<?php


namespace Cap\Controllers;

require_once dirname(__FILE__)."/../libraries/PushMsgLib.php";

class SysController extends BaseController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('mail_lib', function() {
            return new \Cap\Libraries\MailLib();
        }, true);
        $this->_di->set('push_lib', function() {
            return new \PushLib();
        }, true);
    }

    public function clearCacheAction() {
        apc_clear_cache('user');
    }

    public function sendMailAction() {
        if (($r = $this->checkParameter(['mail_text', 'targets', 'from_name'])) !== true) {
            return $r; 
        }
        $obj = $this->request_data;
        $targets = $obj['targets'];
        $text = $obj['mail_text'];
        $from_name = $obj['from_name'];
        if (isset($obj['attachment'])) {
            $attachment = $obj['attachment'];
        } else {
            $attachment = false;
        }
        $from_id = 0;
        $mail_lib = $this->_di->getShared('mail_lib');
        $mail_lib->sendMail($from_id, $targets, $text, $attachment, $from_name);
        $res = array('code'=> 200);
        return json_encode($res);
    }

    public function pushMsgAction() {
        if (($r = $this->checkParameter(['text'/*, 'targets'*/, 'from_name'])) !== true) {
            return $r; 
        }
        $obj = $this->request_data;
        $targets = $obj['targets'];
        $text = $obj['text'];
        $from_id = 0;
        $from_name = $obj['from_name'];
        $push_lib = $this->_di->getShared('push_lib');
        $msg = array(
            'type'=> 6,
            'from'=> $from_id,
            'from_name'=> $from_name,
            'to'=> 298,
            'text'=> $text
        );
        $push_lib->pushMsg($msg);
        $res = array('code'=> 200);
        return json_encode($res);
    }
}
