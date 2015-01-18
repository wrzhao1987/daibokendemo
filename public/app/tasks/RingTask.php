<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14/11/27
 * Time: 下午12:40
 */
class RingTask extends \Phalcon\CLI\Task
{
    public function updateRankAction()
    {
        $rds = $this->getDI()->getShared('redis');
        $keys = $rds->keys('nami:contest:ustatus:*');
        $user_lib = new \Cap\Libraries\UserLib();
        $card_lib = new \Cap\Libraries\CardLib();
        $c_lib = new \Cap\Libraries\ContestLib();
        foreach ($keys as $val) {
            $val_arr = explode(':', $val);
            $uid = $val_arr[3];
            $user = $user_lib->getUser($uid);
            $user_lvl = $user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LEVEL];
            $info = $rds->hGetAll($val);
            $today_honor = $info[\Cap\Libraries\ContestLib::$USTATUS_FILED_HONOR_TODAY];
            $user_grp = $c_lib->getGroup($user_lvl);
            $rank_key = sprintf(\Cap\Libraries\ContestLib::$CACHE_KEY_RANK, $user_grp);
            $tmp_key = $rank_key . ":tmp";
            echo "Adding $uid to $user_grp.\n";
            $rds->zAdd($tmp_key, $today_honor, $uid);
        }
        for($i = 1; $i <= 7; $i++) {
            $key = sprintf(\Cap\Libraries\ContestLib::$CACHE_KEY_RANK, $i);
            $tmp_key = $key . ":tmp";
            $rank = $rds->zRevRange($tmp_key, 0, 9, true);
            $res = [];
            foreach ($rank as $uid => $score) {
                $user = $user_lib->getUser($uid);
                $deck = $card_lib->getDeckCardsOverview($uid);
                $res[$uid]['deck'] = $deck;
                $res[$uid]['level'] = $user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_LEVEL];
                $res[$uid]['name'] = $user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_NAME];
                $res[$uid]['score'] = $score;
            }
			$cache_key = sprintf(\Cap\Libraries\ContestLib::$CACHE_KEY_RANK_DETAIL, $i);
            $rds->set($cache_key, json_encode(array_values($res), JSON_NUMERIC_CHECK));
            echo "Detail Key Set $i:" . json_encode(array_values($res), JSON_NUMERIC_CHECK) . ".\n";
            $rds->rename($tmp_key, $key);
        }
    }
}
