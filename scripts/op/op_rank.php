<?php

$server_addr = "http://127.0.0.1:8080";

function zget($data) {
	global $server_addr;
	$url = "$server_addr/?data=".json_encode($data);
	echo "url:$url\n";
	$res = file_get_contents($url);
	echo "res:[$res]\n";
}

function add($id) {
	zget(array(
		"cmd"=>"add",
		"id"=>$id,
	));
}

function query_rank($ids) {
	zget(array(
		"cmd"=>"queryrank",
		"id"=>$ids,
	));
}

function query_users($ranks) {
	zget(array(
		"cmd"=>"queryuser",
		"rank"=>$ranks,
	));
}

function preempt($user1, $user2) {
	zget(array(
		"cmd"=>"preempt",
		"winner"=>$user1,
		"loser"=>$user2,
	));
}

function test1($n) {
	$t1 = time();
	for ($i=1; $i<$n; $i++) {
		add($i*10);
		#query_rank(array($i));
		//query_users(array($n*0.8));
	}
	$t2 = time();
	echo "test1 $n ops cost ".($t2-$t1)."s\n";
}
function test2($n, $m) {
	$t1 = time();
	for ($i=1; $i<$n; $i++) {
		do {
			$a = rand()%$m;
		} while($a==0);
		do {
			$b = rand()%$m;
		} while($b==0);

		preempt($a, $b);
	}
	$t2 = time();
	echo "test2 $n ops cost ".($t2-$t1)."s\n";
}

function export($file) {
	zget(array(
		"cmd"=>"export",
		"file"=>$file,
	));
}

function import($file) {
	zget(array(
		"cmd"=>"import",
		"file"=>$file,
	));
}

function applylog($file) {
	zget(array(
		"cmd"=>"applylog",
		"file"=>$file,
	));
}


