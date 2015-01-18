<?php 
require "config_mongo.php";

class BaseMongoDBJob
{
	public $db_host;
	public $db_port;
	public $db_user;
	public $db_passwd;

	public $db_name;
	public $db_collection;
	public $db_queries;

	public function __construct() {
		global $settings_mongo;
		$this->db_host = $settings_mongo['default']['host'];
		$this->db_port = $settings_mongo['default']['port'];
		$this->db_user = $settings_mongo['default']['username'];
		$this->db_passwd = $settings_mongo['default']['password'];
		$this->db_name = $settings_mongo['default']['dbname'];
	}

	public function getCollection() {
		return $this->db_collection;
	}

	public function perform() {
		$conn = false;
		try {
			// connect db
			//$conn = new Mongo("mongodb://$this->{db_user}:$this->{db_passwd}@$this->{db_host}");
			$db_host = $this->db_host;
			$conn = new Mongo("mongodb://${db_host}");
			$db = $conn->selectDB($this->db_name);
			$collection = $db->{$this->db_collection};

			// action
			$action = $this->args['action'];
			$params = $this->args['params'];
			if ($action == 'insert') {
				$collection->insert($params['data']);
			} elseif ($action == 'update') {
				$collection->update($params['find'], $params['data']);
			} elseif ($action == 'remove') {
				$collection->remove($params['find']);
			}
			$conn->close();
		} catch (Exception $e) {
			error_log(print_r($e, true));
			if ($conn) {
				$conn->close();
			}
		}
	}
}
