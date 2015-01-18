<?php


$sql_array = [
	'worship_log' => "DROP TABLE IF EXISTS `__TABLE_NAME__`; CREATE TABLE `__TABLE_NAME__` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `user_id` int(11) NOT NULL,
	  `god_id` tinyint(3) NOT NULL,
	  `worship_id` smallint(6) NOT NULL,
	  `god_level` tinyint(3) NOT NULL DEFAULT '0',
	  `created_at` datetime NOT NULL,
	  PRIMARY KEY (`id`),
	  KEY `user_idx` (`user_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8",

	'user_daily_quest' => "DROP TABLE IF EXISTS `__TABLE_NAME__`; CREATE TABLE `__TABLE_NAME__` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `user_id` int(11) NOT NULL,
		  `quest_id` int(11) NOT NULL,
	      `finished_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
		  PRIMARY KEY (`id`),
	      UNIQUE KEY `user_quest_idx` (`user_id`,`quest_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8",

	'sys_join' => "DROP TABLE IF EXISTS `__TABLE_NAME__`;CREATE TABLE `__TABLE_NAME__` (
		 `id` int(11) NOT NULL AUTO_INCREMENT,
		 `user_id` INT(10) UNSIGNED NOT NULL,
		 `type` TINYINT(3) UNSIGNED NOT NULL,
		 `user_level` INT(10) UNSIGNED NOT NULL,
		 `created_at` INT(10) NOT NULL,
		 PRIMARY KEY (`id`),
		 KEY `user_id` (`user_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;", ];

$mysqli = new mysqli('localhost', 'root', 'namisan', 'nami');
$mysqli->query('set names utf8');
$table_num = 100;
$time = time();
if (isset ($argv[1])) {
	$table = strval($argv[1]);
	echo "Create tables $table.\n";
	$sql_array = [$table => $sql_array[$table]];
}
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
