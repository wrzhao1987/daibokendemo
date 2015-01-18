<?php
namespace Cap\Models\Db;

class EmailModel extends BaseModel
{
	public function getSource()
	{
		return 'email';
	}

	public $sql_array = array(
		'find_by_id'   => 'SELECT * from __TABLE_NAME__ WHERE id = :id:',
		'create_table' => 'CREATE TABLE `email` (
		  `email` varchar(200) NOT NULL,
		  `secret_code` varchar(100) NOT NULL,
		  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `created_at` datetime NOT NULL,
		  PRIMARY KEY (`email`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8',
	);
}
