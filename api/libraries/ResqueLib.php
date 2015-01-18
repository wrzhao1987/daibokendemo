<?php
namespace Cap\Libraries;

require_once __DIR__.'/../../lib/php-resque/lib/Resque.php';
require_once __DIR__.'/../../scripts/async/php-resque/init.php';

class ResqueLib extends BaseLib
{
	protected $_di;
	public function __construct() {
		parent::__construct();
        $config = \Phalcon\DI::getDefault()->get('config');
		$host = $config->presque->default->redis_host;
		$port = $config->presque->default->redis_port;
		\Resque::setBackend("${host}:${port}");
	}
	
	public function setJob($queue, $job, $args) {
		return \Resque::enqueue($queue, $job, $args);
	}
}
