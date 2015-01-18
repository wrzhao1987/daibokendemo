<?php

namespace Cap\Libraries;

class RaffleLib extends BaseLib {

    public static $RAFFLE_RECORD_KEY = "raffle_record:%s";  // placeholder: user_id
    public static $RAFFLE_FEILD_LAST_FREE = "last_free_t:%s";// placeholder: type
    public static $LAST_RAFFLE_KEY = "last_raffle:%s";  // placeholder: user_id

    public static $RAFFLE_TYPE_EARTH = 1;
    public static $RAFFLE_TYPE_NAMEK = 2;

    public function __construct() {
        parent::__construct();
        $this->_di->set('card_lib', function() {
            return new \Cap\Libraries\CardLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
        $this->_di->set('card_raffle_model', function() {
            return new \Cap\Models\db\CardRaffleModel();
        }, true);
    }

    public function setRaffleRecords($role_id, $updates) {
        $key = sprintf(self::$RAFFLE_RECORD_KEY, $role_id);
        $rds = $this->_di->getShared('redis');
        return $rds->hmset($key, $updates);
    }

    public function getRaffleRecords($role_id) {
        $key = sprintf(self::$RAFFLE_RECORD_KEY, $role_id);
        $rds = $this->_di->getShared('redis');
        $records = $rds->hgetall($key);
        
        // re_construct
        for ($type=1;$type<3;$type++) {
            $ext = $this->getLastFreeTime($records, $type);
            foreach ($ext as $k=>$v) {
                $records[$k] = $v;
            }
        }
        return $records;
    }

    public function getLastFreeTime($records, $type) {
        $item_raffle_cfg = self::getGameConfig('raffle');
        $nfree_per_day = $item_raffle_cfg['raffle'][$type]['nfree_per_day'];
        $ts = 0;
        $last_free_field = sprintf(self::$RAFFLE_FEILD_LAST_FREE.":", $type);
        $last_day_boundary = self::getDefaultExpire() - 86400;
        $today_count = 0;
        foreach ($records as $key=>$val) {
            // get max val of same category key
            if (strncmp($key, $last_free_field, strlen($last_free_field))==0) {
                if ($val > $last_day_boundary) {
                    $today_count++;
                }
                if ($val > $ts) {
                    $ts = $val;
                }
            }
        }
        $r = array("today_count:$type"=>$today_count);
        if ($ts) {
            $r[$last_free_field] = $ts;
        }
        syslog(LOG_DEBUG, "item raffle getLastFreeTime(.., $type)=> $ts, $today_count");
        return $r;
    }

    public function raffle($role_id, $type, $raffle_type) {
        syslog(LOG_DEBUG, "raffle($role_id, $type, $raffle_type)");
        $user_lib = $this->_di->getShared('user_lib');
        $item_lib = $this->_di->getShared('item_lib');
        $free = !$raffle_type;
        $last_free_field = sprintf(self::$RAFFLE_FEILD_LAST_FREE, $type);
        $item_raffle_cfg = self::getGameConfig('raffle');
        if (!isset($item_raffle_cfg['raffle'][$type])) {
            var_dump($item_raffle_cfg['raffle']);
            syslog(LOG_WARNING, "raffle($role_id, $type) unknown type");
            return array('code'=> 404, 'msg'=> 'unknown raffle type');
        }
        $raffle_cfg = $item_raffle_cfg['raffle'][$type];
        $nfree_per_day = $raffle_cfg['nfree_per_day'];
        if ($raffle_type==1) {
            $cost = $raffle_cfg['cost'];
        } else if ($raffle_type==2) {
            $cost = $raffle_cfg['series_10_cost'];
        }
        $cool_down = $raffle_cfg['free_cool_down'];
        $raffle_records = $this->getRaffleRecords($role_id);

        # check & deduct cost
        if ($raffle_type==0) {
            if ($raffle_records['today_count:'.$type] >= $nfree_per_day) {
                syslog(LOG_WARNING, "raffle($role_id, $type, $raffle_type) used up free times($nfree_per_day) per day");
                return array('code'=> 403, 'msg'=> '今日免费次数已用完', 'updates'=>array("today_count:$type"=>$raffle_records['today_count:'.$type]));
            }
            if (!isset($raffle_records[$last_free_field])) {
                /* -- remove activation restriction 
                # only actived after first paid raffle
                syslog(LOG_WARNING, "raffle($role_id, $type) not actived");
                return array('code'=> 403, 'msg'=> 'free raffle not actived yet');
                */
                $user = $user_lib->getUser($role_id);
                if (isset($user[UserLib::$USER_PROF_FIELD_BIRTH_TIME])) {
                    $raffle_records[$last_free_field] = $user[UserLib::$USER_PROF_FIELD_BIRTH_TIME];
                } else {
                    $raffle_records[$last_free_field] = 0;
                }
            }
            $last_raffle = $raffle_records[$last_free_field];
            if (time() < ($last_raffle+$cool_down)) {
                syslog(LOG_WARNING, "raffle($role_id, $type, $raffle_type) in cool down time");
                return array('code'=> 403, 'msg'=> 'still in cool down time', 'updates'=>array("$last_free_field"=>$last_raffle));
            }
        } else {
            # deduct cost
            if ($cost['item_id']==1) {
                $r = $user_lib->consumeFieldAsync($role_id, UserLib::$USER_PROF_FIELD_GOLD, $cost['count']);
                if ($r===false) {
                    syslog(LOG_ERR, "raffle($role_id, $type, $raffle_type): insufficient coin to cost $cost[count]");
                    return array('code'=> 405, 'msg'=> 'insufficient cost');
                }
                $balance = $r;
            } else if ($cost['item_id']==2) {
                $r = $user_lib->consumeFieldAsync($role_id, UserLib::$USER_PROF_FIELD_COIN, $cost['count']);
                if ($r===false) {
                    syslog(LOG_ERR, "raffle($role_id, $type, $raffle_type): insufficient gold to cost $cost[count]");
                    return array('code'=> 405, 'msg'=> 'insufficient cost');
                }
                $balance = $r;
            } else {
                $r = $item_lib->useItem($role_id, $cost['item_id'], $cost['sub_id'], $cost['count']);
                if ($r['result'] === false) {
                    syslog(LOG_ERR, "raffle($role_id, $type, $raffle_type): insufficient item to cost, $r[msg]");
                    return array('code'=> 405, 'msg'=> 'insufficient cost');
                }
            }
        }
        $seq = isset($raffle_records[$type])?$raffle_records[$type]:0;
        # random items
        $items = array();
        if ($raffle_type==0) {
            # free single raffle
            $item = $this->doRaffle($type, -1, $item_raffle_cfg);
            $items []= $item;
        } else if ($raffle_type==1) {
            # single raffle
            $seq += 1;
            $item = $this->doRaffle($type, $seq, $item_raffle_cfg);
            $items []= $item;
        } else if ($raffle_type==2) {
            # 10 series raffle
            $items = array();
            $rand_one = mt_rand(1, 9); // replace one with special set
            for ($i=0;$i<10;$i++) {
                $seq += 1;
                if ($rand_one==$i) {
                    $set_id = $raffle_cfg['series_10_set'];
                } else {
                    $set_id = false;
                }
                $item = $this->doRaffle($type, $seq, $item_raffle_cfg, $set_id);
                $items []= $item;
            }
        } else {
            return array('code'=> 501, 'msg'=> "invalid raffle type $raffle_type");
        }

        # give items to user
        $ritems = array();
        for ($i=0; $i<count($items); $i++) {
            $item = $items[$i];
            $ritem = $item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count']);
            if ($ritem === true) {
                $ritems []= $item;
            } else {
                $ritems []= $ritem;
            }
        }
        /*
        $card_lib = $this->_di->getShared('card_lib');
        $user_card_id = $card_lib->addCard($role_id, $card_id);
        $user_card = array('id'=>$user_card_id, 'card_id'=>$card_id);

        syslog(LOG_DEBUG, "card raffle uid:$role_id, type:$type, free:$free, seq:$seq, got card:$card_id, ucard:$user_card_id");

        # record history 
        $raffle_model = $this->_di->getShared('card_raffle_model');
        $raffle_model->addRecord($role_id, $type, intval($free), $seq, $card_id, $user_card['id']);
        */

        # set records
        if ($raffle_type==0) {
            $updates[$last_free_field] = time();
            $today_count = $raffle_records['today_count:'.$type]+1;
            $updates[$last_free_field.":".$today_count] = time();
            $updates["today_count:$type"] = $raffle_records['today_count:'.$type]+1;
            syslog(LOG_DEBUG, "set free raffle record $type:".($raffle_records['today_count:'.$type]+1));
        } else {
            $updates = array($type=>$seq);
        }

        $this->setRaffleRecords($role_id, $updates);

        $res = array('code'=> 200, 'items'=> $ritems, 'updates'=>$updates);
        if (isset($balance)) {
            $res['balance'] = $balance;
        }
        return $res;
    }

    /*
     * randomize a item according to type and seq
     */
    private function doRaffle($type, $seq, $item_raffle_cfg, $set_id=false) {
        syslog(LOG_DEBUG, "doRaffle($type, $seq, ..., $set_id)");
        # raffle config
        if (!$item_raffle_cfg) {
            $item_raffle_cfg = self::getGameConfig('raffle');
        }
        $raffle_cfg = $item_raffle_cfg['raffle'][$type];
        $raffle_set = $item_raffle_cfg['item_set'];

        # determine item sample set
        if ($set_id===false) {
            $interval_start =  max(array_keys($raffle_cfg['seq']));
            if (isset($raffle_cfg['seq'][$seq])) {
                $set_id = $raffle_cfg['seq'][$seq];
            } else if (isset($raffle_cfg['interval']) && $seq > $interval_start) {
                if (($seq-$interval_start) % $raffle_cfg['interval']['val'] == 0) {
                    $set_id = $raffle_cfg['interval']['set'];
                }
            }
            if ($set_id===false) {
                $set_id = $raffle_cfg['default'];
            }
        }

        # randomize items
        $raffle_set = $item_raffle_cfg['item_set'][$set_id];
        $total_weight = array_reduce($raffle_set, function($v1, $v2){return $v1+$v2['weight'];}, 0);
        syslog(LOG_DEBUG, "total weight $total_weight, set_id $set_id");
        $rand_weight = mt_rand(1, $total_weight);
        foreach ($raffle_set as $aitem) {
            $weight = $aitem['weight'];
            if ($rand_weight <= $weight) {
                # just this item
                $ritem = $aitem;
                unset($ritem['weight']);
                break;
            }
            $rand_weight -= $weight;
        }
        if (!isset($ritem)) {
            syslog(LOG_ERR, "doRaffle: unexpected code reached, total_weight:$total_weight, rand_weight:$rand_weight");
        }
        return $ritem;
    }
}

// end of file
