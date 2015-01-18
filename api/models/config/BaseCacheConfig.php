<?php 
namespace Cap\Models\Config;

class BaseCacheConfig extends BaseConfig
{
	public $redis_host;
	public $redis_port;
	public $redis_ttl;

	public function __construct()
	{
		parent::__construct();

		$config = \Phalcon\DI::getDefault()->get('config');
		if(is_null($this->redis_host)) {
			$this->redis_host = $config['redis']->default->host;
		}
		if (is_null($this->redis_port)) {
			$this->redis_port = $config['redis']->default->port;
		}
	}

	public function get($id)
	{
		$name_space = $this->getSource();

		$redis = new \redis();
		$redis->connect($this->redis_host, intval($this->redis_port));

		$hash = "${name_space}:${id}";
		$data = $redis->get($hash);
		if ($data === false) {
			$rows = $this->getById($id);

			if (!empty($rows)) {
				$data = json_encode($rows);
				$redis->set($hash, $data);
				if (!is_null($this->redis_ttl)) {
					$redis->setTimeout($hash, $this->redis_ttl);
				}
			} else {
				$data = false;
			}
		}
		$data = json_decode($data);
		$redis->close();
		return $data;
	}

	public function clearCache($id)
	{
		$redis = new \redis();
		$name_space = $this->getSource();
		$redis->connect($this->redis_host, intval($this->redis_port));
		$redis->delete("${name_space}:${id}");
		$redis->close();
	}
	
	public function clearAllCache()
	{
		$redis = new \redis();
		$name_space = $this->getSource();
		$redis->connect($this->redis_host, intval($this->redis_port));
		$ids = $this->getAllIds();
		foreach ($ids as $item) {
			$redis->delete($name_space + ":" + $item->id);
		}
		$redis->close();
	}

	public function update($sql_key, $params)
	{
		$id = $params['id'];
		if (is_null($id)) {
			return false;
		}
		if (isset($this->sql_array[$sql_key])) {
			$sql = $this->sql_array[$sql_key];
			$class = get_called_class();
			$sql = str_replace("__TABLE_NAME__", $class, $sql);
			$result = $this->getModelsManager()->executeQuery($sql, $params);
			if ($result) {
				$this->clearCache($id);
				$this->get($id);
			}
			return $result;
		} else {
			return false;
		}
	}

}
