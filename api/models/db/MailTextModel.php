<?php

namespace Cap\Models\db;

class MailTextModel extends BaseModel {

    public function getSource() {
        return 'mail_text';
    }

    public function newText($content) {
        $db = \Phalcon\DI::getDefault()->getShared('db');
        $tbl = $this->getSource();
        $sql = "insert into $tbl (content) values (?)";
        $r = $db->execute($sql, array($content));
        if ($r) {
            return $db->lastInsertId();
        } else {
            return false;
        }
    }
}
