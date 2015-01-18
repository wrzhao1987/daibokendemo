<?php
namespace Cap\Models\Db;

class QuestModel extends BaseModel
{
    public $id;
    public $user_id;
    public $quest_id;
    public $finish_time;

    public function onConstruct()
    {
        parent::onConstruct();
    }

    public function getSource()
    {
        return 'user_quest';
    }

    public $sql_array = [
        'find_by_user_quest' => 'SELECT id FROM __TABLE_NAME__ WHERE user_id = :user_id: AND quest_id = :quest_id:',
        'create_new'         => 'INSERT INTO __TABLE_NAME__ (user_id, quest_id, finished_at)
                                 VALUES (:user_id:, :quest_id:, NOW())',
    ];

    public function isQuestFinished($user_id, $quest_id)
    {
        if (! ($user_id && $quest_id)) {
            return false;
        }
        $ret = $this->execute('find_by_user_quest', [
            'user_id' => intval($user_id),
            'quest_id' => intval($quest_id),
        ]);
        return $ret->count() ? 1 : 0;
    }

    public function addQuestLog($user_id, $quest_id)
    {
        if (! ($user_id && $quest_id)) {
            return false;
        }
        $ret = $this->execute('create_new', [
            'user_id' => intval($user_id),
            'quest_id' => intval($quest_id),
        ]);
        return $ret->success();
    }
}