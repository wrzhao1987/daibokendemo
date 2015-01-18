<?php 
namespace Cap\Libraries;

require_once 'UserActiveIndexLib.php';
require_once 'LoginIndexLib.php';

use Cap\Models\Db\UserModel;

class UserLib extends BaseLib {

    public static $USER_PROF_KEY = 'role:%s';
    public static $USER_PROF_FIELD_ACCOUNT_ID = 'acct';
    public static $USER_PROF_FIELD_NAME = 'name';
    public static $USER_PROF_FIELD_LEVEL = 'level';
    public static $USER_PROF_FIELD_EXP = 'exp';
    public static $USER_PROF_FIELD_COIN = 'coin';
    public static $USER_PROF_FIELD_GOLD = 'gold';
    public static $USER_PROF_FIELD_HONOR = 'honor';
    public static $USER_PROF_FIELD_SNAKE = 'snake';
    public static $USER_PROF_FIELD_GCOIN = 'gcoin';
    public static $USER_PROF_FIELD_VIP = 'vip';
    public static $USER_PROF_FIELD_SECTION = 'section';
    public static $USER_PROF_FIELD_ENERGY = 'mission_energy';
    public static $USER_PROF_FIELD_SESSION = 'session';
    public static $USER_PROF_FIELD_M_ENERGY_RST = 'energy_time';
    public static $USER_PROF_FIELD_LAST_LOGIN = 'last_login';
    public static $USER_PROF_FIELD_ROB_ENERGY = 'rob_energy';
    public static $USER_PROF_FIELD_ROB_ENERGY_RST = 'rob_energy_time';
    public static $USER_PROF_FIELD_NEWBIE = 'newbie';
    public static $USER_PROF_FIELD_CHARGE = 'charge';
    public static $USER_PROF_FIELD_FEE = 'fee';     // unaccepted mercenary fee received 
    public static $USER_PROF_GUILD_ID = 'gid';
    public static $USER_PROF_FIELD_BIRTH_TIME = 'birthts';     // unaccepted mercenary fee received 

    public static $USER_STAT_KEY = 'rstat:%s';

    public static $WIPE_ENERGY_KEY = 'wipe_energy:%s';
    public static $WIPE_COUNT_KEY = 'wipe_count:%s';
    public static $MERCENARY_RECORDS_KEY = 'mercenary_rec:%s';

    public static $USER_NEWS_KEY = 'unew:%s';

    public static $ENERGY_TYPE_ROB = 1;
    public static $ENERGY_TYPE_MISSION = 2;
    public static $MISSION_ENERGY_RESTORE_RATE = 300;  // seconds per point
    public static $ROB_ENERGY_RESTORE_RATE = 1800;     // seconds per point

    public static $ALLOWED_CUSTOM_FIELDS = array('ng1', 'ng2', 'ng3', 'ng4');

	public function __construct() {
		parent::__construct();
		$this->_di->set("user_model", function() {
			return new UserModel();
		});
        $this->_di->set("resque_lib", function() {
            return new \Cap\Libraries\ResqueLib();
        }, true);
        $this->_di->set("loginindex_lib", function(){
            return new \LoginIndexLib();
        }, true);
        $this->_di->set("frnd_lib", function(){
            return new \Cap\Libraries\FriendLib();
        }, true);
        $this->_di->set("guild_lib", function(){
            return new GuildLib();
        }, true);
        $this->_di->set("charge_lib", function(){
            return new ChargeLib();
        }, true);
	}

