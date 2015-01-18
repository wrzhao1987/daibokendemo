<?php 
namespace Cap\Libraries;

use Phalcon\Mvc\User\Component;
use Phalcon\DI;

class BaseLib extends Component
{
	protected $_di;
	protected $redis;
    protected static $global_config;
	public function __construct()
	{
		$this->_di = DI::getDefault();
		$this->redis = $this->_di->getShared('redis');
	}

	public static function getGameConfig($config_name)
	{
        if (isset (self::$global_config[$config_name])) {
            return self::$global_config[$config_name];
        }
        $config = apc_fetch($config_name);
        if ($config)
        {
            self::$global_config[$config_name] = $config;
            return $config;
        }
        $config_path = __DIR__ . "/../../config/game/{$config_name}.json";
        if (is_readable($config_path))
        {
            # remove comments line
            $text = preg_replace('/^\s*(#|(\/\/))[^\n]+/m', "", file_get_contents($config_path));
            $config = json_decode($text, true);
            apc_store($config_name, $config);
            return $config;
        }
        return false;
	}

    public static function getDefaultExpire()
    {
        return strtotime("05:00", time()+19*3600-1);  // exipre at next 05:00
    }
}
