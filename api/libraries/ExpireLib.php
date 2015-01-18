<?php

namespace Cap\Libraries;

class ExpireLib extends BaseLib {

    public static $UDAY_EXPIRE_KEY = "u:%s:day:%s"; // placeholder: date
    public static $DAY_EXPIRE_KEY = "day:%s"; // placeholder: date

    /*
     *
     * concentralized (expire next morning) field storage
     *
     * u:101:day:2014-05-06 => {
     *   'dailypass:1'=>1,
     *   'dailypass:2'=>3,
     *   'dailypass:1'=>3,
     *   'purchase:1:2'=>4,
     *   'purchase:1:3'=>4,
     * }
     *
     * day:2014-05-06 => {
     *   '101:wipeenergy'=> 10,
     *   '101:robenergy'=>3,
     *   '102:wipeenergy'=> 9,
     * }
     */


    public function onConstruct() {
        parent::onConstruct();
        $day = date('Y-m-d');       // one shot
        $this->day = $day;
        $this->expire_key = sprintf(self::$DAY_EXPIRE_KEY, $day);
        $this->rds = $this->_di->getShared('redis');
    }

    public function hset($role_id, $type, $sub_key, $value) {
        $prefix = "$type:";
        $key = sprintf(self::$UDAY_EXPIRE_KEY, $role_id, $day);
        return $this->rds->hget($key, $prefix.$sub_key, $value);
    }

    public function hget($role_id, $type, $sub_key) {
        $prefix = "$type:";
        $key = sprintf(self::$UDAY_EXPIRE_KEY, $role_id, $day);
        return $rds->hget($key, $prefix.$sub_key);
    }

    public function hgetall($role_id, $type) {
        $prefix = "$type:";
        $key = sprintf(self::$UDAY_EXPIRE_KEY, $role_id, $day);
        $all_data = $this->rds->hgetall($key);

        $data = array();
        $prefix = "$type:";
        $prefix_len = strlen($prefix);
        foreach ($all_data as $key=>$val) {
            if (strncmp($key, $prefix, $prefix_len)==0) {
                $sub_key = explode(':', $key, 2)[1];
                $data[$sub_key] = $val;
            }
        }
        return $data;
    }

    /*
     * get multiple type record
     * params: types=['daily_pass', 'purchase']
     * return 
     * {
     *  'daily_pass': {
     *      '1': 3,
     *      '2': 1,
     *  }
     *  'purchase': {
     *      '1:1': 3,
     *      '1:2': 2
     *  }
     * }
     */
    public function hmgetall($role_id, $types) {
        $prefix = "$type:";
        $key = sprintf(self::$UDAY_EXPIRE_KEY, $role_id, $day);
        $all_data = $this->rds->hgetall($key);
        $mdata = array();

        foreach ($types as $type) {
            $mdata[$type] = array();
        }
        foreach ($all_data as $key=>$val) {
            $parts = explode(':', $key, 2);
            $len = count($parts);
            if ($len != 2) {
                syslog(LOG_ERR, "expire lib: unexpected key ".$this->expire_key."->$key");
                continue;
            }
            $type = $parts[0];
            $sub_key = $parts[1];
            $mdata[$type][$sub_key] = $val;
        }
        return $mdata;
    }

    public function set($role_id, $type, $value) {
        $prefix = "$role_id:$type";
        return $this->rds->hset($this->expire_key, $prefix, $value);
    }

    public function get($role_id, $type) {
        $prefix = "$role_id:$type";
        return $this->rds->hget($this->expire_key, $prefix);
    }

    public function mget($role_id, $types) {
        $subkeys = array();
        foreach ($types as $type) {
            $subkeys []= "$role_id:$type";
        }
        return $this->rds->hmget($this->expire_key, $subkeys);
    }
}

// end of file
