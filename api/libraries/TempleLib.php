<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-7
 * Time: 下午2:45
 */
namespace Cap\Libraries;

use Cap\Models\Db\UserWorshipModel;
use Phalcon\Exception;

class TempleLib extends BaseLib
{
    public static $CACHE_KEY_TEMPLE_STATUS_STATIC  = 'nami:temple:%s';
    public static $CONDITION_USER_LEVEL = 1;
    public static $CONDITION_MAX_SECTION = 2;
    public static $CONDITION_LAST_GOD_LEVEL = 3;

    public static $WORSHIP_DMD_NEED = [
        1 => 10,
        2 => 15,
        3 => 15,
        4 => 20,
    ];
    public function __construct()
    {
        parent::__construct();
        $this->_di->set('user_lib', function () {
            return new UserLib();
        }, true);
        $this->_di->set('resque_lib', function () {
            return new ResqueLib();
        }, true);
        $this->_di->set('item_lib', function () {
            return new ItemLib();
        }, true);
        $this->_di->set('worship_model', function () {
            return new UserWorshipModel();
        }, true);
    }

    public function status($user_id, $origin = false)
    {
        $temple_cfg  = self::getGameConfig('temple');
        $cache_key = sprintf(self::$CACHE_KEY_TEMPLE_STATUS_STATIC, $user_id);
        $result = $this->redis->hGetAll($cache_key);

        if (! $result) {
            foreach ($temple_cfg as $god_id => $cfg) {
                $level_key = implode(':', ['level', $god_id]);
                $worship_count_key = implode(':', ['worship_count', $god_id]);
                $result[$level_key] = 0;
                $result[$worship_count_key] = 0;
            }
            $this->redis->hMSet($cache_key, $result);
        }

        $user_lib    = $this->getDI()->getShared('user_lib');
        $user        = $user_lib->getUser($user_id);
        // 每次重新计算天神的解锁条件
        foreach ($temple_cfg as $god_id => $cfg) {
            $unlock_key = implode(':', ['unlock', $god_id]);
            $condition = $cfg['unlock_condition'];
            $type  = $condition['type'];
            $limit = $condition['value'];
            $unlock = 0;
            switch ($type) {
                case self::$CONDITION_USER_LEVEL:
                    $user_level = $user[UserLib::$USER_PROF_FIELD_LEVEL];
                    if ($user_level >= $limit) {
                        $unlock = 1;
                    }
                    break;
                case self::$CONDITION_MAX_SECTION:
                    $max_section = $user[UserLib::$USER_PROF_FIELD_SECTION];
                    if ($max_section >= $limit) {
                        $unlock = 1;
                    }
                    break;
                case self::$CONDITION_LAST_GOD_LEVEL:
                    $last_god_level_key = implode(':', ['level', $god_id - 1]);
                    $level = $result[$last_god_level_key];
                    if ($level >= $limit) {
                        $unlock = 1;
                    }
                    break;
                default:
            }
            $result[$unlock_key] = $unlock;
        }
        if (! $origin) {
            $result = $this->formatStatus($result);
            $worship_model = $this->_di->getShared('worship_model');
            $today_count = $worship_model->getAllWorship($user_id);
            foreach ($result as $key => $item) {
                $result[$key]['today_count'] = 0;
            }
            foreach ($today_count as $item) {
                $god_id = $item['god_id'];
                if (isset ($result[$god_id])) {
                    $result[$god_id]['today_count']++;
                }
            }
        }
        return $result;
    }

