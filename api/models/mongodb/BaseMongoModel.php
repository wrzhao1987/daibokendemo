<?php 
namespace Cap\Models\Mongodb;

use Phalcon\Mvc\Collection;

class BaseMongoModel extends Collection
{
	public function initialize()
	{
		$this->setConnectionService('mongo1');
	}
}

