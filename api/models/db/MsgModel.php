<?php
namespace Cap\Models\Db;

class MsgModel extends BaseModel {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di = \Phalcon\DI::getDefault();
    }

    public function getSource() {
        return "user_msg";
    }

    public function getMsgs($role_id, $since) {
        syslog(LOG_DEBUG, "getMsgs($role_id, $since)");
        $result = self::find(array(
            '(to=?1 or from_uid=?1 or to=0) and to>=0 and created_at > ?2 order by created_at desc',
            'bind'=>array(1=>$role_id, 2=>$since),
            'limit'=>50,
        ));
        $msgs = $result->toArray();
        return $msgs;
    }

    public function getMsgsByTarget($target_id, $since) {
        $result = self::find(array(
            'to=?1 and created_at > ?2 order by created_at desc',
            'bind'=>array(1=>$target_id, 2=>$since),
            'limit'=>50,
        ));
        $msgs = $result->toArray();
        return $msgs;
    }

    public function newMsg($from_uid, $target_uids, $content, $from_name) {
        syslog(LOG_DEBUG, "new msg ($from_uid, $target_uids[0].., $content, $from_name) ");
        $di = \Phalcon\DI::getDefault();
        $db = $di->getShared('db');
        $tbl = $this->getSource();
        if (!$content) {
            return 0;
        }
        $content = $db->escapeString($content);

        $sql_pre = "insert into $tbl (from_uid, `to`, from_name, text, created_at) values ";
        if (!$from_name || strlen($from_name)==0) {
            $from_name = '';
        }
        $from_name = $db->escapeString($from_name);

        $affected_rows = 0;
        $sql_vals = array();
        $from_uid = intval($from_uid);
        foreach ($target_uids as $uid) {
            $uid = intval($uid);
            $sql_vals []= "($from_uid, $uid, $from_name, $content, now())";
            if (count($sql_vals) >= 100) {
                $sql_valstr = implode(',', $sql_vals);
                $sql_vals = array();
                $sql = $sql_pre.$sql_valstr;
                syslog(LOG_DEBUG, $sql);
                $r = $db->execute($sql);
                $affected_rows += $db->affectedRows();
            }
        }
        if ($sql_vals) {
            $sql_valstr = implode(',', $sql_vals);
            $sql_vals = array();
            $sql = $sql_pre.$sql_valstr;
            syslog(LOG_DEBUG, $sql);
            $r = $db->execute($sql);
            $affected_rows += $db->affectedRows();
        }
        return $affected_rows;
    }
}

// end of file
