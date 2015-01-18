<?php

namespace Cap\Controllers;

class TestController extends BaseController {

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set('drgbl_lib', function () {
            return new \Cap\Libraries\DragonballLib();
        },true);
        $this->_di->set('user_lib', function () {
            return new \Cap\Libraries\UserLib();
        },true);
    }

    public function dragonballAction() {
        $t1 = microtime(true);
        $t_start = $t1;

        $t2 = microtime(true);
        echo "1: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $drgbl_lib = $this->_di->getShared('drgbl_lib');
        $uid = 161;
        $frags = $drgbl_lib->getFragments($uid);
        var_dump($frags);

        $t2 = microtime(true);
        echo "2: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $fragno = 79;
        echo "add fragment $fragno<br/>";
        $r = $drgbl_lib->addFragment($uid, $fragno, 1);

        $t2 = microtime(true);
        echo "3: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $frags = $drgbl_lib->getFragments($uid);
        var_dump($frags);

        $t2 = microtime(true);
        echo "4: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        echo "dec fragment $fragno<br/>";
        $r = $drgbl_lib->decFragment($uid, $fragno, 1);
        var_dump($r);

        $t2 = microtime(true);
        echo "5: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $frags = $drgbl_lib->getFragments($uid);
        var_dump($frags);

        $t2 = microtime(true);
        echo "6: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        echo "dec fragment $fragno<br/>";
        $r = $drgbl_lib->decFragment($uid, $fragno, 1);
        var_dump($r);

        $t2 = microtime(true);
        echo "7: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $frags = $drgbl_lib->getFragments($uid);
        var_dump($frags);

        $t2 = microtime(true);
        echo "8: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;


        $fragno = 80;
        echo "add fragment $fragno<br/>";
        $r = $drgbl_lib->addFragment($uid, $fragno, 1);
        var_dump($r);

        $t2 = microtime(true);
        echo "9: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $frags = $drgbl_lib->getFragments($uid);
        var_dump($frags);

        $t2 = microtime(true);
        echo "10: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;


        echo "synthesize 13<br/>";
        for ($i=0;$i<6;$i++) {
            $drgbl_lib->addFragment($uid, 72+$i, 1);
        }

        $t2 = microtime(true);
        echo "11: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $r = $drgbl_lib->synthesize($uid, 13);
        var_dump($r);

        $t2 = microtime(true);
        echo "12: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        $frags = $drgbl_lib->getFragments($uid);
        var_dump($frags);

        $t2 = microtime(true);
        echo "13: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;


        echo "new dragonball <br/>";
        /*
        $r = $drgbl_lib->newDragonball($uid, 13);
        var_dump($r);
         */
        $balls = $drgbl_lib->getDragonballs($uid);
        var_dump($balls);

        $t2 = microtime(true);
        echo "14: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        foreach ($balls as $ball) {
            if (rand(0,1)>0.5)
                $drgbl_lib->addExp($uid, $ball['id'], 30);
        }
        $balls = $drgbl_lib->getDragonballs($uid);

        $t2 = microtime(true);
        echo "15: cost ".($t2-$t1)."<br/>";
        $t1 = $t2;

        var_dump($balls);
        echo "total cost :".($t2-$t_start)."<br/>";

    }

    public function dbfragAddAction() {
        $drgbl_lib = $this->_di->getShared('drgbl_lib');
        $t1 = microtime(true);
        $r = $drgbl_lib->addFragment(161, 6, 1);
        $t2 = microtime(true);
        syslog(LOG_DEBUG, "fragadd operation cost ".($t2-$t1)."s");
        var_dump($r);
    }

    public function dbfragDecAction() {
        $drgbl_lib = $this->_di->getShared('drgbl_lib');
        $r = $drgbl_lib->decFragment(161, 6, 1);
        var_dump($r);
    }

    public function dbNewAction() {
        $drgbl_lib = $this->_di->getShared('drgbl_lib');
        $r = $drgbl_lib->newDragonball(161, 6, 1);
        var_dump($r);
    }

    public function dbSynAction() {
        $drgbl_lib = $this->_di->getShared('drgbl_lib');
        $r = $drgbl_lib->synthesize(161, 13);
        var_dump($r);
    }

    public function dbgetAction() {
        $drgbl_lib = $this->_di->getShared('drgbl_lib');
        $r = $drgbl_lib->getDragonballs(161);
    }

    public function energyAction() {
        $user_lib = $this->_di->getShared('user_lib');
        $user_lib->consumeMissionEnergy(217, 2);
        $user = $user_lib->getUser(217);
        $res = array('energy'=> $user['mission_energy'], 'rst'=> $user['energy_time']);
        return json_encode($res);
    }

    public function userUpdateAction() {
        $user_lib = $this->_di->getShared('user_lib');
        $user_lib->updateFieldsSync(217, array('vip'=>2, 'coin'=> 5000));
    }
    public function infoAction() {
        phpinfo();
    }

    public function tlogAction() {
        $logger = new \Phalcon\Logger\Adapter\File("/var/log/capt.log");
        $r = $logger->log("this is a test message");
        $r = $logger->log("this is a error message", \Phalcon\Logger::ERROR);
        $r = $logger->log("this is a warn message", \Phalcon\Logger::WARNING);
        $fmt = new \Phalcon\Logger\Formatter\Line("%date% [%type%] - %message%");
        $logger->setFormatter($fmt);
        $r = $logger->log("this is another error message", \Phalcon\Logger::ERROR);
        $logger->info("this is a info");
        var_dump($r);
    }

    public function tsessAction() {
        $this->session->set('abc', "ABC");
        for ($i=0;$i<8;$i++) {
            $this->session->set('abc', "CDEF$i");
            $r = $this->session->get('abc');
            echo "...$r ";
            sleep(1);
        }
        echo "end";
    }

    public function tdiAction() {
        $this->_di->set('ab', function($arg1, $arg2) {
            return new AB($arg1);
        });
        //$this->_di->set('ab', new AB());
        echo "<br/>try get..<br/>";
        $this->_di->get('ab', array(4, 10));
        $this->_di->get('ab', array(5, 10));
    }
}

class AB {
    public static $NAME="AB";

    public function __construct($seq=0) {
        self::$NAME=self::$NAME.".".$seq;
        echo "AB constructing ".self::$NAME."...<br/>";
    }
}
