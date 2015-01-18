<?php
$sql_array = [
	'user_login' => "DROP TABLE IF EXISTS `__TABLE_NAME__`; CREATE TABLE `__TABLE_NAME__` (
		`id` int(11) NOT NULL AUTO_INCREMENT,
			 `account_id` INT(10) UNSIGNED NOT NULL,
			 `server_id` INT(10) UNSIGNED NOT NULL,
			 `user_id` INT(10) UNSIGNED NOT NULL,
			 `uuid` VARCHAR(100) NOT NULL,
			 `login_at` INT(10) NOT NULL,
			 `ip` VARCHAR(100) NOT NULL DEFAULT '',
			 PRIMARY KEY (`id`),
			 KEY `account_id` (`account_id`),
			 KEY `server_id` (`server_id`),
			 KEY `uuid` (`uuid`)  
		)  ENGINE=InnoDB DEFAULT CHARSET=utf8; 
	  ",
];

$mysqli = new mysqli('localhost', 'root', 'namisan', 'nami_account');
$mysqli->query('set names utf8');
$table_num = 100;
$time = time();
foreach ($sql_array as $prefix => $sql) {
	for ($i = 0; $i < $table_num; $i++) {
		$date = date('Ymd', $time + $i * 86400);
		$table_name = $prefix . '_' . $date;
		$query = str_replace('__TABLE_NAME__', $table_name, $sql);
		$mysqli->multi_query($query);
		while ($mysqli->next_result()) {;}
		echo "$table_name completed. --- " . $mysqli->error . "\n";
	}
}
$mysqli->close();
