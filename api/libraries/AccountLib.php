<?php 
namespace Cap\Libraries;

use Cap\Models\Db\AccountModel;
use Cap\Models\Db\SubAccountModel;
use Cap\Models\Db\UserModel;
use Cap\Models\Redis\CommonRedisModel;

class AccountLib extends BaseLib {

    public static $KEY_NAME_ID = 'name:%s';

	public function __construct() {
		parent::__construct();
		$this->_di->set("account_model", function() {
			return new AccountModel();
		}, true);
		$this->_di->set("sub_account_model", function() {
			return new SubAccountModel();
		}, true);
		$this->_di->set("user_model", function() {
			return new UserModel();
		}, true);
		$this->_di->set("name_lib", function() {
			return new \Cap\Libraries\NameLib();
		}, true);
		$this->_di->set("card_lib", function() {
			return new \Cap\Libraries\CardLib();
		}, true);
		$this->_di->set("deck_lib", function() {
			return new \Cap\Libraries\DeckLib();
		}, true);
	}

	public function hasAccountEmail($email) {
		$acct_model = $this->_di->getShared("account_model");
		$acct = $acct_model->findByEmail($email);
		return $acct;
	}

	public function saveAccountEmailPassword($email, $password) {
		$password = $this->encodePassword($password);
		$acct_model = $this->_di->getShared("account_model");
		$result = $acct_model->execute('create_new', array('email'=>$email,
				'password'=>$password));
			
		if ($result->success() != false) {
			return array('result'=>true, 'acct_id'=>$result->getModel()->id);
		} else {
			$message = "";
			foreach ($result->getMessages() as $msg) {
				$message .= $msg . "\n";
			}
			return array('result'=>false, 'message'=>$message);
		}
	}
	
	public function checkAccountEmailPassword($email, $password) {
		$redis_conn = $this->_di->getShared('redis'); // TODO: should be account redis
		$acct_mid_key = "acct:$email:mid";
		$mid = $redis_conn->get($acct_mid_key);
		if (!empty($mid)) {
			$mid_prof_key = "mid:$mid:prof";
			$saved_password = $redis_conn->hget($mid_prof_key, "password");
		}

		if (empty($saved_password)) {
			// get from mysql
			$acct_model = $this->_di->get("account_model");
			$row = $acct_model->findByEmail($email);
			if ($row === false) {
				syslog(LOG_NOTICE, "fail to find info for $email");
				return false;
			} else {
				$saved_password = $row->password;
				$mid = $row->id;
				$redis_conn->set($acct_mid_key, $mid);
				$mid_prof_key = "mid:$mid:prof";
				$redis_conn->hset($mid_prof_key, "email", $email);
				$redis_conn->hset($mid_prof_key, "password", $saved_password);
			}
		} else {
			syslog(LOG_DEBUG, "authenticate $email:$mid using cache");
		}

		$en_password = $this->encodePassword($password);

		if ($en_password == $saved_password) {
			return $mid;
		} else {
			syslog(LOG_DEBUG, "$email authentication, [$en_password] vs [$saved_password] fail");
			syslog(LOG_NOTICE, "user $email failed authentication with $password");
			return false;
		}
	}

	public function getDefaultRoleId($account_id, $server_id) {
		$row = SubAccountModel::findFirst(array(
				"conditions" => "account_id = ?1 AND server_id = ?2",
				"bind" => array(1 => $account_id, 2 => $server_id)
			));
		if (!empty($row)) {
			return $row->id;
		} else {
			return false;
		}
	}

	/*
	 * create a new role
	 */
	public function createRole($account_id, $server_id) {
		$subacct_model = $this->_di->getShared("sub_account_model");
		$result = $subacct_model->execute('create_new', array('account_id'=>$account_id,
				'server_id'=>$server_id));
		
		if ($result->success() != false) {
			$role_id = $result->getModel()->id;
			return array('result'=>true, 'role_id'=>$role_id);
		} else {
			$message = "";
			foreach ($result->getMessages() as $msg) {
				$message .= $msg . "\n";
			}
			return array('result'=>false, 'message'=>$message);
		}
	}
	/*
	 * create a new role
	 */
	public function initRole($account_id, $role_id, $name) {
		$user_model = $this->_di->getShared("user_model");
		$result = $user_model->execute('create_new', array('id'=>$role_id, 'account_id'=>$account_id, 'name'=>$name));
		// result of type Phalcon\Mvc\Model\Query\Status
		if ($result->success() != false) {
			// disable cache 
			// Note: this operation does not gauranntee latest version in cache
			$redis_conn = $this->_di->getShared('redis');
			$r = $redis_conn->delete("role:$role_id");
            $redis_conn->set(sprintf(self::$KEY_NAME_ID, $name), $role_id);
			syslog(LOG_DEBUG, "disable cache for $role_id:$r");
            // remove names from name depot
            $name_lib = $this->_di->getShared('name_lib');
            $name_lib->removeName($name);

			$user_lib = new UserLib();
			$user_lib->getUser($role_id);
            // initial deck info for test
            syslog(LOG_DEBUG, "initialize deck/cards info for user($role_id, $name)");
			
            // 创建卡组
            $deck_lib = $this->_di->getShared('deck_lib');
            $deck_lib->createDeck($role_id);

			return array('result'=>true, 'role_id'=>$result->getModel()->id);
		} else {
			$message = "";
			foreach ($result->getMessages() as $msg) {
				$message .= $msg . "\n";
			}
			return array('result'=>false, 'message'=>$message);
		}
	}

    public function nameExists($name) {
        $rds = $this->_di->getShared('redis');
        $key = sprintf(self::$KEY_NAME_ID, $name);
        return $rds->exists($key);
    }


	public function encodePassword($password) {
		$salt = "ilovedevelopment#$%&";
		return sha1(sha1(md5(md5($password . $salt))));
	}
}
