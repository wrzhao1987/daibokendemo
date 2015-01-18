<?php
namespace Cap\Models\Db;

class GuildModel extends BaseModel
{
    public $id;
    public $name;
    public $icon;
    public $level;
    public $notice;
    public $fund;
    public $created_at;

    public function onConstruct()
    {
        parent::onConstruct();
    }

    public function getSource()
    {
        return 'guild';
    }

    // 创建新公会
    public function createNew($name, $icon)
    {
        $new_gid = 0;
        $sql = "INSERT INTO __TABLE_NAME__
                (name, icon, level, notice, fund, created_at)
                VALUES (:name:, :icon:, 1, '', 0, NOW())";
        $ret = $this->executeSQL($sql, [
            'name' => $name,
            'icon' => $icon,
        ]);
        if ($ret->success()) {
            $new_gid = $ret->getModel()->id;
        }
        return $new_gid;
    }

    // 删除公会信息，用于解散一个公会
    public function remove($gid)
    {
        $sql = "DELETE FROM __TABLE_NAME__ WHERE id = :gid:";
        $result = $this->executeSQL($sql, ['gid' => $gid]);
        return $result->success();
    }

    // 更新公会字段
    public function updateFields($gid, $fields)
    {
        $conditions = '';
        foreach ($fields as $key => $value) {
            $conditions[] = "$key = '$value'";
        }
        $conditions = implode(',', $conditions);
        $sql = "UPDATE __TABLE_NAME__ SET $conditions WHERE id =:gid: ";
        $result = $this->executeSQL($sql, ['gid' => $gid]);
        return $result->success();
    }

    // 添加公会资金
    public function incrFund($gid, $delta)
	{
		$gid = intval($gid);
		$delta = intval($delta);
        $sql = "UPDATE __TABLE_NAME__ SET fund = fund + {$delta} WHERE id = {$gid}";
        $result = $this->executeSQL($sql, []);
        return $result->success();
    }

    // 根据公会ID获取公会信息
    public function getByGid($gid)
    {
        $sql = "SELECT * FROM __TABLE_NAME__ WHERE id = :gid:";
        $result = $this->executeSQL($sql, ['gid' => $gid]);
        return $result->count() ? $result->toArray()[0] : [];
    }

    // 根据公会ID列表获取公会信息
    public function getByIdList($gid_list)
    {
        $ret = [];
        if (empty($gid_list)) {
            return $ret;
        }
        $gid_list = implode(',', $gid_list);
        $sql = "SELECT * FROM __TABLE_NAME__ WHERE id IN ($gid_list)";
        $guilds = $this->executeSQL($sql, []);
        if ($guilds->count() > 0)
        {
            foreach ($guilds as $value) {
                $ret[$value->id] = $value->toArray();
            }
        }
        return $ret;
    }
}
