<?php

namespace Cap\Controllers;

use Cap\Libraries\ChargeLib;

class VipController extends AuthorizedController {

    private static $SOURCE_TBT = 2; // 同步推充值渠道

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('charge_lib', function() {
            return new \Cap\Libraries\ChargeLib();
        }, true);
    }

    public function recordsAction() {
        $role_id = $this->session->get('role_id');
        $charge_lib = $this->_di->getShared('charge_lib');
        $records = $charge_lib->getRecords($role_id);
        $month_card_ttl = $charge_lib->getMonthCardTTL($role_id);
        if ($month_card_ttl > 0) {
            $month_card_ttl += time();
        }
        $res = array('code'=>200, 'records'=>$records, 'month_ttl' => $month_card_ttl);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function chargeAction() {
        if (($r=$this->checkParameter(array('package_id', 'order_id')))!==true) {
            return $r;
        }
        $obj = $this->request_data;
        $package_id = $obj['package_id'];
        $order_id = $obj['order_id'];
        $charge_lib = $this->_di->getShared('charge_lib');
        $role_id = $this->session->get('role_id');
        $res = $charge_lib->charge($role_id, $package_id, $order_id);
        return json_encode($res);
    }

    public function genOrderAction()
    {
        if (($r=$this->checkParameter(array('package_id', 'source')))!==true) {
            return $r;
        }
        $conf = $this->getDI()->getShared('config');
        $package_id = $this->request_data['package_id'];
        $source = $this->request_data['source'];
        $charge_lib = $this->getDI()->getShared('charge_lib');
        $order_id = $charge_lib->genOrder($source, $conf['server_id'], $this->role_id, $package_id);

        if ($order_id) {
            $ret =  ['code' => 200, 'msg' => 'OK', 'order_id' => $order_id];
        } else {
            $ret =  ['code' => 500, 'msg' => '生成订单失败', 'order_id' => 0];
        }
		return json_encode($ret);
    }

    public function cancelOrderAction()
    {
        if (($r=$this->checkParameter(array('order_id')))!==true) {
            return $r;
        }
        $charge_lib = $this->getDI()->getShared('charge_lib');
        $order_id = $this->request_data['order_id'];
        $charge_lib->updateOrderStatus($order_id, ChargeLib::$ORDER_STATUS_CANCELD);

        return json_encode(['code' => 200, 'msg' => 'OK'], JSON_NUMERIC_CHECK);
    }
}

// end of file
