<?php

namespace Cap\Controllers;

class LoginbonusController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('loginbonus_lib', function() {
            return new \Cap\Libraries\LoginBonusLib();
        }, true);

    }

    public function listAction() {
        $bonus_lib = $this->_di->getShared('loginbonus_lib');
        $role_id = $this->session->get('role_id');
        $records = $bonus_lib->getRecords($role_id);
        $res = array('code'=> 200, 'records'=> $records);
        $data = $this->request->getPost('data');
        if ($data) {
            $obj = json_decode($data, true);
            if (isset($obj['cfg'])) {
                $res['cfg'] = $bonus_lib->getBonusConfig();
            }
        }
        return json_encode($res, JSON_FORCE_OBJECT|JSON_NUMERIC_CHECK);
    }

    public function acceptAction() {
        $bonus_lib = $this->_di->getShared('loginbonus_lib');
        $role_id = $this->session->get('role_id');
        $res = $bonus_lib->acceptDayBonus($role_id);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function remedyAction() {
        if (($r=$this->checkParameter(['date'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $date = strptime($obj['date'], '%Y-%m-%d');
        if ($date==false) {
            return json_encode(array('code'=>400, 'msg'=> 'bad date format'));
        }
        $bonus_lib = $this->_di->getShared('loginbonus_lib');
        $role_id = $this->session->get('role_id');
        $res = $bonus_lib->acceptDayBonus($role_id, intval($date['tm_mday']), true);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function accuAcceptAction() {
        if (($r=$this->checkParameter(['accu_value'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $accu = intval($obj['accu_value']);
        $bonus_lib = $this->_di->getShared('loginbonus_lib');
        $role_id = $this->session->get('role_id');
        $res = $bonus_lib->acceptAccuBonus($role_id, $accu);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }
}

// end of file
