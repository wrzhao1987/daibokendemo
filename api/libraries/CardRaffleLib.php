<?php

namespace Cap\Libraries;

class CardraffleLib extends BaseLib {

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
        $card_raffle_cfg = self::getGameConfig('card_raffle');
        $nfree_per_day = $card_raffle_cfg['raffle'][$type]['nfree_per_day'];
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
        syslog(LOG_DEBUG, "card raffle getLastFreeTime(.., $type)=> $ts, $today_count");
        return $r;
    }

    public function raffle($role_id, $type, $free=false) {
        syslog(LOG_DEBUG, "raffle($role_id, $type, $free)");
        $last_free_field = sprintf(self::$RAFFLE_FEILD_LAST_FREE, $type);
        $card_raffle_cfg = self::getGameConfig('card_raffle');
        if (!isset($card_raffle_cfg['raffle'][$type])) {
            syslog(LOG_WARNING, "raffle($role_id, $type) unknown type");
            return array('code'=> 404, 'msg'=> 'unknown raffle type');
        }
        $raffle_cfg = $card_raffle_cfg['raffle'][$type];
        $nfree_per_day = $raffle_cfg['nfree_per_day'];
        $cost = $raffle_cfg['cost'];
        $cool_down = $raffle_cfg['free_cool_down'];
        $raffle_records = $this->getRaffleRecords($role_id);

        # check & deduct cost
        if ($free) {
            if ($raffle_records['today_count:'.$type] >= $nfree_per_day) {
                syslog(LOG_WARNING, "raffle($role_id, $type) used up free times($nfree_per_day) per day");
                return array('code'=> 403, 'msg'=> '今日免费次数已用完', 'updates'=>array("today_count:$type"=>$raffle_records['today_count:'.$type]));
            }
            if (!isset($raffle_records[$last_free_field])) {
                /* -- remove activation restriction 
                # only actived after first paid raffle
                syslog(LOG_WARNING, "raffle($role_id, $type) not actived");
                return array('code'=> 403, 'msg'=> 'free raffle not actived yet');
                */
                $user_lib = $this->_di->getShared('user_lib');
                $user = $user_lib->getUser($role_id);
                if (isset($user[UserLib::$USER_PROF_FIELD_BIRTH_TIME])) {
                    $raffle_records[$last_free_field] = $user[UserLib::$USER_PROF_FIELD_BIRTH_TIME];
                } else {
                    $raffle_records[$last_free_field] = 0;
                }
            }
            $last_raffle = $raffle_records[$last_free_field];
            if (time() < ($last_raffle+$cool_down)) {
                syslog(LOG_WARNING, "raffle($role_id, $type) in cool down time");
                return array('code'=> 403, 'msg'=> 'still in cool down time', 'updates'=>array("$last_free_field"=>$last_raffle));
            }
        } else {
            # deduct cost
            $item_lib = $this->_di->getShared('item_lib');
            $r = $item_lib->useItem($role_id, $cost['item_id'], $cost['sub_id'], $cost['count']);
            if ($r['result'] === false) {
                syslog(LOG_ERR, "raffle($role_id, $type): insufficient item to cost, $r[msg]");
                return array('code'=> 405, 'msg'=> 'insufficient cost');
            }
        }
        $seq = isset($raffle_records[$type])?$raffle_records[$type]:0;
        $seq += 1;
        # random card
        $card_id = $this->doRaffle($type, $seq, $card_raffle_cfg);
        if (!$card_id) {
            syslog(LOG_ERR, "fail to get card");
            return array('code'=> 500, 'msg'=> 'fail to get card');
        }

        # give card to user
        $card_lib = $this->_di->getShared('card_lib');
        $user_card_id = $card_lib->addCard($role_id, $card_id);
        $user_card = array('id'=>$user_card_id, 'card_id'=>$card_id);

        syslog(LOG_DEBUG, "card raffle uid:$role_id, type:$type, free:$free, seq:$seq, got card:$card_id, ucard:$user_card_id");

        # record history 
        $raffle_model = $this->_di->getShared('card_raffle_model');
        $raffle_model->addRecord($role_id, $type, intval($free), $seq, $card_id, $user_card['id']);

        # set records
        $updates = array($type=>$seq);
        if ($free) {
            $updates[$last_free_field] = time();
            $today_count = $raffle_records['today_count:'.$type]+1;
            $updates[$last_free_field.":".$today_count] = time();
            $updates["today_count:$type"] = $raffle_records['today_count:'.$type]+1;
            syslog(LOG_DEBUG, "set free raffle record $type:".($raffle_records['today_count:'.$type]+1));
        }
        $this->setRaffleRecords($role_id, $updates);

        return array('code'=> 200, 'user_card'=> $user_card, 'updates'=>$updates);
    }

    /*
     * randomize a item according to type and seq
     */
    private function doRaffle($type, $seq, $card_raffle_cfg=false) {
        # raffle config
        if (!$card_raffle_cfg) {
            $card_raffle_cfg = self::getGameConfig('card_raffle');
        }
        $raffle_cfg = $card_raffle_cfg['raffle'][$type];
        $raffle_set = $card_raffle_cfg['card_set'];

        # determine card sample set
        $interval_start =  max(array_keys($raffle_cfg['seq']));
        if (isset($raffle_cfg['seq'][$seq])) {
            $set_id = $raffle_cfg['seq'][$seq];
        } else if (isset($raffle_cfg['interval']) && $seq > $interval_start) {
            if (($seq-$interval_start) % $raffle_cfg['interval']['val'] == 0) {
                syslog(LOG_DEBUG, "GOOOOOOOOD");
                $set_id = $raffle_cfg['interval']['set'];
            }
        }
        if (!isset($set_id)) {
            $set_id = $raffle_cfg['default'];
        }

        # randomize items
        $raffle_set = $card_raffle_cfg['card_set'][$set_id];
        $total_weight = array_sum($raffle_set);
        $rand_weight = mt_rand(1, $total_weight);
        foreach ($raffle_set as $cid => $weight) {
            if ($rand_weight <= $weight) {
                # just this card
                $card_id = $cid;
                break;
            }
            $rand_weight -= $weight;
        }
        if (!isset($card_id)) {
            syslog(LOG_ERR, "doRaffle: unexpected code reached, total_weight:$total_weight, rand_weight:$rand_weight");
        }
        syslog(LOG_DEBUG, "using card set $set_id");
        return $card_id;
    }
}

// end of file
