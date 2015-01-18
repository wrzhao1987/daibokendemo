<?php
namespace Cap\Models\Db;

class UserWorshipModel extends BaseModel
{
    public $id;
    public $user_id;
    public $god_id;
    public $worship_id;
    public $god_level;
    public $created_at;

    public function onConstruct()
    {
        parent::onConstruct();
    }

    public $sql_array = [
        'find_by_user_and_worship' => 'SELECT id FROM __TABLE_NAME__ WHERE user_id = :user_id: AND god_id = :god_id: AND worship_id = :worship_id:',
        'find_by_user'             => 'SELECT id, god_id FROM __TABLE_NAME__ WHERE user_id = :user_id:',
        'create_new'               => 'INSERT INTO __TABLE_NAME__ (user_id, god_id, worship_id, god_level, created_at)
                                       VALUES (:user_id:, :god_id:, :worship_id:, :god_level:, NOW())',
    ];

    public function getSource()
    {

        $shard_time = date('Ymd');
        $table_name = implode('_', ['worship_log', $shard_time]);

        return $table_name;
    }

    public function worshipCount($user_id, $god_id, $worship_id)
    {
        $result = $this->execute('find_by_user_and_worship', [
            'user_id'    => intval($user_id),
            'god_id'     => intval($god_id),
            'worship_id' => intval($worship_id),
        ]);
        return $result->count();
    }

    public function worshipTotalCount($user_id)
    {
        $result = $this->execute('find_by_user', [
            'user_id' => $user_id,
        ]);
        return $result->count();
    }

    public function getAllWorship($user_id)
    {
        $result = $this->execute('find_by_user', [
            'user_id' => $user_id,
        ]);
        return $result->count() ? $result->toArray() : [];
    }

    public function addWorship($user_id, $god_id, $worship_id, $god_level)
    {
        $result = $this->execute('create_new', [
            'user_id'    => intval($user_id),
            'god_id'     => intval($god_id),
            'worship_id' => intval($worship_id),
            'god_level'  => intval($god_level),
        ]);
        return $result->success();
    }
}