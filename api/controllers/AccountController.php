<?php 
namespace Cap\Controllers;

use Cap\Libraries\AccountLib;
use Cap\Libraries\EquipLib;
use Cap\Libraries\EventLib;
use Cap\Libraries\MailLib;
use Cap\Libraries\QuestLib;
use Cap\Libraries\TechLib;
use Cap\Libraries\UserLib;
use Cap\Libraries\NameLib;
use Cap\Libraries\RobLib;
use Cap\Libraries\CardLib;
use Cap\Libraries\GuildLib;
use Cap\Libraries\ResqueLib;
use Cap\Libraries\TempleLib;
use Cap\Models\db\UserLoginModel;

class AccountController extends BaseController {

    public static $SDK_SOURCE_ITOOLS = 1; // itools
    public static $SDK_SOURCE_TBT = 2; // 同步推
    public static $SDK_SOURCE_91 = 3; // 91手机助手
	public function onConstruct()
	{
		parent::onConstruct();
		// lazy load
		$this->_di->set("acct_lib", function(){
			return new AccountLib();
		});
		$this->_di->set("user_lib", function(){
			return new UserLib();
		});
		$this->_di->set("resque_lib", function(){
			return new ResqueLib();
		});
        $this->_di->set("loginindex_lib", function(){
            return new \LoginIndexLib();
        }, true);
        $this->_di->set("name_lib", function(){
            return new NameLib();
        }, true);
        $this->_di->set("rob_lib", function(){
            return new RobLib();
        }, true);
        $this->_di->set("card_lib", function(){
            return new CardLib();
        }, true);
        $this->_di->set("tech_lib", function(){
            return new TechLib();
        }, true);
        $this->_di->set("quest_lib", function(){
            return new QuestLib();
        }, true);
        $this->_di->set("equip_lib", function(){
            return new EquipLib();
        }, true);
        $this->_di->set("annouce_lib", function(){
            return new \Cap\Libraries\AnnounceLib();
        }, true);
        $this->_di->set("guild_lib", function () {
            return new GuildLib();
        }, true);
        $this->_di->set("mail_lib", function () {
            return new MailLib();
        }, true);
        $this->_di->set("event_lib", function () {
            return new EventLib();
        }, true);
        $this->_di->set("temple_lib", function () {
            return new TempleLib();
        });
        $this->_di->set("drgnbl_lib", function () {
            return new \Cap\Libraries\DragonBallLib();
        });
        $this->_di->set("friend_lib", function () {
            return new \Cap\Libraries\FriendLib();
        }, true);
        $this->_di->set("loginbonus_lib", function () {
            return new \Cap\Libraries\LoginBonusLib();
        }, true);
        $this->_di->set("cardraffle_lib", function () {
            return new \Cap\Libraries\CardRaffleLib();
        }, true);
        $this->_di->set('item_lib', function() {
            return new \Cap\Libraries\ItemLib();
        }, true);
        $this->_di->set('bind_model', function() {
            return new \Cap\Models\Db\UserBindModel();
        }, true);
        $this->_di->set('campaign_lib', function(){
            return new \Cap\Libraries\CampaignLib();
        });
	}

