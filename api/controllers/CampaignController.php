<?php

namespace Cap\Controllers;

class CampaignController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();

        $this->_di->set('campaign_lib', function(){
            return new \Cap\Libraries\CampaignLib();
        });
    }

    public function queryAction() {
        $campaign_lib = $this->_di->getShared('campaign_lib');
        $role_id = $this->session->get('role_id');
        $status = $campaign_lib->getCampaignStatus($role_id);
        return json_encode(array('code'=>200, 'status'=>$status));
    }

    public function acceptAction() {
        if (($r=$this->checkParameter(['campaign_id', 'award_id']))!==true) {
            return $r;
        }
        $obj = $this->request_data;
        $role_id = $this->session->get('role_id');
        $campaign_lib = $this->_di->getShared('campaign_lib');
        $r = $campaign_lib->accept($role_id, $obj['campaign_id'], $obj['award_id']);
        return json_encode($r);
    }

    public function buyGPlanAction()
    {
        $campaign_lib = $this->_di->getShared('campaign_lib');
        $r = $campaign_lib->buyGrowthPlan($this->role_id);
        return json_encode($r, JSON_NUMERIC_CHECK);
    }
}

// end of file
