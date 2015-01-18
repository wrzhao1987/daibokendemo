<?php

namespace Cap\Libraries;

require_once "PushMsgLib.php";
use \Cap\Libraries\UserLib;

class FriendLib extends BaseLib {

    public static $FRIENDS_KEY = "frnds:%s";             // placeholder: uid
    public static $FRIENDS_GIVEN_KEY = "frnd_given:%s";  // daily given energy to, placeholder: uid
    public static $FRIENDS_RECVD_KEY = "frnd_recvd:%s";  // daily receive energy from, placeholder: uid
    public static $FRIENDS_ACCPT_KEY = "frnd_accpt:%s";  // daily accepted energy from, placeholder: uid
    public static $PENDING_IN_REQ_KEY = "frnd_req_in:%s";  // pending sent friend request,  placeholder: uid
    public static $PENDING_OUT_REQ_KEY = "frnd_req_out:%s";  // pending received friend request,  placeholder: uid
    //public static $FRIEND_PROF_KEY = "frd:%s";           // user friend related profile,  placeholder: uid

    public static $FRIENDS_NUM_LIMIT = 100;
    public static $FRIENDS_REQ_LIMIT = 100;
    public static $FRIENDS_ACCEPT_ENERGY_LIMIT = 10;
    public static $MISSION_ENERGY_PER_GIVE = 2;

