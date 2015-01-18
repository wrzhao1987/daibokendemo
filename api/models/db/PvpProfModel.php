<?php

namespace Cap\Models\db;

class PvpProfModel extends BaseModel {

    public $store_cols = array('role_id', 'best_rank', 'init_rank', 'created_at', 'updated_at');

    public $sql_array = array(
        'find_by_id'   => 'SELECT * from __TABLE_NAME__ WHERE role_id = :role_id:',
        'create_new' => 'INSERT INTO __TABLE_NAME__ (role_id, best_rank, init_rank, created_at) 
            VALUES (:role_id:, :best_rank:, :init_rank:, now())',
    );

    public function onConstruct() {
        parent::onConstruct();
    }

    public function getSource() {
        return 'pvp_prof';
    }

    
}
