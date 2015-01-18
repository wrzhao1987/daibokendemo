<?php
namespace Cap\Models\Db;

class UserBindModel extends BaseModel
{
    public $id;
    public $source;
    public $source_uid;
    public $uid;
    public $created_at;

    public function getSource()
    {
        return 'user_bind';
    }

    public function onConstruct() {
        $this->setConnectionService('account_db');
    }

    public function createBind($source, $source_uid, $account_id) {
        $db = $this->getDI()->getShared('account_db');
        $table = $this->getSource();
        $sql = "INSERT INTO $table (`source`, `source_uid`, `account_id`) VALUES (?, ?, ?)";
        $db->execute($sql, [$source, $source_uid, $account_id]);
    }

    public function findBind($source, $source_uid) {
        $sql = "SELECT * FROM __TABLE_NAME__ WHERE source = :source: AND source_uid = :source_uid:";
        $result = $this->executeSQL($sql, [
            'source' => intval($source),
            'source_uid' => strval($source_uid),
        ]);
        return $result->count() > 0 ? $result->toArray()[0] : [];
    }
}