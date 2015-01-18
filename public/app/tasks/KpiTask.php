<?php

class KpiTask extends \Phalcon\CLI\Task
{
    private static $TYPE_USER_LEVEL_MAP = 1; // 用户等级分布统计
    private static $TYPE_USER_NEWBIE_MAP = 2; // 用户新手引导步骤统计
    private static $TYPE_USER_NEW = 3; // 新增用户统计
    private static $TYPE_USER_STAY = 4; // 用户留存统计
    private static $TYPE_DAU = 5; // 日均活跃用户
    private static $TYPE_ITEM = 6; // 道具使用情况
    private static $TYPE_MISSION = 7; // 任务系统最高章节分布状况
    private static $TYPE_SYS_JOIN = 8; // 系统参与率
    private static $TYPE_PAY = 9; // 付费率
    private static $TYPE_NEW_RET_RATE = 10; // 留存率计算（正统算法）

    // KPI用户分布统计方法，每日运行一次，按日期分开存储
    // KPI Type为1
    public function levelAction($params = null)
    {
        $level_map = [
            'total' => [],
            'today'   => [],
        ];
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $realtime = isset($params[0]);
        $date =  $realtime ? date('Ymd') : date('Ymd', time() - 86400);
        $date_ts = strtotime($date);
        foreach ($all_info as $user_info) {
            $user_level = $user_info['level'];
            if (isset ($level_map['total'][$user_level])) {
                $level_map['total'][$user_level]++;
            } else {
                $level_map['total'][$user_level] = 1;
            }
            $created_at = strtotime($user_info['created_at']);
            if ($date_ts <= $created_at && $created_at <= $date_ts + 86400) {
                if (isset ($level_map['today'][$user_level])) {
                    $level_map['today'][$user_level]++;
                } else {
                    $level_map['today'][$user_level] = 1;
                }
            }
        }
        if (! empty ($level_map)) {
            ksort($level_map['total']);
            ksort($level_map['today']);
            $kpi_model = new \Cap\Models\Db\KpiModel();
            $kpi_model->createData($date, self::$TYPE_USER_LEVEL_MAP, $level_map);
            echo "User level map stastic completed, data: " . json_encode($level_map, JSON_NUMERIC_CHECK | JSON_UNESCAPED_SLASHES) . "\n";
        } else {
            echo "User level map stastic completed, no data to do. \n";
        }
    }

    // KPI新手引导情况统计
    public function newbieAction($params = null)
    {
        $newbie_map = [];
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $realtime = isset($params[0]);
        $date = $realtime ? date('Ymd') : date('Ymd', time() - 86400);
        $date_ts = strtotime($date);
        foreach ($all_info as $user_info) {
            $created_at = strtotime($user_info['created_at']);
            // 只统计当天注册的人
            if ($created_at < $date_ts || $created_at >= $date_ts + 86400) {
                continue;
            }
            $user_newbie = $user_info['newbie'];
            if (isset ($newbie_map[$user_newbie])) {
                $newbie_map[$user_newbie]++;
            } else {
                $newbie_map[$user_newbie] = 1;
            }
        }
        if (! empty ($newbie_map)) {
            ksort($newbie_map);
            $kpi_model = new \Cap\Models\Db\KpiModel();
            $kpi_model->createData($date, self::$TYPE_USER_NEWBIE_MAP, $newbie_map);
            echo "User newbie map stastic completed, data: " . json_encode($newbie_map, JSON_NUMERIC_CHECK | JSON_UNESCAPED_SLASHES) . "\n";
        } else {
            echo "User newbie map stastic completed, no data to do. \n";

        }
    }

    public function newUserAction($params = null)
    {
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        // 每次运行计算的是前一天的新增用户数
        $new_count = 0;
        $realtime = isset($params[0]);
        $start_time = $realtime ? strtotime("00:00") : strtotime("00:00", time() - 86400);
        $end_time = $start_time + 86400;
        foreach ($all_info as $user_info) {
            $create_time = strtotime($user_info['created_at']);
            if ($start_time <= $create_time && $create_time < $end_time) {
                $new_count++;
            }
        }
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData(date('Ymd', $start_time), self::$TYPE_USER_NEW, $new_count);
    }