	public function getUser($user_id) {
        $rds = $this->_di->get('redis');
        $key = sprintf(self::$USER_PROF_KEY, $user_id);
        $user = $rds->hgetall($key);
        if (!$user) {
            $user = $this->loadProfs($user_id);
        } else {
            # update auto store energy
            $mission_energy = $this->calcAutoRestoreEnergy($user_id, $user, self::$ENERGY_TYPE_MISSION);
            $rob_energy = $this->calcAutoRestoreEnergy($user_id, $user, self::$ENERGY_TYPE_ROB);
            $user[self::$USER_PROF_FIELD_ROB_ENERGY] = $rob_energy;
            $user[self::$USER_PROF_FIELD_ENERGY] = $mission_energy;
            if (! isset($user[self::$USER_PROF_FIELD_GCOIN])) {
                $user[self::$USER_PROF_FIELD_GCOIN] = 0;
            }
        }
        if ($user) {
            $charge_lib = $this->_di->getShared('charge_lib');
            $charge = isset($user[self::$USER_PROF_FIELD_CHARGE])?$user[self::$USER_PROF_FIELD_CHARGE]:0;
            $user[self::$USER_PROF_FIELD_VIP] = $charge_lib->getVipLevel($user_id, $charge);
        }
		return $user;
	}

    public function loadProfs($role_id) {
		$user_model = $this->_di->getShared("user_model");
		$user = $user_model->getUser($role_id);
		if ($user == false) {
            syslog(LOG_ERR, "fail to get user $role_id from db");
			return false;
        }
        $profs = array(
            self::$USER_PROF_FIELD_ACCOUNT_ID=> $user['account_id'],
            self::$USER_PROF_FIELD_NAME=> $user['name'],
            self::$USER_PROF_FIELD_LEVEL=> $user['level'],
            self::$USER_PROF_FIELD_EXP=> $user['exp'],
            self::$USER_PROF_FIELD_COIN=> $user['coin'],
            self::$USER_PROF_FIELD_GOLD=> $user['gold'],
            self::$USER_PROF_FIELD_HONOR=> $user['honor'],
            self::$USER_PROF_FIELD_SNAKE => $user['snake'],
            self::$USER_PROF_FIELD_GCOIN => $user['gcoin'],
            self::$USER_PROF_FIELD_VIP=> $user['vip'],
            self::$USER_PROF_FIELD_SECTION=> $user['max_section'],
            self::$USER_PROF_FIELD_NEWBIE=> $user['newbie'],
            self::$USER_PROF_FIELD_CHARGE=> $user['charge'],
            self::$USER_PROF_FIELD_BIRTH_TIME=> strtotime($user['created_at']),
            //self::$USER_PROF_FIELD_FEE=> $user['fee']  // do not record in mysql, let it lost if reach here
        );
        $user_level_config = $this->getGameConfig('user_level');
        if (!$user_level_config) {
            syslog(LOG_ERR, "load prof($role_id) error:user_level_config not configured");
            return $profs;
        }
        $level_config = $user_level_config['level_config'];
        if (!isset($level_config[$user['level']])) {
            syslog(LOG_ERR, "level $user[level] not configured");
            return false;
        }
        $mission_energy_limit = $level_config[$user['level']]['mission_energy_limit'];
        $rob_energy_limit = $user_level_config['rob_energy_limit'];
        $profs[self::$USER_PROF_FIELD_ENERGY] = $mission_energy_limit; // set to max
        $profs[self::$USER_PROF_FIELD_ROB_ENERGY] = $rob_energy_limit; // set to max
        $rds = $this->_di->get('redis');
        $key = sprintf(self::$USER_PROF_KEY, $role_id);
        $rds->hmset($key, $profs);
        return $profs;
    }

    public static function getLevelConfigParam($level, $field) {
        $user_level_config = self::getGameConfig('user_level');
        if (!$user_level_config) {
            syslog(LOG_ERR, "get level config error:user_level_config not configured");
            return false;
        }
        $level_config = $user_level_config['level_config'];
        if (isset($level_config[$level]) && isset($level_config[$level][$field])) {
            return $level_config[$level][$field];
        } else {
            return false;
        }
    }

    private function msetProf($role_id, $updater, $rds=false) {
        if (!$rds) {
            $rds = $this->_di->get('redis');
        }
        $key = sprintf(self::$USER_PROF_KEY, $role_id);
        return $rds->hmset($key, $updater);
    }

