<?php
require_once __DIR__ . '/capbase.php';

class PieceUp extends CapBase
{
    protected $table_prefix = 'user_card_piece_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id = intval($this->args['user_id']);
        $card_id = intval($this->args['card_id']);
        $delta   = intval($this->args['delta']);

        if ($user_id && $card_id)
        {
            $table_name = $this->table_prefix . strval($user_id % $this->shard_count);
            $sql = "INSERT INTO {$table_name} (user_id, card_id, count, created_at)
                    VALUES ('{$user_id}', '{$card_id}', '{$delta}', NOW())
                    ON DUPLICATE KEY UPDATE count = count + {$delta}";
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}

class ProfUp extends CapBase
{
    protected $table_prefix = 'user_card_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id  = intval($this->args['user_id']);
        $ucard_id = intval($this->args['ucard_id']);
        $prof     = $this->args['prof'];

        if ($user_id && $ucard_id) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            $sql = "UPDATE {$table_name} SET __CONDITIONS__ WHERE id = {$ucard_id}";
            $conditions = [];
            foreach ($prof as $field => $value) {
                $conditions[] = "{$field} = {$value}";
            }
            $sql = str_replace('__CONDITIONS__', implode(',', $conditions), $sql);
            syslog(LOG_NOTICE, $sql);
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}

class Delete extends CapBase
{
    protected $table_prefix = 'user_card_';
    protected $shard_count   = 100;

    public function perform()
    {
        $user_id  = intval($this->args['user_id']);
        $ucard_id = intval($this->args['ucard_id']);

        if ($user_id && $ucard_id) {
            $shard = sprintf("%02d", $user_id % $this->shard_count);
            $table_name = $this->table_prefix . $shard;
            $sql = "DELETE FROM {$table_name} WHERE id = {$ucard_id}";
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}