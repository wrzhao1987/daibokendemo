<?php 
namespace Cap\Controllers;

use Phalcon\Mvc\Controller;
use Phalcon\DI;

class BaseController extends Controller
{
	public $_di;
    protected $request_data;
    protected $role_id;
	public function onConstruct()
	{
		$this->_di = DI::getDefault();
        if ($this->request->getPost('data')) {
            $this->request_data = json_decode($this->request->getPost('data'), true);
        }
	}

    /*
     * check existence of request parameters
     */
    protected function checkParameter($required_fields) {
        $data = $this->request->getPost('data');
        if (!$data) {
            return json_encode(array('code'=>'400', 'desc'=>'data required'));
        }
        $obj = json_decode($data, true);
        if (!$obj) {
            return json_encode(array('code'=>'400', 'desc'=>'data should be an valid json object'));
        }
        foreach ($required_fields as $field) {
            if (!isset($obj[$field])) {
                return json_encode(array('code'=>'400', 'desc'=>"param missed or invalid: $field"));
            }
        }
        $this->request_data = $obj;
        return true;
    }
}
