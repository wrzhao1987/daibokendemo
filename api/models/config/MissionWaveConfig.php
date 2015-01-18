<?php 
namespace Cap\Models\Config;

class MissionWaveConfig extends BaseCacheConfig
{
	public $config_path = "mission/wave.php";

	public function getSource() {
		return "cf:wave";
	}
}
