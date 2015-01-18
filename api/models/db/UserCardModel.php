<?php
namespace Cap\Models\Db;

class UserCardModel extends BaseModel
{
	public $id;
	public $user_id;
	public $card_id;
	public $exp;
	public $star;
	public $level;
	public $phase;
	public $potential;
	public $atk; // 升级、突破后的基础攻击力
	public $def; // 升级、突破后的基础防御力
	public $hp;  // 升级、突破后的基础血量
	public $dragon_count; // 可装备的龙珠数量
	public $created_at;
	public $updated_at;

	const MYSQL_TABLE_NAME_PREFIX = 'user_card_';
	const MYSQL_SHARD_COUNT = 100;

	public $sql_array = array(
		'find_by_id'       => 'SELECT id, card_id, level, phase, exp, atk, def, hp, potential, slevel_1, slevel_2, slevel_3, slevel_4
						       FROM __TABLE_NAME__ WHERE id = :id:',

		'find_by_user_id'  => 'SELECT id, card_id FROM __TABLE_NAME__ WHERE user_id = :user_id:',

        'find_by_user'     => 'SELECT id, card_id, level, phase, exp, atk, def, hp, potential, slevel_1, slevel_2, slevel_3, slevel_4
                               FROM __TABLE_NAME__ WHERE user_id = :user_id:',

		'add_new'          => 'INSERT INTO __TABLE_NAME__ (user_id, card_id, exp, level, phase, potential, atk, def, hp, slevel_1, slevel_2, slevel_3, slevel_4, created_at)
				               VALUES (:user_id:, :card_id:, :exp:, :level:, 0, 0, :atk:, :def:, :hp:, :slevel_1:, 0, 0, 0, now())',

		'delete_by_id'     => 'DELETE FROM __TABLE_NAME__ WHERE id = :id:',

		'update_by_id'     => 'UPDATE __TABLE_NAME__ SET __CONDITIONS__ WHERE id = :id:',

		'create_table'     => "CREATE TABLE `user_card` (
							  `id` int(11) NOT NULL AUTO_INCREMENT,
							  `user_id` int(11) NOT NULL COMMENT '卡牌用户ID',
							  `card_id` smallint(6) NOT NULL COMMENT '卡牌ID',
							  `exp` int(11) NOT NULL DEFAULT '0' COMMENT '经验值',
							  `level` smallint(6) NOT NULL DEFAULT '1' COMMENT '卡牌等级',
							  `phase` tinyint(4) NOT NULL DEFAULT '0' COMMENT '卡牌突破阶段',
							  `potential` smallint(6) NOT NULL DEFAULT '0' COMMENT '潜能点',
							  `atk` int(11) NOT NULL DEFAULT '0',
							  `def` int(11) NOT NULL DEFAULT '0',
							  `hp` int(11) NOT NULL DEFAULT '0',
							  `slevel_1` smallint(4) NOT NULL DEFAULT 0,
							  `slevel_2` smallint(4) NOT NULL DEFAULT 0,
							  `slevel_3` smallint(4) NOT NULL DEFAULT 0,
							  `slevel_4` smallint(4) NOT NULL DEFAULT 0,
							  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
							  `created_at` datetime NOT NULL,
							  PRIMARY KEY (`id`),
							  UNIQUE KEY `user_card_idx` (`user_id`,`card_id`)
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

	public function getCard($user_id, $user_card_id)
	{
		$this->user_id = $user_id;
        $user_card_id = intval($user_card_id);

        $result = self::findFirst([
            'conditions' => "id = $user_card_id",
            'columns'    => "id, card_id, exp, level, phase, potential, atk, def, hp, slevel_1, slevel_2, slevel_3, slevel_4",
        ]);
		return $result ? $result->toArray() : [];
	}

	public function getCardByUserId($user_id)
	{
		$this->user_id = $user_id;

		$result = array();
		$cards = $this->execute('find_by_user_id', array('user_id' => $user_id));
		if ($cards->count() >0)
		{
			foreach ($cards as $card)
			{
				$result[$card->card_id] = $card->id;
			}
		}
		return $result;
	}

    public function getByUser($user_id)
    {
        $this->user_id = $user_id;

        $result = array();
		$sql = "SELECT id, card_id, level, phase, exp, atk, def, hp, potential, slevel_1, slevel_2, slevel_3, slevel_4 FROM __TABLE_NAME__ WHERE user_id = $user_id";
		$cards = $this->executeSQL($sql, []);
        if ($cards->count() >0)
        {
            foreach ($cards as $card)
            {
                $result[$card->id] = $card->toArray();
            }
        }
        return $result;
    }
	public function getByCardId($user_id, $card_id)
	{
		$this->user_id = $user_id;

		$user_id = intval($user_id);
		$card_id = intval($card_id);
		$result = self::findFirst("user_id = $user_id AND card_id = $card_id");
		if ($result->count() > 0)
		{
			return $result->toArray();
		}
		return [];
	}

	public function getByIdList($user_id, $id_list)
	{
		$this->user_id = $user_id;

		$result = array();
        if (is_array($id_list))
        {
            $id_list = implode(',', $id_list);
        }
        $sql = "SELECT id, card_id, level, phase, exp, atk, def, hp, potential, slevel_1, slevel_2, slevel_3, slevel_4
                FROM __TABLE_NAME__ WHERE id in ($id_list)";
        $cards = $this->executeSQL($sql, []);

		if ($cards->count() > 0)
		{
			foreach ($cards as $value)
			{
				$result[$value->card_id] = $value->toArray();
			}
		}
		return $result;
	}

	public function addCard($user_id, $new_card_info)
	{
		$this->user_id = $user_id;

		$params = array(
			'user_id'  => $user_id,
			'card_id'  => $new_card_info['card_id'],
			'exp'      => $new_card_info['exp'],
			'level'    => $new_card_info['level'],
			'atk'      => $new_card_info['atk'],
			'def'      => $new_card_info['def'],
			'hp'       => $new_card_info['hp'],
			'slevel_1' => $new_card_info['slevel_1'],
		);
		$result = $this->execute('add_new', $params);
		if ($result->success())
		{
			return $result->getModel()->id;
		}
		return false;
	}

	public function updateCard($user_id, $user_card_id, $user_card_info)
	{
		$this->user_id = $user_id;

		$sql = $this->sql_array['update_by_id'];
		if (is_array($user_card_info))
		{
			$conditions = array();
			foreach ($user_card_info as $key => $value)
			{
				$conditions[] = "$key = '$value'";
			}
			$conditions = implode(',', $conditions);
			$sql = str_replace('__CONDITIONS__', $conditions, $sql);
			$result = $this->executeSQL($sql, array('id' => $user_card_id));
			return $result->success();
		}
		return false;
	}

	public function deleteCard($user_id, $user_card_id)
	{
		$this->user_id = $user_id;

		if (is_scalar($user_card_id))
		{
			$sql = 'delete_by_id';
			$params = array('id' => $user_card_id);
		}
		if (isset ($sql) && isset ($params))
		{
			$result = $this->execute($sql, $params);
			return $result->success();
		}
		return false;
	}
}
