<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-3-11
 * Time: 下午1:09
 */
namespace Cap\Models\Db;

class UserCardPieceModel extends BaseModel
{
	public $id;
	public $user_id;
	public $card_id;
	public $count;
	public $created_at;
	public $updated_at;

	const MYSQL_TABLE_NAME_PREFIX = 'user_card_piece_';
	const MYSQL_SHARD_COUNT = 100;

	public $sql_array = array(
		'find_by_card'   => 'SELECT * FROM __TABLE_NAME__ WHERE user_id = :user_id: AND card_id = :card_id:',
		'find_by_user'   => 'SELECT * FROM __TABLE_NAME__ WHERE user_id = :user_id:',
		'update_by_card' => 'UPDATE __TABLE_NAME__
							 SET count = count + :delta:
							 WHERE user_id = :user_id: AND card_id = :card_id:',
		'add_by_card'    => 'INSERT INTO __TABLE_NAME__ (user_id, card_id, count)
							 VALUES (:user_id:, :card_id:, :delta:)',
		'create_table'   => "CREATE TABLE `user_card_piece_27` (
							  `id` int(11) NOT NULL AUTO_INCREMENT,
							  `user_id` int(11) NOT NULL,
							  `card_id` int(11) NOT NULL,
							  `count` smallint(6) NOT NULL DEFAULT '0',
							  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
							  `created_at` datetime NOT NULL,
							  PRIMARY KEY (`id`),
							  UNIQUE KEY `user_card_index` (`user_id`,`card_id`)
							) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8"
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

	public function addCardPiece($user_id, $card_id, $delta)
	{
		$this->user_id = $user_id;

		$params = array(
			'user_id' => $user_id,
			'card_id' => $card_id,
			'delta'   => $delta,
		);
		$this->execute('add_by_card', $params);
		$last_insert_id = $this->getWriteConnection()->lastInsertId();
		return $last_insert_id;
	}

	public function updateCardPiece($user_id, $card_id, $delta = 0)
	{
		$this->user_id = $user_id;

        $user_id = intval($user_id);
        $card_id = intval($card_id);
        $delta   = intval($delta);
        $sql = "UPDATE __TABLE_NAME__ SET count = count + $delta WHERE user_id = $user_id AND card_id = $card_id";
        $result = $this->executeSQL($sql,[]);
        return $result->success();
	}

	public function getAllPiece($user_id)
	{
		$this->user_id = $user_id;

		$result = array();
		$all_piece = $this->execute('find_by_user', array('user_id' => $user_id));
		if ($all_piece->count() > 0)
		{
			foreach ($all_piece as $piece)
			{
				$result [$piece->card_id] = $piece->count;
			}
		}
		return $result;
	}
}