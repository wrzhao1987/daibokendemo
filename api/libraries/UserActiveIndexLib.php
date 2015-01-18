<?php

class UserActiveIndexLib {

    public static $USER_LEVEL_TIME_KEY = 'level_active:%s:%s';  # hour
    public static $USER_LEVEL_TIME_DIST_KEY = 'level_active_dist:%s';  # level

    public static $USER_PROF_KEY = 'role:%s';   # should be consistent with \Cap\Libaries\UserLib
    public static $USER_PROF_FIELD_LAST_LOGIN = 'last_login';   # should be consistent with \Cap\Libaries\UserLib
    public static $USER_PROF_FIELD_LEVEL = 'level';   # should be consistent with \Cap\Libaries\UserLib


    public function __construct() {
        $rds = new \redis();
        $rds->connect('localhost', 6371);
        $rds->select(1); 
        $this->redis = $rds;
    }

    public function getHour($ts) {
        return intval($ts/3600);
    }

    /*
     * fire upon user login,  queue: user, worker: login
     */
    public function loginEvent($role_id, $time) {
        syslog(LOG_DEBUG, "loginEvent($role_id, $time)");
        $user_rds = new \redis();
        $user_rds->connect('localhost', 6379);
        $user_key = sprintf(self::$USER_PROF_KEY, $role_id);
        $rr = $user_rds->hmget($user_key,
            array(self::$USER_PROF_FIELD_LEVEL, self::$USER_PROF_FIELD_LAST_LOGIN));
        $level = $rr[self::$USER_PROF_FIELD_LEVEL];
        $last_login = $rr[self::$USER_PROF_FIELD_LAST_LOGIN];

        $user_rds->hset($user_key, self::$USER_PROF_FIELD_LAST_LOGIN, $time);
        $user_rds->close();
        if ($level === false) {
            syslog(LOG_ERR, "fail to get level for $role_id ($user_key)");
            return;
        }

        $rds = $this->redis;

        $hour = intval($time/3600);
        $last_login_hour = intval($last_login/3600);
        if ($hour != $last_login_hour) {
            if ($hour - $last_login_hour < 24) {
                # delete from old hour set
                $this->delRoleFromSet($rds, $role_id, $last_login_hour, $level);
            }
            # add to new set
            $this->addRoleToSet($rds, $role_id, $hour, $level);
        } else {
            syslog(LOG_DEBUG, "login hour not changed");
        }
        $rds->close();
    }

    public function delRoleFromSet($rds, $role_id, $hour, $level) {
        $lt_key = sprintf(self::$USER_LEVEL_TIME_KEY, $level, $hour);
        $r = $rds->srem($lt_key, $role_id);
        syslog(LOG_DEBUG, "del $role_id from $lt_key: $r");
        if ($r) {
            $ltd_key = sprintf(self::$USER_LEVEL_TIME_DIST_KEY, $hour);
            $r = $rds->hincrBy($ltd_key, $level, -1);
            if ($r < 0) {
                syslog(LOG_ERR, "delrole($role_id, $hour, $level))".
                    " inconsistent condition: success to deletel from old level set,".
                   " but fail to decrease summary count");
            }
        } else {
            syslog(LOG_ERR, "delrole($role_id, $hour, $level))".
                " inconsistent condition: fail to delete from old set $lt_key");
        }
    }

    public function addRoleToSet($rds, $role_id, $hour, $level) {
        $lt_key = sprintf(self::$USER_LEVEL_TIME_KEY, $level, $hour);
        $ltd_key = sprintf(self::$USER_LEVEL_TIME_DIST_KEY, $hour);
        $added = $rds->sadd($lt_key, $role_id);
        syslog(LOG_DEBUG, "add $role_id to $lt_key: $added");
        if ($added == 1) {
            $r = $rds->hincrBy($ltd_key, $level, 1);
            if ($r == 1) {
                $expire = ($hour+25)*3600;
                $rds->expireAt($lt_key, $expire);
                $rds->expireAt($ltd_key, $expire); // may duplicte, but does not matter
            }
        } else {
            syslog(LOG_INFO, "addRoleToSet($role_id, $hour, $level)".
                " already in new level set $lt_key");
        }
    }

