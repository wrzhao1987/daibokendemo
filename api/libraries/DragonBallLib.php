<?php

namespace Cap\Libraries;

use Phalcon\Exception;

class DragonBallLib extends BaseLib {

	public static $FRAGMENTS_PER_BALL = 6;
    public static $BASIC_EXP = 10;
    public static $CACHE_KEY_BALLS = 'nami:balls:%s';
    public static $CACHE_KEY_FRAGMENTS = 'nami:ballfrags:%s';

	public function __construct() {
		parent::__construct();

		$this->_di->set('dragonball_model', function () {
			return new \Cap\Models\db\UserDragonBallModel();
		}, true);
		$this->_di->set('resque_lib', function () {
			return new \Cap\Libraries\ResqueLib();
		}, true);

	}

	/*
	 * add amount of fragment_no to user, amount should greater than 0
	 */
	public function addFragment($user_id, $frag_no, $amount=1) {
		if ($amount <= 0) {
			return 0;
		}
        $resque_lib = $this->_di->getShared('resque_lib');
        $cache_key = sprintf(self::$CACHE_KEY_FRAGMENTS, $user_id);
        $remain = $this->redis->hIncrBy($cache_key, $frag_no, $amount);
        // 从无到有，要更新龙珠碎片索引
        if ($remain == $amount) {
            $t1 = microtime(true);
            $resque_lib->setJob('fragindex', 'FragmentIndex', array('cmd'=>'fragchange', 'role_id'=> $user_id, 'fragno'=>$frag_no, 'present'=>1));
            $t2 = microtime(true);
            syslog(LOG_DEBUG, "addFrag queueoperation cost ".($t2-$t1)."s");
        }
        return $remain;
	}

	/*
	 * decrease amount of fragment_no from user if exists
	 */
	public function decFragment($user_id, $frag_no, $amount) {
		if ($amount <= 0) {
			return false;
		}
        $cache_key = sprintf(self::$CACHE_KEY_FRAGMENTS, $user_id);
        $remain = $this->redis->hIncrBy($cache_key, $frag_no, - $amount);
        if (intval($remain) >= 0) {
            $resque_lib = $this->_di->getShared('resque_lib');
            if (0 == intval($remain)) {
                // done: enque event to update fragment index
                $resque_lib->setJob('fragindex', 'FragmentIndex', array('cmd'=>'fragchange', 'role_id'=> $user_id, 'fragno'=>$frag_no, 'present'=>0));
            }
        } else {
            $this->redis->hIncrBy($cache_key, $frag_no, $amount);
            return false;
        }
        return $remain;
	}

	/*
	 * get user's fragments
	 */
	public function getFragments($user_id, $for_display = false) {
        $ret = [];
        $cache_key = sprintf(self::$CACHE_KEY_FRAGMENTS, $user_id);
        $pieces = $this->redis->hGetAll($cache_key);
        if ($pieces) {
            if ($for_display) {
                foreach ($pieces as $dball_id => $count) {
                    $arr = ['dball_id' => $dball_id, 'count' => $count];
                    array_push($ret, $arr);
                }
            } else {
                $ret = $pieces;
            }
        }
        return $ret;
    }

	/*
	 * dragonball_no value [1~14]
	 * dragonball_fragment_no values [0~83]
	 */
	public function synthesize($user_id, $dragonball_no) {

		$frag_no = self::$FRAGMENTS_PER_BALL*($dragonball_no-1);
		$frag_nos = [];
		for ($i=0;$i<self::$FRAGMENTS_PER_BALL;$i++) {
			$frag_nos []= $frag_no+$i;
		}
        $frags = $this->getFragments($user_id);
        $avlb = true;
        foreach ($frag_nos as $no) {
            if (! isset ($frags[$no]) || $frags[$no] <= 0) {
                $avlb = false;
                break;
            } else {
                $frags[$no]--;
            }
        }

        if ($avlb) {
            $cache_key = sprintf(self::$CACHE_KEY_FRAGMENTS, $user_id);
            $this->redis->hMSet($cache_key, $frags);
            $resque_lib = $this->_di->getShared('resque_lib');
            // done: enque event to update fragment index
            $resque_lib->setJob('fragindex', 'FragmentIndex', array('cmd'=>'fragchange', 'role_id'=> $user_id, 'fragno'=>$frag_nos, 'present'=>0));
            // add a dragonball
            $info = $this->newDragonball($user_id, $dragonball_no);
            if (!$info) {
                syslog(LOG_ERR, "fail to add dragonball($user_id, $dragonball_no), restore fragments?");
            }
            return $info;
        } else {
            syslog(LOG_ERR, "synthesize($user_id, $dragonball_no), frags not complete");
            return false;
        }
	}

	/*
	 * add a new dragonball to user
	 */
	public function newDragonball($user_id, $dragonball_no)
    {
		$dragonball_model = $this->_di->getShared('dragonball_model');
		$id = $dragonball_model->addDragonball($user_id, $dragonball_no);
		if (!$id) {
			syslog(LOG_WARNING, "fail to add dragonball($user_id, $dragonball_no)");
			return false;
		}
        $cache_key = sprintf(self::$CACHE_KEY_BALLS, $user_id);
        $new_ball_info = [
            'id'             => $id,
            'dragon_ball_id' => $dragonball_no,
            'level'          => 1,
            'exp'            => 0,
        ];
        $this->redis->hSetNx($cache_key, $id, json_encode($new_ball_info));
		$info = array('id'=>$id, 'dragonball_id'=>$dragonball_no, 'level'=>1, 'exp'=>0);
		return $info;
	}

