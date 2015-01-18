<?php

namespace Cap\Models;

class RankModel extends \Phalcon\Mvc\Model {

	public function getSource() {
		return "pvp_rank";
	}

	public function queryRank($role_id) {
		return false;
	}
}
