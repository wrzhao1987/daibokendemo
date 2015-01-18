<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-8-14
 * Time: 下午4:43
 */
namespace Cap\Controllers;
use Cap\Models\Db\ExchangeModel;
use Cap\Libraries\ExchangeLib;

class ExchangeController extends AuthorizedController
{
    public function onConstruct()
    {
        parent::onConstruct();
        $this->_di->set("exchange_lib", function() {
            return new ExchangeLib();
        }, true);
    }

    public function useAction()
    {
        if (! isset ($this->request_data['code'])) {
            throw new \Phalcon\Exception("请输入激活码", ERROR_CODE_PARAM_INVALID);
        }
        $code = $this->request_data['code'];
        $exchange_lib = $this->getDI()->getShared('exchange_lib');
        $result = $exchange_lib->useCode($this->role_id, strval($code));

        return json_encode($result, JSON_NUMERIC_CHECK);
    }

    public function generateAction()
    {
        $alpha = 'abcdefghijklmnopqrstuvwxyz0123456789';
        $len = strlen($alpha);
        for ($i = 0; $i < 10000; $i++) {
            $code = '';
            for ($j = 0; $j < 12; $j++) {
                $pos = mt_rand(0, $len - 1);
                $code .= $alpha[$pos];
            }
            $exchange_model = new ExchangeModel();
            $new_code = [
                'code' => $code,
                'gift' => 11,
                'get_by' => 0,
                'get_at' => 0,
                'expire' => strtotime('2014-12-21'),
            ];
            $exchange_model->create($new_code);
            echo "{$code}<br />";
        }
    }
}