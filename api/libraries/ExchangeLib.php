<?php
namespace Cap\Libraries;

use Cap\Models\Db\ExchangeModel;
use Phalcon\Exception;

class ExchangeLib extends BaseLib
{
    public function __construct() {
        parent::__construct();
        $this->_di->set('exchange_model', function () {
            return new ExchangeModel();
        }, true);
        $this->_di->set('item_lib', function () {
            return new ItemLib();
        }, true);
    }

    public function useCode($user_id, $code)
    {
        $exchange_model = $this->getDI()->getShared('exchange_model');
        $info = $exchange_model::findFirst("code = '{$code}'");
        if ($info) {
            $expire = $info->expire;
            $now = time();
            if ($expire > $now && (empty ($info->get_by))) {
                $gift_box = $info->gift;
                $get = $exchange_model::findFirst("get_by = '{$user_id}' and gift = '{$gift_box}'");
                if ($get) {
                    throw new Exception("每位玩家同类型礼包兑换码只能使用一次.");
                }
                $item_lib = $this->_di->getShared('item_lib');
                $gift_content = self::getGameConfig('gift_box')[$gift_box]['content'];
                $content  = $item_lib->unpackGiftBox($user_id, $gift_content);
                $info->get_by = $user_id;
                $info->get_at = $now;
                $info->save();
                return ['code' => ERROR_CODE_OK, 'content' => $content];
            } else {
                throw new Exception("该兑换码已过期.", ERROR_CODE_FAIL);
            }
        } else {
            throw new Exception("无效的兑换码.", ERROR_CODE_FAIL);
        }
    }
}