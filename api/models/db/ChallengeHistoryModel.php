<?php

namespace Cap\Models\db;


class ChallengeHistoryModel extends BaseModel {

    public $store_cols = array('id', 'attacker', 'defencer', 'result', 'battle_info', 'created_at'); 

    public $sql_array = array(
        'find_by_attacker'   => 'SELECT * from __TABLE_NAME__ WHERE attacker = :attacker:',
        'find_by_defender'   => 'SELECT * from __TABLE_NAME__ WHERE attacker = :defender:',
        'create_new' => 'INSERT INTO __TABLE_NAME__ (attacker, defencer, result, battle_info, created_at) 
            VALUES (:attacker:, :defencer:, :result:, :battle_info:, now())',
    );

    protected $table_name = 'pvp_challenge_history';

    public function setTable($table) {
        $this->table_name = $table;
    }

    public function getSource() {
        return $this->table_name;
    }
}
