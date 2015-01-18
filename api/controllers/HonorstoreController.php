<?php

namespace Cap\Controllers;

class HonorstoreController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();

        $this->_di->set('store_lib', function() {
            return new \Cap\Libraries\StoreLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
    }


    public function recordsAction() {
        $store_lib = $this->_di->getShared('store_lib');
        $role_id = $this->session->get('role_id');

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        if (!$user) {
            $res = array('code'=> 500, 'msg'=> 'user not found');
            return json_encode($res);
        }
        $balance = 0;
        if (isset($user['honor'])) {
            $balance = $user['honor'];
        }
        $res = array('code'=>200, 'balance'=>$balance);

        $daily_records = $store_lib->getDailyPurchaseRecords($role_id);
        if ($daily_records) {
            $res['daily'] = $daily_records;
        }
        $total_records = $store_lib->getTotalPurchaseRecords($role_id);
        if ($total_records) {
            $res['total'] = $total_records;
        }
        return json_encode($res);
    }

    public function buyAction() {
        $data = $this->request->getPost('data');
        if (!$data) {
            return json_encode(array('code'=> 400, 'msg'=> 'data required'));
        }
        $obj = json_decode($data, true);
        if (!isset($obj['commodity_id'])) {
            return json_encode(array('code'=> 400, 'msg'=> 'miss parameters'));
        }
        $commodity_id = $obj['commodity_id'];
        if (isset($obj['count'])) {
            $count = intval($obj['count']);
        } else {
            $count = 1;
        }
        if (isset($obj['store_id'])) {
            $store_id = $obj['store_id'];
        } else {
            $store_id = 1;
        }

        $store_lib = $this->_di->getShared('store_lib');
        $role_id = $this->session->get('role_id');
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);

        $res = $store_lib->buy($role_id, $commodity_id, $count, $store_id);
        return json_encode($res);
    }

}
