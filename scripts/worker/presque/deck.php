<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-23
 * Time: 上午11:28
 */
require_once __DIR__ . '/capbase.php';

class CardUp extends CapBase
{
    protected $deck_table = 'user_deck';

    public function perform()
    {
        $user_id      = intval($this->args['user_id']);
        $pos          = intval($this->args['pos']);
        $user_card_id = intval($this->args['user_card_id']);

        if ($user_id && $pos && $user_card_id)
        {
            $sql = "UPDATE {$this->deck_table} SET __CONDITIONS__ WHERE user_id = {$user_id} AND pos = {$pos}";
            $conditions = [
                "user_card_id = $user_card_id",
            ];
            for ($i = 1; $i <= self::$MAX_COUNT_DRAGON_BALL; $i++)
            {
                $conditions[] = "dragon_ball_{$i} = 0";
            }
            $conditions = implode(',', $conditions);
            $sql = str_replace('__CONDITIONS__', $conditions, $sql);
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}

class FormUp extends CapBase
{
    protected $formation_table = 'user_formation';

    public function perform()
    {
        $user_id     = intval($this->args['user_id']);
        $deck_type   = intval($this->args['deck_type']);
        $update_info = $this->args['update_info'];


        if ($user_id && $deck_type && $update_info)
        {
            $sql = "UPDATE {$this->formation_table} SET __CONDITIONS__ WHERE user_id = {$user_id} AND type = {$deck_type}";
            $conditions = [];
            foreach ($update_info as $dpos => $bpos)
            {
                $var_name = "pos_{$dpos}";
                $conditions[] = "{$var_name} = {$bpos}";
            }
            $conditions = implode(',', $conditions);
            $sql = str_replace('__CONDITIONS__', $conditions, $sql);
            try {
                $this->db->exec($sql);
            } catch (PDOException $e) {
                syslog(LOG_ERR, $e->getMessage());
            }
        }
    }
}

class DragonBallUp extends CapBase
{
    protected $deck_table = 'user_deck';

    public function perform()
    {
        $user_id             = intval($this->args['user_id']);
        $pos                 = intval($this->args['pos']);
        $dragon_ball_pos     = intval($this->args['dragon_ball_pos']);
        $user_dragon_ball_id = intval($this->args['user_dragon_ball_id']);

        $sql = "UPDATE {$this->deck_table} SET __CONDITIONS__ WHERE user_id = {$user_id} AND pos = {$pos}";
        $condition = "dragon_ball_{$dragon_ball_pos} = {$user_dragon_ball_id}";
        $sql = str_replace('__CONDITIONS__', $condition, $sql);

        try {
            $this->db->exec($sql);
        } catch (PDOException $e) {
            syslog(LOG_ERR, $e->getMessage());
        }
    }
}

class EquipUp extends CapBase
{
    protected $deck_table = 'user_deck';

    public function perform()
    {
        $user_id       = intval($this->args['user_id']);
        $pos           = intval($this->args['pos']);
        $equip_pos     = intval($this->args['equip_pos']);
        $user_equip_id = intval($this->args['user_equip_id']);

        $sql = "UPDATE {$this->deck_table} SET __CONDITIONS__ WHERE user_id = {$user_id} AND pos = {$pos}";
        $condition = "equip_{$equip_pos} = {$user_equip_id}";
        $sql = str_replace('__CONDITIONS__', $condition, $sql);

        try {
            $this->db->exec($sql);
        } catch (PDOException $e) {
            syslog(LOG_ERR, $e->getMessage());
        }
    }
}