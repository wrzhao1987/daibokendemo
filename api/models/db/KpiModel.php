<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-9-30
 * Time: 下午3:24
 */
namespace Cap\Models\Db;

class KpiModel extends BaseModel
{
    public function getSource() {
        return 'kpi';
    }

    public function createData($date, $type, $data) {
        $db = $this->getDI()->getShared('db');
        $table = $this->getSource();
        $date = strval($date);
        $type = intval($type);
        $data = json_encode($data, JSON_NUMERIC_CHECK);
        $sql = "INSERT INTO $table (date, type, data)
                VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE data = ?";
        $db->execute($sql, [$date, $type, $data, $data]);
    }

    public function getData($date, $type) {
        $sql = "SELECT * FROM __TABLE_NAME__ WHERE date = :date: AND type = :type:";
        $ret = $this->executeSQL($sql, [
            'date' => $date,
            'type' => $type,
        ]);
        return $ret->count() ? $ret->toArray()[0]['data'] : [];
    }
}