    public function setProf($role_id, $field, $val, $rds=false) {
        if (!$rds) {
            $rds = $this->_di->get('redis');
        }
        $key = sprintf(self::$USER_PROF_KEY, $role_id);
        return $rds->hset($key, $field, $val);
    }

    public function incrProfBy($role_id, $field, $amount, $rds=false) {
        if (!$rds) {
            $rds = $this->_di->get('redis');
        }
        $key = sprintf(self::$USER_PROF_KEY, $role_id);
        return $rds->hincrBy($key, $field, $amount);
    }

    /*
     *  add expeience 
     *  return 
     *  [
     *      'level'=> 10,
     *      'exp'=> 570,
     *      'mission_energy'=> 10, // optional 
     *  ]
     */
    public function addExp($user_id, $amount) {
        syslog(LOG_DEBUG, "addExp($user_id, $amount)");
        $user_level_config = $this->getGameConfig('user_level');
        if (!$user_level_config) {
            syslog(LOG_ERR, "updateExp($user_id, $amount) error:user_level_config not configured");
            return false;
        }
        $user = $this->getUser($user_id);
        $current_level = $user['level'];
        $exp = $user['exp'] + $amount;
        $level_boundary = $user_level_config['level_exp_boundary'];
        $level_config = $user_level_config['level_config'];

        $new_level = $current_level;
        $max_level = count($level_boundary);
        $max_exp = $level_boundary[$max_level-1];
        # level1 [0,100)  level2 [100,200) ..., level9 [800,900), level10[900,900], 
        # level_boundary [0=>0, 1=>100, 2=>200,..., 9=>900]
        if ($exp >= $max_exp) {
            $exp = $max_exp;
            $new_level = $max_level;
        } else {
            // stop condition: $new_level==$max_level or $exp<$level_boundary[$new_level]
            while ($new_level < $max_level && $exp >= $level_boundary[$new_level]) {
                $new_level++;
            }
        }
        syslog(LOG_DEBUG, "new level $new_level for $user_id");

        $res = array('level'=> $new_level, 'exp'=> $exp);

        $resque_lib = $this->_di->getShared('resque_lib');
        if ($new_level != $current_level) {
            // level up
            if (intval($new_level) < intval($current_level)) {
                syslog(LOG_ERR, "unexpected condition, level $new_level less than old $current_level for $user_id");
                return false;
            }
            # new mission energy limit
            $current_mission_energy_limit = $level_config[$current_level]['mission_energy_limit'];
            $new_mission_energy_limit = $level_config[$new_level]['mission_energy_limit'];
            // do not set energy to db
            $this->incrProfBy($user_id, self::$USER_PROF_FIELD_EXP, $exp - $user['exp']);
            $this->setProf($user_id, self::$USER_PROF_FIELD_LEVEL, $new_level);
            # done: update db
            $resque_lib->setJob('user', 'profchange', array('uid'=> $user_id, 
                'level'=>$new_level-$current_level, 'exp'=>$exp - $user['exp']));
            // done: add mission energy to redis if exists
            $energy_bonus = ($new_level-$current_level) * 40;
            $res['mission_energy'] = $this->addMissionEnergy($user_id, $energy_bonus);
            /*
            $e_inc = $new_mission_energy_limit - $current_mission_energy_limit;
            if ($e_inc > 0) {
                //$energy = $this->incrProfBy($user_id, self::$USER_PROF_FIELD_ENERGY, $e_inc);
                $energy = $this->addMissionEnergy($user_id, $e_inc);
                syslog(LOG_DEBUG, "increase mission energy $e_inc to $user_id");
                $res['mission_energy'] = $energy;
                #$res['mission_energy_limit'] = $new_mission_energy_limit;
            }
             */
            // done: enque job to udpate fragment index
            $resque_lib->setJob('fragindex', 'FragmentIndex', array('cmd'=>'levelup', 'role_id'=> $user_id, 'old_level'=> $current_level, 'new_level'=> $new_level));
            //$resque_lib->setJob('user', 'levelup', array('uid'=> $user_id, 'old_level'=> $current_level, 'new_level'=> $new_level));
            if (isset($user[self::$USER_PROF_FIELD_LAST_LOGIN])) {
                $loginindex_lib = $this->_di->getShared('loginindex_lib');
                $loginindex_lib->levelUpEvent($user_id, $current_level, $new_level, $user[self::$USER_PROF_FIELD_LAST_LOGIN]);
            }
        } else if ($exp != $user['exp']) {
            // done: update new exp to db
            syslog(LOG_DEBUG, "$user_id add exp $amount level $current_level");
            $this->incrProfBy($user_id, self::$USER_PROF_FIELD_EXP, $exp - $user['exp']);
            # done: update db
            $resque_lib->setJob('user', 'profchange', array('uid'=> $user_id, 'exp'=> $exp-$user['exp']));
        }
        return $res;
    }