    public function getByUser($user_id, $id_list = null)
    {
        $ret = [];
        $cache_key = sprintf(self::$CACHE_KEY_BALLS, $user_id);
        if (null === $id_list) {
            $tmp = $this->redis->hGetAll($cache_key);
        } else if (is_array($id_list) && count($id_list) > 0) {
            $tmp = $this->redis->hMGet($cache_key, $id_list);
        }
        if (! empty ($tmp) && (false === array_search(false, $tmp)) ) {
            foreach ($tmp as $id => $equip_info) {
                $ret[$id] = json_decode($equip_info, true);
            }
        } else {
            $drgbl_model = $this->_di->getShared('dragonball_model');
            if ($tmp = $drgbl_model->getUserDragonBalls($user_id)) {
                $cache_content = [];
                foreach ($tmp as $id => $equip_info) {
                    $cache_content[$id] = json_encode($equip_info);
                }
                $this->redis->hMSet($cache_key, $cache_content);
                if (empty ($id_list)) {
                    $ret = array_combine(array_column($tmp, 'id'), $tmp);
                } else {
                    foreach ($id_list as $id) {
                        $ret[$id] = $tmp[$id];
                    }
                }
            }
        }
        if (! empty ($ret)){
            if (null === $id_list) {
                $dragon_ball_ids = array_column($ret, 'dragon_ball_id', 'id');
                $level           = array_column($ret, 'level', 'id');
                array_multisort($dragon_ball_ids, SORT_DESC, $level, SORT_DESC, $ret);
                return array_values($ret);
            }
        }
        return $ret;
    }

    private function getBall($user_id, $dball_id)
    {
        if (! ($user_id && $dball_id)) {
            return false;
        }
        $cache_key = sprintf(self::$CACHE_KEY_BALLS, $user_id);
        $ball = $this->redis->hGet($cache_key, $dball_id);
        $ball = ! empty ($ball) ? json_decode($ball, true) : false;
        return $ball;
    }

	/*
	 * add experience to given dragonball
	 */
	public function addExp($user_id, $user_ball_id, $exp_inc) {

        $drgbl_info = $this->getBall($user_id, $user_ball_id);
		if (!$drgbl_info) {
			syslog(LOG_ERR, "addExp($user_id, $user_ball_id, $exp_inc), ball not found");
			return false;
		}
		$ball_no = $drgbl_info['dragon_ball_id'];
		$drgbls_level_config = self::getGameConfig("dragon_ball_exp");
		$drgbl_level_config = $drgbls_level_config[$ball_no];

		if (!isset($drgbls_level_config) || !isset($drgbl_level_config)) {
			syslog(LOG_ERR, "addExp($user_id, $user_ball_id, $exp_inc), ball level config not found");
			return false;
		}   

		$lvl = $drgbl_info['level'];
		$exp = $drgbl_info['exp'];
		syslog(LOG_DEBUG, "addExp($user_id, $user_ball_id, $exp), lvl=$drgbl_info[level], exp=$drgbl_info[exp]");

		$new_lvl = $lvl;
		$max_lvl = count($drgbl_level_config);
		$max_exp = $drgbl_level_config[$max_lvl]['exp_limit'];
		$exp += $exp_inc;
		if ($exp > $max_exp) {
			$exp = $max_exp;
		}
		// stop condition: new_level==max_level or exp < new_level's explimit
		while($new_lvl<$max_lvl && $exp>=$drgbl_level_config[$new_lvl]['exp_limit']) {
			$new_lvl++;
		}
		$update = array();
		if ($exp != $drgbl_info['exp']) {
			$update['exp'] = $exp;
		}
		if ($new_lvl != $lvl) {
			$update['level'] = $new_lvl;
		}
		if ($update) {
            $resque_lib = $this->_di->getShared('resque_lib');
            $resque_lib->setJob('dball', 'DBallUp', [
                'user_id' => $user_id,
                'udball_id' => $user_ball_id,
                'prof' => $update,
            ]);
            $cache_key = sprintf(self::$CACHE_KEY_BALLS, $user_id);
            $drgbl_info = array_merge($drgbl_info, $update);
            $this->redis->hSet($cache_key, $user_ball_id, json_encode($drgbl_info));
		}
		return $drgbl_info;
	}

    public function eat($user_id, $udb_id, $eat_ids)
    {
        $eat_balls = $this->getByUser($user_id, $eat_ids);
        if (count($eat_balls) != count($eat_ids)) {
            throw new Exception("DBall Count Invalid", ERROR_CODE_DATA_INVALID_DBALL);
        }
        $exp_delta = 0;
        foreach ($eat_balls as $detail) {
            $exp_delta += $detail['exp'] + self::$BASIC_EXP;
        }
        $add_exp_ret = $this->addExp($user_id, $udb_id, $exp_delta);
        if ($add_exp_ret) {
            $resque_lib = $this->_di->getShared('resque_lib');
            $resque_lib->setJob('dball', 'DBallDel', [
                'user_id' => $user_id,
                'udball_ids' => $eat_ids,
            ]);
            $cache_key = sprintf(self::$CACHE_KEY_BALLS, $user_id);
            foreach ($eat_ids as $id) {
                $this->redis->hDel($cache_key, $id);
            }
        }
        return $add_exp_ret;
    }
}

// end of file
