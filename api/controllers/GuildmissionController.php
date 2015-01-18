<?php

namespace Cap\Controllers;

use \Cap\Libraries\GuildLib;

class GuildmissionController extends AuthorizedController {
    
    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('gmission_lib', function() {
            return new \Cap\Libraries\GuildMissionLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('guild_lib', function() {
            return new \Cap\Libraries\GuildLib();
        }, true);
    }

    public function summonAction() {
        if (($r = $this->checkParameter(['boss_id'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $role_id = $this->session->get('role_id');

        /*
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $field = \Cap\Libraries\UserLib::$USER_PROF_GUILD_ID;
        if (!isset($user[$field])) {
            return json_encode(['code'=>403, 'msg'=>'you does belong to any guild']);
        }
        $gid = $user[$field];
        */
        $guild_lib = $this->_di->getShared('guild_lib');
        $ginfo = $guild_lib->status($role_id);
        if (!isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
            return json_encode(['code'=>403, 'msg'=>'you does not belong to any guild']);
        }
        $gid = $ginfo[GuildLib::$STATUS_FIELD_GID];

        $boss_id = $obj['boss_id'];

        $gmlib = $this->_di->getShared('gmission_lib');
        $res = $gmlib->summon($gid, $role_id, $boss_id);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    /* get all boss info for each available boss_id */
    public function queryAction() {
        $role_id = $this->session->get('role_id');
        $guild_lib = $this->_di->getShared('guild_lib');
        $ginfo = $guild_lib->status($role_id);
        if (!isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
            return json_encode(['code'=>403, 'msg'=>'you does not belong to any guild']);
        }
        $gid = $ginfo[GuildLib::$STATUS_FIELD_GID];

        $gmlib = $this->_di->getShared('gmission_lib');
        $info = $gmlib->query($gid);
        return json_encode(array('code'=>200, 'level'=>$info['level'], 'bosses'=>$info['bosses'], 'ginfo'=>$ginfo), JSON_NUMERIC_CHECK|JSON_FORCE_OBJECT);
    }

    public function attackAction() {
        if (($r = $this->checkParameter(['boss_uid'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        if (isset($obj['paid'])) {
            $paid = true;
        } else {
            $paid = false;
        }
        $role_id = $this->session->get('role_id');
 
        /*
        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $field = \Cap\Libraries\UserLib::$USER_PROF_GUILD_ID;
        if (!isset($user[$field])) {
            return json_encode(['code'=>403, 'msg'=>'you does belong to any guild']);
        }
        $gid = $user[$field];
        */
        $guild_lib = $this->_di->getShared('guild_lib');
        $ginfo = $guild_lib->status($role_id);
        if (!isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
            return json_encode(['code'=>403, 'msg'=>'you does not belong to any guild']);
        }
        $gid = $ginfo[GuildLib::$STATUS_FIELD_GID];

        $boss_uid = $obj['boss_uid'];

        $gmlib = $this->_di->getShared('gmission_lib');
        $res = $gmlib->attack($role_id, $gid, $boss_uid, $paid);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function commitAction() {
        if (($r = $this->checkParameter(['battle_id', 'damage'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $role_id = $this->session->get('role_id');

        $battle_id = $obj['battle_id'];
        $damage = $obj['damage'];
        $gmlib = $this->_di->getShared('gmission_lib');
        $res = $gmlib->commit($role_id, $battle_id, $damage);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function upgradeAction() {
        $role_id = $this->session->get('role_id');

        $guild_lib = $this->_di->getShared('guild_lib');
        $ginfo = $guild_lib->status($role_id);
        if (!isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
            return json_encode(['code'=>403, 'msg'=>'you does not belong to any guild']);
        }
        $gid = $ginfo[GuildLib::$STATUS_FIELD_GID];
        $gmlib = $this->_di->getShared('gmission_lib');
        $res = $gmlib->upgradeMission($role_id);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }
}


// End of file

