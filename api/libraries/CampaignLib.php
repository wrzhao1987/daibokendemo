<?php

namespace Cap\Libraries;

class CampaignLib extends BaseLib {

    public $server_id = null;
    public static $EVENT_ID_NEW_SERVER_LOGIN = 1; // 新服累计登录奖励
    public static $EVENT_ID_NEW_SERVER_LVLUP = 2; // 新服冲级奖励
    public static $EVENT_ID_FIRST_CHARGE = 3; // 首充返利
    public static $EVENT_ID_CHARGE_RETURN = 4; // 充值返利活动
    public static $EVENT_ID_MONTH_CARD = 5; // 月卡返利活动
    public static $EVENT_ID_GROWTH_FOND = 6; // 成长基金
    public static $EVENT_ID_VIP_ONLY = 7; // VIP专享购买

    public static $KEY_CAMPAIGN_EVENT_STAT = "campaign_event:%s:%s"; // palceholder: campaign_id, role_id
    public static $TIME_OFFSET = -10800;
    public static $LOGIN_HISTORY_DAYS = 8;
    public static $KEY_LOGIN_HISTORY = "ulogindays:%s"; // placeholder: role_id

    public static $GROWTH_FOND_PRICE = 1000;
    public static $VIP_ONLY_PRICE = [
        1 => 10,
        2 => 28,
        3 => 58,
        4 => 98,
        5 => 198,
        6 => 258,
        7 => 298,
        8 => 398,
        9 => 498,
        10 => 998,
        11 => 1298,
        12 => 1998,
        13 => 2498,
        14 => 2998,
        15 => 4998,
    ];

