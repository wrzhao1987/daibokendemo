<?php
namespace Cap\Models\Db;

class UserEquipModel extends BaseModel
{
	public $id;
	public $user_id;
	public $equip_id;
	public $level;

	const MYSQL_TABLE_NAME_PREFIX = 'user_equip_';
	const MYSQL_SHARD_COUNT = 100;

	public $sql_array = array(

		'find_by_user'     => 'SELECT id, equip_id, level FROM __TABLE_NAME__
							   WHERE user_id = :user_id:',

        'find_by_id'       => 'SELECT id, equip_id, level FROM __TABLE_NAME__
                               WHERE user_id = :user_id: AND id = :user_equip_id:',

		'level_up_equip'   => 'UPDATE __TABLE_NAME__ SET level = level + :delta: WHERE id = :id:',

        'create_new'       => 'INSERT INTO __TABLE_NAME__ (user_id, equip_id, level, created_at)
                               VALUES (:user_id:, :equip_id:, 1, NOW())',
        'delete'           => 'DELETE FROM __TABLE_NAME__ WHERE user_id = :user_id: AND id = :user_equip_id:',
		'create_table'     =>  "CREATE TABLE `user_equip` (
								`id` int(11) NOT NULL AUTO_INCREMENT,
								`user_id` int(11) NOT NULL DEFAULT '0',
								`equip_id` smallint(6) NOT NULL DEFAULT '0',
								`level` smallint(6) NOT NULL DEFAULT '1',
								`updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
								`created_at` datetime NOT NULL,
								 PRIMARY KEY (`id`),
								 KEY `user_id_idx` (`user_id`)
								) ENGINE=InnoDB DEFAULT CHARSET=utf8",
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

	public function getByIds($user_id, $user_equip_ids)
	{
		$this->user_id = $user_id;
		if (is_array($user_equip_ids) && count($user_equip_ids) > 0)
		{
			$ids = implode(',', $user_equip_ids);
			$sql = "SELECT id, equip_id, level FROM __TABLE_NAME__ WHERE id IN ($ids)";
			$result = $this->executeSQL($sql, []);
			if ($result->count() > 0)
			{
				return $result;
			}
		}
		return array();
	}

    public function getByUEquipId($user_id, $user_equip_id)
    {
        if (! ($user_id && $user_equip_id))
        {
            return false;
        }
        $this->user_id = intval($user_id);
        $result = $this->execute('find_by_id', ['user_id' => $user_id, 'user_equip_id' => $user_equip_id]);
        if ($result->count() > 0)
        {
            return $result->toArray()[0];
        }
        return false;
    }

    public function getByUser($user_id)
    {
        $this->user_id = $user_id;
        $result = [];
        $equips = $this->execute('find_by_user', array('user_id' => $user_id,));
        if ($equips->count() >0)
        {
            foreach ($equips as $value)
            {
                $result[$value->id] = $value->toArray();
            }
        }
        return $result;
    }

    public function levelUp($user_id, $user_equip_id, $delta)
    {
        $this->user_id = $user_id;

        $delta = intval($delta);
        $user_equip_id = intval($user_equip_id);

        if ($delta && $user_equip_id)
        {
            $result = $this->executeSQL("UPDATE __TABLE_NAME__ SET level = level + $delta WHERE id = $user_equip_id", []);
            return $result->success();
        }
        return false;
    }

    public function addNew($user_id, $equip_id)
    {
        if (! ($user_id && $equip_id))
        {
            return false;
        }
        $this->user_id = intval($user_id);
        $result = $this->execute('create_new', ['user_id' => $user_id, 'equip_id' => $equip_id]);

        return $result->success() ? $result->getModel()->id : false;
    }

    public function del($user_id, $user_equip_id)
    {
        if (! ($user_id && $user_equip_id))
        {
            return false;
        }
        $this->user_id = intval($user_id);
        $result = $this->execute('delete', ['user_id' => $user_id, 'user_equip_id' => $user_equip_id]);
        return $result->success();
    }
}