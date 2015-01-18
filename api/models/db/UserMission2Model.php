<?php 
namespace Cap\Models\Db;

class UserMission2Model extends BaseShardAvgModel
{
	public $role_id;
	public function getSource() {
		//$suffix = $this->role_id % $this->shard_divisor;
		//return sprintf("user_mission2_%02d", $suffix); // add shared suffix
        return "user_mission2";
	}

	public $sql_array = array(
	);

    public function getSections($role_id) {
        $this->role_id = $role_id;
        $sql = 'select * from __TABLE_NAME__ where role_id=:role_id:';
        $sql = $this->makesql($sql);
        $rows = $this->getModelsManager()->executeQuery($sql, array('role_id'=> $role_id));
        $data = array();
        foreach ($rows as $row) {
            $data [] = array('section_id'=>$row->section_id, 'best_point'=>$row->best_point);
        }
        return $data;
    }

}
