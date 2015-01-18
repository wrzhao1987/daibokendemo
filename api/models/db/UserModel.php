<?php 
namespace Cap\Models\Db;

class UserModel extends BaseCacheModel
{

	public $redis_ttl = 172800; // 2days
	public $store_cols = array('id', 'account_id', 'name', 'level',
		'exp', 'coin', 'gold', 'energy', 'gcoin', 'token', 'vip', 'newbie', 'charge',
		'honor', 'snake', 'max_section', 'updated_at', 'created_at');
	public function getSource() {
		return 'user';
	}

	public $sql_array = array(
		'find_by_id'   => 'SELECT * from __TABLE_NAME__ WHERE id = :id:',
		'find_by_ids'  => 'SELECT * from __TABLE_NAME__ WHERE id in (:ids:)',
		'find_by_names'  => 'SELECT * from __TABLE_NAME__ WHERE name in (:names:)',
		'find_by_account_id' => 'SELECT * from __TABLE_NAME__ WHERE account_id = :account_id:',
		'update_energy' => 'UPDATE __TABLE_NAME__ SET energy = :energy: WHERE id = :id: ',
		'create_new' => 'INSERT INTO __TABLE_NAME__ (id, account_id, name, level, 
			exp, coin, gold, honor, snake, gcoin, energy, token, vip, max_section, newbie, charge, created_at)
			VALUES (:id:, :account_id:, :name:, 1, 0, 0, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, now())',
		'create_table' => "CREATE TABLE IF NOT EXISTS `user` (
			`id` bigint(20) unsigned NOT NULL,
		  	`account_id` int NOT NULL,
		  	`name` varchar(200) NOT NULL,
			`level` int unsigned NOT NULL DEFAULT 1,
			`exp` int unsigned NOT NULL DEFAULT 0,
			`coin` int unsigned NOT NULL DEFAULT 0,
			`gold` int unsigned NOT NULL DEFAULT 0,
			`honor` int unsigned NOT NULL DEFAULT 0,
            `snake` int unsigned NOT NULL DEFAULT 0,
            `gcoin` int unsigned NOT NULL DEFAULT 0,
			`energy` int unsigned NOT NULL DEFAULT 0,
			`token` int unsigned NOT NULL DEFAULT 0,
			`vip` smallint unsigned NOT NULL DEFAULT 0,
			`max_section` int unsigned NOT NULL DEFAULT 0,
			`newbie` smallint NOT NULL DEFAULT 0,
		  	`updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  	`created_at` datetime NOT NULL,
		  PRIMARY KEY (`id`),
		  KEY `idx_level` (`level`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8",
	);

    public function getUser($id) {
        $users = $this->getUsers(array($id));
        if ($users)
            return $users[0];
        return false;
    }

    public function getUsers($ids) {
        $ids_str = implode(',', $ids);
        $sql = sprintf("SELECT * from __TABLE_NAME__ WHERE id in (%s)", $ids_str);
        $sql = $this->makeSql($sql);
        $rows = $this->getModelsManager()->executeQuery($sql);
        if (!empty($rows)) {
            $data = array();
            foreach ($rows as $row) {
                $item = array();
                foreach ($this->store_cols as $col) {
                    $item[$col] = $row->{$col};
                }   
                $data[] = $item;
            }   
        } else {
            $data = false;
        }
        return $data;
    }

    public function getUsersByName($names) {
        $ids_str = "'" . implode("','", $names) . "'";
        $sql = sprintf("SELECT * from __TABLE_NAME__ WHERE name in (%s)", $ids_str);
        $sql = $this->makeSql($sql);
        $rows = $this->getModelsManager()->executeQuery($sql);
        if (!empty($rows)) {
            $data = array();
            foreach ($rows as $row) {
                $item = array();
                foreach ($this->store_cols as $col) {
                    $item[$col] = $row->{$col};
                }
                $data[] = $item;
            }
        } else {
            $data = false;
        }
        return $data;
    }

    public function findUserByLevelRange($low_level, $high_level, $limit) {
        return array();
    }

    public function updateFields($user_id, $updates) {
        if (empty($updates)) {
            return;
        }
        $arr = array();
        foreach ($updates as $prop=>$val) {
           $arr []= "$prop=:$prop:";
        }
        $sts = "set ".implode(',', $arr);
        $sql = "update __TABLE_NAME__ $sts where id=:id:";
        $updates['id'] = $user_id;
        syslog(LOG_DEBUG, "user update fields ".json_encode($updates));
        $result = $this->executeSQL($sql, $updates);
        if ($result->success()) {
            return true;
        } else {
            $message = "";
            foreach ($result->getMessages() as $msg) {
                $message .= $msg . "\n";
            }
            syslog(LOG_ERR, "error in updateFields($user_id, ...): $message");
            return false;
        }
    }

    /*
     * get all user id
     */
    public function getAllUserIds() {
        $sql = sprintf("SELECT id from __TABLE_NAME__");
        $sql = $this->makeSql($sql);
        $rows = $this->getModelsManager()->executeQuery($sql);
        $ids = array();
        if (!empty($rows)) {
            foreach ($rows as $row) {
                $ids []= $row->id;
            }
        }
        return $ids;
    }

    public function getAllUsers()
    {
        $sql = sprintf("SELECT * from __TABLE_NAME__");
        $sql = $this->makeSql($sql);
        $rows = $this->getModelsManager()->executeQuery($sql);
        return $rows->count() > 0 ? $rows->toArray() : [];
    }
}
