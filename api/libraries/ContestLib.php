<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14/11/20
 * Time: 下午8:47
 */
namespace Cap\Libraries;

class ContestLib extends BaseLib
{
    public static $CACHE_KEY_RING_SET = 'nami:ring:set:%s';
    public static $CACHE_KEY_RING_JOIN = 'nami:ring:join:%s';
    public static $CACHE_KEY_RSTATUS = 'nami:ring:%s:%s';
    public static $CACHE_KEY_USTATUS = 'nami:contest:ustatus:%s';
    public static $CACHE_KEY_U_CLG_LOG = 'nami:contest:ulog:%s'; // 挑战日志log
    public static $CACHE_KEY_U_NO_GET_HONOR = 'nami:contest:ungh:%s'; // 未领取荣誉
    public static $CACHE_KEY_U_ENCR_LVL = 'nami:contest:encr:%s';
    public static $CACHE_KEY_RANK = 'nami:contest:rank:%s';
    public static $CACHE_KEY_RANK_DETAIL = 'nami:contest:rank:detail:%s';
    public static $CACHE_KEY_MIRROR = 'owner_mirror:%s';
    public static $CACHE_KEY_RING_LOCK = 'nami:ring:lock:%s:%s';

    public static $USTATUS_FILED_HONOR_TODAY = 'honor_today'; // 今日获得荣誉
    public static $USTATUS_FIELD_CLG_TIMES = 'clg_times'; // 今日已挑战次数
    public static $USTATUS_FIELD_GROUP = 'group'; // 所在挑战组
    public static $USTATUS_FIELD_ID_IN_GROUP = 'id_in_group'; // 组内ID

    public static $USTATUS_FIELD_BATTLE_LOG = 'battle_log'; // 战斗日志, set

    public static $USTATUS_FIELD_NOT_GET_HONOR = 'no_get_honor'; // 未领取荣誉

    public static $USTATUS_FIELD_ENCR_LEVEL = 'encr_level';
    public static $USTATUS_FIELD_DECK = 'deck';

    public static $RSTATUS_FIELD_OWNER_DECK = 'deck'; // 擂主卡组
    public static $RSTATUS_FIELD_OWNER_UID  = 'uid'; // 擂主UID
    public static $RSTATUS_FIELD_OWNER_NAME = 'name'; // 擂主名称
    public static $RSTATUS_FIELD_OWNER_LEVEL = 'level'; // 擂主等级
    public static $RSTATUS_FIELD_DEF_TIMES = 'def_times'; // 防守成功次数
    public static $RSTATUS_FILED_ON_TIME = 'on_ring_time'; // 上擂台时间戳

    private static $CLG_TIME_LIMIT = 10; //  每日挑战次数上限
    private static $CLG_GENKI = 1; // 每次挑战消耗元力
    private static $CLG_SUC_HONOR = 3; // 挑战成功获得的荣誉
    private static $DEF_SUC_HONOR = 1; // 防守成功获得的荣誉
    private static $CLG_FAIL_HONOR = 1; // 挑战失败获得的荣誉
    private static $RING_EXPIRE = 3600; // 擂台过期时间
    private static $RING_EXPIRE_HONOR = 37; // 守擂1小时后可领取荣誉
    private static $DOWN_DEF_TIMES = 20; //　防守多少次之后下擂台
    private static $ENCR_COST_GOLD = 10;
    private static $ENCR_COST_COIN = 10000;
    private static $ENCR_TYPE_COIN = 1;
    private static $ENCR_TYPE_GOLD = 2;
    private static $ENCR_LVL_DELTA = 0.02;
    private static $ENCR_SUC_RATE_DELTA = 0.1;
    private static $ENCR_MAX_LVL = 10;
    private static $RING_LOCK_EXPIRE = 300;

    public static $LOG_TYPE_DEF_SUC = 1; // 防守成功
    public static $LOG_TYPE_DEF_FAIL = 2; // 防守失败
    public static $LOG_TYPE_DEF_TIMEOUT = 3; // 防守超过1小时
    public static $LOG_TYPE_DEF_COUNTOUT = 4; // 防守满20次

	public static $FORBID_START = 2;
   	public static $FORBID_END = 8;

    // 连胜配置
    private static $DEF_HIGH_EXTRA = [
        5 => 1,
        10 => 3,
        15 => 5,
        20 => 8,
    ];

