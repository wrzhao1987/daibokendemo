<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-8-25
 * Time: 下午2:04
 */
namespace Cap\Libraries;
use Phalcon\Exception;
require_once 'LoginIndexLib.php';

class CrusadeLib extends BaseLib
{
    public static $CACHE_KEY_CRUSADE       = 'nami:crusade:%s'; // Hash Set
    public static $CACHE_KEY_CRUSADE_RESET = 'nami:crusade:reset:%s'; // Expire Key
    public static $CACHE_KEY_CRUSADE_TODAY_PASS = 'nami:crusade:daypass:%s'; // Daily Pass
    public static $CACHE_KEY_CRUSADE_ROBOTS = 'nami:crusade:robots';

    public static $FIELD_PLAYER_STAT = 'player_stat';
    public static $FIELD_PLAYER_FORM = 'player_form';
    public static $FIELD_ENEMY_STAT  = 'enemy_stat';
    public static $FILED_ENEMIES     = 'enemies';
    public static $FIELD_PLAYER      = 'player';
    public static $FIELD_MAX_PASS    = 'max_pass';
    public static $FIELD_RESET_TIME  = 'crusade_reset_time';
    public static $FIELD_FRD_SELECTED = 'frd_selected';

    public static $CRUSADE_WAVES = 18;

