<?php

namespace Cap\Controllers;

class AuthorizedController extends BaseController {

    public function onConstruct() {
        parent::onConstruct();
        $this->role_id = $this->session->get('role_id');
        if (empty ($this->role_id)) {
            echo json_encode(array('code'=> 401, 'desc'=>'unauthorized operation'));
            exit(0);
        }
    }
}
