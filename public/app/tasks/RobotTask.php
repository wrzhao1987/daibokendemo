<?php

class RobotTask extends \Phalcon\CLI\Task
{
    public static $NEWBIE_TEMPLATES = [
        1 => [
            'hero' => [1, 3, 2, 4, 5, 6],
            'form' => [1 => 5, 2 => 8, 3 => 1, 4 => 2, 5 => 3, 6 => 4],
        ],
        2 => [
            'hero' => [4, 5, 6, 15, 11, 12],
            'form' => [1 => 2, 2 => 5, 3 => 4, 4 => 1, 5 => 3, 6 => 6],
        ],
        3 => [
            'hero' => [2, 7, 8, 9, 10, 13],
            'form' => [1 => 5, 2 => 2, 3 => 1, 4 => 3, 5 => 4, 6 => 6],
        ],
        4 => [
            'hero' => [9, 10, 13, 14, 15, 20],
            'form' => [1 => 1, 2 => 6, 3 => 8, 4 => 4, 5 => 2, 6 => 3],
        ],
        5 => [
            'hero' => [7, 8, 19, 24, 1, 3],
            'form' => [1 => 2, 2 => 5, 3 => 6, 4 => 4, 5 => 1, 6 => 3],
        ],
        6 => [
            'hero' => [11, 12, 24, 7, 6, 15],
            'form' => [1 => 6, 2 => 4, 3 => 1, 4 => 3, 5 => 2, 6 => 5],
        ],
        7 => [
            'hero' => [18, 19, 20, 4, 1, 15],
            'form' => [1 => 1, 2 => 4, 3 => 5, 4 => 2, 5 => 3, 6 => 6],
        ],
        8 => [
            'hero' => [22, 24, 25, 1, 2, 3],
            'form' => [1 => 4, 2 => 6, 3 => 8, 4 => 1, 5 => 2, 6 => 3],
        ],
        9 => [
            'hero' => [6, 10, 22, 23, 27, 31],
            'form' => [1 => 1, 2 => 3, 3 => 2, 4 => 6, 5 => 5, 6 => 4],
        ],
        10 => [
            'hero' => [26, 25, 29, 28, 20, 6],
            'form' => [1 => 5, 2 => 1, 3 => 2, 4 => 3, 5 => 4, 6 => 6],
        ],
        11 => [
            'hero' => [32, 14, 13, 9, 10, 16],
            'form' => [1 => 8, 2 => 5, 3 => 3, 4 => 1, 5 => 4, 6 => 2],
        ],
        12 => [
            'hero' => [4, 5, 11, 12, 15, 18],
            'form' => [1 => 2, 2 => 6, 3 => 4, 4 => 5, 5 => 1, 6 => 3],
        ],
        13 => [
            'hero' => [7, 8, 16, 17, 31, 33],
            'form' => [1 => 2, 2 => 8, 3 => 9, 4 => 4, 5 => 6, 6 => 5],
        ],
        14 => [
            'hero' => [24, 26, 30, 1, 2, 3],
            'form' => [1 => 4, 2 => 5, 3 => 6, 4 => 1, 5 => 2, 6 => 3],
        ],
        15 => [
            'hero' => [8, 14, 23, 7, 8, 21],
            'form' => [1 => 4, 2 => 5, 3 => 6, 4 => 1, 5 => 2, 6 => 3],
        ],
        16 => [
            'hero' => [1, 4, 7, 22, 27, 32],
            'form' => [1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 6, 6 => 5],
        ],
        17 => [
            'hero' => [33, 31, 10, 23, 22, 26],
            'form' => [1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 6, 6 => 5],
        ],
        18 => [
            'hero' => [16, 17, 18, 19, 24, 26],
            'form' => [1 => 1, 2 => 3, 3 => 2, 4 => 4, 5 => 6, 6 => 8],
        ],
        19 => [
            'hero' => [25, 30, 22, 1, 3, 14],
            'form' => [1 => 5, 2 => 1, 3 => 3, 4 => 4, 5 => 6, 6 => 8],
        ],
        20 => [
            'hero' => [18, 28, 29, 26, 14, 8],
            'form' => [1 => 1, 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6],
        ],
    ];
    public function newbieAction($params = null)
    {
        // 加载一些配置
        $srv_conf = $this->getDI()->get('config');
        $server_id = $srv_conf['server_id'];
        $user_lvl_conf = \Cap\Libraries\BaseLib::getGameConfig('user_level');
        $robot_num = intval($params[0]);
        $min_level = isset($params[1]) ? intval($params[1]) : 6;
        $max_level = isset($params[2]) ? intval($params[2]) : 10;
        ////////////////
        for ($i = 0; $i < $robot_num; $i++) {
            // 随机选出一个阵容配置
            $content = array_rand(self::$NEWBIE_TEMPLATES);
            $content = self::$NEWBIE_TEMPLATES[$content];
            // 创建account
            $acct_id = $this->createAccount();
            if (! $acct_id) {
                echo "Failed to add account";
                continue;
            }
            // 创建角色
            $role_id = $this->createRole($acct_id, $server_id);
            if (! $role_id) {
                echo "Failed to create role";
                continue;
            }
            $result = $this->initRole($acct_id, $role_id);
            if (! $result) {
                echo "Failed to init role";
                continue;
            }
            // 为角色升级
            $role_level = mt_rand($min_level, $max_level);
            $this->roleToLevel($role_id, $role_level);
            // 为角色添加卡牌
            $card_lvl_lmt = $user_lvl_conf['level_config'][$role_level]['card_level_limit'];
            $cards = $content['hero'];
            $this->addDeck($role_id, $cards, $card_lvl_lmt - 5, $card_lvl_lmt);
            // 为角色更改PVP阵型
            $form = $content['form'];
            $this->modForm($role_id, \Cap\Libraries\DeckLib::$DECK_TYPE_PVP, $form);
            // 为角色激活PVP
            $this->activePvp($role_id, $i);
        }
    }

