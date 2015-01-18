<?php

namespace Cap\Models\db;

class UserMailModel extends BaseModel {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di = \Phalcon\DI::getDefault();
    }

    public function getSource() {
        return 'user_mail';
    }

    public function getUserMails($role_id, $start_date) {
        $result = self::find(array(
            'user_id=?1 and created_at > ?2',
            'bind'=>array(1=>$role_id, 2=>$start_date),
            'limit'=>100
        ));
        $mails = $result->toArray();
        $text_ids = array();
        foreach ($mails as $k=>&$mail) {
            if ($mail['status']==1 and $mail['attachment']) {
                unset($mails[$k]);
                continue;
            }
            if (!$mail['mail_text']) {
                $text_id = intval($mail['text_id']);
                if ($text_id) {
                    $text_r = MailTextModel::find(array('id=?1', 'bind'=>array(1=>$text_id), 'limit'=>1));
                    $text = '';
                    foreach ($text_r as $txt) {
                        $text = $txt->content;
                    }
                    $mail['mail_text'] = $text;
                } else {
                    syslog(LOG_ERR, "unexpected mail $mail[id] with no text");
                }
            }
            if ($mail['attachment']) {
                $mail['attachment'] = json_decode($mail['attachment'], true);
            }
        }
        if ($text_ids) {
            $text_ids = array_keys($text_ids);
            $tidstr = implode(',', $text_ids);
        }
        return $mails;
    }

    public function acceptMail($role_id, $mail_id) {
        $result = self::find(array(
            'id=?1 and user_id=?2',
            'bind'=>array(1=>$mail_id, 2=>$role_id),
        ));
        if (!$result) {
            syslog(LOG_ERR, "error in get user mail ($role_id, $mail_id)");
            return array('code'=> 500, 'msg'=> 'error in get mail');
        }
        $mails = $result->toArray();
        if (!$mails) {
            syslog(LOG_WARNING, "get user mail ($role_id, $mail_id): not found");
            return array('code'=> 404, 'msg'=> 'mail not found');
        }
        $mail = $mails[0];
        /*
        if (!$mail['attachment']) {
            syslog(LOG_WARNING, "get user mail ($role_id, $mail_id): attachment not found");
            return array('code'=> 406, 'msg'=> 'no attachment');
        }
        */
        if ($mail['attachment']) {
            $mail['attachment'] = json_decode($mail['attachment'], true);
        }
        if ($mail['status'] != 0) {
            syslog(LOG_WARNING, "get user mail ($role_id, $mail_id): already accepted");
            return array('code'=> 405, 'msg'=> 'already accepted');
        }
        # update status
        $tbl = $this->getSource();
        $sql = "update $tbl set status=1 where id=? and status=0";
        $db = $this->_di->getShared('db');
        $r = $db->execute($sql, array($mail_id));
        if ($r===false) {
            syslog(LOG_ERR, "error in acceptMail($role_id, $mail_id)");
            return array('code'=> 500, 'msg'=> 'error in accept attachment');
        }
        if (!$db->affectedRows()) {
            syslog(LOG_WARNING, "acceptMail($role_id, $mail_id): no row affected");
            return array('code'=> 404, 'msg'=> 'no record actually updated');
        }
        return array('code'=> 200, 'attachment'=> $mail['attachment']);
    }

    /*
     * attachment: array
     */
    public function newUserMail($from_uid, $target_uids, $content, $attachment, $from_name) {
        $di = \Phalcon\DI::getDefault();
        $db = $di->getShared('db');
        $tbl = $this->getSource();
        $text_id = 0;
        if (count($target_uids)>=5) { // share text in if more than
            # using text id
            $text_id = (new MailTextModel())->newText($content);
            if ($text_id === false) {
                syslog(LOG_ERR, "fail to insert into text");
                return false;
            }
            $content = '';
        }
        if (!$content) {
            $content = '';
        }
        $content = $db->escapeString($content);

        $sql_pre = "insert into $tbl (user_id, from_uid, from_name, text_id, mail_text, attachment, created_at) values ";
        if ($attachment !== null && $attachment !== false) {
            $attachment = json_encode($attachment);
            $attachment = $db->escapeString($attachment);
        } else {
            $attachment = "null";
        }
        if (!$from_name || strlen($from_name)==0) {
            $from_name = '';
        }
        $from_name = $db->escapeString($from_name);

        $affected_rows = 0;
        $sql_vals = array();
        $from_uid = intval($from_uid);
        foreach ($target_uids as $uid) {
            $uid = intval($uid);
            $sql_vals []= "($uid, $from_uid, $from_name, $text_id, $content, $attachment, now())";
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
