<?php 
namespace Cap\Controllers;

use Cap\Libraries\MissionLib;

class MissionController extends AuthorizedController {

	public function onConstruct()
	{
		parent::onConstruct();
		// lazy load
		$this->_di->set("mission_lib", function($type=0){
			return new MissionLib($type);
		});
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('card_lib', function() {
            return new \Cap\Libraries\CardLib();
        }, true);
        $this->_di->set('deck_lib', function() {
            return new \Cap\Libraries\DeckLib();
        }, true);
        $this->_di->set('tech_lib', function() {
            return new \Cap\Libraries\TechLib();
        }, true);
	}

    public function prepareAction(){
        $data = $this->request->getPost('data');
        if ($data) {
            $obj = json_decode($data, true);
            if (isset($obj['field'])) {
                $attrs = $obj['field'];
            }
        }

        $role_id = $this->session->get('role_id');
        $user_lib = $this->_di->getShared('user_lib');

        $res = array('code'=>200);

        if (isset($attrs) && isset($attrs['mercenaries'])) {
            $num = 5;
            $mercenaries = $user_lib->findSupportUsers($role_id, $num);
            $res['mercenaries'] = $mercenaries;
        }

        if (isset($attrs) && isset($attrs['deck'])) {
            // done: get deck info
            $card_lib = $this->_di->getShared('card_lib');
            $deck_info = $card_lib->getDeckCard($role_id);
            if (!$deck_info) {
                $res['code'] = 500;
                syslog(LOG_INFO, "fail to get deck info for $role_id");
                $res['desc'] = 'fail to get deck info';
            } else {
                $res['deck'] = $deck_info;
            }
        }
        // tech
        $tech_lib = $this->_di->getShared('tech_lib');
        $res['tech'] = $tech_lib->getUserTechs($role_id);

        return json_encode($res, JSON_NUMERIC_CHECK);
    }


