<?php
function getMillisecond(){
	//return round(microtime(true) * 1000);
	list($s1,$s2)=explode(' ',microtime());
	return (float)sprintf('%.0f',(floatval($s1)+floatval($s2))*1000);
}
$time = getMillisecond();
require __DIR__.'/../../../lib/php-resque/lib/Resque.php';
require 'init.php';
//require 'user_mission_db_job.php';

date_default_timezone_set('Asia/Shanghai');

Resque::setBackend('localhost:6379');

$args = array(
    'action' => 'create',
	'params' => array(
		'id' => 0,
		'chapter_mission_id' => 0
	)
);
for ($i=0;$i<100;$i++) {
	Resque::enqueue('mission', 'UserMissionDBJob', $args);
}
$time = getMillisecond() - $time;
echo "cost: $time \n";