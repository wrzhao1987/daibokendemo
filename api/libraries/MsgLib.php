<?php

namespace Cap\Libraries;

require_once("PushMsgLib.php");
use \Cap\Libraries\UserLib;

class MsgLib extends BaseLib {

    public static $WMSG_LAST_SENT = "t_wmsg_sent:%s";  // user last sent world msg time, placeholder: uid
    public static $CHAT_STAT_KEY = "chat:%s";    // placeholder: user_id
    public static $WORLD_MSG_SEND_LIMIT = 5;
    public static $TARGET_TYPE_ALL = 1;
    public static $TARGET_TYPE_GUILD = 2;
    public static $TARGET_TYPE_PRIVATE = 3;

    public function __construct() {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('push_lib', new \PushLib());
        $this->_di->set('msg_model', function() {
            return new \Cap\Models\Db\MsgModel();
        });
        $this->_di->set('guild_lib', function() {
            return new \Cap\Libraries\GuildLib();
        });
        $this->_di->set('guildmember_model', function() {
            return new \Cap\Models\Db\GuildMemberModel();
        });
    }

    public function broadcast($role_id, $text) {
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $data = array(
            'type'=> 1,
            'from'=> $role_id,
            'from_name'=> $user[UserLib::$USER_PROF_FIELD_NAME],
            'level'=> $user[UserLib::$USER_PROF_FIELD_LEVEL],
            'to'=> 0,
            'content'=> $text,
            'ts'=> time(),
        );
        $rds = $this->_di->getShared('redis');
        # check msg send frequency limit
        $wmsg_sent_key = sprintf(self::$WMSG_LAST_SENT, $role_id);
        $last_sent = $rds->get($wmsg_sent_key);
        $now = time();
        if ($now - $last_sent < self::$WORLD_MSG_SEND_LIMIT) {
            return json_encode(array('code'=>403, 'msg'=> 'wmsg rate limit reached'));
        }
        # check free broadcast opportunities, cost item speaker if available
        $stat_key = sprintf(self::$CHAT_STAT_KEY, $role_id);
        $bc = $rds->hincrBy($stat_key, 'broadcast', 1);
        if ($bc==1) {
            $rds->expireAt($stat_key, self::getDefaultExpire());
        }
        $vip = $user[UserLib::$USER_PROF_FIELD_VIP];
        $vipcfgs = self::getGameConfig('user_vip');
        $free_times = $vipcfgs[$vip]['free_chat_broadcast'];
        if ($bc > $free_times) {
            // cost
            syslog(LOG_DEBUG, "used up free broadcast, cost xxx to speak");
            // TODO cost item instead of forbidden
            $res = array('code'=>403, 'msg'=> 'used all free chat times');
            return $res;
        }
        // record to database
        $msg_model = $this->_di->getShared('msg_model');
        $r = $msg_model->newMsg($role_id, array(0), $text, $user[UserLib::$USER_PROF_FIELD_NAME]);

        $push_lib = $this->_di->getShared('push_lib');
        $r = $push_lib->pushMsg($data);
        if ($r) {
            $res = array('code'=>200, 'stat'=>array('broadcast'=>$bc));
            # set msg send last time
            $rds->set($wmsg_sent_key, $now);
        } else {
            $res = array('code'=>500, 'msg'=> 'error in add push task to queue');
        }
        return $res;
    }

    /*
     * return msg count sent today
     */
    public function getMsgStat($role_id) {
        $rds = $this->_di->getShared('redis');
        $stat_key = sprintf(self::$CHAT_STAT_KEY, $role_id);
        $r = $rds->hgetall($stat_key);
        return $r;
    }

