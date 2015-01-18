<?php

namespace Cap\Controllers;

class ConfigController extends BaseController {


    public static $CONFIG_PATH = "../../config/game/";
    public static $ALLOWED_CONFIGS = array(
        "newbie_guide", 
        "store_goods", 
        "login_bonus_01",
        "login_bonus_02",
        "login_bonus_03",
        "login_bonus_04",
        "login_bonus_05",
        "login_bonus_06",
        "login_bonus_07",
        "login_bonus_08",
        "login_bonus_09",
        "login_bonus_10",
        "login_bonus_11",
        "login_bonus_12"
    );

    private function readConfig($file) {
        $full_path = self::$CONFIG_PATH.$file;
        $content = preg_replace('/^\s*(#|(\/\/))[^\n]+/m', "", file_get_contents($full_path));
        return $content;
    }

    public function store_goodsaction() {
        return $this->readConfig('store_goods.json');
    }

    public function __call($method, $args) {
        if (preg_match('/^(.+)Action$/', $method, $matches)) {
            $config_name = $matches[1];
            if (in_array($config_name, self::$ALLOWED_CONFIGS)) {
                return $this->readconfig("$config_name.json");
            }
            return "config not availavle";
        } else {
            return "invalid method";
        }
    }
}
