<?php 
namespace Cap\Libraries;

use Cap\Models\Db\UserMissionModel;
use Cap\Libraries\UserLib;
use Phalcon\Exception;

class MissionLib extends BaseLib {

    public static $DAILY_PASS_RECORD_KEY = 'dailysecpass:%s';  // role_id
    public static $PASSED_SECTIONS_KEY = 'secpass:%s';  // role_id
    public static $ELITE_DAILY_PASS_RECORD_KEY = 'dailyesecpass:%s';  // role_id
    public static $ELITE_PASSED_SECTIONS_KEY = 'esecpass:%s';  // role_id
    public static $CONFIG_NAME = 'mission_map';
    public static $ELITE_CONFIG_NAME = 'elite_mission';
    public static $STAR_BONUS_KEY = 'nami:mission:starbonus:%s';
    public static $ELITE_STAR_BONUS_KEY = 'nami:elite_mission:starbonus:%s';
    public static $STAR_BONUS_CONFIG = 'mission_star_bonus';
    public static $ELITE_STAR_BONUS_CONFIG = 'elite_mission_star_bonus';
    public static $BATTLE_TYPE = 3; // normal

    public static $RABBIT_CONFIG_NAME = 'mission_rabbit';
    public static $REDRIBBON_CONFIG_NAME = 'mission_redribbon';
    public static $GINYU_CONFIG_NAME = 'mission_ginyu';
    public static $FIREDRICE_CONFIG_NAME = 'mission_firedrice';
    public static $FLISA_CONFIG_NAME = 'mission_flisa';

    public static $GENERAL_DAILY_PASS_RECORD_KEY = 'dailysecpass:%s:%s'; // type, role_id

    public static $MISSION_TYPE_NORMAL = 0;
    public static $MISSION_TYPE_ELITE = 1;
    public static $MISSION_TYPE_RABBIT = 2;
    public static $MISSION_TYPE_REDRIBBON = 3;
    public static $MISSION_TYPE_FIREDRICE = 4;
    public static $MISSION_TYPE_GINYU = 5;
    public static $MISSION_TYPE_FLISA = 6;

    public static $MISSION_CONFIG_INDEX = array(
        2 => [
            "config_name"=>"mission_rabbit",
        ],
        3 => [
            "config_name"=>"mission_redribbon",
        ],
        4 => [
            "config_name"=>"mission_firedrice",
        ],
        5 => [
            "config_name"=>"mission_ginyu",
        ],
        6 => [
            "config_name"=>"mission_flisa",
        ],
    );

