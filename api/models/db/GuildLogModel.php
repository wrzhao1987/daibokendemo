<?php
namespace Cap\Models\Db;

class GuildLogModel extends BaseModel
{
    public $id;
    public $uid;
    public $gid;
    public $type;
    public $params;
    public $created_at;

    public function onConstruct()
    {
        parent::onConstruct();
    }

    public function getSource()
    {
        return 'guild_log';
    }

    // 获取指定用户的所有公会相关操作记录，可能涉及多个公会
    public function getLogByUid($uid, $type = null)
    {
        $sql = "SELECT id, gid, type, params, created_at FROM __TABLE_NAME__ WHERE uid = :uid: ";
        $params = ['uid' => $uid];
        if (isset ($type)) {
            $sql .= "AND type = :type:";
            $params['type'] = $type;
        }
        $ret = $this->executeSQL($sql, $params);
        return $ret->count() ? $ret->toArray() : [];
    }

    // 根据GID获得公会日志列表
    public function getLogByGid($gid, $count = null)
    {
        $gid = intval($gid);
        $sql = "SELECT id, gid, type, params, created_at FROM __TABLE_NAME__ WHERE gid = '$gid' ";
        if ($count) {
            $sql .= " ORDER BY created_at DESC LIMIT $count";
        }
        $ret = $this->executeSQL($sql, []);
        return $ret->count() ? $ret->toArray() : [];
    }

    // 写入一条公会日志
    public function addLog($uid, $gid, $type, $params)
    {
        $sql = "INSERT INTO __TABLE_NAME__ (uid, gid, type, params, created_at)
                VALUES (:uid:, :gid:, :type:, :params:, NOW())";
        $ret = $this->executeSQL($sql, [
            'uid'  => $uid,
            'gid'  => $gid,
            'type' => $type,
            'params' => $params,
        ]);
        return $ret->success() ? $ret->getModel()->id : false;
    }
}