    public static $CRUSADE_BOX_IDS = [31, 31, 27, 31, 31, 27, 31, 31, 28, 31, 31, 28, 32, 32, 29, 32, 32, 30];

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('card_lib', function ()  {
            return new CardLib();
        }, true);
        $this->_di->set('user_lib', function ()  {
            return new UserLib();
        }, true);
        $this->_di->set('item_lib', function ()  {
            return new ItemLib();
        }, true);
        $this->_di->set("loginindex_lib", function(){
            return new \LoginIndexLib();
        }, true);
        $this->_di->set("resque_lib", function() {
            return new ResqueLib();
        }, true);
    }

    public function status($user_id)
    {
        // 获得燃烧远征基本数据
        $cache_key = sprintf(self::$CACHE_KEY_CRUSADE, $user_id);
        $stat = $this->redis->hGetAll($cache_key);
        if (! $stat) {
            $stat = $this->initStatus($user_id);
        } else {
            foreach ($stat as & $item) {
                $item = json_decode($item, true);
            }
        }
        $cache_key_reset = sprintf(self::$CACHE_KEY_CRUSADE_RESET, $user_id);
        $reset_time = $this->redis->get($cache_key_reset);
        if (false === $reset_time) {
            $expire = $this->getDefaultExpire();
            $this->redis->set($cache_key_reset, 0);
            $this->redis->expireAt($cache_key_reset, $expire);
        }
        $stat[self::$FIELD_RESET_TIME] = intval($reset_time);

        return $stat;
    }

    public function begin($user_id, $progress, $deck_form, $friend_id = null)
    {
        $ret = ['code' => 200];
        $cache_key = sprintf(self::$CACHE_KEY_CRUSADE, $user_id);
        // 开始远征，需要记录当前用户卡组和雇佣好友的情况
        if (1 == $progress) {
            $card_lib = $this->getDI()->getShared('card_lib');
            $deck_mine = $card_lib->getDeckCard($user_id, false);
            if (intval($friend_id) > 0) {
                $deck_frd = $card_lib->getDeckCard($friend_id, false);
                $card_frd = $deck_frd[DeckLib::$USER_DECK_LEADER_POSITION];
                $coin = $this->giveFrdCoin($user_id, $friend_id, $card_frd);
                if ($coin > 0) {
                    $ret['content']['money'] = $coin;
                } else {
                    throw new Exception('没有足够的索尼币雇佣此好友.', ERROR_CODE_FAIL);
                }
                $deck_mine[DeckLib::$USER_DECK_FRIEND_POSITION] = $card_frd;
                $set[self::$FIELD_FRD_SELECTED] = 1;
            } else {
                $ret['content']['money'] = 0;
                unset($deck_mine[DeckLib::$USER_DECK_FRIEND_POSITION]);
            }
            foreach ($deck_mine as & $member) {
                unset($member['pve_pos']);
                unset($member['pvp_pos']);
            }
            $set[self::$FIELD_PLAYER] = json_encode(array_values($deck_mine), JSON_NUMERIC_CHECK);
            $set[self::$FIELD_PLAYER_FORM] = json_encode($deck_form, JSON_NUMERIC_CHECK);
            $this->redis->hMSet($cache_key, $set);
            // kpi埋点
            (new KpiLib())->recordSysJoin($user_id, KpiLib::$EVENT_TYPE_CRUSADE);
            // 刚刚进入远征，这步需要加载好友列表
        } else if (0 == intval($progress)) {
            $user_lib = $this->getDI()->getShared('user_lib');
            $frds = $user_lib->findSupportUsers($user_id, 5);
            $ret['content'] = $frds;
        } else {
            $this->redis->hSet($cache_key, self::$FIELD_PLAYER_FORM, json_encode($deck_form, JSON_NUMERIC_CHECK));
        }
        return $ret;
    }

    public function commit($user_id, $progress, $success, $user_data = [])
    {
        $ret = ['code' => 200, ];
        $cache_key = sprintf(self::$CACHE_KEY_CRUSADE, $user_id);
        $max_pass = $this->redis->hGet($cache_key, self::$FIELD_MAX_PASS);
        if ($progress != $max_pass + 1) {
            throw new Exception('提交步骤不正确.', ERROR_CODE_PARAM_INVALID);
        }
        $remainder = $progress % 2;
        if ($remainder) {
            // 提交战斗结果, user_data格式[[0.5, 0.44], [0.3, 1.0], ...]
            if ($success) {
                // 成功
                $stat = [
                    self::$FIELD_MAX_PASS => $progress,
                    self::$FIELD_PLAYER_STAT => json_encode($user_data),
                ];
                $this->redis->hMSet($cache_key, $stat);
                $this->incrTodayCount($user_id);
            } else {
                // 失败
                $this->redis->hSet($cache_key, self::$FIELD_ENEMY_STAT, json_encode($user_data, JSON_NUMERIC_CHECK));
            }
            // kpi埋点
            (new KpiLib())->recordSysJoin($user_id, KpiLib::$EVENT_TYPE_CRUSADE);
        } else {
            // 开宝箱
            $box_cfg = self::getGameConfig('treasure_box');
            $box_id = self::$CRUSADE_BOX_IDS[intval($progress / 2) - 1];
            $box_content = $box_cfg[$box_id]['content'];
            $user_lib = $this->getDI()->getShared('user_lib');
            $user = $user_lib->getUser($user_id);
            $user_level = $user[UserLib::$USER_PROF_FIELD_LEVEL];
            $coin = $this->calProgressCoin($user_level, intval($progress / 2));
            array_push($box_content, [
                'item_id' => ITEM_TYPE_SONY,
                'sub_id'  => 1,
                'count'   => $coin,
                'chance'  => 0,
            ]);
            $item_lib = $this->getDI()->getShared('item_lib');
            $unpack_ret = $item_lib->unpackTreasureBox($user_id, $box_content);
            $ret['content'] = $unpack_ret;

            $this->redis->hSet($cache_key, self::$FIELD_MAX_PASS, $progress);
        }
        return $ret;
    }

    public function reset($user_id)
    {
        $status = $this->status($user_id);
        $ret = ['code' => 200];
        if ($status[self::$FIELD_MAX_PASS] == 0 && empty ($status[self::$FIELD_ENEMY_STAT])) {
            throw new Exception('蛇道还未开始，无法重置.', ERROR_CODE_FAIL);
        }
        $reset_times = $status[self::$FIELD_RESET_TIME];
        $user_lib = new UserLib();
        $vip_config = self::getGameConfig('user_vip');
        $current_user = $user_lib->getUser($user_id);
        $vip_level = $current_user[UserLib::$USER_PROF_FIELD_VIP];
        $reset_limit = $vip_config[$vip_level]['crusade_reset_time'];

        if ($reset_times < $reset_limit) {
            $reset_key = sprintf(self::$CACHE_KEY_CRUSADE_RESET, $user_id);
            $this->redis->incr($reset_key);
            $ret['status'] = $this->initStatus($user_id);
        } else {
            throw new Exception('重置次数不足，无法重置.', ERROR_CODE_FAIL);
        }
        return $ret;
    }

    private function getEnemies($user_id)
    {
        $ret = [];

        $user_lib = $this->getDI()->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $user_level = $user[UserLib::$USER_PROF_FIELD_LEVEL];
        $start_level = $user_level - 5;
        $end_level = $user_level + 10;

        $loginindex_lib = $this->getDI()->getShared('loginindex_lib');
        $enemies = $loginindex_lib->findUsers($start_level, $end_level, 18, mt_rand(1, 100));
        $enemies = array_keys($enemies);
        syslog(LOG_DEBUG, "Search Crusade Enemies For User $user_id:$user_level ---" . json_encode($enemies));
        $card_lib = $this->getDI()->getShared('card_lib');
        $e_count = count($enemies);
        if ($e_count < 18) {
            $add_count = 18 - $e_count;
            $add_members = $this->redis->zRangeByScore(
                self::$CACHE_KEY_CRUSADE_ROBOTS,
                27,
                42,
                ['withscores' => true,]
            );
			$ids = array_keys($add_members);
            $keys = array_rand($ids, $add_count);
            if (is_int($keys)) {
                $enemies[] = $ids[$keys];
                syslog(LOG_DEBUG, "Adding Crusade Robot-" . $ids[$keys] ." For User $user_id:$user_level");
            } else if (is_array($keys)) {
                foreach ($keys as $val) {
                    $enemies[] = $ids[$val];
                    syslog(LOG_DEBUG, "Adding Crusade Robot-" . $ids[$val] ." For User $user_id:$user_level");
                }
            }
        }
        syslog(LOG_DEBUG, "Crusade $user_id:$user_level Enemies:" . json_encode($enemies));
        /**
        // 测试用，须删除
		$count = count($enemies);
        $i = $count;
        $j = 0;
        $start = 1168;
        while ($i < 18) {
            $id = $start + $j;
			$e_user = $user_lib->getUser($id);
			if (empty($e_user)) {
				$j++;
				continue;
			}
			if ($e_user[UserLib::$USER_PROF_FIELD_LEVEL] < 27) {
				$j++;
				continue;
			}
            if (isset ($enemies[$id])) {
                $j++;
            } else {
                $deck = $card_lib->getDeckCard($id, false);
                unset($deck[DeckLib::$USER_DECK_FRIEND_POSITION]);
                if (! is_bool($deck)) {
                    $enemies[$id] = 1;
                    $i++;
                } else {
                    $j++;
                }
            }
        }
         * **/
        ///////////////////////////////////////
        foreach ($enemies as $uid) {
            $enemy_info = $user_lib->getUser($uid);
            $e_deck = $card_lib->getDeckCard($uid, false);
            unset($e_deck[DeckLib::$USER_DECK_FRIEND_POSITION]);
            $new_e = [
                'level' => $enemy_info[UserLib::$USER_PROF_FIELD_LEVEL],
                'name'  => $enemy_info[UserLib::$USER_PROF_FIELD_NAME],
                'deck'  => array_values($e_deck),
            ];
			$ret[] = $new_e;
        }
		usort ($ret, function ($a, $b) {
			return $a['level'] > $b['level'];
		});
        return array_values($ret);
    }

    private function calProgressCoin($level, $section)
    {
        $coin = (120000 + ($level - 30) * 1500) / 9 * (1 + ($section - 9) * 0.05);
        return intval($coin);
    }

    private function giveFrdCoin($user_id, $frd_id, $frd_card)
    {
        $user_lib = $this->getDI()->getShared('user_lib');
        $coin = intval((20000 + $frd_card['level'] + $frd_card['strength']) * 1.1);
        $remain = $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, $coin);
        if ($remain) {
            $user_lib->addMercenaryFee($user_id, $frd_id, $coin);
            return $coin;
        } else {
            return 0;
        }
    }

    private function initStatus($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_CRUSADE, $user_id);
        $stat = [
            self::$FIELD_MAX_PASS => 0,
            self::$FIELD_PLAYER_STAT => [],
            self::$FIELD_ENEMY_STAT  => [],
            self::$FIELD_PLAYER => [],
            self::$FIELD_PLAYER_FORM => [],
            self::$FIELD_FRD_SELECTED => 0,
        ];
        $enemies = $this->getEnemies($user_id);
        /**
        if (empty ($enemies) || count($enemies) < self::$CRUSADE_WAVES) {
        throw new Exception("无法找到足够多的对手，请稍后刷新重试.", ERROR_CODE_FAIL);
        }
         * **/
        $stat[self::$FILED_ENEMIES] = $enemies;

        $tmp = [];
        foreach ($stat as $key => $item) {
            $tmp[$key] = json_encode($item, JSON_NUMERIC_CHECK);
        }
        $this->redis->hMSet($cache_key, $tmp);

        return $stat;
    }

    public function getTodayCount($user_id) {
        $cache_key = sprintf(self::$CACHE_KEY_CRUSADE_TODAY_PASS, $user_id);
        $count = $this->redis->get($cache_key);
        return $count ? intval($count) : 0;
    }

    private function incrTodayCount($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_CRUSADE_TODAY_PASS, $user_id);
        $expire = self::getDefaultExpire();

        if ($this->redis->exists($cache_key)) {
            $count = $this->redis->incr($cache_key);
        } else {
            $count = $this->redis->incr($cache_key);
            $this->redis->expireAt($cache_key, $expire);
        }
        return $count;
    }
}
