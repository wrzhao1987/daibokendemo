<?php
use Cap\Libraries\MailLib;
use Cap\Models\Db\UserModel;

class MailTask extends \Phalcon\CLI\Task
{
    public static $MAIL_QUEUE_KEY       = 'nami:admin:mail:queue';
    public static $MAIL_ADMIN_ROLE_ID   = 9527;
    public static $MAIL_ADMIN_NICK_NAME = '系统管理员';

    public function sendAction()
    {
        $mail_lib = new MailLib();
        $redis = $this->getDI()->getShared('redis');
        $mail = $redis->lPop(self::$MAIL_QUEUE_KEY);
        if ($mail) {
            $mail = json_decode($mail, true);
			$mail['content'] = $mail['title'] . "\n" . $mail['content'];
			$attach = ! empty($mail['attach']) ? $mail['attach'] : false;
            if ($mail['users'] == -1) {
                $mail_lib->sendMail(self::$MAIL_ADMIN_ROLE_ID,
                    [0], $mail['content'],
					$attach,
                    self::$MAIL_ADMIN_NICK_NAME);
            } else if (is_array($mail['users'])) {
                $user_model = new UserModel();
                $users = $user_model->getUsersByName($mail['users']);
				$target_ids = array_column($users, 'id');
                $mail_lib->sendMail(self::$MAIL_ADMIN_ROLE_ID,
                    $target_ids, $mail['content'],
					$attach,
                    self::$MAIL_ADMIN_NICK_NAME);
            }
        } else {
            echo "No mail to send, bye.\n";
        }
    }
}
