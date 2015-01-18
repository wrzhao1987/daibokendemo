<?php

namespace Cap\Libraries;

class StoreLib extends BaseLib {

    public static $DAILY_PURCHASE_RECORD_KEY = 'daily_purchase_record:%s'; // purchase record for user_id in store_id
    public static $TOTAL_PURCHASE_RECORD_KEY = 'purchase_record:%s'; // purchase record for user_id in store_id
    public static $LAST_PURCHASE_TIME_KEY = 'last_purchase:%s'; // purchase record for user_id in store_id
    public static $PURCHASE_FIELD = '%s:%s';  // palceholds: [store_id, commodiy_id]

    public static $ITEM_TYPE_ITEM = 1;
    public static $ITEM_TYPE_ENERGY = 2;
    public static $ITEM_TYPE_ENERGY_MISSION = 1;
    public static $ITEM_TYPE_ENERGY_ROB = 2;

    public function __construct() {
        parent::__construct();

        $this->_di->set('store_model', function() {
            return new \Cap\Models\db\StoreModel();
        }, true);
        $this->_di->set('resque_lib', function() {
            return new \Cap\Libraries\ResqueLib();
        }, true);
        $this->_di->set('purchase_history_model', function() {
            return new \Cap\Models\db\UserPurchaseRecordModel();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
    }

    private function getVipDependentValue($user_id, $vip_depend) {
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $vip_lvl = $user['vip'];
        return $vip_depend[$vip_lvl];
    }

    /*
     * differential pricing cost
     */
    protected function calDiffCost($price, $n) {
        for($i=$n;$i>=0;$i--) {
            if (isset($price['diff'][$i]))
                return $price['diff'][$i];
        }
        syslog(LOG_ERR, "calDiffCost(.., $n), not find out final cost");
        return false;
    }

    /*
     * buy commodity
     */
    public function buy($user_id, $commodity_id, $count=1, $store_id=1) {
        /*
        {
            "1": {
                "items": [
                    {
                        "type": 1,
                        "val": 1,
                        "count": 2,
                    },
                    ...
                ]
                "price": {
                    "currency_type": "gold",
                    "val": 5
                }
                "purchase_restriction": {
                    "amount": 1,
                    "type": 1    // 0-- no restrict, 1 -- restrict per day, 2 -- restrict total, 3 -- cool down time
                }
            },
            ...
        }
        */
        syslog(LOG_DEBUG, "buy($user_id, $commodity_id, $count, $store_id) start");
        # check store and commodity
        $all_store_goods = self::getGameConfig('store_goods');
        if (!isset($all_store_goods[$store_id])) {
            return array('code'=> 404, 'msg'=> 'store not exists');
        }
        $goods = $all_store_goods[$store_id];
        if (!isset($goods[$commodity_id])) {
            return array('code'=> 404, 'msg'=> 'commodity not found');
        }
        $commodity = $goods[$commodity_id];
        $price = $commodity['price'];
        $items = $commodity['items'];
        $purchase_restrict = $commodity['purchase_restriction'];
        # amount dependent on vip level
        if (isset($purchase_restrict['vip_dependent'])) {
            $purchase_restrict['amount'] = $this->getVipDependentValue($user_id,
                $purchase_restrict['vip_dependent']);
        }

        $rds = $this->_di->getShared('redis');

        # check purchase restriction
        $drkey = sprintf(self::$DAILY_PURCHASE_RECORD_KEY, $user_id);
        $trkey = sprintf(self::$TOTAL_PURCHASE_RECORD_KEY, $user_id);
        syslog(LOG_DEBUG, "restricttype:$purchase_restrict[type]");
        $field_key = sprintf(self::$PURCHASE_FIELD, $store_id, $commodity_id);
        if ($purchase_restrict['type'] == 1) {
            // num limited per day
            $records = $this->getDailyPurchaseRecords($user_id, $store_id);
            if (isset($records[$field_key])) {
                $num = $records[$field_key];
                if ($num + $count > $purchase_restrict['amount']) {
                    return array('code'=> 403, 'msg'=> 'daily purchase limit reached');
                }
            }
        } else if ($purchase_restrict['type'] == 2) {
            // num limited total
            $records = $this->getTotalPurchaseRecords($user_id, $store_id);
            if (isset($records[$field_key])) {
                $num = $records[$field_key];
                if ($num + $count > $purchase_restrict['amount']) {
                    return array('code'=> 403, 'msg'=> 'total purchase limit reached');
                }
            }
        } else if ($purchase_restrict['type'] == 3) {
            // limit per cooldown time
            $cooldown = $purchase_restrict['amount'];
            $last_purchase = $this->getLastPurchaseTime($user_id, $store_id, $commodity_id);
            if (time() < $cooldown + $last_purchase) {
                return array('code'=> 403, 'msg'=> 'in cool down time');
            }
        }

        // check open hour
        if (isset($commodity['open_hour'])) {
            $start_ts = strtotime($commodity['open_hour'][0]);
            $stop_ts = strtotime($commodity['open_hour'][1]);
            $now = time();
            if ($now < $start_ts || $now > $stop_ts) {
                return array('code'=> 403, 'msg'=> 'not in open time');
            }
        }

        # check&deduct balance
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $field = $price['currency']; // honor, gold, coin, free
        if (isset($price['diff'])) {
            if (!isset($num)) {
                $num = 0;
            }
            $cost = 0;
            for ($i=1;$i<=$count;$i++) {
                $ucost = $this->calDiffCost($price, $num+$i);
                if ($ucost === false) {
                    return array('code'=> 500, 'msg'=> 'fail to determine price');
                }
                $cost += $ucost;
            }
            syslog(LOG_DEBUG, "buy($user_id, $commodity_id, $count), cost=$cost");
        } else {
            $cost = $price['val'] * $count;
        }
        $balance = 0;
        if (isset($user[$field])) {
            $balance = $user[$field];
        }
        if ($cost) {
            $balance = $user_lib->incrProfBy($user_id, $field, -$cost);
            if ($balance < 0) {
                syslog(LOG_INFO, "buy($user_id, $commodity_id, $count, $store_id): balance not enough");
                $balance = $user_lib->incrProfBy($user_id, $field, $cost);
                return array('code'=> 405, 'msg'=> "balance $balance not enough");
            }
            # back ground job to persistent prof change
            $resque_lib = $this->_di->getShared('resque_lib');
            $resque_lib->setJob('user', 'profchange', array('uid'=> $user_id, $field=>-$cost));
        }
        // give items to user
        $this->dispatchItems($user_id, $items, $count);

        # records history
        if ($purchase_restrict['type'] == 1) {
            $r = $rds->hincrBy($drkey, $field_key, $count);
            if ($r==1) {
                $rds->expireAt($drkey, $this->getDefaultExpire());
            }
        } else if ($purchase_restrict['type'] == 2) {
            $rds->hincrBy($trkey, $field_key, $count);
        } else if ($purchase_restrict['type'] == 3) {
            $this->setLastPurchaseTime($user_id, $store_id, $commodity_id);
        }
        $history_model = $this->_di->getShared('purchase_history_model');
        $r = $history_model->addRecord($user_id, $store_id, $commodity_id, $count, $cost, $price['currency']);
        if (!$r) {
            syslog(LOG_ERR, "buy($user_id, $commodity_id, $count, $store_id): fail to record history");
        }

        return array('code'=> 200, 'balance'=>$balance, 'items'=>$items);
    }

    public function getDailyPurchaseRecords($user_id, $store_id=1) {
        $key = sprintf(self::$DAILY_PURCHASE_RECORD_KEY, $user_id, $store_id);
        $rds = $this->_di->getShared('redis');
        $records = $rds->hgetall($key);
        return $records;
    }

    public function getTotalPurchaseRecords($user_id, $store_id=1) {
        $key = sprintf(self::$TOTAL_PURCHASE_RECORD_KEY, $user_id, $store_id);
        $rds = $this->_di->getShared('redis');
        $records = $rds->hgetall($key);
        return $records;
    }

    public function setLastPurchaseTime($user_id, $store_id, $commodity_id) {
        $key = sprintf(self::$LAST_PURCHASE_TIME_KEY, $user_id);
        $field = sprintf(self::$PURCHASE_FIELD, $store_id, $commodity_id);
        $rds = $this->_di->getShared('redis');
        $r = $rds->hset($key, $field, time());
        return $r;
    }

    public function getLastPurchaseTime($user_id, $store_id, $commodity_id) {
        $key = sprintf(self::$LAST_PURCHASE_TIME_KEY, $user_id);
        $field = sprintf(self::$PURCHASE_FIELD, $store_id, $commodity_id);
        $rds = $this->_di->getShared('redis');
        $r = $rds->hget($key, $field);
        return $r;
    }

    // give items to user
    protected function dispatchItems($user_id, &$items, $count) {
        # full implementation
        $user_lib = $this->_di->getShared('user_lib');
        $item_lib = $this->_di->getShared('item_lib');
        foreach ($items as &$item) {
            syslog(LOG_DEBUG, "store dispatch item $item[type]:$item[item_id] X $count to $user_id");
            if ($item['type'] == self::$ITEM_TYPE_ENERGY) {
                # give energy to user
                switch($item['item_id']) {
                case self::$ITEM_TYPE_ENERGY_ROB:
                    $user_lib->addRobEnergy($user_id, $item['count']*$count);
                    break;
                case self::$ITEM_TYPE_ENERGY_MISSION:
                    $user_lib->addMissionEnergy($user_id, $item['count']*$count);
                    break;
                default:
                    break;
                }
            } else if ($item['type'] == self::$ITEM_TYPE_ITEM) {
                $item['count'] *= $count;
                $r = $item_lib->addItem($user_id, $item['item_id'], $item['sub_id'], $item['count']);
                if (is_array($r)) {
                    $item = array_merge($item, $r);
                }
            } else {
                syslog(LOG_ERR, "store dispatch item type not implemented yet");
            }
        }
    }

}


