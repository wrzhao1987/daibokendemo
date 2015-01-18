<?php

class SysTask extends \Phalcon\CLI\Task
{
    public function flushCardDataAction()
    {
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $card_lib = new \Cap\Libraries\CardLib();
        $card_model = new \Cap\Models\Db\UserCardModel();
        $resque_lib = new \Cap\Libraries\ResqueLib();
        foreach ($all_info as $info) {
            $user_id = $info['id'];
            $cards_mysql = $card_model->getByUser($user_id);
            $ids_mysql = array_keys($cards_mysql);
            $cards_redis = $card_lib->getCardList($user_id);
            $ids_redis = array_column($cards_redis, 'ucard_id');
			$ids_redis = array_filter($ids_redis);
            $need_del = array_diff($ids_mysql, $ids_redis);
            if (! empty ($need_del)) {
                foreach ($need_del as $val) {
                    $resque_lib->setJob('card', 'Delete', [
                        'user_id' => $user_id,
                        'ucard_id' => $val,
                    ]);
                }
                echo $user_id . ":" .json_encode(array_values($need_del)) . " handled.\n";
            }
        }
    }

    public function genCodeAction($params = null)
    {
        $gift_box_id = intval($params[0]);
        $count = intval($params[1]);
        $alpha = 'abcdefghijklmnopqrstuvwxyz0123456789';
        $len = strlen($alpha);
        for ($i = 0; $i < $count; $i++) {
            $code = '';
            for ($j = 0; $j < 12; $j++) {
                $pos = mt_rand(0, $len - 1);
                $code .= $alpha[$pos];
            }
            $exchange_model = new \Cap\Models\Db\ExchangeModel();
            $new_code = [
                'code' => $code,
                'gift' => $gift_box_id,
                'get_by' => 0,
                'get_at' => 0,
                'expire' => strtotime('2015-12-21'),
            ];
            $exchange_model->create($new_code);
            echo "{$code}\n";
        }
    }

    public function regrpArenaRobotAction()
    {
        $raw_data = [];
        $rds = $this->getDI()->getShared('redis');
        $arena_lib = new \Cap\Libraries\ArenaLib();
        for ($i = 1; $i <= 5; $i++) {
            $cache_key = sprintf(\Cap\Libraries\ArenaLib::$ROBOT_KEY, $i);
            $robot_ids = $rds->sMembers($cache_key);
            foreach ($robot_ids as $uid) {
                $r_rank = $arena_lib->getRank($uid);
                $raw_data[$uid] = $r_rank;
            }
            echo "Set $i Completed.\n";
        }
        arsort($raw_data);
        echo "Raw Data After Sorting:" . json_encode(array_keys($raw_data)) . "\n";
        $chunks = array_chunk($raw_data, 20, true);
        foreach ($chunks as $offset => $data) {
            echo "Moving " . json_encode(array_keys($data)) . " into $offset.\n";
            $key = sprintf(\Cap\Libraries\ArenaLib::$ROBOT_KEY, $offset + 1) . ":tmp";
            $uids = array_keys($data);
			foreach ($uids as $val) {
				$rds->sAdd($key, $val);
			}
        }
    }
}