    /*
     * consume mission energy
     */
    public function consumeMissionEnergy($role_id, $amount) {
        $ret =  $this->consumeAutoRestoreEnergy($role_id, $amount, self::$ENERGY_TYPE_MISSION);
        if ($ret) {
            $guild_lib = $this->getDI()->getShared('guild_lib');
            $guild_lib->donate($role_id, GuildLib::$DONATE_TYPE_ENERGY, $amount);
        }
        return $ret;
    }

    public function addMissionEnergy($role_id, $amount) {
        return $this->consumeAutoRestoreEnergy($role_id, -$amount, self::$ENERGY_TYPE_MISSION);
    }

    public function consumeRobEnergy($role_id, $amount) {
        return $this->consumeAutoRestoreEnergy($role_id, $amount, self::$ENERGY_TYPE_ROB);
    }

    public function addRobEnergy($role_id, $amount) {
        return $this->consumeAutoRestoreEnergy($role_id, -$amount, self::$ENERGY_TYPE_ROB);
    }
    /*
     * consume wipe energy
     */
    public function consumeWipeEnergy($role_id, $amount) {
        $vip_cfg = $this->getGameConfig('user_vip');
        $user = $this->getUser($role_id);
        $vip_level = $user['vip'];
        $daily_wipe_energy = $vip_cfg[$vip_level]['wipe_energy'];

        $rds = $this->_di->getShared('redis');
        $wipe_count_key = sprintf(self::$WIPE_COUNT_KEY, $role_id);
        $count = $rds->incrBy($wipe_count_key, $amount);
        if ($count == $amount) {
            $rds->expireAt($wipe_count_key, self::getDefaultExpire());
        } else if ($count > $daily_wipe_energy) {
            $rds->incrBy($wipe_count_key, -$amount);
            return false;
        }
        
        return $daily_wipe_energy - intval($count);
    }

    /*
     * get wipe energy
     */
    public function getWipeCount($role_id) {
        $rds = $this->_di->getShared('redis');
        $wipe_count_key = sprintf(self::$WIPE_COUNT_KEY, $role_id);
        $count = $rds->get($wipe_count_key);
        return intval($count);
    }

    /*
     * add wipe energy
     */
    public function addWipeEnergy($role_id, $amount) {
        $this->consumeWipeEnergy($role_id, -$amount);
    }


