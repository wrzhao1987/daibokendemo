<?php 
namespace Cap\Models\Db;

class UserMissionModel extends BaseShardAvgModel
{
	public $role_id;
	public function getSource() {
		$suffix = $this->role_id % $this->shard_divisor;
		return sprintf("user_mission_%02d", $suffix); // add shared suffix
	}

	public $sql_array = array(
		'find_by_id'   => 'SELECT * FROM __TABLE_NAME__ WHERE id = :id:',
		'find_by_ids'  => 'SELECT * FROM __TABLE_NAME__ WHERE id in (:ids:)',
		'find_by_id_and_chapter_mission_id' => 'SELECT * FROM __TABLE_NAME__ WHERE id = :id: AND chpater_mission_id = :chapter_mission_id:',
		'update_star' => 'UPDATE __TABLE_NAME__ SET star = :star:, count = count+1 WHERE id = :id: AND chpater_mission_id = :chapter_mission_id:',
		'create_table' => 'CREATE TABLE IF NOT EXISTS __TABLE_NAME__ (
			`id` bigint(20) unsigned NOT NULL,
		  	`chapter_mission_id` int unsigned NOT NULL,
			`star` int unsigned NOT NULL DEFAULT 0,
			`count` int unsigned NOT NULL DEFAULT 0,
		  	`updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  	`created_at` datetime NOT NULL,
		  KEY (`id`, `chapter_mission_id`),
		) ENGINE=InnoDB  DEFAULT CHARSET=utf8',
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
