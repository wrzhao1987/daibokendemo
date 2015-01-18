<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-12
 * Time: 下午4:43
 */
namespace Cap\Controllers;

use Cap\Libraries\TempleLib;

class TempleController extends AuthorizedController
{
    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('temple_lib', function () {
            return new TempleLib();
        }, true);
    }

    public function statusAction() {
        $temple_lib = $this->getDI()->getShared('temple_lib');
        $status = $temple_lib->status($this->role_id);
        echo json_encode($status, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
    }

    public function worshipAction() {
        $temple_lib = $this->getDI()->getShared('temple_lib');
        $god_id = intval($this->request_data['god_id']);
        $result     = $temple_lib->worship($this->role_id, $god_id);
        echo json_encode($result, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
    }
}