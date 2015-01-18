<?php 
namespace Cap\Controllers;

use Cap\Libraries\AuthLib,
	Cap\Libraries\UserLib;

class AuthController extends BaseController {


	public function onConstruct()
	{
		parent::onConstruct();
		// lazy load
		$this->_di->set("auth_lib", function(){
			return new AuthLib();
		});
		$this->_di->set("user_lib", function(){
			return new UserLib();
		});
	}

	public function signupAction()
	{
		$name = $this->request->getPost("name");
		$email = $this->request->getPost("email");
		$password = $this->request->getPost("password");

		$auth_lib = $this->_di->getShared("auth_lib");

		/*
		if ($auth_lib->hasUserEmail($email)) {
			echo json_encode(array("result"=>"failed", "error_code"=> 101,
					"message"=>"邮件已经存在"));
			return;
		}
		 */

		$result = $auth_lib->saveUserEmailPassword($email, $name, $password);
		if ($result['result'] === true) {
			// set session
			$user_id = $result['user_id'];
			$this->session->set("uid", $user_id);
			$user_lib = $this->_di->getShared("user_lib");
			$user_info = $user_lib->getUser($user_id);
			echo json_encode(array('result'=>'success', 'uid'=>$user_id,
					'user'=>$user_info));
		} else {
			echo json_encode(array("result"=>"failed", "error_code"=> 102,
					"message"=>$result));
		}
	}

	public function signinAction()
	{
		// check the user and pwd
		$email = $this->request->getPost("email");
		$password = $this->request->getPost("password");

		$auth_lib = $this->_di->getShared("auth_lib");
		$user_id = $auth_lib->checkUserEmailPassword($email, $password);
		if ($user_id != false) {
			// set session
			$this->session->set("uid", $user_id);
			$user_lib = $this->_di->getShared("user_lib");
			$user_info = $user_lib->getUser($user_id);
			echo json_encode(array('result'=>'success', 'uid'=>$user_id,
					'user'=>$user_info));
		} else {
			echo json_encode(array('result'=>'failed',
					'error_code'=>201, 'message'=>'密码错误'));
		}
	}

	public function signoutAction()
	{
		if ($this->session->has("uid")) {
			$name = $this->session->destroy();
			echo json_encode(array('result'=>'success'));
		} else {
			echo json_encode(array('result'=>'success', 'error_code'=>301,
					'message'=>'已经退出登录'));
		}
	}

	public function resetAction() 
	{
		$email = $this->request->getPost("email");

		$auth_lib = $this->_di->getShared("auth_lib");
		$user_id = $auth_lib->hasUserEmail($email);
		if ($user_id == false) {
			echo json_encode(array("result"=>"failed", "error_code"=> 401,
					"message"=>"邮件没有注册"));
			return;
		}

		$secret_code = $auth_lib->setEmailSecretCode($email);
		$url = $this_di->getUrl();
		$reset_url = $url->get("/app/auth/reset/$user_id/$secret_code/");

		$to      = $email;
		$subject = '找回密码(请不要回复该邮件)';
		$message = "<a href='$reset_url'>请点击</a> 找回密码 <br> ".
				   "或者将 $reset_url 复制到浏览器中打开";

		$headers  = 'MIME-Version: 1.0' . "\r\n";
		$headers .= 'Content-type: text/html; charset=utf-8' . "\r\n";
		
		// Additional headers
		// $headers .= "To: $email" . "\r\n";
		$headers .= 'From: reset@followme.com' . "\r\n";

		mail($to, $subject, $message, $headers);
		echo json_encode(array('result'=>'success'));

	}

}