    /*
     * find support users for the user
    */
    public function findSupportUsers($user_id, $num) {
        $user = $this->getUser($user_id);
        if (!$user) {
            return array();
        }
        $level = $user['level'];

        $user_level_config = $this->getGameConfig('user_level');
        $level_boundary = $user_level_config['level_exp_boundary'];
        $max_level = count($level_boundary);

        $start_level = $level - 3;
        if ($start_level <= 0) $start_level = 1;
        $end_level = $level + 3;
        if ($start_level > $max_level) $end_level = $max_level;


        # find friends
        $frnd_lib = $this->_di->getShared('frnd_lib');
        $frnd_uids = $frnd_lib->getRandFriends($user_id, 5);
        # find strangers
        $loginindex_lib = $this->_di->getShared('loginindex_lib');
        $users = $loginindex_lib->findUsers($start_level, $end_level, 5, gettimeofday()['usec']);
        $card_lib = $this->_di->getShared('card_lib');
        $mercenaries = array();
        $uids = array_merge($frnd_uids, array_keys($users));
        $uids = array_unique($uids);
        foreach ($uids as $uid) {
            if ($uid == $user_id) {
                continue;
            }
            $deck_cards = @$card_lib->getDeckCard($uid);
            if (!$deck_cards) {
                syslog(LOG_WARNING, "mision_prepare: deck cards not found for $uid");
                continue;
            }
            $leader_card = $deck_cards[USER_DECK_LEADER_POSITION - 1];
            $uinfo = $this->getUser($uid);
            $name = $uinfo['name'];
            $mercenaries []= array(
                'user_id'=> $uid,
                'name'=> $name,
                'card'=> $leader_card,
                'isfriend'=> in_array($uid, $frnd_uids)
            );
        }
        return $mercenaries;
    }

    /*
     * fire login event to update index
     */
    public function fireLoginEvent($role_id, $time, $level) {
        $rds = $this->_di->getShared('redis');
        $rds->hset(sprintf(self::$USER_PROF_KEY, $role_id), self::$USER_PROF_FIELD_LAST_LOGIN, $time);
        $loginindex_lib = $this->_di->getShared('loginindex_lib');
        $loginindex_lib->loginEvent($role_id, $time, $level);
    }