    public function sendMsg($role_id, $to, $type, $content) {
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $guild_lib = $this->_di->getShared('guild_lib');
        $ginfo = $guild_lib->status($role_id);
        $msg_model = $this->_di->getShared('msg_model');

        $to_uids = array();
        if ($type == self::$TARGET_TYPE_GUILD) {
            if (!isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
                syslog(LOG_ERROR, "sendMsg guild, but no guild");
                return array('code'=> 403, 'msg'=> 'no guild');
            }
            $to = -$ginfo[GuildLib::$STATUS_FIELD_GID];
            $gmodel = $this->_di->getShared('guildmember_model');
            $gmembers = $gmodel->getMembers(-$to);
            $to_uids = array_column($gmembers, 'uid');
        } else if ($type == self::$TARGET_TYPE_ALL) {
            $to = 0;
            $to_uids = array($to);
        } else if ($type == self::$TARGET_TYPE_PRIVATE) {
            $to_uids = array($to, $role_id);
            $to_user = $user_lib->getUser($to);
            $to_name = $to_user[UserLib::$USER_PROF_FIELD_NAME];
            $dest = $to;
        } else {
            syslog(LOG_DEBUG, "unsupported msg type $type");
            return array('code'=>405, 'msg'=>"unsupported msg type");
        }

        $r = $msg_model->newMsg($role_id, array($to), $content, $user[UserLib::$USER_PROF_FIELD_NAME]);

        // push destinations
        $push_lib = $this->_di->getShared('push_lib');
        $ts = time();
        foreach ($to_uids as $uid) {
            syslog(LOG_DEBUG, "push msg $role_id=>$uid");
            $data = array(
                'type'=> 1,
                'from'=> $role_id,
                'from_name'=> $user[UserLib::$USER_PROF_FIELD_NAME],
                'level'=> $user[UserLib::$USER_PROF_FIELD_LEVEL],
                'to'=> $uid,
                'content'=> $content,
                'ts'=> $ts,
                'sub_type'=> $type,
            );
            if (isset($to_name)) {
                $data['to_name'] = $to_name;
                $data['dest'] = $dest;
            }
            $push_lib->pushMsg($data);
        }

        return array('code'=>200, 'msg'=>'OK');
    }

    /*
     * get pending msgs in inbox, include guild and private
     */
    public function getInboxMsgs($role_id, $since) {
        $msg_model = $this->_di->getShared('msg_model');
        $start_date = date("Y-m-d H:i:s", $since);
        // private msgs
        $msgs = $msg_model->getMsgs($role_id, $start_date);

        // guild msgs
        $guild_lib = $this->_di->getShared('guild_lib');
        $ginfo = $guild_lib->status($role_id);
        $gmsgs = array();
        if (isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
            $gid = $ginfo[GuildLib::$STATUS_FIELD_GID];
            $gmsgs = $msg_model->getMsgsByTarget(-$gid, $start_date);
        }

        $overall_msgs = array_merge($msgs, $gmsgs);
        // user info
        $users = array();
        foreach ($overall_msgs as $msg) {
            $users[$msg['from_uid']] = true;
            if ($msg['to']>0) {    
                $users[$msg['to']] = true;
            }
        }
        $user_lib = $this->_di->getShared('user_lib');
        foreach ($users as $uid=>$v) {
            $users[$uid] = $user_lib->getUser($uid);
        }

        foreach ($overall_msgs as &$msg) {
            // format adaption
            if ($msg['to']<0) {
                $msg['to'] = -$msg['to'];
                $msg['sub_type'] = 2;
            } else if ($msg['to']==0) {
                $msg['sub_type'] = 1;
            } else {
                $msg['sub_type'] = 3;
            }
            $msg['ts'] = strtotime($msg['created_at']);
            unset($msg['created_at']);
            $msg['from'] = $msg['from_uid'];
            unset($msg['from_uid']);
            $msg['content'] = $msg['text'];
            unset($msg['text']);
            $msg['from_name'] = $users[$msg['from']][UserLib::$USER_PROF_FIELD_NAME];
            if ($msg['sub_type']==3 && $msg['to']!=$role_id) {
                $msg['to_name'] = $users[$msg['to']][UserLib::$USER_PROF_FIELD_NAME];
                $msg['level'] = $users[$msg['to']][UserLib::$USER_PROF_FIELD_LEVEL];
				$msg['dest'] = $msg['to'];
            } else {
                $msg['level'] = $users[$msg['from']][UserLib::$USER_PROF_FIELD_LEVEL];
            }
        }

        // sort
        function sort_func($a, $b) {
        }
        usort($overall_msgs, function($a, $b){
            return $a['ts'] > $b['ts'];
        });
        
        return $overall_msgs;
    }
}
