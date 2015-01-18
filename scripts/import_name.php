<?php
/*
 * game charactor name depot
 */

/*
 * import name to redis set, 
 * name generated from two files: first name file and second name file
 */
function import_name_depot($first_name_file, $second_name_file) {
    $rds = new redis();
    $rds->connect('127.0.0.1', 6379);
    $rds->del("unused_names");
    $file_handle = fopen($first_name_file, "r");
    $firstnames = array();
    if (!$file_handle) {
        echo "file $first_name_file not found\n";
        return;
    }
    while (!feof($file_handle)) {
        $firstname = fgets($file_handle);
        $firstname=str_replace(array("\n","\r"),"",$firstname);
        if (strlen($firstname)==0) 
            continue;
        $firstnames []= $firstname;
    }

    $second = fopen($second_name_file, "r");
    if (!$second) {
        echo "file $second_name_file not found\n";
        return;
    }
    $c = 0;
    while (!feof($second)) {
        $secondname = fgets($second);
        $secondname = str_replace(array("\n","\r"),"",$secondname);
        if (strlen($secondname)==0)
            continue;
        foreach ($firstnames as $firstname) {
            $name = $firstname.$secondname;
            if (mb_strlen($name, 'utf8') > 8) {
                continue;
            }
            $rds->sadd("unused_names", $name);
            $c++;
        }
    }
    fclose($second);
    print ("added $c names\n");
    $rds->close();
}

function import_forbidden_names($name_file) {
    echo "import forbidden names from $name_file";
    $rds = new redis();
    $rds->connect('127.0.0.1', 6379);
    $rds->del("forbidden_names");
    $file_handle = fopen($name_file, "r");
    $names = array();
    if (!$file_handle) {
        echo "file $name_file not found\n";
        return;
    }
    while (!feof($file_handle)) {
        $name = fgets($file_handle);
        $name = str_replace(array("\n","\r"),"",$name);
        if (strlen($name)==0) 
            continue;
        $rds->sadd("forbidden_names", $name);
    }
    $rds->close();
}

/*
 * remove the used names from the name depot
 */
function clear_used_names() {
    $mysql_cfg = array(
        'host'=> 'localhost',
        'port'=> 3306,
        'user'=> 'root',
        'passwd'=> 'namisan',
        'db'=> 'nami',
    );

    $rds = new redis();
    $rds->connect('127.0.0.1', 6379);

    $mysqli = new mysqli($mysql_cfg['host'], $mysql_cfg['user'], 
        $mysql_cfg['passwd'], $mysql_cfg['db'], $mysql_cfg['port']);
    if ($mysqli->connect_errno) {
        echo "Failed to connect to MySQL: (".$mysqli->connect_errno.") ".$mysqli->connect_error."\n";
        return;
    }
    $mysqli->query("SET NAMES 'UTF8'"); 
    $mysqli->query("SET CHARACTER SET UTF8"); 
    $mysqli->query("SET CHARACTER_SET_RESULTS='UTF8'");

    $sql = "select name from user limit 10";
    $res = $mysqli->query($sql);
    $names = array();
    if (!$res) {
        echo "error in query [$sql]:".$mysqli->error."\n";
        return;
    }
    $c = 0;
    while ($row=$res->fetch_row()) {
        $name = $row[0];
        $r = $rds->srem("unused_names", $name);
        if ($r) {
            echo "remove $name\n";
            $c++;
        }
    }
    $mysqli->close();
    $rds->close();
    echo "removed $c names\n";
}

if (count($argv)<2) {
    echo "usage: php $argv[0] [import|importforbidden|clearused] ...\n";
    exit(0);
}
if (strcasecmp($argv[1], "import") == 0) {
    if (!isset($argv[2]) || !isset($argv[3])) {
        echo "miss arguments\nusage: php $argv[0] import first_name_file second_name_file\n";
        exit(0);
    }
    import_name_depot($argv[2], $argv[3]);
} else if (strcasecmp($argv[1], "importforbbiden") == 0) {
    if (!isset($argv[2])) {
        echo "miss arguments\nusage: php $argv[0] importforbbiden name_file\n";
        exit(0);
    }
    import_forbidden_names($argv[2]);
} else if (strcasecmp($argv[1], "clearused") == 0) {
    clear_used_names();
} else {
    echo "unknown cmd: $argv[1]\nusage: php $argv[0] [import|clear_used] ...\n";
    exit(0);
}

