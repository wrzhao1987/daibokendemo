<?php

require_once(__DIR__."/../../config/common.php");

class FragmentIndexLib {

    public static $FRAG_LEVEL_KEY = "fl:%s:%s";
    public static $FRAG_LEVEL_DISTRIBUTION_KEY = "fl_distr";
    public static $SHARD_RADIX = 100;

    public function __construct() {
        $rds = new \redis();
        $rds->connect('127.0.0.1', 6371);
        $this->redis = $rds;
    }

    protected function getUserRedis() {
        if (isset($this->user_redis)) {
            return $this->user_redis;
        }
        $rds = new \redis();
        global $settings;
        $rds->connect($settings['redis']['default']['host'], $settings['redis']['default']['port']);
        $this->user_redis = $rds;
        return $rds;
    }

    /*
     * create index for (dragonball_fragment, level) => user
     */
    public function createIndex() {
        $mysqli = new mysqli("127.0.0.1", "root", "namisan", "nami", 3306);
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            return;
        }
        $rds = $this->redis;
        $user_tbl = "user"; 
        $distribution = array();
        for ($suffix=0; $suffix<100; $suffix++) {
            $frag_tbl = sprintf("dragonball_fragment_%02d", $suffix); // shard 
            $sql = "select level, fragment_no, group_concat($user_tbl.id) as idgroup from $user_tbl join $frag_tbl on $user_tbl.id=$frag_tbl.role_id group by fragment_no, level";
            syslog(LOG_INFO, "$sql");
            if ($res=$mysqli->query($sql)) {
                while($obj=$res->fetch_object()) {
                    syslog(LOG_DEBUG, "got: ".$obj->fragment_no.":".$obj->level."=> ".$obj->idgroup."");
                    $key = sprintf(self::$FRAG_LEVEL_KEY, $obj->fragment_no, $obj->level);
                    $ids = explode(',', $obj->idgroup);
                    if (!isset($distribution[$key])) {
                        $distribution[$key] = 0;
                    }
                    foreach ($ids as $id) {
                        $score = $id;
                        $rds->zadd($key, $score, $id);
                        $distribution[$key]++;
                    }
                }
                $res->close();
            } else {
                syslog(LOG_ERR, "error in mysql: ".$mysqli->error);
                return;
            }
        }
        $rds->hmset(self::$FRAG_LEVEL_DISTRIBUTION_KEY, $distribution);
    }

    public function levelUp($role_id, $old_level, $new_level) {
        syslog(LOG_DEBUG, "levelUp($role_id, $old_level, $new_level)");
        # get all fragment no of role_id
        $rds = $this->redis;
        $suffix = $role_id % self::$SHARD_RADIX;
        $frag_tbl = sprintf("dragonball_fragment_%02d", $suffix); // shard 
        $sql = "select role_id, fragment_no, count from $frag_tbl where role_id = $role_id";
        $dkey = self::$FRAG_LEVEL_DISTRIBUTION_KEY;
        syslog(LOG_INFO, "$sql");
        for ($fno=0;$fno<42;$fno++) {
            syslog(LOG_INFO, "update $role_id level for $fno");
            $old_key = sprintf(self::$FRAG_LEVEL_KEY, $fno, $old_level);
            $n = $rds->zrem($old_key, $role_id);
            if ($n) {
                syslog(LOG_INFO, "update $role_id level for $fno");
                $rds->hincrBy($dkey, $old_key, -1);
                $new_key = sprintf(self::$FRAG_LEVEL_KEY, $fno, $new_level);
                $n = $rds->zadd($new_key, $role_id, $role_id);
                if ($n)
                    $rds->hincrBy($dkey, $new_key, 1);
            }
        }
    }

    /*
     * a user got one or lost all of some kind fragement
     */
    public function fragmentPresentChange($role_id, $fragment_no, $present) {
        syslog(LOG_DEBUG, "fragmentPresentChange($role_id, $fragment_no, $present)");
        $rds = $this->redis;
        $urds = $this->getUserRedis();
        $level = $urds->hget("role:$role_id", 'level');
        syslog(LOG_DEBUG, "fragement $fragment_no present($present) on $role_id(lvl$level)");
        $key = sprintf(self::$FRAG_LEVEL_KEY, $fragment_no, $level);
        if (!$present) {
            $deleted = $rds->zrem($key, $role_id);
            if ($deleted == "0") {
                syslog(LOG_WARNING, "WARN: nothing to remove $role_id from $key");
            } else {
                $rds->hincrBy(self::$FRAG_LEVEL_DISTRIBUTION_KEY, $key, -1);
            }
        } else {
            $added = $rds->zadd($key, $role_id, $role_id);
            if ($added) {
                $r = $rds->hincrBy(self::$FRAG_LEVEL_DISTRIBUTION_KEY, $key, 1);
                syslog(LOG_DEBUG, "hincr $key ==> $r");
            } else {
                syslog(LOG_INFO, "$role_id already in $key");
            }
        }
    }

    /*
     * get opponents who has the fragments, between specified level range
     * return array of user=>level
     */
    public function findOpponents($start_level, $end_level, $fragments, $num) {
        $rds = $this->redis;
        syslog(LOG_DEBUG, "findOpponents($start_level, $end_level, $num)");
        if ($num <=0 || !$fragments || $start_level>$end_level) {
            return array();
        }
        $keys = array();
        for ($lvl=$start_level;$lvl<=$end_level;$lvl++) {
            foreach ($fragments as $fragment_no) {
                $key = sprintf(self::$FRAG_LEVEL_KEY, $fragment_no, $lvl);
                $keys["$lvl:$fragment_no"]= $key;
            }
        }
        $d = $rds->hmget(self::$FRAG_LEVEL_DISTRIBUTION_KEY, $keys);
        $sum = 0;
        foreach ($keys as $lvl_frag=>$k) {
            $v = $d[$k];
            if (!$v) {
                unset($keys[$lvl_frag]);
                continue;
            }
            $sum += $v;
        }
        syslog(LOG_DEBUG, "num:$num/$sum\n");
        $result = array();
        if ($sum == 0) {
            return array();
        } else if ($sum <= $num) {
            // fetch all
            syslog(LOG_DEBUG, "fetch all \n");
            foreach ($keys as $lvl_frag=>$key) {
                $v = $d[$key];
                #if (!$v) continue;
                $arr = $rds->zrange($key, 0, -1);
                foreach ($arr as $e)  {
                    $result[$e] = array($lvl_frag);
                }
            }
            return $result;
        }
        $offsets = array();
        while (count($offsets) < $num) {
            $offset = mt_rand(0, $sum-1);
            $offsets[$offset]= 1;
        }
        $sum = 0;
        $i = 0;
        $offsets = array_keys($offsets);
        sort($offsets, SORT_NUMERIC);
        $offset = $offsets[$i];

        foreach ($keys as $lvl_frag=>$key) {
            $v = $d[$key];
            #if (!$v) continue;
            while ($offset < ($sum+$v)) {
                syslog(LOG_DEBUG, "fetch $key, offset ".($offset-$sum));
                $arr = $rds->zrange($key, $offset-$sum, $offset-$sum);
                if ($arr) {
                    if (!isset($result[$arr[0]])) {
                        $result[$arr[0]] = array($lvl_frag);
                    } else {
                        $result[$arr[0]][] = $lvl_frag;
                    }
                } else {
                    syslog(LOG_WARNING, '===empty range for '.$key.' -- '.($offset-$sum));
                }
                $i++;
                if ($i>=count($offsets)) {
                    syslog(LOG_DEBUG, "find all $i users\n");
                    return $result;
                }
                $offset = $offsets[$i];
            }
            $sum += $v;
        }
        return $result;
    }
}

function test() {
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    openlog('fragindex', LOG_PID|LOG_PERROR, LOG_LOCAL0);
    $t = new FragmentIndexLib();
    #$t->createIndex();
    #$t->levelUp(270, 38, 39);
    $t->fragmentPresentChange(270, 84, 0);
    $users = $t->findOpponents(35,40, [84], 4);
    var_dump($users);
}

#test();

