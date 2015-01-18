<?php
require_once 'BaseShardAvgDBJob.php';

class UserMissionDBJob extends BaseShardAvgDBJob
{
	public $db_table = "user_mission";
	public $db_queries = array(
		'update_star' => 'UPDATE __TABLE_NAME__ SET star = :star:, count = count+1 WHERE id = :id: AND chpater_mission_id = :chapter_mission_id:',
		'create' => 'INSERT INTO __TABLE_NAME__ (id, chapter_mission_id, created_at) VALUES (:id:, :chapter_mission_id:, now())');
}
