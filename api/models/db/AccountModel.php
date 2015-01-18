<?php 
namespace Cap\Models\Db;

class AccountModel extends BaseModel
{
	public $store_cols = array('id', 'email', 'password', 'create_time', 'update_time'); 
	public $cache_keys = array(
		'acct_mid'=>'acct:%s:mid', 
		'mid_profile'=>'mid:%s:prof', 
		'mid_role'=>'mid:%s:roles',
	);
	public function getSource() {
		return 'account';
	}

	public function onConstruct() {
		$this->setConnectionService('account_db');

		$config = \Phalcon\DI::getDefault()->get('config');
        if(empty($this->redis_host)) {
            $this->redis_host = $config['redis']->default->host;
        }   
        if (empty($this->redis_port)) {
            $this->redis_port = $config['redis']->default->port;
        } 
	}

	public $sql_array = array(
		'find_by_id'   => 'SELECT * from __TABLE_NAME__ WHERE id = :id:',
		'find_by_ids'  => 'SELECT * from __TABLE_NAME__ WHERE id in (:ids:)',
		'find_by_email' => 'SELECT * from __TABLE_NAME__ WHERE email = :email:',
		'create_new' => 'INSERT INTO __TABLE_NAME__ (email, password, create_time) 
			VALUES (:email:, :password:, now())',
	);

	public function findByEmail($email) {
		$redis = new \redis();
		$redis->connect($this->redis_host, \intval($this->redis_port));
		//
		$key = sprintf($this->cache_keys['acct_mid'], $email);
		$mid = $redis->get($key);
		syslog(LOG_DEBUG, "key=$key, mid=$mid, ");

		$acct = $this->findBy('find_by_email', array('email'=>$email));
        if($acct->count()==0) {
            return false;
        } else {
			$mid = $acct[0]->id;
			$redis->set($key, $mid); // restore cache
            return $acct[0];
        }   

	}

}
