<?php 
namespace Cap\Models\Config;

class BaseConfig
{
	public $config;
	public $config_path;

	public function __construct()
	{
		require __DIR__."/data/".$this->config_path;
		//global $config
		$this->config = $config;
		$this->_di = \Phalcon\DI::getDefault();
	}

	public function getAll()
	{	
		return $this->config;
	}
	
	public function getById($id)
	{
		return $this->config[$id];
	}
	
	public function getAllIds()
	{
		$ids = array();
		foreach ($this->config as $id => $data) {
			$ids[] = $data;
		}
		return $ids;
	}
}
