<?php

namespace Cap\Libraries;

class ArenaLib extends BaseLib {
    public static $cache_keys = array(
        "pvp_prof"=> "role:%d:prof",
        "pvp_opponents"=> "role:%d:opponents",
        "pvp_opportunties"=> "role:%d:%s:opportunties",
        "pvp_uncommited"=> "challenge:%d",
        "pvp_id_gen"=> "pvp_id",
        "pvp_arena_record"=> "chlng_rec:%s",
    );
    public static $challenge_expire = 100;
    public static $opponents_expire = 6;
    public static $opponents_rank = array();
    public static $FREE_OPPORTUNTIES = 15;
    public static $daily_challenge_time_max = "05:00";
    public static $redis_max_retries = 3;
    public static $achievement_awards_level = array(5000, 3000, 1000, 500, 100, 50, 10, 1);// desc
    public static $max_rank = 100000000;

    public static $ENERGY_COST_PER_CHALLENGE = 1;
    public static $HONOR_PER_WIN = 2;
    public static $HONOR_PER_LOSE = 1;

    public static $ROBOT_KEY = 'nami:arena:robot:%s';

    public function __construct() {
        parent::__construct();
        $this->_di->set("pvp_prof_model", function () {
            return new \Cap\Models\db\PvpProfModel();
        }, true);
        $this->_di->set("pvp_history_model", function () {
            return new \Cap\Models\db\ChallengeHistoryModel();
        }, true);
        $this->_di->set("rank_lib", function () {
            return new \Cap\Libraries\RankLib();
        }, true);
        $this->_di->set("resque_lib", function() {
            return new \Cap\Libraries\ResqueLib();
        }, true);

        $this->_di->set("battle_lib", function() {
            return new \Cap\Libraries\BattleLib();
        }, true);

        $this->_di->set("user_lib", function() {
            return new \Cap\Libraries\UserLib();
        }, true);

        $this->_di->set("card_lib", function() {
            return new \Cap\Libraries\CardLib();
        }, true);

        $this->_di->set("award_lib", function() {
            return new \Cap\Libraries\AwardLib();
        }, true);

        $this->_di->set("deck_lib", function() {
            return new \Cap\Libraries\DeckLib();
        }, true);
    }

