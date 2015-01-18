<?php

namespace Cap\Libraries;

use \Cap\Libraries\UserLib;

class NewbieLib extends BaseLib {

    public function __construct() {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
        $this->_di->set("card_lib", function(){
            return new \Cap\Libraries\CardLib();
        }, true);
    }

    /*
     * finish one step, give items and move step on
     */
    public function finishStep($role_id, $step) {
        syslog(LOG_DEBUG, "finishStep($role_id, $step) entry");
        $newbie_cfg = self::getGameConfig("newbie_guide");
        if (!$newbie_cfg || !isset($newbie_cfg[$step])) {
            syslog(LOG_ERR, "finishStep($role_id, $step), step not configed");
            return array('code'=> 404, 'msg'=> 'step not configured');
        }
        $res = array('code'=> 200);
        $step_cfg = $newbie_cfg[$step];
        if (isset($step_cfg['items'])) {
            $items = $step_cfg['items'];
            # dispatch items
            $item_lib = $this->_di->getShared('item_lib');
            foreach ($items as &$item) {
                $r = $item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count']); 
                if ($r===false) {
                    syslog(LOG_ERR, "fail to add item($role_id, $item[item_id], $item[sub_id], $item[count])");
                } else if (is_array($r)){
                    $item = array_merge($item, $r);
                }
            }
            $res['items'] = $items;
        }

        $user_lib = $this->_di->getShared('user_lib');
        if (isset($step_cfg['props'])) {
            $props = $step_cfg['props'];
            $props_new = array();
            # set extra user properties to special values
            foreach ($props as $prop=> $val) {
                syslog(LOG_DEBUG, "newbie $role_id step $step, add prop $prop $val");
                if ($prop == 'exp') {
                    $r = $user_lib->addExp($role_id, $val);
                    $props_new = array_merge($r, $props_new);
                } else if ($prop == 'mission_energy') {
                    $r = $user_lib->addMissionEnergy($role_id, $val);
                    $props_new[$prop] = $r;
                } else if ($prop == 'rob_energy') {
                    $r = $user_lib->addRobEnergy($role_id, $val);
                    $props_new[$prop] = $r;
                } else if ($prop == 'card_exp') {
                    syslog(LOG_DEBUG, "give card exp $val");
                    $card_lib = $this->_di->getShared('card_lib');
                    $deck_info = $card_lib->getDeckCard($role_id);
                    $cards = array();
                    if (is_array($deck_info)) {
                        foreach ($deck_info as $card_info) {
                            if(isset($card_info['ucard_id'])) {
                                $cards []= $card_info['ucard_id'];
                            }
                        }
                        $card_exp_res = $card_lib->addExpForCards($role_id, $cards, $val);
                        $res['cards'] = $card_exp_res;
                    }
                    $props_new[$prop] = $r;
                } else {
                    syslog(LOG_ERR, "unimplemented user prop obtain in finishStep($role_id, $step), $prop");
                }
            }
            $res['props'] = $props;
        }

        # special action
        /*
        if ($step == self::$STEP_TECH) {
            $tech_lib = $this->_di->getShared('tech_lib');
            $tech_lib->addExp($user_id, $tech_id, 100, false);
        }
        */

        if (isset($step_cfg['forward'])) {
            $res['forward'] = $step_cfg['forward'];
        }

        # move on newbie step
        $saved_step = $user_lib->incrFieldAsync($role_id, UserLib::$USER_PROF_FIELD_NEWBIE, 1);

        # TODO: file format bin log

        return $res;
    }

}

// end of file
