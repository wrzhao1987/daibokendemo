<?php

namespace Cap\Controllers;

class UserController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('user_lib', function () {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('card_lib', function () {
            return new \Cap\Libraries\CardLib();
        }, true);
    }


    public function infoAction() {
        $data = $this->request->getPost('data');
        if ($data) {
            $obj = json_decode($data, True);
            if (isset($obj['users'])) {
                $user_ids = $obj['users'];
            }
        }
        if (!isset($user_ids)) {
            $user_ids = array($this->session->get('role_id'));
        }
        $user_lib = $this->_di->getShared('user_lib');
        
        $users = array();
        $card_lib = $this->_di->getShared('card_lib');
        foreach ($user_ids as $uid) {
            $user_info = $user_lib->getUser($uid);
            if ($user_info) {
                $user_info['deck'] = $card_lib->getDeckCard($uid);
            }
            $users[$uid] = $user_info;
        }
        $res = array(
            'code'=> 200,
            'users'=> $users,
        );
        return json_encode($res, JSON_FORCE_OBJECT|JSON_NUMERIC_CHECK);
    }

    public function overviewAction() {
        if (($r = $this->checkparameter(['users'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;

        $uids = $obj['users'];
        $users = array();
        $user_lib = $this->_di->getShared('user_lib');
        $card_lib = $this->_di->getShared('card_lib');
        foreach ($uids as $uid) {
            $user = $user_lib->getUser($uid);
            if ($user) {
                $deck_info = $card_lib->getDeckCardsOverview($uid);
                $users[strval($uid)] = array(
                    'name'=> $user['name'],
                    'level'=> $user['level'],
                    'deck'=> $deck_info
                );
            } else {
                $users[strval($uid)] = false;
            }
        }
        $res = array(
            'code'=> 200,
            'users'=> $users
        );
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function setfieldAction() {
        if (($r = $this->checkparameter(['field', 'value'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $role_id = $this->session->get('role_id');
        $user_lib = $this->_di->getShared('user_lib');
        $res = $user_lib->setUserData($role_id, $obj['field'], $obj['value']);
        return json_encode($res);
    }
}

