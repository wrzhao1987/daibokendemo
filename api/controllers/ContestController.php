<?php
namespace Cap\Controllers;

use Cap\Libraries\ContestLib;

class ContestController extends AuthorizedController
{
    public function onConstruct()
    {
        parent::onConstruct();
    }

    public function statusAction()
    {
        $contest_lib = new ContestLib();
        $ret = $contest_lib->userStatus($this->role_id);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function encrAction()
    {
        if (($r=$this->checkParameter(['type']))!==true) {
            return $r;
        }
        $type = $this->request_data['type'];
        $contest_lib = new ContestLib();
        $ret = $contest_lib->encr($this->role_id, $type);
        return json_encode($ret, JSON_NUMERIC_CHECK);

    }

    public function beginAction()
    {
        $contest_lib = new ContestLib();
        $ret = $contest_lib->findRing($this->role_id);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function commitAction()
    {
        if (($r=$this->checkParameter(['group', 'group_id', 'result']))!==true) {
            return $r;
        }
        $opp_uid = $this->request_data['uid'];
        $group = $this->request_data['group'];
        $id_in_grp = $this->request_data['group_id'];
        $win = $this->request_data['result'];
        $contest_lib = new ContestLib();
        $ret = $contest_lib->commit($this->role_id, $opp_uid, $group, $id_in_grp, $win);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function bonusAction()
    {
        $contest_lib = new ContestLib();
        $ret = $contest_lib->finishRing($this->role_id);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function rankAction()
    {
        $contest_lib = new ContestLib();
        $ret = $contest_lib->rank($this->role_id);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }
}
