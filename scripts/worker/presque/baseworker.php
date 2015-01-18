<?php

class BaseWorker {

    protected $user_shard_suffix = 100;

    protected function getDbConn() {
        $mysqli = new mysqli("127.0.0.1", "root", "namisan", "nami", 3306);
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            $mysqli->close();
            return false;
        }
        $this->mysqli = $mysqli;
        return $mysqli;
    }
}
