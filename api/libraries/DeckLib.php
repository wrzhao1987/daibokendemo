<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-13
 * Time: 下午8:06
 */
namespace Cap\Libraries;

use Cap\Models\Db\UserDeckModel;
use Cap\Models\Db\UserFormationModel;
use Phalcon\Exception;

class DeckLib extends BaseLib
{
    public static $CACHE_KEY_DECK = "nami:deck:%s";
    public static $DECK_TYPE_PVE  = 1;
    public static $DECK_TYPE_PVP  = 2;
    public static $USER_DECK_LEADER_POSITION = 1;
    public static $USER_DECK_MAX_POSITION    = 6;
    public static $USER_DECK_FRIEND_POSITION = 7;

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('deck_model', function (){
            return new UserDeckModel();
        }, true);
        $this->_di->set('formation_model', function (){
            return new UserFormationModel();
        }, true);
        $this->_di->set('resque_lib', function (){
            return new ResqueLib();
        }, true);
        $this->_di->set('equip_lib', function () {
            return new EquipLib();
        });
    }

    public function createDeck($user_id)
    {
        if (empty ($user_id))
        {
            return false;
        }
        $deck_model = $this->getDI()->getShared('deck_model');
        for ($i = self::$USER_DECK_LEADER_POSITION; $i <= self::$USER_DECK_MAX_POSITION; $i++)
        {
            $deck_model->createDeck($user_id, $i);
        }
        $formation_model = $this->getDI()->getShared('formation_model');
        $formation_model->createNew($user_id, self::$DECK_TYPE_PVE);
        $formation_model->createNew($user_id, self::$DECK_TYPE_PVP);
        return true;
    }

    public function getDeck($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_DECK, $user_id);

        $result = $this->redis->hGetAll($cache_key);
        if (! $result)
        {
            $result = [];
            $deck_model = $this->getDI()->getShared('deck_model');
            foreach ($deck_model::find("user_id = $user_id") as $item)
            {
                $pos = $item->pos;

                // card:{1,6}
                $card_key = "card:{$pos}";
                $result[$card_key] = $item->user_card_id;

                // dball:{1,6}:{1,4}
                for ($i = 1; $i <= HERO_MAX_DRAGON_BALL_COUNT; $i++)
                {
                    $dball_key = "dball:{$pos}:{$i}";
                    $var_name = "dragon_ball_$i";
                    $result[$dball_key] = $item->$var_name;
                }

                // equip:{1,6}:{1,4}
                for ($i = 1; $i <= HERO_MAX_EQUIP_COUNT; $i++)
                {
                    $equip_key = "equip:{$pos}:{$i}";
                    $var_name = "equip_$i";
                    $result[$equip_key] = $item->$var_name;
                }

                // pve_formation{1,7}
                $formation_model = $this->getDI()->getShared('formation_model');
                $pve_fmt = $formation_model::findFirst(
                    [
                        'conditions' => "user_id = {$user_id} AND type = " . self::$DECK_TYPE_PVE,
                    ]
                );
                for ($i = self::$USER_DECK_LEADER_POSITION; $i <= self::$USER_DECK_FRIEND_POSITION; $i++)
                {
                    $pve_pos_key = "pvepos:{$i}";
                    $var_name = "pos_{$i}";
                    $result[$pve_pos_key] = $pve_fmt->$var_name;
                }

                // pvp_formation{1,6}
                $pvp_fmt = $formation_model::findFirst(
                    [
                        'conditions' => "user_id = {$user_id} AND type = " . self::$DECK_TYPE_PVP,
                    ]
                );
                for ($i = self::$USER_DECK_LEADER_POSITION; $i <= self::$USER_DECK_MAX_POSITION; $i++)
                {
                    $pvp_pos_key = "pvppos:{$i}";
                    $var_name = "pos_{$i}";
                    $result[$pvp_pos_key] = $pvp_fmt->$var_name;
                }
            }
            $result && $this->redis->hMSet($cache_key, $result);
        }
        return $result;
    }

    public function updateDeckCard($user_id, $pos, $user_card_id)
    {
        if (! ($user_id))
        {
            return false;
        }
        // 只允许更改用户自己的卡组卡牌
        if (intval($pos) > self::$USER_DECK_MAX_POSITION || intval($pos) < self::$USER_DECK_LEADER_POSITION)
        {
            return false;
        }
        if ($this->isInDeck($user_id, $user_card_id))
        {
            return false;
        }
        $resque_lib = $this->getDI()->getShared('resque_lib');
        $job_is_set = $resque_lib->setJob('deck', 'CardUp', [
            'user_id'      => $user_id,
            'pos'          => $pos,
            'user_card_id' => $user_card_id,
        ]);
        if ($job_is_set)
        {
            $cache_key = sprintf(self::$CACHE_KEY_DECK, $user_id);

            $deck_info = [];
            $card_key  = "card:{$pos}";
            $deck_info[$card_key] = $user_card_id;

            // 一旦更换了卡组内的卡牌，立即取下该位置上所有的龙珠
            for ($i = 1; $i <= HERO_MAX_DRAGON_BALL_COUNT; $i++)
            {
                $dball_key = "dball:{$pos}:{$i}";
                $deck_info[$dball_key] = 0;
            }
            $this->redis->hMSet($cache_key, $deck_info);
            syslog(LOG_DEBUG, "update card($user_card_id) to deck($pos)");
            return true;
        }
        return false;
    }

    public function setCardPvePosition($user_id, $pos, $deck = null)
    {
        $count    = 0;
        $out_pos  = [];
        $in_pos   = [];
        if (! $deck) {
            $deck = $this->getDeck($user_id);
        }
        foreach ($deck as $key => $value) {
            $key = explode(':', $key);
            // 计算卡组中成员数量
            if ($key[0] == 'card' && $value != 0) {
                $count++;
            // 计算九宫格外成员的数量
            } else if ($key[0] == 'pvepos') {
                if ($value == 10 || $value == 11) {
                    $out_pos[] = $value;
                } else if ($value >= 1 && $value <=9) {
                    $in_pos[] = $value;
                }
            }
        }
        if ($count == 6) {
            // PVE卡组上阵人数已满
            return false;
        } else if ($count == 5) {
            // 可以上阵一人，位置有可能在九宫格上，也可能在替补中
            if (count($in_pos) < 5) {
                // 可以塞进九宫格
                $can_use = array_diff(range(1, 9), $in_pos);
            } else {
                // 只能放进替补位置
                $can_use = array_diff(range(10, 11), $out_pos);
            }
        } else {
            if (count($in_pos) == 5) {
                $can_use = array_diff(range(10, 11), $out_pos);
            } else {
                $can_use = array_diff(range(1, 9), $in_pos);
            }
        }
        sort($can_use);
        $bpos = array_shift($can_use);
        $this->updateDeckFormation($user_id, self::$DECK_TYPE_PVE, [$pos => $bpos]);
        return true;
    }

    public function updateDeckFormation($user_id, $deck_type, $update_info)
    {
        if (! ($user_id && $update_info))
        {
            return false;
        }
        if (! (self::$DECK_TYPE_PVE == $deck_type || self::$DECK_TYPE_PVP == $deck_type))
        {
            return false;
        }
        // 计算update_info中，阵上英雄数量，如果大于6，则不能更新.
        if (self::$DECK_TYPE_PVE == $deck_type) {
            $in_grid = array_intersect($update_info, range(1, 9));
            if (count($in_grid) >= 6) {
                return false;
            }
        }
        $cache_key = sprintf(self::$CACHE_KEY_DECK, $user_id);
        $deck_info = $this->getDeck($user_id);
		foreach ($update_info as $dpos => $bpos)
        {
            if ($dpos != 0 && $bpos != 0) {
                $prefix = self::$DECK_TYPE_PVE == $deck_type ? 'pvepos' : 'pvppos';
                $pos_key = $prefix . ':' . $dpos;
                $deck_info[$pos_key] = intval($bpos);
            }
        }
        $this->redis->hMSet($cache_key, $deck_info);

        $resque_lib = $this->getDI()->getShared('resque_lib');
        $job_is_set = $resque_lib->setJob('deck', 'FormUp', [
            'user_id'     => $user_id,
            'deck_type'   => $deck_type,
            'update_info' => $update_info,
        ]);
        return $job_is_set ? true : false;
    }

    public function updateDeckEquip($user_id, $pos, $equip_pos, $user_equip_id)
    {
        if (! ($user_id && $pos && $equip_pos))
        {
            throw new Exception("Parameter Invalid", ERROR_CODE_FAIL);
        }
        $resque_lib = $this->getDI()->getShared('resque_lib');
        $cache_key = sprintf(self::$CACHE_KEY_DECK, $user_id);

        $in_deck = $this->isEquipInDeck($user_id, $user_equip_id);
        if (is_array($in_deck) && count($in_deck) == 2)
        {
            $job_is_set = $resque_lib->setJob('deck', 'EquipUp', [
                'user_id'       => $user_id,
                'pos'           => $in_deck[0],
                'equip_pos'     => $in_deck[1],
                'user_equip_id' => 0,
            ]);
            if ($job_is_set) {
                $equip_key = "equip:{$in_deck[0]}:{$in_deck[1]}";
                $this->redis->hSet($cache_key, $equip_key, 0);
            }
        }
        $equip_lib = $this->_di->getShared('equip_lib');
        $equip_info = $equip_lib->getEquip($user_id, $user_equip_id);
        if (! $equip_info) {
            throw new Exception("找不到{$user_equip_id}号装备", ERROR_CODE_FAIL);
        }
        if ($equip_info['type'] != $equip_pos) {
            throw new Exception("Equip cannot be in this pos.", ERROR_CODE_FAIL);
        }
        $job_is_set = $resque_lib->setJob('deck', 'EquipUp', [
            'user_id'       => $user_id,
            'pos'           => $pos,
            'equip_pos'     => $equip_pos,
            'user_equip_id' => $user_equip_id,
        ]);
        if ($job_is_set) {
            $equip_key = "equip:{$pos}:{$equip_pos}";
            $this->redis->hSet($cache_key, $equip_key, $user_equip_id);
            return true;
        }
        return false;
    }

    public function updateDeckDragonBall($user_id, $pos, $dragon_ball_pos, $user_dragon_ball_id)
    {
        if (! ($user_id && $pos && $dragon_ball_pos))
        {
            return false;
        }
        $resque_lib = $this->getDI()->getShared('resque_lib');
        $cache_key = sprintf(self::$CACHE_KEY_DECK, $user_id);

        $in_deck = $this->isDballInDeck($user_id, $user_dragon_ball_id);
        if (is_array($in_deck) && count($in_deck) == 2)
        {
            $job_is_set = $resque_lib->setJob('deck', 'DragonBallUp', [
                'user_id'             => $user_id,
                'pos'                 => $in_deck[0],
                'dragon_ball_pos'     => $in_deck[1],
                'user_dragon_ball_id' => 0,
            ]);
            if ($job_is_set) {
                $dball_key = "dball:{$in_deck[0]}:{$in_deck[1]}";
                $this->redis->hSet($cache_key, $dball_key, 0);
            }
        }
        $job_is_set = $resque_lib->setJob('deck', 'DragonBallUp', [
            'user_id'             => $user_id,
            'pos'                 => $pos,
            'dragon_ball_pos'     => $dragon_ball_pos,
            'user_dragon_ball_id' => $user_dragon_ball_id,
        ]);
        if ($job_is_set)
        {
            $dball_key = "dball:{$pos}:{$dragon_ball_pos}";
            $this->redis->hSet($cache_key, $dball_key, $user_dragon_ball_id);
            return true;
        }
        return false;
    }

    public function isInDeck($user_id, $user_card_id)
    {
        $deck = $this->getDeck($user_id);
        for ($i = self::$USER_DECK_LEADER_POSITION; $i <= self::$USER_DECK_MAX_POSITION; $i++)
        {
            $card_key = "card:{$i}";
            if ($user_card_id == $deck [$card_key])
            {
                return true;
            }
        }
        return false;
    }

    public function isEquipInDeck($user_id, $user_equip_id)
    {
        $deck = $this->getDeck($user_id);
        for ($i = self::$USER_DECK_LEADER_POSITION; $i <= self::$USER_DECK_MAX_POSITION; $i++)
        {
            for ($j = 1; $j <= HERO_MAX_EQUIP_COUNT; $j++)
            {
                $equip_key = "equip:{$i}:{$j}";
                if ($deck [$equip_key] == $user_equip_id)
                {
                    return [$i, $j];
                }
            }
        }
        return false;
    }

    public function isDballInDeck($user_id, $user_dball_id)
    {
        $deck = $this->getDeck($user_id);
        for ($i = self::$USER_DECK_LEADER_POSITION; $i <= self::$USER_DECK_MAX_POSITION; $i++)
        {
            for ($j = 1; $j <= HERO_MAX_DRAGON_BALL_COUNT; $j++)
            {
                $dball_key = "dball:{$i}:{$j}";
                if ($deck [$dball_key] == $user_dball_id)
                {
                    return [$i, $j];
                }
            }
        }
        return false;
    }

    public function getDeckUserCardId($user_id)
    {
        $user_card_ids = [];
        $deck = $this->getDeck($user_id);
        foreach ($deck as $key => $value) {
            $tmp = explode(':', $key);
            if ('card' == $tmp[0]) {
                $user_card_ids[$tmp[1]] = $value;
            }
        }
        return $user_card_ids;
    }
}