    public function crusadeAction($params = null)
    {
        // 加载一些配置
        $srv_conf = $this->getDI()->get('config');
        $server_id = $srv_conf['server_id'];
        $user_lvl_conf = \Cap\Libraries\BaseLib::getGameConfig('user_level');
        $robot_num = intval($params[0]);
        $min_level = 27;
        $max_level = 42;
        for ($i = 0; $i < $robot_num; $i++) {
            // 随机选出一个阵容配置
            $content = array_rand(self::$NEWBIE_TEMPLATES);
            $content = self::$NEWBIE_TEMPLATES[$content];
            // 创建account
            $acct_id = $this->createAccount();
            if (! $acct_id) {
                echo "Failed to add account";
                continue;
            }
            // 创建角色
            $role_id = $this->createRole($acct_id, $server_id);
            if (! $role_id) {
                echo "Failed to create role";
                continue;
            }
            $result = $this->initRole($acct_id, $role_id);
            if (! $result) {
                echo "Failed to init role";
                continue;
            }
            // 为角色升级
            $role_level = mt_rand($min_level, $max_level);
            $this->roleToLevel($role_id, $role_level);
            // 为角色添加卡牌
            $card_lvl_lmt = $user_lvl_conf['level_config'][$role_level]['card_level_limit'];
            $cards = $content['hero'];
            $this->addDeck($role_id, $cards, $card_lvl_lmt - 5, $card_lvl_lmt);
            // 为角色更改PVP阵型
            $form = $content['form'];
            $this->modForm($role_id, \Cap\Libraries\DeckLib::$DECK_TYPE_PVP, $form);
            // 为角色激活PVP
            $this->activeCrusade($role_id, $role_level);
        }
    }

    private function createAccount()
    {
        $email = uniqid("robot_", true) . "@namirobot.com";
        $password = '123456';
        $account_lib = new \Cap\Libraries\AccountLib();
        $result = $account_lib->saveAccountEmailPassword($email, $password);
        if ($result['result'] === true) {
            $acct_id = $result['acct_id'];
            return $acct_id;
        } else {
            return false;
        }
    }

    private function createRole($account_id, $server_id)
    {
        $acct_lib = new \Cap\Libraries\AccountLib();
        $result = $acct_lib->createRole($account_id, $server_id);
        return isset ($result['role_id']) ? $result['role_id'] : false;
    }

    private function initRole($account_id, $role_id)
    {
        $name_lib = new \Cap\Libraries\NameLib();
        $role_name = $name_lib->getNames(1);
        echo "New Role Name is " . $role_name[0] . "\n";
        if (is_string($role_name[0])) {
            $acct_lib = new \Cap\Libraries\AccountLib();
            $result = $acct_lib->initRole($account_id, $role_id, $role_name[0]);
            if ($result['result']===true) {
                $name_lib->removeName($role_name[0]);
                return true;
            } else {
                echo $result['message'] . "\n";
                return false;
            }
        } else {
            return false;
        }
    }

    private function roleToLevel($role_id, $level)
    {
        $user_lib = new \Cap\Libraries\UserLib();
        $user_info = $user_lib->getUser($role_id);
        $user_exp = $user_info[\Cap\Libraries\UserLib::$USER_PROF_FIELD_EXP];
        $level_conf = $user_lib->getGameConfig('user_level');
        $to_exp = $level_conf["level_exp_boundary"][$level] - 1;
        $delta = $to_exp - $user_exp;
        $user_lib->addExp($role_id, $delta);
    }

    private function addDeck($role_id, $card_ids, $min_level, $max_level)
    {
        $card_lib = new \Cap\Libraries\CardLib();
        foreach ($card_ids as $val) {
            $c_lvl = mt_rand($min_level, $max_level);
            $card_lib->addCard($role_id, $val, $c_lvl);
        }
    }

    private function modForm($role_id, $type, $form)
    {
        $deck_lib = new \Cap\Libraries\DeckLib();
        $deck_lib->updateDeckFormation($role_id, $type, $form);
    }

    private function activePvp($role_id, $order)
    {

        $arena_lib = new \Cap\Libraries\ArenaLib();
        $arena_lib->getRank($role_id);

        $order = 5 - intval($order / 5);
        $cache_key = sprintf(\Cap\Libraries\ArenaLib::$ROBOT_KEY, $order);
        $redis = $this->getDI()->getShared('redis');
        $redis->sAdd($cache_key, $role_id);
    }

    private function activeCrusade($role_id, $level)
    {
        $cache_key = \Cap\Libraries\CrusadeLib::$CACHE_KEY_CRUSADE_ROBOTS;
        $redis = $this->getDI()->getShared('redis');
        $redis->zAdd($cache_key, $level, $role_id);
    }
}