<?php
namespace Cap\Models\Db;

class ExchangeModel extends BaseModel
{
    public function getSource()
    {
        return 'exchange';
    }

    public function initialize() {
        $this->setConnectionService('admin_db');
    }
}