<?php
require_once "baseworker.php";

class Best_Rank extends BaseWorker{

    public function perform() {
        syslog(LOG_DEBUG, "bestrank job perform task");
        if (!isset($this->args['rank']) || !isset($this->args['role_id'])) {
            syslog(LOG_ERR, "rank or role_id not passed in");
            return;
        }
        $new_rank = $this->args['rank'];
        $role_id = $this->args['role_id'];

        $mysqli = $this->getDbConn();
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            $mysqli->close();
            return;
        }   

        // update to mysql
        $sql = "update pvp_prof set best_rank=$new_rank where role_id=$role_id and best_rank>$new_rank";
        syslog(LOG_DEBUG, "$sql");
        $res = $mysqli->query($sql);
        if ($res == false) {
            syslog(LOG_WARNING, "fail to updat best rank $new_rank for $role_id to db");
        } else {
            syslog(LOG_INFO, "updated best rank $new_rank for $role_id to db");
        }
    }
}
