<?php

namespace Cap\Controllers;

class RefreshstoreController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('rstore_lib', function() {
            return new \Cap\Libraries\RefreshStoreLib();
        }, true);
    }

    public function buyAction() {
        if (($r=$this->checkParameter(array('commodity_id'))) !== true) {
            return $r; 
        }
        $commodity_id = $this->request_data['commodity_id'];
        if (isset ($this->request_data['store_id'])) {
            $store_id = intval($this->request_data['store_id']);
        } else {
            $store_id = 1;
        }
        if (isset($this->request_data['count'])) {
            $count = intval($this->request_data['count']);
        } else {
            $count = 1;
        }
        $role_id = $this->session->get('role_id');

        $rstore_lib = $this->_di->getShared('rstore_lib');
        $res = $rstore_lib->buy($role_id, $commodity_id, $count, $store_id);

        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function listAction() {
        $rstore_lib = $this->_di->getShared('rstore_lib');
        $role_id = $this->session->get('role_id');
        if (isset ($this->request_data['store_id'])) {
            $store_id = intval($this->request_data['store_id']);
        } else {
            $store_id = 1;
        }
        $records = $rstore_lib->getRecords($role_id, $store_id);
        return json_encode($records, JSON_NUMERIC_CHECK);
    }

    public function refreshAction() {
        $rstore_lib = $this->_di->getShared('rstore_lib');
        $role_id = $this->session->get('role_id');
        if (isset ($this->request_data['store_id'])) {
            $store_id = intval($this->request_data['store_id']);
        } else {
            $store_id = 1;
        }
        $records = $rstore_lib->refresh($role_id, $store_id);
        return json_encode($records, JSON_NUMERIC_CHECK);
    }
}


