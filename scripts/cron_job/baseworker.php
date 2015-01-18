<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

class BaseWorker {

    protected function getDbConn() {
        $mysqli = new mysqli("127.0.0.1", "root", "stand@123", "cap", 3306);
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            $mysqli->close();
            return false;
        }
        $this->mysqli = $mysqli;
        return $mysqli;
    }

    protected function getRedis() {
        $redis = new redis();
        if (!$redis->connect('127.0.0.1', 6379)) {
            syslog(LOG_ERR, "fail to connect redis");
            return false;
        }
        $this->redis = $redis;
        return $redis;
    }
}
