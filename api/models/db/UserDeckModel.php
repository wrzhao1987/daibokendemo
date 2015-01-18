<?php
namespace Cap\Models\Db;

class UserDeckModel extends BaseModel
{
	public $id;
	public $user_id;
	public $pos;
	public $user_card_id;
	public $equip_1;
	public $equip_2;
	public $equip_3;
	public $equip_4;
	public $dragon_ball_1;
	public $dragon_ball_2;
	public $dragon_ball_3;
	public $dragon_ball_4;
    public $updated_at;
    public $created_at;

    public $sql_array = [
        'create_new' => '',
    ];

	public function getSource()
	{
		return 'user_deck';
	}

    public function createDeck($user_id, $pos)
    {
        if (empty ($user_id) || empty ($pos))
        {
            return false;
        }
        $sql = "INSERT INTO __TABLE_NAME__ (user_id, pos, user_card_id,
                equip_1, equip_2, equip_3, equip_4,
                dragon_ball_1, dragon_ball_2, dragon_ball_3, dragon_ball_4, created_at)
                VALUES ('$user_id', '$pos', 0, 0, 0, 0, 0, 0, 0, 0, 0, NOW())";

        $result = $this->executeSQL($sql,[]);
        return $result->success();
    }
}
