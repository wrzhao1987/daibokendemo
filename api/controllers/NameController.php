<?php

namespace Cap\Controllers;

use Cap\Libraries\NameLib;
use Cap\Libraries\AccountLib;
use Cap\Libraries\UserLib;
use Cap\Models\Db\UserModel;

class NameController extends BaseController {



    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('name_lib', function () {
            return new NameLib();
        }, true);
        $this->_di->set('acct_lib', function () {
            return new AccountLib();
        }, true);
        $this->_di->set('user_lib', function () {
            return new UserLib();
        }, true);
        $this->_di->set('user_model', function () {
            return new UserModel();
        }, true);
    }

    public function generateAction() {
        $name_lib = $this->_di->get('name_lib');
        $names = $name_lib->getNames(5);
        $res = array(
            'code'=> 200,
            'names'=> $names,
        );
        return json_encode($res, JSON_UNESCAPED_UNICODE);
    }

    public function renameAction() {
        $res = [];
        $role_id = $this->session->get('role_id');
        if (! $role_id) {
            $res = array("code" => 403, "msg" => "尚未登录.");
            return json_encode($res);
        }
        $name = trim($this->request_data['name']);
        $name_lib = $this->getDI()->getShared('name_lib');
        if ($name_lib->isForbidden($name)) {
            $res = array("code"=> 405, "msg"=> "无法使用该用户名");
            return json_encode($res);
        }
        $acct_lib = $this->getDI()->getShared('acct_lib');
        if ($acct_lib->nameExists($name)) {
            $res = array("code"=> 403, "msg"=> "名称已存在");
            return json_encode($res);
        }
        $user_model = $this->getDI()->getShared('user_model');
        $user_lib = $this->getDI()->getShared('user_lib');
        $remain = $user_lib->consumeFieldAsync($role_id, UserLib::$USER_PROF_FIELD_GOLD, 100);
        if ($remain !== false) {
            $db_ret = $user_model->updateFields($role_id, ['name' => $name]);
            // 数据库修改成功
            if ($db_ret) {
                // 更改应用到Redis
                $user_lib->getUser($role_id);
                $rds = $this->_di->getShared('redis');
                $cache_key = sprintf(UserLib::$USER_PROF_KEY, $role_id);
                $rds->hSet($cache_key, UserLib::$USER_PROF_FIELD_NAME, $name);

                // 从名字库中删除该名字
                $name_lib->removeName($name);
                // 设置改名冷却时间
                $cool_down_key = sprintf(NameLib::$CACHE_KEY_RENAME_COOLDOWN, $role_id);
                $rds->set($cool_down_key, 1);
                $rds->expire($cool_down_key, NameLib::$RENAME_COOLDOWN);
                $res = array("code" => 200, "msg" => "OK");
            } else {
                $res = array("code" => 500, "msg" => "内部错误.");
            }
        } else {
            $res = array("code" => 201, "msg" => "索尼币余额不足.");
        }
        return json_encode($res);
    }
}

