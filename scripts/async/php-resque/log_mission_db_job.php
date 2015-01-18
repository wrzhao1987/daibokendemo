<?php
require_once 'BaseMongoDBJob.php';

class LogMissionDBJob extends BaseMongoDBJob
{
	public $db_collection = "log_mission";
}
