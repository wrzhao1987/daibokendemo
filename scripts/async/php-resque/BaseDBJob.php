<?php 
require "config.php";

class BaseDBJob
{
	public $db_host;
	public $db_user;
	public $db_passwd;

	public $db_name;
	public $db_table;
	public $db_queries;

	public function __construct() {
		global $settings;
		$this->db_host = $settings['database']['default']['host'];
		$this->db_user = $settings['database']['default']['username'];
		$this->db_passwd = $settings['database']['default']['password'];
		$this->db_name = $settings['database']['default']['dbname'];
	}
	
	public function getTable() {
		return $this->db_table;
	}

	public function perform() {
		// connect db
		$connect = mysqli_connect(
				$this->db_host,
				$this->db_user,
				$this->db_passwd,
				$this->db_name);

		if (!$connect) {
			printf("Can't connect to MySQL Server. Errorcode: %s ", mysqli_connect_error());
			exit;
		}

		// sql
		$action = $this->args['action'];
		$sql = $this->db_queries[$action];

		$params = $this->args['params'];
		foreach ($params as $key=>$val) {
			if (is_array($val)) {
				$params[$key] = implode(",", $val);
			}
			if (!is_int($val)) {
				$val = "'$val'";
			}
			$sql = str_replace(":$key:", $val, $sql);
		}
		$sql = str_replace("__TABLE_NAME__", $this->getTable(), $sql);
		echo "$sql\n";
		// execute
		
		if ($result = mysqli_query($connect, $sql)) {
			// log
		} else {
			// log
			var_dump($sql);
		}

		// close db
		mysqli_close($connect);
	}
}
