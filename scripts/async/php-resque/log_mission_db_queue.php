<?php
function getMillisecond(){
	//return round(microtime(true) * 1000);
	list($s1,$s2)=explode(' ',microtime());
	return (float)sprintf('%.0f',(floatval($s1)+floatval($s2))*1000);
}
$time = getMillisecond();
require __DIR__.'/../../../lib/php-resque/lib/Resque.php';
require 'init.php';

date_default_timezone_set('Asia/Shanghai');

Resque::setBackend('localhost:6379');

$args = array(
    'action' => 'insert',
	'params' => array(
		'data' => array(
			'user_id' => 100,
			'time' => time(),
		),
	)
);
for ($i=0;$i<100;$i++) {
	Resque::enqueue('log_mission', 'LogMissionDBJob', $args);
}
$time = getMillisecond() - $time;
echo "cost: $time \n";
