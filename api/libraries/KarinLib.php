<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-28
 * Time: 下午9:19
 */
namespace Cap\Libraries;

use Phalcon\Exception;

class KarinLib extends BaseLib
{
    public  static $KARIN_FLOOR_KEY        = "nami:karin:floor:%s";
    public  static $KARIN_RESET_KEY        = "nami:karin:reset:%s";
    public  static $KARIN_TODAY_COUNT_KEY  = "nami:karin:today:%s";
    public  static $KARIN_RANK_KEY_FLOOR   = "nami:karin:rank:floor";
    public  static $KARIN_RANK_KEY_TIME    = "nami:karin:rank:time";
    public  static $KARIN_RANK_KEY_TOTAL   = "nami:karin:rank:total";
    public  static $KARIN_RANK_KEY_DETAILS = "nami:karin:rank:details";

    public  static $FIELD_VIP_KARIN_RESET  = "karin_reset_time";
    private static $FILED_CURRENT_FLOOR    = 'cur_floor'; // 当前所在层数
    private static $FILED_MAX_FLOOR        = 'max_floor'; // 最高所在的层数
    public  static $WIPE_DIAMOND_COST      = 50; // 扫荡需要的钻石数量

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('item_lib', function() {
            return new ItemLib();
        }, true);
        $this->_di->set('card_lib', function() {
            return new CardLib();
        }, true);
        $this->_di->set('user_lib', function() {
           return new UserLib();
        }, true);
    }

    public function status($user_id)
    {
        $floor_info = $this->getFloorInfo($user_id);
        $reset_time = $this->getResetTime($user_id);
        $result = $floor_info + $reset_time;
        return $result;
    }

    private function getFloorInfo($user_id)
    {
        $floor_key = sprintf(self::$KARIN_FLOOR_KEY, $user_id);
        $floor_info = $this->redis->hGetAll($floor_key);
        if (! $floor_info) {
            $floor_info[self::$FILED_MAX_FLOOR]     = 1;
            $floor_info[self::$FILED_CURRENT_FLOOR] = 1;
            $this->redis->hMset($floor_key, $floor_info);
        }
        return $floor_info;
    }

    private function getResetTime($user_id)
    {
        $reset_time_key = sprintf(self::$KARIN_RESET_KEY, $user_id);
        $reset_time = $this->redis->get($reset_time_key);
        if (false === $reset_time) {
            $reset_time = 0;
            // 第二天凌晨5点，重置次数失效
            $expire = self::getDefaultExpire();
            $this->redis->set($reset_time_key, $reset_time);
            $this->redis->expireAt($reset_time_key, $expire);
        }
        return [self::$FIELD_VIP_KARIN_RESET => $reset_time];
    }

    public function pass($user_id, $floor, $result)
    {
        // kpi埋点
        (new KpiLib())->recordSysJoin($user_id, KpiLib::$EVENT_TYPE_KARIN);
        if ($result) {
            $status        = $this->getFloorInfo($user_id);
            $current_floor = $status[self::$FILED_CURRENT_FLOOR];
            $max_floor     = $status[self::$FILED_MAX_FLOOR];
            // 如果当前已经在卡林神塔最高层
            if (KARIN_MAX_FLOOR < $current_floor) {
                throw new Exception("已达到最大层数.", ERROR_CODE_DATA_INVALID_KARIN);
            }
            // 如果前端传过来的层数信息和后端存储的当前层数不符
            if ($floor != $current_floor) {
                throw new Exception("Floor Does Not Match Current Floor", ERROR_CODE_FAIL);
            }

            $floor_key = sprintf(self::$KARIN_FLOOR_KEY, $user_id);
            // 突破了自己的极限,更新排行榜数据
            if ($max_floor == $current_floor) {
                $this->redis->hIncrBy($floor_key, self::$FILED_CURRENT_FLOOR, 1);
                $this->redis->hIncrBy($floor_key, self::$FILED_MAX_FLOOR, 1);

                $pass_time = strtotime('2020-01-01') - time();
                $this->redis->zadd(self::$KARIN_RANK_KEY_TIME,  $pass_time,     $user_id);
                $this->redis->zadd(self::$KARIN_RANK_KEY_FLOOR, min(KARIN_MAX_FLOOR, $max_floor), $user_id);
            } else if ($max_floor > $current_floor) {
                // 当前还没有爬到已能爬到的最高层
                $this->redis->hIncrBy($floor_key, self::$FILED_CURRENT_FLOOR, 1);
            }
            $this->incrTodayCount($user_id);
            $bonus = $this->giveBonus($user_id, [$current_floor]);
            $result = ['code' => ERROR_CODE_OK, 'drops' => $bonus['boxes']];

            // 获得当前用户的基本信息
            $user_lib = $this->_di->getShared('user_lib');
            $user = $user_lib->getUser($user_id);
            $result['level'] = $user[UserLib::$USER_PROF_FIELD_LEVEL];
            $result['exp']   = $user[UserLib::$USER_PROF_FIELD_EXP];
            $result['coin']  = $user[UserLib::$USER_PROF_FIELD_COIN];
            return $result;
        } else {
            // TODO 记录一条爬塔战斗失败日志
            return ['code' => ERROR_CODE_OK];
        }
    }

    public function reset($user_id)
    {
        $status = $this->getResetTime($user_id);
        $reset_times = $status[self::$FIELD_VIP_KARIN_RESET];

        $user_lib = new UserLib();
        $vip_config = self::getGameConfig('user_vip');
        $current_user = $user_lib->getUser($user_id);
        $vip_level = $current_user[UserLib::$USER_PROF_FIELD_VIP];
        $reset_limit = $vip_config[$vip_level]['karin_reset_time'];

        // 如果目前还剩余重置次数
        if ($reset_times < $reset_limit) {
            $reset_key = sprintf(self::$KARIN_RESET_KEY, $user_id);
            $floor_key = sprintf(self::$KARIN_FLOOR_KEY, $user_id);
            $this->redis->incr($reset_key);
            $this->redis->hSet($floor_key, self::$FILED_CURRENT_FLOOR, 1);
            return [
                'code'   => ERROR_CODE_OK,
                'reset_times' => $reset_times + 1,
                'msg'    => 'OK',
            ];
        } else {
            throw new Exception("重置次数不足！", ERROR_CODE_DATA_INVALID_KARIN);
        }
    }

    public function wipe($user_id)
    {
        $floor_info = $this->getFloorInfo($user_id);
        $cur_floor = $floor_info[self::$FILED_CURRENT_FLOOR];
        $max_floor = $floor_info[self::$FILED_MAX_FLOOR];

        if ($cur_floor == $max_floor) {
            throw new Exception("已在最高楼层，无法扫荡.", ERROR_CODE_DATA_INVALID_KARIN);
        }

        $floors = range($cur_floor, $max_floor - 1);
        $bonus = $this->giveBonus($user_id, $floors);
        $floor_key = sprintf(self::$KARIN_FLOOR_KEY, $user_id);
        $this->redis->hSet($floor_key, self::$FILED_CURRENT_FLOOR, $max_floor);
        $this->incrTodayCount($user_id);
        // kpi埋点
        (new KpiLib())->recordSysJoin($user_id, KpiLib::$EVENT_TYPE_KARIN);
        return [
            'code' => ERROR_CODE_OK,
            'cur_floor' => $max_floor,
            'bonus' => $bonus,
        ];
    }

    public function rank($user_id)
    {
        $result = [
            'leaderboard' => [],
            'user_rank'   => -1,
        ];
        if ($this->redis->exists(self::$KARIN_RANK_KEY_TOTAL)) {
            // 取出前50名
            $leaderboard = $this->redis->get(self::$KARIN_RANK_KEY_DETAILS);
            $user_rank = $this->redis->zRevRank(self::$KARIN_RANK_KEY_TOTAL, $user_id);
            if ($leaderboard) {
                $result['leaderboard'] = json_decode($leaderboard, true);
            }
            if (false !== $user_rank) {
                $result['user_rank'] = $user_rank + 1;
            }
        }
        return $result;
    }

    private function giveBonus($user_id, $floors)
    {
        $sony = 0;
        $boxes = [];
        foreach ($floors as $f) {
            $bonus = self::getGameConfig('karin_bonus')[$f];
            if (isset ($bonus['box'])) {
                $boxes[] = [
                    'item_id' => ITEM_TYPE_TREASURE_BOX,
                    'sub_id'  => $bonus['box'],
                    'count'   => 1,
                ];
            }
            if (isset ($bonus['sony'])) {
                $sony += $bonus['sony'];
            }
        }
        $item_lib = $this->_di->getShared('item_lib');
        $ret = [
            'sony' => 0,
            'boxes' => [],
        ];
        if ($sony) {
            $item_lib->addItem($user_id, ITEM_TYPE_SONY, 1, $sony);
            $ret['sony'] = $sony;
        }
        if ($boxes) {
            $item_lib->addInternalItemBatch($user_id, $boxes);
            $ret['boxes'] = $boxes;
        }
        return $ret;
    }

    public function getTodayCount($user_id) {
        $cache_key = sprintf(self::$KARIN_TODAY_COUNT_KEY, $user_id);
        $count = $this->redis->get($cache_key);
        return $count ? intval($count) : 0;
    }

    private function incrTodayCount($user_id)
    {
        $cache_key = sprintf(self::$KARIN_TODAY_COUNT_KEY, $user_id);
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
