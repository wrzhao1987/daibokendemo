<?php
namespace Cap\Models\Db;

class UserDragonBallModel extends BaseModel
{
	public $user_id;

	const MYSQL_TABLE_NAME_PREFIX = 'user_dragon_ball_';
	const MYSQL_SHARD_COUNT = 100;

	public $sql_array = array(
        'find_by_id'     => 'SELECT id, dragon_ball_id, level, exp FROM __TABLE_NAME__ WHERE id=:id:',

		'find_by_user'   => 'SELECT id, dragon_ball_id, level, exp FROM __TABLE_NAME__ WHERE user_id = :user_id:',

        'create_new'     => 'INSERT INTO __TABLE_NAME__ (user_id, dragon_ball_id, level, exp, created_at)
                             VALUES (:user_id:, :dragon_ball_id:, 1, 0, NOW())',

		'create_table'   => "CREATE TABLE `user_dragon_ball` (
							  `id` int(11) NOT NULL AUTO_INCREMENT,
							  `user_id` int(11) NOT NULL DEFAULT '0',
							  `dragon_ball_id` int(11) NOT NULL DEFAULT '0',
							  `level` tinyint(4) NOT NULL DEFAULT '1',
							  `exp` int(11) NOT NULL DEFAULT '0',
							  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
							  `created_at` datetime NOT NULL,
							  PRIMARY KEY (`id`),
							  UNIQUE KEY `card_dragon_ball_idx` (`user_id`,`user_card_id`,`dragon_ball_id`)
							) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8",
	);

	public function onConstruct()
	{
		parent::onConstruct();
	}

	public function getSource()
	{
		if (! $this->user_id)
		{
			return substr(self::MYSQL_TABLE_NAME_PREFIX, 0, -1);
		}
		$table_num = sprintf('%02d', $this->user_id % self::MYSQL_SHARD_COUNT);
		return self::MYSQL_TABLE_NAME_PREFIX . $table_num;
	}

	public function getUserDragonBalls($user_id)
	{
		$this->user_id = $user_id;
        $result = [];
		$balls = $this->execute('find_by_user', array('user_id' => $user_id));
        if ($balls->count()) {
            foreach ($balls as $value) {
                $result[$value->id] = $value->toArray();
            }
        }
        return $result;
	}

    /*
     * add a new dragonball to user and return user_dragonball_id
     */
    public function addDragonball($user_id, $dragonball_no) {
		$this->user_id = $user_id;
        $result = $this->execute('create_new', array('user_id'=>$user_id, 'dragon_ball_id'=>$dragonball_no));
        if ($result->success()) {
            syslog(LOG_DEBUG, "success to add dragnoball($dragonball_no) to $user_id:".$result->getModel()->id);
            return $result->getModel()->id;
        } else {
            $message = ""; 
            foreach ($result->getMessages() as $msg) {
                $message .= $msg . "\n";
            }
            syslog(LOG_ERR, "error in add dragnoball($dragonball_no) to $user_id: $message");
            return false;
        }
    }

    public function getDragonball($user_id, $user_dragonball_id) {
		$this->user_id = $user_id;
        $rs = $this->execute('find_by_id', array('id'=>$user_dragonball_id));
        if ($rs) {
            $info = array();
            foreach ($rs as $row) {
                $info['id'] = $row->id;
                $info['level'] = $row->level;
                $info['exp'] = $row->exp;
                $info['dragon_ball_id'] = $row->dragon_ball_id;
            }
            return $info;
        } else {
            $message = ""; 
            foreach ($rs->getMessages() as $msg) {
                $message .= $msg . "\n";
            }
            syslog(LOG_ERR, "error in find dragnoball($user_id, $user_dragonball_id): $message");
            return false;
        }
    }

    /*
     * update dragonball level&exp
     */
    public function updateDragonball($user_id, $user_dragonball_id, $updates) {
        unset($updates['id']);
        if (empty($updates)) {
            return;
        }
		$this->user_id = $user_id;
        $arr = array();
        foreach ($updates as $prop=>$val) {
           $arr []= "$prop=:$prop:";
        }
        $sts = "set ".implode(',', $arr);
        $sql = "update __TABLE_NAME__ $sts where id=:id:";
        $updates['id'] = $user_dragonball_id;
        $result = $this->executeSQL($sql, $updates);
        if ($result->success()) {
            return true;
        } else {
            $message = ""; 
            foreach ($result->getMessages() as $msg) {
                $message .= $msg . "\n";
            }
            syslog(LOG_ERR, "error in find update($user_id, $user_dragonball_id): $message");
            return false;
        }
    }

    /*
     * get balls of one user
     */
	public function getDragonballs($user_id, $user_dragon_ball_ids)
	{
		$this->user_id = $user_id;

		$ids = implode(',', $user_dragon_ball_ids);
		$sql = "SELECT id, dragon_ball_id, level, exp FROM __TABLE_NAME__ WHERE id IN ($ids)";
		$result = $this->executeSQL($sql, []);
		if ($result->count() >0)
		{
			return $result->toArray();
		}
		return array();
	}
}
