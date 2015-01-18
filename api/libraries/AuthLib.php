<?php 
namespace Cap\Libraries;

use Cap\Models\Db\UserModel,
	Cap\Models\Db\EmailModel;

class AuthLib extends BaseLib {

	public function __construct() {
		parent::__construct();
		$this->_di->set("user_model", function() {
			return new UserModel();
		});
		$this->_di->set("email_model", function() {
			return new EmailModel();
		});
	}

	public function hasUserEmail($email) {
		$user_model = $this->_di->getShared("user_model");
		$user = $user_model->findBy('find_by_email', array('email'=>$email));
		if($user->count()==0) {
			return false;
		} else {
			return $user[0]->id;
		}
	}

	public function saveUserEmailPassword($email, $name, $password) {
		$password = $this->encodePassword($password);
		$user_model = $this->_di->getShared("user_model");
		$result = $user_model->execute('create_new', array('email'=>$email,
				'name'=>$name, 'password'=>$password));
		
		if ($result->success() != false) {
			return array('result'=>true, 'user_id'=>$result->getModel()->id);
		} else {
			$message = "";
			foreach ($result->getMessages() as $msg) {
				$message .= $msg . "\n";
			}
			return array('result'=>false, 'message'=>$message);
		}
	}
	
	public function checkUserEmailPassword($email, $password) {

		$password = $this->encodePassword($password);
		$check = UserModel::findFirst(array(
				"conditions" => "email = ?1 AND password = ?2",
				"bind" => array(1 => $email, 2 => $password)
		));
		if (!empty($check)) {
			return $check->id;
		} else {
			return false;
		}
	}

	public function setEmailSecretCode($email_str)
	{
		$secret_code = mt_rand();

		$email = $this->_di->getShared("email_model");

		$email->email = $email_str;
		$email->secret_code = $secret_code;
		$email->created_at = date("Y-m-d H:i:s");

		if ($email->save() == true) {
			return $secret_code;
		} else {
			$message = "";
			foreach ($email->getMessages() as $msg) {
				$message .= $msg . "\n";
			}
			error_log($message);
			return false;
		}
	}

	public function checkEmailSecretCode($email, $secret_code) {
		$check = Email::findFirst(array(
				"conditions" => "email = ?1 AND secret_code = ?2",
				"bind" => array(1 => $email, 2 => $secret_code)
		));
		return !empty($check);
	}

	public function removeEmailSecretCode($email) {
		$email_secret = EmailModel::findFirst(array(
				"conditions" => "email = ?1",
				"bind" => array(1 => $email)
		));
		$email_secret->email = $email;
		$email_secret->secret_code = "";
		return $email_secret->update();
	}

	public function encodePassword($password) {
		$salt = "ilovedevelopment#$%&";
		return sha1(sha1(md5(md5($password . $salt))));
	}
}
