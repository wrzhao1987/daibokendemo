<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-16
 * Time: 下午5:42
 */
require_once __DIR__ . '/capbase.php';

class DBallFragUp extends CapBase
{
    protected $table_prefix = 'dragonball_fragment_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id = intval($this->args['user_id']);
        $frag_id = intval($this->args['frag_id']);
        $delta   = intval($this->args['delta']);

        if ($user_id && $frag_id) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            $sql = "INSERT INTO {$table_name} (role_id, fragment_no, count)
                    VALUES ('{$user_id}', '{$frag_id}', '{$delta}')
                    ON DUPLICATE KEY UPDATE count = count + {$delta}";
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}

class DBallFragDec extends CapBase
{
    protected $table_prefix = 'dragonball_fragment_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id = intval($this->args['user_id']);
        $frag_ids = $this->args['frag_ids'];
        $delta = isset ($this->args['delta']) ? intval($this->args['delta']) : 1;

        if (is_array($frag_ids) && count($frag_ids) > 0 && $user_id) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            $frag_ids = implode(',', $frag_ids);
            $sql = "UPDATE $table_name SET count = count - $delta WHERE role_id = $user_id AND fragment_no IN ($frag_ids)";
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}

class DBallUp extends CapBase
{
    protected $table_prefix = 'user_dragon_ball_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id   = intval($this->args['user_id']);
        $udball_id = intval($this->args['udball_id']);
        $prof      = $this->args['prof'];

        if ($user_id && $udball_id) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            $sql = "UPDATE {$table_name} SET __CONDITIONS__ WHERE id = {$udball_id}";
            $conditions = [];
            foreach ($prof as $field => $value) {
                $conditions[] = "{$field} = {$value}";
            }
            $sql = str_replace('__CONDITIONS__', implode(',', $conditions), $sql);
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}

class DBallDel extends CapBase
{
    protected $table_prefix = 'user_dragon_ball_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id   = intval($this->args['user_id']);
        $udball_ids = $this->args['udball_ids'];

        if ($user_id && $udball_ids) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            $udball_ids = implode(',', $udball_ids);
            $sql = "DELETE FROM {$table_name} WHERE id IN ({$udball_ids})";
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}