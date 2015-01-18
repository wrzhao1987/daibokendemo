<?php
ini_set("display_errors", 1);
date_default_timezone_set('Asia/Shanghai');
error_reporting(E_ALL);


require __DIR__ . "/../../config/common.php";
require __DIR__ . "/../../config/error_code.php";
require __DIR__ . "/../../config/game_config.php";
require __DIR__ . "/../../lib/common_functions.php";

require __DIR__ . "/../../lib/protocolbuf/message/pb_message.php";
require __DIR__ . "/../../lib/xxtea.php";

openlog("nami-".$settings['server_id'], LOG_PID|LOG_PERROR, LOG_LOCAL0);

use Phalcon\Mvc\Micro\Collection as MicroCollection;

$start_time = microtime(true);

if (isset($_POST['data'])/* && isset($_POST['cypher'])*/ && $_SERVER['REMOTE_ADDR']!='127.0.0.1') {
    function hex($string) {/*for debug*/
        syslog(LOG_DEBUG, "HEX String $string");
        $ss = array();
        $bytes = array();  
        for($i = 0; $i < strlen($string); $i++){  
            $bytes[] = ord($string[$i]);  
            $ss[]=dechex(ord($string[$i]));
        }   
        syslog(LOG_DEBUG, join(" ", $ss));
        return $bytes;
    }

    $key = $settings['cipher_key'];
    $data = $_POST['data'];
    $data = base64_decode($data);
    $plain_data = xxtea_decrypt($data, $key);
    syslog(LOG_DEBUG, "cipher_data:$data\nplain text:$plain_data");
    $_POST['data'] = $plain_data;
}

