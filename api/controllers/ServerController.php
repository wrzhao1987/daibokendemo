<?php
namespace Cap\Controllers;


class ServerController extends BaseController {

	public function onConstruct() {
		parent::onConstruct();
		$this->server_cfg = new \Phalcon\Config\Adapter\Ini(__DIR__.'/../../config/servers.ini');
	}

	public function listAction() {
		$cfg = $this->server_cfg;
		$idstr = $this->server_cfg->global->game_servers;
		$ids = explode(',', $idstr);
		$servers = array();
		foreach ($ids as $id) {
			$servers []= $cfg->$id;
		}
		$res = array('code'=>200, 'servers'=>$servers);
		return json_encode($res, JSON_NUMERIC_CHECK);
	}
}
