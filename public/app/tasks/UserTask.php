<?php

class UserTask extends \Phalcon\CLI\Task
{
    public function addExpAction(array $params)
    {
        $user_lib = new \Cap\Libraries\UserLib();
        $user_id    = $params[0];
        $exp_amount = $params[1];
		$user_lib->getUser($user_id);
		$user_lib->addExp($user_id, $exp_amount);
		echo "{$user_id} add {$exp_amount} exp.\n";
	}


    public function toLevelAction(array $params)
    {
        $user_lib = new \Cap\Libraries\UserLib();
        $user_id  = intval($params[0]);
        $to_level = intval($params[1]);
        $user_info = $user_lib->getUser($user_id);
        $user_level = $user_info[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LEVEL];
        $user_exp = $user_info[\Cap\Libraries\UserLib::$USER_PROF_FIELD_EXP];
        $level_conf = $user_lib->getGameConfig('user_level');
        if ($to_level <= $user_level) {
            echo "Can't set level to a lower one.";
            exit(-1);
        }
        $to_exp = $level_conf["level_exp_boundary"][$to_level] - 1;
        $delta = $to_exp - $user_exp;
        $user_lib->addExp($user_id, $delta);
        echo "Ok";
    }

    public function addSoulAction(array $params)
    {
        $user_id = intval($params[0]);
        $delta   = intval($params[1]);
        if ($user_id > 0 && $delta > 0) {
            $card_lib = new \Cap\Libraries\CardLib();
            $hero_conf = $card_lib->getGameConfig('hero_basic');
            $card_ids = array_keys($hero_conf);
            foreach ($card_ids as $card_id) {
                $card_lib->updateCardPiece($user_id, $card_id, $delta);
                echo "{$user_id} added card {$card_id} {$delta} pieces.\n";
            }
        }
    }

    public function addDBallAction(array $params)
    {
        $user_id = intval($params[0]);
        $dball_lib = new \Cap\Libraries\DragonBallLib();

        for ($i = 1; $i <=7; $i++) {
            for ($j = 0; $j <5; $j++ ) {
                $ret = $dball_lib->newDragonball($user_id, $i);
                echo "Added Dball $i for user {$user_id}.\n";
            }
        }
    }
}
