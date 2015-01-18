#!/usr/bin/php 
<?php
openlog("nami-daily", LOG_PID|LOG_PERROR, LOG_LOCAL0);
syslog(LOG_INFO, "nami rank award daily award running");

require __DIR__."/../op/op_rank.php";
$datestr = date("Y-m-d");
$datafile = "/tmp/rank_$datestr.data";
export($datafile);

$awards_config = array(
    // rank => items
    "1"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 800
        )
    ),
    "2"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 700
        )
    ),
    "3"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 650
        )
    ),
    "10"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 600
        )
    ),
    "50"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 550
        )
    ),
    "100"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 500
        )
    ),
    "200"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 400
        )
    ),
    "500"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 350
        )
    ),
    "1000"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 300
        )
    ),
    "2000"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 250
        )
    ),
    "3000"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 220
        )
    ),
    "4000"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 200
        )
    ),
    "5000"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 180
        )
    ),
    "7000"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 150
        )
    ),
    "10000"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 120
        )
    ),
    // max
    "9999999"=> array(
        array(
            "item_id"=> 22,
            "sub_id"=> 1,
            "count"=> 100
        )
    ),
);

function giveAwards($datafile) {
    $f = fopen($datafile, "r");
    $rank = 0;
    global $awards_config;
    $award_users = array();
    while ($line=fgets($f)) {
        $line = chop($line);
        if (strlen($line)==0 or $line[0] == '#') {
            continue;
        }
        $rank++;
        $uid = intval($line);
        // determine award
        $award_key = 9999999;
        foreach ($awards_config as $r=>$items) {
            if ($rank<=$r && $r<$award_key ) {
                $award_key = $r;
            }
        }
        syslog(LOG_DEBUG, "rank $rank user $uid award $award_key\n");
        sendAwards(array($uid), $awards_config[$award_key], $rank);
    }
}

function sendAwards($uids, $items, $rank) {
    syslog(LOG_DEBUG, "send award to $rank\n");
    global $datestr;
    $mail = array(
        'mail_text'=> "武道排位赛每日奖励\n".$datestr." 你的排名是".$rank.",获得奖励",
        'targets'=> $uids,
        'from_name'=> '管理员',
        'attachment'=> $items
    );
    $data=json_encode($mail);
    $params = array(
        'http' => array(  
            'method'  => 'POST',  
            'header'  => "Content-type:application/x-www-form-urlencoded",   
            'content' => http_build_query(array('data'=>$data)),  
        )
    );
    $url = "http://127.0.0.1/nami-server/sys/sendmail";
    file_get_contents($url, false, stream_context_create($params)); 
}

giveAwards($datafile);

syslog(LOG_INFO, "nami rank award daily award end");




