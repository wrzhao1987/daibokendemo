<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-9
 * Time: 上午11:51
 */
namespace Cap\Models\Db;

class UserFormationModel extends BaseModel
{
	public $id;
	public $user_id;
	public $type;
	public $pos_1;
	public $pos_2;
	public $pos_3;
	public $pos_4;
	public $pos_5;
	public $pos_6;
	public $pos_7;

	public function getSource()
	{
		return 'user_formation';
	}

    public function createNew($user_id, $type)
    {
        if (empty ($user_id) || ! in_array($type, [DECK_TYPE_PVE, DECK_TYPE_PVP]))
        {
            return false;
        }
        if (DECK_TYPE_PVE == $type)
        {
            $sql = "INSERT INTO __TABLE_NAME__ (user_id, type, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6, pos_7, created_at)

                    VALUES ({$user_id}, $type, 0, 0, 0, 0, 0, 0, 11, NOW())";
        }
        else if (DECK_TYPE_PVP == $type)
        {
            $sql = "INSERT INTO __TABLE_NAME__ (user_id, type, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6, pos_7, created_at)

                    VALUES ({$user_id}, $type, 1, 2, 3, 4, 5, 6, 0, NOW())";
        }

        return isset ($sql) && $this->executeSQL($sql, []);
    }
}