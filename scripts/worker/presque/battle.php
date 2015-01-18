<?php

require_once "baseworker.php";

/*
 * battle attack start
 */
class BattlePrepare extends BaseWorker{

    public function perform() {
        syslog(LOG_DEBUG, "battle prepare worker working");

        $data = $this->args;
        if (!isset($data['id']) || !isset($data['type']) || !isset($data['uid'])
            || !isset($data['target'])) {
            syslog(LOG_INFO, 'battle prepare worker, incomplete arguments');
            return;
        }

        $role_id = intval($data['uid']);
        $target = intval($data['target']);
        $btl_id = intval($data['id']);
        $type = intval($data['type']);

        $mysqli = $this->getDbConn();
        switch ($type) {
        case 1:
            $tbl = "battle_history_rank";
            break;
        case 2:
            $tbl = "battle_history_rob";
            break;
        case 3:
            $tbl = "battle_history_mission";
            $this->sectionAttackStastic($role_id, $target);
            break;
        default:
            syslog(LOG_WARNING, "battleprepare: unknown battle type $type:$btl_id for $role_id attack $target");
            $mysqli->close();
            return;
        }

        # record history
        $sql = "insert into $tbl (battle_id, attacker, target, created_at) values ($btl_id, $role_id, $target, now())";
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        }
        $mysqli->close();
    }

    public function sectionAttackStastic($role_id, $section_id, $type) {
        # update statistic
        $shard_suffix = $role_id % $this->user_shard_suffix;
        $tbl = sprintf("user_mission_%02d", $shard_suffix); # add shard suffix
        $sql = "update $tbl set nattempt=nattempt+1 where role_id=$role_id and section_id=$section_id";
        $mysqli = $this->mysqli;
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        } else if ($mysqli->affected_rows == 0) {
            syslog(LOG_INFO, "mission attack job: add new section ($role_id@$section_id");
            $sql = "insert into $tbl (role_id, section_id, created_at) values ($role_id, $section_id, now())";
            $r = $mysqli->query($sql);
            if ($r===false) {
                syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
            }
        }
    }
}

/*
 * battle commit
 */
class BattleCommit extends BaseWorker{

    public function perform() {
        syslog(LOG_DEBUG, "battle commit worker working");
        $data = $this->args;
        if (!isset($data['id']) || !isset($data['type']) 
            || !isset($data['uid']) || !isset($data['target'])) {
            syslog(LOG_INFO, 'battle commit worker, incomplete arguments');
            return;
        }

        $role_id = intval($data['uid']);
        $target = intval($data['target']);
        $result = intval($data['r']);
        $btl_id = intval($data['id']);
        $type = intval($data['type']);
        if (isset($data['info'])) {
            $info = $data['info'];
        } else {
            $info = false;
        }

        $mysqli = $this->getDbConn();

        switch ($type) {
        case 1:
            $tbl = "battle_history_rank";
            break;
        case 2:
            $tbl = "battle_history_rob";
            break;
        case 3:
            $tbl = "battle_history_mission";
            $this->sectionAttackStastic($role_id, $target, $result);
            break;
        default:
            syslog(LOG_WARNING, "battlecommit: unknown battle type $type:$btl_id for $role_id attack $target");
            $mysqli->close();
            return;
        }

        # record history
        $info = $mysqli->escape_string(json_encode($info));
        $sql = "update $tbl set result=$result, battle_info='$info'  where battle_id=$btl_id";
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        } else if ($mysqli->affected_rows == 0) {
            syslog(LOG_ERR, "attackcommit none affected: [$sql], try insert");
            # try insert
            $sql = "insert into $tbl (battle_id, attacker, target, result, battle_info, created_at) values ($btl_id, $role_id, $target,  $result, '$info', now()) on duplicate key update result=$result, battle_info='$info'";
            $r = $mysqli->query($sql);
            if ($r===false) {
                syslog(LOG_ERR, "battle commit worker: error in execute [$sql]:".$mysqli->error);
            }
        }
        syslog(LOG_DEBUG, "battle $btl_id commit history affected rows:".$mysqli->affected_rows);
        $mysqli->close();
    }

    public function sectionAttackStastic($role_id, $section_id, $result) {
        # 1. update statistic
        $shard_suffix = $role_id % $this->user_shard_suffix;
        $tbl = sprintf("user_mission_%02d", $shard_suffix); # add shard suffix
        $mysqli = $this->mysqli;
        if ($result = 1) {
            $sql = "update $tbl set npass=npass+1 where role_id=$role_id and section_id=$section_id";
        } else {
            $sql = "update $tbl set nfail=nfail+1 where role_id=$role_id and section_id=$section_id";
        }
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        } else if ($mysqli->affected_rows == 0) {
            syslog(LOG_ERR, "attackcommit none affected: [$sql]");
        }
    }
}

/*
 * battle gain
 * update gained items for the battle
 */
class BattleGain extends BaseWorker {

    public function perform() {
        syslog(LOG_DEBUG, "battle gain worker working");
        $data = $this->args;
        if (!isset($data['id']) || !isset($data['type']) || !isset($data['gain'])) {
            syslog(LOG_INFO, 'battle gain worker, incomplete arguments');
            return;
        }
        $btl_id = $data['id'];
        $type = $data['type'];
        $gain = $data['gain'];

        switch ($type) {
        case 1:
            $tbl = "battle_history_rank";
            break;
        case 2:
            $tbl = "battle_history_rob";
            break;
        case 3:
            $tbl = "battle_history_mission";
            break;
        default:
            syslog(LOG_WARNING, "battlegain: unknown battle type $type:$btl_id");
            $mysqli->close();
            return;
        }
        $mysqli = $this->getDbConn();

        $gain = $mysqli->escape_string(json_encode($gain));
        $sql = "update $tbl set gain='$gain'  where battle_id=$btl_id";
        $r = $mysqli->query($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$mysqli->error);
        } else if ($mysqli->affected_rows == 0) {
            syslog(LOG_ERR, "battlegain none affected [$sql]:".$mysqli->error);
        }
        $mysqli->close();
    }
}
