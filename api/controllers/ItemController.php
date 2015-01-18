<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-23
 * Time: 下午2:57
 */
namespace Cap\Controllers;

use Cap\Libraries\ItemLib;

class ItemController extends AuthorizedController
{
    public function onConstruct()
    {
        parent::onConstruct();
        $this->_di->set('item_lib', function() {
            return new ItemLib();
        }, true);
    }

    public function listAction()
    {
        $item_lib = $this->getDI()->getShared('item_lib');
        $result   = $item_lib->listItem($this->role_id, true);
        echo json_encode($result, JSON_NUMERIC_CHECK);
    }

    public function useAction()
    {
        $item_lib = $this->getDI()->getShared('item_lib');

        $item_id  = intval($this->request_data['item_id']);
        $sub_id   = intval($this->request_data['sub_id']);
        $count    = intval($this->request_data['count']);
        $user_card_id = isset ($this->request_data['user_card_id']) ? $this->request_data['user_card_id'] : 0;

        $result = $item_lib->useItem($this->role_id, $item_id, $sub_id, $count, $user_card_id);
        echo json_encode($result, JSON_NUMERIC_CHECK);
    }
}