<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-2
 * Time: 下午7:46
 */
use Cap\Libraries\GuildLib;
use Cap\Libraries\CardLib;
use Cap\Models\Db\GuildModel;
use Cap\Models\Db\GuildMemberModel;


class GuildTask extends \Phalcon\CLI\Task
{
    public function updateRankAction()
    {
        $cache_key = GuildLib::$CACHE_KEY_GUILD_STRENGTH_RANK;
		$cache_key_tmp = GuildLib::$CACHE_KEY_GUILD_STRENGTH_RANK . ":tmp";
        $redis = $this->getDI()->getShared('redis');
        $card_lib = new CardLib();
        foreach (GuildModel::find() as $guild) {
            $strength = 0;
            $gname = $guild->name;
            $gid = $guild->id;
            foreach (GuildMemberModel::find("gid = $gid") as $member) {
                $uid = $member->uid;
                $deck_overview = $card_lib->getDeckCardsOverview($uid);
                foreach ($deck_overview as $card) {
                    if (is_array($card)) {
                        $strength += $card['strength'];
                    }
                }
            }
            $redis->zAdd($cache_key_tmp, $strength, $gid);
            echo "Updated Guild $gid($gname)'s strength to $strength.\n";
        }
		$redis->rename($cache_key_tmp, $cache_key);
        $ret = $redis->zRevRange($cache_key, 0, 49, true);
        $total = [];
        $guild_model = new GuildModel();
		echo "Adding " . json_encode(array_keys($ret)) . " to detail rank.\n";
        foreach ($ret as $gid => $strength) {
            $g_info = $guild_model->getByGid($gid);
            if ($g_info) {
                $total[$gid]['name'] = $g_info['name'];
                $total[$gid]['level'] = $g_info['level'];
                $total[$gid]['icon'] = $g_info['icon'];
                $total[$gid]['strength'] = $strength;
			} else {
				echo "$gid has no info.\n";
			}
        }
        $redis->set(GuildLib::$CACHE_KEY_GUILD_STRENGTH_RANK_DETAIL, json_encode($total, JSON_NUMERIC_CHECK));
        echo "Job's done." . date('Y-m-d H:i:s') . "\n";
    }

    public function truncateCacheAction()
    {
        $redis = $this->getDI()->getShared('redis');
        $keys = $redis->keys("nami:guild:*");
        foreach ($keys as $key) {
            $redis->del($key);
        }
    }
}
