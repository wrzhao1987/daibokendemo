<?php

namespace Cap\Controllers;

class StoreController extends AuthorizedController {

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
        $res = array('code'=>200, 'honor'=>$balance, 'gold'=>$user['gold'], 'coin'=>$user['gold']);

        $daily_records = $store_lib->getDailyPurchaseRecords($role_id);
        if ($daily_records) {
            $res['daily'] = $daily_records;
        }
        $total_records = $store_lib->getTotalPurchaseRecords($role_id);
        if ($total_records) {
            $res['total'] = $total_records;
        }
        
        $obj = $this->request_data;
        if(isset($obj['store_id'])) {
    	    $config = \Cap\Libraries\BaseLib::getGameConfig('store_goods');
	        $res['item_store'] = $this->formatItemStore($config[$obj['store_id']]);
        }
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function buyAction() {
        if (($r=$this->checkParameter(array('store_id', 'commodity_id'))) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $commodity_id = $obj['commodity_id'];
        $store_id = $obj['store_id'];
        if (isset($obj['count'])) {
            $count = intval($obj['count']);
        } else {
            $count = 1;
        }

        $store_lib = $this->_di->getShared('store_lib');
        $role_id = $this->session->get('role_id');
        $res = $store_lib->buy($role_id, $commodity_id, $count, $store_id);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }
    
    private function formatItemStore($config) {
    	$result = array();

        $now = time();
        $obsolete_cids = array();
    	foreach ($config as $cid=>$commodity) {
    		if(isset($commodity['open_hour'])) {
    			$open_hour = $commodity['open_hour'];
    			$start_ts = strtotime($open_hour[0]);
    			$stop_ts = strtotime($open_hour[1]);
    			if ($now >= $stop_ts) {
                    $obsolete_cids[]= $cid;
    			}
            }
        }
        foreach ($obsolete_cids as $cid) {
            unset($config[$cid]);
        }
        return $config;

    	
        /*
    	foreach ($config as $key=>$value) {

    		$store_data = array();
    		$item = $value['items'][1];
    		$store_data['item_id'] = $item['item_id'];
    		$store_data['sub_id'] = $item['sub_id'];
    		
    		$price = $value['price'];
    		if(isset($price['diff'])) {
    			$store_data['costs'] = $price['diff'];
    		} else {
    			$store_data['costs'] = array($price['val']);
    		}
            $store_data['currency'] = $price['currency'];

    		if (isset($value['purchase_restriction'])) {
    			$purchase_restriction = $value['purchase_restriction'];
    			// 0==����, 1==ÿ���޹�amount��, 2==�ܹ��޹�amount��,
    			if($purchase_restriction['type'] == 1 ||
    				$purchase_restriction['type'] == 2) {

    				$restrict = array();
    				$restrict['type'] = $purchase_restriction['type'];
					if(isset($purchase_restriction['vip_dependent'])){
						$restrict['values'] = $purchase_restriction['vip_dependent'];
					} else {
						$restrict['values'] = array();
						for ($i = 0; $i < 15; $i++) {
							$restrict['values'][] = $purchase_restriction['amount'];
						}
					}
					$store_data['restrict'] = $restrict;
    			}
    		}

    		$store_data['weight'] = $value['weight'];
    		if(isset($value['open_hour'])) {
    			$open_hour = $value['open_hour'];
    			$start_ts = strtotime($open_hour[0]);
    			$stop_ts = strtotime($open_hour[1]);
    			$now = time();
    			if ($now >= $start_ts && $now <= $stop_ts) {
    				$store_data['time_restrict'] = array();
    				$store_data['time_restrict']['times'] = array($open_hour[0], $open_hour[1]);
    				$result[$key] = $store_data;
    			}
    		} else {
    			$result[$key] = $store_data;
    		}
        }
    	return $result;
         */
    }

}
