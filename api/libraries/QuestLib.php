<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-23
 * Time: 下午2:45
 */
namespace Cap\Libraries;

use Phalcon\Exception;
use Cap\Models\Db\QuestModel;
use Cap\Models\Db\DailyQuestModel;

class QuestLib extends BaseLib
{
    private $quest_cfg = null;
    public static $DAILY_QUEST_LIST = [
        100101, 100102, 100103, 100104, 100105,
        100106, 100107, 100108, 100109, 100117,
        100118, 100119, 100120, 900000, 900001,
		100121,
    ]; // 日常任务列表
    public static $BOOTSTRAP_QUEST_LIST   = [100201, 100301, 100401, 100601]; // 首次加载任务列表时需要LOAD的状态
    public static $CACHE_KEY_QUEST_DAILY  = 'nami:quest:daily:%s'; // 日常任务状态缓存，次日5点失效
    public static $CACHE_KEY_QUEST_NORMAL = 'nami:quest:normal:%s'; // 正常任务状态缓存，不失效

    private static $QUEST_TYPE_PVE_NORMAL     = 1;  // 通关任意副本
    private static $QUEST_TYPE_PVE_HERO       = 2;  // 通关精英副本
    private static $QUEST_TYPE_MIDAS          = 3;  // 点金手
    private static $QUEST_TYPE_ARENA          = 4;  // 进行擂台赛
    private static $QUEST_TYPE_ROB            = 5;  // 抢夺龙珠
    private static $QUEST_TYPE_WORSHIP        = 6;  // 膜拜天神
    private static $QUEST_TYPE_KARIN          = 7;  // 爬卡林神塔
    private static $QUEST_TYPE_EQUIP_ENHANCE  = 8;  // 装备强化
    private static $QUEST_TYPE_HERO_COUNT     = 9;  // 英雄收集数量（只计最高数）
    private static $QUEST_TYPE_VIP_LEVEL      = 10; // VIP等级
    private static $QUEST_TYPE_NORMAL_SECTION = 11; // 完成的最高普通章节
    private static $QUEST_TYPE_HERO_SECTION   = 12; // 完成的最高英雄章节
    private static $QUEST_TYPE_TIME_LIMIT     = 13; // 限时日常任务
    private static $QUEST_TYPE_SKILL_UP       = 15; // 技能升级
    private static $QUEST_TYPE_USER_LEVEL     = 16; // 战队等级任务
    private static $QUEST_TYPE_MONTH_CARD     = 17; // 月卡任务
    private static $QUEST_TYPE_CRUSADE        = 18; // 轮回蛇道日常任务
    private static $QUEST_TYPE_CHALLENGE      = 19; // 挑战日常任务
    private static $QUEST_TYPE_WANTED         = 20; // 悬赏日常任务
    private static $QUEST_TYPE_CONTEST        = 21; // 擂台赛任务

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('mission_lib', function() {
            return new MissionLib();
        }, true);
        $this->_di->set('arena_lib', function() {
            return new ArenaLib();
        }, true);
        $this->_di->set('rob_lib', function() {
            return new RobLib();
        }, true);
        $this->_di->set('temple_lib', function() {
            return new TempleLib();
        }, true);
        $this->_di->set('karin_lib', function() {
            return new KarinLib();
        }, true);
        $this->_di->set('card_lib', function() {
            return new CardLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new ItemLib();
        }, true);
        $this->_di->set('equip_lib', function() {
            return new EquipLib();
        }, true);
        $this->_di->set('midas_lib', function() {
            return new MidasLib();
        }, true);
        $this->_di->set('charge_lib', function() {
            return new ChargeLib();
        }, true);
        $this->_di->set('crusade_lib', function() {
            return new CrusadeLib();
        }, true);
        $this->_di->set('daily_quest_model', function () {
           return new DailyQuestModel();
        }, true);
        $this->_di->set('quest_model', function () {
           return new QuestModel();
        }, true);
        $this->quest_cfg = self::getGameConfig('quest');
    }

    public function status($user_id)
    {
        $daily = $this->dailyStatus($user_id);
        $normal = $this->normalStatus($user_id);
        $status = $daily + $normal;
        // 如果任务数量正确
        if (count($status) ==  count($daily) + count($normal)) {
            return $status;
        } else {
            throw new Exception("Quest count is invalid, may be you did not define them correctly.", ERROR_CODE_DATA_INVALID_QUEST);
        }
    }

    private function dailyStatus($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_QUEST_DAILY, $user_id);
        $status = $this->redis->hGetAll($cache_key);

        if (empty ($status)) {
            $cache = [];
            foreach (self::$DAILY_QUEST_LIST as $quest_id) {
                $status[$quest_id] = $this->isQuestCanBeCommitted($user_id, $quest_id);
                $cache[$quest_id] = json_encode($status[$quest_id]);
            }
            if (! empty ($status)) {
                $expire = self::getDefaultExpire();
                $this->redis->hMSet($cache_key, $cache);
                $this->redis->expireAt($cache_key, $expire);
            }
        } else {
            foreach ($status as $quest_id => & $item) {
                $item = $this->isQuestCanBeCommitted($user_id, $quest_id);
            }
        }
        return $status;

    }

    private function normalStatus($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_QUEST_NORMAL, $user_id);
        $status = $this->redis->hGetAll($cache_key);
        if (empty ($status)) {
            $cache = [];
            foreach (self::$BOOTSTRAP_QUEST_LIST as $quest_id) {
                $status[$quest_id] = $this->isQuestCanBeCommitted($user_id, $quest_id);
                $cache[$quest_id] = json_encode($status[$quest_id]);
            }
            if (! empty ($status)) {
                $this->redis->hMSet($cache_key, $cache);
            }
        } else {
            foreach ($status as $quest_id => & $item) {
                $item = $this->isQuestCanBeCommitted($user_id, $quest_id);;
            }
        }
        return $status;
    }

    public function commit($user_id, $quest_id)
    {
        $sts = $this->isQuestCanBeCommitted($user_id, $quest_id);
        if ($sts['status']) {
            $is_daily = self::isDailyQuest($quest_id);
            // 如果是日常任务
            if ($is_daily) {
                $cache_key = sprintf(self::$CACHE_KEY_QUEST_DAILY, $user_id);
                $quest_model = $this->_di->getShared('daily_quest_model');
            } else {
                $cache_key = sprintf(self::$CACHE_KEY_QUEST_NORMAL, $user_id);
                $quest_model = $this->_di->getShared('quest_model');
            }
            // 判断任务是否已经被完成过了
            $finished = $quest_model->isQuestFinished($user_id, $quest_id);
            if (! $finished) {
                if (isset ($this->quest_cfg[$quest_id])) {
                    $item_lib = $this->_di->getShared('item_lib');
                    // 发放奖励
                    $bonus = $this->quest_cfg[$quest_id]['bonus'];
                    $bonus_ret = [];
                    foreach ($bonus as $item) {
                        $ret = $item_lib->addItem($user_id, $item['item_id'], $item['sub_id'], $item['count']);
                        if (is_array($ret) && isset($ret['pk_id'])) {
                            $bonus_ret[] = $ret;
                        } else {
                            $bonus_ret[] = [
                                'item_id' => $item['item_id'],
                                'sub_id'  => $item['sub_id'],
                                'count'   => $item['count'],
                            ];
                        }
                    }
                    // 添加任务完成日志
                    $log_ret = $quest_model->addQuestLog($user_id, $quest_id);
                    if ($log_ret) {
                        $next_quest_id = -1; // -1的情况下，前端需要删除该条任务
                        if (! $is_daily) {
                            $next_quest_id = $this->quest_cfg[$quest_id]['next_id'];
                            if (isset ($this->quest_cfg[$next_quest_id])) {
                                $sts = $this->isQuestCanBeCommitted($user_id, $next_quest_id);
                                $this->redis->hSetNx($cache_key, $next_quest_id, json_encode($sts));
                            }
                        }
                        $this->redis->hDel($cache_key, $quest_id);
                        $user_lib = $this->getDI()->getShared('user_lib');
                        // 有些任务送战队经验，所以需要在这里添加
                        $user = $user_lib->getUser($user_id);
                        $result = [
                            'code'     => ERROR_CODE_OK,
                            'next_id'  => $next_quest_id,
                            'status'   => $sts['status'],
                            'progress' => $sts['progress'],
                            'msg'      => 'OK',
                            'user'     => [
                                'exp'   => $user[UserLib::$USER_PROF_FIELD_EXP],
                                'level' => $user[UserLib::$USER_PROF_FIELD_LEVEL],
                                'energy' => $user[UserLib::$USER_PROF_FIELD_ENERGY],
                            ],
                            'bonus'    => $bonus_ret,
                        ];
                        return $result;
                    } else {
                        throw new Exception("添加任务日志失败", ERROR_CODE_DB_ERROR_MYSQL);
                    }
                } else {
                    throw new Exception("Quest is not defined for id:$quest_id", ERROR_CODE_CONFIG_NOT_FOUND);
                }
            } else {
                return [
                    'code' => ERROR_CODE_FAIL,
                    'msg'  => "该任务已经完成",
                ];
            }
        }
        return [
            'code' => ERROR_CODE_FAIL,
            'msg'  => "尚未达到任务要求.",
        ];
    }

    private static function isDailyQuest($quest_id)
    {
        return in_array($quest_id, self::$DAILY_QUEST_LIST);
    }

    private function isQuestCanBeCommitted($user_id, $quest_id)
    {
        if (isset ($this->quest_cfg[$quest_id])) {
            $type  = $this->quest_cfg[$quest_id]['type'];
            $limit = $this->quest_cfg[$quest_id]['limit'];
            switch ($type) {
                case self::$QUEST_TYPE_PVE_NORMAL:
                    $mission_lib = new MissionLib(0);
                    $count = $mission_lib->getSectionPassCountTotal($user_id);
                    break;

                case self::$QUEST_TYPE_PVE_HERO:
                    $mission_lib = new MissionLib(1);
                    $count = $mission_lib->getSectionPassCountTotal($user_id);
                    break;

                case self::$QUEST_TYPE_MIDAS:
                    $midas_lib = $this->_di->getShared('midas_lib');
                    $count = $midas_lib->getUsedTimes($user_id);
                    break;

                case self::$QUEST_TYPE_ARENA:
                    $cache_key = sprintf("chlng_rec:%s", $user_id);
                    $count = intval($this->redis->get($cache_key));
                    break;

                case self::$QUEST_TYPE_ROB:
                    $rob_lib = $this->_di->getShared('rob_lib');
                    $count = $rob_lib->getTodayRobCount($user_id);
                    break;

                case self::$QUEST_TYPE_WORSHIP:
                    $temple_lib = $this->_di->getShared('temple_lib');
                    $count = $temple_lib->getTotalWorshipCount($user_id);
                    break;

                case self::$QUEST_TYPE_KARIN:
                    $karin_lib = $this->_di->getShared('karin_lib');
                    $count = $karin_lib->getTodayCount($user_id);
                    break;

                case self::$QUEST_TYPE_EQUIP_ENHANCE:
                    $equip_lib = $this->_di->getShared('equip_lib');
                    $count = $equip_lib->getEnhanceCount($user_id);
                    break;
                case self::$QUEST_TYPE_HERO_COUNT:
                    $card_lib = $this->_di->getShared('card_lib');
                    $count = $card_lib->cardHisCount($user_id);
                    break;
                case self::$QUEST_TYPE_VIP_LEVEL:
                    $user_lib = $this->_di->getShared('user_lib');
                    $user = $user_lib->getUser($user_id);
                    $charge = $user[UserLib::$USER_PROF_FIELD_CHARGE];
                    // 从充值配置来计算用户VIP等级
                    $vip_conf = $this->getGameConfig('user_vip');
                    $count = 0;
                    foreach ($vip_conf as $lvl_conf) {
                        if ($charge >= $lvl_conf['charge']) {
                            $count++;
                        }
                    }
                    $count = min($count, 15);
                    break;
                case self::$QUEST_TYPE_NORMAL_SECTION:
                    $mission_lib = new MissionLib(MissionLib::$MISSION_TYPE_NORMAL);
                    $count = $mission_lib->getMaxSection($user_id); // 普通副本
                    break;
                case self::$QUEST_TYPE_HERO_SECTION:
                    $mission_lib = new MissionLib(MissionLib::$MISSION_TYPE_ELITE);
                    $count = $mission_lib->getMaxSection($user_id, true); // 精英副本
                    break;
                case self::$QUEST_TYPE_SKILL_UP:
                    $card_lib = $this->_di->getShared('card_lib');
                    $count = $card_lib->getSkillUpCount($user_id);
                    break;
                case self::$QUEST_TYPE_USER_LEVEL:
                    $user_lib = $this->_di->getShared('user_lib');
                    $user = $user_lib->getUser($user_id);
                    $count = $user[UserLib::$USER_PROF_FIELD_LEVEL];
                    break;
                // 吃仙豆属于特殊任务，需要特殊处理
                case self::$QUEST_TYPE_TIME_LIMIT:
                    $start = strtotime($limit["1"]);
                    $end   = strtotime($limit["2"]);
                    $now   = time();
                    $status = $start <= $now && $now <= $end ? 1 : 0;
                    return [
                        'status' => $status,
                        'progress' => $status,
                    ];
                    break;
                // 月卡任务特殊处理
                case self::$QUEST_TYPE_MONTH_CARD:
                    $charge_lib = $this->_di->getShared('charge_lib');
                    $month_status = $charge_lib->getMonthCardTTL($user_id);
                    if (! $month_status) {
                        return [
                            'status' => 0,
                            'progress' => 0,
                        ];
                    } else {
                        return [
                            'status' => 1,
                            'progress' => 1,
                        ];
                    }
                case self::$QUEST_TYPE_CRUSADE:
                    $crusade_lib = $this->getDI()->getShared('crusade_lib');
                    $count = $crusade_lib->getTodayCount($user_id);
                    break;
                case self::$QUEST_TYPE_CHALLENGE:
                    $record = MissionLib::getTimeLimitedMissionRecord($user_id);
                    $count = intval($record[MissionLib::$MISSION_TYPE_FIREDRICE])
                        + intval($record[MissionLib::$MISSION_TYPE_GINYU])
                        + intval($record[MissionLib::$MISSION_TYPE_FLISA]);
                    break;
                case self::$QUEST_TYPE_WANTED:
                    $record = MissionLib::getTimeLimitedMissionRecord($user_id);
                    $count = intval($record[MissionLib::$MISSION_TYPE_RABBIT])
                        + intval($record[MissionLib::$MISSION_TYPE_REDRIBBON]);
                    break;
                case self::$QUEST_TYPE_CONTEST:
                    $ring_lib = new ContestLib();
                    $u_status = $ring_lib->userStatus($user_id, true);
                    $count = $u_status[ContestLib::$USTATUS_FIELD_CLG_TIMES];
                    break;
                default:
                    throw new Exception("Quest type not defined for $type", ERROR_CODE_DATA_INVALID_QUEST);

            }
            $status = $count >= $limit ? 1 : 0;
            return [
                'status' => $status,
                'progress' => min($count, $limit),
            ];
        } else {
            throw new Exception("quest is not defined for id:$quest_id", ERROR_CODE_CONFIG_NOT_FOUND);
        }
    }
}
