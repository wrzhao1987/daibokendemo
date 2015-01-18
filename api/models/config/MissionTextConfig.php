<?php 
namespace Cap\Models\Config;

class MissionDataConfig extends BaseCacheConfig
{
	public $config_path = "mission/data.php";

	public function getSource() {
		return "cf:mission";
	}
}
