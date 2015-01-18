<?php 
define('G_ENV', 'develop');

if (G_ENV === "develop") {

	$settings_mongo = array(
		"default" => array(
			"host"     => "localhost",
			"port"	   => "27017",
			"username" => "root",
			"password" => "stand@123",
			"dbname"   => "cap",
		),
	);
	
} elseif (G_ENV === "staging") {
	
} elseif (G_ENV === "production"){
	
}