    public function worship($user_id, $god_id)
    {
        $temple_cfg = self::getGameConfig('temple');
        $result = ['code' => ERROR_CODE_FAIL, 'msg' => 'Unknown Error.'];
        if (! isset ($temple_cfg[$god_id])) {
            throw new Exception("God ID Not Defined:{$god_id}", ERROR_CODE_PARAM_INVALID);
        }
        $vip_cfg       = self::getGameConfig('user_vip');
        $now           = time();
        $user_lib      = $this->getDI()->getShared('user_lib');
        $worship_model = $this->getDI()->getShared('worship_model');
        $user_info     = $user_lib->getUser($user_id);
        $user_vip      = $user_info[UserLib::$USER_PROF_FIELD_VIP];
        $worship_limit = $vip_cfg[$user_vip]['temple_worship_time'];
        $open_times    = $temple_cfg[$god_id]['open_time'];

        $hit = false;
        $god_status = $this->status($user_id, false);
        $is_unlock = $god_status[$god_id]['unlock'];
        if (! $is_unlock) {
            throw new Exception('天神尚未解锁，不可膜拜', ERROR_CODE_FAIL);
        }
        $today_count = $god_status[$god_id]['today_count'];
        foreach ($open_times as $worship_id => $period) {
            global $hit;
            $start = strtotime($period['start']);
            $end   = strtotime($period['end']);
            // 在活动时间内
            if ($start <= $now && $now <= $end) {
                $hit = true;
                // 判断活动时间内膜拜次数是否超限
                $count = $worship_model->worshipCount($user_id, $god_id, $worship_id);
                if ($count >= 0 && $count < $worship_limit) {
                    $status = $this->status($user_id, true);
                    $level_key = implode(':', ['level', $god_id]);
                    $worship_count_key = implode(':', ['worship_count', $god_id]);
                    $worship_model->addWorship($user_id, $god_id, $worship_id, $status[$level_key]);

                    // 钻石数量是否足够支付本次膜拜
                    $dmd_need = $today_count == 0 ? 0 : self::$WORSHIP_DMD_NEED[$god_id];
                    if ($dmd_need <= $user_info[UserLib::$USER_PROF_FIELD_GOLD]) {
                        if (intval($dmd_need) > 0) {
                            $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_GOLD, $dmd_need);
                        }
                        $status[$worship_count_key]++;
                        $bonus = $this->calBonus($god_id, $status[$level_key], $temple_cfg);
                        $item_lib = $this->getDI()->getShared('item_lib');
                        foreach ($bonus as $value) {
                            $item_lib->addItem($user_id, $value['item_id'], $value['sub_id'], $value['count']);
                        }
                        // 计算膜拜后天神等级
                        $level_limit = $temple_cfg[$god_id]['level_limit'][$status[$level_key]];
                        if ($status[$worship_count_key] >= $level_limit) {
                            $status[$level_key]++;
                            $status[$worship_count_key] = 0;
                        }
                        $new_unlock = $this->unlockNewGod($status, $temple_cfg);
                        $cache_key = sprintf(self::$CACHE_KEY_TEMPLE_STATUS_STATIC, $user_id);
                        $this->redis->hMSet($cache_key, $status);
                        $result = [
                            'code' => ERROR_CODE_OK,
                            'msg'    => 'OK',
                            'bonus'  => $bonus,
                            'level'  => $status[$level_key],
                            'new_unlock' => intval($new_unlock),
                        ];
                        // kpi埋点
                        (new KpiLib())->recordSysJoin($user_id, KpiLib::$EVENT_TYPE_TEMPLE);
                        return $result;
                    } else {
                        $result['msg'] = '膜拜所需钻石不足.';
                        return $result;
                    }
                }
                else
                {
                    $result['msg'] = '膜拜次数超限.';
                    return $result;
                }
                break;
            }
        }
        if (! $hit) {
            $result['msg'] = '天神还未开启.';
            return $result;
        }
        return $result;
    }

    private function unlockNewGod(& $status, & $temple_cfg = null)
    {
        if (! $temple_cfg) {
            $temple_cfg  = self::getGameConfig('temple');
        }
        $sts_arr = $this->formatStatus($status);
        ksort($sts_arr);
        $last_god_id = 0;
        foreach ($sts_arr as $god_id => $value) {
            if (! $value['unlock']) {
                $conditions = $temple_cfg[$god_id]['unlock_condition'];
                foreach ($conditions as $cdt) {
                    $type  = $cdt['type'];
                    $limit = $cdt['value'];
                    if (self::$CONDITION_LAST_GOD_LEVEL == $type) {
                        if ( $last_god_id && ($sts_arr[$last_god_id]['level'] >= $limit) ) {
                            $level_key  = implode(':', ['level', $god_id]);
                            $unlock_key = implode(':', ['unlock', $god_id]);
                            $worship_count_key = implode(':', ['worship_count', $god_id]);
                            $status[$level_key] = 0;
                            $status[$unlock_key] = 1;
                            $status[$worship_count_key] = 0;
                            return $god_id;
                        }
                    }
                }
            } else {
                $last_god_id = $god_id;
            }
        }
        return false;
    }

    private function calBonus($god_id, $god_level, & $temple_cfg = null)
    {
        if (! $temple_cfg) {
            $temple_cfg  = self::getGameConfig('temple');
        }
        $bonus = [];
        if (! isset ($temple_cfg[$god_id])) {
            throw new Exception("God Id Not Defined", ERROR_CODE_CONFIG_NOT_FOUND);
        }
        $bonus_cfg = $temple_cfg[$god_id]['bonus'][$god_level];
        $sony = $bonus_cfg['sony'];
        $bonus[] = [
            'item_id' => ITEM_TYPE_SONY,
            'sub_id'  => 1,
            'count'   => $sony,
        ];
        if (isset ($bonus_cfg['box'])) {
            $box_id = $bonus_cfg['box']['id'];
            $box_chance = $bonus_cfg['box']['chance'];
            if (mt_rand(1, 10000) <= $box_chance) {
                // ROLL到了
                $bonus[] = [
                    'item_id' => ITEM_TYPE_TREASURE_BOX,
                    'sub_id'  => $box_id,
                    'count'   => 1,
                ];
            }
        }
        return $bonus;
    }

    private function formatStatus($status)
    {
        $sts_arr = [];

        foreach ($status as $key => $value) {
            list ($field, $god_id) = explode(':', $key);
            $sts_arr[$god_id][$field] = $value;
        }
        return $sts_arr;
    }

    public function getTotalWorshipCount($user_id)
    {
        $worship_model = $this->_di->getShared('worship_model');
        $count = $worship_model->worshipTotalCount($user_id);

        return $count;
    }
}
