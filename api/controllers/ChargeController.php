<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14/12/4
 * Time: 下午1:58
 */

namespace Cap\Controllers;

use Cap\Libraries\ChargeLib;
use Cap\Models\Db\PayOrderModel;

class ChargeController extends BaseController
{
    public function onConstruct()
    {
        parent::onConstruct();
    }

    public function tbnotifyAction()
    {
        $game_key = 'h5EbRo2LBNl9x@Us5uEbod2AYNkxH@rh';
        $paramArray = array(
            'source'=>'',
            'trade_no'=>'',
            'amount'=>'',
            'partner'=>'',
            'paydes'=>'',//SDK2.4新增字段，传支付说明信息
            'debug'=>0,//是否是测试模式
            'tborder'=>'',//同步平台订单号
            'sign'=>'',
        );
        //参数赋值
        foreach($paramArray as $key =>$data){
            $val = $this->request->getQuery($key);
            if(isset($val)) {
                $paramArray[$key] = $val;
            }
        }
        $str= 'source='.$paramArray['source'].'&trade_no='.$paramArray['trade_no'].'&amount='.$paramArray['amount'].'&partner='.$paramArray['partner'];
//生成 sign 加密串 参数顺序要保持一致
        if(isset($_GET['paydes']) && isset($_GET['debug'])){//SDK 2.4 版本以上(含2.4)paydes 需加入验证
            $str = $str.'&paydes='.$paramArray['paydes'].'&debug='.$paramArray['debug'];
        }
        if(isset($_GET['tborder'])){//sdk 3.1版本（含3.1）tborder需加入验证
            $str = $str.'&tborder='.$paramArray['tborder'];
        }
        $str .= '&key='.$game_key;
        $sign = md5($str);
        syslog(LOG_DEBUG, "TBT_PAY_CALLBACK: Received A callback with paramaters $str");
        if($sign == $paramArray['sign']) {
            $order_model = new PayOrderModel();
            $order = $order_model->getOrderByOrderID($paramArray['trade_no']);
            if ($order) {
                $order_model->updateOrder($paramArray['trade_no'], [
                    'status' => ChargeLib::$ORDER_STATUS_PAID,
                    'debug' => intval($paramArray['debug']),
                    'thr_order' => strval($paramArray['tborder']),
                ]);
                echo json_encode(array('status'=>'success'));
            } else {
                echo json_encode(array('status'=>'error'));
                syslog(LOG_DEBUG, "TBT_PAY_CALLBACK: Order {$paramArray['trade_no']} not exists.");
            }
        } else {
            echo json_encode(array('status'=>'error'));
            syslog(LOG_DEBUG, "TBT_PAY_CALLBACK: Failed to check sign, our is $sign, and their is {$paramArray['sign']}");
        }
    }
}