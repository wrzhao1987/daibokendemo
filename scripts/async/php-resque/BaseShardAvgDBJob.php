<?php
require_once "BaseDBJob.php";

class BaseShardAvgDBJob extends BaseDBJob
{	
	public function __construct() {
		parent::__construct();
	}

	public $shard_divisor = 100;

	public function getTable() {
		$suffix = $this->id % $this->shard_divisor;
		return "user_mission_$suffix";
	}
	
	public function perform() {
		$params = $this->args['params'];
		if (!isset($params['id'])) {
			printf("id should be given.");
			exit;
		}
		$this->id = $params['id'];
		parent::perform();
	}
}