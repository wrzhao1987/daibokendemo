<?php

namespace Cap\Libraries;

require 'FragmentIndexLib.php';

class RobLib extends BaseLib {

    public static $cache_keys = array(
        'rob_energy'=> 'role:%s:nrob',  // daily left opportunities to perform rob 
        'rob_id_gen'=> 'rob_id_gen',    // robbery id generator
        'rob_id'=> 'rob:%s',            // uncommited rob
        'robbed_record'=> 'role:%s:be_rob', // protection user from too many robbery
        'rob_record'=> 'role:%s:robs',  // daily robery record {uid:times,...}
        'rob_exempt'=> 'role:%s:rob_exempt',  // rob protection
    );

    public static $FRAGMENTS_PER_BALL = 6;
    public static $FREE_ROB_ENERGY = 100;
    public static $DAILY_BE_ROB_LIMIT = 100;
    public static $DAILY_ROB_TO_SINGLE_LIMIT = 50;
    public static $DROP_ITEM_PROBABILITY = 0.8;
    public static $ENERGY_COST_PER_ROB = 1;
    public static $MIN_ROBBERY_LEVEL = 1;

    public function __construct() {
        parent::__construct();
        $config = $this->config;

        $this->_di->set('fragment_index', function () {
            return new \FragmentIndexLib();
        }, true);

        $this->_di->set('fragment_model', function () {
            return new \Cap\Models\db\FragmentModel();
        }, true);

        $this->_di->set('resque_lib', function () {
            return new \Cap\Libraries\ResqueLib();
        }, true);
        $this->_di->set('battle_lib', function () {
            return new \Cap\Libraries\BattleLib();
        }, true);
        $this->_di->set('card_lib', function () {
            return new \Cap\Libraries\CardLib();
        }, true);
        $this->_di->set('deck_lib', function () {
            return new \Cap\Libraries\CardLib();
        }, true);
        $this->_di->set('user_lib', function () {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('drgbl_lib', function () {
            return new \Cap\Libraries\DragonBallLib();
        }, true);

    }


    /*
     * get rob energy, return daily initial free energy if not exists 
     */
    public function getRobEnergy($role_id) {
        $rds = $this->_di->get('redis');
        $key = sprintf(self::$cache_keys['rob_energy'], $role_id);
        $energy = $rds->get($key);
        if ($energy === false) {
            // do not set until real usage
            $energy = self::$FREE_ROB_ENERGY;
        }
        return $energy;
    }

    /*
     * add rob energy
     */
    public function addRobEnergy($role_id, $amount) {
        $rds = $this->_di->get('redis');
        $key = sprintf(self::$cache_keys['rob_energy'], $role_id);
        $energy = $rds->get($key);
        // do not watch it for rare probability of write conflit 
        if ($energy === false) {
            $rds->setex($key, strtotime("23:59:60")-time(), $amount + self::$FREE_ROB_ENERGY);
            $energy = $amount + self::$FREE_ROB_ENERGY;
        } else {
            $energy = $rds->incrBy($key, $amount);
        }
        return $energy;
    }

    /*
     * consume rob energy, return remaining energy
     */
    public function useRobEnergy($role_id, $amount) {
        $rds = $this->_di->get('redis');
        $key = sprintf(self::$cache_keys['rob_energy'], $role_id);
        $energy = $rds->get($key);
        if ($energy === false && $amount <= self::$FREE_ROB_ENERGY) {
            $rds->setex($key, strtotime("23:59:60")-time(), self::$FREE_ROB_ENERGY - $amount);
            $energy = self::$FREE_ROB_ENERGY - $amount;
        } else if ($energy < $amount) {
            syslog(LOG_INFO, "not enough energy($energy) to consume($amount) for $role_id");
            return false;
        } else {
            $energy = $rds->decrBy($key, $amount);
        }
        return $energy;
    }

    /*
     * search for opponents who has the item
     */
    public function getOpponents($role_id, $item, $num) {
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $mylevel = $user['level']; # done get real level
        $fragment_index = $this->_di->getShared('fragment_index');
        $fragment_no = $item['sub_id'];
        if ($fragment_no<0 || $fragment_no>83) {
            syslog(LOG_WARNING, "invalid fragment $fragment_no for $role_id search");
            return array('code'=>200, 'msg'=>'invalid target item');
        }
        $low_level = $mylevel - 5;
        if($low_level<10) 
            $low_level = 10;
        $high_level = $mylevel + 5;
        // expand fragment to sibling fragments
        $radix = self::$FRAGMENTS_PER_BALL;
        $dragonball_no = intval($fragment_no/$radix);
        $fragments = array($radix*$dragonball_no);
        for ($i=1;$i<$radix;$i++) {
            $fragments []= $fragments[0]+$i;
        }

        $users = $fragment_index->findOpponents($low_level, $high_level, $fragments, $num);
        if (count($users)<$num) {
            $low_level = $mylevel - 10;
            if($low_level<10) 
                $low_level = 10;
            $high_level = $mylevel + 10;
            $users = $fragment_index->findOpponents($low_level, $high_level, $fragments, $num);
        }
        # filter self
        unset($users[$role_id]);
        
        $card_lib = $this->_di->getShared('card_lib');
        $opponents = array();
        foreach ($users as $uid=>$level_frags) {
            $opponent = $user_lib->getUser($uid);
            $deck_cards = $card_lib->getDeckCardsOverview($uid);
            foreach ($level_frags as $level_frag) {
                list($level, $fragno) = explode(':', $level_frag);
                $opponents [] = array(
                    'user_id'=> $uid,
                    'name'=> $opponent['name'],
                    'item_val'=> $fragno,
                    'level'=> $level,
                    'chance'=> max(0.75+($level-$mylevel)*0.05, 0.25),
                    'deck'=> $deck_cards, # done get opponent defence position/deck
                );
            }
        }

        if (count($opponents)<1) {
            #: add robots charactor -- obsoleted
        }
        return $opponents;
    }

    /*
     * set rob exempt (role, duration)
     * return 0/false if already set, otherwise return 1
     */
    public function setRobExempt($role_id, $ttl) {
        $rds = $this->_di->getShared('redis');
        $rob_exempt_key = sprintf(self::$cache_keys['rob_exempt'], $role_id);
        $r = $rds->setnx($rob_exempt_key, 1);
        if ($r) {
            $rds->expire($rob_exempt_key, $ttl);
        }
        syslog(LOG_DEBUG, "setRobExempt($role_id, $ttl) -- $r");
        return $r;
    }

    public function cancelRobExempt($role_id)
    {
        $rds = $this->_di->getShared('redis');
        $rob_exempt_key = sprintf(self::$cache_keys['rob_exempt'], $role_id);
        $rds->del($rob_exempt_key);

        return true;
    }

    /*
     * get rob exempt status/till_time
     * return 0/false if not in rob_exempt state, otherwise return left time(seconds) in rob_exempt state
     */
    public function getRobExempt($role_id) {
        $rds = $this->_di->getShared('redis');
        $rob_exempt_key = sprintf(self::$cache_keys['rob_exempt'], $role_id);
        $r = $rds->ttl($rob_exempt_key);
        if ($r == -1 || $r == -2) # -2 means not exist in version 2.8+
            return false;
        return $r;
    }

    /*
     * attack opponents
     */
    public function attack($role_id, $target, $item) {
        syslog(LOG_DEBUG, "$role_id attack $target for $item[item_id]:$item[sub_id]");
        if ($role_id == $target) {
            return array('code'=>400, 'msg'=>'cannot rob self');
        }
        $rds = $this->_di->get('redis');

        // validate user
        # rob exempt check
        # item check level check, rob_limit_single check, rob_limit check
        # skip check of target has that item
        $rob_exempt_key = sprintf(self::$cache_keys['rob_exempt'], $role_id);
        if ($rds->exists($rob_exempt_key)) {
            syslog(LOG_INFO, "suspend a robbery from $role_id to $target due to rob protection");
            return array('code'=> 606, 'msg'=> 'you are in protection mode');
        }
        $rob_exempt_key = sprintf(self::$cache_keys['rob_exempt'], $target);
        if ($rds->exists($rob_exempt_key)) {
            syslog(LOG_INFO, "$target avoid a robbery from $role_id due to rob protection");
            return array('code'=> 605, 'msg'=> 'target in protection mode');
        }
        # done get real level 
        $user_lib = $this->_di->getShared('user_lib');
        $a_user = $user_lib->getUser($role_id);
        $d_user = $user_lib->getUser($target);
        $a_lvl = $a_user['level'];
        $d_lvl = $d_user['level'];
        $guard_lvl = self::$MIN_ROBBERY_LEVEL;
        if ($a_lvl < $guard_lvl || $d_lvl < $guard_lvl || abs($a_lvl-$d_lvl) > 10) {
            syslog(LOG_WARNING, "robbery level violation $role_id($a_lvl) vs $target($d_lvl)");
            return array('code'=> 603, 'msg'=> 'robbery level violation');
        }
        $drop_chance = 0.75 + ($d_lvl-$a_lvl)*0.05;
		if ($drop_chance < 0.25) {
			$drop_chance = 0.25;
		}
        // do not incr record until robbery commit, this may cause rob limit violation

        $key_rob_record = sprintf(self::$cache_keys['rob_record'], $role_id);
        $rob_record = $rds->hincrBy($key_rob_record, $target, 1);
        if ($rob_record == 1) {
            $rds->expire($key_rob_record, strtotime("23:59:60")-time());
        }
        if ($rob_record > self::$DAILY_ROB_TO_SINGLE_LIMIT) {
            syslog(LOG_INFO, "$role_id rob of $target exceeds limit");
            // restore record
            $rds->hincrBy($key_rob_record, $target, -1);
            return array('code'=>603, 'msg'=> 'you can not rob it any more today');
        }

        $key_rob_protect = sprintf(self::$cache_keys['robbed_record'], $target);
        $berob_times = $rds->incr($key_rob_protect);
        if ($berob_times == 1) {
            $rds->expire($key_rob_protect, strtotime("23:59:60")-time());
        }
        if ($berob_times > self::$DAILY_BE_ROB_LIMIT) {
            syslog(LOG_INFO, "$target suffered enough robs today");
            // restore record
            $rds->decr($key_rob_protect);
            $rds->hincrBy($key_rob_record, $target, -1);
            return array('code'=>603, 'msg'=> 'target luckily rescued by adminstrator');
        }

        $rob_energy = $user_lib->consumeRobEnergy($role_id, 1);
        if ($rob_energy === false) {
            $rds->decr($key_rob_protect);
            $rds->hincrBy($key_rob_record, $target, -1);
            return array('code'=> 604, 'msg'=> 'not enough energy to rob');
        }
        // add honor value by 1
        $honor = $user_lib->incrProfBy($role_id, 'honor', 1);
        $res['honor'] = $honor;

        // get cards
        $cards = array();
        // done: user real cards
        $card_lib = $this->_di->getShared('card_lib');
        $deck_info = $card_lib->getDeckCard($role_id, DECK_TYPE_PVP);
        foreach ($deck_info as $info) {
            if (!empty($info['user_card_id'])) {
                $cards []= $info['user_card_id'];
            }
        }
        
        // set uncommited robbery
        $battle_lib = $this->_di->getShared('battle_lib');
        $battle_info = array('item_id'=>$item['item_id'], 'chance'=>$drop_chance,
            'sub_id'=>$item['sub_id'], 'cards'=>json_encode($cards));
        $rob_id = $battle_lib->prepareBattle($role_id, $target, $battle_info, BattleLib::$BATTLE_TYPE_PVP_ROB, $rds);

        $res = array(
            'code'=> 200,
            'rob_id'=> $rob_id,
            'rob_energy'=> $rob_energy,
        );

        return $res;
    }

    /*
     * commit attack result
     */
    public function commitAttack($role_id, $rob_id, $result, $info) {
        syslog(LOG_DEBUG, "commit robbery $rob_id:$result");
        $battle_lib = $this->_di->getShared('battle_lib');
        $rob_info = $battle_lib->commitBattle($role_id, $rob_id, BattleLib::$BATTLE_TYPE_PVP_ROB, $result, $info);
        if (!$rob_info) {
            syslog(LOG_INFO, "commited rob_id($rob_id) not found");
            return array('code'=> 404, 'msg'=> 'invalid robbery');
        }

        $atkr = $role_id;
        $dfcr = $rob_info['target'];
        $item_type = $rob_info['item_id'];
        $item_val = $rob_info['sub_id'];
        $drop_probability = floatval($rob_info['chance']);

        $res = array('code'=> 200, 'fragment_id' => $item_val);
        if ($result == 0) {
            // lose, nothing to do
            return $res;
        }
        // add experience to cards
        $cost_energy = self::$ENERGY_COST_PER_ROB;
        $pvp_cfg = self::getGameConfig('pvp_config');
        $user_exp_inc = $pvp_cfg['pvp_user_exp_per_energy'] * $cost_energy;
        $card_exp_inc = $pvp_cfg['pvp_card_exp_per_energy'] * $cost_energy;

        $cards = json_decode($rob_info['cards']);
        $card_lib = $this->_di->getShared('card_lib');
        if (!empty($cards)) {
            $card_exp_inc_res = $card_lib->addExpForCards($role_id, $cards, $card_exp_inc);
            $res['cards'] = $card_exp_inc_res;
        }
        $user_lib = $this->_di->getShared('user_lib');
        $user_exp_inc_res = $user_lib->addExp($role_id, $user_exp_inc);
        $res['user_exp'] = $user_exp_inc_res;
        $p = mt_rand(0,100)/100;
        syslog(LOG_DEBUG, "$atkr rob $item_type:$item_val of $dfcr drop probability $drop_probability ($p)");
        if ($p < $drop_probability) {
            $drgbl_lib = $this->_di->getShared('drgbl_lib');
            $r1 = $drgbl_lib->decFragment($dfcr, $item_val, 1);
            if ($r1===false) {
                syslog(LOG_INFO, "fail to rob $item_type:$item_val from $dfcr, seems already lost");
                $res['code'] = 601;
                $res['msg'] = 'fail to execute the item drop, its gone';
                return $res;
            }
            $r2 = $drgbl_lib->addFragment($atkr, $item_val, 1);
            # TODO 1. enqueue event to update fragment index --done; 2. update redis -cache?
            // rob the item
            /*
            $frag_model = $this->_di->getShared('fragment_model');
            # bypass phsql, because I can't find a way to find out affected rows
            $rs1 = $frag_model->decrFrag($dfcr, $item_val, 1);
            if ($rs1 === false) {
                syslog(LOG_ERR, "fail to rob decrease $item_type:$item_val from $dfcr");
                return array('code'=>500, 'msg'=>'fail to execute the item drop');
            } else if ($rs1 == 0) {
                # check if defencer really has the item
                syslog(LOG_INFO, "fail to rob $item_type:$item_val from $dfcr, seems already lost");
                $res['code'] = 601;
                $res['msg'] = 'fail to execute the item drop, its gone';
                return $res;
            }
            $resque_lib = $this->_di->getShared('resque_lib');
            $resque_lib->setJob('fragindex', 'FragmentIndex', array('cmd'=>'fragchange', 'role_id'=> $dfcr, 'fragno'=>$item_val, 'present'=>0));
            
            $rs2 = $frag_model->addFrag($atkr, $item_val, 1);
            if ($rs2===false) {
                syslog(LOG_ERR, "fail to add $item_type:$item_val to $atkr");
                // now the item is lost in world
                return array('code'=>500, 'msg'=>'fail to execute the item pickup');
            }
            $resque_lib->setJob('fragindex', 'FragmentIndex', array('cmd'=>'fragchange', 'role_id'=> $atkr, 'fragno'=>$item_val, 'present'=>1));
             */
            // record item gain for battle
            # TODO: give gain to user -- not applicable?
            $gain = array(array('item_id'=>$item_type, 'sub_id'=>$item_val));
            $battle_lib->battleGain($rob_id, BattleLib::$BATTLE_TYPE_PVP_ROB, $gain);

            syslog(LOG_INFO, "$atkr success to rob $item_type:$item_val of $dfcr");
            $item_lib = $this->_di->getShared('item_lib');
            $coin = 1000; // config
            $rc = $item_lib->addItem($atkr, ITEM_TYPE_SONY, 0, $coin);
            $award = array('coin'=>$coin, 'item'=>array('item_id'=>ITEM_TYPE_DRAGON_BALL_FRAGMENT, 'sub_id'=>$item_val, 'count'=>1));
            $res['award'] = $award;
        } else {
            syslog(LOG_INFO, "unfortunately fail to get item $item_type:$item_val from $dfcr");
        }
        return $res;
    }

    public function getTodayRobCount($role_id)
    {
        $key_rob_record = sprintf(self::$cache_keys['rob_record'], $role_id);
        $record = $this->redis->hGetAll($key_rob_record);
        return $record ? array_sum($record) : 0;
    }

    public function getHistory($role_id) {
        $battle_lib = $this->_di->getShared('battle_lib');
        $records = $battle_lib->getHistory(BattleLib::$BATTLE_TYPE_PVP_ROB, $role_id);
        $uids = array();
        foreach ($records as $rec) {
            $uids[$rec['attacker']] = 1;
            $uids[$rec['target']] = 1;
        }
        // get user info
        $user_lib = $this->_di->getShared('user_lib');
        $card_lib = $this->_di->getShared('card_lib');
        foreach ($uids as $uid=>$_) {
            $user = $user_lib->getUser($uid);
            if ($user) {
                $deck_info = $card_lib->getDeckCardsOverview($uid);
                $users[strval($uid)] = array(
                    'name'=> $user['name'],
                    'level'=> $user['level'],
                    'deck'=> $deck_info
                );
            } else {
                $users[strval($uid)] = false;
            }
        }
        // fill user info
        foreach ($records as &$rec) {
            if ($role_id == $rec['attacker']) {
                $rec['opponent'] = $users[$rec['target']];
            } else {
                $rec['opponent'] = $users[$rec['attacker']];
            }
        }
        return $records;
    }
}

