<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-10-26
 * Time: 下午3:18
 */
namespace Cap\Libraries;

class EventLib extends BaseLib
{
    public $server_id = null;
    public static $EVENT_ID_NEW_SERVER_LOGIN = 1; // 新服累计登录奖励
    public static $EVENT_ID_NEW_SERVER_LVLUP = 2; // 新服冲级奖励
    public static $EVENT_ID_ALPHA_VIP = 10001; // 封测送VIP奖励

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
        $this->_di->set('mail_lib', function() {
            return new MailLib();
        }, true);
        $cfg = $this->getDI()->get('config');
        $this->server_id = $cfg['server_id'];
    }

    public function fireEvent($event_id, $params = [])
    {
        $handler = '';
        $cfg = self::getGameConfig('event');
        if (isset ($cfg[$this->server_id]) && isset ($cfg[$this->server_id][$event_id])) {
            $cfg = $cfg[$this->server_id][$event_id];
        } else {
            return false;
        }
        $curr_ts = time();
        $event_start = strtotime($cfg['start_time']);
        $event_end = strtotime($cfg['end_time']);
        if (! ($curr_ts >= $event_start && $curr_ts < $event_end)) {
            return false;
        }
        switch ($event_id) {
            case self::$EVENT_ID_NEW_SERVER_LOGIN:
                if (count($params) != 1) {
                    return false;
                }
                $handler = 'newServerLogin';
                $params[] = $curr_ts;
                $params[] = $event_start;
                $params[] = $cfg['conf'];
                break;
            case self::$EVENT_ID_ALPHA_VIP:
                $handler = 'alphaVip';
                $params[] = $curr_ts;
                $params[] = $event_start;
                $params[] = $cfg['conf'];
                break;
        }
        if (! $handler) {
            $ret = false;
        } else {
            $ret = call_user_func_array([__CLASS__, $handler], $params);
        }
        return $ret;
    }

    protected function newServerLogin($user_id, $curr_ts, $start_ts, $bonus)
    {
        $cache_key = 'nami:event:betalogin:%s';
        $now_day = intval(($curr_ts - $start_ts) / 86400) + 1;
        $now_cache_key = sprintf($cache_key, $now_day);
        $redis = $this->getDI()->getShared('redis');
        if (! $redis->sIsMember($now_cache_key, $user_id)) {
            $redis->sAdd($now_cache_key, $user_id);
        } else {
            return false;
        }
        if (true) return true;  // no mail sent
        $count = 0;
        for ($i = 1; $i <= $now_day; $i++) {
            $curr_cache_key = sprintf($cache_key, $i);
            if ($redis->sIsMember($curr_cache_key, $user_id)) {
                $count++;
            }
        }
        $index = min(8, $count);
        if (isset ($bonus[$index]['bonus'])) {
            $give = array_values($bonus[$index]['bonus']);
            $title = $bonus[$index]['mail_title'];
            $content = $bonus[$index]['mail_content'];
        } else {
            $give = array_values($bonus[$index]);
            $title = "封测送好礼";
            $content = "今天是您在封测期间累计第%s天登录游戏，非常感谢您对《悟空大冒险》的支持。为表谢意，我们为您送上了一份礼物，请在附件中查收。明天继续登录的话，还能获得更丰厚的奖励哦！";

        }
        $mail_lib = $this->getDI()->getShared('mail_lib');
        $content = sprintf($content, $count);
        $content = "{$title}\n{$content}";
        $mail_lib->sendMail(0, array($user_id), $content, $give, '小悟空');
        return true;
    }

    protected function alphaVip($curr_ts, $start_ts, $tmp_charge_num)
    {
        if ($curr_ts < $start_ts) {
            return [
                UserLib::$USER_PROF_FIELD_CHARGE => 0,
                UserLib::$USER_PROF_FIELD_VIP    => 0,
            ];
        }
        $now_day = intval(($curr_ts - $start_ts) / 86400) + 1;
        $charge = $tmp_charge_num[min(count($tmp_charge_num), $now_day)];
        return [
            UserLib::$USER_PROF_FIELD_CHARGE => $charge,
            UserLib::$USER_PROF_FIELD_VIP    => min(5, $now_day) * 3 ,
        ];
    }
}