	const MISSION_STATE_NAMESPACE = "mission";
	public function __construct($type=0) {
		parent::__construct();
        $this->type = $type;
        syslog(LOG_DEBUG, "mssion constructing type=$type");
        if ($type == self::$MISSION_TYPE_NORMAL) {
            // keep default
            self::$DAILY_PASS_RECORD_KEY = 'dailysecpass:%s';
            self::$PASSED_SECTIONS_KEY = 'secpass:%s';
            self::$STAR_BONUS_KEY = 'nami:mission:starbonus:%s';
            self::$CONFIG_NAME = 'mission_map';
            self::$STAR_BONUS_CONFIG = 'mission_star_bonus';
            self::$BATTLE_TYPE = \Cap\Libraries\BattleLib::$BATTLE_TYPE_PVE_NORMAL;
        } else if ($type == self::$MISSION_TYPE_ELITE) {
            // using elite config
            self::$DAILY_PASS_RECORD_KEY = self::$ELITE_DAILY_PASS_RECORD_KEY;
            self::$PASSED_SECTIONS_KEY = self::$ELITE_PASSED_SECTIONS_KEY;
            self::$STAR_BONUS_KEY = self::$ELITE_STAR_BONUS_KEY;
            self::$CONFIG_NAME = self::$ELITE_CONFIG_NAME;
            self::$STAR_BONUS_CONFIG = self::$ELITE_STAR_BONUS_CONFIG;
            self::$BATTLE_TYPE = \Cap\Libraries\BattleLib::$BATTLE_TYPE_PVE_ELITE;
        } else if (!isset(self::$MISSION_CONFIG_INDEX[$type])) {
            syslog(LOG_ERR, "mission type $type not configured");
            throw new \Phalcon\Exception("config not defined", ERROR_CODE_CONFIG_NOT_FOUND);
        } else {
            self::$DAILY_PASS_RECORD_KEY = sprintf(self::$GENERAL_DAILY_PASS_RECORD_KEY, $type, "%s");
            switch ($type) {
            case self::$MISSION_TYPE_RABBIT:
                self::$BATTLE_TYPE = \Cap\Libraries\BattleLib::$BATTLE_TYPE_PVE_SUB1;
                break;
            case self::$MISSION_TYPE_REDRIBBON:
                self::$BATTLE_TYPE = \Cap\Libraries\BattleLib::$BATTLE_TYPE_PVE_SUB2;
                break;
            case self::$MISSION_TYPE_FIREDRICE:
                self::$BATTLE_TYPE = \Cap\Libraries\BattleLib::$BATTLE_TYPE_PVE_SUB3;
                break;
            case self::$MISSION_TYPE_GINYU:
                self::$BATTLE_TYPE = \Cap\Libraries\BattleLib::$BATTLE_TYPE_PVE_SUB4;
                break;
            case self::$MISSION_TYPE_FLISA:
                self::$BATTLE_TYPE = \Cap\Libraries\BattleLib::$BATTLE_TYPE_PVE_SUB5;
                break;
            default:
                syslog(LOG_WARNING, "battle type unspecified mission type ".$type);
                throw new \Phalcon\Exception("battle type unspecified mission type ".$type, ERROR_CODE_CONFIG_NOT_FOUND);
            }
            self::$CONFIG_NAME = self::$MISSION_CONFIG_INDEX[$type]['config_name'];
        }
        syslog(LOG_DEBUG, "misiosn lib using config file ".self::$CONFIG_NAME.", battletype ".self::$BATTLE_TYPE);

		$this->_di->set("resque_lib", function() {
			return new ResqueLib();
		}, true);
		$this->_di->set("user_lib", function(){
			return new UserLib();
		}, true);
		$this->_di->set("card_lib", function(){
			return new \Cap\Libraries\CardLib();
		}, true);
		$this->_di->set("user_mission_model", function() use($type) {
            if ($type==self::$MISSION_TYPE_NORMAL) {
                return new UserMissionModel();
            } else if ($type==self::$MISSION_TYPE_ELITE) {
                return new \Cap\Models\db\UserEliteMissionModel();
            } else {
                $classname = "Cap\\Controllers\\UserMission${type}Model";
                return new $classname();
            }
		}, true);
        $this->_di->set("battle_lib", function() {
            return new \Cap\Libraries\BattleLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
    }


    /*
     * attack a section, with mercenary(user_id) employed
     */
    public function attack($user_id, $section_id, $mercenary, $members, $fee=0) {
        # check sectin existence
        $mission_config = self::getGameConfig(self::$CONFIG_NAME);
        $sections = $mission_config['sections'];
        if (!isset($sections[$section_id])) {
            syslog(LOG_INFO, "section $section_id not exists");
            return array('code'=> 400, 'msg'=> 'section not exists');
        }
        $section = $sections[$section_id];
        # check if this section available for the user

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        if ($this->type == self::$MISSION_TYPE_NORMAL || $this->type == self::$MISSION_TYPE_ELITE) {
            # both elite and normal section should beyond normal section
            $max_section = $user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_SECTION];
            if ($this->type == self::$MISSION_TYPE_ELITE && $section_id > $max_section) {
                return array('code'=> 400, 'msg'=> '需要通关对应普通副本.');
            }
            if ($section_id>1) {
                # elite section should also not exceed elite max_section
                $sec_points = $this->getPassedSections($user_id);
                if (!isset($sec_points[$section_id-1])) {
                    syslog(LOG_ERR, "suspend $user_id attck elite section $section_id");
                    return array('code'=> 400, 'msg'=> '尚未开启此章节.');
                }
            }
        }

        $rds = $this->_di->getShared('redis');
        $daily_pass_record_key = sprintf(self::$DAILY_PASS_RECORD_KEY, $user_id);
        $today_mission_passes = $rds->hgetall($daily_pass_record_key);
        $today_passes = isset($today_mission_passes[$section_id])?$today_mission_passes[$section_id]:0;

        # check mission passes limit
        if (isset($mission_config['daily_pass_limit'])) {
            if (array_sum($today_mission_passes) >= $mission_config['daily_pass_limit']) {
                syslog(LOG_DEBUG, "suspend $user_id attack ".$this->type.":$section_id due to max limit");
                return array('code'=> 403, 'msg'=> 'mission daily pass limit reached');
            }
        }
        # check open weekday time
        if (isset($mission_config['open_wday'])) {
            $wday = date('w', time()-3600*5); // back 5 hour
            if (!in_array($wday, $mission_config['open_wday'])) {
                syslog(LOG_DEBUG, "$wday suspend $user_id attack ".$this->type.":$section_id due to weekday restriction");
                return array('code'=> 403, 'msg'=> 'not in open time');
            }
        }

        # check daily pass limit
        if ($today_passes >= $section['daily_pass_limit']) {
            syslog(LOG_DEBUG, "suspend $user_id attack $section_id due to max limit");
            return array('code'=> 403, 'msg'=> 'section daily pass limit reached');
        }

        # check required level if exists
        /*
        if (isset($section['required_level']) && $user['level']<$section['required_level']) {
            syslog(LOG_ERR, "suspend user $user_id attack $section_id for level viloation($section[required_level])");
            return array('code'=> 400, 'msg'=> "user level not satisfied $section[required_level]");
        }
         */


        # check & consume commision
        $resque_lib = $this->_di->getShared('resque_lib');
        if ($mercenary && $fee) {
            // give money to mercenary, according to mercenary's strength
            // get mercenary's leader card strength or passed by client?
            //$fee = 1500;
            $remain = $user_lib->incrProfBy($user_id, 'coin', -$fee);
            if ($remain < 0) {
                // return fee to user
                $user_lib->incrProfBy($user_id, 'coin', $fee);
                return array('code'=> 403, 'msg'=> '索尼币不足以支付雇佣兵援助费用');
            }
        }
        
        # check & consume energy
        $energy = $user_lib->consumeMissionEnergy($user_id, $section['energy_cost']);
        if ($energy === false) {
            syslog(LOG_INFO, "fail to consume mission energy");
            if ($mercenary && $fee) {
                // return fee to user
                $user_lib->incrProfBy($user_id, 'coin', $fee);
            }
            return array('code'=> 405, 'msg'=> '冒险能量不足.');
        }

        # check ok to attak, really give money to mercenary
        if ($mercenary && $fee) {
            // done: queue jobs to persistent property changes, implement jobs
            // $user_lib->incrProfBy($mercenary, 'coin', $fee);
            $resque_lib->setJob('user', 'profchange', array('uid'=> $user_id, 'coin'=>-$fee));
            $user_lib->addMercenaryFee($user_id, $mercenary, $fee);
            //$resque_lib->setJob('user', 'profchange', array('uid'=> $mercenary, 'coin'=>$fee));
        }

        # calculate drops upon pass
        $items_per_pass = array();
        foreach ($section['drops'] as $drop) {
            $count = 1;
            if (isset($drop['count'])) {
                $count = $drop['count'];
            }
            for ($i=0;$i<$count;$i++) {
                if (mt_rand(0,100)/100 < $drop['chance']) {
                    $items_per_pass []= array('item_id'=> $drop['item_id'], 
                        'sub_id'=> $drop['sub_id'], 'count'=> 1);
                }
            }
        }
        $res['drops'] = $items_per_pass;

        # assign battle_id
        $battle_info = array(
            'cards'=> json_encode($members),
            'drops'=> json_encode($items_per_pass),
            'type'=> $this->type
        );
        $battle_lib = $this->_di->getShared('battle_lib');
        $battle_id = $battle_lib->prepareBattle($user_id, $section_id, $battle_info, self::$BATTLE_TYPE, $rds);


        # enque mission attack start event
        # done: implement jobs
        $resque_lib->setJob('mission', 'missionattack', 
            array('sec'=>$section_id, 'uid'=>$user_id, 'btl'=>$battle_id, 'type'=>$this->type));
        // jobs: 1. record history; 2. update statistic, TODO: skip move this job to unified battle queue
        return array('code'=> 200, 'battle_id'=> $battle_id, 'drops'=> $items_per_pass);
    }

    /*
     * commit a mission attack
     */
    public function commitAttack($role_id, $battle_id, $result, $deaths) {
        # check btl_id, check 
        $rds = $this->_di->getShared('redis');
        $battle_lib = $this->_di->getShared('battle_lib');
        $btl_info = $battle_lib->commitBattle($role_id, $battle_id, self::$BATTLE_TYPE, $result, array('deaths'=>$deaths));
        if (!$btl_info) {
            return array('code'=> 400, 'msg'=> 'battle_id not exists or exipred or invalid');
        }
        $section_id = $btl_info[BattleLib::$BATTLE_INFO_FIELD_TARGET];
        if ($btl_info['type'] != $this->type) {
            syslog(LOG_ERR, "mission commitAttack($role_id, $battle_id,...) saved type:$btl_info[type] not match");
            return array('code'=> 403, 'msg'=> 'mission type invaled');
        }
        $drops = json_decode($btl_info['drops'], true);

        $res = array('code'=> 200);
        if (!$result) {
            # failed
            syslog(LOG_DEBUG, "failed mission for $role_id on $section_id");
            return $res;
        }

        # pass points
        if ($deaths < 1) {
            $point = 3;
        } else if ($deaths < 2) {
            $point = 2;
        } else {
            $point = 1;
        }
    
        # gain
        $cards = json_decode($btl_info['cards']);
        $bonus_res = $this->giveMissionBonus($role_id, $cards, $section_id, $point, 1, array($drops));
        $bonus_res['drops'] = $bonus_res['drops'][0];
        $res = array_merge($res, $bonus_res);

        # no more job for sub mission
        if (($this->type != self::$MISSION_TYPE_NORMAL) && ($this->type != self::$MISSION_TYPE_ELITE)) {
            return $res;
        }

        $resque_lib = $this->_di->getShared('resque_lib');
        $passed_key = sprintf(self::$PASSED_SECTIONS_KEY, $role_id);
        $saved_sections = $this->getPassedSections($role_id);
        if (isset($saved_sections[$section_id]) && $saved_sections[$section_id] < $point) {
            # update best point
            syslog(LOG_DEBUG, "update best point $point in sec $section_id for $role_id");
            $rds->hset($passed_key, $section_id, $point);
            # done: implement jobs
            $resque_lib->setJob('mission', 'bestpoint', array('uid'=>$role_id, 'sec'=>$section_id, 'point'=>$point, 'type'=>$this->type));
            $res['best_point'] = $point;
        } else if (!isset($saved_sections[$section_id])) {
            syslog(LOG_DEBUG, "set point $point in sec $section_id for $role_id");
            $rds->hset($passed_key, $section_id, $point);
            # done: implement jobs
            $resque_lib->setJob('mission', 'bestpoint', array('uid'=>$role_id, 'sec'=>$section_id, 'point'=>$point, 'type'=>$this->type));
            $res['best_point'] = $point;
        }

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        if ($this->type==0 && $user['section'] < $section_id) {
            # set new max_section
            $new_section = $user_lib->incrProfBy($role_id, 'section', 1);
            # done: implement jobs
            $resque_lib->setJob('user', 'profchange', array('uid'=>$role_id, 'section'=>1));
        }

        return $res;
    }

    /*
     * wipe: quick battle, user passed with points 3 can wipe the section
     * only applicable for MISSION_TYPE_NORMAL and MISSION_TYPE_ELITE
     */
    public function wipe($role_id, $section_id, $count=1, $free=true) {
        syslog(LOG_DEBUG, "wipe($role_id, $section_id, $count)");
        # check section existence
        $mission_map_config = self::getGameConfig(self::$CONFIG_NAME);
        $sections = $mission_map_config['sections'];
        if (!isset($sections[$section_id])) {
            syslog(LOG_INFO, "section $section_id not exists");
            return array('code'=> 400, 'msg'=> 'section not exists');
        }
        $section = $sections[$section_id];

        # check wipe access
        $sec_points = $this->getPassedSections($role_id);
        if (!isset($sec_points[$section_id]) || $sec_points[$section_id]<3) {
            return array('code'=> 403, 'msg'=> 'operation not allowed');
        }

        # check daily pass limit
        $rds = $this->_di->getShared('redis');
        $daily_pass_record_key = sprintf(self::$DAILY_PASS_RECORD_KEY, $role_id);
        $today_passes = $rds->hget($daily_pass_record_key, $section_id);
        if ($today_passes >= $section['daily_pass_limit']) {
            syslog(LOG_DEBUG, "suspend $role_id wipe $section_id due to max limit");
            return array('code'=> 403, 'msg'=> 'section daily pass limit reached');
        }
        
        # consume wipe energy or gold
        $user_lib = $this->_di->getShared('user_lib');
        if ($free) {
            $wipe_energy_cost = $count * 1;
            $wipe_energy = $user_lib->consumeWipeEnergy($role_id, $wipe_energy_cost);
            if ($wipe_energy === false) {
                syslog(LOG_INFO, "suspend $count wipe $section_id of $role_id due to lack wipe energy");
                return array('code'=> 403, 'msg'=> 'not enough wipe energy');
            }
        } else {
            $gold_cost = $count * 1;
            $gold = $user_lib->incrProfBy($role_id, UserLib::$USER_PROF_FIELD_GOLD, -$gold_cost);
            if ($gold < 0) {
                $user_lib->incrProfBy($role_id,  UserLib::$USER_PROF_FIELD_GOLD, $gold_cost);
                syslog(LOG_INFO, "suspend nonfree $count wipe $section_id of $role_id due to lack gold");
                return array('code'=> 403, 'msg'=> 'not enough gold');
            }
        }
        # consume mission energy
        $mission_energy = $user_lib->consumeMissionEnergy($role_id, $count * $section['energy_cost']);
        if ($mission_energy === false) {
            syslog(LOG_INFO, "fail to consume mission energy for $role_id");
            // return wipe energy/gold to user
            if ($free) {
                $user_lib->addWipeEnergy($role_id, $wipe_energy_cost);
            } else {
                $user_lib->incrProfBy($role_id,  UserLib::$USER_PROF_FIELD_GOLD, $gold_cost);
            }
            return array('code'=> 405, 'msg'=> 'mission energy not enough');
        }

        # persist gold cost
        if (!$free) {
            $resque_lib = $this->_di->getShared('resque_lib');
            $resque_lib->setJob('user', 'profchange', array('uid'=> $role_id, UserLib::$USER_PROF_FIELD_GOLD=>-$gold_cost));
        }

        # give bonus
        $card_lib = $this->_di->getShared('card_lib');
        $deck_info = $card_lib->getDeckCard($role_id);
        $cards = array();
        if (is_array($deck_info)) {
            foreach ($deck_info as $card_info) {
                if(isset($card_info['ucard_id'])) {
                    $cards []= $card_info['ucard_id'];
                }
            }
        }
        # give bonus and record daily pass count
        $res = $this->giveMissionBonus($role_id, $cards, $section_id, 3, $count);
        if (isset($wipe_energy)) {
            $res['wipe_energy'] = $wipe_energy;
        } else if (isset($gold)) {
            $res['gold'] = $gold;
        }
        if (!isset($res['mission_energy'])) {
            $res['mission_energy'] = $mission_energy;
        }
        $res['code'] = 200;
        syslog(LOG_DEBUG, "wipe success, remain_mission_energy=$mission_energy");
        return $res;
    }

    public function getPassedSections($role_id) {
        $rds = $this->_di->get('redis');
        $passed_key = sprintf(self::$PASSED_SECTIONS_KEY, $role_id);
        $sec_points = $rds->hgetall($passed_key);
        if ($sec_points) {
            return $sec_points;
        }
        $user_mission_model = $this->_di->getShared('user_mission_model');
        $sections = $user_mission_model->getSections($role_id);
        $passed_sections = array();
        foreach ($sections as $section) {
            if ($section['best_point']) {
                // already passed
                $passed_sections[$section['section_id']] = $section['best_point'];
            }
        }
        syslog(LOG_DEBUG, "set passed section from db for $role_id");
        if ($passed_sections) {
            $rds->hmset($passed_key, $passed_sections);
            $rds->expire($passed_key, 3600*12);
        }
        return $passed_sections;
    }

    public function getSectionsHistory($role_id) {
        $rds = $this->_di->get('redis');
        $sec_points = $this->getPassedSections($role_id);

        $daily_pass_key = sprintf(self::$DAILY_PASS_RECORD_KEY, $role_id);
        $daily_passes = $rds->hgetall($daily_pass_key);
        $secs = array();
        foreach ($sec_points as $section_id=>$point) {
            if (isset($daily_passes[$section_id])) {
                $count = $daily_passes[$section_id];
            } else {
                $count = 0;
            }
            $secs[$section_id] = array('point'=> $point, 'count'=>$count);
        }
        return $secs;
    }

    // 获取当天通关所有副本的次数
    public function getSectionPassCountTotal($role_id)
    {
        $rds = $this->_di->get('redis');
        $daily_pass_key = sprintf(self::$DAILY_PASS_RECORD_KEY, $role_id);
        $daily_passes = $rds->hgetall($daily_pass_key);

        return $daily_passes ? array_sum($daily_passes) : 0;
    }

    // 获得最大通关英雄章节
    public function getMaxSection($role_id, $elite = false)
    {
        $rds = $this->_di->get('redis');
        if ($elite) {
            $cache_key = sprintf(self::$ELITE_PASSED_SECTIONS_KEY, $role_id);
        } else {
            $cache_key = sprintf(self::$PASSED_SECTIONS_KEY, $role_id);
        }
        $sections = $rds->hGetAll($cache_key);
        if (is_array($sections) && count($sections) > 0) {
            $section_ids = array_keys($sections);
            $max_id = max($section_ids);
            return $max_id;
        } else {
            return 0;
        }
    }

    // 获得最大通关普通章节
    /*
     * calcute and give mission bonus
     * return: [
     *  'remain_pass'=> 1,
     *  'mission_energy'=> 10,  // user add exp: new mission_energy if presents
     *  'level'=> 12,           // user add exp: user level 
     *  'exp'=> 570,            // user add exp: user experience
     *  'cards'=> [1001=>['level'=>10, 'exp'=>120],...] // card add exp: 
     *  'coin'=> 340,
     * ]
     */
    public function giveMissionBonus($role_id, $cards, $section_id, $point, $times=1, $items=false) {
        $rds = $this->_di->getShared('redis');
        $user_lib = $this->_di->getShared('user_lib');
        $res = array();
        $mission_cfg = self::getGameConfig(self::$CONFIG_NAME);
        $sections = $mission_cfg['sections'];
        $section = $sections[$section_id];
        $inc_exp_user = $section['role_exp'] * $times;
        $inc_exp_card = $section['card_exp'] * $times;
        $coin_gain = $section['coin'] * $times;

        $daily_pass_key = sprintf(self::$DAILY_PASS_RECORD_KEY, $role_id);
        $n = $rds->hincrBy($daily_pass_key, $section_id, $times*1);
        if ($n == $times*1) {
            // may executed multiple times
            $rds->expireAt($daily_pass_key, self::getDefaultExpire()); // expire next morning
        }
        $remain_pass = $section['daily_pass_limit'] - $n;
        $res['remain_pass'] = $remain_pass;

        # given drops, add exps
        $exp_res = $user_lib->addExp($role_id, $inc_exp_user);
        if ($exp_res)
            $res = array_merge($exp_res, $res);
        # done: add card exp
        if (!empty($cards)) {
            $card_lib = $this->_di->getShared('card_lib');
            $card_exp_res = $card_lib->addExpForCards($role_id, $cards, $inc_exp_card);
            if ($card_exp_res) {
                $res['cards'] = $card_exp_res;
            }
        }

        if ($items === false) {
            $items = [];
            for($i=0;$i<$times;$i++) {
                $items_per_pass = array();
                foreach ($section['drops'] as $drop) {
                    $count = 1;
                    if (isset($drop['count'])) {
                        $count = $drop['count'];
                    }
                    for ($c=0;$c<$count;$c++) {
                        if (mt_rand(0,100)/100 < $drop['chance']) {
                            $items_per_pass []= array('item_id'=> $drop['item_id'], 
                                'sub_id'=> $drop['sub_id'], 'count'=> 1);
                        }
                    }
                }
                $items []= $items_per_pass;
            }
        }
        // add items to user, and optimize to batch dispatch
        $item_lib = $this->_di->getShared('item_lib');
        foreach ($items as &$items_per_pass) {
            foreach ($items_per_pass as &$item) {
                $ir = $item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], 1);
                if (is_array($ir)) {
                    $item = array_merge($ir, $item);
                }
            }
        }
        $res['drops'] = $items;

