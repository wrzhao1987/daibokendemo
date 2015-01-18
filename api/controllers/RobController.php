<?php

namespace Cap\Controllers;


class RobController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();

        $this->_di->set('rob_lib', function() {
            return new \Cap\Libraries\RobLib();
        }, true);
        $this->_di->set('card_lib', function() {
            return new \Cap\Libraries\CardLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
        $this->_di->set('tech_lib', function() {
            return new \Cap\Libraries\TechLib();
        }, true);
    }

    public function itemlistAction() {
        $rob_lib = $this->_di->getShared('rob_lib');
        $role_id = $this->session->get('role_id');
        $res = array(
            'code'=> 200,
            'items'=> array('dragonball_fragment'),
        );
        return json_encode($res);
    }

    public function searchAction() {
        $rob_lib = $this->_di->getShared('rob_lib');
        $data = $this->request->getPost('data');
        $obj = json_decode($data, true);
        if (!$obj) {
            return json_encode(array('code'=>'400', 'desc'=>'data required'));
        }
        if (!isset($obj['item']) || !is_array($obj['item']) 
            || !isset($obj['item']['item_id']) || !isset($obj['item']['sub_id'])) {
            return json_encode(array('code'=>'400', 'desc'=>'param missed or invalid'));
        }
        $role_id = $this->session->get('role_id');
        $item = $obj['item'];

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $energy = $user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_ROB_ENERGY];
        $users = $rob_lib->getOpponents($role_id, $item, 5);
        $res = array(
            'code'=> 200,
            'rob_energy'=> $energy,
            'users'=> $users,
        );
        if (isset($obj['protect_status'])) {
            $res['protect_ttl'] = intval($rob_lib->getRobExempt($role_id));
            $item_lib = $this->_di->getShared('item_lib');
            $items = $item_lib->listItem($role_id, true);
            $res['protect_token'] = $item_lib->getItemCount($role_id, ITEM_TYPE_AVOID_FIGHT_TOKEN, 1);
        }
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function attackAction() {
        $data = $this->request->getPost('data');
        $obj = json_decode($data, true);
        if (!$obj) {
            return json_encode(array('code'=>'400', 'desc'=>'data required'));
        }
        if (!isset($obj['opponent']) || !isset($obj['item']) 
            || !is_array($obj['item']) || !isset($obj['item']['item_id']) 
            || !isset($obj['item']['sub_id'])) {
            return json_encode(array('code'=>'400', 'desc'=>'param missed or invalid'));
        }
        $role_id = $this->session->get('role_id');
        $opponent = $obj['opponent'];
        $item = $obj['item'];

        $rob_lib = $this->_di->getShared('rob_lib');
        $res = $rob_lib->attack($role_id, $opponent, $item);
        if ($res['code'] != 200) {
            return json_encode($res);
        }

        $card_lib = $this->_di->getShared('card_lib');
        if (isset($obj['get_deck'])) {
            $deck_info = $card_lib->getDeckCard($role_id);
            $res['deck'] = $deck_info;
        }

        // done: open target deck info
        syslog(LOG_DEBUG, "get opponent($opponent) deck info");
        $opponent_deck_info = $card_lib->getDeckCard($opponent);
        $res['target_deck'] = $opponent_deck_info;

        # get tech info
        $tech_lib = $this->_di->getShared('tech_lib');
        $r = $tech_lib->getUserTechs($opponent);
        $res['tech'] = $r;
        
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function commitAction() {
        $data = $this->request->getPost('data');
        $obj = json_decode($data, true);
        if (!$obj) {
            return json_encode(array('code'=>'400', 'desc'=>'data required'));
        }
        if (!isset($obj['rob_id']) || !isset($obj['result']) || !isset($obj['info'])) {
            return json_encode(array('code'=>'400', 'desc'=>'param missed or invalid'));
        }

        $rob_id = $obj['rob_id'];
        $result = $obj['result'];
        $info = $obj['info'];
        $role_id = $this->session->get('role_id');

        $rob_lib = $this->_di->getShared('rob_lib');
        $res = $rob_lib->commitAttack($role_id, $rob_id, $result, $info);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function noExemptAction()
    {
        $rob_lib = $this->_di->getShared('rob_lib');
        $rob_lib->cancelRobExempt($this->role_id);
        return json_encode(['code' => 200, 'msg' => 'OK'], JSON_NUMERIC_CHECK);
    }

    public function historyAction() {
        $rob_lib = $this->_di->getShared('rob_lib');
        $role_id = $this->session->get('role_id');
        $records = $rob_lib->getHistory($role_id);
        return json_encode(['code' => 200, 'history' => $records], JSON_NUMERIC_CHECK);
    }
}

// end of file