    /*
     * indicate wether user has some field change that client care about 
     */
    public function getNewFields($role_id) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$USER_NEWS_KEY, $role_id);
        $news = $rds->hgetall($key);
        $incoming_frnd_req = sprintf(\Cap\Libraries\FriendLib::$PENDING_IN_REQ_KEY, $role_id);
        if ($rds->exists($incoming_frnd_req)) {
            $news['friend_request'] = 1;
        }
        return array_keys($news);
    }
    public function clearNewField($role_id, $field) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$USER_NEWS_KEY, $role_id);
        $r = $rds->hdel($key, $field);
        syslog(LOG_DEBUG, "clearNewField($role_id, $field): $r");
        return $r;
    }
    public function setNewField($role_id, $field) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$USER_NEWS_KEY, $role_id);
        $r = $rds->hset($key, $field, 1);
        syslog(LOG_DEBUG, "setNewField($role_id, $field): $r");
        return $r;
    }

    /*
     * auto restore energy maintain
     * rst: timestamp to retore to limit
     * basic_energy: recorded energy, not considered auto restore part
     */
    function calcAutoRestoreEnergy($role_id, $user, $type) {
        $user_level_config = self::getGameConfig('user_level');
        if ($type == self::$ENERGY_TYPE_ROB) {
            $energy_limit = $user_level_config['rob_energy_limit'];
            $field_rst = self::$USER_PROF_FIELD_ROB_ENERGY_RST;
            $field = self::$USER_PROF_FIELD_ROB_ENERGY;
            $rate = self::$ROB_ENERGY_RESTORE_RATE;
        } else if ($type == self::$ENERGY_TYPE_MISSION) {
            $level_config = $user_level_config['level_config'];
            $energy_limit = $level_config[$user['level']]['mission_energy_limit'];
            $field_rst = self::$USER_PROF_FIELD_M_ENERGY_RST;
            $field = self::$USER_PROF_FIELD_ENERGY;
            $rate = self::$MISSION_ENERGY_RESTORE_RATE;
        } else {
            syslog(LOG_ERR, "calcAutoRestoreEnergy , unknown type $type");
            return 0;
        }
        $basic_energy = isset($user[$field])?$user[$field]:0;
        $rst = isset($user[$field_rst])?$user[$field_rst]:0;
        $now = time();
        
        if ($basic_energy > $energy_limit) {
            $energy = $basic_energy;
        } else if ($rst <= $now) {
            $energy = $energy_limit;
        } else {
            $energy = $energy_limit - ceil(($rst-$now)/$rate);
        }
        //syslog(LOG_DEBUG, "calcAutoRestoreEnergy $role_id - $type, basic:$basic_energy, real:$energy, rst:$rst, now:$now, limit:$energy_limit");
        return $energy;
    }

    function consumeAutoRestoreEnergy($role_id, $amount, $type) {
        $user = $this->getUser($role_id);
        $user_level_config = self::getGameConfig('user_level');
        if ($type == self::$ENERGY_TYPE_ROB) {
            $energy_limit = $user_level_config['rob_energy_limit'];
            $field_rst = self::$USER_PROF_FIELD_ROB_ENERGY_RST;
            $field = self::$USER_PROF_FIELD_ROB_ENERGY;
            $rate = self::$ROB_ENERGY_RESTORE_RATE;
        } else if ($type == self::$ENERGY_TYPE_MISSION) {
            $level_config = $user_level_config['level_config'];
            $energy_limit = $level_config[$user['level']]['mission_energy_limit'];
            $field_rst = self::$USER_PROF_FIELD_M_ENERGY_RST;
            $field = self::$USER_PROF_FIELD_ENERGY;
            $rate = self::$MISSION_ENERGY_RESTORE_RATE;
        } else {
            syslog(LOG_ERR, "calcAutoRestoreEnergy , unknown type $type");
            return 0;
        }
        $energy = isset($user[$field])?$user[$field]:0;
        $rst = isset($user[$field_rst])?$user[$field_rst]:0;
        $now = time();
        //syslog(LOG_DEBUG, "consumeAutoRestoreEnergy($role_id, $amount, $type), [$field] energy=$energy");

        if ($energy < $amount) {
            syslog(LOG_ERR, "energy $role_id - $type insufficient ($energy<$amount)");
            return false;
        }

        $energy -= $amount;
        if ($energy >= $energy_limit) {
            $rst = 0;
        } else {
            $rst = $now + ($energy_limit-$energy)*$rate;
        }
        $this->msetProf($role_id, array($field=>$energy, $field_rst=>$rst));

        syslog(LOG_DEBUG, "consumeAutoRestoreEnergy($role_id, $amount, $type), remain=$energy, rst:$rst");
        return $energy;
    }

    /*
     * update fields synchronized
     * param: updates: array(field=>$value)
     */ 
    public function updateFieldsSync($role_id, $updates) {
        $user_model = $this->_di->getShared('user_model');
        $user_model->updateFields($role_id, $updates);
        $user = $this->getUser($role_id); // ensure user info in redis
        $this->msetProf($role_id, $updates);
    }

    /*
     * incr field asynchronized
     */ 
    public function incrFieldAsync($role_id, $field, $delta_val) {
        $r = $this->incrProfBy($role_id, $field, $delta_val);
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('user', 'profchange', array('uid'=> $role_id, $field=>$delta_val));
        return $r;
    }

    /*
     * consume property asynchronly, roll back if lack amount
     */ 
    public function consumeFieldAsync($role_id, $field, $amount) {
        $currencies = array(
            self::$USER_PROF_FIELD_COIN,
            self::$USER_PROF_FIELD_GOLD,
            self::$USER_PROF_FIELD_HONOR,
            self::$USER_PROF_FIELD_SNAKE,
            self::$USER_PROF_FIELD_GCOIN,
        );
        syslog(LOG_DEBUG, "consumeFieldAsync($role_id, $field, $amount)");
        if (!in_array($field, $currencies)) {
            syslog(LOG_ERR, "consume property error: try consume non-currency $field");
            return false;
        }
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$USER_PROF_KEY, $role_id);
        $r = $rds->hincrBy($key, $field, -$amount);
        if ($r < 0) {
            $rr = $rds->hincrBy($key, $field, $amount);
            syslog(LOG_ERR, "consume property error: $field insufficient to cost $amount/$rr");
            return false;
        }
        $resque_lib = $this->_di->getShared('resque_lib');
        $resque_lib->setJob('user', 'profchange', array('uid'=> $role_id, $field=>-$amount));
        syslog(LOG_DEBUG, "consumeFieldAsync($role_id, $field, $amount) success, remain=$r");
        return $r;
    }

    /*
     * add mercenary fee to account balance
     */
    public function applyMercenaryFee($role_id) {
        syslog(LOG_DEBUG, "applyMercenaryFee($role_id)");
        $rds = $this->_di->getShared('redis');
        $user_key = sprintf(self::$USER_PROF_KEY, $role_id);
        $rds->multi();
        $rds->hget($user_key, self::$USER_PROF_FIELD_FEE);
        $rds->hset($user_key, self::$USER_PROF_FIELD_FEE, 0);
        $r = $rds->exec();
        $fee = $r[0];
        // add fee to account balance
        $coin = $this->incrFieldAsync($role_id, self::$USER_PROF_FIELD_COIN, $fee);
        return $coin;
    }

    /*
     * record one employ record, the fee is already deducted from balance before call
     */
    public function addMercenaryFee($employer, $employee, $fee) {
        $ts = time();
        syslog(LOG_DEBUG, "addMercenaryFee($employer, $employee, $fee)");
        $rds = $this->_di->getShared('redis');
        $employee_key = sprintf(self::$USER_PROF_KEY, $employee);
        $employer_rec_key = sprintf(self::$MERCENARY_RECORDS_KEY, $employer);
        $employee_rec_key = sprintf(self::$MERCENARY_RECORDS_KEY, $employee);

        $data_employ = json_encode(array(
            "employer" => $employer,
            "employee" => $employee,
            "time" => $ts,
            "fee" => $fee
        ));

        $rds->hincrBy($employee_key, self::$USER_PROF_FIELD_FEE, $fee);
        // record
        $rds->multi();
        $rds->lpush($employer_rec_key, $data_employ);
        $rds->lpush($employee_rec_key, $data_employ);
        $rds->expireAt($employer_rec_key, self::getDefaultExpire());
        $rds->expireAt($employee_rec_key, self::getDefaultExpire());
        $r = $rds->exec();
    }

    /*
     * get mercenary records
     */
    public function getMercenaryRecords($role_id) {
        $rec_key = sprintf(self::$MERCENARY_RECORDS_KEY, $role_id);
        $rds = $this->_di->getShared('redis');
        $records = $rds->lrange($rec_key, 0, -1);
        $name_cache = array();          // cache uid to name
        foreach ($records as &$rec) {
            $rec = json_decode($rec, true);
            if ($rec['employee'] == $role_id) {
                $target_id = $rec['employer'];
            } else if ($rec['employer'] == $role_id) {
                $target_id = $rec['employee'];
            } else {
                syslog(LOG_ERR, "unexpected mercenary data for $role_id of ".json_encode($rec));
                continue;
            }
            if (isset($name_cache[$target_id])) {
                $rec['name'] = $name_cache[$target_id];
            } else {
                $user = $this->getUser($target_id);
                $rec['name'] = $user[self::$USER_PROF_FIELD_NAME];
                $name_cache[$target_id] = $rec['name'];
            }
            $rec['fee'] = intval($rec['fee']);
        }
        return $records;
    }

    /*
     * set custom user data
     */
    public function setUserData($role_id, $field, $value) {
        if (!in_array($field, self::$ALLOWED_CUSTOM_FIELDS)) {
            return array('code'=>400, 'msg'=> 'not allowed field');
        }
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$USER_PROF_KEY, $role_id);
        $rds->hset($key, $field, $value);
        return array('code'=> 200);
    }

    /*
     * record user stastistics
     */
    public function incrStat($role_id, $field, $value=1) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$USER_STAT_KEY, $role_id);
        $rds->hincrBy($key, "$field", $value);
    }

    public function getStats($role_id) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$USER_STAT_KEY, $role_id);
        return $rds->hgetAll($key);
    }
}
