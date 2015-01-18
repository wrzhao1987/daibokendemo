<?php

namespace Cap\Models\db;

class FragmentModel{

    public static $SHARD_RADIX = 100;

    public $store_cols = array('id', 'role_id', 'fragment_no', 'count');

    public $sql_array = array(
    );

    protected $table = 'dragonball_fragment';

    public function __construct() {
        $this->_di = \Phalcon\DI::getDefault();
    }

    public function getFragments($role_id) {
        $db = $this->_di->getShared('db');
        $table = $this->getShardedTableName($role_id);
        $sql = "select fragment_no, count from $table where role_id=?";
        $rs = $db->query($sql, array($role_id));
        if (!$rs) {
            return false;
        }
        $data = $rs->fetchAll();
        return $data;
    }

    /*
     * decrease amount of fragment for role
     * return affected rows
     */
    public function decrFrag($role_id, $fragment_no, $count) {
        $db = $this->_di->getShared('db');
        $table = $this->getShardedTableName($role_id);
        $sql = "update $table set count=count-? where fragment_no=? and role_id=? and count>0";
        $r = $db->execute($sql, array($count, $fragment_no, $role_id));
        if ($r===false) {
            syslog(LOG_ERR, "error in decrFrag($role_id, $fragment_no, $count)");
            return false;
        }
        return $db->affectedRows();
    }

    /*
     * increase amount of fragment for role
     * return affected rows
     */
    public function addFrag($role_id, $fragment_no, $count) {
        $db = $this->_di->getShared('db');
        $table = $this->getShardedTableName($role_id);
        $sql = "insert into $table (role_id, fragment_no, count) values (?,?,?) on duplicate key update count=count+?";
        $r = $db->execute($sql, array($role_id, $fragment_no, $count, $count));
        if ($r===false) {
            syslog(LOG_ERR, "error in decrFrag($role_id, $fragment_no, $count):".$db->error);
            return false;
        }
        return $db->affectedRows();
    }

    /*
     * decrease amount of fragment with specified amount
     * all fragments count should greater than 0, otherwise return false
     */
    public function decrFragments($role_id, $frag_nos, $amount) {
        $db = $this->_di->getShared('db');
        $table = $this->getShardedTableName($role_id);
        $frags = implode(',', $frag_nos);
        /*
         * notice: did not grant atomic operation, if conflicts happens, just let it happen
         */
        $sql = "select count(*) as num from $table where role_id=$role_id and fragment_no in ($frags) and count>$amount";
        $ri = $db->query($sql);
        if (!$ri) {
            syslog(LOG_ERR, "error in execute [$sql]");
            return false;
        }
        while ($row = $ri->fetch()) {
            $count = $row['num'];
        }
        if (!isset($count) || $count < count($frag_nos)) {
            syslog(LOG_DEBUG, "not enough fragment($count/".count($frag_nos).") to decrease");
            return false;
        }
        $sql = "update $table set count=count-$amount where role_id=$role_id and fragment_no in ($frags) and count>$amount";
        $r = $db->execute($sql);
        if ($r===false) {
            syslog(LOG_ERR, "error in execute [$sql]:".$db->error);
            return false;
        }
        $affected_rows = $db->affectedRows();
        if ($affected_rows != count($frag_nos)) {
            syslog(LOG_WARNING, "decrFrag($role_id), [$sql], affectedrows="
                .$affected_rows.", not equal to ".count($frag_nos));
        }
        return $affected_rows;
    }

    protected function getShardedTableName($role_id) {
        # use remainder for shard
        return sprintf($this->table."_%02d", intval($role_id%self::$SHARD_RADIX));
    }

    public function getSource() {
        return $this->table;
    }
}


