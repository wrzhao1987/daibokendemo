<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-4-23
 * Time: 上午11:49
 */
abstract class CapBase
{
    protected $dsn     = 'mysql:dbname=nami;port=3306;host=127.0.0.1';
    protected $db_user = 'root';
    protected $db_pwd  = 'namisan';

    protected $db;

    protected static $MAX_COUNT_DRAGON_BALL = 4;
    protected static $MAX_COUNT_EQUIP       = 4;
    protected static $MAX_COUNT_SKILL       = 4;

    public function setUp()
    {
        date_default_timezone_set('Asia/Shanghai');
        try {
            $this->db = new PDO($this->dsn, $this->db_user, $this->db_pwd);
        } catch (PDOException $e) {
            syslog(LOG_ERR, "MySQL Connection Error:" . $e->getMessage());
        }
    }

    abstract public function perform();

    public function tearDown()
    {
        $this->db = null;
    }
}
