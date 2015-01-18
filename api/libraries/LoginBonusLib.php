<?php

namespace Cap\Libraries;

use \Cap\Libraries\UserLib;

class LoginBonusLib extends BaseLib {

    public static $SIGN_BONUS_KEY = 'signbonus:%s:%s'; // placeholder:[month, uid]
    public static $ACCU_FIELD_PREFIX = 'accu:';

    public function __construct() {
        parent::__construct();
        $this->current_ts = time();
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
    }

    public function getRecords($role_id) {
        $rds = $this->_di->getShared('redis');
        $month = date('Y-m', $this->current_ts);
        $rkey = sprintf(self::$SIGN_BONUS_KEY, $month, $role_id);
        $records = $rds->hgetall($rkey);
		foreach ($records as $key=>&$val) {
			$val = date('d', $val);
		}
        return $records;
    }

    public function acceptDayBonus($role_id, $day=false, $is_remedy=false) {
        syslog(LOG_DEBUG, "getDayBonus($role_id, $day, $is_remedy)");
        $month = date('Y-m', $this->current_ts);
        $curday = (int)date('d', $this->current_ts);
        if (!$day) {
            $day = $curday;
        } else if (intval($day)>$curday) {
            return array('code'=> 403, 'msg'=> 'date not beyond current day');
        }
        $day = (int)$day; // transfer 03 to 3
        $rkey = sprintf(self::$SIGN_BONUS_KEY, $month, $role_id);
        $rds = $this->_di->getShared('redis');
        $records = $rds->hgetall($rkey);
        if (isset($records[$day])) {
            return array('code'=> 405, 'msg'=> 'already given bonus');
        }

        # checkout basic items
        $bonus_cfg = $this->getBonusConfig();
        if (!$bonus_cfg || !isset($bonus_cfg[$day])) {
            syslog(LOG_DEBUG, "bonus not configued for $day");
            return array('code'=> 404, 'msg'=> 'bonus not set');
        }
        $items = $bonus_cfg[$day]['award'];

        # cause cost if is remedy
        if ($is_remedy) {
            # find out how many remedy occured yet
            $remedy_count = 1;
            foreach ($records as $mday=>$ts) {
                if ($mday != date('d', $ts)) {
                    $remedy_count++;
                }
            }
            # deduct cost
            $cost = 10 * ceil(($remedy_count)/2);
            syslog(LOG_DEBUG, "remedy bonus $role_id, $day remedycount:$remedy_count, cost:$cost");
            $user_lib = $this->_di->getShared('user_lib');
            $cr = $user_lib->consumeFieldAsync($role_id, UserLib::$USER_PROF_FIELD_GOLD, $cost);
            if ($cr===false) {
                syslog(LOG_INFO, "remedy bonus $role_id, $day cost=$cost, denied due to lack of gold");
                return array('code'=> 405, 'msg'=> 'gold insufficient');
            }
        }

        # check extra multiple
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $vip = $user['vip'];
        $multiple = 1;
        if (isset($bonus_cfg['vip_multiples'])) {
            foreach ($bonus_cfg['vip_multiples'] as $k=>$v) {
                if ($vip >= $k && $v > $multiple) {
                    $multiple = $v;
                }
            }
        }
        syslog(LOG_DEBUG, "getDayBonus($role_id) $month-$day, multiple=$multiple, remedy=$is_remedy");
        $item_lib = $this->_di->getShared('item_lib');
        foreach ($items as &$item) {
            $item['count'] *= $multiple;
            # give items
            if ($r=$item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count'])) {
                if (is_array($r)) {
                    $item = array_merge($item, $r);
                }
            } else {
                syslog(LOG_ERR, "fail to add item ($role_id, $item[item_id], $item[sub_id], $item[count])");
            }
        }

        # set bonus record
        $records = $rds->hset($rkey, $day, $this->current_ts);
        return array('code'=>200, 'items'=> $items);
    }

    public function getBonusConfig() {
        $month = date('m', $this->current_ts);
        $bonus_cfg = self::getGameConfig('login_bonus_'.$month);
        return $bonus_cfg;
    }

    /*
     * accept accumulated sign caused bonus
     * param: accu indicate which accumulated bonus to accept
     */
    public function acceptAccuBonus($role_id, $accu) {
        syslog(LOG_DEBUG, "acceptAccuBonus($role_id, $accu)");
        $month = date('Y-m', $this->current_ts);
        $rkey = sprintf(self::$SIGN_BONUS_KEY, $month, $role_id);
        $rds = $this->_di->getShared('redis');
        $records = $rds->hgetall($rkey);
        $field = self::$ACCU_FIELD_PREFIX.$accu;
        if (isset($records[$field])) {
            return array('code'=> 405, 'msg'=> 'already accepted');
        }

        # checkout basic items
        $bonus_cfg = $this->getBonusConfig();
        if (!$bonus_cfg || !isset($bonus_cfg['accumulator']) 
            || !isset($bonus_cfg['accumulator'][$accu])) {
            return array('code'=> 404, 'msg'=> 'bonus not set');
        }
        $items = $bonus_cfg['accumulator'][$accu];

        # check award activation
        $sign_count = 0;
        foreach ($records as $key=> $val) {
            if (strncmp($key, self::$ACCU_FIELD_PREFIX, strlen(self::$ACCU_FIELD_PREFIX))) {
                $sign_count++;
            }
        }
        syslog(LOG_DEBUG, "acceptAccuBonus($role_id, $accu), sign_count=$sign_count");
        if ($sign_count < $accu) {
            return array('code'=> 406, 'msg'=> 'bonus not actived yet');
        }
        $item_lib = $this->_di->getShared('item_lib');
        foreach ($items as $item) {
            # give items
            if (!$item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count'])) {
                syslog(LOG_ERR, "fail to add item ($role_id, $item[item_id], $item[sub_id], $item[count])");
            }
        }

        # set record
        $rds->hset($rkey, $field, $this->current_ts);

        return array('code'=> 200, 'items'=> $items);
    }
}

// end of file
