<?php

namespace Cap\Libraries;

class BattleLib extends BaseLib {

    public static $BATTLE_ID_GEN_KEY = 'battle_id_gen_%s';
    public static $BATTLE_INFO_KEY = 'battle:%s:%s';
    public static $BATTLE_INFO_FIELD_ROLE = 'role';
    public static $BATTLE_INFO_FIELD_TARGET = 'target';
    public static $BATTLE_TYPE_PVP_RANK = 1;
    public static $BATTLE_TYPE_PVP_ROB = 2;
    public static $BATTLE_TYPE_PVE_NORMAL = 3;
    public static $BATTLE_TYPE_PVE_ELITE = 4;
    public static $BATTLE_TYPE_PVE_SUB1 = 5; // Rabbit Legion
    public static $BATTLE_TYPE_PVE_SUB2 = 6; // Red Ribbon Legion
    public static $BATTLE_TYPE_PVE_SUB3 = 7; // Ginyu special team
    public static $BATTLE_TYPE_PVE_SUB4 = 8; // Fried rice Legion
    public static $BATTLE_TYPE_PVE_SUB5 = 9; // Flisa Legion
    public static $BATTLE_TYPE_GUILD_BOSS = 10; // guild boss
    public static $BATTLE_INFO_EXPIRE = 3600;

    public function __construct() {
        parent::__construct();
        $this->_di->set("battle_history_model", function () {
            return new \Cap\Models\db\BattleHistoryModel();
        }, true);
        $this->_di->set("resque_lib", function () {
            return new \Cap\Libraries\ResqueLib();
        }, true);
    }

    /*
     * prepare a uncommited battle
     * return battle id
     */
    public function prepareBattle($role_id, $target, $extra_info, $type, $rds=false) {
        if (!$rds) {
            $rds = $this->_di->getShared('redis');
        }
        $battle_id_key = sprintf(self::$BATTLE_ID_GEN_KEY, $type);
        $battle_id = $rds->incr($battle_id_key);
        $battle_info_key = sprintf(self::$BATTLE_INFO_KEY, $type, $battle_id);
        $extra_info[self::$BATTLE_INFO_FIELD_ROLE] = $role_id;
        $extra_info[self::$BATTLE_INFO_FIELD_TARGET] = $target; // may be section or other user
        $rds->hmset($battle_info_key, $extra_info);
        $rds->expire($battle_info_key, self::$BATTLE_INFO_EXPIRE);
        # done: enqueue task to record battle history
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('battle', 'battleprepare', array('id'=>$battle_id, 'type'=>$type, 'uid'=>$role_id, 'target'=>$target));

        syslog(LOG_DEBUG, "prepared battle $type:$battle_id for $role_id attack $target");

        // 参与度统计埋点
        if (in_array($type, [self::$BATTLE_TYPE_PVE_SUB1, self::$BATTLE_TYPE_PVE_SUB2])) {
            $join_type = KpiLib::$EVENT_TYPE_WANTED;
        } else if (in_array($type, [self::$BATTLE_TYPE_PVE_SUB3, self::$BATTLE_TYPE_PVE_SUB4, self::$BATTLE_TYPE_PVE_SUB5])) {
            $join_type = KpiLib::$EVENT_TYPE_CHALLENGE;
        } else if (self::$BATTLE_TYPE_PVE_ELITE == $type) {
            $join_type = KpiLib::$EVENT_TYPE_HERO_MISSON;
        } else if (self::$BATTLE_TYPE_GUILD_BOSS == $type) {
            $join_type = KpiLib::$EVENT_TYPE_GUILD_BOSS;
        } else if (self::$BATTLE_TYPE_PVP_ROB == $type) {
            $join_type = KpiLib::$EVENT_TYPE_DBALL_ROB;
        } else if (self::$BATTLE_TYPE_PVP_RANK == $type) {
            $join_type = KpiLib::$EVENT_TYPE_ARENA;
        }
        if (isset ($join_type)) {
            (new KpiLib())->recordSysJoin($role_id, $join_type);
        }
        return $battle_id;
    } 

    /*
     * commit a battle
     * return battle info
     * return false if battle invalid
     */
    public function commitBattle($role_id, $battle_id, $type, $result, $extra_info, $rds=false) {
        if (!$rds) {
            $rds = $this->_di->getShared('redis');
        }
        $battle_info_key = sprintf(self::$BATTLE_INFO_KEY, $type, $battle_id);
        $battle_info = $rds->hgetall($battle_info_key);
        if (!$battle_info) {
            syslog(LOG_INFO, "battle info for user:$role_id, battle:$battle_id, type:$type not found");
            return false;
        }
        $saved_role_id = $battle_info[self::$BATTLE_INFO_FIELD_ROLE];
        $target = $battle_info[self::$BATTLE_INFO_FIELD_TARGET];
        if ($saved_role_id != $role_id) {
            syslog(LOG_INFO, "battle info for user:($role_id vs $saved_role_id), battle:$battle_id, type:$type not match");
            return false;
        }
        $rds->del($battle_info_key);
        # done: enqueue task to record/update battle history
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('battle', 'battlecommit', array('id'=>$battle_id, 
            'type'=>$type, 'r'=>$result, 'info'=>$extra_info, 'uid'=>$role_id,
            'target'=>$target));

        syslog(LOG_DEBUG, "commited battle $type:$battle_id for $role_id, result=$result");
        return $battle_info;
    }

    /*
     * set battle gain
     */
    public function battleGain($battle_id, $type, $gain, $rds=false) {
        if (!$rds) {
            $rds = $this->_di->getShared('redis');
        }
        # done: enqueue task to update battle gain
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('battle', 'battlegain', array('id'=>$battle_id, 'type'=>$type, 'gain'=>$gain));
    }

    /*
     * get battle history
     */
    public function getHistory($type, $role_id) {
        syslog(LOG_DEBUG, "battle get history($type, $role_id)");
        $records = array();
        $battle_model = $this->_di->getShared('battle_history_model');
        switch ($type) {
        case BattleLib::$BATTLE_TYPE_PVP_RANK:
            $battle_model->settable('battle_history_rank');
            break;
        case BattleLib::$BATTLE_TYPE_PVP_ROB:
            $battle_model->settable('battle_history_rob');
            break;
        default:
            syslog(LOG_ERR, "battle get history unsupported type $type");
            return $records;
        }
        $rs = $battle_model->findByAttacker($role_id);
        foreach ($rs as $row) {
            $info = array();
            $info['attacker'] = $row['attacker'];
            $info['target'] = $row['target'];
            $info['result'] = $row['result'];
            $info['battle_id'] = $row['battle_id'];
            if ($row['gain'] != null) {
                $info['gain'] = json_decode($row['gain']);
            }
            $info['time'] = strtotime($row['created_at']);
            $records[]= $info;
        }
        // defence
        $rs = $battle_model->findByTarget($role_id);
        foreach ($rs as $row) {
            $info = array();
            $info['attacker'] = $row['attacker'];
            $info['target'] = $row['target'];
            $info['result'] = $row['result'];
            $info['battle_id'] = $row['battle_id'];
            if ($row['gain'] != null) {
                $info['gain'] = json_decode($row['gain']);
            }
            $info['gain'] = $row['gain'];
            $info['time'] = strtotime($row['created_at']);
            $records[]= $info;
        }
        return $records;
    }
}

// end of file
