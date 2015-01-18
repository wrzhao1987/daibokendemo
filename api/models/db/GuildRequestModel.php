<?php
namespace Cap\Models\Db;

class GuildRequestModel extends BaseModel
{
    public $id;
    public $uid;
    public $gid;
    public $created_at;

    public function onConstruct()
    {
        parent::onConstruct();
    }

    public function getSource()
    {
        return 'guild_request';
    }

    // 获取指定UID的所有公会入会请求
    public function getRequestByUID($uid)
    {
        $sql = "SELECT id, uid, gid, created_at FROM __TABLE_NAME__ WHERE uid = :uid:";
        $ret = $this->executeSQL($sql, ['uid' => intval($uid)]);
        return $ret->count() ? $ret->toArray() : [];
    }

    // 获取指定GID的公会入会请求
    public function getRequestByGID($gid)
    {
        $sql = "SELECT id, uid, gid, created_at FROM __TABLE_NAME__ WHERE gid = :gid:";
        $ret = $this->executeSQL($sql, ['gid' => intval($gid)]);
        return $ret->count() ? $ret->toArray() : [];
    }

    // 获取指定公会指定用户的入会请求
    public function getRequestByGidAndUid($gid, $uid)
    {
        $sql = "SELECT id, uid, gid, created_at
                FROM __TABLE_NAME__
                WHERE gid = :gid: AND uid = :uid:";
        $ret = $this->executeSQL($sql, [
            'gid' => intval($gid),
            'uid' => intval($uid),
        ]);

        return $ret->count() ? $ret->toArray()[0] : [];
    }

    // 获取指定ID的入会请求
    public function getRequestByID($rid)
    {
        $sql = "SELECT id, uid, gid, created_at FROM __TABLE_NAME__ WHERE id = :rid:";
        $ret = $this->executeSQL($sql, ['rid' => intval($rid)]);
        return $ret->count() ? $ret->toArray()[0] : [];
    }

    // 删除指定ID的入会请求
    public function removeRequest($rid)
    {
        $sql = "DELETE FROM __TABLE_NAME__ WHERE id = :rid:";
        $ret = $this->executeSQL($sql, ['rid' => $rid]);
        return $ret->success();
    }

    // 更新入会请求，用于更新超过3天失效的入会请求
    public function updateRequestTime($rid, $time = null)
    {
        if (null == $time) {
            $time = date('Y-m-d H:i:s');
        }
        $sql = "UPDATE __TABLE_NAME__ SET created_at = :now: WHERE id = :rid:";
        $ret = $this->executeSQL($sql, ['now' => $time, 'rid' => $rid]);
        return $ret->success();
    }

    // 插入一条新的入会请求
    public function createRequest($uid, $gid)
    {
        $sql = "INSERT INTO __TABLE_NAME__ (uid, gid, created_at) VALUES (:uid:, :gid:, NOW())";
        $ret = $this->executeSQL($sql, [
            'uid' => $uid,
            'gid' => $gid,
        ]);
        return $ret->success() ? $ret->getModel()->id : false;
    }

    // 根据UID, GID删除公会请求
    public function removeByUidGid($uid, $gid)
    {
        $sql = "DELETE FROM __TABLE_NAME__ WHERE uid = :uid: AND gid = :gid:";
        $ret = $this->executeSQL($sql, ['uid' => $uid, 'gid' => $gid]);
        return $ret->success();
    }
}