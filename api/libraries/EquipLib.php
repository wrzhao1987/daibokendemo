<?php
namespace Cap\Libraries;

use Cap\Models\Db\UserEquipModel;
use Phalcon\Exception;

class EquipLib extends BaseLib
{
    public static $CACHE_KEY_EQUIPS = 'nami:equips:%s';
    public static $CACHE_KEY_EQUIP_PIECES = 'nami:epieces:%s';
    public static $CACHE_KEY_SPACE_COUNT = "nami:equips:space:%s";
    public static $PIECE_NEED_PER_STAR = [
        3 => 20,
        4 => 40,
        5 => 80,
    ];
    public static $CAHE_KEY_ENHANCE_COUNT = "nami:equips:enhance:%s";
    public static $EQUIPS_MAX_COUNT = 500;

	public function __construct()
	{
		parent::__construct();
		$this->_di->set('equip_model', function() {
			return new UserEquipModel();
		}, true);
        $this->_di->set('resque_lib', function() {
            return new ResqueLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
	}

    public function getEquips($user_id, $id_list = null)
    {
        $ret = [];
        $cache_key = sprintf(self::$CACHE_KEY_EQUIPS, $user_id);
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
            $equip_model = $this->getDI()->getShared('equip_model');
            if ($tmp = $equip_model->getByUser($user_id)) {
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
        if (! empty ($ret)) {
            foreach ($ret as & $value) {
                if (! empty ($value)) {
                    $equip_config = self::getGameConfig('equip');
                    $value['star'] = $equip_config[$value['equip_id']]['star'];
                    $value['type'] = $equip_config[$value['equip_id']]['type'];
                    if (null === $id_list) {
                        $value['uequip_id'] = $value['id'];
                        unset ($value['id']);
                    }
                }
            }
            if (null === $id_list) {
                $stars  = array_column($ret, 'star');
                $levels = array_column($ret, 'level');
                array_multisort($stars, SORT_DESC, $levels, SORT_DESC, $ret);
                foreach ($ret as & $detail) {
                    unset ($detail['star']);
                }
            }
        }
        return $ret;
    }

    public function getEquip($user_id, $user_equip_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_EQUIPS, $user_id);
        $equip = $this->redis->hGet($cache_key, $user_equip_id);
        $equip = json_decode($equip, true);
        if (is_array($equip) && isset($equip['id']) && isset($equip['equip_id'])) {
            $equip_config = self::getGameConfig('equip');
            $equip['type'] = $equip_config[$equip['equip_id']]['type'];
            return $equip;
        }
        return false;
    }

    public function levelUp($user_id, $user_equip_id, $delta = 1)
    {
        $user_lib = $this->_di->getShared('user_lib');
        $user     = $user_lib->getUser($user_id);
        $user_level  = $user[UserLib::$USER_PROF_FIELD_LEVEL];

        $equip = $this->getEquip($user_id, $user_equip_id);
        if ($equip) {
            if ($equip['level'] + $delta <= $user_level) {
                $equip_config = self::getGameConfig('equip');
                $cost = $equip_config [$equip['equip_id']]['cost'] [$equip['level']];
                $remain = $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, $cost);
                // 索尼币余额足够支付
                if ($remain !== false) {
                    $resque_lib = $this->_di->getShared('resque_lib');
                    if ($resque_lib->setJob('equip', 'EquipLevelUp', [
                        'user_id'   => $user_id,
                        'uequip_id' => $user_equip_id,
                        'delta'     => $delta,
                    ])) {
                        $equip['level'] += $delta;
                        unset($equip['type']);
                        $cache_key = sprintf(self::$CACHE_KEY_EQUIPS, $user_id);
                        $this->redis->hSet($cache_key, $user_equip_id, json_encode($equip));
                        $this->incrEnhanceCount($user_id);
                        return true;
                    }
                } else {
                    throw new Exception('索尼币余额不足!', ERROR_CODE_FAIL);
                }
            } else {
                throw new Exception('强化等级不得超过战队等级!', ERROR_CODE_FAIL);
            }

        } else {
            throw new Exception('获取装备信息失败!', ERROR_CODE_FAIL);

        }
        return false;
    }

    public function levelUpMax($user_id, $user_equip_id)
    {
        $user_lib = $this->getDI()->getShared('user_lib');
        $user     = $user_lib->getUser($user_id);
        $user_level = $user[UserLib::$USER_PROF_FIELD_LEVEL];
        $user_coin  = $user[UserLib::$USER_PROF_FIELD_COIN];
        $equip = $this->getEquip($user_id, $user_equip_id);
        if ($equip) {
            $equip_level = $equip['level'];
            $equip_config = self::getGameConfig('equip');
            $cost = 0;
            for ($i = $equip_level; $i < $user_level; $i++) {
                $cost += $equip_config[$equip['equip_id']]['cost'] [$i];
                if ($cost > $user_coin) {
                    $cost -= $equip_config[$equip['equip_id']]['cost'] [$i];
                    break;
                }
            }
            $delta = $i - $equip_level;
            if (intval($delta) > 0) {
                $remain = $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, $cost);
                if ($remain !== false) {
                    $resque_lib = $this->_di->getShared('resque_lib');
                    if ($resque_lib->setJob('equip', 'EquipLevelUp', [
                        'user_id'   => $user_id,
                        'uequip_id' => $user_equip_id,
                        'delta'     => $delta,
                    ])) {
                        $equip['level'] += $delta;
                        unset($equip['type']);
                        $cache_key = sprintf(self::$CACHE_KEY_EQUIPS, $user_id);
                        $this->redis->hSet($cache_key, $user_equip_id, json_encode($equip));
                        $this->incrEnhanceCount($user_id, $delta);
                        return [
                            'level' => $i,
                            'cost'  => $cost,
                        ];
                    }
                } else {
                    throw new Exception('索尼币余额不足!', ERROR_CODE_FAIL);
                }
            } else {
                return [
                    'level' => $equip_level,
                    'cost'  => 0,
                ];
            }
        } else {
            throw new Exception('获取装备信息失败!', ERROR_CODE_FAIL);
        }
        return false;
    }

