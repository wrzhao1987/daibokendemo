<?php
namespace Cap\Controllers;
use Cap\Libraries\GuildLib;

class GuildController extends AuthorizedController
{
    public function onConstruct()
    {
        parent::onConstruct();
        $this->_di->set('guild_lib', function() {
            return new GuildLib();
        }, true);
    }

    public function createAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $name = strval($this->request_data['name']);
        $icon = strval($this->request_data['icon']);
        $ret = $guild_lib->create($this->role_id, $name, $icon);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function pickAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->randomGuilds($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);

    }

    public function rjoinAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $gid = intval($this->request_data['gid']);
        $ret = $guild_lib->requestJoin($this->role_id, $gid);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function rlistAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->requestList($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function rdenyAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $rid = intval($this->request_data['rid']);
        $ret = $guild_lib->refuseJoin($this->role_id, $rid);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function radmitAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $rid = intval($this->request_data['rid']);
        $ret = $guild_lib->admitJoin($this->role_id, $rid);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function quitAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->quit($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function kickAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $target_mid = $this->request_data['target_mid'];
        $ret = $guild_lib->kick($this->role_id, $target_mid);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function mlistAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $gid = intval($this->request_data['gid']);
        $ret = $guild_lib->memberList($gid);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function searchAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $gid = intval($this->request_data['gid']);
        $ret = $guild_lib->search($this->role_id, $gid);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function statusAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->guildStatus($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function logListAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $gid = intval($this->request_data['gid']);
        $count = isset ($this->request_data['count']) ? intval($this->request_data['count']) : 50;
        $ret = $guild_lib->logList($gid, $count);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function donateAction()
    {
        if (($r = $this->checkParameter(['type', 'amount'])) !== true) {
            return $r;
        }
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $type = intval($this->request_data['type']);
        $amount = intval($this->request_data['amount']);
        $ret = $guild_lib->donate($this->role_id, $type, $amount);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function dismissAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->dismiss($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function modGradeAction()
    {
        if (($r = $this->checkParameter(['target_mid', 'target_grade'])) !== true) {
            return $r;
        }
        $target_mid = intval($this->request_data['target_mid']);
        $target_grade = intval($this->request_data['target_grade']);
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->changeGrade($this->role_id, $target_mid, $target_grade);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function levelUpAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->levelUp($this->role_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function postAncAction()
    {
        if (($r = $this->checkParameter(['content'])) !== true) {
            return $r;
        }
        $content = strval($this->request_data['content']);
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->postAnc($this->role_id, $content);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function rcancelAction()
    {
        if (($r = $this->checkParameter(['gid'])) !== true) {
            return $r;
        }
        $gid = intval($this->request_data['gid']);
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->cancelRequest($this->role_id, $gid);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function rankAction()
    {
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $ret = $guild_lib->guildRankList();
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }
}