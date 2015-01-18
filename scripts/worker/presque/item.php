<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-23
 * Time: 上午11:28
 */
require_once __DIR__ . '/capbase.php';

class ItemUpsert extends CapBase
{
    protected $table_prefix  = "user_item_";
    protected $shard_count   = 100;

    public function perform()
    {
        syslog(LOG_DEBUG, "Item insert/update begins.");
        if (   ! isset ($this->args['user_id'])
            || ! isset ($this->args['item_id'])
            || ! isset ($this->args['sub_id'])
            || ! isset ($this->args['count'])
        )
        {
            syslog(LOG_WARNING, 'The required paramater is empty.');
        }
        $user_id = intval($this->args['user_id']);
        $item_id = intval($this->args['item_id']);
        $sub_id  = intval($this->args['sub_id']);
        $count   = intval($this->args['count']);
        if ($user_id && $item_id && $sub_id && $count)
        {
            $table_name = $this->table_prefix . sprintf("%02d", $user_id % $this->shard_count);
            $sql = "INSERT INTO {$table_name} (user_id, item_id, sub_id, count, created_at)
                    VALUES ({$user_id}, {$item_id}, {$sub_id}, {$count}, NOW())
                    ON DUPLICATE KEY UPDATE count = count + {$count}";
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }

}