try {
    if (1 == mt_rand(1, 500)) {
        xhprof_enable(XHPROF_FLAGS_CPU + XHPROF_FLAGS_MEMORY + XHPROF_FLAGS_NO_BUILTINS);
        $xhprof_enable = true;
    }
	/**
	 * Read the configuration
	 */
	$config = new \Phalcon\Config($settings);

	/**
	 * Registering a set of directories taken from the configuration file
	 */
	$loader = new \Phalcon\Loader();

	/**
	 * Register some namespaces
	 */
	$loader->registerNamespaces(
	    array(
			'Cap\Controllers' 		=> $config->api->controllersDir,
	    	'Cap\Libraries'   		=> $config->api->librariesDir,
	    	'Cap\Models' 	   		=> $config->api->modelsDir,
	    	'Cap\Models\Db'   		=> $config->api->modelsDbDir,
	    	'Cap\Models\Mongodb'   	=> $config->api->modelsMongodbDir,
	    	'Cap\Models\Config'   	=> $config->api->modelsConfigDir,
	    	'Cap\Models\Memcache'   => $config->api->modelsMemcacheDir,
	    	'Cap\Models\Redis'   	=> $config->api->modelsRedisDir,
	    	'Cap\Models\Flare'   	=> $config->api->modelsFlareDir,
	       	'Cap\Plugins'     		=> $config->api->pluginsDir,
		    'Phalcon'               => $config->incubator->path,
	    )
	);
	$loader->register();

	/**
	 * Dependency injection 
	 */
	$di = new \Phalcon\DI\FactoryDefault();

	/**
	 * The URL component is used to generate all kind of urls in the application
	 */
	$di->set('url', function() use ($config){
		$url = new \Phalcon\Mvc\Url();
		$url->setBaseUri($config->api->baseUri);
		return $url;
	});

	/**
	 * Database connection is created based in the parameters defined in the configuration file
	 */
	$di->set('db', function() use ($config) {
		return new \Phalcon\Db\Adapter\Pdo\Mysql(array(
				"host"     => $config->database->default->host,
				"username" => $config->database->default->username,
				"password" => $config->database->default->password,
				"dbname"   => $config->database->default->dbname,
				"charset"  => "utf8mb4"
		));
	});
	$di->set('account_db', function() use ($config) {
		return new \Phalcon\Db\Adapter\Pdo\Mysql(array(
				"host"     => $config->database->account->host,
				"username" => $config->database->account->username,
				"password" => $config->database->account->password,
				"dbname"   => $config->database->account->dbname,
				"charset"  => "utf8"
		));
	});
    $di->set('admin_db', function() use ($config) {
        return new \Phalcon\Db\Adapter\Pdo\Mysql(array(
            "host"     => $config->database->admin->host,
            "username" => $config->database->admin->username,
            "password" => $config->database->admin->password,
            "dbname"   => $config->database->admin->dbname,
            "charset"  => "utf8"
        ));
    });
	\Phalcon\Mvc\Model::setup(array(
		'notNullValidations' => false
	));

	// This service returns a mongo database at 192.168.1.100
	$di->set('mongo', function() {
		//$mongo = new Mongo("mongodb://scott:nekhen@192.168.1.100");
		$mongo = new Mongo("mongodb://".$config->database->default->host);
		return $mongo->selectDb($config->mongo->default->dbname);
	}, true);

    $di->set('redis', function() use ($config) {
        $rds =  new \redis();
        $rds->connect($config->redis->default->host, $config->redis->default->port);
        return $rds;
    }, true);

	/**
	 * Set config 
	 */
	$di->set('config', $config);
	
	/**
	 * Start the session the first time some component request the session service
	 */
	$redis_host = $config->redis->default->host;
	$redis_port = $config->redis->default->port;
	$di->set('session', function() use ($redis_host, $redis_port) {
		$session = new \Phalcon\Session\Adapter\Redis(array(
			'path' => "tcp://$redis_host:$redis_port?weight=1",
            'lifetime'=> 86400,
		));
		$session->start();
		return $session;
	});

	$di->set('redis', function() use ($redis_host, $redis_port) {
		$redis = new \Redis();
		$redis->connect($redis_host, $redis_port);
		return $redis;
	}, true);

	$api = new \Phalcon\Mvc\Micro($di);

    $router = $di['router'];
    $router->handle();
    $ctrl = $router->getControllerName();
    $action = $router->getActionName();
    /*
    $classname = "Cap\Controllers\\".ucwords($ctrl)."Controller";
    $method = "${action}Action";
    $instance =  new $classname();
    call_user_func(array($instance, $method), array());
    */
    $coll = new MicroCollection();
    $coll->setHandler("Cap\Controllers\\".ucwords($ctrl)."Controller", true);
    $coll->map("/$ctrl/$action", "${action}Action");
    $api->mount($coll);

	$api->notFound(function () use ($api, $di) {
		$api->response->setStatusCode(404, "Not Found")->sendHeaders();
	});
    // for debug log
    $session = $di->getShared('session');
    if ($session->get('role_id')) {
        $debug_uid = $session->get('role_id');
    } else {
        $debug_uid = 0;
    }
    syslog(LOG_DEBUG, "$debug_uid $_GET[_url] ".(isset($_POST['data'])?'==> '.$_POST['data']:"")."  --$start_time");
	$res = $api->handle();
    if ($res) {
        $exec_time = microtime(true) - $start_time;
        // for test
        if (strlen($res)>1000) {
            $lf = fopen("/tmp/longresp.txt", "a+");
            fwrite($lf, date("Y-m-d H:i:s")." "."nami-".$settings['server_id']." $debug_uid $_GET[_url] <== $res - ". $exec_time ."s\n");
            fclose($lf);
        }
        syslog(LOG_DEBUG, "$debug_uid $_GET[_url] <== $res - ". $exec_time ."s");
        if (isset ($xhprof_enable) && $xhprof_enable) {
            if ($exec_time >= 0.05) {
                $xhprofData = xhprof_disable();
                require __DIR__ . "/../../lib/xhprof/xhprof_lib/utils/xhprof_lib.php";
                require __DIR__ . "/../../lib/xhprof/xhprof_lib/utils/xhprof_runs.php";
                $xhprofRuns = new XHProfRuns_Default();
                $prof_type = "{$ctrl}_{$action}";
                $xhprofRuns->save_run($xhprofData, $prof_type);
            } else {
                xhprof_disable();
            }
        }
        echo $res;
    }




} catch (Phalcon\Exception $e) {
	syslog(LOG_INFO, "PhalconException $e");
    $error_info = [
        'code' => $e->getCode(),
        'msg'  => $e->getMessage(),
    ];
	echo json_encode($error_info, JSON_NUMERIC_CHECK | JSON_UNESCAPED_UNICODE);
	error_log($e->getMessage());
	error_log(print_r($e, true));
} catch (PDOException $e){
	syslog(LOG_INFO, "PDOException $e");
	echo $e->getMessage();
	error_log($e->getMessage());
	error_log(print_r($e, true));
} catch (Exception $e) {
	syslog(LOG_INFO, "Exception $e");
	header($e->getMessage(), true, 500);
	error_log(print_r($e, true));
}

closelog();
