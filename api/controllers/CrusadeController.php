<?php
namespace Cap\Controllers;
use Cap\Libraries\CrusadeLib;
use Phalcon\Exception;

class CrusadeController extends AuthorizedController
{
    public function onConstruct()
    {
        parent::onConstruct();
        $this->_di->set('crusade_lib', function() {
            return new CrusadeLib();
        }, true);
    }

    public function statusAction()
    {
        $crusade_lib = $this->getDI()->getShared('crusade_lib');
        $status = $crusade_lib->status($this->role_id);
        return json_encode($status, JSON_NUMERIC_CHECK);
    }

    public function beginAction()
    {
        $crusade_lib = $this->getDI()->getShared('crusade_lib');
        if (! isset($this->request_data['progress'])) {
            throw new Exception('progress is required.', ERROR_CODE_PARAM_INVALID);
        }
        $progress = intval($this->request_data['progress']);
        $deck_form = isset($this->request_data['form']) ? $this->request_data['form'] : '';
        $friend_id = isset ($this->request_data['friend_id']) ? intval($this->request_data['friend_id']) : null;

        $ret = $crusade_lib->begin($this->role_id, $progress, $deck_form, $friend_id);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function commitAction()
    {
        $crusade_lib = $this->getDI()->getShared('crusade_lib');
        if (! isset ($this->request_data['progress'])) {
            throw new Exception('progress is required.', ERROR_CODE_PARAM_INVALID);
        }
        if (! isset ($this->request_data['success'])) {
            throw new Exception('success is required.', ERROR_CODE_PARAM_INVALID);
        }
        $progress = intval($this->request_data['progress']);
        $success = $this->request_data['success'];
        $user_data = isset($this->request_data['user_data']) ? $this->request_data['user_data'] : [];

        $ret = $crusade_lib->commit($this->role_id, $progress, $success, $user_data);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }

    public function resetAction()
    {
        $crusade_lib = $this->getDI()->getShared('crusade_lib');
        $ret = $crusade_lib->reset($this->role_id);
        return json_encode($ret, JSON_NUMERIC_CHECK);
    }
}