    public static $CACHE_KEY_GROWTH_FOND = 'growth_fond:%s';
    public static $CACHE_KEY_VIP_ONLY = 'vip_only:%s:%s'; // user_id:vip_level

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new ItemLib();
        }, true);
        $this->_di->set('charge_lib', function() {
            return new ChargeLib();
        }, true);
        $cfg = $this->getDI()->get('config');
        $this->server_id = $cfg['server_id'];
    }

    public function getAvailableCampaigns() {
        $cfg = self::getGameConfig('event');
        if (!isset($cfg[$this->server_id])) {
            syslog(LOG_DEBUG, "campaign not configured in this server ".$this->server_id);
            return array();
        }
        $campaigns = $cfg[$this->server_id];
        $available_campaigns = array();
        foreach ($campaigns as $id=>$campaign) {
            $endtime = strtotime($campaign['end_time']);
            if (time() > $endtime) {
                syslog(LOG_DEBUG, "skip obsolete campaign $id $campaign[end_time]");
                continue;
            }
            $available_campaigns[$id]= $campaign;
            syslog(LOG_DEBUG, "get campaign $id");
        }
        return $available_campaigns;
    }

    public function getCampaignStatus($role_id) {
        $cfg = self::getGameConfig('event');
        $curr_ts = time();
        $rds = $this->_di->getShared('redis');
        $campaigns = $this->getAvailableCampaigns();
        $result = array();
        foreach ($campaigns as $id=>$campaign) {
            $award_record_key = "campaign:$id:$role_id";
            $records = $rds->hgetall($award_record_key);
            $r = array('record'=>$records);
            if ($id==1) {
                // accumulate login status
                $ccfg = $cfg[$this->server_id][$id];
                $start_ts = strtotime($ccfg['start_time']);
                $count = $this->getLoginDays($role_id, $start_ts);
                $r['progress'] = $count;
            }
            $r['life_time'] = array($campaign['start_time'], $campaign['end_time']);
            syslog(LOG_DEBUG, "campaign $id life time $campaign[start_time], $campaign[end_time]");
            $result[$id] = $r;
        }
        
        return $result;
    }

    public function accept($role_id, $campaign_id, $award_id) {
        syslog(LOG_DEBUG, "accept($role_id, $campaign_id, $award_id)");
        $cfg = self::getGameConfig('event');
        // check campaign
        $campaigns = $this->getAvailableCampaigns();
        if (!isset($campaigns[$campaign_id])) {
            syslog(LOG_ERR, "accept($role_id, $campaign_id, $award_id) campaign not found");
            return array('code'=>404, 'msg'=>'campaign not exists');
        }
        $ccfg = $cfg[$this->server_id][$campaign_id];
        $campaign = $campaigns[$campaign_id];
        if ($award_id > 8 && $campaign_id==1) {
            // 8 days or layer
            $actual_award_id = 8;
        } else {
            $actual_award_id = $award_id;
        }
        if (!isset($campaign['conf'][$actual_award_id])) {
            syslog(LOG_ERR, "accept($role_id, $campaign_id, $award_id) award($actual_award_id) not exists");
            return array('code'=>404, 'msg'=>'award not exists');
        }

        $rds = $this->_di->getShared('redis');
        // check if already given
        $award_record_key = "campaign:$campaign_id:$role_id";
        $records = $rds->hgetall($award_record_key);
        if (isset($records[$award_id])) {
            syslog(LOG_ERR, "accept($role_id, $campaign_id, $award_id) award($actual_award_id) already given");
            return array('code'=>403, 'msg'=>'already given');
        }

        // check condition
        switch ($campaign_id) {
            case self::$EVENT_ID_NEW_SERVER_LOGIN:
            // accumulate login
            $items = array_values($campaign['conf'][$actual_award_id]['bonus']);
            $start_ts = strtotime($ccfg['start_time']);
            $login_days = $this->getLoginDays($role_id, $start_ts);
            if ($award_id>8) {
                // only today's award is available
                if ($login_days != $award_id) {
                    syslog(LOG_INFO, "suspended campaign award due to condition check failed ($login_days != $award_id) ");
                    return array('code'=> 405, 'msg'=> 'condition not satisfied 2');
                }
            } else {
                if ($login_days < $award_id) {
                    syslog(LOG_INFO, "suspended campaign award due to condition check failed ($login_days < $award_id) ");
                    return array('code'=> 405, 'msg'=> 'condition not satisfied');
                }
            }
            break;
            case self::$EVENT_ID_NEW_SERVER_LVLUP:
            // level up to
            $items = array_values($campaign['conf'][$award_id]['bonus']);
            $required_level = $campaign['conf'][$award_id]['condition'];
            $user_lib = $this->_di->getShared('user_lib');
            $user = $user_lib->getUser($role_id);
            if ($user[UserLib::$USER_PROF_FIELD_LEVEL] < $required_level) {
                syslog(LOG_INFO, "suspended campaign award due to condition check failed");
                return array('code'=> 405, 'msg'=> 'condition not satisfied');
            }
            break;
            case self::$EVENT_ID_FIRST_CHARGE:
                $items = array_values($campaign['conf'][$award_id]['bonus']);
                $user_lib = $this->_di->getShared('user_lib');
                $user = $user_lib->getUser($role_id);
                if (! $user[UserLib::$USER_PROF_FIELD_CHARGE]) {
                    syslog(LOG_INFO, "suspended campaign award due to condition check failed");
                    return array('code'=> 405, 'msg'=> '尚未充值，无法领取奖励.');
                }
                break;
            case self::$EVENT_ID_CHARGE_RETURN:
                $items = array_values($campaign['conf'][$award_id]['bonus']);
                $req_charge = $campaign['conf'][$award_id]['condition'];
                $user_lib = $this->_di->getShared('user_lib');
                $user = $user_lib->getUser($role_id);
                if ($user[UserLib::$USER_PROF_FIELD_CHARGE] < $req_charge) {
                    syslog(LOG_INFO, "suspended campaign award due to condition check failed");
                    return array('code'=> 405, 'msg'=> "充值需要满{$req_charge}才能领取活动奖励");
                }
                break;
            case self::$EVENT_ID_MONTH_CARD:
                $items = array_values($campaign['conf'][$award_id]['bonus']);
                $charge_lib = $this->getDI()->getShared('charge_lib');
                $m_c_ttl = $charge_lib->getMonthCardTTL($role_id);
                if (! $m_c_ttl) {
                    syslog(LOG_INFO, "suspended campaign award due to condition check failed");
                    return array('code'=> 405, 'msg'=> "需要购买月卡才能领取该奖励哦");
                }
                break;
            case self::$EVENT_ID_GROWTH_FOND:
                $cache_key = sprintf(self::$CACHE_KEY_GROWTH_FOND, $role_id);
                $buyed = $this->redis->get($cache_key);
                if ($buyed) {
                    $items = array_values($campaign['conf'][$award_id]['bonus']);
                    $need_lvl = $campaign['conf'][$award_id]['condition'];
                    $user_lib = $this->_di->getShared('user_lib');
                    $user = $user_lib->getUser($role_id);
                    if ($user[UserLib::$USER_PROF_FIELD_LEVEL] < $need_lvl) {
                        syslog(LOG_INFO, "suspended campaign award due to condition check failed");
                        return array('code'=> 405, 'msg'=> "等级到达{$need_lvl}才能领取奖励哦");
                    }
                } else {
                    syslog(LOG_INFO, "suspended campaign award due to not enough diamond");
                    return array('code'=> 505, 'msg'=> "只有购买了成长计划才能领取哦");
                }

                break;
            case self::$EVENT_ID_VIP_ONLY:
                $items = array_values($campaign['conf'][$award_id]['bonus']);
                $need_vip = $campaign['conf'][$award_id]['condition'];
                $user_lib = $this->_di->getShared('user_lib');
                $user = $user_lib->getUser($role_id);
                if ($user[UserLib::$USER_PROF_FIELD_VIP] < $need_vip) {
                    syslog(LOG_INFO, "suspended campaign award due to condition check failed");
                    return array('code'=> 405, 'msg'=> "VIP级别到达{$need_vip}才能领取奖励哦");
                } else {
                    $need_gold = self::$VIP_ONLY_PRICE[$award_id];
                    $remain = $user_lib->consumeFieldAsync($role_id, UserLib::$USER_PROF_FIELD_GOLD, $need_gold);
                    if (! $remain) {
                        return array('code'=> 403, 'msg'=> "没有足够的钱购买此专享服务哦");
                    }
                }
                break;
            default:
            return array('code'=>403, 'msg'=>'unaccepted campaign');
        }


        syslog(LOG_DEBUG, "give campain award $campaign_id:$award_id items:".json_encode($items));
        // give award
        $res = array();
        $item_lib = $this->_di->getShared('item_lib');
        foreach ($items as &$item) {
            $ir = $item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count']);
            // TODO: more dedicated result handle
            if (is_array($ir)) {
                $item = array_merge($ir, $item);
            }
        }
        $res['items'] = $items;
        $res['code'] = 200;

        // record in redis
        $award_record_key = "campaign:$campaign_id:$role_id";
        $rds = $this->_di->getShared('redis');
        $rds->hset($award_record_key, $award_id, 3);

        // update status
        $status = $this->getCampaignStatus($role_id);
        $res['status'] = $status;

        return $res;
    }

    public function getDayth($ts) {
        $dayth = ceil(($ts - self::$TIME_OFFSET)/86400);
        return $dayth;
    }

    public function getLoginDays($role_id, $start_ts) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$KEY_LOGIN_HISTORY, $role_id);
        $dayth = $this->getDayth(time());
        $count = $rds->zcount($key, $this->getDayth($start_ts), $dayth);
        syslog(LOG_DEBUG, "getLoginDays($role_id, $start_ts) => $count");
        return $count;
    }

    public function fireEvent($event_id, $params = [])
    {
        syslog(LOG_DEBUG, "fireEvent($event_id..)");
        $handler = '';
        $cfg = self::getGameConfig('event');
        if (isset ($cfg[$this->server_id]) && isset ($cfg[$this->server_id][$event_id])) {
            $cfg = $cfg[$this->server_id][$event_id];
        } else {
            return false;
        }
        $curr_ts = time();
        $event_start = strtotime($cfg['start_time']);
        $event_end = strtotime($cfg['end_time']);
        if (! ($curr_ts >= $event_start && $curr_ts < $event_end)) {
            return false;
        }
        switch ($event_id) {
            case self::$EVENT_ID_NEW_SERVER_LOGIN:
                if (count($params) != 1) {
                    syslog(LOG_ERR, "fireEvent, param needed!");
                    return false;
                }
                $handler = 'newServerLogin';
                $params[] = $curr_ts;
                $params[] = $event_start;
                $params[] = $cfg['conf'];
                break;
        }
        if (! $handler) {
            $ret = false;
        } else {
            $ret = call_user_func_array([__CLASS__, $handler], $params);
        }
        return $ret;
    }

    public function getCampaignEvents($role_id) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$KEY_CAMPAIGN_EVENT_STAT, self::$EVENT_ID_NEW_SERVER_LOGIN, $role_id);
        syslog(LOG_DEBUG, "key:$key");
        $cstat = $rds->hgetall($key);
        return $cstat;
    }

    protected function newServerLogin($user_id, $curr_ts, $start_ts)
    {
        syslog(LOG_DEBUG, "event user $user_id login $curr_ts");
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$KEY_LOGIN_HISTORY, $user_id);
        $dayth = $this->getDayth($curr_ts);
        syslog(LOG_DEBUG, "event user $user_id login $curr_ts, dayth = $dayth");
        $r = $rds->zadd($key, $dayth, $dayth);
        syslog(LOG_DEBUG, "zadd r=$r");
        if ($r) {
            $rds->zrem($key, 0, $this->getDayth($start_ts)-1);
        }
        return $r;
    }

    public function buyGrowthPlan($role_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_GROWTH_FOND, $role_id);
        $buyed = $this->redis->get($cache_key);
        $user_lib = $this->getDI()->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $vip = intval($user[UserLib::$USER_PROF_FIELD_VIP]);
        if ($vip < 2) {
            return ['code' => 407, 'msg' => '只有VIP2以上用户才能购买成长计划'];
        }
        if ($buyed) {
            return ['code' => 405, 'msg' => '已经购买了成长计划'];
        } else {
            $user_lib = $this->getDI()->getShared('user_lib');
            $remain = $user_lib->consumeFieldAsync($role_id, UserLib::$USER_PROF_FIELD_GOLD, self::$GROWTH_FOND_PRICE);
            if (! $remain) {
                return ['code' => 403, 'msg' => '没有足够的钱购买成长计划'];
            } else {
                $this->redis->set($cache_key, 1);
                return ['code' => 200, 'msg' => 'OK', 'gold_remain' => $remain];
            }
        }
    }

    public function getGrowthPlan($role_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_GROWTH_FOND, $role_id);
        $ret = $this->redis->get($cache_key);
        return $ret ? 1 : 0;
    }
}
