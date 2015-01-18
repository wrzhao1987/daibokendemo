<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-18
 * Time: 下午12:39
 */
namespace Cap\Libraries;

use Phalcon\Exception;

class ItemLib extends BaseLib
{
    // 可以在list接口中查询到的道具类型
    public static $list_available = [
        ITEM_TYPE_EXP_MEDICINE,
        ITEM_TYPE_AVOID_FIGHT_TOKEN,
        ITEM_TYPE_TREASURE_BOX_KEY,
        ITEM_TYPE_TREASURE_BOX,
        ITEM_TYPE_GIFT_BOX,
        ITEM_TYPE_ENERGY_MEDICINE,
        ITEM_TYPE_GENKI_MEDICINE,
        ITEM_TYPE_GACHA_TICKET,
    ];

    public static $external_available = [
        ITEM_TYPE_DIAMOND,
        ITEM_TYPE_SONY,
        ITEM_TYPE_HERO,
        ITEM_TYPE_HERO_FRAGMENT,
        ITEM_TYPE_DRAGON_BALL,
        ITEM_TYPE_DRAGON_BALL_FRAGMENT,
        ITEM_TYPE_EQUIP,
        ITEM_TYPE_EQUIP_FRAGMENT,
        ITEM_TYPE_USER_EXP,
        ITEM_TYPE_STAMINA,
        ITEM_TYPE_HONOR,
        ITEM_TYPE_SNAKE,
    ];

    public static $item_ttl = [
        ITEM_TYPE_AVOID_FIGHT_TOKEN => 3600,
    ];

    public static $ENERGY_MDC_AMOUNT = [
        1 => 10,
        2 => 20,
        3 => 50,
        4 => 120,
    ];

    public static $EXP_MDC_AMOUNT = [
        1 => 100,
        2 => 500,
        3 => 2000,
        4 => 10000,
    ];

