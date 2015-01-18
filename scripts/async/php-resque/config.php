<?php 
define('G_ENV', 'develop');

if (G_ENV === "develop") {

	$settings = array(
		"database"=>array(
			"default" => array(
				"host"     => "localhost",
				"username" => "root",
				"password" => "pilot@123",
				"dbname"   => "cap",
			),
			"static" => array(
				"host"     => "localhost",
				"username" => "root",
				"password" => "pilot@123",
				"dbname"   => "cap",
			)
		),
		"redis"=>array(
			"default" => array(
				"host" =>"127.0.0.1",
				"port" => "6379",
			)	
		),
	);
	
} elseif (G_ENV === "staging") {
	
} elseif (G_ENV === "production"){
	
}

