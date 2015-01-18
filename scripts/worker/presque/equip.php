<?php
require_once __DIR__ . '/capbase.php';

class EquipDel extends CapBase
{
    protected $table_prefix = 'user_equip_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id  = intval($this->args['user_id']);
        $uequip_id = intval($this->args['uequip_id']);
        if ($user_id && $uequip_id) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            if ($uequip_id > 0) {
                $sql = "DELETE FROM {$table_name} WHERE id = {$uequip_id}";
                try {
                    $this->db->exec($sql);
                } catch (PDOException $e) {
                    syslog(LOG_ERR, $e->getMessage());
                }
            }
        }
    }
}

class EquipLevelUp extends CapBase
{
    protected $table_prefix = 'user_equip_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id   = intval($this->args['user_id']);
        $uequip_id = intval($this->args['uequip_id']);
        $delta     = intval($this->args['delta']);
        if ($user_id && $uequip_id) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            if ($uequip_id > 0) {
                $sql = "UPDATE {$table_name} SET level = level + {$delta} WHERE id = {$uequip_id}";
                try {
                    $this->db->exec($sql);
                } catch (PDOException $e) {
                    syslog(LOG_ERR, $e->getMessage());
                }
            }
        }
    }
}