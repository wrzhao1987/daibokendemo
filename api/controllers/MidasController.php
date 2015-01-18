<?php

namespace Cap\Controllers;

class MidasController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();

        $this->_di->set('midas_lib', function() {
            return new \Cap\Libraries\MidasLib();
        }, true);
    }

    public function queryAction() {
        $role_id = $this->session->get('role_id');
        $midas_lib = $this->_di->getShared('midas_lib');
        $used_times = $midas_lib->getUsedTimes($role_id);
        $res = array('code'=> 200, 'used_times'=> $used_times);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function buyAction() {
        $role_id = $this->session->get('role_id');
        $midas_lib = $this->_di->getShared('midas_lib');
        $res = $midas_lib->buy($role_id);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

}

// end of file