    /*
     * update best rank if the rank is better than record
     * recorded best rank is needed
     */
    public function updateBestRank($role_id, $rank) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$cache_keys['pvp_prof'], $role_id);
        $retry = 0;
        while (True) {
            $rds->watch($key);
            $old_best_rank = intval($rds->hget($key, 'best_rank'));
            if ($rank >= $old_best_rank) {
                $rds->unwatch();
                syslog(LOG_DEBUG, "best rank not broken $role_id($old_best_rank->$rank)");
                return false;
            }
            $rds->multi();
            $rds->hset($key, 'best_rank', $rank);
            if ($rds->exec() != false) {
                syslog(LOG_INFO, "best rank updated $role_id($old_best_rank->$rank)");
                break;
            }
            if ($retry++ >= self::$redis_max_retries) {
                syslog(LOG_ERR, "update redis $key abort after tried $retry times");
                return false;
            }
        }

        // update mysql, post to queues
        $resque_lib = $this->_di->get('resque_lib');
        $resque_lib->setJob('arena', 'best_rank', array('role_id'=>$role_id, 'rank'=>$rank));
        
        return $this->checkAwardsActivation($role_id, $old_best_rank, $rank);
    }

    public function checkAwardsActivation($role_id, $old_best_rank, $best_rank) {
        // progress award
        $award_lib = $this->_di->getShared('award_lib');
        $awards = array();
        $ndiamond = 0;
        syslog(LOG_DEBUG, "checkAwardsActivation($role_id, $old_best_rank, $best_rank)");
        if ($old_best_rank) {
            /*
            if ($best_rank>=10000) {
                $ndiamond = ceil(($old_best_rank - $best_rank)/100);
            } else if ($best_rank>=5000) {
                $ndiamond = ceil(($old_best_rank - 10000)/100) + ceil((10000 - $best_rank)/50);
            } else {
                $ndiamond = ceil(($old_best_rank - 10000)/100) + 100 + ceil((5000 - $best_rank)/20);
            }
            */
            function getRankUnitAward($rank) {
                $val = 0.01;
                if ($rank > 5000) {
                    $val = 0.01;
                } else if ($rank > 2000) {
                    $val = 0.1;
                } else if ($rank > 500) {
                    $val = 0.2;
                } else if ($rank > 200) {
                    $val = 1;
                } else if ($rank > 50) {
                    $val = 2;
                } else if ($rank > 20) {
                    $val = 10;
                } else if ($rank > 10) {
                    $val = 30;
                } else if ($rank > 5) {
                    $val = 50;
                } else {
                    $val = 100;
                }
                return $val*5;
            }
            $ndiamond = 0;
            for ($k=$best_rank; $k<$old_best_rank; $k++) {
                $ndiamond += getRankUnitAward($k); 
            }
            $ndiamond = ceil($ndiamond);
            syslog(LOG_INFO, "got $ndiamond progross awards ($old_best_rank>$best_rank)");
            $user_lib = $this->_di->getShared('user_lib');
            $gold = $user_lib->incrFieldAsync($role_id, 'gold', $ndiamond);
            $awards['gold'] = $gold;
        } else {
            $old_best_rank = self::$max_rank; // for caculation achievement award
        }
        // achievement award
        $awards['new_award'] = array();
        $award_cfg = self::getGameConfig('rank_award');
        $type = \Cap\Libraries\AwardLib::$AWARD_CTGRY_PVP_RANK_PROGRESS;
        foreach ($award_cfg as $award_id=>$cfg) {
            if ($old_best_rank > $cfg['rank'] && $best_rank <= $cfg['rank']) {
                syslog(LOG_INFO, "active user $role_id award $award_id for reach rank $cfg[rank]");
                $user_award_id = $award_lib->activeAward($role_id, $type, $award_id);
                $awards['new_awards'] []= array('type'=> $type, 'id'=> $user_award_id, 'award_id'=>$award_id);
            }
        }
        return $awards;
    }

    /*
     * add new record, operation failed if already exists
     */
    public function addPlayer($role_id, $rank) {
        $pvp_model = $this->_di->getShared('pvp_prof_model');
        $result = $pvp_model->execute('create_new', array('role_id'=>$role_id, 
            'best_rank'=>$rank, 'init_rank'=>$rank));
        syslog(LOG_INFO, "pvp rank add ".($result->success()?"success":"fail")." $role_id with $rank ");
        if ($result->success()) {
            $rds = $this->_di->getShared('redis');
            $key = sprintf(self::$cache_keys['pvp_prof'], $role_id);
            $rds->hset($key, "best_rank", $rank);
            $rank_res = $this->checkAwardsActivation($role_id, false, $rank);
            return $rank_res;
        } else {
            return False;
        }
    }

    /*
     * get best rank record
     */
    public function getBestRank($role_id) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$cache_keys['pvp_prof'], $role_id);
        $data = $rds->hget($key, 'best_rank');
        if ($data) {
            return intval($data);
        }
        $pvp_model = $this->_di->getShared('pvp_prof_model');
        $record = $pvp_model->findBy('find_by_id', array('role_id'=>$role_id));
        if ($record->count() == 0) {
            syslog(LOG_ERR, "best rank for $role_id not found, try join...");
            $rank_lib = $this->_di->getShared('rank_lib');
            $rank = $rank_lib->add($role_id);
            if ($rank) {
                $this->addPlayer($role_id, $rank);
            } else {
                syslog(LOG_ERR, "fail to add $role_id to arena($rank)");
                return false;
            }
            return intval($rank);
        } else {
            $best_rank = $record[0]->best_rank;
            $rds->hset($key, 'best_rank', $best_rank);
            return intval($record[0]->best_rank);
        }
    }

    /*
     * find suitable opponents for user, using given rank if provided
     */
    public function findOpponents($role_id, $rank = false) {
        // get from cache
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$cache_keys['pvp_opponents'], $role_id);
        $cached_opponents = $rds->get($key);
        if ($cached_opponents) {
            syslog(LOG_DEBUG, "using cache for $role_id's oppoents");
            return json_decode($cached_opponents, true);
        }
        // provide robots for first 3 times
        $user_lib = $this->_di->getShared('user_lib');
        $stats = $user_lib->getStats($role_id);
        if (!isset($stats['challenge'])) {
            $seq = 0;
        } else {
            $seq = $stats['challenge'];
        }
        if ($seq < 5) {
            syslog(LOG_INFO, "findOpponents($role_id, $rank) seq=$seq, give robots");
            // give robots
            $seq++;
            $robots_key = "nami:arena:robot:$seq";
            $robot_ids = $rds->srandmember($robots_key, 5);
            $rank_lib = $this->_di->getShared("rank_lib");
            $card_lib = $this->_di->getShared('card_lib');
            $ranks = $rank_lib->queryRanks($robot_ids);
            
            // fill user info
            $rusers = array();
            $len = count($robot_ids);
            for($i=0; $i<$len; $i++) {
                $uid = $robot_ids[$i];
                $user = $user_lib->getUser($uid);
                if ($user) {
                    $deck_cards = @$card_lib->getDeckCardsOverview($uid);
                    $rusers []= array('uid'=> $uid, 'name'=>$user['name'], 
                        'level'=>$user['level'], 'rank'=>$ranks[$i], 'deck'=>$deck_cards);
                }
            }
            // set cache
            if (!empty($rusers)) {
                // sort by rank
                usort($rusers, function($a, $b){
                    if ($a['rank'] == $b['rank']) return 0;
                    return ($a['rank'] > $b['rank']) ? -1 : 1;
                });
                $js = json_encode($rusers);
                $rds->setex($key, self::$opponents_expire, $js);
                return $rusers;
            } else {
                syslog(LOG_INFO, "find empty robots for user ($role_id), continue with normal procedure");
                syslog(LOG_INFO, "robots_id is ".json_encode($robot_ids));
            }
        }
        // fetch from db
        if (!$rank) {
            $rank = $this->getRank($role_id);
            if (!$rank) {
                return array();
            }
        }
        // generate opponents rank
        if ($rank > 100) {
            $r = array($rank-1, 0.9*$rank, 0.89*$rank, 0.85*$rank, 0.84*$rank, 0.80*$rank);
            @syslog(LOG_DEBUG, "rankrange $r[0],$r[1],$r[2],$r[3],$r[4] for $rank");
            $rks = array();
            $rks[0] = mt_rand($r[1], $r[0]);
            $rks[1] = mt_rand($r[1], $r[0]);
            $rks[2] = mt_rand($r[1], $r[0]);
            $rks[3] = mt_rand($r[3], $r[2]);
            $rks[4] = mt_rand($r[5], $r[4]);
        } else {
            $r = $rank-1;
            $rks = array();
            while ($r>0 && count($rks)<5) {
                $rks []= $r;
                $r--;
            }
        }
        @syslog(LOG_DEBUG, "generate oppenent rank $rks[0],$rks[1],$rks[2],$rks[3],$rks[4] for $rank");
        for ($i=0;$i<count($rks);$i++) {
            if ($rks[$i] > $rank || $rks[$i]<=0 )
                unset($rks[$i]);
        } 
        if (count($rks) > 0) {
            $opponents = $this->getUserInfoByRanks($rks);
            // set cache
            if (!empty($opponents)) {
                // sort by rank
                usort($opponents, function($a, $b){
                    if ($a['rank'] == $b['rank']) return 0;
                    return ($a['rank'] > $b['rank']) ? -1 : 1;
                });
                $js = json_encode($opponents);
                $rds->setex($key, self::$opponents_expire, $js);
            }
            return $opponents;
        } else {
            syslog(LOG_WARNING, "no suitilable rank for $role_id($rank)");
            return array();
        }
    }

    /*
     * get available opportunties
     */
    public function getOpportunities($role_id) {
        $today = date("Y-m-d");
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$cache_keys['pvp_opportunties'], $role_id, $today);
        $opportunties = $rds->get($key);
        if ($opportunties === false) {
            return self::$FREE_OPPORTUNTIES;
        } else {
            return $opportunties;
        }
    }

    /*
     *  increase opportunties, user may pay for this
     */
    public function addOpportunties($role_id, $amount) {
        $today = date("Y-m-d");
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$cache_keys['pvp_opportunties'], $role_id, $today);
        $rds->watch($key);
        $retry = 0;
        while (True) {
            $opportunties = $rds->get($key);
            $rds->multi();
            if ($opportunties === false) {
                $opportunties = self::$FREE_OPPORTUNTIES + $amount;
                $rds->setex($key, strtotime("23:59:60")-time(), $opportunties);
            } else {
                $rds->incrBy($key, $amount);
            }
            if ($rds->exec() != false) {
                syslog(LOG_INFO, "add opportunity $amount for $role_id");
                break;
            }
            if ($retry++ >= self::$redis_max_retries) {
                syslog(LOG_ERR, "update redis $key abort after tried $retry times");
                break;
            }
        }
    }

    /*
     * consume an opportunity
     */
    public function useOpportunity($role_id, $amount) {
        $today = date("Y-m-d"); # date may change during request, but seems does not matter a lot
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$cache_keys['pvp_opportunties'], $role_id, $today);
        $left_times = false;
        $retry = 0;
        while (True) {
            $opportunties = $rds->get($key);
            $rds->multi();
            if ($opportunties === false && self::$FREE_OPPORTUNTIES>$amount) {
                // expire next morning
                $rds->setex($key, strtotime("23:59:60")-time(), self::$FREE_OPPORTUNTIES-$amount);
                $left_times =  self::$FREE_OPPORTUNTIES-$amount;
            } else if ($opportunties < $amount) {
                $rds->discard();
                $rds->unwatch();
                return false;
            } else {
                $rds->decrBy($key, $amount);
                $left_times = $opportunties - $amount;
            }

            if ($rds->exec() != false) {
                syslog(LOG_INFO, "used opportunity for $role_id");
                break;
            }
            if ($retry++ >= self::$redis_max_retries) {
                syslog(LOG_ERR, "update redis $key abort after tried $retry times");
                break;
            }
        }
        return $left_times;
    }

    /*
     * player A challenge player B
     */
    public function challenge($attacker, $defencer) {
        syslog(LOG_DEBUG, "$attacker challenge $defencer");
        if ($attacker == $defencer) {
            syslog(LOG_ERR, "$attacker challenge $defencer self");
            return array('code'=>400, 'desc'=>'cannot challenge self');
        }
        $rds = $this->_di->getShared('redis');
        // check time limit
        /**
        $tmax = strtotime(self::$daily_challenge_time_max);
        if ($tmax < time()) {
            syslog(LOG_WARNING, "($attacker vs $defencer) exceed challenge time");
            return array('code'=>403, 'desc'=> 'challenge currently is not allowed');
        }
         * **/
        // check attacker/defencer's rank
        $rank_lib = $this->_di->get('rank_lib');
        $ranks = $rank_lib->queryRanks(array($attacker, $defencer));
        if (!$ranks) {
            syslog(LOG_ERR, "challenge: fail to get ranks for $attacker,$defencer");
            return array('code'=>500, 'desc'=>'fail to get ranks');
        }
        list($arank, $drank) = $ranks;
        /* cancel restriction
        if ($arank<$drank || ($arank>100 && $drank<0.70*$arank)) {
            // limit allowable defencer's rank range
            syslog(LOG_WARNING, "challenger beyond range ($arank, $drank)");
            $res = array('code'=>604, 'desc'=>"opponent not suitable, ($arank vs $drank)");

            return $res;
        }
         */

        // check&use available opportunities
        $user_lib = $this->di->getShared('user_lib');
        $left_energy = $user_lib->consumeRobEnergy($attacker, self::$ENERGY_COST_PER_CHALLENGE);
        if ($left_energy === false) {
            return array('code'=> 603, 'desc'=> 'insufficient energy');
        }
        // set a record
        $chlng_rec_key = sprintf(self::$cache_keys['pvp_arena_record'], $attacker);
        $rec = $rds->incr($chlng_rec_key);
        if ($rec == 1) {
            $rds->expireAt($chlng_rec_key, self::getDefaultExpire());
        }

        // record rank times
        $user_lib->incrStat($attacker, 'challenge', 1);

        // set uncommited challenge
        $battle_lib = $this->_di->getShared('battle_lib');
        $battle_info = array("atk_r"=>$arank, "dfc_r"=>$drank);
        $deck_lib = $this->_di->getShared('deck_lib');
        $cards = $deck_lib->getDeckUserCardId($attacker);
        $battle_info['cards'] = json_encode($cards);        // get deck info from card lib
        //$battle_info['target_cards'] = json_encode(array()); 
        $challenge_id = $battle_lib->prepareBattle($attacker, $defencer, $battle_info, BattleLib::$BATTLE_TYPE_PVP_RANK, $rds);
        return array(
            'code'=> 200,
            'challenge_id'=> $challenge_id,
            'rob_energy'=> $left_energy,
        );
    }

    /*
     * commit challenge 
     */
    public function commitChallenge($challenge_id, $win, $battle_info) {
        $rds = $this->_di->getShared('redis');
        $battle_lib = $this->_di->getShared('battle_lib');
        $role_id = $this->session->get('role_id');
        $cinfo = $battle_lib->commitBattle($role_id, $challenge_id, BattleLib::$BATTLE_TYPE_PVP_RANK, $win, $battle_info);
        if (!$cinfo) {
            return array('code'=> 400, 'msg'=> 'invalid battle id');
        }
        $atk = intval($cinfo['role']);
        $dfs = intval($cinfo['target']);

        // gain honor
        $user_lib = $this->_di->getShared('user_lib');
        $honor = $user_lib->incrProfBy($atk, 'honor', $win?self::$HONOR_PER_WIN:self::$HONOR_PER_LOSE);
        if (!$win) {
            return array('code'=>200, 'desc'=>'record saved', 'honor'=> $honor);
        }

        //

        // adjust rank
        $rank_lib = $this->_di->get("rank_lib");
        $ranks = $rank_lib->queryRanks(array($atk, $dfs));
        if (!$ranks) {
            syslog(LOG_ERR, "rank for ($atk, $dfs) should not be empty");
            return array('code'=>500, 'desc'=> 'server error fail to get rank info');
        }
        list($arank, $drank) = $ranks;
        if ($arank < $drank) {
            syslog(LOG_ERR, "user $atk($arank) should can not challenge $dfs($drank)");
        }
        $new_rank = $rank_lib->preempt($atk, $dfs);
        syslog(LOG_DEBUG, "user $atk($arank) beat $dfs($drank), got new rank $new_rank");
        // check best rank change
        $rank_res = $this->updateBestRank($atk, $new_rank);

        // allow refresh 
        $opponents_key = sprintf(self::$cache_keys['pvp_opponents'], $role_id);
        $rds->del($opponents_key);

        $res = array('code'=> 200, 'rank'=> $new_rank, 'honor'=> $honor);
        if ($rank_res) {
            $res = array_merge($res, $rank_res);
        }
        // add exp to user and members
        $cost_energy = self::$ENERGY_COST_PER_CHALLENGE;
        $pvp_cfg = self::getGameConfig('pvp_config');
        $user_exp_inc = $pvp_cfg['pvp_user_exp_per_energy'] * $cost_energy;
        $card_exp_inc = $pvp_cfg['pvp_card_exp_per_energy'] * $cost_energy;
        $user_exp_inc_res = $user_lib->addExp($atk, $user_exp_inc);
        $card_lib = $this->_di->getShared('card_lib');
        $cards = json_decode($cinfo['cards'], true);
        if (!empty($cards)) {
            $card_exp_inc_res = $card_lib->addExpForCards($atk, $cards, $card_exp_inc);
            $res['card_exp'] = $card_exp_inc_res;
        }
        $res['user_exp'] = $user_exp_inc_res;

        return $res;
    }

    /*
     * get challenge history
     */
    public function getPvpHistory($role_id) {
        $pvp_history_model = $this->_di->get('pvp_history_model');
        $battles = array();
        $attacks = \Cap\Models\db\ChallengeHistoryModel::find(array(
            "attacker=?1",
            "bind"=> array(1=>$role_id),
        ));
        foreach ($attacks as $btl) {
            $battles []=  array('a'=>$btl->attacker, 'd'=>$btl->defencer, 
                'r'=>$btl->result, 't'=>$btl->created_at, 'i'=>$btl->battle_info);
        }
        $defences = \Cap\Models\db\ChallengeHistoryModel::find(array(
            "defencer=?1",
            "bind"=> array(1=>$role_id),
        ));
        foreach ($defences as $btl) {
            $battles []=  array('a'=>$btl->attacker, 'd'=>$btl->defencer, 
                'r'=>$btl->result, 't'=>$btl->created_at, 'i'=>$btl->battle_info);
        }
        return $battles;
    }

    /*
     * get user info by ranks
     */
    public function getUserInfoByRanks($rks) {

        $rank_lib = $this->_di->getShared("rank_lib");
        $uids = $rank_lib->queryUsers($rks);
        $user_rank = array();
        $len = count($rks);
        $rks = array_values($rks);
        for ($i=0;$i<count($rks);$i++) {
            if ($uids[$i] == -1) {
                syslog(LOG_WARNING, "ranks ".$rks[$i]." with no user");
                break;
            }
            $user_rank[$uids[$i]] = $rks[$i];
        }

        $users = array();
        $card_lib = $this->_di->getShared('card_lib');
        $user_lib = $this->_di->getShared('user_lib');
        foreach ($user_rank as $uid=>$rank) {
            // get other info: name, level, deck_card_id(type)
            $deck_cards = @$card_lib->getDeckCardsOverview($uid);

            $user = $user_lib->getUser($uid);
            if ($user) {
                $users []= array('uid'=> $uid, 'name'=>$user['name'], 
                    'level'=>$user['level'], 'rank'=>$rank, 'deck'=>$deck_cards);
            }
        }
        return $users;
    }

    /*
     * get top players info
     */
    public function getTopUsers($num) {
        if ($num <= 0) {
            return array();
        }
        $ranks = array();
        for ($i=1;$i<=$num;$i++) {
            $ranks []=$i;
        }
        $users = $this->getUserInfoByRanks($ranks);
        return $users;
    }

    /*
     * query rank of user, if not exists join in
     */
    public function getRank($uid) {
        $rank_lib = $this->_di->getShared("rank_lib");
        $rank = $rank_lib->queryRank($uid);
        if (!$rank) {
            // join
            syslog(LOG_DEBUG, "fail to get rank for $uid, try join");
            $rank = $rank_lib->add($uid);
            if ($rank) {
                $this->addPlayer($uid, $rank);
            } else {
                syslog(LOG_ERR, "fail to add $uid to arena($rank)");
            }
            syslog(LOG_INFO, "add $uid to arena with rank $rank");
        }
        return $rank;
    }

    /*
     * get pvp history
     */
    public function getHistory($role_id) {
        $battle_lib = $this->_di->getShared('battle_lib');
        $records = $battle_lib->getHistory(BattleLib::$BATTLE_TYPE_PVP_RANK, $role_id);
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

// end of file
