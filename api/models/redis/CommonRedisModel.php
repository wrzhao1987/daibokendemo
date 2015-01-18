<?php

namespace Cap\Models\Redis;

class CommonRedisModel {

	public function __construct($host, $port) {
		$this->host = $host;
		$this->port = intval($port);
		$redis = new \redis();
		$redis->connect($this->host, $this->port);
		$this->redis = $redis;
	}

	public function getConn() {
		return $this->redis;
	}
}


