<?php

namespace Cap\Libraries;

class AwardLib extends BaseLib {

    public static $AWARD_CTGRY_PVP_RANK_PROGRESS = 1;
    public static $AWARD_CTGRY_PVP_RANK_ACHIEVEMENT = 2;
    public static $AWARD_CTGRY_PVP_RANK = 3;
    public static $AWARD_CTGRY_DAILY_SIGNIN = 4;

    public function __construct() {
        parent::__construct();

        $this->_di->set('award_model', function() {
            return new \Cap\Models\db\AwardModel();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
    }

    /*
     * activate an award to user with type and id
     */
    public function activeAward($role_id, $award_ctgry, $award_id) {
        $award_model = $this->_di->getShared('award_model');
        $user_award_id = $award_model->insertAward($role_id, $award_id, array());
        return $user_award_id;
    }

    /*
     *  redempt an award
     */
    public function redemptAward($role_id, $award_ctgry, $user_award_id) {
        $award_model = $this->_di->getShared('award_model');
        $r = $award_model->redemptAward($role_id, $user_award_id);
        if ($r === false) {
            $res = array('code'=> 500, 'msg'=> 'internal error');
        } else if (is_null($r)) {
            $res = array('code'=> 404, 'msg'=> 'award not found');
        } else {
            $res = array('code'=> 200);
            // give items to user
            $item_lib = $this->_di->getShared('item_lib');
            $award_id = $r;
            $award_cfg = self::getGameConfig('rank_award');
            $items = $award_cfg[$award_id]['items'];
            $res['items'] = array();
            foreach ($items as $item) {
                if (!($ir=$item_lib->addItem($role_id, $item['item_id'], $item['sub_id'], $item['count']))) {
                    syslog(LOG_ERR, "redemptAward: fail addItem($role_id, $item[item_id], $item[sub_id], $item[count])");
                }
                if (is_array($ir)) {
                    $res['items'][] = array_merge($item, $ir);
                } else {
                    $res['items'][] = $item;
                }
            }
        }
        return $res;
    }

    /*
     * check redemptable awards
     */
    public function checkAward($role_id, $award_ctgry) {
        $award_model = $this->_di->getShared('award_model');
        $awards = $award_model->getUnredemptedAwards($role_id);
        return $awards;
    }
}


