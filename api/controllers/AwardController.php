<?php

namespace Cap\Controllers;

class AwardController extends BaseController {

    public function onConstruct() {
        parent::onConstruct();

        $this->_di->set('award_lib', function() {
            return new \Cap\Libraries\AwardLib();
        }, true);

    }

    public function redemptAction() {
        if (($r=$this->checkParameter(['ctgry', 'id']))!=true) {
            return $r;
        }
        $obj = $this->request_data;
        $award_ctgry = $obj['ctgry'];
        $award_id = $obj['id'];
        $role_id = $this->session->get('role_id');

        $award_lib = $this->_di->getShared('award_lib');
        $res = $award_lib->redemptAward($role_id, $award_ctgry, $award_id);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    /*
     * for test
     */
    public function testAction() {
        $award_lib = $this->_di->getShared('award_lib');
        $role_id = 162;
        $award_ctgry = \Cap\Libraries\AwardLib::$AWARD_CTGRY_PVP_RANK_PROGRESS;
        $award_id = 1;
        #$award_lib->activeAward($role_id, $award_ctgry, 1);
        $awards = $award_lib->checkAward($role_id, $award_ctgry);
        var_dump($awards);
        if ($awards) {
            echo "redempt awards<br/>";
            $award = $award_lib->redemptAward($role_id, $award_ctgry, $awards[0]['id']);
            var_dump($award);
        }
        $award = $award_lib->redemptAward($role_id, $award_ctgry, 1);
        var_dump($award);
    }

}
