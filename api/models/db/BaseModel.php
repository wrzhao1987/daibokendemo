<?php 
namespace Cap\Models\Db;

use Phalcon\Mvc\Model;

class BaseModel extends Model
{
	public $create_table;
	public $sql_array;

	public function onConstruct() {
		$this->skipAttributesOnCreate(array('updated_at'));
		$this->skipAttributesOnUpdate(array('updated_at', 'created_at'));
	}

	public function createTable() {
		return $this->getWriteConnection()->query($this->create_table);
	}

	public function makeSql($sql) {
		$class = get_called_class();
		$sql = str_replace("__TABLE_NAME__", $class, $sql);
		return $sql;
	}

	public function findBy($sql_key, $params = false) {
		if (isset($this->sql_array[$sql_key])) {
			$sql = $this->makeSql($this->sql_array[$sql_key]);
			if ($params === false) {
				return $this->getModelsManager()->executeQuery($sql);
			} else {
				if (is_scalar($params)) {
					return false;
				}
				foreach ($params as $key=>$val) {
					if (is_array($val)) {
						$params[$key] = implode(",", $val);
						// should be escaped before here
						// to get a high performance
						$sql = str_replace(":$key:", $params[$key], $sql);
						unset($params[$key]);
					}
				}
				return $this->getModelsManager()->executeQuery($sql, $params);
			}
		} else {
			return false;
		}
	}

	public function execute($sql_key, $params) {
		if (isset($this->sql_array[$sql_key])) {
			$sql = $this->makeSql($this->sql_array[$sql_key]);
			return $this->getModelsManager()->executeQuery($sql, $params);
		} else {
			return false;
		}
	}

	public function executeSQL($sql, $params) {
		$sql = $this->makeSql($sql);
		return $this->getModelsManager()->executeQuery($sql, $params);
	}

	public function get($id) {
		$sql = $this->makeSql("SELECT * from __TABLE_NAME__ WHERE id = :id:");
		$rlt = $this->getModelsManager()->executeQuery($sql, array("id"=>$id));
		if (count($rlt) == 1) {
			return $rlt[0];
		}
		return $rlt;
	}

	public function getById($id) {
		$sql = $this->makeSql("SELECT * from __TABLE_NAME__ WHERE id = :id:");
		return $this->getModelsManager()->executeQuery($sql, array("id"=>$id));
	}

	public function getAllIds() {
		$ids = array();
		$sql = $this->makeSql("SELECT id from __TABLE_NAME__");
		$data = $this->getModelsManager()->executeQuery($sql);
		foreach ($data as $row) {
			$ids[] = $row->id;
		}
		return $ids;
	}

	public function getAll() {
		$sql = $this->makeSql("SELECT * from __TABLE_NAME__");
		return $this->getModelsManager()->executeQuery($sql, array("id"=>$id));
	}

}

/*
use Redis;
//-------- MEMCACHE USAGE --------//
echo "popActAction start";
//Cache data for one hour
$frontCache = new \Phalcon\Cache\Frontend\Data(array(
		"lifetime" => 3600
));

//Create the Cache setting memcached connection options
$cache = new \Phalcon\Cache\Backend\Memcache($frontCache, array(
		'host' => 'localhost',
		'port' => 11211,
		'persistent' => false
));

//Cache arbitrary data
$cache->save('my-data', array(1, 2, 3, 4, 5));

//Get data
$data = $cache->get('my-data');
var_dump($data);
echo "popActAction end";
*/

/*
 //-------- REDIS USAGE --------//
echo "popActAction start";

//Connect to redis
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);

//Create a Data frontend and set a default lifetime to 1 hour
$frontend = new \Phalcon\Cache\Frontend\Data(array(
		'lifetime' => 3600
));

//Create the cache passing the connection
$cache = new \Phalcon\Cache\Backend\Redis($frontend, array(
		'redis' => $redis
));

//Cache arbitrary data
$cache->save('my-data', array(1, 2, 3, 4, 5));

//Get data
$data = $cache->get('my-data');
var_dump($data);
echo "popActAction end";
*/

