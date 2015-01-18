<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-3-11
 * Time: 上午10:04
 */
namespace Cap\Controllers;

use Cap\Libraries\QuestLib;
use Phalcon\Exception;

class QuestController extends AuthorizedController
{
    public function onConstruct()
    {
        parent::onConstruct();
        $this->_di->set('quest_lib', function() {
            return new QuestLib();
        }, true);
    }

    public function statusAction()
    {
        $quest_lib = $this->getDI()->getShared('quest_lib');
        $status = $quest_lib->status($this->role_id);

        return json_encode($status, JSON_NUMERIC_CHECK);
    }

    public function commitAction()
    {
        $quest_id = intval($this->request_data['quest_id']);
        if ($quest_id <= 0) {
            throw new Exception("Quest ID is required", ERROR_CODE_PARAM_INVALID);
        }
        $quest_lib = $this->getDI()->getShared('quest_lib');
        $ret = $quest_lib->commit($this->role_id, $quest_id);

        return json_encode($ret, JSON_NUMERIC_CHECK);
    }
}