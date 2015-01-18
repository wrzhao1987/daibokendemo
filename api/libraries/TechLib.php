<?php

namespace Cap\Libraries;

class TechLib extends BaseLib {

    public static $USER_TECH_KEY = 'user:%s:tech'; // placeholders: role_id

    public function __construct() {
        parent::__construct();

        $this->_di->set('tech_config', function() {
            return self::getGameConfig('tech');
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('card_lib', function() {
            return new \Cap\Libraries\CardLib();
        }, true);
        $this->_di->set('equip_lib', function() {
            return new \Cap\Libraries\EquipLib();
        }, true);
    }

    public function getUserTechs($user_id) {
        $rds = $this->_di->getShared('redis');

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $user_level = $user['level'];

        $tech_key = sprintf(self::$USER_TECH_KEY, $user_id);
        $user_techs = $rds->hgetall($tech_key);
        # check open 
        $tech_configs = $this->_di->getShared('tech_config');
        $techs = array();
        foreach ($tech_configs as $tech_id=>$tech_config) {
            $lvl_cfg = $tech_config['level_cfg'];
            if (isset($user_techs[$tech_id])) {
                $exp = intval($user_techs[$tech_id]);
            } else {
                $exp = 0;
            }
            $lvl = $this->calcLevel($user_level, $exp, $lvl_cfg);
            if ($lvl !== false) {
                $techs[] = array('id'=>$tech_id, 'lvl'=> $lvl, 'exp'=>$exp);
            }
        }
        return $techs;
    }

    /*
     * calculate level according to experience and level config, user level
     * return false if not opened yet
     */
    function calcLevel($user_level, $exp, $lvl_cfg) {
        # determine level
        $cur_level = 0;
        $max_level = count($lvl_cfg) - 1;
        # stop condition: level==max_level or exp<level[exp_limit] or reach limit
        while ($cur_level < $max_level) {
            if ($user_level < $lvl_cfg[$cur_level]['required_level']) {
                $cur_level--;
                break;
            }
            if ($exp < $lvl_cfg[$cur_level]['exp_limit']) {
                break;
            }
            $cur_level++;
        }
        if ($cur_level < 0)
            $cur_level = false;
        return $cur_level;
    }

    /*
     * return false if not opened yet
     */
    function addExp($user_id, $tech_id, $exp_add, $lvl_cfg) {
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($user_id);
        $user_level = $user['level'];

        if (!$lvl_cfg) {
            $tech_configs = $this->_di->getShared('tech_config');
            $tech_config = $tech_configs[$tech_id];
            $lvl_cfg = $tech_config['level_cfg'];
        }

        $rds = $this->_di->getShared('redis');
        $tech_key = sprintf(self::$USER_TECH_KEY, $user_id);

        $max_level = count($lvl_cfg) - 1;
        $new_exp = $rds->hincrBy($tech_key, $tech_id, $exp_add);
        $new_lvl = $this->calcLevel($user_level, $new_exp, $lvl_cfg);
        if ($new_lvl === false) {
            syslog(LOG_INFO, "addTechExp: tech $tech_id not opened for $user_id:$user_level");
            if ($new_exp == $exp_add) {
                $rds->hdel($tech_key, $tech_id);
            } else {
                $rds->hincrBy($tech_key, $tech_id, -$exp_add);
            }
            return false;
        }
        # revise exp
        $exp_limit = $lvl_cfg[$new_lvl]['exp_limit'];
        if ($new_exp > $exp_limit) {
            syslog(LOG_INFO, "addTechExp: truncate $tech_id@$user_id exp $new_exp to $exp_limit");
            $new_exp = $exp_limit;
            $rds->hset($tech_key, $tech_id, $new_exp);
        }
        return array('level'=>$new_lvl, 'exp'=>$new_exp);
    }

    public function techUpgrade($user_id, $tech_id, $ucards, $card_sprits, $uequips) {
        $tech_configs = $this->_di->getShared('tech_config');
        if (!isset($tech_configs[$tech_id])) {
            return array('code'=> 404, 'msg'=> 'tech not found');
        }
        $tech_config = $tech_configs[$tech_id];
        $lvl_cfg = $tech_config['level_cfg'];

        # consume ucards, card_sprits and equips, gain exp
        $exp_add = 0;
        $card_cfg = self::getGameConfig('hero_basic');
        $card_lvl_cfg = self::getGameConfig('hero_level');
        $card_lib = $this->_di->getShared('card_lib');
        # consume user card
        foreach ($ucards as $ucard_id) {
            $ucard = $card_lib->deleteUserCard($user_id, $ucard_id, true);
            if ($ucard) {
                # using configured exp conversion
                $exp_add += $card_lvl_cfg[$ucard['card_id']][$ucard['level']]['tech_exp'];
            } else {
                syslog(LOG_WARNING, "techUpgrade fail to consume ucard $ucard_id");
            }
        }

        # consume card spirit
        foreach ($card_sprits as &$num) {
            $num = -$num;
        }
        $result = $card_lib->updatePieceBatch($user_id, $card_sprits);
        foreach ($result as $card_id => $r) {
            if ($r===false) {
                syslog(LOG_ERR, "techUpgrade fail to consume fragment $card_id");
            } else {
                # calculate exp according to star
                $star = $card_cfg[$card_id]['star'];
                $exp_add += $star * abs($card_sprits[$card_id]);
            }
        }
        # consume equip
        $equip_lib = $this->_di->getShared('equip_lib');
        foreach ($uequips as $uequip_id) {
            # calc equip exp
            $uequip = $equip_lib->delEquip($user_id, $uequip_id);
            if ($uequip) {
                $exp_add += $equip_lib->getEquipTechExp($uequip);
            } else {
                syslog(LOG_ERR, "techUpgrade fail to consume uequip $uequip_id");
            }
        }

        syslog(LOG_DEBUG, "techUpgrade($user_id, $tech_id, ...), expadd=$exp_add");

        $exp_ret = $this->addExp($user_id, $tech_id, $exp_add, $lvl_cfg);
        if ($exp_ret === false) {
            return array('code'=> 403, 'msg'=> 'tech not opened yet');
        }
        $exp_ret['code'] = 200;
        // 参与度埋点
        (new KpiLib())->recordSysJoin($user_id, KpiLib::$EVENT_TYPE_TECH);
        return $exp_ret;
    }

}

// enf of file
