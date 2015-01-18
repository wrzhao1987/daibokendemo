<?php
namespace Cap\Models\Db;

class GuildMemberModel extends BaseModel
{
    public $id;         // 主键ID
    public $uid;        // 用户ID
    public $gid;        // 公会ID
    public $grade;      // 公会阶级
    public $contr;      // 公会贡献度
    public $created_at; // 加入公会时间

    public function onConstruct()
    {
        parent::onConstruct();
    }

    public function getSource()
    {
        return 'guild_member';
    }

    // 通过UID获取公会成员信息
    public function getMemberByUid($uid)
    {
        $sql = "SELECT id, uid, gid, grade FROM __TABLE_NAME__ WHERE uid = :uid:";
        $ret = $this->executeSQL($sql, ['uid' => intval($uid)]);
        return $ret->count() ? $ret->toArray()[0] : [];
    }

    // 通过MID获取用户信息
    public function getMemberById($id)
    {
        $sql = "SELECT id, uid, gid, grade FROM __TABLE_NAME__ WHERE id = :id:";
        $ret = $this->executeSQL($sql, ['id' => intval($id)]);
        return $ret->count() ? $ret->toArray()[0] : [];
    }

    // 向公会中添加指定阶级的会员
    public function addMember($gid, $uid, $grade)
    {
        $new_id = 0;
        $sql = "INSERT INTO __TABLE_NAME__ (uid, gid, grade, contr, created_at)
                VALUES ({$uid}, {$gid}, {$grade}, 0, NOW())";
        $ret = $this->executeSQL($sql, []);
        if ($ret->success()) {
            $new_id = $ret->getModel()->id;
        }
        return $new_id;
    }

    // 移除公会成员
    public function removeMember($mid)
    {
        $sql = "DELETE FROM __TABLE_NAME__ WHERE id = :mid:";
        $ret = $this->executeSQL($sql, [
            'mid' => intval($mid),
        ]);
        return $ret->success();
    }

    // 获取公会成员，可指定阶级
    public function getMembers($gid, $grade = null)
    {
        $params = [];
        $sql = "SELECT id, uid, gid, grade FROM __TABLE_NAME__ WHERE gid = :gid:";
        $params['gid'] = intval($gid);
        if (isset ($grade)) {
            $sql .= " AND grade = :grade:";
            $params['grade'] = intval($grade);
        }
        $ret = $this->executeSQL($sql, $params);
        return $ret->count() ? $ret->toArray() : [];
    }

    // 更改公会成员阶级
    public function modGrade($mid, $grade)
    {
        $mid = intval($mid);
        $grade = intval($grade);
        $sql = "UPDATE __TABLE_NAME__ SET grade = '{$grade}' WHERE id = '{$mid}'";
        $ret = $this->executeSQL($sql, []);
        return $ret->success();
    }

    // 删除指定GID的所有成员
    public function removeByGid($gid)
    {
        $sql = "DELETE FROM __TABLE_NAME__ WHERE gid = :gid:";
        $ret = $this->executeSQL($sql, [
            'gid' => intval($gid),
        ]);
        return $ret->success();
    }
}
