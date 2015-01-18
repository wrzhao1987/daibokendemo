<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-9-12
 * Time: 下午2:08
 */
namespace Cap\Libraries;

use Cap\Models\Db\GuildMemberModel;
use Cap\Models\Db\GuildModel;
use Cap\Models\Db\GuildRequestModel;
use Cap\Models\Db\GuildLogModel;
use Phalcon\Exception;

class GuildLib extends BaseLib
{
    // 公会头衔代码
    public static $MEMBER_TYPE_HUIZHANG   = 1; // 会长
    public static $MEMBER_TYPE_FUHUIZHANG = 2; // 副会长
    public static $MEMBER_TYPE_ZHANGLAO   = 3; // 长老
    public static $MEMBER_TYPE_NORMAL     = 4; // 普通会员

    // 日志类型代码
    public static $LOG_TYPE_MEMBER_JOIN              = 1;  // 成员加入公会
    public static $LOG_TYPE_MEMBER_QUIT              = 2;  // 成员退出公会
    public static $LOG_TYPE_MEMBER_PROMOTE           = 3;  // 成员晋升
    public static $LOG_TYPE_MEMBER_DEGRADE           = 4;  // 成员降级
    public static $LOG_TYPE_MEMBER_CONTRIBUTE_GOLD   = 5;  // 成员通过金币贡献公会
    public static $LOG_TYPE_MEMBER_CONTRIBUTE_ENERGY = 6;  // 成员通过消耗体力贡献公会
    public static $LOG_TYPE_MISSION_RESET            = 7;  // 公会副本重置
    public static $LOG_TYPE_MISSION_PASS             = 8;  // 公会副本通关
    public static $LOG_TYPE_LEVELUP_SELF             = 9;  // 公会升级
    public static $LOG_TYPE_LEVELUP_BUILDING         = 10; // 公会建筑升级
    public static $LOG_TYPE_KICKED                   = 11; // 开除出公会
    public static $LOG_TYPE_LEADER_TRANS             = 12; // 转让会长

    public static $CACHE_KEY_GUILD_AVAILABLE = 'nami:guild:available';  // 可用随机公会列表
    public static $CACHE_KEY_GUILD_MEMBER_COUNT = 'nami:guild:member:%s'; // 公会成员数计数
    public static $CACHE_KEY_GUILD_KICK_COUNT = 'nami:guild:kick:%s';
    public static $CACHE_KEY_GUILD_STRENGTH_RANK = 'nami:guild:rank';
    public static $CACHE_KEY_GUILD_STRENGTH_RANK_DETAIL = 'nami:guild:rank:detail';

    public static $STATUS_FIELD_GID    = 'gid';
    public static $STATUS_FIELD_UID    = 'uid';
    public static $STATUS_FIELD_MID    = 'mid';
    public static $STATUS_FIELD_GRADE  = 'grade';
    public static $STATUS_FIELD_GNAME  = 'gname';
    public static $STATUS_FIELD_GICON  = 'gicon';
    public static $STATUS_FIELD_GLEVEL = 'glevel';
    public static $STATUS_FIELD_GFUND  = 'gfund';
    public static $STATUS_FIELD_NOTICE = 'gnotice';

    public static $DONATE_TYPE_MONEY = 1;
    public static $DONATE_TYPE_ENERGY = 2;
    public static $DONATE_LIMIT_MONEY = 500;
    public static $DONATE_LIMIT_ENERGY = 500;
    public static $CACHE_KEY_DAILY_DONATE_MONEY  = 'nami:guild:dmoney:%s';  // 每日贡献索尼币
    public static $CACHE_KEY_DAILY_DONATE_ENERGY = 'nami:guild:denergy:%s'; // 每日贡献体力

    public static $CACHE_KEY_TOTAL_DONATE = 'nami:guild:dtotal:%s';
    public static $TOTAL_DONATE_FIELD_MONEY = 'money';
    public static $TOTAL_DONATE_FIELD_DONATION = 'donation';

    public static $GUILD_LEVEL_CONF = [
        1  => ['up_cost' => 0,         'member_limit' => 30],
        2  => ['up_cost' => 1800000,   'member_limit' => 35],
        3  => ['up_cost' => 2800000,   'member_limit' => 40],
        4  => ['up_cost' => 4800000,   'member_limit' => 45],
        5  => ['up_cost' => 7200000,  'member_limit' => 50],
        6  => ['up_cost' => 10000000,  'member_limit' => 55],
        7  => ['up_cost' => 13200000,  'member_limit' => 60],
        8  => ['up_cost' => 24000000, 'member_limit' => 65],
        9  => ['up_cost' => 31200000, 'member_limit' => 70],
        10 => ['up_cost' => 42000000, 'member_limit' => 75],
    ];

