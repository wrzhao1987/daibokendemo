<?php

namespace Cap\Controllers;

class FriendController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('friend_lib', function() {
            return new \Cap\Libraries\FriendLib();
        }, true);
    }

    public function reqAddAction() {
        if (($r = $this->checkParameter(['uid'])) !== true) {
            return $r;
        } 
        $obj = $this->request_data;

        $uid = $obj['uid'];
        $role_id = $this->session->get('role_id');
        $friend_lib = $this->_di->getShared('friend_lib');
        $res = $friend_lib->reqAdd($role_id, $uid);
        return json_encode($res);
    }

    public function reqCancelAction() {
        if (($r = $this->checkParameter(['uid'])) !== true) {
            return $r;
        } 
        $obj = $this->request_data;

        $uid = $obj['uid'];
        $role_id = $this->session->get('role_id');
        $friend_lib = $this->_di->getShared('friend_lib');
        $res = $friend_lib->reqCancel($role_id, $uid);
        return json_encode($res);
    }

    public function reqOpAction() {
        if (($r = $this->checkParameter(['uid', 'approve'])) !== true) {
            return $r;
        } 
        $obj = $this->request_data;
        $uid = $obj['uid'];
        $op = $obj['approve'];
        $role_id = $this->session->get('role_id');
        $friend_lib = $this->_di->getShared('friend_lib');
        if ($op) {
            $res = $friend_lib->reqApprove($role_id, $uid);
        } else {
            $res = $friend_lib->reqDecline($role_id, $uid);
        }
        return json_encode($res);
    }

    public function listAction() {
        $role_id = $this->session->get('role_id');
        $friend_lib = $this->_di->getShared('friend_lib');
        $friends = $friend_lib->getFriends($role_id);
        $pending_friends = $friend_lib->getFriends($role_id, true);
        $gift_sent_list = $friend_lib->getGiftUserList($role_id, 0);
        $gift_recv_list = $friend_lib->getGiftUserList($role_id, 1);
        $gift_accpt_list = $friend_lib->getGiftUserList($role_id, 2);
        $res = array(
            'code'=> 200,
            'friends'=> $friends,
            'incoming_request'=> $pending_friends,
            'gift_sent_list'=> $gift_sent_list,
            'gift_recv_list'=> $gift_recv_list,
            'gift_accpt_list'=> $gift_accpt_list
        );
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function delAction() {
        if (($r = $this->checkParameter(['uid'])) !== true) {
            return $r;
        } 
        $obj = $this->request_data;
        $uid = $obj['uid'];
        $role_id = $this->session->get('role_id');
        $friend_lib = $this->_di->getShared('friend_lib');
        $r = $friend_lib->delFriend($role_id, $uid);
        if ($r)
            $res = array('code'=>200);
        else
            $res = array('code'=>404);
        return json_encode($res);
    }

    public function giveEnergyAction() {
        if (($r = $this->checkParameter(['uid'])) !== true) {
            return $r;
        } 
        $obj = $this->request_data;
        $uid = $obj['uid'];
        $role_id = $this->session->get('role_id');
        $friend_lib = $this->_di->getShared('friend_lib');
        $res = $friend_lib->giveEnergy($role_id, $uid);
        return json_encode($res);
    }

    public function acceptEnergyAction() {
        if (($r = $this->checkParameter(['uid'])) !== true) {
            return $r;
        } 
        $obj = $this->request_data;
        $uid = $obj['uid'];
        $role_id = $this->session->get('role_id');
        $friend_lib = $this->_di->getShared('friend_lib');
        $res = $friend_lib->acceptEnergy($role_id, $uid, isset($obj['give_back']));
        return json_encode($res);
    }

    public function sendMsgAction() {
        if (($r = $this->checkParameter(['msg'])) !== true) {
            return $r;
        } 
        $obj = $this->request_data;
        $msg = $obj['msg']; 
        $target = 0;
    }

}



