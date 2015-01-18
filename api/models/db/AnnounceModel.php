<?php
namespace Cap\Models\Db;

class AnnounceModel extends BaseModel
{
    public $id;
    public $title;
    public $content;
    public $weight;
    public $start;
    public $end;

    public function getSource()
    {
        return 'announce';
    }
}