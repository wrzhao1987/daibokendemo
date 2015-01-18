<?php

namespace Cap\Libraries;
require_once "PushMsgLib.php";

class MailLib extends BaseLib {

    public static $MAIL_EXPIRE_TIME = 1296000; //15*24*3600;

    public function __construct() {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('mail_model', function() {
            return new \Cap\Models\db\UserMailModel();
        }, true);
        $this->_di->set('user_model', function() {
            return new \Cap\Models\db\UserModel();
        }, true);
        $this->_di->set('push_lib', function() {
            return new \PushLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
    }

    public function getUserMail($role_id) {
        $mail_model = $this->_di->getShared('mail_model');
        $start_ts = time() - self::$MAIL_EXPIRE_TIME;
        $start_date = date("Y-m-d H:M:S", $start_ts);
        $mails = $mail_model->getUserMails($role_id, $start_date);
        foreach ($mails as &$mail) {
            unset($mail['user_id']);
            unset($mail['text_id']);
            unset($mail['updated_at']);
            unset($mail['type']);
        }
        # clear change flag
        $user_lib = $this->_di->getShared('user_lib');
        $user_lib->clearNewField($role_id, 'mail');

        return $mails;
    }

    public function acceptMail($role_id, $mail_id) {
        syslog(LOG_DEBUG, "accept mail $mail_id");
        $mail_model = $this->_di->getShared('mail_model');
        $ret = $mail_model->acceptMail($role_id, $mail_id);
        $item_lib = $this->_di->getShared('item_lib');
        if ($ret['code']==200) {
            #  update status to readed, give items to user if exists
            syslog(LOG_DEBUG, "accept Attachment($role_id, $mail_id) give ".json_encode($ret['attachment']));
            if ($ret['attachment']) {
				$ret['result'] = [];
                foreach ($ret['attachment'] as $item) {
                    if ($r = $item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count'])) {
                        if (is_array($r)) {
                            if (isset ($r[0]['pk_id'])) {
                                $ret['result'] = array_merge($ret['result'], $r);
                            } else if (isset ($r['pk_id'])) {
                                $ret['result'][] = $r;
                            }
                        }
                    } else {
                        syslog(LOG_ERR, "fail to addItem($role_id, $item[item_id], $item[sub_id], $item[count])");
                    }
                }
            }
        }
        return $ret;
    }

    public function sendMail($role_id, $targets, $content, $attachment, $from_name) {
        syslog(LOG_INFO, microtime(true).": sendMail($role_id, ..., $content, ".json_encode($attachment).")");
        if (in_array(0, $targets)) {
            # broadcast, get all user_ids
            $user_model = $this->_di->getShared('user_model');
            $targets = $user_model->getAllUserIds();
            syslog(LOG_INFO, "broadcast mail to ".count($targets)." users");
        }
        if (empty($targets)) {
            return;
        }
        $mail_model = $this->_di->getShared('mail_model');
        $r = $mail_model->newUserMail($role_id, $targets, $content, $attachment, $from_name);
        syslog(LOG_DEBUG, microtime(true).": sent $r mails");
        # set user change flag
        $user_lib = $this->_di->getShared('user_lib');
        $push_lib = $this->_di->getShared('push_lib');
        foreach ($targets as $target) {
            $user_lib->setNewField($target, 'mail');
            # push notify
            $msg = array('type'=>\PushLib::$MSG_TYPE_MAIL, 'from'=>0,
                'to'=>$target, 'ts'=>time(), 'changes'=>array('mail'=>1));
            $push_lib->pushMsg($msg);
        }

    }
}

// end of file