    public function attackAction() {
        $data = $this->request->getPost('data');
        if ($data) {
            $obj = json_decode($data, true);
            if (!isset($obj['section_id'])) {
                return json_encode(array('code'=>400, 'msg'=> 'section required'));
            }
        } else {
            return json_encode(array('code'=>400, 'msg'=> 'data required'));
        }

        $role_id = $this->session->get('role_id');
        $section = $obj['section_id'];

        if (isset($obj['type'])) {
            $type = $obj['type'];
        } else if (isset($obj['elite']) && $obj['elite']) {
            $type = 1;
        } else {
            $type = 0;
        }

        $deck_lib = $this->_di->getShared('deck_lib');
        if (isset($obj['deck_update'])) {
            // done: update and get deck members
            $deck_lib->updateDeckFormation($role_id, DECK_TYPE_PVE, $obj['deck_update']);
        }
        $ucards = array();
        $deck = $deck_lib->getDeck($role_id, DECK_TYPE_PVE);
        foreach ($deck as $key => $value) {
            $tmp = explode(':', $key);
            if ('card' == $tmp[0])
            {
                $ucards[] = $value;
            }
        }
        if (empty($ucards)) {
            return json_encode(array('code'=> 500, 'msg'=> 'user deck card not found'));
        }

        if (isset($obj['mercenary'])) {
            $mercenary = $obj['mercenary'];
        } else {
            $mercenary = false;
        }
        if (isset($obj['cost'])) {
            $fee = $obj['cost'];
        } else {
            $fee = 0;
        }
        $mission_lib = $this->_di->get('mission_lib', [$type]);
        $res = $mission_lib->attack($role_id, $section, $mercenary, $ucards, $fee);
        
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function commitAction() {
        $data = $this->request->getPost('data');
        if ($data) {
            $obj = json_decode($data, true);
            if (!isset($obj['battle_id']) || !isset($obj['result']) || !isset($obj['deaths'])) {
                return json_encode(array('code'=>400, 'msg'=> 'battle_id, result or deaths required'));
            }
        } else {
            return json_encode(array('code'=>400, 'msg'=> 'data required'));
        }

        $role_id = $this->session->get('role_id');
        $btl_id = $obj['battle_id'];
        $result = $obj['result'];
        $deaths = $obj['deaths'];
        if (isset($obj['type'])) {
            $type = $obj['type'];
        } else if (isset($obj['elite']) && $obj['elite']) {
            $type = 1;
        } else {
            $type = 0;
        }
        $mission_lib = $this->_di->get('mission_lib', [$type]);
        $res = $mission_lib->commitAttack($role_id, $btl_id, $result, $deaths);

        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function wipeAction() {
        $data = $this->request->getPost('data');
        if ($data) {
            $obj = json_decode($data, true);
            if (!isset($obj['section_id'])) {
                return json_encode(array('code'=>400, 'msg'=> 'section_id required'));
            }
        } else {
            return json_encode(array('code'=>400, 'msg'=> 'data required'));
        }

        $role_id = $this->session->get('role_id');
        $section_id = $obj['section_id'];
        $count = 1;
        if (isset($obj['count'])) {
            $count = intval($obj['count']);
        }
        if (isset($obj['free'])) {
            $free = intval($obj['free']);
        } else {
            $free = 1;
        }
        if (isset($obj['type'])) {
            $type = $obj['type'];
        } else if (isset($obj['elite']) && $obj['elite']) {
            $type = 1;
        } else {
            $type = 0;
        }

        $mission_lib = $this->_di->get('mission_lib', [$type]);
        $res = $mission_lib->wipe($role_id, $section_id, $count, $free);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    /*
     * get sections already passed and passed point
     */
    public function sectionsAction() {
        $data = $this->request->getPost('data');
        $type = 0;
        if ($data) {
            $obj = json_decode($data, true);
            if (isset($obj['type'])) {
                $type = $obj['type'];
            } else if (isset($obj['elite']) && $obj['elite']) {
                $type = 1;
            } else {
                $type = 0;
            }
        }
        $role_id = $this->session->get('role_id');
        $mission_lib = $this->_di->get('mission_lib', [$type]);
        $sections = $mission_lib->getSectionsHistory($role_id);
        $bonus_gived = $mission_lib->getStarBonus($role_id);
        $res = array('code'=>200, 'sections'=> $sections, 'awards_rec' => $bonus_gived);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    /*
     * time limited sections daily pass record
     */
    public function tlRecordAction() {
        $data = $this->request->getPost('data');
        $type = 0;
        if ($data) {
            $obj = json_decode($data, true);
            if (isset($obj['type'])) {
                $type = $obj['type'];
            } else if (isset($obj['elite']) && $obj['elite']) {
                $type = 1;
            } else {
                $type = 0;
            }
        }
        $role_id = $this->session->get('role_id');
        $recs = MissionLib::getTimeLimitedMissionRecord($role_id);
        $res = array('code'=>200, 'records'=> $recs);
        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function bonusAction() {
        $data = $this->request->getPost('data');
        $type = 0;
        $chapter = 0;
        $bonus_no = 0;
        if ($data) {
            $obj = json_decode($data, true);
            if (isset($obj['type'])) {
                $type = $obj['type'];
            } else if (isset($obj['elite']) && $obj['elite']) {
                $type = 1;
            } else {
                $type = 0;
            }
            $chapter = $obj['chapter'];
            $bonus_no = $obj['bonus_no'];
        }
        if (empty ($chapter) || empty ($bonus_no)) {
            $res = ['code' => 400, 'msg' => '数据传输有误'];
        } else {
            $role_id = $this->session->get('role_id');
            $mission_lib = $this->_di->get('mission_lib', [$type]);
            $bonus = $mission_lib->giveStarBonus($role_id, $chapter, $bonus_no);
            $res = ['code' => 200, 'bonus' => $bonus, 'msg' => 'OK'];
        }
        return json_encode($res, JSON_NUMERIC_CHECK);
    }
}