	/*
	 * create account
	 */
	public function registerAction()
	{
        if (($r = $this->checkParameter(['email', 'password'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
		$email = $obj['email'];
		$password = $obj['password'];
        syslog(LOG_DEBUG, "register with $email, $password");

		$acct_lib = $this->_di->getShared("acct_lib");

		if ($acct_lib->hasAccountEmail($email)) {
			return json_encode(array("code"=> 101,
					"msg"=>"email already used"));
		}

		$res = array();

		try {
			$result = $acct_lib->saveAccountEmailPassword($email, $password);
		} catch (\PDOException $e) {
			if ($e->getCode()==23000) {
				syslog(LOG_NOTICE, "PDOException: $e");
				$res = array("code"=>101, "msg"=>"email has just been used");
				return json_encode($res);
			} else {
				throw $e;
			}
		}
		if ($result['result'] === true) {
			// set session
			$acct_id = $result['acct_id'];
			$this->session->set("acct_id", $acct_id);
			$res = array("code"=>200, "msg"=>"OK");
		} else {
			$res = array("code"=>500, "msg"=>"fail to create account:".$result['message']);
		}
		return json_encode($res);

	}

	/*
	 * authenticate user account by password
	 */
	public function loginAction()
	{
		$data = $this->request->getPost("data");
        require "../../api/proto/pb_proto_login.php";
        $msg = new \msg_login();
        $msg->parseFromString($data);

        /*
		$data = $this->request->getPost("data");
		syslog(LOG_INFO, "account login data=".$data);
		$obj = json_decode($data, true);
		if (!$obj || !isset($obj['email']) || !isset($obj['password'])) {
			syslog(LOG_INFO, "invalid parameters:$data");
			return json_encode(array("code"=>400, "msg"=>"invalid parameters"));
		}
		$email = $obj['email'];
		$password = $obj['password'];
        */
		$email = $msg->username();
		$password = $msg->password();

		$server_id = $this->config['server_id'];

		$acct_lib = $this->_di->getShared("acct_lib");
		$account_id = $acct_lib->checkAccountEmailPassword($email, $password);
		if ($account_id != false) {
			// set session
			$this->session->set("account_id", $account_id);
		} else {
			return json_encode(array('code'=>101, 'msg'=>'password error'));
		}
		$user_id = $acct_lib->getDefaultRoleId($account_id, $server_id);
		$res = array('code'=>200, 'msg'=>'OK', 'users'=>array());
		if ($user_id !=false) {
			// get user info
			$this->session->set("role_id", $user_id);
			$user_lib = $this->_di->getShared("user_lib");
			$user_info = $user_lib->getUser($user_id);
            $res['new'] = $user_lib->getNewFields($user_id);
            if ($user_info) {
				$res['users'] []= $this->fillUserInfo($user_id, $user_info);
                $user_lib->fireLoginEvent($user_id, time(), 1);
                // destroy old session if exists, set new session to user
                $this->setSession($user_id);

                // welcome message
                $annouce_lib = $this->_di->getShared('annouce_lib');
                $msgs = $annouce_lib->getAnnounce();
                $res['announce'] = $msgs;
			} else {
				$res = array('code'=>500, 'msg'=>"miss detail data for role $user_id");
			}
		}
		return json_encode($res, JSON_UNESCAPED_UNICODE|JSON_NUMERIC_CHECK);
	}

	/*
	 * query if the email exists in system or not
	 */
	public function queryAction() {
		$data = $this->request->getPost("data");
		syslog(LOG_INFO, "account query data=".$data);
		$obj = json_decode($data, true);
		if (!$obj || !isset($obj['email'])) {
			syslog(LOG_INFO, "invalid parameters:$data");
			return json_encode(array("code"=>400, "msg"=>"invalid parameters"));
		}
		$email = $obj['email'];
		if (!$this->session->has('account_id')) {
			syslog(LOG_INFO, "unlogin user xxx");
			return json_encode(array("code"=>401, "msg"=>"unauthorized operation"));
		}

		$acct_lib = $this->_di->getShared("acct_lib");
		$acct = $acct_lib->hasAccountEmail($email);
		if ($acct) {
			return json_encode(array("code"=>200, "msg"=>"exists"));
		} else {
			return json_encode(array("code"=>404, "msg"=>"not found"));
		}
	}

	/*
	 * create role for this server
	 */
	public function createRoleAction() {
        if (($r = $this->checkParameter(['name'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
		$name = chop($obj['name']);
        syslog(LOG_DEBUG, "create name [$name]");
        if (strlen($name)==0 or mb_strlen($name, "UTF-8")>8) {
            return json_encode(array('code'=>400, 'msg'=> 'name should not be empty or exceeds 8'));
        }
		$res = array('code'=>200);
		$account_id = $this->session->get('account_id');
		if (!$account_id) {
			syslog(LOG_INFO, "user not logged in");
			$res = array('code'=>401, 'msg'=>'user not logged in');
			return json_encode($res);
		}
        $name_lib = $this->_di->getShared('name_lib');
        if ($name_lib->isForbidden($name)) {
			syslog(LOG_INFO, "user name [$name] is forbidden");
			$res = array('code'=>403, 'msg'=>'invalid user name');
			return json_encode($res);
        }
		syslog(LOG_INFO, "create role for $account_id");
		$server_id = $this->config['server_id'];

		$acct_lib = $this->_di->getShared("acct_lib");
		try {
			$role_res = $acct_lib->createRole($account_id, $server_id);
			if ($role_res) {
				$role_id = $role_res['role_id'];
			} else {
				$res = array("code"=>500, "msg"=>"fail to create role for $account_id@$server_id");
				return json_encode($res);
			}
		} catch (\PDOException $e) {
			if ($e->getCode()==23000) {
				syslog(LOG_NOTICE, "PDOException: $e");
				syslog(LOG_INFO, "role id already exists for $account_id");
				$role_id = $acct_lib->getDefaultRoleId($account_id, $server_id);
				syslog(LOG_INFO, "role id $role_id already exists for $account_id");
				if ($role_id) {
					// if exists in user table	
					$user_lib = $this->_di->getShared("user_lib");
					$user_info = $user_lib->getUser($role_id);
					if ($user_info) {
						$res = array("code"=>409, "msg"=>"only one role is allowed in one server");
						return json_encode($res);
					} else {
						syslog(LOG_INFO, "initial existing role info for $role_id");
					}
				} else {
					syslog(LOG_ERR, "inconsistent state, role id can neither be added nor be found");
					$res = array("code"=>500, "msg"=>"fail to create or found role for account $account_id");
					return json_encode($res);
				}
			} else {
				throw $e;
			}
		}
		// init profile for this role id
		syslog(LOG_INFO, "initial role $role_id");
		try {
			$result = $acct_lib->initRole($account_id, $role_id, $name);

			if ($result['result']===true) {
				$res = array("code"=>200, "msg"=>"OK");
                $user_lib = $this->_di->getShared("user_lib");
                $user_lib->fireLoginEvent($role_id, time(), 1);
                $this->session->set("role_id", $role_id);

			} else {
				$res = array("code"=>500, "msg"=> $result['message']);
			}
		} catch (\PDOException $e) {
			// here is not reached when the whole record fully matched one in db
            // other integrity check exception may also exists
			if ($e->getCode()==23000) {
				syslog(LOG_NOTICE, "PDOException: $e");
				$res = array("code"=>409, "msg"=>"该名字已存在.");
				return json_encode($res);
			} else {
				throw $e;
			}
		}
		
		return json_encode($res, JSON_NUMERIC_CHECK);
	}

    public function nameAllowedAction() {
        if (($r = $this->checkParameter(['name'])) !== true) {
            return $r;
        }
        $obj = $this->request_data;
        $name = $obj['name'];
        $name_lib = $this->_di->getShared('name_lib');
        if ($name_lib->isForbidden($name)) {
            $res = array("code"=> 403, "msg"=> "name forbidden");
            return json_encode($res);
        }
        $acct_lib = $this->_di->getShared('account_lib');
        if ($acct_lib->nameExists($name)) {
            $res = array("code"=> 403, "msg"=> "名字已存在.");
            return json_encode($res);
        }
        $res = array("code"=> 200);
        return json_encode($res);
    }

	public function logoutAction()
	{
		// destroy session
		if ($this->session->has("account_id")) {
			$this->session->destroy();
			return json_encode(array('code'=>200));
		} else {
			return json_encode(array('code'=>401,
					'msg'=>'not online'));
		}
	}

    /*
     * Notice:hard code destroy old session
     */
    function setSession($role_id) {
        $rds = $this->_di->getShared('redis');
        $saved_session_key = "role:$role_id:session";
        $saved_session_id = $rds->get($saved_session_key);
        if ($saved_session_id) {
            $session_key = "PHPREDIS_SESSION:$saved_session_id";
            $rds->del($session_key);
        }
        if ($saved_session_id != $this->session->getId()) {
            $rds->set($saved_session_key, $this->session->getId());
            syslog(LOG_DEBUG, "replace old session $saved_session_id to ".$this->session->getId());
        }
    }

    /** Bind from 3rd party account */
    function bindAction()
    {
        if (($r = $this->checkParameter(['source'])) !== true) {
            return $r;
        }
        $res = ['code' => 500, 'msg' => '未知错误.'];
        $source = intval($this->request_data['source']);
        switch ($source) {
            case self::$SDK_SOURCE_ITOOLS:
                $sessionid = $this->request_data['sessionid'];
                $source_uid = explode('_', $sessionid)[0];
                $url = [
                    'https://pay.slooti.com/?r=auth/verify',
                    'appid=622',
                    'sessionid=' . $sessionid,
                    'sign=' . md5("appid=622&sessionid={$sessionid}"),
                ];
                $url = implode('&', $url);
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                $ret = curl_exec($ch);
                $ret = json_decode($ret, true);
                if ('success' == $ret['status']) {
                    $bind_model = $this->getDI()->getShared('bind_model');
                    $bind_status = $bind_model->findBind($source, $source_uid);
                    $acct_lib = $this->getDI()->getShared("acct_lib");
                    // 已绑定用户，直接登录
                    if ($bind_status) {
                        $res = array(
                            "code" => 200,
                            "msg" => "OK",
                            "account_id" => $bind_status['account_id']
                        );
                    } else {
                        // 未绑定，需要新注册用户
                        $email = "{$source_uid}@itools.com";
                        $password = '123456';
                        $result = $acct_lib->saveAccountEmailPassword($email, $password);
                        if ($result['result'] === true) {
                            // set session
                            $acct_id = $result['acct_id'];
                            $bind_model->createBind($source, $source_uid, $acct_id);
                            $this->session->set("account_id", $acct_id);
                            $res = array(
                                "code" => 200,
                                "msg" => "OK",
                                "account_id" => $acct_id);
                        } else {
                            $res = array("code"=>500, "msg"=>"创建账户失败:".$result['message']);
                        }
                    }
                } else {
                    $res =  ['code' => 403, 'msg' => '账户授权失败.'];
                }
                curl_close($ch);
                break;
            case self::$SDK_SOURCE_TBT:
                $sessionid = $this->request_data['sessionid'];
                $url = "http://tgi.tongbu.com/checkv2.aspx?k={$sessionid}";
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                $ret = curl_exec($ch);
                if (1 < $ret) {
                    // 返回值即是uid
                    $source_uid = $ret;
                    $bind_model = $this->getDI()->getShared('bind_model');
                    $bind_status = $bind_model->findBind($source, $source_uid);
                    $acct_lib = $this->getDI()->getShared("acct_lib");
                    // 已绑定用户，直接登录
                    if ($bind_status) {
                        $res = array(
                            "code" => 200,
                            "msg" => "OK",
                            "account_id" => $bind_status['account_id']
                        );
                    } else {
                        // 未绑定，需要新注册用户
                        $email = "{$source_uid}@tongbu.com";
                        $password = '123456';
                        $result = $acct_lib->saveAccountEmailPassword($email, $password);
                        if ($result['result'] === true) {
                            // set session
                            $acct_id = $result['acct_id'];
                            $bind_model->createBind($source, $source_uid, $acct_id);
                            $this->session->set("account_id", $acct_id);
                            $res = array(
                                "code" => 200,
                                "msg" => "OK",
                                "account_id" => $acct_id);
                        } else {
                            $res = array("code" => 500, "msg" => "创建账户失败:" . $result['message']);
                        }
                    }
                } else {
                    $res =  ['code' => 403, 'msg' => '账户授权失败.'];
                }
				break;
            case self::$SDK_SOURCE_91:
                $sessionid = $this->request_data['sessionid'];
                $uin = $this->request_data['uin'];
                $url = "http://service.sj.91.com/usercenter/ap.aspx";
                $act_id = 4; // 91定义的登录动作码
                $app_id = 116190;
                $app_key = '329c7c7882d08bf374c073b3a996d25046ddf36f5daf57e6';
                $sign = md5($app_id . $act_id . $uin . $sessionid . $app_key);
                $source_str = "AppId=".$app_id."&Act=".$act_id."&Uin=".$uin."&SessionId=".$sessionid."&Sign=".$sign;
                $source_str = trim($source_str);

                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, "$url?$source_str");
                syslog(LOG_DEBUG, "SDK IMPORT SENDING REQUEST TO $url?$source_str");
                curl_setopt($ch, CURLOPT_HEADER, false);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 3);
                $ret = curl_exec($ch);
                $ret = json_decode($ret, true);
                syslog(LOG_DEBUG, "SDK IMPORT RECEIVED RESPONSE" . json_encode($ret));
                if (is_array($ret) && isset($ret['ErrorCode'])) {
                    if (1 == $ret['ErrorCode']) {
                        $bind_model = $this->getDI()->getShared('bind_model');
                        $bind_status = $bind_model->findBind($source, $uin);
                        $acct_lib = $this->getDI()->getShared("acct_lib");
                        // 已绑定用户，直接登录
                        if ($bind_status) {
                            $res = array(
                                "code" => 200,
                                "msg" => "OK",
                                "account_id" => $bind_status['account_id']
                            );
                        } else {
                            // 未绑定，需要新注册用户
                            $email = "{$uin}@91.com";
                            $password = '123456';
                            $result = $acct_lib->saveAccountEmailPassword($email, $password);
                            if ($result['result'] === true) {
                                // set session
                                $acct_id = $result['acct_id'];
                                $bind_model->createBind($source, $uin, $acct_id);
                                $this->session->set("account_id", $acct_id);
                                $res = array(
                                    "code" => 200,
                                    "msg" => "OK",
                                    "account_id" => $acct_id
                                );
                            } else {
                                $res = array("code" => 500, "msg" => "创建账户失败:" . $result['message']);
                            }
                        }
                    } else {
                        syslog(LOG_DEBUG, '91 ERROR CODE: ' . $ret['ErrorCode']);
                        $res = array("code" => 500, "msg" => "鉴权失败");
                    }
                } else {
                    syslog(LOG_DEBUG, "91 ERROR, Package Parse Error" . $ret );
                    $res = array("code" => 500, 'msg' => '鉴权失败');
                }
        }
        return json_encode($res, JSON_UNESCAPED_UNICODE|JSON_NUMERIC_CHECK);
    }

    function bindLoginAction()
    {
        if (($r = $this->checkParameter(['account_id'])) !== true) {
            return $r;
        }
        $acct_lib = $this->getDI()->getShared("acct_lib");
        $acct_id = $this->request_data['account_id'];
        $server_id = $this->config['server_id'];
        $this->session->set('account_id', $acct_id);
        $user_id = $acct_lib->getDefaultRoleId($acct_id, $server_id);
        $res = array('code'=>200, 'msg'=>'OK', 'users'=>array());
        if ($user_id !=false) {
            // get user info
            $this->session->set("role_id", $user_id);
            $user_lib = $this->getDI()->getShared("user_lib");
            $user_info = $user_lib->getUser($user_id);
            $res['new'] = $user_lib->getNewFields($user_id);
            if ($user_info) {
                $res['users'] []= $this->fillUserInfo($user_id, $user_info);
                $user_lib->fireLoginEvent($user_id, time(), 1);
                // destroy old session if exists, set new session to user
                $this->setSession($user_id);
                // welcome message
                $annouce_lib = $this->getDI()->getShared('annouce_lib');
                $msgs = $annouce_lib->getAnnounce();
                $res['announce'] = $msgs;

            } else {
                $res = array('code'=>500, 'msg'=>"miss detail data for role $user_id");
            }
            // 记录登录日志
            $uuid = isset($this->request_data['uuid']) ? $this->request_data['uuid'] : '';
            if (empty ($uuid)) {
                $uuid = myuuid();
                $res['uuid'] = $uuid;
            }
            $this->writeLoginLog($server_id, $acct_id, $user_id, $uuid);
        }
        return json_encode($res, JSON_UNESCAPED_UNICODE|JSON_NUMERIC_CHECK);
    }

    private function writeLoginLog($server_id, $account_id, $user_id, $uuid)
    {
        $login_at = time();
        $ip = getRealIP();
        $user_login_model = new UserLoginModel();
        $user_login_model->createLog($server_id, $account_id, $user_id, $uuid, $login_at, $ip);
    }

    private function fillUserInfo($user_id, & $user_info)
    {
        $user_info['id']= $user_id;
        $user_lib = $this->getDI()->getShared('user_lib');
        // get deck info
        $card_lib  = $this->getDI()->getShared('card_lib');
        $tech_lib  = $this->getDI()->getShared('tech_lib');
        $quest_lib = $this->getDI()->getShared('quest_lib');
        $deck_info = $card_lib->getDeckCard($user_id);
        $user_info['deck'] = $deck_info;
        $user_info['tech'] = $tech_lib->getUserTechs($user_id);
        $user_info['quest'] = $quest_lib->status($user_id);
        // 获得改名冷却时间
        $name_lib = $this->getDI()->getShared('name_lib');
        $user_info['rename_cooldown'] = $name_lib->getRenameCoolDown($user_id);
        // 获得装备空间计数
        $equip_lib = $this->getDI()->getShared('equip_lib');
        $user_info['equip_count'] = $equip_lib->getSpaceCount($user_id);
        $user_info['equip_list']  = $equip_lib->getEquips($user_id);
        $user_info['equip_piece'] = $equip_lib->getAllPieces($user_id);
        // get wipe energy
        $user_info['wipe_count'] = $user_lib->getWipeCount($user_id);
        // 获得用户公会信息
        $guild_lib = $this->getDI()->getShared('guild_lib');
        $user_info['guild'] = $guild_lib->guildStatus($user_id);
        // 获得卡牌的历史记录
        $user_info['card_his'] = $card_lib->cardHisDetail($user_id);
        $user_info['card_list'] = $card_lib->getCardList($user_id);
        // dragonball list
        $drgnbl_lib = $this->getDI()->getShared('drgnbl_lib');
        $user_info['dragonball_list'] = array(
            'balls'=>$drgnbl_lib->getByUser($user_id),
            'fragments' => $drgnbl_lib->getFragments($user_id, true)
        );
        // 获得签到记录
        $bonus_lib = $this->getDI()->getShared("loginbonus_lib");
        $user_info['loginbonus_record'] = $bonus_lib->getRecords($user_id);
        // 获得神殿数据
        $temple_lib = $this->getDI()->getShared('temple_lib');
        $user_info['temple'] = $temple_lib->status($user_id);
        // friends
        $friend_lib = $this->getDI()->getShared('friend_lib');
        $friends = $friend_lib->getFriends($user_id);
        $pending_friends = $friend_lib->getFriends($user_id, true);
        $gift_sent_list = $friend_lib->getGiftUserList($user_id, 0);
        $gift_recv_list = $friend_lib->getGiftUserList($user_id, 1);
        $gift_accpt_list = $friend_lib->getGiftUserList($user_id, 2);
        $user_info['friend'] = array(
            'friends'=> $friends,
            'incoming_request'=> $pending_friends,
            'gift_sent_list'=> $gift_sent_list,
            'gift_recv_list'=> $gift_recv_list,
            'gift_accpt_list'=> $gift_accpt_list
        );

        $gacha_lib = $this->getDI()->getShared('cardraffle_lib');
        $user_info['raffle_record'] = $gacha_lib->getRaffleRecords($user_id);
        $item_lib = $this->getDI()->getShared('item_lib');
        $user_info['item_list'] = $item_lib->listItem($user_id, true);

        // 添加邮件列表
        $mail_lib = $this->getDI()->getShared('mail_lib');
        $mail_list = $mail_lib->getUserMail($user_id);
        $user_info['mail_list'] = array_values($mail_list);
        $user_info['server_ts'] = time();

        // rob protect ttl
        $rob_lib = $this->getDI()->getShared('rob_lib');
        $protect_ttl = $rob_lib->getRobExempt($user_id);
        if ($protect_ttl) {
            $user_info['rob_protect_ttl'] = time() + $protect_ttl;
        } else {
            $user_info['rob_protect_ttl'] = 0;
        }
        // campaign
        $campaign_lib = $this->_di->getShared('campaign_lib');
        $campaign_lib->fireEvent(\Cap\Libraries\CampaignLib::$EVENT_ID_NEW_SERVER_LOGIN, array($user_id));
        $user_info['campaign_status'] = $campaign_lib->getCampaignStatus($user_id);
        $user_info['growth_plan'] = $campaign_lib->getGrowthPlan($user_id);
        return $user_info;
    }
}

