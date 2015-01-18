<?php

require dirname(__FILE__).'/../../../api/libraries/UserActiveIndexLib.php';
require_once "baseworker.php";

/*
 * update user profile delta data(integer)
 */
class ProfChange extends BaseWorker{

    /*
     * fields should be of type integer
     */
    public function perform() {
        syslog(LOG_DEBUG, "profchange worker working");
        if (!isset($this->args['uid'])) {
            syslog(LOG_WARNING, "profchange: role_id not specfied");
            return;
        }
        $data = $this->args;
        $role_id = $data['uid'];
        unset($data['uid']);
        if (empty($data)) {
            syslog(LOG_DEBUG, 'empty info to update');
            return;
        }
        $fields = array();
        $values = array();
        foreach ($data as $prof=>$val) {
            syslog(LOG_DEBUG, "update $role_id.$prof=$val");
            $fields[] = "$prof=$prof+$val";
            $values[] = $val;
        }
        $fields_update = implode(',', $fields);
        $mysqli = $this->getDbConn();
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            $mysqli->close();
            return;
        }
        $tbl_name = 'user';
        $sql = "update $tbl_name set $fields_update where id=$role_id";
        syslog(LOG_DEBUG, "sql:$sql");
        $res = $mysqli->query($sql);
        if ($res == false) {
            syslog(LOG_ERR, "fail to update $fields_update for $role_id:".$mysqli->error);
        }
        if ($mysqli->affected_rows == 0) {
            syslog(LOG_INFO, "nothing updated for $role_id");
        }
        $mysqli->close();
    }
}

/*
 * login event
 */
class Login {

    public function perform() {
        # update useractivetime_level index 
        syslog(LOG_DEBUG, "User login event -- update login level index");
        $data = $this->args;
        if (!isset($data['uid']) || !isset($data['time'])) {
            syslog('miss args');
            return;
        }
        $role_id = $data['uid'];
        $time = $data['time'];

        $idx_lib = new UserActiveIndexLib();
        $idx_lib->loginEvent($role_id, $time);
    }
}

class LevelUp {
    public function perform() {
        syslog(LOG_DEBUG, "User Levelup event -- update login level index");
        $data = $this->args;
        if (!isset($data['uid']) || !isset($data['old_level']) || !isset($data['new_level'])) {
            syslog('miss args');
            return;
        }
        $old_level = $data['old_level'];
        $new_level = $data['new_level'];

        $idx_lib = new UserActiveIndexLib();
        $idx_lib->levelUpEvent($role_id, $old_level, $new_level);
    }
}