    public function __construct() {
        parent::__construct();

        $this->_di->set('push_lib', function() {
            return new \PushLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('card_lib', function() {
            return new \Cap\Libraries\CardLib();
        }, true);
    }

    /*
     * atomic opertaion of add $v1 to $s1 and add $v2 to $s2
     */
    private function atomicSadd($s1, $v1, $s2, $v2) {
        $rds = $this->_di->getShared('redis');
        return $rds->eval("
            redis.call('sadd', KEYS[1], ARGV[1]);
            return redis.call('sadd', KEYS[2], ARGV[2]);
            ", array($s1, $s2, $v1, $v2), 2);
    }

    private function atomicSrem($s1, $v1, $s2, $v2) {
        $rds = $this->_di->getShared('redis');
        return $rds->eval("
            redis.call('srem', KEYS[1], ARGV[1]);
            return redis.call('srem', KEYS[2], ARGV[2]);
            ", array($s1, $s2, $v1, $v2), 2);
    }

    private function atomicZadd($s1, $v1, $s2, $v2) {
        $t = time();
        $rds = $this->_di->getShared('redis');
        return $rds->eval("
            redis.call('zadd', KEYS[1], ARGV[3], ARGV[1]);
            return redis.call('zadd', KEYS[2], ARGV[3], ARGV[2]);
            ", array($s1, $s2, $v1, $v2, $t), 2);
    }
    private function atomicZrem($s1, $v1, $s2, $v2) {
        $t = time();
        $rds = $this->_di->getShared('redis');
        return $rds->eval("
            redis.call('zrem', KEYS[1], ARGV[1], ARGV[3]);
            return redis.call('zrem', KEYS[2], ARGV[2], ARGV[3]);
            ", array($s1, $s2, $v1, $v2, $t), 2);
    }

    public function reqAdd($from, $to) {
        # self check
        if ($from == $to) {
            return array('code'=> 403, 'msg'=> '不能添加自己');
        }
        $rds = $this->_di->getShared('redis');
        $out_key = sprintf(self::$PENDING_OUT_REQ_KEY, $from);
        $in_key = sprintf(self::$PENDING_IN_REQ_KEY, $to);
        # friend/request limit check
        $from_frnd_key = sprintf(self::$FRIENDS_KEY, $from);
        $from_num = $rds->scard($from_frnd_key);
        if ($from_num > self::$FRIENDS_NUM_LIMIT) {
            return array('code'=> 403, 'msg'=> '你的好友数量已达到上限.');
        }
        $to_frnd_key = sprintf(self::$FRIENDS_KEY, $to);
        $to_num = $rds->scard($to_frnd_key);
        if ($to_num > self::$FRIENDS_NUM_LIMIT) {
            return array('code'=> 403, 'msg'=> '对方好友数量已达上限.');
        }

        # existence check
        if ($rds->sismember($from_frnd_key, $to)) {
            return array('code'=> 201, 'msg'=> '已经是好友了');
        }

        # ensure atomic operation
        $this->atomicZadd($out_key, $to, $in_key, $from);  // note: little chance to exceed friend num limit
        return array('code'=>200);
    }

    public function reqCancel($from, $to) {
        $rds = $this->_di->getShared('redis');
        $out_key = sprintf(self::$PENDING_OUT_REQ_KEY, $from);
        $in_key = sprintf(self::$PENDING_IN_REQ_KEY, $to);
        # done: ensure atomic operation
        # skip: existence check
        $this->atomicZrem($out_key, $to, $in_key, $from);
        return array('code'=> 200);
    }

    public function reqApprove($role_id, $requester) {
        syslog(LOG_DEBUG, "$role_id approve friend request from $requester");
        $rds = $this->_di->getShared('redis');
        $req_out_key = sprintf(self::$PENDING_OUT_REQ_KEY, $requester);
        $req_in_key = sprintf(self::$PENDING_IN_REQ_KEY, $role_id);
        # existence check
        # done: ensure atomic operation
        $r = $this->atomicZrem($req_out_key, $role_id, $req_in_key, $requester);
        if (!$r) {
            return array('code'=> 404, 'msg'=> 'request not found');
        }

        $role_frnd_key = sprintf(self::$FRIENDS_KEY, $role_id);
        $requester_frnd_key = sprintf(self::$FRIENDS_KEY, $requester);
        # friend/request limit check
        $request_frd_num = $rds->scard($requester_frnd_key);
        if ($request_frd_num > self::$FRIENDS_NUM_LIMIT) {
            return array('code'=> 403, 'msg'=> 'requester friend limit reached');
        }
        $role_frnd_num = $rds->scard($role_frnd_key);
        if ($role_frnd_num > self::$FRIENDS_NUM_LIMIT) {
            return array('code'=> 403, 'msg'=> 'your friend limit reached');
        }

        # add to eachother's friend list
        $r = $this->atomicSadd($role_frnd_key, $requester, $requester_frnd_key, $role_id);
        if (!$r) {
            return array('code'=> 201, 'msg'=> '已经是朋友了');
        } else {
            # push msg to notify role and requester
            //$this->pushMsgTo($role_id, $requester, \PushLib::$MSG_TYPE_FRND_NEW, "$role_id have approved your friend request");
            return array('code'=> 200);
        }
    }

    public function reqDecline($role_id, $requester) {
        syslog(LOG_DEBUG, "$role_id decline friend request from $requester");
        $rds = $this->_di->getShared('redis');
        $out_key = sprintf(self::$PENDING_OUT_REQ_KEY, $requester);
        $in_key = sprintf(self::$PENDING_IN_REQ_KEY, $role_id);
        # ensure atomic operation
        $this->atomicZrem($out_key, $role_id, $in_key, $requester);
        # push msg to notify requester
        //$this->pushMsgTo($role_id, $requester, \PushLib::$MSG_TYPE_FRND_DECLINE, "$role_id have declined your friend request");
        return array('code'=> 200);
    }

    public function getFriends($role_id, $pending = false) {
        $rds = $this->_di->getShared('redis');
        if ($pending) {
            $frnd_key = sprintf(self::$PENDING_IN_REQ_KEY, $role_id);
            $uids = $rds->zrange($frnd_key, 0, -1);
        } else {
            $frnd_key = sprintf(self::$FRIENDS_KEY, $role_id);
            $uids = $rds->smembers($frnd_key);
        }

        $user_lib = $this->_di->getShared('user_lib');
        $users = array();
        foreach ($uids as $uid) {
            $user = $user_lib->getUser($uid);
            if (!$user) {
                syslog(LOG_ERR, "fail to get user for $uid");
                continue;
            }
            # get deck info
            $card_lib = $this->_di->getShared('card_lib');
            $deck_info = $card_lib->getDeckCardsOverview($uid);
            if (count(array_keys($deck_info, 0)) == count($deck_info)) {
                syslog(LOG_ERR, "fail to get deck for $uid");
                continue;
            }
            $res_info = array('id'=>$uid,
                'name'=> $user[UserLib::$USER_PROF_FIELD_NAME],
                'level'=> $user[UserLib::$USER_PROF_FIELD_LEVEL],
                'deck'=> $deck_info
            );
            $users []= $res_info;
        }
        return $users;
    }

    public function getRandFriends($role_id, $num) {
        $rds = $this->_di->getShared('redis');
        $frnd_key = sprintf(self::$FRIENDS_KEY, $role_id);
        $uids = $rds->srandmember($frnd_key, $num);
        return $uids;
    }

    public function delFriend($role_id, $target) {
        syslog(LOG_DEBUG, "delFriend($role_id, $target)");
        $rds = $this->_di->getShared('redis');
        $src_frnd_key = sprintf(self::$FRIENDS_KEY, $role_id);
        $dest_frnd_key = sprintf(self::$FRIENDS_KEY, $target);

        # done: ensure atomic operation
        # done: existence check
        $r = $this->atomicSrem($src_frnd_key, $target, $dest_frnd_key, $role_id);
        # push msg to notify requester
        //$this->pushMsgTo($role_id, $target, \PushLib::$MSG_TYPE_FRND_DEL, "");
        return $r;
    }

    public function getGiftUserList($role_id, $type) {
        $rds = $this->_di->getShared('redis');
        switch($type) {
        case 0:
            $key = sprintf(self::$FRIENDS_GIVEN_KEY, $role_id);
            break;
        case 1:
            $key = sprintf(self::$FRIENDS_RECVD_KEY, $role_id);
            break;
        case 2:
            $key = sprintf(self::$FRIENDS_ACCPT_KEY, $role_id);
            break;
        default;
            break;
        }
        return $rds->smembers($key);
    }


    public function giveEnergy($role_id, $target) {
        syslog(LOG_DEBUG, "giveEnergy($role_id, $target)");
        $rds = $this->_di->getShared('redis');
        $frnd_key = sprintf(self::$FRIENDS_KEY, $role_id);
        if (!$rds->sismember($frnd_key, $target)) {
            syslog(LOG_WARNING, "givenEnergy($role_id, $target), $target not a friend");
            return array('code'=>404, 'msg'=> 'not a friend');
        }
        # skip: ensure atomic operation
        $frnd_given_key = sprintf(self::$FRIENDS_GIVEN_KEY, $role_id);
        $frnd_recvd_key = sprintf(self::$FRIENDS_RECVD_KEY, $target);
        if ($rds->sadd($frnd_given_key, $target)) {
            $rds->sadd($frnd_recvd_key, $role_id);
            $t = strtotime('23:59:60');
            $rds->expireAt($frnd_given_key, $t);
            $rds->expireAt($frnd_recvd_key, $t);
            # push msg to notify role and requester
            $this->pushMsgTo($role_id, $target, \PushLib::$MSG_TYPE_FRND_GIVEENERGY, "");
        } else {
            syslog(LOG_WARNING, "givenEnergy($role_id, $target), already given");
            return array('code'=>403, 'msg'=> 'already given energy');
        }
        return array('code'=>200);
    }

    public function acceptEnergy($role_id, $target, $giveback = false) {
        syslog(LOG_DEBUG, "acceptEnergy($role_id, $target, $giveback)");
        $rds = $this->_di->getShared('redis');
        $frnd_accpt_key = sprintf(self::$FRIENDS_ACCPT_KEY, $role_id);
        $frnd_recvd_key = sprintf(self::$FRIENDS_RECVD_KEY, $role_id);
        # skip: ensure atomic operation
        # accept limit check
        if ($rds->scard($frnd_accpt_key) >= self::$FRIENDS_ACCEPT_ENERGY_LIMIT) {
            return array('code'=> 403, 'msg'=> 'can not accept more energy today');
        }
        # existence check
        if ($rds->sismember($frnd_recvd_key, $target)) {
            if ($rds->sadd($frnd_accpt_key, $target)) {
                $rds->expireAt($frnd_accpt_key, strtotime('23:59:60')); // expire next morning
                # add energy to user
                $user_lib = $this->_di->getShared('user_lib');
                $energy = $user_lib->addMissionEnergy($role_id, self::$MISSION_ENERGY_PER_GIVE);
                # give energy back
                if ($giveback) {
                    $this->giveEnergy($role_id, $target);
                }
                $res = array('code'=> 200, 'energy'=>$energy);
            } else {
                syslog(LOG_WARNING, "$role_id accept energy from friend $target, already accepted");
                $res = array('code'=> 405, 'msg'=> 'already accepted');
            }
        } else {
            syslog(LOG_WARNING, "$role_id accept energy from friend $target, not received");
            $res = array('code'=> 404, 'msg'=> 'not received energy');
        }
        return $res;
    }

    /*
     * push msg to user
     */
    private function pushMsgTo($from, $target, $type, $content) {
        syslog(LOG_DEBUG, "pushMsgTo($from, $target, $type, $content)");
        $push_lib = $this->_di->getShared('push_lib');
        $data = array(
            'type'=> $type,
            'from'=> $from,
            'to'=> $target,
            'ts'=> time(),
            'content'=> $content,
        );
        $push_lib->pushMsg($data);
    }

}

// end of file
