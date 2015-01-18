<?php

namespace Cap\Controllers;

class CardRaffleController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('card_raffle_lib', function() {
            return new \Cap\Libraries\CardRaffleLib();
        }, true);
        $this->_di->set('raffle_lib', function() {
            return new \Cap\Libraries\RaffleLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
    }

    public function queryAction() {
        $role_id = $this->session->get('role_id');
        $raffle_lib = $this->_di->getShared('raffle_lib');
        $raffle_records = $raffle_lib->getRaffleRecords($role_id);
        $item_lib = $this->_di->getShared('item_lib');
        $res = array (
            'code'=> 200,
            'raffle_record'=> $raffle_records,
            'item_list'=> $item_lib->listItem($role_id, true)
        );
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function raffleAction() {
        if (($r = $this->checkParameter(['type'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $type = $obj['type'];
        if (isset($obj['raffle_type'])) {
            $raffle_type = $obj['raffle_type'];
        } else if (isset($obj['free'])) {
            $raffle_type = 0;
        } else {
            $raffle_type = 1;   // 0=free, 1=single, 2=series_10
        }
        $role_id = $this->session->get('role_id');
        $raffle_lib = $this->_di->getShared('raffle_lib');
        $res = $raffle_lib->raffle($role_id, $type, $raffle_type);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }
}

// end of file