    public static $GENKI_MDC_AMOUNT = 20;
    public static $ITEM_MAX_COUNT = 999;
    public static $CACHE_KEY_ITEMS = 'nami:items:%s';
    public static $CACHE_KEY_MONTH_CONSUME = 'nami:items:comsume';

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('resque_lib', function() {
            return new ResqueLib();
        });
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
    }

    public static function itemListKey($user_id)
    {
        return sprintf(self::$CACHE_KEY_ITEMS, $user_id);
    }

    public function listItem($user_id, $external = false)
    {
        $ret = [];
        $cache_key = self::itemListKey($user_id);
        $items = $this->redis->hGetAll($cache_key);
        if ($items) {
            if ($external) {
                foreach ($items as $key => $count) {
                    list ($item_id, $sub_id) = explode(':', $key);
                    if (self::available($item_id)) {
                        array_push($ret, [
                            'item_id' => $item_id,
                            'sub_id'  => $sub_id,
                            'count'   => $count,
                        ]);
                    }
                }
            } else {
                $ret = $items;
            }
        }
        return $ret;
    }

    public function addItem($user_id, $item_id, $sub_id, $count = 1)
    {
        if (self::available($item_id)) {
            $cache_key = self::itemListKey($user_id);
            $item_key  = $item_id . ':' . $sub_id;
            $this->myRedisIncrBy($cache_key, $item_key, $count);
            return true;
        } else if (self::externalAvailable($item_id)) {
            switch ($item_id) {
                case ITEM_TYPE_HONOR:
                    $user_lib = $this->getDI()->getShared('user_lib');
                    $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_HONOR, $count);
                    break;
                case ITEM_TYPE_SNAKE:
                    $this->getDI()->getShared('user_lib')->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_SNAKE, $count);
                    break;
                case ITEM_TYPE_USER_EXP:
                    $new_prop = $this->getDI()->getShared('user_lib')->addExp($user_id, $count);
                    return $new_prop;
                case ITEM_TYPE_STAMINA:
                    $this->getDI()->getShared('user_lib')->addMissionEnergy($user_id, $count);
                    break;
                case ITEM_TYPE_DIAMOND:
                    $this->getDI()->getShared('user_lib')->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_GOLD, $count);
                    break;
                case ITEM_TYPE_SONY:
                    $this->getDI()->getShared('user_lib')->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, $count);
                    break;
                case ITEM_TYPE_HERO:
                    $card_lib = new CardLib();
                    $new_card_id = $card_lib->addCard($user_id, $sub_id);

                    if (FALSE === $new_card_id) {
                        return false;
                    }

                    if (intval($new_card_id) > 0) {
                        return [
                            'pk_id'   => $new_card_id,
                            'item_id' => ITEM_TYPE_HERO,
                            'sub_id'  => $sub_id,
                            'count'   => 1,
                        ];
                    } else {
                        $hero_phase_config = self::getGameConfig('hero_phase')[$sub_id];
                        $piece_count = floor($hero_phase_config[0]['need_piece'] * CardLib::$SOUL_TRANS_RATE);
                        return [
                            'pk_id'   => 0,
                            'item_id' => ITEM_TYPE_HERO_FRAGMENT,
                            'sub_id'  => $sub_id,
                            'count'   => $piece_count,
                        ];
                    }

                case ITEM_TYPE_DRAGON_BALL:
                    $dragon_ball_lib = new DragonBallLib();
                    if ($count > 1) {
                        $result = [];
                        for ($i = 0; $i < $count; $i++) {
                            $ret = $dragon_ball_lib->newDragonball($user_id, $sub_id);
                            if (isset ($ret['id']) && intval($ret['id']) > 0) {
                                $result[] = [
                                    'pk_id' => $ret['id'],
                                    'item_id' => ITEM_TYPE_DRAGON_BALL,
                                    'sub_id' => $sub_id,
                                    'count' => 1,
                                ];
                            }
                        }
                        return empty ($result) ? false : $result;
                    } else if ($count == 1) {
                        $ret = $dragon_ball_lib->newDragonball($user_id, $sub_id);
                        if (isset ($ret['id']) && intval($ret['id']) > 0) {
                            return [
                                'pk_id' => $ret['id'],
                                'item_id' => ITEM_TYPE_DRAGON_BALL,
                                'sub_id' => $sub_id,
                                'count' => 1,
                            ];
                        }
                    }
                    return false;

                case ITEM_TYPE_EQUIP:
                    $equip_lib = new EquipLib();
                    if ($count > 1) {
                        $result = [];
                        for ($i = 0; $i < $count; $i++) {
                            $user_equip_id = $equip_lib->addEquip($user_id, $sub_id);
                            if ($user_equip_id > 0) {
                                $result[] =  [
                                    'pk_id'   => $user_equip_id,
                                    'item_id' => ITEM_TYPE_EQUIP,
                                    'sub_id'  => $sub_id,
                                    'count'   => 1,
                                ];
                            }
                        }
                        return empty ($result) ? false : $result;
                    } else if ($count == 1) {
                        $user_equip_id = $equip_lib->addEquip($user_id, $sub_id);
                        if (FALSE === $user_equip_id) {
                            return false;
                        }
                        if ($user_equip_id > 0) {
                            return [
                                'pk_id'   => $user_equip_id,
                                'item_id' => ITEM_TYPE_EQUIP,
                                'sub_id'  => $sub_id,
                                'count'   => 1,
                            ];
                        }
                    }
                    return false;

                case ITEM_TYPE_HERO_FRAGMENT:
                    $card_lib = new CardLib();
                    if (! $card_lib->updateCardPiece($user_id, $sub_id, $count)) {
                        return false;
                    }
                    break;

                case ITEM_TYPE_DRAGON_BALL_FRAGMENT:
                    $dragon_ball_lib = new DragonBallLib();
                    if (! $dragon_ball_lib->addFragment($user_id, $sub_id, $count)) {
                        return false;
                    }
                    break;

                case ITEM_TYPE_EQUIP_FRAGMENT:
                    $equip_lib = new EquipLib();
                    if (! $equip_lib->updatePiece($user_id, $sub_id, $count)) {
                        return false;
                    }
                default:
            }
            return true;
        }
        return false;
    }

    public function addInternalItemBatch($user_id, $item_list)
    {
        if (empty ($item_list)) {
            throw new Exception("Item list cannot be empty in addItemBatch Method", ERROR_CODE_DATA_INVALID_ITEM);
        }
        $items = [];
        foreach ($item_list as $item) {
            $item_id = $item['item_id'];
            if (self::available($item_id)) {
                $field = "{$item_id}:{$item['sub_id']}";
                if (isset ($items[$field])) {
                    $items[$field] += $item['count'];
                } else {
                    $items[$field] = $item['count'];
                }
            } else {
                throw new Exception("Unsupported Item ID:{$item_id}", ERROR_CODE_DATA_INVALID_ITEM);
            }
        }
        if (! empty ($items)) {
            $cache_key = self::itemListKey($user_id);
            $this->hMIncrBy($cache_key, $items);
            return true;
        }
        return false;
    }

    public function useItem($user_id, $item_id, $sub_id, $count, $user_card_count = [])
    {
        if (! ($user_id && $item_id && $sub_id)) {
            throw new Exception('数据传输错误', ERROR_CODE_FAIL);
        }
        $result = [];
        if (self::available($item_id)) {
            $item_list = $this->listItem($user_id);
            $item_key  = $item_id . ':' . $sub_id;
            if (isset ($item_list[$item_key]) && ( intval($item_list[$item_key]) - $count ) >= 0) {
                switch ($item_id) {
                    case ITEM_TYPE_TRAIL_MEDICINE:
                        $result['result'] = true;
                        break;

                    case ITEM_TYPE_GACHA_TICKET:
                        $result['result'] = true;
                        break;

                    case ITEM_TYPE_EXP_MEDICINE:
                        if (! $user_card_count) {
                            $result['result'] = false;
                            $result['msg']    = "Invalid card count for user_card_ids.";
                            return $result;
                        }
                        $card_lib = new CardLib();
                        $exp = self::$EXP_MDC_AMOUNT[$sub_id];
                        foreach ($user_card_count as $user_card_id => $mdc_count) {
                            $exp_delta = $exp * $mdc_count;
                            $ret = $card_lib->addExpForCards($user_id, [$user_card_id], $exp_delta) ? true : false;
                            if ($ret) {
                                $result['result'] = true;
                            } else {
                                $result['result'] = false;
                                $result['msg']    = "Failed to add exp to user:{$user_id}, user_card_id:{$user_card_id}";
                                return $result;
                            }
                        }

                        break;
                    case ITEM_TYPE_ENERGY_MEDICINE:
                        $user_lib = $this->getDI()->getShared('user_lib');
                        $user = $user_lib->getUser($user_id);
                        $user_level_cfg = self::getGameConfig('user_level');
                        $user_energy = $user[UserLib::$USER_PROF_FIELD_ENERGY];
                        $enery_limit = $user_level_cfg ['level_config'] [$user[UserLib::$USER_PROF_FIELD_LEVEL]] ['mission_energy_limit'];
                        if ($user_energy < $enery_limit) {
                            $user_lib->addMissionEnergy($user_id, self::$ENERGY_MDC_AMOUNT[$sub_id]);
                            $result['result'] = true;
                        } else {
                            $result['result'] = false;
                            syslog(LOG_DEBUG, "Failed to add energy to user:{$user_id}, energy over the limit.");
                            $result['msg'] = "能量已超过上限，无法使用";
                        }
                        break;
                    case ITEM_TYPE_GENKI_MEDICINE:
                        $user_lib = $this->getDI()->getShared('user_lib');
                        $user = $user_lib->getUser($user_id);
                        $genki = $user[UserLib::$USER_PROF_FIELD_ROB_ENERGY];
                        if ($genki < RobLib::$FREE_ROB_ENERGY) {
                            $user_lib->addRobEnergy($user_id, self::$GENKI_MDC_AMOUNT);
                            $result['result'] = true;
                        } else {
                            $result['result'] = false;
                            syslog(LOG_DEBUG, "Failed to add genki to user:{$user_id}, energy over the limit.");
                            $result['msg'] = "元力已超过上限，无法使用";
                        }
                        break;
                    case ITEM_TYPE_AVOID_FIGHT_TOKEN:
                        $rob_lib = new RobLib();
                        // 如果目前用户还处于免战状态
                        $result['result'] = false;
                        if ($rob_lib->getRobExempt($user_id)) {
                            $result['result'] = false;
                            $result['msg'] = "Failed to use avoid-fighting token:token in use";
                        } else {
                            if ($rob_lib->setRobExempt($user_id, self::$item_ttl[ITEM_TYPE_AVOID_FIGHT_TOKEN])) {
                                $result['result'] = true;
                            } else {
                                $result['result'] = false;
                                $result['msg'] = "Failed to use avoid-fight token:roblib error";
                            }
                        }
                        break;


                    case ITEM_TYPE_TREASURE_BOX:
                        $box_config  = self::getGameConfig('treasure_box')[$sub_id];
                        $key_to_open = $box_config['key'];
                        // 有的宝箱可能不需要钥匙，所以需要预先判断一下
                        if (! empty ($key_to_open)) {
                            $key_field   = ITEM_TYPE_TREASURE_BOX_KEY . ':' . $key_to_open;
                            // 如果用户有钥匙
                            if (array_key_exists($key_field, $item_list) && intval($item_list[$key_field]) > 0) {
                                $key_count = intval($item_list[$key_field]);
                                $count = min($key_count, $count);
                                $this->addItem($user_id, ITEM_TYPE_TREASURE_BOX_KEY, $sub_id, -$count);
                            }
                        }
                        $get_content = $this->unpackTreasureBox($user_id, $box_config['content'], $count);

                        if ($get_content) {
                            $result['result'] = true;
                            $result['new_items'] = $get_content;
                        } else {
                            $result['result'] = false;
                        }
                        break;

                    case ITEM_TYPE_TREASURE_BOX_KEY:
                        $box_id = implode(':', [ITEM_TYPE_TREASURE_BOX, $sub_id]);
                        $box_count = $item_list[$box_id];
                        $count = min($count, $box_count);
                        // 如果现在用户道具中有可以用此钥匙打开的宝箱
                        if (intval($box_count) > 0) {
                            $box_config = self::getGameConfig('treasure_box');
                            $box_content = $box_config[$sub_id]['content'];
                            $get_content = $this->unpackTreasureBox($user_id, $box_content, $count);
                            if ($get_content) {
                                $result['result'] = true;
                                $result['new_items'] = $get_content;
                            } else {
                                $result['result'] = false;
                            }
                            // 消耗宝箱
                            $this->addItem($user_id, ITEM_TYPE_TREASURE_BOX, $sub_id, -$count);
                            break;
                        } else {
                            $result['result'] = false;
                            $result['msg'] = '宝箱数量不足，无法开启';
                        }
                        break;

                    case ITEM_TYPE_GIFT_BOX:
                        $gift_content = self::getGameConfig('gift_box')[$sub_id]['content'];
                        $get_content  = $this->unpackGiftBox($user_id, $gift_content, $count);
                        if ($get_content) {
                            $result['result'] = true;
                            $result['new_items'] = $get_content;
                        } else {
                            $result['result'] = false;
                        }
                        break;

                    default:
                        // TODO 找不到对应的道具类型，这不应该发生，抛出异常
                        $result['result'] = false;
                        $result['msg'] = "Cannot find item type:{$item_id}";
                }
                if ($result['result']) {
                    $this->addItem($user_id, $item_id, $sub_id, -$count);
                }
            }
            else {
                $result['result'] = false;
                $result['msg']    = "Count of item:{$item_id}, sub_id:{$sub_id} is not enough, need {$count}";
            }
            $this->incrItemUse($item_id, $sub_id, $count);
        }
        return $result;
    }

    // 检测item_id是否可以用于显示或者使用
    private static function available($item_id)
    {
        return in_array(intval($item_id), self::$list_available);
    }

    // 检测item_id是否属于外部道具范围
    private static function externalAvailable($item_id)
    {
        return in_array(intval($item_id), self::$external_available);
    }

    private function myRedisIncrBy($cache_key, $field, $delta)
    {
        $count = $this->redis->hIncrBy($cache_key, $field, $delta);
        if ($count < 0) {
            $this->redis->hIncrBy($cache_key, $field, - $delta);
        } else if ($count == 0) {
            $this->redis->hDel($cache_key, $field);
        } else if ($count > self::$ITEM_MAX_COUNT) {
            $this->redis->hSet($cache_key, $field, self::$ITEM_MAX_COUNT);
        }
    }

    public function unpackTreasureBox($user_id, $box_content, $box_count = 1)
    {
        $get_content = [];
        $roll_poll = [];
        $start = 0;
        foreach ($box_content as $item) {
            $chance = intval($item['chance']);
            if ($chance > 0) {
                $roll_key = implode(':', [$item['item_id'], $item['sub_id'], $item['count']]);
                $roll_poll[$roll_key] = $start + $chance;
                $start += $chance;
            } else {
            // 如果配置中概率为0，该道具就是一定会送给用户的
                if (! in_array($item['item_id'], [ITEM_TYPE_HERO, ITEM_TYPE_DRAGON_BALL, ITEM_TYPE_EQUIP])) {
                    $ret = $this->addItem($user_id, $item['item_id'], $item['sub_id'], $item['count'] * $box_count);
                    $ret && array_push($get_content, [
                        'item_id' => $item['item_id'],
                        'sub_id'  => $item['sub_id'],
                        'count'   => $item['count'] * $box_count,
                    ]);
                }
            }
        }
        if ($start) {
            for ($i = 0; $i < $box_count; $i++) {
                $roll = mt_rand(1, $start);
                foreach ($roll_poll as $roll_key => $chance) {
                    // roll到物品
                    if ($roll <= $chance) {
                        list ($item_id, $sub_id, $count) = explode(':', $roll_key);
                        $ret = $this->addItem($user_id, $item_id, $sub_id, $count);
                        if (is_scalar($ret) && $ret) {
                            $duplicated = false;
                            foreach ($get_content as & $c) {
                                if (($c['item_id'] == $item_id) && ($c['sub_id'] == $sub_id)) {
                                    $c['count'] = $c['count'] + $count;
                                    $duplicated = true;
                                    break;
                                }
                            }
                            if (! $duplicated) {
                                array_push($get_content, [
                                    'item_id' => $item_id,
                                    'sub_id'  => $sub_id,
                                    'count'   => $count,
                                ]);
                            }
                        } else if (is_array($ret)) {
                            array_push($get_content, [
                                'pk_id'   => $ret['pk_id'],
                                'item_id' => $ret['item_id'],
                                'sub_id'  => $sub_id,
                                'count'   => $ret['count'],
                            ]);
                        }
						break;
                    }
                }
            }
        }
        return $get_content;
    }

    public function unpackGiftBox($user_id, $box_content, $count = 1)
    {
        $get_content = [];
        for ($i = 0; $i < $count; $i++) {
            foreach ($box_content as $content) {
                $ret = $this->addItem($user_id, $content['item_id'], $content['sub_id'], $content['count']);
                if (is_scalar($ret) && $ret) {
                    $duplicated = false;
                    foreach ($get_content as & $c) {
                        if (($c['item_id'] == $content['item_id'])
                            && ($c['sub_id'] == $content['sub_id'])) {
                            $c['count'] = $c['count'] + $content['count'];
                            $duplicated = true;
                            break;
                        }
                    }
                    if (! $duplicated) {
                        array_push($get_content, [
                            'item_id' => $content['item_id'],
                            'sub_id'  => $content['sub_id'],
                            'count'   => $content['count'],
                        ]);
                    }
                } else if (is_array($ret)) {
                    array_push($get_content, [
                        'pk_id'   => $ret['pk_id'],
                        'item_id' => $ret['item_id'],
                        'sub_id'  => $content['sub_id'],
                        'count'   => $ret['count'],
                    ]);
                }
            }
        }

        return $get_content;
    }

    public function getItemCount($user_id, $item_id, $sub_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_ITEMS, $user_id);
        $item_key = $item_id . ':' . $sub_id;
        $count = $this->redis->hGet($cache_key, $item_key);
        return $count ? $count : 0;
    }

    private function hMIncrBy($key, $incr_arr)
    {
        $key_count = count($incr_arr);
        $params = $scripts = [];
        $key_start = 1;
        $argv_start = 1 + $key_count;
        foreach ($incr_arr as $field => $value) {
            $scripts[] = "redis.call('hIncrBy', '{$key}', KEYS[{$key_start}], ARGV[$key_start])";
            $params[$key_start] = $field;
            $params[$argv_start] = $value;
            $key_start ++;
            $argv_start ++;
        }
        ksort($params);
        $scripts = implode(';', $scripts);
        $this->redis->eval($scripts, $params, $key_count);
    }

    private function incrItemUse($item_id, $sub_id, $count)
    {
        $key = "$item_id:$sub_id";
        if ($this->redis->exists(self::$CACHE_KEY_MONTH_CONSUME)) {
            $this->redis->hIncrBy(self::$CACHE_KEY_MONTH_CONSUME, $key, $count);
        } else {
            $this->redis->hIncrBy(self::$CACHE_KEY_MONTH_CONSUME, $key, $count);
            $expire = self::getDefaultExpire();
            $this->redis->expireAt(self::$CACHE_KEY_MONTH_CONSUME, $expire);
        }
    }
}