    public function addEquip($user_id, $equip_id)
    {
        if ($this->isExceedSpaceCount($user_id)) {
            return 0;
        }
        $equip_model = $this->getDI()->getShared('equip_model');
        // 返回装备主键ID
        $equip_conf = self::getGameConfig('equip');
        if (! isset ($equip_conf[$equip_id])) {
            return 0;
        }
        $new_equip_id = $equip_model->addNew($user_id, $equip_id);
        if (intval($new_equip_id) > 0) {
            $new_equip_info = [
                'id'       => $new_equip_id,
                'equip_id' => $equip_id,
                'level'    => 1,
            ];
            $cache_key = sprintf(self::$CACHE_KEY_EQUIPS, $user_id);
            $this->redis->hSetNx($cache_key, $new_equip_id, json_encode($new_equip_info));
            $this->updateSpaceCount($user_id, 1);
        }
        return $new_equip_id;
    }

    public function delEquip($user_id, $user_equip_id)
    {
        $equip_info = $this->getEquip($user_id, $user_equip_id);
        if ($equip_info)
        {
            $equip_model = $this->getDI()->getShared('equip_model');
            $ret = $equip_model->del($user_id, $user_equip_id);
            if ($ret) {
                $cache_key = sprintf(self::$CACHE_KEY_EQUIPS, $user_id);
                $this->redis->hDel($cache_key, $user_equip_id);
                $this->updateSpaceCount($user_id, -1);
                return $equip_info;
            }
        }
        return false;
    }

    /*
     * equip convert to tech expereince
     */
    public static function getEquipTechExp($equip) {
        $equip_config = self::getGameConfig('equip');
        $tech_exp = $equip_config[$equip['equip_id']]['tech_exp'][$equip['level']];
        return $tech_exp;
    }

    public function getAllPieces($user_id)
    {
        $ret = [];
        $cache_key = sprintf(self::$CACHE_KEY_EQUIP_PIECES, $user_id);
        $pieces = $this->redis->hGetAll($cache_key);
        if ($pieces) {
            foreach ($pieces as $equip_id => $count) {
                $arr = ['equip_id' => $equip_id, 'count' => $count];
                array_push($ret, $arr);
            }
        }
        return $ret;
    }

