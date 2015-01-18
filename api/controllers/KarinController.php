<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-28
 * Time: 下午9:18
 */
namespace Cap\Controllers;

use Cap\Libraries\KarinLib;

class KarinController extends AuthorizedController
{
    public function onConstruct()
    {
        parent::onConstruct();
        $this->_di->set('karin_lib', function() {
            return new KarinLib();
        }, true);
    }

    public function statusAction()
    {
        $karin_lib = $this->getDI()->getShared('karin_lib');
        $status = $karin_lib->status($this->role_id);

        return json_encode($status, JSON_NUMERIC_CHECK);
    }

    public function passAction()
    {
        $karin_lib = $this->getDI()->getShared('karin_lib');
        $floor  = intval($this->request_data['floor']);
        $result = intval($this->request_data['result']);
        $ret = $karin_lib->pass($this->role_id, $floor, $result);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function resetAction()
    {
        $karin_lib = $this->getDI()->getShared('karin_lib');
        $ret = $karin_lib->reset($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function wipeAction()
    {
        $karin_lib = $this->getDI()->getShared('karin_lib');
        $ret = $karin_lib->wipe($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function rankAction()
    {
        $karin_lib = $this->getDI()->getShared('karin_lib');
        $rank = $karin_lib->rank($this->role_id);

        return json_encode($rank, JSON_NUMERIC_CHECK);
    }
}