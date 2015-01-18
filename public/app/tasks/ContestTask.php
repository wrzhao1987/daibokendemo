<?php

class ContestTask extends \Phalcon\CLI\Task
{
    public function expireAction()
    {
        $c_lib = new \Cap\Libraries\ContestLib();
        $rds = $this->getDI()->getShared('redis');
        for($i = 1; $i < 7; $i++) {
			echo "Handling Group $i.\n";
            $join_key = sprintf(\Cap\Libraries\ContestLib::$CACHE_KEY_RING_JOIN, $i);
            $all_info = $rds->sMembers($join_key);
            foreach ($all_info as $uid) {
                $sts = $c_lib->userStatus($uid);
                /**
                $grp = $sts['status'][\Cap\Libraries\ContestLib::$USTATUS_FIELD_GROUP];
                $id_in_grp = $sts['status'][\Cap\Libraries\ContestLib::$USTATUS_FIELD_ID_IN_GROUP];
                $b_log = $sts['status'][\Cap\Libraries\ContestLib::$USTATUS_FIELD_BATTLE_LOG];
                $count_log = count($b_log);
                if (($grp == 0) && ($id_in_grp == 0)) {
                    if ($count_log) {
                        $last_log = $b_log[$count_log - 1];
                        $last_log_type = $last_log['type'];
                        if ($last_log_type != \Cap\Libraries\ContestLib::$LOG_TYPE_DEF_TIMEOUT) {
                            $c_lib->log($uid, 0, '', \Cap\Libraries\ContestLib::$LOG_TYPE_DEF_TIMEOUT, 0, 0);
                            echo "User $uid has problem.\n";
                        }
                    } else {
                        $c_lib->log($uid, 0, '', \Cap\Libraries\ContestLib::$LOG_TYPE_DEF_TIMEOUT, 0, 0);
                        echo "User $uid has problem.\n";
                    }
                }
                 * **/
            }
        }
        $keys = $rds->keys('nami:ring:set:*');
        foreach ($keys as $val) {
            $rds->del($val);
        }
    }

	public function delKeysAction()
	{
		$rds = $this->getDI()->getShared('redis');
		$keys = $rds->keys('nami:contest:*');
		foreach ($keys as $val) {
			$rds->del($val);
			echo "$val deleted.\n";
		}
	}
}
