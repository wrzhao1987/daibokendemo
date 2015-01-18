<?php

namespace Cap\Models\Db;

class SubAccountModel extends BaseModel {

	public $store_cols = array('id', 'account_id', 'server_id', 'create_time');
	public $sql_array = array(
        'find_by_id'   => 'SELECT * from __TABLE_NAME__ WHERE id = :id:',
        'find_by_account' => 'SELECT * from __TABLE_NAME__ WHERE email = :email:',
        'create_new' => 'INSERT INTO __TABLE_NAME__ (account_id, server_id, create_time) 
            VALUES (:account_id:, :server_id:, now())',
    );

	public function initialize() {
		$this->setConnectionService('account_db');
	}

	public function getsource() {
		return "sub_account";
	}

}
