<?php

namespace Cap\Libraries;

use \Cap\Libraries\UserLib;

class MidasLib extends BaseLib {

    public static $MIDAS_KEY = "midas:%s";
    
    public function __construct() {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
        $this->_di->set('resque_lib', function() {
            return new \Cap\Libraries\ResqueLib();
        }, true);
    }

    public function getUsedTimes($role_id) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$MIDAS_KEY, $role_id);
        $record = $rds->get($key);
        return intval($record);
    }

    public function buy($role_id) {
        syslog(LOG_DEBUG, "midas buy($role_id)");
        $rds = $this->_di->getShared('redis');
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $vip = $user[UserLib::$USER_PROF_FIELD_VIP];
        $midas_cfg = self::getGameConfig('midas');

        $limits = $midas_cfg['daily_limit'];
        $limit = 0;
        foreach ($limits as $k=>$v) {
            if ($vip>=$k && $limit<$v) {
                $limit = $v;
            }
        }

        $record_key = sprintf(self::$MIDAS_KEY, $role_id);
        $record = $rds->incr($record_key);
        if ($record==1) {
            $rds->expireAt($record_key, $this->getDefaultExpire());
        }
        $left_times = $limit - $record;
        if ($left_times < 0) {
            syslog(LOG_INFO, "midas buy($role_id): daily limit reached");
            $rds->decr($record_key); // roll back
            return array('code'=> 403, 'msg'=> 'daily limit reached');
        }

        # calculate cost and amount
        $prices = $midas_cfg['price'];
        for ($i=$record;$i>=1;$i--) {
            if (isset($prices[$i])) {
                break;
            }
        }
        $price = $prices[$i];
        $cost = $price['cost'];
        list($base_factor, $level_factor, $modifier) = array($price['factor'][1], $price['factor'][2], $price['factor'][3]);
        $base_amount = ($base_factor+$level_factor*$user[UserLib::$USER_PROF_FIELD_LEVEL]) * $modifier;

        # extra crit multiply
        $crits = $midas_cfg['crit'];
        for ($i=$vip;$i>=0;$i--) {
            if (isset($crits[$i])) {
                break;
            }
        }
        $crit = $crits[$i];
        $total_weight = array_sum($crit);
        $rand = mt_rand(0, $total_weight-1);
        foreach ($crit as $times=>$weight) {
            //syslog(LOG_DEBUG, "$rand vs $times");
            if ($rand < $weight) {
                break;
            }
            $rand -= $weight;
        }
        $amount = intval($base_amount * $times);
        syslog(LOG_DEBUG, "midas buy($role_id), cost=$cost, base=$base_amount, amount=$amount, cirt=$times");

        # deduct&check gold balance
        if (($remain_gold=$user_lib->incrProfBy($role_id, UserLib::$USER_PROF_FIELD_GOLD, -$cost))<0) {
            syslog(LOG_ERR, "midas buy($role_id), insufficient gold $remain_gold / $cost");
            $user_lib->incrProfBy($role_id, UserLib::$USER_PROF_FIELD_GOLD, $cost);// #roll back
            $rds->decr($record_key); // roll back
            return array('code'=> 405, 'msg'=> 'insufficient gold');
        }
        $remain_coin = $user_lib->incrProfBy($role_id, UserLib::$USER_PROF_FIELD_COIN, $amount);
        # persistent back job
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('user', 'profchange', array('uid'=> $role_id, 
            UserLib::$USER_PROF_FIELD_GOLD=>-$cost,
            UserLib::$USER_PROF_FIELD_COIN=>$amount));

        $res = array('code'=> 200, 'coin'=>$remain_coin, 'gold'=>$remain_gold, 'crit'=> $times, 'used_times'=>$record);
        return $res;
    }
}

// end of file
