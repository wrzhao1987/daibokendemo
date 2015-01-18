<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-11-10
 * Time: 下午3:48
 */
namespace Cap\Models\Db;

class KpiJoinModel extends BaseModel
{
    public $ts;

    public function getSource()
    {
		if ($this->ts) {
			$date = date('Ymd', $this->ts);
		} else {
			$date = date('Ymd');
		}
        return 'sys_join_' . $date;
    }

    public function createJoinRec($user_id, $type, $user_level, $time = null)
    {
        $this->ts = $time ? $time : time();
        $sql = "INSERT INTO __TABLE_NAME__ (user_id, type, user_level, created_at)
                VALUES ('$user_id', '$type', '$user_level', '$time')";
        $result = $this->executeSQL($sql, []);
        return $result->success();
    }

    public function getRec($ts = null)
    {
        $this->ts = $ts ? $ts : time();
        $sql = "SELECT * FROM __TABLE_NAME__";
        $result = $this->executeSQL($sql, []);
        return $result->count() ? $result->toArray() : [];
    }
}
