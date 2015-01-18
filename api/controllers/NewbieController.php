<?php

namespace Cap\Controllers;

class NewbieController extends AuthorizedController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('newbie_lib', function() {
            return new \Cap\Libraries\NewbieLib();
        }, true);
        $this->_di->set('user_lib', function() {
            return new \Cap\Libraries\UserLib();
        }, true);
        $this->_di->set('deck_lib', function() {
            return new \Cap\Libraries\DeckLib();
        }, true);
    }

    /*
     * route: {'controller':'..', 'action':'xx}
     */
    protected function forward($route, $args) {
        $controller = ucwords($route['controller'])."Controller";
        $method = "$route[action]Action";
        $class = "\\Cap\\Controllers\\$controller";
        $instance = new $class();
        $r = call_user_func(array($instance, $method), $args);
        return $r;
    }

    public function commitAction() {
        if (($r=$this->checkParameter(['step']))!==true) {
            return $r;
        }
        $data = $this->request_data;
        $step = $data['step'];
        $role_id = $this->session->get('role_id');

        # possible deck update
        if (isset($data['deck_update'])) {
            $deck_lib = $this->_di->getShared('deck_lib');
            syslog(LOG_DEBUG, "newbie step $step update deck");
            $deck_lib->updateDeckFormation($role_id, DECK_TYPE_PVE, $data['deck_update']);
        }

        $user_lib = $this->_di->getShared('user_lib');
        $user = $user_lib->getUser($role_id);
        $saved_step = isset($user['newbie'])? $user['newbie']:0;
        if ($step <= $saved_step) {
            return json_encode(array('code'=> 403, 'msg'=> 'already passed step'));
        } else if ($step > $saved_step + 1) {
            return json_encode(array('code'=> 403, 'msg'=> 'not opened yet'));
        }

        $newbie_lib = $this->_di->getShared('newbie_lib');
        $res = $newbie_lib->finishStep($role_id, $step);
        if (isset($res['forward'])) {
            $fres = $this->forward($res['forward'], array());
            unset($res['forward']);
            $res = array_merge($res, json_decode($fres, true));
        }
        return json_encode($res, JSON_NUMERIC_CHECK);
    }
}

// end of file
