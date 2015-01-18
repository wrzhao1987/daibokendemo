<?php
require_once "baseworker.php";

function getMissionTableName($type) {
}

/*
 * update best point
 */
class BestPoint extends BaseWorker{

    public function perform() {
        syslog(LOG_DEBUG, "mission bestpoint worker working");
        if (!isset($this->args['uid']) || !isset($this->args['sec']) 
            || !isset($this->args['point']) || !isset($this->args['type'])) {
            syslog(LOG_WARNING, "profchange: role_id not specfied");
            return;
        }
        $role_id = $this->args['uid'];
        $section_id = $this->args['sec'];
        $point = $this->args['point'];
        $type = $this->args['type'];

        $mysqli = $this->getDbConn();
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            $mysqli->close();
            return;
        }
        $shard_suffix = $role_id % $this->user_shard_suffix;
        if ($type == 0) {
            $tbl_name = sprintf('user_mission_%02d', $shard_suffix); # add shard suffix
        } else if ($type == 1) {
            $tbl_name = sprintf('user_elite_mission_%02d', $shard_suffix); # add shard suffix
        } else if ($type == 2) {
            $tbl_name = 'user_mission_tl2';
        } else if ($type == 3) {
            $tbl_name = 'user_mission_tl3';
        } else if ($type == 4) {
            $tbl_name = 'user_mission_tl4';
        } else if ($type == 5) {
            $tbl_name = 'user_mission_tl5';
        } else if ($type == 6) {
            $tbl_name = 'user_mission_tl6';
        } else {
            syslog(LOG_ERR, "unsupported mission type $type");
            $mysqli->close();
            return;
        }
        $sql = "insert into $tbl_name (role_id, section_id, best_point, created_at) values ($role_id, $section_id, $point, now()) on duplicate key update best_point=$point";
        syslog(LOG_DEBUG, "sql:$sql");
        $res = $mysqli->query($sql);
        if ($res == false) {
            syslog(LOG_ERR, "fail to set best point $point for $role_id:".$mysqli->error);
        }
        if ($mysqli->affected_rows == 0) {
            syslog(LOG_INFO, "nothing updated for $role_id");
        }
        $mysqli->close();
    }
}


/*
 * mission start attack
 */
class MissionAttack extends BaseWorker{

    public function perform() {
        syslog(LOG_DEBUG, "mission attack worker working");

        $data = $this->args;
        if (!isset($data['sec']) || !isset($data['uid']) || !isset($data['btl']) || !isset($data['type'])) {
            syslog(LOG_INFO, 'missionattck, incomplete argment');
            return;
        }

        $section_id = $data['sec'];
        $role_id = $data['uid'];
        $btl = $data['btl'];
        $type = $data['type'];

        $mysqli = $this->getDbConn();
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            $mysqli->close();
            return;
        }

        # 1. update statistic
        $shard_suffix = $role_id % $this->user_shard_suffix;
        if ($type == 0) {
            $tbl_name = sprintf('user_mission_%02d', $shard_suffix); # add shard suffix
        } else if ($type == 1) {
            $tbl_name = sprintf('user_elite_mission_%02d', $shard_suffix); # add shard suffix
        } else if ($type == 2) {
            $tbl_name = 'user_mission_tl2';
        } else if ($type == 3) {
            $tbl_name = 'user_mission_tl3';
        } else if ($type == 4) {
            $tbl_name = 'user_mission_tl4';
        } else if ($type == 5) {
            $tbl_name = 'user_mission_tl5';
        } else if ($type == 6) {
            $tbl_name = 'user_mission_tl6';
        } else {
            syslog(LOG_ERR, "unsupported mission type $type");
            $mysqli->close();
            return;
        }
        $sql = "update $tbl_name set nattempt=nattempt+1 where role_id=$role_id and section_id=$section_id";
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        } else if ($mysqli->affected_rows == 0) {
            syslog(LOG_INFO, "mission attack job: add new section ($role_id@$section_id");
            $sql = "insert into $tbl_name (role_id, section_id, nattempt, created_at) values ($role_id, $section_id, 1, now())";
            $r = $mysqli->query($sql);
            if ($r===false) {
                syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
            }
        }

        # 2. record history
        $tbl = "mission_attack_history";
        $sql = "insert into $tbl (role_id, type, section_id, battle_id, result, created_at) values ($role_id, $type, $section_id, $btl, 2, now())";
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        }
        $mysqli->close();
    }
}

/*
 * mission commit
 */
class MissionCommit extends BaseWorker{

    public function perform() {
        syslog(LOG_DEBUG, "mission commit worker working");
        $data = $this->args;
        if (!isset($data['sec']) || !isset($data['uid']) || !isset($data['btl']) || !isset($data['r']) || !isset($data['type'])) {
            syslog(LOG_INFO, 'missioncommit, incomplete argument');
            return;
        }

        $section_id = $data['sec'];
        $role_id = $data['uid'];
        $result = $data['r'];
        $btl = $data['btl'];
        $type = $data['type'];

        $mysqli = $this->getDbConn();
        if ($mysqli->connect_errno) {
            syslog(LOG_ERR, "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
            $mysqli->close();
            return;
        }

        # 1. update statistic
        $shard_suffix = $role_id % $this->user_shard_suffix;
        $tbl_name = sprintf("user_mission_%02d", $shard_suffix); # add shard suffix
        if ($type == 0) {
            $tbl_name = sprintf('user_mission_%02d', $shard_suffix); # add shard suffix
        } else if ($type == 1) {
            $tbl_name = sprintf('user_elite_mission_%02d', $shard_suffix); # add shard suffix
        } else if ($type == 2) {
            $tbl_name = 'user_mission_tl2';
        } else if ($type == 3) {
            $tbl_name = 'user_mission_tl3';
        } else if ($type == 4) {
            $tbl_name = 'user_mission_tl4';
        } else if ($type == 5) {
            $tbl_name = 'user_mission_tl5';
        } else if ($type == 6) {
            $tbl_name = 'user_mission_tl6';
        } else {
            syslog(LOG_ERR, "unsupported mission type $type");
            $mysqli->close();
            return;
        }
        if ($result = 1) {
            $sql = "update $tbl_name set npass=npass+1 where role_id=$role_id and section_id=$section_id";
        } else {
            $sql = "update $tbl_name set nfail=nfail+1 where role_id=$role_id and section_id=$section_id";
        }
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        } else if ($mysqli->affected_rows == 0) {
            syslog(LOG_ERR, "attackcommit none affected: [$sql]");
        }
        syslog(LOG_DEBUG, "affected rows:".$mysqli->affected_rows);

        # 2. record history
        $tbl = "mission_attack_history";
        $sql = "update $tbl set result=$result where battle_id=$btl and type=$type";
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        } else if ($mysqli->affected_rows == 0) {
            syslog(LOG_ERR, "attackcommit none affected: [$sql]");
        }
        syslog(LOG_DEBUG, "affected rows:".$mysqli->affected_rows);
        $mysqli->close();
    }
}

