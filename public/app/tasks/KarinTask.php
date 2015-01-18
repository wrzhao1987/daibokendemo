<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-2
 * Time: 下午7:46
 */
use Cap\Libraries\KarinLib;
use Cap\Libraries\CardLib;
use Cap\Libraries\UserLib;

class KarinTask extends \Phalcon\CLI\Task
{
    public function updateRankAction()
    {
		echo "Start updating karin rank, " . date('Y-m-d H:i:s') . "\n";
        $result = [];
        $redis = $this->getDI()->getShared('redis');
        $user_lib = new UserLib();
        $card_lib = new CardLib();
        if ($redis->exists(KarinLib::$KARIN_RANK_KEY_FLOOR)
            && $redis->exists(KarinLib::$KARIN_RANK_KEY_TIME))
        {
            // 层数的权重远大于通关时间的权重
            $floor_weight = pow(10, 9);
            $time_weight  = 1;
            // 求交集,存入总排行
            $redis->zInter(
                KarinLib::$KARIN_RANK_KEY_TOTAL,
                [KarinLib::$KARIN_RANK_KEY_FLOOR, KarinLib::$KARIN_RANK_KEY_TIME],
                [$floor_weight, $time_weight]
            );
            // 倒序求出前50名
            $top_50 = $redis->zRevRange(KarinLib::$KARIN_RANK_KEY_TOTAL, 0, 49);
            if (! empty ($top_50))
            {
                $level_field = UserLib::$USER_PROF_FIELD_LEVEL;
                foreach ($top_50 as $user_id)
                {
                    $user = $user_lib->getUser($user_id);
                    $user_floor = $redis->zScore(KarinLib::$KARIN_RANK_KEY_FLOOR, $user_id);
                    $user_level = $user[$level_field];
                    $user_deck = $card_lib->getDeckCardsOverview($user_id);
                    $result[$user_id]['user_id']   = $user_id;
                    $result[$user_id]['user_name'] = $user[UserLib::$USER_PROF_FIELD_NAME];
                    $result[$user_id]['floor']     = $user_floor;
                    $result[$user_id]['deck']      = $user_deck;
                    $result[$user_id]['level']     = $user_level;
					echo "Added user {$user_id} to the rank.\n";
                }
                $redis->set(KarinLib::$KARIN_RANK_KEY_DETAILS, json_encode(array_values($result)));
			} else {
				echo "No enough user to generate rank.\n";
			}
		} else {
			echo "Failed to get karin redis keys.\n";
		}
		echo "Job's done." . date('Y-m-d H:i:s') . "\n";
    }
}
