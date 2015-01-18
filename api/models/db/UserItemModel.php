<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-21
 * Time: 下午4:18
 */
namespace Cap\Models\Db;

class UserItemModel extends BaseModel
{
    public $id;
    public $user_id;
    public $item_id;
    public $sub_id;
    public $count;
    public $created_at;
    public $updated_at;

    public $sql_array = [
        'find_by_user' => 'SELECT id, user_id, item_id, sub_id, count FROM __TABLE_NAME__ WHERE user_id = :user_id:',
        'upsert'       => 'INSERT INTO __TABLE_NAME__ (user_id, item_id, sub_id, count)
                           VALUES (:user_id:, :item_id:, :sub_id:)
                           ON DUPLICATE KEY UPDATE count = count + :count:',
        'create_table' => 'CREATE TABLE `user_item`(
                            `id` INT(11) NOT NULL AUTO_INCREMENT,
                            `user_id` INT(11) NOT NULL,
                            `item_id` TINYINT(2) NOT NULL,
                            `sub_id`  SMALLINT(4) NOT NULL DEFAULT 1,
                            `count`   SMALLINT(6) NOT NULL DEFAULT 0,
                            `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            `created_at` datetime NOT NULL,
							 PRIMARY KEY (`id`),
							 UNIQUE KEY `item_idx` (`user_id`, `item_id`, `sub_id`)
                           ) ENGINE=InnoDB DEFAULT CHARSET=utf8',
    ];

    const MYSQL_TABLE_NAME_PREFIX = 'user_item_';
    const MYSQL_SHARD_COUNT = 100;

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

    public function getByUser($user_id)
    {
        $this->user_id = intval($user_id);

        $result = $this->execute('find_by_user', ['user_id' => $this->user_id]);

        return $result->count() > 0 ? $result->toArray() : [];
    }

    public function updateItem($user_id, $item_id, $sub_id, $count)
    {
        if (! ( intval($user_id) && intval($item_id) && intval($sub_id) ))
        {
            return false;
        }
        $params = [
            'user_id' => intval($user_id),
            'item_id' => intval($item_id),
            'sub_id'  => intval($sub_id),
            'count'   => intval($count),
        ];
        return $this->execute('upsert', $params)->success();
    }
}