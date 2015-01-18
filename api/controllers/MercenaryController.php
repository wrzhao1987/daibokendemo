<?php

namespace Cap\Controllers;

class MercenaryController extends AuthorizedController {
    
    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('user_lib', new \Cap\Libraries\UserLib(), true);
    }

    public function acceptAction() {
        $role_id = $this->session->get('role_id');
        $user_lib = $this->_di->getShared('user_lib');
        $coin = $user_lib->applyMercenaryFee($role_id);
        $res = array('code'=>200, 'coin'=>$coin);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function queryAction() {
        $role_id = $this->session->get('role_id');
        $user_lib = $this->_di->getShared('user_lib');
        $records = $user_lib->getMercenaryRecords($role_id);
        $user = $user_lib->getUser($role_id);
        if (isset($user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_FEE])) {
            $fee = $user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_FEE];
        } else {
            $fee = 0;
        }
        $res = array('code'=>200, 'records'=>$records, 'fee'=>$fee);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }
}

// End of File

