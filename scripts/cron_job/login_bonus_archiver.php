<?php

require "baseworker.php";

/*
 * worker to archive last month's redis login bonus records to mysql
 * crontab or just manually operation
 */

class LoginBonusArchiver extends BaseWorker {

    public static $SIGN_BONUS_KEY_PREFIX = 'signbonus:%02s:'; // placeholder:[month, uid]
    public static $ACCU_FIELD_PREFIX = 'accu:';
    public static $TABLE_PREFIX = 'login_bonus_';
    public static $ACCU_TABLE_PREFIX = 'accu_login_bonus_';

    public function createTable($year_month) {
        $mysqli = $this->getDbConn();
        $table_name = self::$TABLE_PREFIX.preg_replace('/-/', '_', $year_month);
        $sql = "create table if not exists $table_name (id int primary key auto_increment, user_id int unsigned not null, bonus_day tinyint, accept_ts int, created_at timestamp default current_timestamp, unique index idx_ud(user_id, bonus_day))";
        $r = $mysqli->query($sql);
        if (!$r) {
            syslog(LOG_ERR, "error in create table $table_name:".$mysqli->error);
        }
        syslog(LOG_DEBUG, "created table $table_name");
        var_dump($r);
        return $table_name;
    }

    public function createAccuTable($year_month) {
        $mysqli = $this->getDbConn();
        $table_name = self::$ACCU_TABLE_PREFIX.preg_replace('/-/', '_', $year_month);
        $sql = "create table if not exists $table_name (id int primary key auto_increment, user_id int unsigned not null, accu_value tinyint, accept_ts int, created_at timestamp default current_timestamp, unique index idx_ud(user_id, accu_value))";
        $r = $mysqli->query($sql);
        if (!$r) {
            syslog(LOG_ERR, "error in create table $table_name:".$mysqli->error);
        }
        syslog(LOG_DEBUG, "created table $table_name");
        var_dump($r);
        return $table_name;
    }

    /*
     * delete the key from redis and insert it into mysql
     */
    public function performTask($year_month) {
        syslog(LOG_INFO, "LoginBonusArchiver:performTask($year_month)");
        $rds = $this->getRedis();
        $mysqli = $this->getDbConn();
        $table_name = $this->createTable($year_month);
        $accu_table_name = $this->createAccuTable($year_month);

        $key_prefix = sprintf(self::$SIGN_BONUS_KEY_PREFIX, $year_month);
        $keys = $rds->keys($key_prefix."*");
        foreach ($keys as $key) {
            $parts = explode(':', $key);
            if (count($parts) != 3) {
                syslog(LOG_ERR, "LoginBonusArchiver task: unexpected key $key");
                continue;
            }
            $month = $parts[1];
            $uid = $parts[2];
            $data = $rds->hgetall($key);
            syslog(LOG_DEBUG, "archive month $month login bonus for $uid:".json_encode($data));
            $values = array();
            $accu_values = array();
            foreach ($data as $bday=>$aday) {
                if (strncmp($bday, self::$ACCU_FIELD_PREFIX, strlen(self::$ACCU_FIELD_PREFIX))) {
                    $values []= "($uid, $bday, $aday)";
                } else {
                    // accumated award accu:7
                    $accu_value = substr($bday, strlen(self::$ACCU_FIELD_PREFIX));
                    $accu_value = intval($accu_value);
                    $accu_values []= "($uid, $accu_value, $aday)";
                }
            }
            if ($values) {
                $valstr = implode(",", $values);
                $sql = "insert into $table_name (user_id, bonus_day, accept_ts) values $valstr";
                if (!($r=$mysqli->query($sql))) {
                    syslog(LOG_ERR, "error in insert $table_name:".$mysqli->error.", sql:$sql");
                }
            }
            if ($accu_values) {
                $valstr = implode(",", $accu_values);
                $sql = "insert into $accu_table_name (user_id, accu_value, accept_ts) values $valstr";
                if (!($r=$mysqli->query($sql))) {
                    syslog(LOG_ERR, "error in insert $accu_table_name:".$mysqli->error.", sql:$sql");
                }
            }
            syslog(LOG_INFO, "archived key [$key]");
        }
        $mysqli->close();
    }
}

function work() {
    openlog("zcc-cap-task-bonus", LOG_PID|LOG_PERROR, LOG_LOCAL0);
    $archiver = new LoginBonusArchiver();
    $ts = time();
    $month = date('Y-m', $ts);
    $archiver->performTask($month);
}

work();


