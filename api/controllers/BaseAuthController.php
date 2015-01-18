<?php 
namespace Cap\Controllers;

class BaseAuthController extends BaseController
{
	public $_di;
	public function onConstruct()
	{
		parent::onConstruct();
		// check session
		if (!$this->session->has("uid")) {
			// TODO log more details.
			error_log("Try to access api without authority.");
			exit();
		}
	}
}
