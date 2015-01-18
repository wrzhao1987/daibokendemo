<?php 

namespace Cap\Models\Db;

use Phalcon\Mvc\Model;

class BaseShardAvgModel extends BaseModel
{
	public $shard_divisor = 100;

	public function findBy($sql_key, $params = false)
	{
		if (!isset($params['id'])) {
			return false;
		}
		$this->id = $params['id'];
		return parent::findBy($sql_key, $params = false);
	}

	public function execute($sql_key, $params)
	{
		if (!isset($params['id'])) {
			return false;
		}
		$this->id = $params['id'];
		return parent::execute($sql_key, $params);
	}

	public function executeSql($sql, $params)
	{
		if (!isset($params['id'])) {
			return false;
		}
		$this->id = $params['id'];
		return parent::executeSql($sql, $params);
	}

	public function get($id)
	{
		if (!isset($id)) {
			return false;
		}
		$this->id = $id;
		return parent::get($id);
	}

	public function getById($id)
	{
		if (!isset($id)) {
			return false;
		}
		$this->id = $id;
		return parent::getById($id);
	}

	public function getAllIds()
	{
		$ids = array();
		$sql = $this->makeSql("SELECT id from __TABLE_NAME__");
		for ($i=0; $i<$this->shard_divisor; $i++) {
			$this->id = $i;
			$data = $this->getModelsManager()->executeQuery($sql);
			foreach ($data as $row) {
				$ids[] = $row->id;
			}
		}
		return $ids;
	}

}