    /*
     * trigger
     */
    public function levelUpEvent($role_id, $orig_level, $new_level) {
        syslog(LOG_DEBUG, "levelUpEvent($role_id, $orig_level, $new_level)");
        # get last login time
        $user_rds = new \redis();
        $user_rds->connect('localhost', 6379);
        $user_key = sprintf(self::$USER_PROF_KEY, $role_id);
        $last_login = $user_rds->hget($user_key, self::$USER_PROF_FIELD_LAST_LOGIN);
        $user_rds->close();
        $last_hour = intval($last_login/3600);
        $curr_hour = intval(time()/3600);

        $rds = $this->redis;
        echo "$curr_hour - $last_hour\n";
        if ($curr_hour - $last_hour < 24) {
            # delete it from old level
            $this->delRoleFromSet($rds, $role_id, $last_hour, $orig_level);
            $this->addRoleToSet($rds, $role_id, $last_hour, $new_level);
        }
    }

    /*
     * find $num users between start_level and end_level (inclusive)
     * exclude user itself
     * find user from random hours
     */
    public function findUsers($start_level, $end_level, $num) {
        syslog(LOG_DEBUG, "mercenary findUsers($start_level, $end_level, $num)");
        $rds = $this->redis;

        if ($start_level > $end_level || !$num) {
            return array();
        }

        $curr_hour = intval(time()/3600);
        $hour = $curr_hour;
        $lvls = array();
        for ($lvl=$start_level;$lvl<=$end_level;$lvl++) {
            $lvls []= $lvl;
        }
        $total_distr = array();
        $sum = 0;
        for ($i=0; $i<24; $i++) {
            $ltd_key = sprintf(self::$USER_LEVEL_TIME_DIST_KEY, $hour);
            $dist = $rds->hmget($ltd_key, $lvls);
            if (empty($dist)) continue;
            for ($lvl=$start_level;$lvl<=$end_level;$lvl++) {
                if (isset($dist[$lvl])) {
                    $lt_key = sprintf(self::$USER_LEVEL_TIME_KEY, $lvl, $hour);
                    $total_distr[$lt_key] = $dist[$lvl];
                    $sum += $dist[$lvl];
                }
            }
            if ($sum > 5*$num) {
                # enough samples
                break;
            }
            $hour--;
        }
        if ($sum <= $num) {
            syslog(LOG_DEBUG, "fetch all");
            $users = array();
            foreach ($total_distr as $key=> $count) {
                $users = array_merge($users, $rds->smembers($key));
            }
            $rds->close();
            return $users;
        }
        $rand_offsets = array();
        while (count($rand_offsets) < $num) {
            $offset = mt_rand(0, $sum-1);
            $rand_offsets[$offset] = 1;
        }
        $offsets = array_keys($rand_offsets);
        $offsets = sort($offsets, SORT_NUMERIC);
        $users = array();
        
        list(,$offset) = each($offsets);
        $sum = 0;
        foreach ($total_distr as $key=> $count) {
            $c = 0;
            while ($offset!==null && $offset < $sum+$count) {
                list(,$offset) = each($offsets);
                $c++;
            }
            if ($c > 0) {
                $users = array_merge($rds->srandmembers($key, $c)); // redis 2.6+ required
            }
            if ($offset===null)
                break;
            $sum += $count;
        }
        $rds->close();
        return $users;
    }
}

/*
function test() {
    $lib = new UserActiveIndexLib();
    #$lib->loginEvent(162, time());
    #$lib->loginEvent(145, time());
    $lib->levelUpEvent(145, 5, 3);
    #$users = $lib->findUsers(0, 5, 2);
    #var_dump($users);
}

openlog("zcc-cap", LOG_PID|LOG_PERROR, LOG_LOCAL0);
test();
*/

