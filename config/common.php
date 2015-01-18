<?php 
define('G_ENV', 'develop');

if (G_ENV === "develop") {

	$settings = array(
		"database"=>array(
			"default" => array(
				"adapter"  => "Mysql",
				"host"     => "localhost",
				"username" => "root",
				"password" => "namisan",
				"dbname"   => "nami",
			),
			"account" => array(
				"adapter"  => "Mysql",
				"host"     => "localhost",
				"username" => "root",
				"password" => "namisan",
				"dbname"   => "nami_account",
			),
			"static" => array(
				"adapter"  => "Mysql",
				"host"     => "localhost",
				"username" => "root",
				"password" => "namisan",
				"dbname"   => "nami",
			),
            "admin" => array(
                "adapter"  => "Mysql",
                "host"     => "localhost",
                "username" => "root",
                "password" => "namisan",
                "dbname"   => "nami_admin",
            ),
		),
		"mongodb"=>array(
			"default" => array(
				"host"     => "localhost",
				"port"	   => "27017",
				"username" => "root",
				"password" => "stand@123",
				"dbname"   => "nami",
			)
		),
		"redis"=>array(
			"default" => array(
				"host" =>"127.0.0.1",
				"port" => "6379",
			),	
			"account" => array(
				"host" =>"127.0.0.1",
				"port" => "6370",
			),
		),
		"0mq"=>array(
			"default" => array(
				"proto" => "ipc",
				"host" => "routing.ipc",
				"port" => "",//5560
			)
		),
		"presque"=>array(
			"default" => array(
				"redis_host" =>"127.0.0.1",
				"redis_port" => "6379",
			)
		),
		"api" => array(
				"controllersDir" 		=> __DIR__ . "/../api/controllers/",
				"librariesDir"   		=> __DIR__ . "/../api/libraries/",
				"modelsDir"      		=> __DIR__ . "/../api/models/",
				"modelsDbDir"    		=> __DIR__ . "/../api/models/db/",
				"modelsMongodbDir"		=> __DIR__ . "/../api/models/mongodb/",
				"modelsConfigDir"    	=> __DIR__ . "/../api/models/config/",
				"modelsMemcacheDir"    	=> __DIR__ . "/../api/models/memcache/",
				"modelsRedisDir"    	=> __DIR__ . "/../api/models/redis/",
				"modelsFlareDir"    	=> __DIR__ . "/../api/models/flare/",
				"pluginsDir" 	 		=> __DIR__ . "/../api/plugins/",
				"baseUri"		 		=> "localhost",
			),
		"app" => array(),
		"incubator" => array(
			"path"  => '/var/www/incubator/Library/Phalcon/',
		),
		"server_id" => 1, // server id
        "cipher_key" => 'wp#$trns$wg%@'
	);

} elseif (G_ENV === "staging") {
	
} elseif (G_ENV === "production"){
	
}
