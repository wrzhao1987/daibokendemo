<?php
use Phalcon\DI\FactoryDefault\CLI as CliDI;
use Phalcon\CLI\Console as ConsoleApp;

define('VERSION', '1.0.0');
date_default_timezone_set('Asia/Shanghai');
include __DIR__ . "/../../config/game_config.php";
include __DIR__ . '/../../config/common.php';
include __DIR__ . "/../../lib/common_functions.php";
require __DIR__ . "/../../config/error_code.php";


$di = new CliDI();

$loader = new \Phalcon\Loader();

$config = new \Phalcon\Config($settings);

$di->set('redis', function() use ($config) {
    $rds =  new \redis();
    $rds->connect($config->redis->default->host, $config->redis->default->port);
    return $rds;
}, true);

$di->set('db', function() use ($config) {
    return new \Phalcon\Db\Adapter\Pdo\Mysql(array(
        "host"     => $config->database->default->host,
        "username" => $config->database->default->username,
        "password" => $config->database->default->password,
        "dbname"   => $config->database->default->dbname,
        "charset"  => "utf8"
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

$di->set('config', $config);

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

$loader->registerDirs([
    __DIR__ . '/tasks',
]);

$loader->register();

$console = new ConsoleApp();
$console->setDI($di);

\Phalcon\Mvc\Model::setup(array(
    'notNullValidations' => false
));

$arguments = [];
foreach($argv as $k => $arg) {
    if($k == 1) {
        $arguments['task'] = $arg;
    } elseif($k == 2) {
        $arguments['action'] = $arg;
    } elseif($k >= 3) {
        $arguments['params'][] = $arg;
    }
}

// define global constants for the current task and action
define('CURRENT_TASK', (isset($argv[1]) ? $argv[1] : null));
define('CURRENT_ACTION', (isset($argv[2]) ? $argv[2] : null));

try {
 // handle incoming arguments
 $console->handle($arguments);
}
catch (\Phalcon\Exception $e) {
 echo $e->getMessage();
 exit(255);
}