    public function stayUserAction()
    {
        $result = [
            'd1'  => [
                'active' => 0,
                'total'  => 0,
            ],
            'd3'  => [
                'active' => 0,
                'total'  => 0,
            ],
            'd7'  => [
                'active' => 0,
                'total'  => 0,
            ],
            'd15'  => [
                'active' => 0,
                'total'  => 0,
            ],
            'd30'  => [
                'active' => 0,
                'total'  => 0,
            ],
        ];

        $user_model = new \Cap\Models\Db\UserModel();
        $user_lib = new \Cap\Libraries\UserLib();
        $all_info = $user_model->getAllUsers();
        $start_time_1  = strtotime("00:00", time() - 2 * 86400);  // 次日留存最早注册时间
        $start_time_3  = strtotime("00:00", time() - 4 * 86400);  // 3日留存最早注册时间
        $start_time_7  = strtotime("00:00", time() - 8 * 86400);  // 7日留存最早注册时间
        $start_time_15 = strtotime("00:00", time() - 16 * 86400); // 15日留存最早注册时间
        $start_time_30 = strtotime("00:00", time() - 31 * 86400); // 30日留存最早注册时间

        $active_time = $start_time_1 + 86400;
        foreach ($all_info as $user_info) {
            $create_time = strtotime($user_info['created_at']);
            $user_redis = $user_lib->getUser($user_info['id']);
            if ($create_time >= $start_time_1) {
                $result['d1']['total']++;
                $result['d3']['total']++;
                $result['d7']['total']++;
                $result['d15']['total']++;
                $result['d30']['total']++;
                if ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] >= $active_time
                && ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] < $active_time + 86400)) {
                    $result['d1']['active']++;
                    $result['d3']['active']++;
                    $result['d7']['active']++;
                    $result['d15']['active']++;
                    $result['d30']['active']++;
                }
            } else if ($create_time >= $start_time_3) {
                $result['d3']['total']++;
                $result['d7']['total']++;
                $result['d15']['total']++;
                $result['d30']['total']++;
                if ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] >= $active_time
                && ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] < $active_time + 86400)) {
                    $result['d3']['active']++;
                    $result['d7']['active']++;
                    $result['d15']['active']++;
                    $result['d30']['active']++;
                }
            } else if ($create_time >= $start_time_7) {
                $result['d7']['total']++;
                $result['d15']['total']++;
                $result['d30']['total']++;
                if ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] >= $active_time
                && ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] < $active_time + 86400)) {
                    $result['d7']['active']++;
                    $result['d15']['active']++;
                    $result['d30']['active']++;
                }
            } else if ($create_time >= $start_time_15) {
                $result['d15']['total']++;
                $result['d30']['total']++;
                if ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] >= $active_time
                && ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] < $active_time + 86400)) {
                    $result['d15']['active']++;
                    $result['d30']['active']++;
                }
            } else if ($create_time >= $start_time_30) {
                $result['d30']['total']++;
                if ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] >= $active_time
                && ($user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] < $active_time + 86400)) {
                    $result['d30']['active']++;
                }
            }
        }
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData(date('Ymd', $active_time), self::$TYPE_USER_STAY, json_encode($result, JSON_UNESCAPED_SLASHES));
    }

    public function retRateAction($params = null)
    {
        $result = [
            'd1'  => [
                'active' => 0,
                'regist'  => 0,
            ],
            'd3'  => [
                'active' => 0,
                'regist'  => 0,
            ],
            'd7'  => [
                'active' => 0,
                'regist'  => 0,
            ],
            'd15'  => [
                'active' => 0,
                'regist'  => 0,
            ],
            'd30'  => [
                'active' => 0,
                'regist'  => 0,
            ],
        ];
        $user_model = new \Cap\Models\Db\UserModel();
        $user_lib = new \Cap\Libraries\UserLib();
        $all_info = $user_model->getAllUsers();
        $real = isset ($params);
        if (! $real) {
            $regist_1  = strtotime("00:00", time() - 2 * 86400);
            $regist_3  = strtotime("00:00", time() - 4 * 86400);
            $regist_7  = strtotime("00:00", time() - 8 * 86400);
            $regist_15 = strtotime("00:00", time() - 16 * 86400);
            $regist_30 = strtotime("00:00", time() - 31 * 86400);
        } else {
            $regist_1  = strtotime("00:00", time() - 1 * 86400);
            $regist_3  = strtotime("00:00", time() - 3 * 86400);
            $regist_7  = strtotime("00:00", time() - 7 * 86400);
            $regist_15 = strtotime("00:00", time() - 15 * 86400);
            $regist_30 = strtotime("00:00", time() - 30 * 86400);
        }
        $active_time = $regist_1 + 86400;

        $uids_1 = [];$uids_3 = [];$uids_7 = [];$uids_15 = [];$uids_30 = [];
        foreach ($all_info as $info) {
            $created_at = strtotime($info['created_at']);
            $uid = intval($info['id']);
            if ($regist_1 <= $created_at && $created_at < $regist_1 + 86400) {
                $uids_1[]  = $uid;
            } else if ($regist_3 <= $created_at && $created_at < $regist_3 + 86400) {
                $uids_3[] = $uid;
            } else if ($regist_7 <= $created_at && $created_at < $regist_7 + 86400) {
                $uids_7[]  = $uid;
            } else if ($regist_15 <= $created_at && $created_at < $regist_15 + 86400) {
                $uids_15[] = $uid;
            } else if ($regist_30 <= $created_at && $created_at < $regist_30 + 86400) {
                $uids_30[] = $uid;
            }
        }
        if (is_array($uids_1)) {
            $result['d1']['regist'] = count($uids_1);
            foreach ($uids_1 as $uid) {
                $user_redis = $user_lib->getUser($uid);
                $login_time = $user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN];
                if ($active_time <= $login_time && $login_time < $active_time + 86400) {
                    $result['d1']['active']++;
                }
            }
        }
        if (is_array($uids_3)) {
            $result['d3']['regist'] = count($uids_3);
            foreach ($uids_3 as $uid) {
                $user_redis = $user_lib->getUser($uid);
                $login_time = $user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN];
                if ($active_time <= $login_time && $login_time < $active_time + 86400) {
                    $result['d3']['active']++;
                }
            }
        }
        if (is_array($uids_7)) {
            $result['d7']['regist'] = count($uids_7);
            foreach ($uids_7 as $uid) {
                $user_redis = $user_lib->getUser($uid);
                $login_time = $user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN];
                if ($active_time <= $login_time && $login_time < $active_time + 86400) {
                    $result['d7']['active']++;
                }
            }
        }
        if (is_array($uids_15)) {
            $result['d15']['regist'] = count($uids_15);
            foreach ($uids_15 as $uid) {
                $user_redis = $user_lib->getUser($uid);
                $login_time = $user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN];
                if ($active_time <= $login_time && $login_time < $active_time + 86400) {
                    $result['d15']['active']++;
                }
            }
        }
        if (is_array($uids_30)) {
            $result['d30']['regist'] = count($uids_30);
            foreach ($uids_30 as $uid) {
                $user_redis = $user_lib->getUser($uid);
                $login_time = $user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN];
                if ($active_time <= $login_time && $login_time < $active_time + 86400) {
                    $result['d30']['active']++;
                }
            }
        }
        var_dump($result);
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData(date('Ymd', $active_time), self::$TYPE_NEW_RET_RATE, json_encode($result, JSON_UNESCAPED_SLASHES));
    }

    public function activeUserAction()
    {
        $result = [
            'new' => 0,
            'old' => 0,
        ];
        $user_model = new \Cap\Models\Db\UserModel();
        $user_lib = new \Cap\Libraries\UserLib();
        $all_info = $user_model->getAllUsers();
        $new_regist_time = strtotime('00:00', time() - 86400);
        foreach ($all_info as $user_info) {
            $user_redis = $user_lib->getUser($user_info['id']);
            $last_login = $user_redis[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN];
            if ($last_login >= $new_regist_time) {
                if (strtotime($user_info['created_at']) < $new_regist_time) {
                    $result['old']++;
                } else if ($new_regist_time <= strtotime($user_info['created_at'])
                    && strtotime($user_info['created_at']) < $new_regist_time + 86400) {
                    $result['new']++;
                }
            }
        }
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData(date('Ymd', $new_regist_time), self::$TYPE_DAU, json_encode($result, JSON_UNESCAPED_SLASHES));
    }

    public function itemAction()
    {
        $result = [
            'produce' => [],
            'consume' => [],
        ];
        $start_date = date('Y-m-d H:i:s', time() - 86400);
        $end_date   = date('Y-m-d H:i:s');

        $normal_cfg = \Cap\Libraries\BaseLib::getGameConfig('store_goods');
        $normal_model = new \Cap\Models\db\UserPurchaseRecordModel();
        $normal_records = $normal_model->getRecord($start_date, $end_date);

        // 统计普通商店道具的出售状况
        foreach ($normal_records as $record) {
            $store_id = $record['store_id'];
            $commodity_id = $record['commodity_id'];
            $count = $record['count'];

            $goods = $normal_cfg[$store_id][$commodity_id]['items'];
            foreach ($goods as $item) {
                if (isset ($result['produce'] [$item['item_id']] [$item['sub_id']])) {
                    $result['produce'][$item['item_id']][$item['sub_id']] += $item['count'] * $count;
                } else {
                    $result['produce'][$item['item_id']][$item['sub_id']] = $item['count'] * $count;
                }
            }
        }
        $refresh_cfg = \Cap\Libraries\BaseLib::getGameConfig('rstore');
        $refresh_model = new \Cap\Models\db\UserRefreshPurchaseRecordModel();
        $refresh_records = $refresh_model->getRecord($start_date, $end_date);
        // 统计可刷新商店道具的出售状况
        foreach ($refresh_records as $record) {
            $store_id = $record['store_id'];
            $commodity_id = $record['commodity_id'];
            $count = $record['count'];

            $goods = $refresh_cfg[$store_id]['commodities'][$commodity_id]['items'];
            foreach ($goods as $item) {
                $item['sub_id'] = empty($item['sub_id']) ? 1 : $item['sub_id'];
                if (isset ($result ['produce'] [$item['item_id']] [$item['sub_id']] )) {
                    $result['produce'] [$item['item_id']] [$item['sub_id']] += $item['count'] * $count;
                } else {
                    $result['produce'] [$item['item_id']] [$item['sub_id']] =  $item['count'] * $count;
                }
            }
        }
        // 统计道具的使用状况
        $consume_key = \Cap\Libraries\ItemLib::$CACHE_KEY_MONTH_CONSUME;
        $consume_info = $this->getDI()->getShared('redis')->hGetAll($consume_key);

        foreach ($consume_info as $key => $count) {
            list ($item_id, $sub_id) = explode(":", $key);
            $result['consume'][$item_id][$sub_id] = $count;
        }
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData(date('Ymd', time() - 86400), self::$TYPE_ITEM, json_encode($result, JSON_UNESCAPED_SLASHES));
    }

    public function missionAction($params = null)
    {
        $result = [
            'today' => [
                'normal' => [],
                'elite'  => [],
            ],
            'total' => [
                'normal' => [],
                'elite'  => [],
            ],
        ];
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $rds = $this->getDI()->getShared('redis');
        $realtime = isset($params[0]);
        $date = $realtime ? date('Ymd') : date('Ymd', time() - 86400);
        $date_ts = strtotime($date);
        foreach ($all_info as $user_info) {
            $user_id = $user_info['id'];
            $created_at = strtotime($user_info['created_at']);
            // 普通副本最大章节计算
            $normal_key = sprintf(\Cap\Libraries\MissionLib::$PASSED_SECTIONS_KEY, $user_id);
            $elite_key = sprintf(\Cap\Libraries\MissionLib::$ELITE_PASSED_SECTIONS_KEY, $user_id);
            $normal_info = $rds->hGetAll($normal_key);
            $elite_info = $rds->hGetAll($elite_key);

            if ($normal_info) {
                $sections = array_keys($normal_info);
                $normal_max_sec = max($sections);
                if (isset ($result['total']['normal'][$normal_max_sec])) {
                    $result['total']['normal'][$normal_max_sec]++;
                } else {
                    $result['total']['normal'][$normal_max_sec] = 1;
                }
                if ($date_ts <= $created_at && $created_at < $date_ts + 86400) {
                    if (isset ($result['today']['normal'][$normal_max_sec])) {
                        $result['today']['normal'][$normal_max_sec]++;
                    } else {
                        $result['today']['normal'][$normal_max_sec] = 1;
                    }
                }
            }
            ksort($result['total']['normal']);
            ksort($result['today']['normal']);
            if ($elite_info) {
                $sections = array_keys($elite_info);
                $elite_max_sec = max($sections);
                if (isset ($result['total']['elite'][$elite_max_sec])) {
                    $result['total']['elite'][$elite_max_sec]++;
                } else {
                    $result['total']['elite'][$elite_max_sec] = 1;
                }
                if ($date_ts <= $created_at && $created_at < $date_ts + 86400) {
                    if (isset ($result['today']['elite'][$elite_max_sec])) {
                        $result['today']['elite'][$elite_max_sec]++;
                    } else {
                        $result['today']['elite'][$elite_max_sec] = 1;
                    }
                }
            }
            ksort($result['total']['elite']);
            ksort($result['today']['elite']);
        }
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData($date, self::$TYPE_MISSION, json_encode($result, JSON_UNESCAPED_SLASHES));
    }

    public function payAction()
    {
        $result = [
            'new_pay' => 0, // 昨日新增付费人数 checked
            'new_regist' => 0, // 昨日新增注册人数 checked
            'first_level_map' => [], // 首次充值等级分布 checked
            'first_time_map' => [], // 首次充值间隔时间分布 checked
            'total_pay' => 0, // 总共充值人数 checked
            'total_regist' => 0, // 总共注册人数 checked
        ];
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $result['total_regist'] = is_array($all_info) ? count($all_info) : 0;

        $rds = $this->getDI()->getShared('redis');
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $date = date('Ymd', time() - 86400);

        $new_user = $kpi_model->getData($date, self::$TYPE_USER_NEW);
        $result['new_regist'] = intval($new_user);
        $pay_time_map = $rds->hGetAll(\Cap\Libraries\ChargeLib::$CACHE_KEY_FIRST_TIME);
        $result['total_pay'] = is_array($pay_time_map) ? count($pay_time_map) : 0;

        if (is_array($pay_time_map)) {
            foreach ($all_info as $info) {
                $create_time = strtotime($info['created_at']);
                $uid = $info['id'];
                if (isset ($pay_time_map[$uid])) {
                    $pay_time = $pay_time_map[$uid];
                    if ($pay_time - strtotime($date) < 86400) {
                        $result['new_pay']++;
                    }
                    $period = intval(($pay_time - $create_time) / 86400) + 1;
                    if (isset ($result['first_time_map'][$period])) {
                        $result['first_time_map'][$period]++;
                    } else {
                        $result['first_time_map'][$period] = 1;
                    }
                }
            }
        }
        $pay_level_map = $rds->hGetAll(\Cap\Libraries\ChargeLib::$CACHE_KEY_FIRST_LEVEL);
        $result['first_level_map'] = $pay_level_map;

        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData($date, self::$TYPE_PAY, json_encode($result, JSON_UNESCAPED_SLASHES));
    }

    public function realtimeStayAction()
    {
        $rds = $this->getDI()->getShared('redis');
        $key1 = "nami:event:betalogin:1";
        $key2 = "nami:event:betalogin:2";
        $users_1 = $rds->sMembers($key1);
        $users_2 = $rds->sMembers($key2);
        $user_lib = new \Cap\Libraries\UserLib();
        foreach ($users_1 as $key =>  $val) {
            $user = $user_lib->getUser($val);
            if ($user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LEVEL] < 5) {
                unset($users_1[$key]);
            }
        }
        $inter = array_intersect($users_1, $users_2);
        echo "昨天5级以上登录用户为:" . count($users_1) . "人\n";
        echo "这些用户中，今天又登录的用户为" . count($inter) . "人\n";
    }

	public function cloginAction()
    {
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $time = strtotime("00:00", time() - 86400);
        $user_lib = new \Cap\Libraries\UserLib();
      
        $users = [];
        foreach ($all_info as $info) {
            $c_time = strtotime($info['created_at']);
            if ($c_time >= $time && $c_time < $time + 86400) {
                $user = $user_lib->getUser($info['id']);
                if ($user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LAST_LOGIN] >= $time + 86400) {
                    $users[] = $info['id'];
                }
            }
        }
        var_dump($users);
    }

    public function joinRateAction($params = null)
    {
        $result = [
            'e1'  => ['join' => 0, 'total' => 0],
            'e2'  => ['join' => 0, 'total' => 0],
            'e3'  => ['join' => 0, 'total' => 0],
            'e4'  => ['join' => 0, 'total' => 0],
            'e5'  => ['join' => 0, 'total' => 0],
            'e6'  => ['join' => 0, 'total' => 0],
            'e7'  => ['join' => 0, 'total' => 0],
            'e8'  => ['join' => 0, 'total' => 0],
            'e9'  => ['join' => 0, 'total' => 0],
            'e10' => ['join' => 0, 'total' => 0],
        ];
		$ts = isset($params) ? time() : time() - 86400;
        $user_lib = new \Cap\Libraries\UserLib();
        $config = $this->getDI()->getShared('config');
        $srv_id = $config->server_id;
        // 活动参与记录
		$join_model = new \Cap\Models\Db\KpiJoinModel();
        $join_log = $join_model->getRec($ts);
        // 获取登录用户ID列表
        $login_model = new \Cap\Models\db\UserLoginModel();
        $login_log = $login_model->getByServer($srv_id, $ts);
        $user_ids = array_column($login_log, 'user_id');
        $user_ids = array_unique($user_ids);
        foreach ($user_ids as $uid) {
            $user_info = $user_lib->getUser($uid);
            $user_level = $user_info[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LEVEL];
            echo "Start handling user $uid, his level is $user_level.\n";
            if ($user_level >= 36) { // 公会
                $result['e1']['total']++;$result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;$result['e5']['total']++;$result['e6']['total']++;
                $result['e7']['total']++;$result['e8']['total']++;$result['e9']['total']++;
                $result['e10']['total']++;
            } else if ($user_level >= 32) { // 蛇道
                $result['e1']['total']++;$result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;$result['e5']['total']++;$result['e6']['total']++;
                $result['e7']['total']++;$result['e8']['total']++;$result['e9']['total']++;
            } else if ($user_level >= 28) { // 神塔
                $result['e1']['total']++;$result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;$result['e5']['total']++;$result['e6']['total']++;
                $result['e7']['total']++;$result['e8']['total']++;
            } else if ($user_level >= 25) { // 科技
                $result['e1']['total']++;$result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;$result['e5']['total']++;$result['e6']['total']++;
                $result['e7']['total']++;
            } else if ($user_level >= 22) { // 神殿
                $result['e1']['total']++;$result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;$result['e5']['total']++;
                $result['e7']['total']++;
            } else if ($user_level >= 20) { // 挑战
                $result['e1']['total']++;$result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;$result['e5']['total']++;
            } else if ($user_level >= 18) { // 夺龙珠
                $result['e1']['total']++;$result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;
            } else if ($user_level >= 15) { // 悬赏
                $result['e2']['total']++;$result['e3']['total']++;
                $result['e4']['total']++;
            } else if ($user_level >= 12) { // 英雄副本
                $result['e3']['total']++;
                $result['e4']['total']++;
            } else if ($user_level >= 10) { // 排位赛
                $result['e4']['total']++;
            }
            $this->joinWhat($uid, $join_log, $result);
        }
        $kpi_model = new \Cap\Models\Db\KpiModel();
        $kpi_model->createData(date('Ymd', $ts), self::$TYPE_SYS_JOIN, json_encode($result, JSON_UNESCAPED_SLASHES));
    }

    private function joinWhat($user_id, $join_log, & $result) {
        $join_ret = [];
        foreach ($join_log as $val) {
            $join_id = $val['user_id'];
            if ($join_id == $user_id) {
                $join_ret[] = $val['type'];
            }
        }
        $join_ret = array_unique($join_ret);
        echo "User $user_id joined system " . json_encode(array_values($join_ret), JSON_NUMERIC_CHECK) . ".\n";
        foreach ($join_ret as $type) {
            $var_name = "e{$type}";
            $result[$var_name]['join']++;
        }
    }
}
