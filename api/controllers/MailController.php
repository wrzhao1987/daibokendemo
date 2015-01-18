<?php

namespace Cap\Controllers;
use \Cap\Libraries\UserLib;

class MailController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('mail_lib', function() {
            return new \Cap\Libraries\MailLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
    }

    public function listAction() {
        $role_id = $this->session->get('role_id');
        $mail_lib = $this->_di->getShared('mail_lib');
        $mails = $mail_lib->getUserMail($role_id);
        $res = array('code'=> 200, 'mails'=> array_values($mails));
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function acceptAction() {
        if (($r = $this->checkParameter(['mail_id'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $mail_id = $obj['mail_id'];

        $role_id = $this->session->get('role_id');
        $mail_lib = $this->_di->getShared('mail_lib');
        $res = $mail_lib->acceptMail($role_id, $mail_id);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function sendAction() {
        if (($r = $this->checkParameter(['mail_text', 'targets'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $targets = $obj['targets'];
        if (count($targets) > 1 || in_array(0, $targets)) {
            $res = array('code'=> 403, 'msg'=> 'invalid target for normal user');
            return json_encode($res);
        }
        $text = $obj['mail_text'];
        if (isset($obj['attachment'])) {
            $attachment = $obj['attachment'];
        } else {
            $attachment = false;
        }
        $role_id = $this->session->get('role_id');

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $from_name = $user[UserLib::$USER_PROF_FIELD_NAME];

        $mail_lib = $this->_di->getShared('mail_lib');
        $mail_lib->sendMail($role_id, $targets, $text, $attachment, $from_name);
        $res = array('code'=> 200);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

}
