<?php

namespace Cap\Libraries;

use Phalcon\Exception;

class RefreshStoreLib extends StoreLib {

    public static $KEY_STORE_USER_RECORDS = "storeitems:%s:%s"; // placeholders: store_id, user_id
    public static $KEY_REFRESH_COUNT = "storerefresh:%s:%s"; // placeholders: store_id, user_id

    public function __construct() {
        parent::__construct();
        $this->_di->set('resque_lib', function() {
            return new \Cap\Libraries\ResqueLib();
        }, true);
        $this->_di->set('purchase_history_model', function() {
            return new \Cap\Models\db\UserRefreshPurchaseRecordModel();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
    }

    public function buy($user_id, $commodity_id, $count=1, $store_id=1) {
        syslog(LOG_DEBUG, "RefreshStore buy($user_id, $commodity_id) start");
        # check store and commodity
        $all_store_goods = self::getGameConfig('rstore');
        if (!isset($all_store_goods[$store_id])) {
            return array('code'=> 404, 'msg'=> 'store not exists');
        }
        $store = $all_store_goods[$store_id];
        $goods = $store['commodities'];
        if (!isset($goods[$commodity_id])) {
            return array('code'=> 404, 'msg'=> 'commodity not found');
        }
        $commodity = $goods[$commodity_id];
        $price = $commodity['price'];
        $items = $commodity['items'];
        
        # check depot for user
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$KEY_STORE_USER_RECORDS, $store_id, $user_id);
        $records = $rds->hgetall($key);
        if (!isset($records, $commodity_id)) {
            return array('code'=> 404, 'msg'=> 'commodity not available for user');
        }
        # check and add purchace record
        $r = $rds->hincrBy($key, $commodity_id, 1);
        if ($r>1) {
            syslog(LOG_ERR, "user $user_id can not buy this any more");
            $rds->hincrBy($key, $commodity_id, -1);
            return array('code'=> 403, 'msg'=> 'can not buy this any more');
        }
        # deduct cost
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $field = $price['currency']; // honor, gold, coin, free
        $cost = $price['val'];
        $balance = 0;
        if (isset($user[$field])) {
            $balance = $user[$field];
        }
        $balance = $user_lib->incrProfBy($user_id, $field, -$cost);
        if ($balance < 0) {
            syslog(LOG_INFO, "buy($user_id, $commodity_id,  $store_id): balance not enough");
            $balance = $user_lib->incrProfBy($user_id, $field, $cost);
            return array('code'=> 405, 'msg'=> "balance $balance not enough");
        }
        # back ground job to persistent prof change
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('user', 'profchange', array('uid'=> $user_id, $field=>-$cost));

        $this->dispatchItems($user_id, $items, $count);

        # record history
        $history_model = $this->_di->getShared('purchase_history_model');
        $r = $history_model->addRecord($user_id, $store_id, $commodity_id, $count, $cost, $price['currency']);
        if (!$r) {
            syslog(LOG_ERR, "buy($user_id, $commodity_id, $count, $store_id): fail to record history");
        }
        return array('code'=> 200, 'balance'=>$balance, 'items'=>$items);
    }

    /*
     * refresh a store (count)items presented to a user
     */
    public function refresh($user_id, $store_id) {
        $rds = $this->_di->getShared('redis');
        $all_store_goods = self::getGameConfig('rstore');
        if (!isset($all_store_goods[$store_id])) {
            syslog(LOG_ERR, "refresh($user_id, $store_id): fail to find store");
            return false;
        }
        $store = $all_store_goods[$store_id];
        $refresh_price = $store['refresh_price'];
        $goods = $store['commodities'];
        $count = $store['presents_count'];
        $fixed_cids = $store['fix_commodities'];

        $commodities = array();
        $commodities_records = array();
        # fixed items
        foreach ($fixed_cids as $commodity_id) {
            $commodities_records[$commodity_id] = 0;
            $g = array();
            $g['id'] = $commodity_id;
            $g['item'] = $goods[$commodity_id]['items'][0];
            $g['count'] = 0;
            $g['cost'] = $goods[$commodity_id]['price']['val'];
            $g['weight'] = $goods[$commodity_id]['weight'];
            $commodities[] = $g;
            unset($goods[$commodity_id]);
        }
        # random items
        if ($count > count($fixed_cids)) {
            $rids = array_rand($goods, $count-count($fixed_cids));
            if (!is_array($rids)) {
                $rids = array($rids);
            }
            foreach ($rids as $commodity_id) {
                syslog(LOG_DEBUG, "cid:".$commodity_id);
                $commodities_records[$commodity_id] = 0;
                $g = array();
                $g['id'] = $commodity_id;
                $g['item'] = $goods[$commodity_id]['items'][0];
                $g['count'] = 0;
                $g['cost'] = $goods[$commodity_id]['price']['val'];
                $g['weight'] = $goods[$commodity_id]['weight'];
                $commodities[] = $g;
            }
        }
        usort($commodities, function($a,$b){
            if (isset($a['weight']) && isset($b['weight'])) {
                return $a['weight'] < $b['weight'];
            } else if (isset($a['weight'])) {
                return true;
            } else {
                return false;
            }
        });

        # record refresh count
        $refresh_key = sprintf(self::$KEY_REFRESH_COUNT, $store_id, $user_id);
        $rcount = $rds->incr($refresh_key);
        if ($rcount == 1) {
            $rds->expireAt($refresh_key, $this->getDefaultExpire());
        }

        # calculate cost by count
        $cost = $this->calDiffCost($refresh_price, $rcount);
        $next_cost = $this->calDiffCost($refresh_price, $rcount+1);
        $user_lib = $this->_di->getShared('user_lib');
        $field = $refresh_price['currency'];
        $balance = $user_lib->consumeFieldAsync($user_id, $field, $cost);
        if ($balance === false) {
            syslog(LOG_ERR, "fail to consume gold $cost");
            # rollback
            $rds->incrBy($refresh_key, -1);
            return false;
        }

        # replace old records
        $key = sprintf(self::$KEY_STORE_USER_RECORDS, $store_id, $user_id);
        $rds->del($key);
        $rds->hmset($key, $commodities_records);
        $rds->expireAt($key, $this->getDefaultExpire());

        $res = array(
            'code'=> 200,
            'refresh_count'=> $rcount - 1, // 将免费刷新的那次减去
            'refresh_cost'=> $next_cost,
            'awards'=> $commodities,
            'balance' => $balance,
        );
        return $res;
    }

    /*
     * get the commodity list for the commodity 
     */
    public function getRecords($user_id, $store_id) {
        // replace old records
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$KEY_STORE_USER_RECORDS, $store_id, $user_id);
        $rids = $rds->hgetall($key);
        if ($rids==false) {
            return $this->refresh($user_id, $store_id);
        }
        $all_store_goods = self::getGameConfig('rstore');
        if (!isset($all_store_goods[$store_id])) {
            syslog(LOG_ERR, "refresh($user_id, $store_id): fail to find store");
            return false;
        }
        $store = $all_store_goods[$store_id];
        $refresh_price = $store['refresh_price'];
        $goods = $store['commodities'];
        $commodities = array();
        foreach ($rids as $commodity_id=>$purchased) {
            $g = array();
            $g['id'] = $commodity_id;
            $g['count'] = $purchased;
            if (isset($goods[$commodity_id])) {
                $g['item'] = $goods[$commodity_id]['items'][0];
                $g['cost'] = $goods[$commodity_id]['price']['val'];
                $g['weight'] = $goods[$commodity_id]['weight'];
            } else {
                syslog(LOG_INFO, "store record, $store_id:$commodity_id is absent from shelf");
            }
            $commodities[] = $g;
        }
        usort($commodities, function($a,$b){
            if (isset($a['weight']) && isset($b['weight'])) {
                return $a['weight'] < $b['weight'];
            } else if (isset($a['weight'])) {
                return true;
            } else {
                return false;
            }
        });

        $refresh_key = sprintf(self::$KEY_REFRESH_COUNT, $store_id, $user_id);
        $rcount = $rds->get($refresh_key);
        if (!$rcount)
            $rcount = 0;
        $refresh_price = $store['refresh_price'];
        $rcost = $this->calDiffCost($refresh_price, $rcount+1);

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $res = array (
            'code'=> 200,
            'refresh_count'=> $rcount - 1, // 将免费刷新的那次减去
            'refresh_cost'=> $rcost,
            'awards'=> $commodities,
            'balance' => $user[$refresh_price['currency']],
        );
        return $res;
    }

    protected function getRefreshPrice(){
        $refresh_price = array("diff"=>array("1"=>0, "2"=>10, "4"=>20, "40"=>100));
        return $refresh_price;
    }
}

// end of file