    public static $DAILY_MAX_KICK = 10;

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('guild_model', function () {
            return new GuildModel();
        }, true);
        $this->_di->set('member_model', function () {
            return new GuildMemberModel();
        }, true);
        $this->_di->set('request_model', function () {
            return new GuildRequestModel();
        }, true);
        $this->_di->set('log_model', function () {
            return new GuildLogModel();
        }, true);
        $this->_di->set('mail_lib', function () {
            return new MailLib();
        }, true);
        $this->_di->set('card_lib', function () {
            return new CardLib();
        }, true);
        $this->_di->set('user_lib', function () {
            return new UserLib();
        }, true);
        $this->_di->set('g_m_lib', function () {
            return new GuildMissionLib();
        }, true);
    }

    // 创建公会
    public function create($uid, $name, $icon)
    {
        // 判断用户是否已经属于某公会
        $user_status = $this->status($uid);
        // 如果没有公会
        if (empty ($user_status)) {
            $m_model = $this->getDI()->getShared('member_model');
            $user_lib = $this->getDI()->getShared('user_lib');
            $user_lib->getUser($uid);
            if (! $user_lib->consumeFieldAsync($uid, UserLib::$USER_PROF_FIELD_GOLD, 500)) {
                throw new Exception('钻石不足，无法创建公会.', ERROR_CODE_FAIL);
            }
            $g_model = $this->getDI()->getShared('guild_model');
            $exists = GuildModel::find("name = '$name'");
            if ($exists->count()) {
                throw new Exception("公会名称已存在.", ERROR_CODE_DATA_INVALID_GUILD);
            }
            $new_gid  = $g_model->createNew($name, $icon);
            if ($new_gid) {
                // 在公会成员表中，添加创始人
                $m_model->addMember($new_gid, $uid, self::$MEMBER_TYPE_HUIZHANG);
                // 向随机公会选取列表中插入新公会ID
                $this->redis->sAdd(self::$CACHE_KEY_GUILD_AVAILABLE, $new_gid);
                // 公会人数计数自增
                $m_count_key = sprintf(self::$CACHE_KEY_GUILD_MEMBER_COUNT, $new_gid);
                $this->redis->incr($m_count_key);
                $ret['basic'] = [
                    'my_position' => self::$MEMBER_TYPE_HUIZHANG,
                    'guild_id' => $new_gid,
                    'guild_name' => $name,
                    'guild_icon' => $icon,
                    'guild_lv' => 1,
                    'guild_total_money' => 0,
                    'guild_member_count' => 1,
                    'guild_announcement' => '',
                    'guild_combat' => 0,
                    'guild_rank' => -1,
                    'total_donate_money' => 0,
                    'total_donate_donation' => 0,
                    'today_donate_money' => 0,
                    'today_donate_energy' => 0,
                ];
                $card_lib = $this->getDI()->getShared('card_lib');
                $deck_view = $card_lib->getDeckCardsOverview($uid);
                foreach ($deck_view as $card) {
                    $ret['basic']['guild_combat'] += is_array($card) ? $card['strength'] : 0;
                }
                $ret['member_list'] = $this->memberList($new_gid);
                return $ret;
            } else {
                throw new Exception('创建公会失败:内部错误.', ERROR_CODE_DB_ERROR_MYSQL);
            }
        } else {
            throw new Exception('创建公会失败:已有所属公会.', ERROR_CODE_DATA_INVALID_GUILD);
        }
    }

    // 解散公会
    public function dismiss($uid)
    {
        $ret = ['code' => 200, 'msg' => ''];
        $user_status = $this->status($uid);
        if (! empty($user_status)) {
            if ($user_status[self::$STATUS_FIELD_GRADE] == self::$MEMBER_TYPE_HUIZHANG) {
                $g_model = $this->getDI()->getShared('guild_model');
                $m_model = $this->getDI()->getShared('member_model');
                $members = $m_model->getMembers($user_status[self::$STATUS_FIELD_GID]);
                $member_ids = array_column($members, 'uid');
                $g_model->remove($user_status[self::$STATUS_FIELD_GID]);
                $m_model->removeByGid($user_status[self::$STATUS_FIELD_GID]);
                $this->redis->sRem(self::$CACHE_KEY_GUILD_AVAILABLE, $user_status[self::$STATUS_FIELD_GID]);
                $g_m_lib = $this->getDI()->getShared('g_m_lib');
                // 解散公会的时候要清掉mission数据
                $g_m_lib->releaseMission($user_status[self::$STATUS_FIELD_GID]);
                $mail_lib = $this->getDI()->getShared('mail_lib');
                $this->eraseGuildInfo($uid);
                $mail_content  = "悲催的孩子!\n";
                $mail_content .= "辛辛苦苦好多年，一朝回到出生前啊！我可怜的战士 ，您的公会会长就在刚才，把你的公会给强拆啦！你要坚强起来哦！";
                $mail_lib->sendMail($uid, $member_ids, $mail_content, [], '公会管理员');
            } else {
                throw new Exception('你不是会长，无法进行此项操作.', ERROR_CODE_DATA_INVALID_GUILD);
            }
        } else {
            throw new Exception('你已不属于任何公会，请检查邮箱.', ERROR_CODE_DATA_INVALID_GUILD);
        }
        return $ret;
    }

    // 请求加入公会
    public function requestJoin($uid, $gid)
    {
        $ret = ['code' => 200, 'rid' => 0];
        $user_status = $this->status($uid);
        if (! empty ($user_status)) {
            throw new Exception('已有所属公会，无法再向其他公会发出入会请求.', ERROR_CODE_DATA_INVALID_GUILD);
        }
        // 获得退出公会记录
        $log_model = $this->getDI()->getShared('log_model');
        $quit_log  = $log_model->getLogByUid($uid, self::$LOG_TYPE_MEMBER_QUIT);
        $now = time();
        foreach ($quit_log as $item) {
            $log_time = strtotime($item['created_at']);
            $delta = $now - $log_time;
            // 判断2，想要加入相同公会需要至少48小时
            if ($gid == $item['gid']) {
                if ($delta < 48 * 3600) {
                    throw new Exception('申请失败,退出相同公会不足48小时.', ERROR_CODE_DATA_INVALID_GUILD);
                }
            } else {
                // 判断1，必须退出前公会超过1小时
                if ($delta < 3600) {
                    throw new Exception('申请失败,退出前公会不足1小时.', ERROR_CODE_DATA_INVALID_GUILD);
                }
            }
        }
        // 获得申请入会记录
        $req_model = $this->getDI()->getShared('request_model');
        $req_log = $req_model->getRequestByUID($uid);
        if (is_array($req_log)) {
            $req_count = count($req_log);
            // 判断5，最多3个请求
            if ($req_count >= 3) {
                throw new Exception('您已经向3个公会发起了入会请求，请耐心等待会长们的批准，无需再次申请。', ERROR_CODE_DATA_INVALID_GUILD);
            }
            foreach ($req_log as $item) {
                $rid = $item['id'];
                $log_time = strtotime($item['created_at']);
                $req_gid  = $item['gid'];
                if ($req_gid == $gid) {
                    // 判断4，超过3天的请求，刷新请求时间，防止多个请求出现在管理员界面
                    if ($now - $log_time <= 3 * 86400) {
                        throw new Exception('您已经申请过该公会,请等待会长审批.', ERROR_CODE_DATA_INVALID_GUILD);
                    } else {
                        // 超过3天，重新设置请求的请求时间
                        $req_model->updateRequestTime($rid);
                        $ret['rid'] = $rid;
                    }
                }
            }
        }
        // 检查都没有问题，插入一条新的入会请求
        $new_rid = $req_model->createRequest($uid, $gid);
        if (intval($new_rid) > 0) {
            $ret['rid'] = intval($new_rid);
            return $ret;
        } else {
            throw new Exception('入会请求提交失败！', ERROR_CODE_DB_ERROR_MYSQL);
        }
    }

    // 管理员拒绝用户加入公会,UID为当前登录用户ID，正常情况下应该为管理层
    public function refuseJoin($uid, $rid)
    {
        $ret = ['code' => 200, 'rid' => $rid];
        $user_status = $this->status($uid);
        if (! empty($user_status)) {
            $grade = $user_status[self::$STATUS_FIELD_GRADE];
            // 长老以上才能拒绝入会
            if (in_array($grade, [
                self::$MEMBER_TYPE_HUIZHANG,
                self::$MEMBER_TYPE_FUHUIZHANG,
                self::$MEMBER_TYPE_ZHANGLAO,
            ])) {
                $r_model = $this->getDI()->getShared('request_model');
                $r_info  = $r_model->getRequestByID($rid);
                if (! $r_info) {
                    throw new Exception('入会请求不存在.', ERROR_CODE_DATA_INVALID_GUILD);
                }
                if ($r_info['gid'] != $user_status['gid']) {
                    throw new Exception('公会信息不匹配，无法拒绝会员加入.', ERROR_CODE_DATA_INVALID_GUILD);
                }
                $r_model->removeRequest($rid);
                $g_name = $user_status[self::$STATUS_FIELD_GNAME];
                $mail_lib = $this->getDI()->getShared('mail_lib');
                $mail_content  = "入会申请被拒绝\n";
                $mail_content .= "您加入公会{$g_name}的申请被拒绝，请继续申请其他公会.";
                $mail_lib->sendMail($uid, [$r_info['uid'], ], $mail_content, [], '公会管理员');
            } else {
                throw new Exception('非常抱歉，你没有权限拒绝会员加入.', ERROR_CODE_DATA_INVALID_GUILD);
            }
        } else {
            throw new Exception('你已不属于任何公会，请检查邮箱.', ERROR_CODE_DATA_INVALID_GUILD);
        }
        return $ret;
    }

    // 管理员允许用户加入公会
    public function admitJoin($uid, $rid)
    {
        $ret = ['code' => 200, 'mid' => $rid];
        $user_status = $this->status($uid);
        if (! empty($user_status)) {
            $grade = $user_status[self::$STATUS_FIELD_GRADE];
            // 长老以上才能同意入会申请
            if (in_array($grade, [
                self::$MEMBER_TYPE_HUIZHANG,
                self::$MEMBER_TYPE_FUHUIZHANG,
                self::$MEMBER_TYPE_ZHANGLAO,
            ])) {
                $r_model = $this->getDI()->getShared('request_model');
                $r_info  = $r_model->getRequestByID($rid);
                if (! $r_info) {
                    throw new Exception('入会请求不存在.', ERROR_CODE_DATA_INVALID_GUILD);
                }
                if ($r_info['gid'] != $user_status['gid']) {
                    throw new Exception('公会信息不匹配，无法拒绝会员加入.', ERROR_CODE_DATA_INVALID_GUILD);
                }
                $target_info = $this->status($r_info['uid']);
                if (! empty($target_info)) {
                    $t_gid = $target_info[self::$STATUS_FIELD_GID];
                    if ($t_gid == $user_status[self::$STATUS_FIELD_GID]) {
                        throw new Exception('公会其他管理员已经通过了该请求.', ERROR_CODE_DATA_INVALID_GUILD);
                    } else {
                        $r_model->removeRequest($rid);
                        throw new Exception('玩家已经加入了其他公会.', ERROR_CODE_DATA_INVALID_GUILD);
                    }
                }
                $cache_key_m_count = sprintf(self::$CACHE_KEY_GUILD_MEMBER_COUNT, $r_info['gid']);
                // 公会人数不能超过等级限制
                $m_count = $this->redis->get($cache_key_m_count);
                $g_level = $user_status[self::$STATUS_FIELD_GLEVEL];
                if ($m_count < self::$GUILD_LEVEL_CONF[$g_level]['member_limit']) {
                    $m_model = $this->getDI()->getShared('member_model');
                    $mid = $m_model->addMember($r_info['gid'], $r_info['uid'], self::$MEMBER_TYPE_NORMAL);
                    if ($mid > 0) {
                        $ret['mid'] = $mid;
                    } else {
                        throw new Exception("加入新会员失败.", ERROR_CODE_DB_ERROR_MYSQL);
                    }
                    $r_model->removeRequest($rid);
                    $user_lib = $this->getDI()->getShared('user_lib');
                    $user = $user_lib->getUser($r_info['uid']);
                    $this->writeLog(
                        $r_info['uid'],
                        $user_status[self::$STATUS_FIELD_GID],
                        self::$LOG_TYPE_MEMBER_JOIN,
                        $user[UserLib::$USER_PROF_FIELD_NAME]
                    );
                    $this->redis->incr($cache_key_m_count);
                    // 发送邮件
                    $mail_lib = $this->getDI()->getShared('mail_lib');
                    $g_name = $user_status[self::$STATUS_FIELD_GNAME];
                    $mail_content = "成功加入公会\n你已经成功加入了公会{$g_name}，祝你愉快!";
                    $mail_lib->sendMail($uid, [$r_info['uid'], ], $mail_content, [], '公会管理员');
                } else {
                    throw new Exception('公会人数已满，无法通过请求.', ERROR_CODE_DATA_INVALID_GUILD);
                }
            }
        } else {
            throw new Exception('你已不属于任何公会，请检查邮箱.', ERROR_CODE_DATA_INVALID_GUILD);
        }
        return $ret;
    }

    // 用户主动退出公会
    public function quit($uid)
    {
        $user_status = $this->status($uid);
        if (! empty($user_status)) {
            $grade = $user_status[self::$STATUS_FIELD_GRADE];
            if (self::$MEMBER_TYPE_HUIZHANG == $grade) {
                throw new Exception('会长无法退出公会.', ERROR_CODE_DATA_INVALID_GUILD);
            }
            $m_model = $this->getDI()->getShared('member_model');
            $m_model->removeMember($user_status[self::$STATUS_FIELD_MID]);
            $user_lib = $this->getDI()->getShared('user_lib');
            $user = $user_lib->getUser($uid);
            $this->writeLog(
                $uid,
                $user_status[self::$STATUS_FIELD_GID],
                self::$LOG_TYPE_MEMBER_QUIT,
                $user[UserLib::$USER_PROF_FIELD_NAME]);
            $this->eraseGuildInfo($uid);
            // 减少公会成员计数
            $gid = $user_status[self::$STATUS_FIELD_GID];
            $m_count_key = sprintf(self::$CACHE_KEY_GUILD_MEMBER_COUNT, $gid);
            $this->redis->incrBy($m_count_key, -1);
            // 发送邮件
            $mail_lib = $this->getDI()->getShared('mail_lib');
            $g_name = $user_status[self::$STATUS_FIELD_GNAME];
            $mail_content = "成功退出公会\n你已经成功退出了公会{$g_name}。";
            $mail_lib->sendMail($uid, [$uid, ], $mail_content, [], '公会管理员');
            return ['code' => 200, 'msg' => '退出公会成功.'];
        } else {
            throw new Exception('你已不属于任何公会，请检查邮箱.', ERROR_CODE_DATA_INVALID_GUILD);
        }
    }

    private function eraseGuildInfo($uid)
    {
        $key_today_donate_money  = sprintf(self::$CACHE_KEY_DAILY_DONATE_MONEY, $uid);
        $key_today_donate_energy = sprintf(self::$CACHE_KEY_DAILY_DONATE_ENERGY, $uid);
        $key_total_donate = sprintf(self::$CACHE_KEY_TOTAL_DONATE, $uid);

        $this->redis->multi();
        $this->redis->del($key_today_donate_money);
        $this->redis->del($key_today_donate_energy);
        $this->redis->hMSet($key_total_donate, [
            self::$TOTAL_DONATE_FIELD_DONATION => 0,
            self::$TOTAL_DONATE_FIELD_MONEY => 0,
        ]);
        // $this->redis->hSet(sprintf(UserLib::$USER_PROF_KEY, $uid), UserLib::$USER_PROF_FIELD_GCOIN, 0);
        $this->redis->exec();
    }
    // 管理员改变用户阶级
    public function changeGrade($uid, $target_mid, $target_grade)
    {
        $ret = ['code' => 200, 'msg' => ''];
        $user_status = $this->status($uid);
        if (! empty($user_status)) {
            $gid = $user_status[self::$STATUS_FIELD_GID];
            if (in_array($target_grade, [
                self::$MEMBER_TYPE_HUIZHANG,
                self::$MEMBER_TYPE_FUHUIZHANG,
                self::$MEMBER_TYPE_ZHANGLAO,
                self::$MEMBER_TYPE_NORMAL,
            ])) {
                $user_lib = $this->getDI()->getShared('user_lib');
                $m_model = $this->getDI()->getShared('member_model');
                $members = $m_model->getMembers($gid, $target_grade);
                $member_count = count($members);
                //为日志准备目标用户和当前用户的USER信息
                $target_m_info = $m_model->getMemberById($target_mid);
                $curr_user = $user_lib->getUser($uid);
                $target_user = $user_lib->getUser($target_m_info['uid']);
                switch ($target_grade) {
                    case self::$MEMBER_TYPE_HUIZHANG:
                        // 退位让贤
                        if ($user_status[self::$STATUS_FIELD_GRADE] == self::$MEMBER_TYPE_HUIZHANG) {
                            $m_model->modGrade($user_status[self::$STATUS_FIELD_MID], self::$MEMBER_TYPE_NORMAL);
                            $m_model->modGrade($target_mid, self::$MEMBER_TYPE_HUIZHANG);
                            // 记录禅让日志
                            $this->writeLog(0, $user_status[self::$STATUS_FIELD_GID], self::$LOG_TYPE_LEADER_TRANS, [
                                $curr_user[UserLib::$USER_PROF_FIELD_NAME],
                                $target_user[UserLib::$USER_PROF_FIELD_NAME],
                            ]);
                        } else {
                            throw new Exception('只有会长可以退位让贤.', ERROR_CODE_DATA_INVALID_GUILD);
                        }
                        break;
                    case self::$MEMBER_TYPE_FUHUIZHANG:
                        if ($user_status[self::$STATUS_FIELD_GRADE] == self::$MEMBER_TYPE_HUIZHANG) {
                            if ($member_count >= 0 && $member_count < 2) {
                                $m_model->modGrade($target_mid, self::$MEMBER_TYPE_FUHUIZHANG);
                                // 记录晋升日志
                                $this->writeLog($target_m_info['uid'], $target_m_info['gid'], self::$LOG_TYPE_MEMBER_PROMOTE, [
                                    $curr_user[UserLib::$USER_PROF_FIELD_NAME],
                                    $target_user[UserLib::$USER_PROF_FIELD_NAME],
                                    self::memberTypeToName(self::$MEMBER_TYPE_FUHUIZHANG),
                                ]);
                            } else {
                                throw new Exception('副会长人数已满，无法任命.', ERROR_CODE_DATA_INVALID_GUILD);
                            }
                        } else {
                            throw new Exception('只有会长可以任命副会长.', ERROR_CODE_DATA_INVALID_GUILD);
                        }
                        break;
                    case self::$MEMBER_TYPE_ZHANGLAO:
                        // 副会长以上官衔才能任命长老
                        if ($user_status[self::$STATUS_FIELD_GRADE] <= self::$MEMBER_TYPE_FUHUIZHANG) {
                            if ($member_count >= 0 && $member_count < 2) {
                                $m_model->modGrade($target_mid, self::$MEMBER_TYPE_ZHANGLAO);
                                // 记录晋升日志
                                $this->writeLog($target_m_info['uid'], $target_m_info['gid'], self::$LOG_TYPE_MEMBER_PROMOTE, [
                                    $curr_user[UserLib::$USER_PROF_FIELD_NAME],
                                    $target_user[UserLib::$USER_PROF_FIELD_NAME],
                                    self::memberTypeToName(self::$MEMBER_TYPE_ZHANGLAO),
                                ]);
                            } else {
                                throw new Exception('长老人数已满，无法任命.', ERROR_CODE_DATA_INVALID_GUILD);
                            }
                        } else {
                            throw new Exception('只有副会长以上可以任命长老.', ERROR_CODE_DATA_INVALID_GUILD);
                        }
                        break;
                    case self::$MEMBER_TYPE_NORMAL:
                        // 只有降级才会出现普通会员这种情况,并且只有公会会长可以降级
                        if ($user_status[self::$STATUS_FIELD_GRADE] < $target_m_info['grade']
                        && ($user_status[self::$STATUS_FIELD_GRADE] != self::$MEMBER_TYPE_ZHANGLAO)) {
                            $m_model->modGrade($target_mid, self::$MEMBER_TYPE_NORMAL);
                            // 记录被贬日志
                            $this->writeLog($target_m_info['uid'], $target_m_info['gid'], self::$LOG_TYPE_MEMBER_DEGRADE, [
                                $curr_user[UserLib::$USER_PROF_FIELD_NAME],
                                $target_user[UserLib::$USER_PROF_FIELD_NAME],
                                self::memberTypeToName($target_m_info['grade']),
                                self::memberTypeToName(self::$MEMBER_TYPE_NORMAL),
                            ]);
                        } else {
                            throw new Exception('你没有权限这样做.', ERROR_CODE_DATA_INVALID_GUILD);
                        }
                        break;
                }
            }
        } else {
            throw new Exception('你已不属于任何公会.', ERROR_CODE_DATA_INVALID_GUILD);
        }
        return $ret;
    }

    // 管理员踢出公会成员
    public function kick($uid, $target_mid)
    {
        $ret = ['code' => 200, 'msg' => ''];
        $user_status = $this->status($uid);
        if ($user_status[self::$STATUS_FIELD_GRADE] <= self::$MEMBER_TYPE_ZHANGLAO) {
            $m_model = $this->getDI()->getShared('member_model');
            $m_info = $m_model->getMemberById($target_mid);
            $grade = $m_info['grade'];
            if (self::$MEMBER_TYPE_NORMAL != $grade) {
                throw new Exception('只有普通会员可以被踢出.', ERROR_CODE_DATA_INVALID_GUILD);
            }
            $count = $this->incrKickCount($user_status[self::$STATUS_FIELD_GID]);
            if (! $count) {
                throw new Exception('每日踢人次数超限.', ERROR_CODE_DATA_INVALID_GUILD);
            }

            $m_model->removeMember($target_mid);
            $cache_key_m_count = sprintf(self::$CACHE_KEY_GUILD_MEMBER_COUNT, $user_status[self::$STATUS_FIELD_GID]);
            $this->redis->incrBy($cache_key_m_count, -1);
            $this->eraseGuildInfo($m_info['uid']);
            // 记录日志
            $user_lib = $this->getDI()->getShared('user_lib');
            $curr_user = $user_lib->getUser($uid);
            $target_user = $user_lib->getUser($m_info['uid']);
            $this->writeLog($uid, $m_info['gid'], self::$LOG_TYPE_KICKED, [
                $curr_user[UserLib::$USER_PROF_FIELD_NAME],
                $target_user[UserLib::$USER_PROF_FIELD_NAME],
            ]);
            // 发送邮件
            $mail_lib = $this->getDI()->getShared('mail_lib');
            $g_name = $user_status[self::$STATUS_FIELD_GNAME];
            $mail_content = "悲催的孩子!\n您已经被{$g_name}公会管理员踢出公会，请知晓。";
            $mail_lib->sendMail($uid, [$m_info['uid'], ], $mail_content, [], '公会管理员');
        } else {
            throw new Exception('只有长老以上可以踢出公会成员.', ERROR_CODE_DATA_INVALID_GUILD);
        }
        return $ret;
    }

    // 更新今日踢人计数
    private function incrKickCount($gid) {
        $cache_key = sprintf(self::$CACHE_KEY_GUILD_KICK_COUNT, $gid);
        $kick_count = $this->redis->incr($cache_key);
        if (1 == $kick_count) {
            $this->redis->expireAt($cache_key, self::getDefaultExpire());
        }
        if ($kick_count > self::$DAILY_MAX_KICK) {
            return false;
        }
        return $kick_count;
    }

    // 公会成员列表
    public function memberList($gid)
    {
        $user_lib = $this->getDI()->getShared('user_lib');
        $m_model = $this->getDI()->getShared('member_model');
        $m_list = $m_model->getMembers($gid);
        $card_lib = $this->getDI()->getShared('card_lib');
        foreach ($m_list as & $item) {
            $user = $user_lib->getUser($item['uid']);
            $item['name'] = $user[UserLib::$USER_PROF_FIELD_NAME];
            $item['level'] = $user[UserLib::$USER_PROF_FIELD_LEVEL];
            $item['deck'] = $card_lib->getDeckCardsOverview($item['uid']);
            $item['contr'] = isset($user[UserLib::$USER_PROF_FIELD_GCOIN]) ? $user[UserLib::$USER_PROF_FIELD_GCOIN] : 0;
            $item['mid'] = $item['id'];
            $key_total = sprintf(self::$CACHE_KEY_TOTAL_DONATE, $item['uid']);
            $d_m = $this->redis->hGet($key_total, self::$TOTAL_DONATE_FIELD_MONEY);
            $item['donate_money'] = $d_m ? intval($d_m) : 0;
            unset($item['id']);
            unset($item['gid']);
        }
        return $m_list;
    }

    // 加入公会请求列表
    public function requestList($uid)
    {
        $user_lib = $this->getDI()->getShared('user_lib');
        $status = $this->status($uid);
        if (isset ($status[self::$STATUS_FIELD_GID])) {
            $r_model = $this->getDI()->getShared('request_model');
            $r_list = $r_model->getRequestByGID($status[self::$STATUS_FIELD_GID]);
            $card_lib = $this->getDI()->getShared('card_lib');
            foreach ($r_list as & $item) {
                $user = $user_lib->getUser($item['uid']);
                $item['name'] = $user[UserLib::$USER_PROF_FIELD_NAME];
                $item['level'] = $user[UserLib::$USER_PROF_FIELD_LEVEL];
                $item['deck'] = $card_lib->getDeckCardsOverview($item['uid']);
                $item['rid'] = $item['id'];
                unset($item['id']);
                unset($item['gid']);
            }
            return $r_list;
        } else {
            throw new Exception('非公会成员无法查看申请列表.', ERROR_CODE_DATA_INVALID_GUILD);
        }

    }

    // 获得指定uid用户的公会信息，包括公会名称，公会阶级和公会贡献度
    public function status($uid)
    {
        $status = [];
        $m_model = $this->getDI()->getShared('member_model');
        $m_info = $m_model->getMemberByUid($uid);
        if (isset($m_info['gid']) && $m_info['gid'] > 0) {
            $status[self::$STATUS_FIELD_MID] = $m_info['id'];
            $status[self::$STATUS_FIELD_GID] = $m_info['gid'];
            $status[self::$STATUS_FIELD_GRADE] = $m_info['grade'];
            $status[self::$STATUS_FIELD_UID] = $m_info['uid'];
            $g_model = $this->getDI()->getShared('guild_model');
            $g_info = $g_model->getByGid($m_info['gid']);
            if (empty ($g_info)) {
                syslog(LOG_ERR, "Try to load user:$uid's guild:{$m_info['gid']} info, but not found");
                return [];
            }
            $status[self::$STATUS_FIELD_GNAME] = $g_info['name'];
            $status[self::$STATUS_FIELD_GICON] = $g_info['icon'];
            $status[self::$STATUS_FIELD_GLEVEL] = $g_info['level'];
            $status[self::$STATUS_FIELD_GFUND] = $g_info['fund'];
            $status[self::$STATUS_FIELD_NOTICE] = $g_info['notice'];
        }
        return $status;
    }

    // 获得公会总体状态
    public function guildStatus($uid)
    {
        $user_status = $this->status($uid);
        if (empty ($user_status)) {
            return [];
        }
        $g_status = [];
        $g_status['basic'] = [
            'my_position'        => $user_status[self::$STATUS_FIELD_GRADE],
            'guild_id'           => $user_status[self::$STATUS_FIELD_GID],
            'guild_name'         => $user_status[self::$STATUS_FIELD_GNAME],
            'guild_lv'           => $user_status[self::$STATUS_FIELD_GLEVEL],
            'guild_total_money'  => $user_status[self::$STATUS_FIELD_GFUND],
            'guild_announcement' => $user_status[self::$STATUS_FIELD_NOTICE],
            'guild_icon'         => $user_status[self::$STATUS_FIELD_GICON],
        ];
        $cache_key_today_dm = sprintf(self::$CACHE_KEY_DAILY_DONATE_MONEY, $uid); // 当天捐钱总数
        $cache_key_today_de = sprintf(self::$CACHE_KEY_DAILY_DONATE_ENERGY, $uid); // 当天捐能量总数
        $cache_key_donate_total = sprintf(self::$CACHE_KEY_TOTAL_DONATE, $uid);
        $g_status['basic']['today_donate_money'] = intval($this->redis->get($cache_key_today_dm));
        $g_status['basic']['today_donate_energy'] = intval($this->redis->get($cache_key_today_de));
        // 获得总共的捐钱数量和在本公会获得的贡献点数
        $total_donate = $this->redis->hGetAll($cache_key_donate_total);
        if (! empty($total_donate) && is_array($total_donate)) {
            if (isset ($total_donate[self::$TOTAL_DONATE_FIELD_MONEY])) {
                $g_status['basic']['total_donate_money'] = $total_donate[self::$TOTAL_DONATE_FIELD_MONEY];
            } else {
                $g_status['basic']['total_donate_money'] = 0;
            }
            $g_status['basic']['total_donate_donation'] = $total_donate[self::$TOTAL_DONATE_FIELD_DONATION];
        } else {
            $g_status['basic']['total_donate_money'] = 0;
            $g_status['basic']['total_donate_donation'] = 0;
        }
        $m_count_key = sprintf(self::$CACHE_KEY_GUILD_MEMBER_COUNT, $user_status[self::$STATUS_FIELD_GID]);
        $g_status['basic']['guild_member_count'] = $this->redis->get($m_count_key);
        $g_status['member_list'] = $this->memberList($user_status[self::$STATUS_FIELD_GID]);

        // 获得公会排行信息
        $rank_info = $this->getGuildRank($user_status[self::$STATUS_FIELD_GID]);
        $g_status['basic']['guild_combat'] = $rank_info['strength'];
        $g_status['basic']['guild_rank'] = $rank_info['rank'];

        return $g_status;
    }

    // 重写获得随机公会列表方法
    public function randomGuilds($uid)
    {
        $ret = [];
        $r_model = $this->getDI()->getShared('request_model');
        $req_list = $r_model->getRequestByUID($uid);
        $req_gid = array_column($req_list, 'gid');
        $req_count = count($req_list);

        $random_guilds = $this->redis->sRandMember(self::$CACHE_KEY_GUILD_AVAILABLE, 9);
        $diff = array_diff($random_guilds, $req_gid);
        shuffle($diff);
        $req_gid = array_merge($req_gid, array_slice($diff, 0, 9 - $req_count));

        $g_model = $this->getDI()->getShared('guild_model');
        $g_list = $g_model->getByIdList($req_gid);
        foreach ($g_list as $gid => $info) {
            $ret[$gid] = [
                'guild_id' => $gid,
                'guild_name' => $info['name'],
                'guild_icon' => $info['icon'],
                'guild_lv' => $info['level'],
                'guild_announcement' => $info['notice'],
            ];
            $ret[$gid]['is_apply'] = false;
            $m_count_key = sprintf(self::$CACHE_KEY_GUILD_MEMBER_COUNT, $gid);
            $ret[$gid]['guild_member_count'] = $this->redis->get($m_count_key);
            foreach ($req_list as $item) {
                if ($item['gid'] == $gid) {
                    $ret[$gid]['is_apply'] = true;
                    break;
                }
            }
            $rank_info = $this->getGuildRank($gid);
            $ret[$gid]['guild_rank'] = $rank_info['rank'];
        }
		return array_values($ret);
    }

    // 记录公会日志
    public function writeLog($uid, $gid, $type, $params)
    {
        $params = is_array($params) ? json_encode($params, JSON_NUMERIC_CHECK) : strval($params);
        $l_model = $this->getDI()->getShared('log_model');
        $l_model->addLog($uid, $gid, $type, $params);
        return true;
    }

    // 获得公会日志列表
    public function logList($gid, $count)
    {
        $l_model = $this->getDI()->getShared('log_model');
        $l_list = $l_model->getLogByGid($gid, $count);
        foreach ($l_list as & $item) {
            if (! $tmp = json_decode($item['params'], true)) {
                $item['params'] = [$item['params']];
            } else {
                $item['params'] = $tmp;
            }
            $item['timestamp'] = strtotime($item['created_at']);
        }
        usort($l_list, function ($a, $b) {
           return $a['timestamp'] < $b['timestamp'];
        });

        return array_values($l_list);
    }

    // 按照指定GID查找公会信息
    public function search($user_id, $gid)
    {
        $g_model = $this->getDI()->getShared('guild_model');
        $g_info = $g_model->getByGid($gid);
        if (! $g_info) {
            throw new Exception('您所查找的公会不存在.', ERROR_CODE_DATA_INVALID_GUILD);
        }
        $r_model = $this->getDI()->getShared('request_model');
        $r_list = $r_model->getRequestByGidAndUid($gid, $user_id);
        $g_info['request_sent'] = empty ($r_list) ? false : true;
        $rank_info = $this->getGuildRank($gid);
        $g_info['guild_rank'] = $rank_info['rank'];
        $m_count_key = sprintf(self::$CACHE_KEY_GUILD_MEMBER_COUNT, $gid);
        $g_info['guild_member_count'] = $this->redis->get($m_count_key);
        return $g_info;
    }

    public function donate($uid, $d_type, $d_amount)
    {
        $ret = ['code' => 200, 'contr' => 0,];
        $user_status = $this->status($uid);
        if ($user_status) {
            $key_total = sprintf(self::$CACHE_KEY_TOTAL_DONATE, $uid);
            if (self::$DONATE_TYPE_MONEY == $d_type) {
                $user_lib = $this->getDI()->getShared('user_lib');
                if ($user_lib->consumeFieldAsync($uid, UserLib::$USER_PROF_FIELD_COIN, $d_amount)) {
                    $delta = intval($d_amount / 1000);
                    // 计算贡献度实际增加数值
                    $cache_key = sprintf(self::$CACHE_KEY_DAILY_DONATE_MONEY, $uid);
                    $daily_curr = intval($this->redis->get($cache_key));
                    $delta = min(self::$DONATE_LIMIT_MONEY - $daily_curr, $delta);
                    // 为公会添加总资金
                    $g_model = $this->getDI()->getShared('guild_model');
                    $g_model->incrFund($user_status[self::$STATUS_FIELD_GID], $d_amount);
                    // 添加用户为公会捐赠的总资金数量
                    $this->redis->hIncrBy($key_total, self::$TOTAL_DONATE_FIELD_MONEY, $d_amount);
                    $user_lib = $this->getDI()->getShared('user_lib');
                    $user = $user_lib->getUser($uid);
                    $this->writeLog($uid, $user_status[self::$STATUS_FIELD_GID], self::$LOG_TYPE_MEMBER_CONTRIBUTE_GOLD, [
                        $user[UserLib::$USER_PROF_FIELD_NAME],
                        $d_amount,
                        $delta,
                    ]);
                } else {
                    throw new Exception('你没有足够的索尼币进行捐献.', ERROR_CODE_DATA_INVALID_GUILD);
                }
            } else if (self::$DONATE_TYPE_ENERGY == $d_type) {
                $delta = $d_amount;
                $cache_key = sprintf(self::$CACHE_KEY_DAILY_DONATE_ENERGY, $uid);
                $daily_curr = intval($this->redis->get($cache_key));
                $delta = min(self::$DONATE_LIMIT_ENERGY - $daily_curr, $delta);
            } else {
                throw new Exception("无法识别的贡献类型", ERROR_CODE_DATA_INVALID_GUILD);
            }
            // 添加用户贡献度总值
            $this->redis->hIncrBy($key_total, self::$TOTAL_DONATE_FIELD_DONATION, $delta);
            if ($this->redis->exists($cache_key)) {
                $this->redis->incrBy($cache_key, $delta);
            } else {
                $this->redis->set($cache_key, $delta);
                $this->redis->expireAt($cache_key, self::getDefaultExpire());
            }
            $user_lib = $this->getDI()->getShared('user_lib');
            $user = $user_lib->getUser($uid);
            $user_lib->incrFieldAsync($uid, UserLib::$USER_PROF_FIELD_GCOIN, $delta);
            if (isset ($user[UserLib::$USER_PROF_FIELD_GCOIN])) {
                $ret['contr'] = $user[UserLib::$USER_PROF_FIELD_GCOIN]+ $delta;
            } else {
                $ret['contr'] = $delta;
            }
        } else {
            return ['code' => 405, '你已经不属于任何公会，请查看会长是否已经解散公会'];
        }
        return $ret;
    }

    // 提升公会等级
    public function levelUp($uid)
    {
        $status = $this->status($uid);
        if ($status[self::$STATUS_FIELD_GRADE] <= self::$MEMBER_TYPE_FUHUIZHANG) {
            $g_level = $status[self::$STATUS_FIELD_GLEVEL];
            if (isset (self::$GUILD_LEVEL_CONF[$g_level + 1])) {
                $cost = self::$GUILD_LEVEL_CONF[$g_level + 1]['up_cost'];
                if ($status[self::$STATUS_FIELD_GFUND] >= $cost) {
                    $fields['level'] = $g_level + 1;
                    $fields['fund'] = $status[self::$STATUS_FIELD_GFUND] - $cost;
                    $g_model = $this->getDI()->getShared('guild_model');
                    if ($g_model->updateFields($status[self::$STATUS_FIELD_GID], $fields)) {
                        $user_lib = $this->getDI()->getShared('user_lib');
                        $user = $user_lib->getUser($uid);
                        $this->writeLog($uid, $status[self::$STATUS_FIELD_GID], self::$LOG_TYPE_LEVELUP_SELF, [
                            $user[UserLib::$USER_PROF_FIELD_NAME],
                            $g_level + 1,
                        ]);
                        return ['code' => ERROR_CODE_OK, 'msg' => 'OK'];
                    } else {
                        return ['code' => ERROR_CODE_DB_ERROR_MYSQL, 'msg' => '升级公会失败.'];
                    }
                } else {
                    return ['code' => ERROR_CODE_DATA_INVALID_GUILD, 'msg' => '公会资金不足'];
                }
            } else {
                return ['code' => ERROR_CODE_DATA_INVALID_GUILD, 'msg' => '公会已达到最高等级'];
            }
        } else {
            throw new Exception('只有会长和副会长才能升级公会', ERROR_CODE_DATA_INVALID_GUILD);
        }
    }

    // 更新公会公告
    public function postAnc($uid, $content)
    {
        $user_status = $this->status($uid);
        if ($user_status[self::$STATUS_FIELD_GRADE] <= self::$MEMBER_TYPE_FUHUIZHANG) {
            $gid = $user_status[self::$STATUS_FIELD_GID];
            $fields = ['notice' => $content];
            $g_model = $this->getDI()->getShared('guild_model');
            if (! $g_model->updateFields($gid, $fields)) {
                throw new Exception('更新失败');
            }
            return ['code' => 200, 'msg' => 'OK'];
        } else {
            throw new Exception('只有会长和副会长才能修改公告', ERROR_CODE_DATA_INVALID_GUILD);
        }
    }

    private static function memberTypeToName($member_type) {
        switch ($member_type) {
            case self::$MEMBER_TYPE_HUIZHANG:
                return '会长';
            case self::$MEMBER_TYPE_FUHUIZHANG:
                return '副会长';
            case self::$MEMBER_TYPE_ZHANGLAO:
                return '长老';
            case self::$MEMBER_TYPE_NORMAL:
                return '普通会员';
            default:
                return '普通会员';
        }
    }

    // 扣除公会资金接口，返回布尔值FALSE证明扣除失败，其他值表示扣除成功
    public function consumeGuildFund($uid, $amount)
    {
        $user_status = $this->status($uid);
        if ($user_status) {
            $gid  = $user_status[self::$STATUS_FIELD_GID];
            $fund = $user_status[self::$STATUS_FIELD_GFUND];
            $g_model = $this->getDI()->get('guild_model');
            if ($fund >= $amount) {
                $g_model->incrFund($gid, - $amount);
                return ($fund - $amount);
            }
        }
        return false;
    }

    public function cancelRequest($uid, $gid) {
        $r_model = $this->getDI()->getShared('request_model');
        $ret = $r_model->removeByUidGid($uid, $gid);
        if (! $ret) {
            throw new Exception('取消请求失败.', ERROR_CODE_DB_ERROR_MYSQL);
        }
        return ['code' => 200, 'msg' => 'OK'];
    }

    private function getGuildRank($gid)
    {
        $rank = $this->redis->zRevRank(self::$CACHE_KEY_GUILD_STRENGTH_RANK, $gid);
        $strength = $this->redis->zScore(self::$CACHE_KEY_GUILD_STRENGTH_RANK, $gid);
        $ret = [
            'rank'     => is_numeric($rank) ? $rank + 1 : -1,
            'strength' => empty($strength) ? 0 : $strength,
        ];
        return $ret;
    }

    public function guildRankList()
    {
        $rank_key = self::$CACHE_KEY_GUILD_STRENGTH_RANK_DETAIL;
        $rank_info = $this->redis->get($rank_key);
        $rank_info = json_decode($rank_info, true);
        foreach ($rank_info as $gid => & $item) {
            $item['id'] = $gid;
        }
        return $rank_info ? array_values($rank_info) : [];
    }
}