    public function updatePiece($user_id, $equip_id, $delta)
    {
        if ($this->isExceedSpaceCount($user_id)) {
            return false;
        }
        $cache_key = sprintf(self::$CACHE_KEY_EQUIP_PIECES, $user_id);
        $remain = $this->redis->hIncrBy($cache_key, $equip_id, $delta);
        if (intval($remain) < 0) {
            $this->redis->hIncrBy($cache_key, $equip_id, - $delta);
            return false;
        } else if ($remain == 0) {
            $this->redis->hDel($cache_key, $equip_id);
            $this->updateSpaceCount($user_id, -1);
        } else if ($remain == $delta) {
            $this->updateSpaceCount($user_id, 1);
        }
        return true;
    }

    public function compose($user_id, $equip_id)
    {
        $new_equip_id = 0;
        $equip_cfg = self::getGameConfig('equip');
        if (! isset ($equip_cfg[$equip_id])) {
            throw new Exception("Equip ID:$equip_id NOT DEFINED", ERROR_CODE_CONFIG_NOT_FOUND);
        }
        $star = $equip_cfg[$equip_id]['star'];
        if (! isset (self::$PIECE_NEED_PER_STAR[$star])) {
            throw new Exception("Equip ID:$equip_id CANNOT BE COMPOSE", ERROR_CODE_FAIL);
        }
        $pieces_need = self::$PIECE_NEED_PER_STAR[$star];
        if ($this->updatePiece($user_id, $equip_id, - $pieces_need)) {
            $new_equip_id = $this->addEquip($user_id, $equip_id);
            if (! $new_equip_id) {
                $this->updatePiece($user_id, $equip_id, $pieces_need);
                return false;
            }
        }
        return $new_equip_id;
    }

    public function getEnhanceCount($user_id)
    {
        $cache_key = sprintf(self::$CAHE_KEY_ENHANCE_COUNT, $user_id);
        $count = $this->redis->get($cache_key);
        return $count ? intval($count) : 0;
    }

    public function incrEnhanceCount($user_id, $delta = 1)
    {
        $cache_key = sprintf(self::$CAHE_KEY_ENHANCE_COUNT, $user_id);
        $expire = self::getDefaultExpire();

        if ($this->redis->exists($cache_key)) {
            $count = $this->redis->incrBy($cache_key, $delta);
        } else {
            $count = $this->redis->incrBy($cache_key, $delta);
            $this->redis->expireAt($cache_key, $expire);
        }
        return $count;
    }

    private function isExceedSpaceCount($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_SPACE_COUNT, $user_id);
        $space_count = $this->redis->get($cache_key);
        return $space_count >= self::$EQUIPS_MAX_COUNT;
    }

    private function updateSpaceCount($user_id, $delta)
    {
        $cache_key = sprintf(self::$CACHE_KEY_SPACE_COUNT, $user_id);
        $space_count = $this->redis->incrBy($cache_key, $delta);
        if ($space_count < 0) {
            $this->redis->set($cache_key, 0);
        }
    }

    public function getSpaceCount($user_id) {
        $cache_key = sprintf(self::$CACHE_KEY_SPACE_COUNT, $user_id);
        $space_count = $this->redis->get($cache_key);
        return $space_count ? intval($space_count) : 0;
    }

    public function sale($user_id, $uequip_id)
    {
        $equip_info = $this->getEquip($user_id, $uequip_id);
        if (! $equip_info) {
            return ['code' => '404', "msg" => '找不到该装备'];
        }
        $equip_id  = $equip_info['equip_id'];
        $equip_lvl = $equip_info['level'];
        $cfg = self::getGameConfig('equip');
        $price = $cfg[$equip_id]['price'][$equip_lvl];
        $user_lib = $this->getDI()->getShared('user_lib');
        $remain = $user_lib->incrFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, $price);
        if ($remain) {
            $this->delEquip($user_id, $uequip_id);
            return ['code' => 200, 'money' => $remain];
        } else {
            return ['code' => 500, 'msg' => '内部错误'];
        }
    }
}
