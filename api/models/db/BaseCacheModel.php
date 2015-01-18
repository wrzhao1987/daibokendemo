<?php 
namespace Cap\Models\Db;

class BaseCacheModel extends BaseModel
{
	public $redis_host;
	public $redis_port;
	public $redis_ttl;
	public $store_cols;

	public function onConstruct()
	{
		parent::onConstruct();

		$config = \Phalcon\DI::getDefault()->get('config');
		if(is_null($this->redis_host)) {
			$this->redis_host = $config['redis']->default->host;
		}
		if (is_null($this->redis_port)) {
			$this->redis_port = $config['redis']->default->port;
		}
	}

	public function get($id, $ex_redis = false)
	{
		$name_space = $this->getSource();
		if ($ex_redis == false) {
			$redis = new \redis();
			$redis->connect($this->redis_host, \intval($this->redis_port));
		} else {
			$redis = $ex_redis;
		}

		$hash = "${name_space}:${id}";
		//$data = $redis->hgetall($hash);
		$data = $redis->get($hash);
		if ($data === false) {
			$rows = $this->getById($id);

			if (!empty($rows)) {
				$data = array();
				foreach ($rows as $row) {
					$item = array();
					foreach ($this->store_cols as $col) {
						$item[$col] = $row->{$col};
					}
					$data[] = $item;
				}
				if (count($data) == 1) {
					$data = $data[0];
				}
				$data = json_encode($data);
				//$redis->hmset($hash, $data);
				$redis->set($hash, $data);
				if (!is_null($this->redis_ttl)) {
					$redis->expire($hash, $this->redis_ttl);
				}
			} else {
				$data = false;
			}
		}
		$data = json_decode($data);
		if ($ex_redis == false) {
			$redis->close();
		}
		return $data;
	}

	public function getByIds($ids) {

		$name_space = $this->getSource();

		$redis = new \redis();
		$redis->connect($this->redis_host, \intval($this->redis_port));
		
		$hash = "${name_space}:${id}";
		$data = $redis->get($hash);
		if ($data === false) {
			$rows = $this->getById($id);
		
			if (!empty($rows)) {
				$data = array();
				foreach ($rows as $row) {
					$item = array();
					foreach ($store_cols as $col) {
						$item[] = array($col=>$row->{$col});
					}
					$data[] = $item;
				}
				if (count($data) == 1) {
					$data = $data[0];
				}
				$data = json_encode($data);
				$redis->set($hash, $data);
				if (!is_null($this->redis_ttl)) {
					$redis->expire($hash, $this->redis_ttl);
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
		$redis->connect($this->redis_host, \intval($this->redis_port));
		$redis->delete("${name_space}:${id}");
		$redis->close();
	}
	
	public function clearAllCache()
	{
		$redis = new \redis();
		$name_space = $this->getSource();
		$redis->connect($this->redis_host, \intval($this->redis_port));
		$ids = $this->getAllIds();
		foreach ($ids as $item) {
			$redis->delete($name_space + ":" + $item->id);
		}
		$redis->close();
	}

	public function updateBy($sql_key, $params)
	{
		if (!isset($params['id'])) {
			return false;
		}
		$id = $params['id'];

		$result = $this->execute($sql_key, $params);
		if ($result) {
			$this->clearCache($id);
			$this->get($id);
		}
		return $result;
	}

	public function updateSql($sql, $params)
	{
		if (!isset($params['id'])) {
			return false;
		}
		$id = $params['id'];
		
		$result = $this->executeSql($sql_key, $params);
		if ($result) {
			$this->clearCache($id);
			$this->get($id);
		}
		return $result;
	}
}
