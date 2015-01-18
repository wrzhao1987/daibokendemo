<?php

namespace Cap\Controllers;

class TechController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('tech_lib', function() {
            return new \Cap\Libraries\TechLib();
        }, true);
    }

    public function listAction() {
        $role_id = $this->session->get('role_id');
        $tech_lib = $this->_di->getShared('tech_lib');

        $techs = $tech_lib->getUserTechs($role_id);
        $res = array('code'=> 200, 'techs'=> $techs);
        return json_encode($res);
    }

    public function addExpAction() {
        if (($r = $this->checkParameter(['tech_id', 'cost_cards', 'cost_equips', 'cost_card_sprits'])) !== true) {
            return $r; 
        }   
        $obj = $this->request_data;
        $tech_id = $obj['tech_id'];
        $ucards = $obj['cost_cards'];
        $card_sprits = $obj['cost_card_sprits'];
        $uequips = $obj['cost_equips'];

        $role_id = $this->session->get('role_id');
        $tech_lib = $this->_di->getShared('tech_lib');
        $res = $tech_lib->techUpgrade($role_id, $tech_id, $ucards, $card_sprits, $uequips);
        return json_encode($res);
    }
}

// end of file
