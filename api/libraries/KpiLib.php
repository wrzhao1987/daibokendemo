<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-11-10
 * Time: 下午2:57
 */
namespace Cap\Libraries;


use Cap\Models\Db\KpiJoinModel;

class KpiLib extends BaseLib
{
    public static $EVENT_TYPE_DBALL_ROB = 1; // 夺龙珠
    public static $EVENT_TYPE_WANTED = 2; // 悬赏
    public static $EVENT_TYPE_HERO_MISSON = 3; // 英雄副本
    public static $EVENT_TYPE_ARENA = 4; // 排位赛
    public static $EVENT_TYPE_CHALLENGE = 5; // 挑战
    public static $EVENT_TYPE_TECH = 6; // 科技
    public static $EVENT_TYPE_TEMPLE = 7; // 神殿
    public static $EVENT_TYPE_KARIN = 8; // 卡林神塔
    public static $EVENT_TYPE_CRUSADE = 9; // 蛇道
    public static $EVENT_TYPE_GUILD_BOSS = 10; // 公会BOSS
    public static $EVENT_TYPE_CONTEST = 11; // 擂台赛

    public function __construct() {
        parent::__construct();
        $this->_di->set('user_lib', function() {
            return new UserLib();
        }, true);
        $this->_di->set('join_model', function () {
            return new KpiJoinModel();
        });
    }
    public function recordSysJoin($user_id, $type, $user_level = null)
    {
        $user_lib = $this->getDI()->getShared('user_lib');
        if (! $user_level) {
            $user = $user_lib->getUser($user_id);
            $user_level = $user[UserLib::$USER_PROF_FIELD_LEVEL];
        }
        (new ResqueLib())->setJob('kpi', 'CreateRec', [
            'user_id' => $user_id,
            'type'    => $type,
            'user_level' => $user_level,
            'ts' => time(),
        ]);
    }
}