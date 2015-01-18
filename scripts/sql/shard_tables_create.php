<?php


$sql_tmplts= array(
    "CREATE TABLE if not exists `user_mission_%02d` (
      `role_id` bigint(20) unsigned NOT NULL,
      `section_id` int(10) unsigned NOT NULL,
      `best_point` tinyint(4) DEFAULT NULL,
      `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
      `npass` int(10) unsigned NOT NULL DEFAULT '0',
      `nfail` int(10) unsigned NOT NULL DEFAULT '0',
      `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
      `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `created_at` datetime DEFAULT NULL,
      UNIQUE KEY `idx_rolesection` (`role_id`, `section_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;",

   "CREATE TABLE if not exists `user_elite_mission_%02d` (
      `role_id` bigint(20) unsigned NOT NULL,
      `section_id` int(10) unsigned NOT NULL,
      `best_point` tinyint(4) DEFAULT NULL,
      `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
      `npass` int(10) unsigned NOT NULL DEFAULT '0',
      `nfail` int(10) unsigned NOT NULL DEFAULT '0',
      `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
      `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `created_at` datetime DEFAULT NULL,
      UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;",

  "CREATE TABLE if not exists `dragonball_fragment_%02d` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `role_id` int(11) NOT NULL,
      `fragment_no` int(11) DEFAULT NULL,
      `count` int(11) NOT NULL DEFAULT '0',
      PRIMARY KEY (`id`),
      UNIQUE KEY `idx_frag` (`fragment_no`,`role_id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=19260 DEFAULT CHARSET=utf8;",
  
);
$sql_tmplts_month = array(
  "CREATE TABLE if not exists `user_purchase_record_%s` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `user_id` bigint(20) unsigned NOT NULL,
      `store_id` smallint(6) NOT NULL,
      `commodity_id` smallint(6) NOT NULL,
      `count` smallint(6) NOT NULL,
      `cost` int(11) NOT NULL,
      `currency` varchar(20) NOT NULL,
      `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
  ) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8;",
);

$sql_tmplts_timelimited = "CREATE TABLE if not exists `user_mission_tl%d` (
      `role_id` bigint(20) unsigned NOT NULL,
      `section_id` int(10) unsigned NOT NULL,
      `best_point` tinyint(4) DEFAULT NULL,
      `nattempt` int(10) unsigned NOT NULL DEFAULT '0',
      `npass` int(10) unsigned NOT NULL DEFAULT '0',
      `nfail` int(10) unsigned NOT NULL DEFAULT '0',
      `nwipe` int(10) unsigned NOT NULL DEFAULT '0',
      `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `created_at` datetime DEFAULT NULL,
      UNIQUE KEY `idx_rolesection` (`role_id`,`section_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;";

$mysqli = new mysqli("127.0.0.1", "root", "namisan", "nami");
if ($mysqli->connect_errno) {
    die("fail to connect mysql:".$mysqli->connect_error);
}

function create_shard_table_by_num($sql_tmplt, $num) {
    global $mysqli;
    for ($i=0; $i<$num; $i++) {
        $sql = sprintf($sql_tmplt, $i);
        $r = $mysqli->query($sql);
        if (!$r) {
            echo "fail to execute [$sql]:".$mysqli->error;
            exit(1);
        }
    }
}

function create_shard_table_by_month($sql_tmplt, $year) {
    global $mysqli;
    for ($i=1; $i<=12; $i++) {
        $month = sprintf("%s_%02d", $year, $i); 
        $sql = sprintf($sql_tmplt, $month);
        $r = $mysqli->query($sql);
        if (!$r) {
            echo "fail to execute [$sql]:".$mysqli->error;
            exit(1);
        }
    }
}

function drop_table($num) {
    global $mysqli;
    for ($i=1; $i<$num; $i++) {
        $seq = sprintf("%02d", $i);
        $sql = "drop table if exists user_purchase_record_honorstore_2014_$seq";
        $sql = "drop table if exists user_mission_$seq";
        //$sql = "drop table if exists user_elite_mission_$seq";
        $r = $mysqli->query($sql);
        if (!$r) {
            echo "fail to execute [$sql]:".$mysqli->error;
            exit(1);
        }
    }
}

// time limited mission tables
for ($i=2;$i<=6;$i++) {
    $sql = sprintf($sql_tmplts_timelimited, $i);
    $r = $mysqli->query($sql);
    if (!$r) {
        echo "fail to execute [$sql]:".$mysqli->error;
        exit(1);
    }
}

/*
foreach ($sql_tmplts as $sql_tmplt) {
    create_shard_table_by_num($sql_tmplt, 100);
}

foreach ($sql_tmplts_month as $sql_tmplt) {
    create_shard_table_by_month($sql_tmplt, 2014);
}
 */

//drop_table(100);





// end of file