        /*
        if ($point == 3) {
            $coin_gain = intval($coin_gain * 1.2);
        } else if ($point == 2) {
            $coin_gain = intval($coin_gain * 1.1);
        }
         */
        $coin = $user_lib->incrProfBy($role_id, UserLib::$USER_PROF_FIELD_COIN, $coin_gain);
        syslog(LOG_DEBUG, "give coin $coin_gain, now $coin, $times*$section[coin] config:".self::$CONFIG_NAME);
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('user', 'profchange', array('uid'=> $role_id, UserLib::$USER_PROF_FIELD_COIN=>$coin_gain));
        $res['coin'] = $coin;
        return $res;
    }

    public function giveStarBonus($role_id, $chapter, $bonus_no)
    {
        $passed = $this->getPassedSections($role_id);
        $min_sec = ($chapter - 1) * 10 + 1;
        $max_sec = $chapter * 10;
        $condition = $bonus_no * 10;

        $points = 0;
        for ($i = $min_sec; $i <= $max_sec; $i++) {
            if (!isset($passed[$i])) {
                break;
            }
            $points += $passed[$i];
        }
        if ($points >= $condition) {
            $cache_key = sprintf(self::$STAR_BONUS_KEY, $role_id);
            $bonus_code = "{$chapter}:{$bonus_no}";
            if ($this->redis->sIsMember($cache_key, $bonus_code)) {
                throw new Exception("已经领取过奖励，无法重复领取", ERROR_CODE_FAIL);
            }
            $bonus_conf = self::getGameConfig(self::$STAR_BONUS_CONFIG);
            $bonus = $bonus_conf[$chapter][$bonus_no];
            $item_lib = $this->_di->getShared('item_lib');
            foreach ($bonus as & $item) {
                $ret = $item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count']);
                if (is_array($ret)) {
                    $item = $ret;
                }
            }
            if ($bonus) {
                $this->redis->sAdd($cache_key, $bonus_code);
                return array_values($bonus);
            }
            return false;
        } else {
            throw new Exception("未达成任务条件，无法领取相应奖励", ERROR_CODE_FAIL);
        }
    }

    public function getStarBonus($role_id)
    {
        $cache_key = sprintf(self::$STAR_BONUS_KEY, $role_id);
        $bonus_gived = $this->redis->sMembers($cache_key);
        if ($bonus_gived) {
            return array_values($bonus_gived);
        }
        return [];
    }

    /*
     * get all time limited missions' pass record
     */
    public static function getTimeLimitedMissionRecord($role_id) {
        $di = \Phalcon\DI::getDefault();
        $rds = $di->getShared('redis');
        $recs = array();
        foreach (self::$MISSION_CONFIG_INDEX as $type=> $_) {
            $key = sprintf(self::$GENERAL_DAILY_PASS_RECORD_KEY, $type, $role_id);
            $r = $rds->hgetall($key);
            if ($r) {
                $recs[$type] = array_sum($r);
            } else {
                $recs[$type] = 0;
            }
        }
        return $recs;
    }
}

// end of file
