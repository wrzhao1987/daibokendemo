<?php

namespace Cap\Models\db;

class BattleHistoryModel extends BaseModel {

    public $store_cols = array('battle_id', 'attacker', 'target', 'result', 'battle_info', 'gain', 'created_at', 'updated_at'); 

    public $sql_array = array(
        'find_by_attacker'   => 'SELECT * from __TABLE_NAME__ WHERE attacker = :attacker:',
        'find_by_target'   => 'SELECT * from __TABLE_NAME__ WHERE target = :target:',
        'create_new' => 'INSERT INTO __TABLE_NAME__ (battle_id, attacker, target, result, battle_info, created_at) 
            VALUES (:battle_id:, :attacker:, :target:, :result:, :battle_info:, now())',
        'update_gain' => 'UPDATE __TABLE_NAME__ set gain=:gain: where battle_id=:battle_id:',
    );

    public $table_name = 'battle_history_mission';

    public function settable($table) {
        $this->table_name = $table;
    }

    public function getSource() {
        return $this->table_name;
    }

    public function findByAttacker($role_id) {
        $role_id =  intval($role_id);
        $db = \Phalcon\DI::getDefault()->getShared('db');
        $table = $this->table_name;
        $sql = "SELECT * from $table WHERE attacker=? and created_at>DATE_SUB(now(), INTERVAL 1 WEEK)";
        $rs = $db->query($sql, array($role_id));
        if (!$rs) {
            return false;
        }
        $data = $rs->fetchAll();
        return $data;
    }
    public function findByTarget($role_id) {
        $role_id =  intval($role_id);
        $db = \Phalcon\DI::getDefault()->getShared('db');
        $table = $this->table_name;
        $sql = "SELECT * from $table WHERE target=? and created_at>DATE_SUB(now(), INTERVAL 1 WEEK)";
        $rs = $db->query($sql, array($role_id));
        if (!$rs) {
            return false;
        }
        $data = $rs->fetchAll();
        return $data;
    }
}
