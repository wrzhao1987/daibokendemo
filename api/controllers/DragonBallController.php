<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-3-11
 * Time: 上午10:04
 */
namespace Cap\Controllers;

use Cap\Libraries\DragonBallLib;
use Cap\Libraries\UserLib;
use Phalcon\Exception;

class DragonBallController extends AuthorizedController {

    public static $ACCEPT_FIELDS = array(
        'fragments'=> 1,
        'balls'=> 2
    );

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('dragon_ball_lib', function() {
            return new DragonBallLib();
        }, true);
    }

    public function listAction()
    {
        $data = $this->request->getPost('data');
        if (!$data) {
            return json_encode(array('code'=>400, 'msg'=>'data required'));
        }
        $obj = json_decode($data, true);
        if (!$obj || !is_array($obj)) {
            return json_encode(array('code'=>400, 'msg'=>"invalid parameters from $data"));
        }
        $role_id = $this->session->get('role_id');
        $db_lib = $this->getDI()->getShared('dragon_ball_lib');
        $res = array('code'=>200);
        foreach ($obj as $field=>$v) {
            if (!isset(self::$ACCEPT_FIELDS[$field])) {
                syslog(LOG_INFO, "dragon list action: skip unknown field $field");
                continue;
            }
            $k = self::$ACCEPT_FIELDS[$field];
            switch ($k) {
            case 1:
                $r = $db_lib->getFragments($role_id, true);
                break;
            case 2:
                $r = $db_lib->getByUser($role_id);
                break;
            default:
                $r = 'not implemented';
                break;
            }
            if ($r===false) {
                $res['code'] = 500;
                $res['msg'] = "fail to fetch $field";
                break;
            }
            $res[$field] = $r;
        }

        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function expUpAction()
    {
        $db_lib = $this->getDI()->getShared('dragon_ball_lib');
        $udb_id = $this->request_data['udb_id'];
        $exp    = $this->request_data['exp'];
        $role_id = $this->session->get('role_id');
        $result = $db_lib->addExp($role_id, $udb_id, $exp);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

    public function eatAction()
    {
        $udb_id  = $this->request_data['udb_id'];
        $eat_ids = $this->request_data['eat_ids'];
        if (intval($udb_id) <=0 || ! is_array($eat_ids)) {
            throw new Exception("Invalid Parameters", ERROR_CODE_PARAM_INVALID);
        }
        $db_lib = $this->getDI()->getShared('dragon_ball_lib');
        $result = $db_lib->eat($this->role_id, $udb_id, $eat_ids);
        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

    public function composeAction()
    {
        $db_lib = $this->getDI()->getShared('dragon_ball_lib');
        $dragon_ball_id = intval($this->request_data['db_id']);
        $role_id = $this->session->get('role_id');
        $compose_result = $db_lib->synthesize($role_id, $dragon_ball_id);

        return json_encode(['result' => $compose_result], JSON_NUMERIC_CHECK);
    }
}

// end of file
