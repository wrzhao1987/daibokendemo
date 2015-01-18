<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-23
 * Time: 上午11:28
 */
require_once __DIR__ . '/capbase.php';

class CreateRec extends CapBase
{
    protected $table_prefix  = "sys_join_";

    public function perform()
    {
        if (   ! isset ($this->args['user_id'])
            || ! isset ($this->args['type'])
            || ! isset ($this->args['user_level'])
            || ! isset ($this->args['ts'])
        )
        {
            syslog(LOG_WARNING, 'The required paramater is empty.');
            return;
        }
        $user_id = intval($this->args['user_id']);
        $type = intval($this->args['type']);
        $user_level  = intval($this->args['user_level']);
        $ts = intval($this->args['ts']);
        if ($user_id && $type && $user_level && $ts)
        {
            // 每天5点刷新
            $table_name = $this->table_prefix . date('Ymd', $ts - 5 * 3600);
            $sql = "INSERT INTO {$table_name} (user_id, type, user_level, created_at) VALUES ('{$user_id}', '{$type}', '{$user_level}', '{$ts}')";
            syslog(LOG_DEBUG, $sql);
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }

}