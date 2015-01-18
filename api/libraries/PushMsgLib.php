<?php

class PushLib {

    public static $MSG_TYPE_BROADCAST = 1;
    public static $MSG_TYPE_FRND_ADD_REQ = 2;
    public static $MSG_TYPE_FRND_DEL = 3;
    public static $MSG_TYPE_FRND_GIVEENERGY = 4;
    public static $MSG_TYPE_MAIL = 5;
    public static $MSG_TYPE_FRND_NEW = 6;
    public static $MSG_TYPE_MSG_GUILD = 7;
    public static $MSG_TYPE_MSG_PRIVITE = 8;
    public static $MSG_TYPE_FRND_DECLINE = 9;
    public static $KEY_PUSH_TASK_QUEUE = 'queue_msg_push';

    public function __construct() {
        $rds = new \redis();
        $rds->connect('127.0.0.1', 6379);
        $this->redis = $rds;
    }

    /*
     * push msg: add task to redis queue
     * param $msg {
     *      type,
     *      from,
     *      to,
     *      ts,
     *      ...
     * }
     */
    public function pushMsg($msg) {
        if (!is_array($msg)) {
            syslog(LOG_ERR, "pushMsg content type should be array");
            return false;
        }
        if (!isset($msg['from']) || !isset($msg['to']) || !isset($msg['type'])) {
            syslog(LOG_ERR, "incomplete msg parameters in ".json_encode($msg));
            return false;
        }
        if ($msg['to'] == '*') {
            $msg['to'] = 0;
        }
        $str = json_encode($msg, JSON_NUMERIC_CHECK);
        $r =  $this->redis->rpush(self::$KEY_PUSH_TASK_QUEUE, $str);
        if (!$r) {
            syslog(LOG_ERR, "fail to add push task to queue");
        }
        return $r;
    }
}

// end of file
