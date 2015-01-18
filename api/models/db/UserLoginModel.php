<?php

namespace Cap\Models\db;

class UserLoginModel extends BaseModel
{
    public $ts = null;
    public function onConstruct()
    {
        $this->setConnectionService('account_db');
    }

    public function getSource()
    {
        if ($this->ts) {
            $date = date('Ymd', $this->ts);
        } else {
            $date = date('Ymd');
        }
        return 'user_login_' . $date;
    }

    public function createLog($server_id, $account_id, $user_id, $uuid, $login_at, $ip)
    {
        $sql = "INSERT INTO __TABLE_NAME__ (server_id, account_id, user_id, uuid, login_at, ip)
                VALUES (:server_id:, :account_id:, :user_id:, :uuid:, :login_at:, :ip:)";
        $ret = $this->executeSQL($sql, [
            'server_id' => $server_id,
            'account_id' => $account_id,
            'user_id' => $user_id,
            'uuid' => $uuid,
            'login_at' => $login_at,
            'ip' => $ip,
        ]);
        return $ret->success();
    }

    public function getByServer($server_id, $ts = null)
    {
        $this->ts = $ts ? $ts : time();
        $sql = "SELECT * FROM __TABLE_NAME__ WHERE server_id = '{$server_id}'";
        $ret = $this->executeSQL($sql, []);
        return $ret->count() ? $ret->toArray() : [];
    }
}