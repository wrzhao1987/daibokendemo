<?php 
namespace Cap\Models\Mongodb;

class LogMissionMongoModel extends BaseMongoModel
{
	public function getSource()
	{
		return "log_mission";
	}
}
