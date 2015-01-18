<?php

namespace Cap\Models\db;

class AwardModel extends BaseModel {

    public static $AWARD_STATUS_UNREDEMPT = 0;
    public static $AWARD_STATUS_REDEMPTED = 0;

    public $sql_array = array(
        'find_by_id' => 'select award_id, status, item, created_at, redempt_time from __TABLE_NAME__ where id=:id:',
        'find_by_status'=> 'select id, award_id, created_at from __TABLE_NAME__ where user_id=:user_id: and status=:status:',
        'create_new'=> 'insert into __TABLE_NAME__ (user_id, award_id, status, item, created_at) values (:user_id:, :award_id:, 0, :item:, now())',
    );

    public function onConstruct() {
        parent::onConstruct();
    }

    public function getSource() {
        return 'user_award_pvp';
    }


    public function getUnredemptedAwards($user_id) {
        $rs = $this->execute('find_by_status', array('user_id'=>$user_id, 
            'status'=> self::$AWARD_STATUS_UNREDEMPT));
        if (!$rs) {
            syslog(LOG_ERR, "error in find getUnredemptedAwards($user_id)");
            return false;
        }
        $awards = array();
        foreach ($rs as $row) {
            $awards []= array(
                'id'=> intval($row->id),
                'award_id'=> intval($row->award_id),
            );
        }
        return $awards;
    }

    /*
     * insert new award
     * length of item should not greater than 1024
     */
    public function insertAward($user_id, $award_id, $items=array()) {
        $items = json_encode($items);
        if (mb_strlen($items, 'utf8') > 1024) {
            syslog(LOG_ERR, "error in insertAward($user_id, $award_id, $items): items too long");
            return false;
        }
        $r = $this->execute('create_new', array('user_id'=>$user_id, 
            'award_id'=>$award_id, 'item'=>$items));
        if ($r->success()) {
            $id = $r->getModel()->id;
            syslog(LOG_DEBUG, "insert award($user_id, $award_id, $items) $id");
            return $id;
        } else {
            syslog(LOG_ERR, "error in insert new award for $user_id, $award_id");
            return false;
        }
    }

    public function redemptAward($user_id, $user_award_id) {
        // try update
        $di = \Phalcon\DI::getDefault();
        $db = $di->getShared('db');
        $tbl = $this->getSource();
        $id = intval($user_award_id);

        $record = $this->getById($id);
        if (!$record) {
            return null;
        }

        $sql = "update $tbl set status=1 where id=?";
        $r = $db->execute($sql, array($id));
        if ($r===false) {
            syslog(LOG_ERR, "error in redemptAward, execute[$sql]:".$db->error);
            return false;
        }
        $affectedRows = $db->affectedRows();
        if ($affectedRows <= 0) {
            syslog(LOG_WARNING, "redemptAward($user_id, $user_award_id), record already redempted or not found");
            return null;
        }
        foreach ($record as $row)
            return $row->award_id;
        return null;
    }

}
