<?php

namespace Cap\Controllers;


require_once dirname(__FILE__)."/../libraries/PushMsgLib.php";

class MsgpushController extends BaseController {

    public static $WMSG_LAST_SENT = "t_wmsg_sent:%s";  // user last sent world msg time, placeholder: uid
    public static $WORLD_MSG_SEND_LIMIT = 5;      // (s)  minimum broadcast msg send interval


    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('push_lib', function() {
            return new \PushLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('msg_lib', function() {
            return new \Cap\Libraries\MsgLib();
        }, true);
    }

    public function pushAction() {
        $data = $this->request->getPost('data');
        $obj = json_decode($data, true);
        
        if (!$obj || !is_array($obj)) {
            return json_encode(array('code'=>'400', 'desc'=>'data required or invalid json format'));
        }
        if (!isset($obj['from']) || !isset($obj['to']) || !isset($obj['type'])) {
            return json_encode(array('code'=>'400', 'desc'=>'miss parameters'));
        }
        $push_lib = $this->_di->getShared('push_lib');
        $r = $push_lib->pushMsg($obj);
        if ($r) {
            $res = array('code'=>200);
        } else {
            $res = array('code'=>500, 'msg'=> 'error in add push task to queue');
        }
        return json_encode($res);
    }

    public function broadCastAction() {
        if (!($role_id=$this->session->get('role_id'))) {
            return json_encode(array('code'=> 401, 'msg'=> 'unauthorized operation'));
        }
        if (($r = $this->checkParameter(['text'])) !== true) {
            return $r; 
        }
        $msg_lib = $this->_di->getShared('msg_lib');
        $obj = $this->request_data;
        $res = $msg_lib->broadcast($role_id, $obj['text']);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function sendAction() {
        if (!($role_id=$this->session->get('role_id'))) {
            return json_encode(array('code'=> 401, 'msg'=> 'unauthorized operation'));
        }
        if (($r = $this->checkParameter(['text', 'to', 'type'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $msg_lib = $this->_di->getShared('msg_lib');
        $res = $msg_lib->sendMsg($role_id, $obj['to'], $obj['type'], $obj['text']);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function queryAction() {
        if (!($role_id=$this->session->get('role_id'))) {
            return json_encode(array('code'=> 401, 'msg'=> 'unauthorized operation'));
        }
        $msg_lib = $this->_di->getShared('msg_lib');
        $obj = $this->request_data;
        $stat = $msg_lib->getMsgStat($role_id);
        if (isset($obj['since'])) {
            $since = $obj['since'];
        } else if (isset($stat['unreadsince'])) {
            $since = intval($stat['unreadsince']);
        } else {
            $since = 0;
        }
        $msgs = $msg_lib->getInboxMsgs($role_id, $since);
        $res = array('code'=>200, 'stat'=>$stat, 'msgs'=>$msgs);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

}
