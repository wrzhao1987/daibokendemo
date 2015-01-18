<?php

class EventTask extends \Phalcon\CLI\Task
{
    public function betaLevelUpAction($params = null)
    {
        $server_id = $this->getDI()->getShared('config')['server_id'];
        $cfg =
            \Cap\Libraries\BaseLib::getGameConfig('event')
            [$server_id]
            [\Cap\Libraries\EventLib::$EVENT_ID_NEW_SERVER_LVLUP];
        if (! $cfg) {
            echo "Conf not found for server:{$server_id}, bye.\n";
            exit;
        }
        $detail_conf = $cfg['conf'];
        $start = strtotime($cfg['start_time']);
        $end   = strtotime($cfg['end_time']);
        $curr_ts = time();
        if ($curr_ts < $start || $curr_ts >= $end) {
            echo "Not in event, bye.\n";
            exit;
        }
        $now_day = intval(($curr_ts - $start) / 86400) + 1;
        if ($now_day >= 2 && $now_day <= 6) {
            $condition = $detail_conf[$now_day - 1]['condition'];
            $user_model = new \Cap\Models\Db\UserModel();
            $all_info = $user_model->getAllUsers();
            $targets = [];
            foreach ($all_info as $info) {
                if ($info['level'] >= $condition) {
                    $targets[] = $info['id'];
                }
            }
            $title = '';
            $content = '';
            $bonus = array_values($detail_conf[$now_day - 1]['bonus']);
            $mail_lib = new \Cap\Libraries\MailLib();
            $mail_lib->sendMail(0, $targets, "$title\n$content", $bonus, '小悟空');
        }
    }

    public function oldUserAction()
    {
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $user_lib = new \Cap\Libraries\UserLib();
        foreach ($all_info as $info) {
            $user = $user_lib->getUser($info['id']);
            $account_id = $user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_ACCOUNT_ID];
            echo $account_id . "\n";
        }
    }

    public function bonusToOldUserAction()
    {
        $file_path = '';
        $old_users = file($file_path);
        $user_model = new \Cap\Models\Db\UserModel();
        $all_info = $user_model->getAllUsers();
        $user_lib = new \Cap\Libraries\UserLib();
        $targets = [];
        foreach ($all_info as $info) {
            $user = $user_lib->getUser($info['id']);
            if (in_array($user[\Cap\Libraries\UserLib::$USER_PROF_FIELD_ACCOUNT_ID], $old_users)) {
                $targets[] = $info['id'];
            }
        }
        $title = '';
        $content = '';
        $bonus = [];
        $mail_lib = new \Cap\Libraries\MailLib();
        $mail_lib->sendMail(0, $targets, "$title\n$content", $bonus, '小悟空');
    }
}