    public static $RING_CONF = [
        1 => ['start' => 3, 'delta' => 100, 's_level' => 25, 'e_level' => 34],
        2 => ['start' => 3, 'delta' => 100, 's_level' => 35, 'e_level' => 44],
        3 => ['start' => 2, 'delta' => 100, 's_level' => 45, 'e_level' => 59],
        4 => ['start' => 1, 'delta' => 100, 's_level' => 60, 'e_level' => 69],
        5 => ['start' => 1, 'delta' => 100, 's_level' => 70, 'e_level' => 79],
        6 => ['start' => 1, 'delta' => 100, 's_level' => 80, 'e_level' => 89],
        7 => ['start' => 1, 'delta' => 100, 's_level' => 90, 'e_level' => 100],
    ];

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
        $this->_di->set('card_lib', function() {
            return new CardLib();
        }, true);
    }

    // 获得用户状态,包括今日获得总荣誉，已挑战次数，组别，组内擂台号，对战记录，未领取荣誉
    public function userStatus($user_id, $only_basic = false)
    {
        $ret = [
            'code' => 200,
            'msg' => 'OK',
        ];
        // 获取基本信息
        $ustatus_key = sprintf(self::$CACHE_KEY_USTATUS, $user_id);
        $ustatus = $this->redis->hGetAll($ustatus_key);
        if (! $ustatus) {
            $ustatus = [
                self::$USTATUS_FILED_HONOR_TODAY => 0,
                self::$USTATUS_FIELD_CLG_TIMES => 0,
                self::$USTATUS_FIELD_GROUP => 0,
                self::$USTATUS_FIELD_ID_IN_GROUP => 0,
            ];
            $this->redis->hMSet($ustatus_key, $ustatus);
            $this->redis->expireAt($ustatus_key, self::getDefaultExpire());
        } else {
            // 看看用户所在擂台是不是过期了
            $grp = $ustatus[self::$USTATUS_FIELD_GROUP];
            $id_in_grp = $ustatus[self::$USTATUS_FIELD_ID_IN_GROUP];
            if ($grp && $id_in_grp) {
                $r_sts = $this->ringStatus($grp, $id_in_grp);
                if ($r_sts) {
                    $on_time = $r_sts[self::$RSTATUS_FILED_ON_TIME];
                    $time = time();
                    if ($on_time >0 && ($time - $on_time >= self::$RING_EXPIRE)) {
                        $this->initRing($grp, $id_in_grp);
                        $this->log($user_id, 0, '', self::$LOG_TYPE_DEF_TIMEOUT, 0, 0);
                        $this->updateUStatus($user_id, [
                            self::$USTATUS_FIELD_GROUP => 0,
                            self::$USTATUS_FIELD_ID_IN_GROUP => 0,
                        ]);
                        $ustatus[self::$USTATUS_FIELD_GROUP] = 0;
                        $ustatus[self::$USTATUS_FIELD_ID_IN_GROUP] = 0;
                        // 守擂满1小时，需要给37荣誉
                        $honor_key = sprintf(self::$CACHE_KEY_U_NO_GET_HONOR, $user_id);
                        $this->redis->set($honor_key, self::$RING_EXPIRE_HONOR);
                        $this->updateEncr($user_id, 0);
                    }
                }
            }
        }
        $mirror_key = sprintf(self::$CACHE_KEY_MIRROR, $user_id);
        $mirror = $this->redis->get($mirror_key);
        $ustatus[self::$USTATUS_FIELD_DECK] = $mirror ? json_decode($mirror, true) : [];
        if ($only_basic) {
            return $ustatus;
        }
        // 获得鼓舞状况
        $encr_lvl = $this->getEncr($user_id);
        $ustatus[self::$USTATUS_FIELD_ENCR_LEVEL] = array_fill(0, 4, $encr_lvl * self::$ENCR_LVL_DELTA);
        // 获取战斗日志
        $ustatus[self::$USTATUS_FIELD_BATTLE_LOG] = $this->getBattleLog($user_id);
        // 获取未领取荣誉
        $honor_key = sprintf(self::$CACHE_KEY_U_NO_GET_HONOR, $user_id);
        $no_get_honor = $this->redis->get($honor_key);
        $ustatus[self::$USTATUS_FIELD_NOT_GET_HONOR] = $no_get_honor ? intval($no_get_honor) : 0;
        $ret['status'] = $ustatus;
        return $ret;
    }

    private function getBattleLog($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_U_CLG_LOG, $user_id);
        $logs = $this->redis->zRange($cache_key, 0, -1);
        if (! $logs) {
            return [];
        }
        foreach ($logs as & $item) {
            $item = json_decode($item, true);
        }
        return array_values($logs);
    }

    // 擂台状态获取
    public function ringStatus($group_id, $id_in_group)
    {
        $key = sprintf(self::$CACHE_KEY_RSTATUS, $group_id, $id_in_group);
        $info = $this->redis->hGetAll($key);
        if (! $info) {
            $info = $this->initRing($group_id, $id_in_group);
        }
        return $info;
    }

    private function lockRing($grp, $id_in_grp, $uid)
    {
        $key = sprintf(self::$CACHE_KEY_RING_LOCK, $grp, $id_in_grp);
        $this->redis->setEx($key, self::$RING_LOCK_EXPIRE, $uid);
    }

    private function unlockRing($grp, $id_in_grp)
    {
        $key = sprintf(self::$CACHE_KEY_RING_LOCK, $grp, $id_in_grp);
        $this->redis->del($key);
    }

    private function getLock($grp, $id_in_grp)
    {
        $key = sprintf(self::$CACHE_KEY_RING_LOCK, $grp, $id_in_grp);
        $uid = $this->redis->get($key);
        return intval($uid);
    }

    public function getGroup($user_level)
    {
        $ret = 0;
        foreach (self::$RING_CONF as $group_id => $conf) {
            if ($conf['s_level'] <= $user_level && $user_level <= $conf['e_level']) {
                $ret = $group_id;
                break;
            }
        }
        return $ret;
    }

    // 寻找合适的擂台
    public function findRing($user_id)
    {
        $ret = [
            'code' => 200,
            'msg'  => 'OK',
            'occupied' => false,
            'opp_info' => [],
            'rob_energy' => 0,
            'group' => 0,
            'id_in_group' => 0,
            'honor' => 0,
        ];
        // kpi埋点
        (new KpiLib())->recordSysJoin($user_id, KpiLib::$EVENT_TYPE_CONTEST);
        $user_lib = $this->getDI()->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $ret['honor'] = $user[UserLib::$USER_PROF_FIELD_HONOR];
        $ret['rob_energy'] = $user[UserLib::$USER_PROF_FIELD_ROB_ENERGY];
        if (! self::canBegin()) {
            $ret['code'] = 503;
            $ret['msg'] = '现在是擂台休息时间.';
            return $ret;
        }
        $user_lvl = $user[UserLib::$USER_PROF_FIELD_LEVEL];
        $user_grp = $this->getGroup($user_lvl);
        if ($user_grp) {
            $u_sts = $this->userStatus($user_id, true);
            if ($u_sts[self::$USTATUS_FIELD_CLG_TIMES] < self::$CLG_TIME_LIMIT) {
                $ring_set_key = sprintf(self::$CACHE_KEY_RING_SET, $user_grp);
                $join_key = sprintf(self::$CACHE_KEY_RING_JOIN, $user_grp);
                $join_count = 0;
                $ring_set = $this->redis->get($ring_set_key);
                if (FALSE === $ring_set) {
                    // 该组竞技场还未初始化,根据配置初始化
                    $ergy_remain = $user_lib->consumeRobEnergy($user_id, self::$CLG_GENKI);
                    if (! $ergy_remain) {
                        $ret['code'] = 402;
                        $ret['msg'] = '元力不足，无法进行擂台赛>_<!';
                        return $ret;
                    } else {
                        $ret['rob_energy'] = $ergy_remain;
                    }
                    $ring_count = self::$RING_CONF[$user_grp]['start'];
                    if ($ring_count == 1) {
                        $ring_set = [];
                    } else if ($ring_count == 2) {
                        $ring_set = [2];
                    } else {
                        $ring_set = range(2, $ring_count);
                    }
                    foreach ($ring_set as $ring_id) {
                        $this->initRing($user_grp, $ring_id);
                    }
                    // 自动让用户占领一个擂台
                    $this->initRing($user_grp, 1, $user_id);
                    $remain = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_HONOR, self::$CLG_SUC_HONOR);
                    $ret['honor'] = $remain;
                    $this->updateUStatus($user_id, [
                        self::$USTATUS_FILED_HONOR_TODAY => self::$CLG_SUC_HONOR,
                        self::$USTATUS_FIELD_CLG_TIMES => 1,
                        self::$USTATUS_FIELD_GROUP => $user_grp,
                        self::$USTATUS_FIELD_ID_IN_GROUP => 1,
                    ]);
                    syslog(LOG_DEBUG, "$user_id Seized ring due to initialization.");
                    $ring_set[] = 1;
                    $ret['occupied'] = true;
                    $ret['group'] = $user_grp;
                    $ret['id_in_group'] = 1;
                } else {
                    $ring_set = json_decode($ring_set, true);
                    $ring_count = count($ring_set);
                    $join_count = $this->redis->sCard($join_key);
                    if ($ring_count * self::$RING_CONF[$user_grp]['delta'] <= $join_count) {
                        $ergy_remain = $user_lib->consumeRobEnergy($user_id, self::$CLG_GENKI);
                        if (! $ergy_remain) {
                            $ret['code'] = 402;
                            $ret['msg'] = '元力不足，无法进行擂台赛>_<!';
                            return $ret;
                        } else {
                            $ret['rob_energy'] = $ergy_remain;
                        }
                        // 需要新开竞技场，并且把当前用户设置为擂主
                        $new_id_in_grp = $ring_count + 1;
                        array_push($ring_set, $new_id_in_grp);
                        $this->initRing($user_grp, $new_id_in_grp, $user_id);
                        $remain = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_HONOR, self::$CLG_SUC_HONOR);
                        $ret['honor'] = $remain;
                        $this->updateUStatus($user_id, [
                            self::$USTATUS_FILED_HONOR_TODAY => self::$CLG_SUC_HONOR,
                            self::$USTATUS_FIELD_CLG_TIMES => 1,
                            self::$USTATUS_FIELD_GROUP => $user_grp,
                            self::$USTATUS_FIELD_ID_IN_GROUP => $new_id_in_grp,
                        ]);
                        $ret['occupied'] = true;
                        $ret['group'] = $user_grp;
                        $ret['id_in_group'] = $new_id_in_grp;
                        syslog(LOG_DEBUG, "$user_id seized ring due to new ring creation");
                    } else {
                        // 寻找一个合适的擂台
                        $find = 0;
                        foreach ($ring_set as $key => $ring_id) {
                            $r_sts = $this->ringStatus($user_grp, $ring_id);
                            // 如果发现可以挑战的擂台
                            if (! empty($r_sts)) {
                                $lock = $this->getLock($user_grp, $ring_id);
                                if (! $lock) {
                                    if (! $r_sts[self::$RSTATUS_FIELD_OWNER_UID]) {
                                        $ergy_remain = $user_lib->consumeRobEnergy($user_id, self::$CLG_GENKI);
                                        if (! $ergy_remain) {
                                            $ret['code'] = 402;
                                            $ret['msg'] = '元力不足，无法进行擂台赛>_<!';
                                            return $ret;
                                        } else {
                                            $ret['rob_energy'] = $ergy_remain;
                                        }
                                        // 如果擂台没有擂主,则玩家自动成为擂主
                                        $this->initRing($user_grp, $ring_id, $user_id);
                                        $ret['occupied'] = true;
                                        $this->updateUStatus($user_id, [
                                            self::$USTATUS_FILED_HONOR_TODAY => self::$CLG_SUC_HONOR,
                                            self::$USTATUS_FIELD_CLG_TIMES => 1,
                                            self::$USTATUS_FIELD_GROUP => $user_grp,
                                            self::$USTATUS_FIELD_ID_IN_GROUP => $ring_id,
                                        ]);
                                        $remain = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_HONOR, self::$CLG_SUC_HONOR);
                                        $ret['honor'] = $remain;
                                        $ret['occupied'] = true;
                                        $ret['group'] = $user_grp;
                                        $ret['id_in_group'] = $ring_id;
                                        syslog(LOG_DEBUG, "$user_id seized ring due to no owner ring.");
                                    } else {
                                        $on_time = $r_sts[self::$RSTATUS_FILED_ON_TIME];
                                        $curr_time = time();
                                        if ($curr_time - $on_time >= self::$RING_EXPIRE) {
                                            // 如果竞技场过期，自动下擂台,当前挑战人成为擂主
                                            $ergy_remain = $user_lib->consumeRobEnergy($user_id, self::$CLG_GENKI);
                                            if (! $ergy_remain) {
                                                $ret['code'] = 402;
                                                $ret['msg'] = '元力不足，无法进行擂台赛>_<!';
                                                return $ret;
                                            } else {
                                                $ret['rob_energy'] = $ergy_remain;
                                            }
                                            $r_uid = $r_sts[self::$RSTATUS_FIELD_OWNER_UID];
                                            $this->updateUStatus($r_uid, [
                                                self::$USTATUS_FIELD_GROUP => 0,
                                                self::$USTATUS_FIELD_ID_IN_GROUP => 0,
                                            ]);
                                            $this->initRing($user_grp, $ring_id, $user_id);
                                            $ret['occupied'] = true;
                                            $ret['group'] = $user_grp;
                                            $ret['id_in_group'] = $ring_id;
                                            $this->updateUStatus($user_id, [
                                                self::$USTATUS_FILED_HONOR_TODAY => self::$CLG_SUC_HONOR,
                                                self::$USTATUS_FIELD_CLG_TIMES => 1,
                                                self::$USTATUS_FIELD_GROUP => $user_grp,
                                                self::$USTATUS_FIELD_ID_IN_GROUP => $ring_id,
                                            ]);
                                            // 守擂满1小时，需要给37荣誉
                                            $honor_key = sprintf(self::$CACHE_KEY_U_NO_GET_HONOR, $r_uid);
                                            $this->redis->set($honor_key, self::$RING_EXPIRE_HONOR);
                                            $this->log($r_sts[self::$RSTATUS_FIELD_OWNER_UID], 0, '', self::$LOG_TYPE_DEF_TIMEOUT, 0, 0);
                                            $this->updateEncr($r_sts[self::$RSTATUS_FIELD_OWNER_UID], 0);
                                            syslog(LOG_DEBUG, "$user_id seized ring due to ring expiration.");
                                        } else {
                                            // 已有擂主，需要和擂主PK
                                            $ergy_remain = $user_lib->consumeRobEnergy($user_id, self::$CLG_GENKI);
                                            if (! $ergy_remain) {
                                                $ret['code'] = 402;
                                                $ret['msg'] = '元力不足，无法进行擂台赛>_<!';
                                                return $ret;
                                            } else {
                                                $ret['rob_energy'] = $ergy_remain;
                                            }
                                            $encr_lvl = $this->getEncr($r_sts[self::$RSTATUS_FIELD_OWNER_UID]);
                                            $ret['opp_info'] = [
                                                'uid'  => $r_sts[self::$RSTATUS_FIELD_OWNER_UID],
                                                'name' => $r_sts[self::$RSTATUS_FIELD_OWNER_NAME],
                                                'level' => $r_sts[self::$RSTATUS_FIELD_OWNER_LEVEL],
                                                'deck' => $r_sts[self::$RSTATUS_FIELD_OWNER_DECK],
                                                'encr_level' => array_fill(0, 4, $encr_lvl * self::$ENCR_LVL_DELTA),
                                                'def_times' => $r_sts[self::$RSTATUS_FIELD_DEF_TIMES],
                                            ];
                                            $ret['group'] = $user_grp;
                                            $ret['id_in_group'] = $ring_id;
                                            $this->updateUStatus($user_id, [
                                                self::$USTATUS_FIELD_CLG_TIMES => 1,
                                            ]);
                                            // 锁定擂台
                                            $this->lockRing($user_grp, $ring_id, $r_sts[self::$RSTATUS_FIELD_OWNER_UID]);
                                        }
                                    }
                                    $find = $ring_id;
                                    unset($ring_set[$key]);
                                    break;
                                }
                            }
                        }
                        if ($find) {
                            // 把刚刚产生过活动的擂台放到可选擂台的最后面
                            $ring_set[] = $find;
                        } else {
                            // 没有空擂台可以选择
                            $ret['code'] = 404;
                            $ret['msg'] = '没有空擂台了，请稍后重试>_<!';
                        }
                    }
                }
                $this->redis->multi();
                if (! $join_count) {
                    $this->redis->sAdd($join_key, $user_id);
                    $this->redis->expireAt($join_key, self::getDefaultExpire());
                } else {
                    $this->redis->sAdd($join_key, $user_id);
                }
                $this->redis->set($ring_set_key, json_encode(array_values($ring_set), JSON_NUMERIC_CHECK));
                $this->redis->expireAt($ring_set_key, self::getDefaultExpire());
                $this->redis->exec();
            } else {
                $ret['code'] = 503;
                $ret['msg'] = '剩余擂台赛挑战次数不足>_<!';
            }
        }
        return $ret;
    }

    private function updateUStatus($user_id, $update_info)
    {
        $key = sprintf(self::$CACHE_KEY_USTATUS, $user_id);
        $this->redis->multi();
        foreach ($update_info as $field => $delta) {
            switch ($field) {
                case self::$USTATUS_FILED_HONOR_TODAY:
                    $this->redis->hIncrBy($key, self::$USTATUS_FILED_HONOR_TODAY, $delta);
                    break;
                case self::$USTATUS_FIELD_CLG_TIMES:
                    $this->redis->hIncrBy($key, self::$USTATUS_FIELD_CLG_TIMES, $delta);
                    break;
                case self::$USTATUS_FIELD_GROUP:
                    $this->redis->hSet($key, self::$USTATUS_FIELD_GROUP, $delta);
                    break;
                case self::$USTATUS_FIELD_ID_IN_GROUP:
                    $this->redis->hSet($key, self::$USTATUS_FIELD_ID_IN_GROUP, $delta);
                    break;
            }
        }
        $ret = $this->redis->exec();
        syslog(LOG_DEBUG, "Update UStatus Result:" . json_encode($ret));
    }
    private function initRing($group, $id_in_grp, $user_id = null)
    {
        $cache_key = sprintf(self::$CACHE_KEY_RSTATUS, $group, $id_in_grp);
        $ring_info = [
            self::$RSTATUS_FIELD_OWNER_UID => 0,
            self::$RSTATUS_FIELD_OWNER_NAME => '',
            self::$RSTATUS_FIELD_OWNER_LEVEL => 0,
            self::$RSTATUS_FIELD_OWNER_DECK => '',
            self::$RSTATUS_FIELD_DEF_TIMES => 0,
            self::$RSTATUS_FILED_ON_TIME => 0,
        ];
        if (! empty ($user_id)) {
            $user_lib = $this->getDI()->getShared('user_lib');
            $card_lib = $this->getDI()->getShared('card_lib');
            $deck = $card_lib->getDeckCard($user_id, true);
            $user = $user_lib->getUser($user_id);
            $ring_info[self::$RSTATUS_FIELD_OWNER_UID] = $user_id;
            $ring_info[self::$RSTATUS_FIELD_OWNER_NAME] = $user[UserLib::$USER_PROF_FIELD_NAME];
            $ring_info[self::$RSTATUS_FIELD_OWNER_LEVEL] = $user[UserLib::$USER_PROF_FIELD_LEVEL];
            $ring_info[self::$RSTATUS_FIELD_OWNER_DECK] = json_encode($deck, JSON_NUMERIC_CHECK);
            $ring_info[self::$RSTATUS_FILED_ON_TIME] = time();
            $mirr_key = sprintf(self::$CACHE_KEY_MIRROR, $user_id);
            $this->redis->set($mirr_key, json_encode($deck, JSON_NUMERIC_CHECK));
        }
        $this->redis->hMSet($cache_key, $ring_info);
        $l_ctt = "Initialized Ring {$group}:{$id_in_grp}";
        $l_ctt .= isset($user_id) ? " For User $user_id" : '';
        syslog(LOG_DEBUG, "Contest: " . $l_ctt);
        return $ring_info;
    }

    public function commit($user_id, $opp_uid, $group, $id_in_group, $win)
    {
        $ret = ['code' => 200, 'msg' => 'OK'];
        $user_lib = $this->getDI()->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $ret['honor'] = $user[UserLib::$USER_PROF_FIELD_HONOR];
        $user_name = $user[UserLib::$USER_PROF_FIELD_NAME];
        $r_status = $this->ringStatus($group, $id_in_group);
        $lock = $this->getLock($group, $id_in_group);
        if (! $lock) {
            $ret['code'] = 200;
            $ret['msg'] = '无效的请求.';
            return $ret;
        }
        if ($lock != $opp_uid) {
            $ret['code'] = 200;
            $ret['msg'] = '无效的请求.';
            return $ret;
        }
        if ($win) {
            // 如果赢了,占领该擂台，发送奖励给当前用户，去掉原擂台用户的擂台数据
            $owner_uid = $r_status[self::$RSTATUS_FIELD_OWNER_UID];
            $this->updateUStatus($owner_uid, [
                self::$USTATUS_FIELD_GROUP => 0,
                self::$USTATUS_FIELD_ID_IN_GROUP => 0,
            ]);
            $this->initRing($group, $id_in_group, $user_id);
            $this->log($owner_uid, $user_id, $user_name, self::$LOG_TYPE_DEF_FAIL, 0, 0);
            // 发送荣誉给当前挑战者
            $give = self::$CLG_SUC_HONOR;
            if ($r_status[self::$RSTATUS_FIELD_DEF_TIMES] == 10) {
                $give += 1;
            } else if ($r_status[self::$RSTATUS_FIELD_DEF_TIMES] == 19) {
                $give += 5;
            }
            $this->updateUStatus($user_id, [
                self::$USTATUS_FIELD_GROUP => $group,
                self::$USTATUS_FIELD_ID_IN_GROUP => $id_in_group,
                self::$USTATUS_FILED_HONOR_TODAY => $give,
            ]);
            $remain = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_HONOR, $give);
            $ret['honor'] = $remain;
            $this->updateEncr($owner_uid, 0);
        } else {
            // 输了，给擂主发送奖励，记未领取记录
            $cache_key = sprintf(self::$CACHE_KEY_RSTATUS, $group, $id_in_group);
            $owner_uid = $r_status[self::$RSTATUS_FIELD_OWNER_UID];
            $now_def_times = $this->redis->hIncrBy($cache_key, self::$RSTATUS_FIELD_DEF_TIMES, 1);
            $extra_honor = 0;
            if (isset (self::$DEF_HIGH_EXTRA[$now_def_times])) {
                // 如果有连胜奖励
                $extra_honor = self::$DEF_HIGH_EXTRA[$now_def_times];
            }
            $owner_honor = self::$DEF_SUC_HONOR + $extra_honor;
            $honor_key = sprintf(self::$CACHE_KEY_U_NO_GET_HONOR, $owner_uid);
            $this->redis->incrBy($honor_key, $owner_honor);
            $this->log($owner_uid, $user_id, $user_name, self::$LOG_TYPE_DEF_SUC, self::$DEF_SUC_HONOR, $extra_honor);

            if (self::$DOWN_DEF_TIMES == $now_def_times) {
                $this->updateUStatus($owner_uid, [
                    self::$USTATUS_FIELD_GROUP => 0,
                    self::$USTATUS_FIELD_ID_IN_GROUP => 0,
                ]);
                $this->initRing($group, $id_in_group);
                $this->log($owner_uid, 0, $user_name, self::$LOG_TYPE_DEF_COUNTOUT, 0, 0);
            }
            // 挑战失败，获得一点荣誉
            $remain = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_HONOR, self::$CLG_FAIL_HONOR);
            $ret['honor'] = $remain;
            $this->updateUStatus($user_id, [
                self::$USTATUS_FILED_HONOR_TODAY => self::$CLG_FAIL_HONOR,
            ]);
            $this->updateEncr($user_id, 0);
        }
        // 无论结果如何，擂台都应被解锁
        $this->unlockRing($group, $id_in_group);
        return $ret;
    }

    // 鼓舞
    public function encr($user_id, $type)
    {
        $ret = [
            'code' => 200,
            'msg'  => 'OK',
            'success' => false,
            'remain' => 0,
            'encr_level' => [],
        ];
        $encr_lvl = $this->getEncr($user_id);
        if ($encr_lvl == self::$ENCR_MAX_LVL) {
            $ret['code'] = 403;
            $ret['msg'] = '已达到最大鼓舞等级';
        } else {
            $user_lib = $this->getDI()->getShared('user_lib');
            if (self::$ENCR_TYPE_GOLD == $type) {
                $remain = $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_GOLD, self::$ENCR_COST_GOLD);
                if (false !== $remain) {
                    $ret['remain'] = $remain;
                    $this->updateEncr($user_id, $encr_lvl + 1);
                    $ret['success'] = true;
                    $ret['encr_level'] = array_fill(0, 4, ($encr_lvl + 1) * self::$ENCR_LVL_DELTA);
                } else {
                    $ret['code'] = 404;
                    $ret['msg'] = '钻石余额不足';
                }
            } else if (self::$ENCR_TYPE_COIN == $type) {
                $remain = $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, self::$ENCR_COST_COIN);
                if (false !== $remain) {
                    $ret['remain'] = $remain;
                    $suc_rate = 1 - self::$ENCR_SUC_RATE_DELTA * $encr_lvl;
                    $roll = mt_rand(1, 100);
                    if ($roll <= intval($suc_rate * 100)) {
                        $this->updateEncr($user_id, $encr_lvl + 1);
                        $ret['success'] = true;
                        $ret['encr_level'] = array_fill(0, 4, ($encr_lvl + 1) * self::$ENCR_LVL_DELTA);
                    } else {
                        $ret['success'] = false;
                        $ret['remain'] = $remain;
                    }
                }else {
                    $ret['code'] = 405;
                    $ret['msg'] = '索尼币余额不足';
                }
            } else {
                $ret['code'] = 505;
                $ret['msg'] = '鼓舞类型错误';
            }
        }
        return $ret;
    }

    // 获得鼓舞状况
    public function getEncr($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_U_ENCR_LVL, $user_id);
        $lvl = $this->redis->get($cache_key);
        return $lvl ? $lvl : 0;
    }

    // 获得鼓舞状况
    public function updateEncr($user_id, $lvl)
    {
        $cache_key = sprintf(self::$CACHE_KEY_U_ENCR_LVL, $user_id);
        $this->redis->set($cache_key, $lvl);
    }

    // 记录日志, win表示$to_uid是否守擂成功
    public function log($to_uid, $from_uid, $name, $type, $honor, $extra_honor)
    {
        $time = time();
        $content = [
            'type' => $type,
            'uid'  => $from_uid,
            'name' => $name,
            'honor' => $honor,
            'extra_honor' => $extra_honor,
            'time' => time(),
            'deck' => [],
            'level' => 0,
        ];
        $card_lib = $this->getDI()->getShared('card_lib');
        if ($from_uid) {
            $user_lib = $this->getDI()->getShared('user_lib');
            $user = $user_lib->getUser($from_uid);
            $content['level'] = $user[UserLib::$USER_PROF_FIELD_LEVEL];
            $content['deck'] = $card_lib->getDeckCardsOverview($from_uid);
        }
        $log_key = sprintf(self::$CACHE_KEY_U_CLG_LOG, $to_uid);
        syslog(LOG_DEBUG, "Contest: Battle Log" . json_encode($content) . " Logged.");
        $this->redis->zAdd($log_key, $time, json_encode($content, JSON_NUMERIC_CHECK));
    }

    public function finishRing($user_id)
    {
        $ret = [
            'code' => 200,
            'msg'  => 'OK',
        ];
        $u_sts = $this->userStatus($user_id, true);
        $grp = $u_sts[self::$USTATUS_FIELD_GROUP];
        if ($grp) {
            $ret['code'] = 503;
            $ret['msg'] = '你还未下擂台，无法领奖.';
            return $ret;
        }
        $user_lib = $this->getDI()->getShared('user_lib');
        $user  = $user_lib->getUser($user_id);
        $cache_key = sprintf(self::$CACHE_KEY_U_NO_GET_HONOR, $user_id);
        $no_get = $this->redis->get($cache_key);
        if ($no_get) {
            $now_honor = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_HONOR, $no_get);
            $this->updateUStatus($user_id, [
                self::$USTATUS_FILED_HONOR_TODAY => $no_get,
            ]);
            $this->redis->set($cache_key, 0);
            $ret['score'] = $now_honor;
            $ret['new_get_score'] = $no_get;
        } else {
            $ret['score'] = $user[UserLib::$USER_PROF_FIELD_HONOR];
            $ret['new_get_score'] = 0;
        }
        // 清理战斗日志
        $log_key = sprintf(self::$CACHE_KEY_U_CLG_LOG, $user_id);
        $this->redis->del($log_key);
        // 清理镜像
        $mirror_key = sprintf(self::$CACHE_KEY_MIRROR, $user_id);
        $this->redis->del($mirror_key);
        $this->updateEncr($user_id, 0);
        return $ret;
    }

    public function rank($user_id)
    {
        $ret = [
            'code' => 200,
            'msg'  => 'OK',
            'rank' => -1,
            'board' => [],
        ];
        $user_lib = $this->getDI()->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $user_grp = $this->getGroup($user[UserLib::$USER_PROF_FIELD_LEVEL]);
        $rank_key = sprintf(self::$CACHE_KEY_RANK, $user_grp);
        $rank = $this->redis->zRevRank($rank_key, $user_id);
		syslog(LOG_DEBUG, "Contest:User $user_id in group $user_grp is $rank");
        $ret['rank'] = is_int($rank) ? intval($rank) + 1 : -1;
        $board = [];
        $count = count(self::$RING_CONF);
        for ($i = 1; $i <= $count; $i++) {
            $key = sprintf(self::$CACHE_KEY_RANK_DETAIL, $i);
            $content = $this->redis->get($key);
            $content = json_decode($content, true);
            $board[$i] = empty($content) ? [] : $content;
        }
		$ret['board'] = array_values($board);
        return $ret;
    }

    private static function canBegin()
    {
        $h = intval(date('H'));
        $ret =  ! ($h >= self::$FORBID_START && $h < self::$FORBID_END);
		syslog(LOG_DEBUG, "Contest: Now is $h, result is $ret");
		return $ret;
    }
}
