<?php

namespace Cap\Libraries;

use Cap\Models\Db\PayOrderModel;

class ChargeLib extends BaseLib {

    public static $CACHE_KEY_MONTH_CARD = 'nami:monthcard:%s';
    public static $CHARGE_RECORDS_KEY = "charge:%s";

    public static $CACHE_KEY_FIRST_LEVEL = 'nami:charge:flevel';
    public static $CACHE_KEY_FIRST_TIME  = 'nami:charge:ftime';

    public static $ORDER_STATUS_CREATED = 1;
    public static $ORDER_STATUS_PAID = 2;
    public static $ORDER_STATUS_FINISHED = 3;
    public static $ORDER_STATUS_CANCELD = 4;

    public function __construct() {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
        $this->_di->set('order_model', function () {
            return new PayOrderModel();
        }, true);

    }

    public function getRecords($user_id) {
        $rds = $this->_di->getShared('redis');
        $rkey = sprintf(self::$CHARGE_RECORDS_KEY, $user_id);
        $records = $rds->hgetall($rkey);
        return $records;
    }

    /* get vip level according to charge amount */
    public function getVipLevel($user_id, $charge=false) {
        $vip_cfg = self::getGameConfig('user_vip');
        if ($charge===false) {
            $user_lib = $this->_di->getShared('user_lib');
            $user = $user_lib->getUser($user_id);
            $charge = $user[UserLib::$USER_PROF_FIELD_CHARGE];
        }
        $vip_count = count($vip_cfg);
        for ($i=0;$i<$vip_count;$i++) {
            if ($charge < $vip_cfg[$i]["charge"]) {
                return $i;
            }
        }
        return $vip_count-1;
    }

    public function updateVipLevel($user_id, $charge=false) {
        $user_lib = $this->_di->getShared('user_lib');
        $vip_level = $this->getVipLevel($user_id, $charge);
        $rds = $this->_di->getShared('redis');
        $user_lib->setProf($user_id, UserLib::$USER_PROF_FIELD_VIP, $vip_level);
    }

    /*
     * pay money for gold
     */
    public function charge($user_id, $package_id, $order_id) {
        $rds = $this->_di->getShared('redis');
        $user_lib = $this->_di->getShared('user_lib');

        $charge_packages = self::getGameConfig('charge_package');
        if (!isset($charge_packages[$package_id])) {
            return array('code'=> 404, 'msg'=> "package $package_id not configured");
        }
        $package = $charge_packages[$package_id];
        $price = $package['price'];
        $gold = $package['gold'];
        # TODO: check receipt for charge and check price
        $order = $this->getOrder($order_id);
        if ($order) {
            if (self::$ORDER_STATUS_PAID != $order['status']) {
                return array('code' => 403, 'msg' => '订单未被支付');
            }
        }
        # extra bonus
        $extra = 0;
        if (isset($package['extra_gold'])) {
            $extra += $package['extra_gold'];
        }

        /** 为KPI系统添加首次充值时间和等级分布 */
        $rkey = sprintf(self::$CHARGE_RECORDS_KEY, $user_id);
        // 没有充值记录，说明是第一次充钱
        if (! $rds->exists($rkey)) {
            $user = $user_lib->getUser($user_id);
            $level = $user[UserLib::$USER_PROF_FIELD_LEVEL];
            $stamp = time();
            $rds->hIncrBy(self::$CACHE_KEY_FIRST_LEVEL, $level, 1);
            $rds->hSet(self::$CACHE_KEY_FIRST_TIME, $user_id, $stamp);
        }
        /** ********************************/
        # virgin purchase bonus
        if (isset($package['virgin_extra'])) {
            syslog(LOG_DEBUG, "charge on item with virgin extra");
            $rkey = sprintf(self::$CHARGE_RECORDS_KEY, $user_id);
            $buy_count = $rds->hincrBy($rkey, $package_id, 1);
            if ($buy_count == 1) {
                syslog(LOG_DEBUG, "give virgin extra to user $user_id");
                $extra += $package['virgin_extra'];
            }
        }
        $res = array('code'=> 200);
        # 如果package_id为1，为月卡，要观察是否需要更新月卡状态
        if ($package_id == 1) {
            $ttl = $this->updateMonthCard($user_id);
            if ($ttl) {
                $res['month_ttl'] = time() + $ttl; 
            } else {
                $res['month_ttl'] = 0;
            }
        }
        $new_gold = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_GOLD, $gold + $extra);
        $new_charge = $user_lib->incrProfBy($user_id, UserLib::$USER_PROF_FIELD_CHARGE, $gold);
        # update vip level
        $this->updateVipLevel($user_id, $new_charge);

        $res['gold'] = $new_gold; 
        $res['charge']= $new_charge;
        $this->updateOrderStatus($order_id, self::$ORDER_STATUS_FINISHED);
        return $res;
    }

    private function updateMonthCard($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_MONTH_CARD, $user_id);
        $ttl = $this->redis->ttl($cache_key);
        $now = time();
        if ($ttl==-1 || $ttl==-2) {
            $secofday = $now - strtotime("05:00", $now-5*3600);
            $ttl = 30 * 86400 - $secofday;
        } else {
            $ttl += 30 * 86400;
        }
        //$ttl = strtotime("05:00", $ttl + 30 * 86400 + 19*3600-1);
        syslog(LOG_DEBUG, "month card of $user_id new ttl = $ttl");
        $this->redis->setex($cache_key, $ttl, 1);
        return $ttl;
    }

    public function getMonthCardTTL($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_MONTH_CARD, $user_id);
        $ttl = $this->redis->ttl($cache_key);
        return $ttl > 0 ? intval($ttl) : 0;
    }

    public function genOrder($source, $server_id, $user_id, $package_id)
    {
        $date = date('YmdHis');
        $order_id = $date . sprintf('%02d', $server_id) . sprintf('%03d', $source) . sprintf('%08d', $user_id) . sprintf('%03d', $package_id) . mt_rand(100, 999);
        $charge_packages = self::getGameConfig('charge_package');
        if (isset ($charge_packages[$package_id])) {
            $amount = $charge_packages[$package_id]['price'] * 100; // 转化为分
            $order_model = $this->getDI()->getShared('order_model');
            $ret = $order_model->createOrder($source, $server_id, $user_id, $order_id, $package_id, $amount);
            if ($ret) {
                return $order_id;
            }
        }
        return 0;
    }

    public function getOrder($order_id)
    {
        $order_model = $this->getDI()->getShared('order_model');
        $order = $order_model->getOrderByOrderID($order_id);
        return $order;
    }

    public function updateOrderStatus($order_id, $status)
    {
        $order_model = $this->getDI()->getShared('order_model');
        $ret = $order_model->updateOrderStatus($order_id, $status);
        return $ret;
    }
}

// end of file
