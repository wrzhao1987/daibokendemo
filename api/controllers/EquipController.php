<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-3-11
 * Time: 上午10:04
 */
namespace Cap\Controllers;

use Cap\Libraries\EquipLib;
use Cap\Libraries\UserLib;
use Phalcon\Exception;

class EquipController extends AuthorizedController {

    public $list_items = [
        'equip' => 1,
        'piece' => 2,
    ];

    public function onConstruct() {

        parent::onConstruct();
        $this->_di->set('equip_lib', function() {
            return new EquipLib();
        }, true);

        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
    }

    public function listAction()
    {
        $equip_lib = $this->getDI()->getShared('equip_lib');
        $parts = isset ($this->request_data['part']) ? intval($this->request_data['part']) : 3;

        $ret = [];
        $key = array_search($parts, $this->list_items);
        if ('equip' == $key) {
            $ret['equip'] = $equip_lib->getEquips($this->role_id);
        } else if ('piece' == $key) {
            $ret['piece'] = $equip_lib->getAllPieces($this->role_id);
        } else {
            $ret['equip'] = $equip_lib->getEquips($this->role_id);
            $ret['piece'] = $equip_lib->getAllPieces($this->role_id);
        }

        echo json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function levelUpAction()
    {
        $equip_lib = $this->getDI()->getShared('equip_lib');

        $user_equip_id = $this->request_data['uequip_id'];

        $result = $equip_lib->levelUp($this->role_id, $user_equip_id);

        echo json_encode(["result" => $result], JSON_NUMERIC_CHECK);
    }

    public function levelUpMaxAction()
    {
        $equip_lib = $this->getDI()->getShared('equip_lib');
        $user_equip_id = $this->request_data['uequip_id'];
        $result = $equip_lib->levelUpMax($this->role_id, $user_equip_id);

        echo json_encode(["result" => $result], JSON_NUMERIC_CHECK);

    }

    public function composeAction()
    {
        $equip_id = intval($this->request_data['equip_id']);
        if (empty ($equip_id)) {
            throw new Exception("Equip ID is needed.", ERROR_CODE_PARAM_INVALID);
        }
        $equip_lib = $this->getDI()->getShared('equip_lib');
        $ret = $equip_lib->compose($this->role_id, $equip_id);
        return json_encode([
            'code' => ERROR_CODE_OK,
            'new_equip_id' => $ret,
        ], JSON_NUMERIC_CHECK);
    }

    public function saleAction()
    {
        if (($r = $this->checkParameter(['uequip_id'])) !== true) {
            return $r;
        }
        $user_equip_id = $this->request_data['uequip_id'];
        $equip_lib = $this->getDI()->getShared('equip_lib');
        $ret = $equip_lib->sale($this->role_id, $user_equip_id);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }
}
