<?php
namespace Cap\Libraries;

class RankLib extends BaseLib {

    public function __construct() {
        parent::__construct();
        $this->url = "http://localhost:8080/?data=";
    }

    public function rget($data) {
        $url = $this->url . json_encode($data);
        syslog(LOG_DEBUG, "url:$url");
        $res = @file_get_contents($url);
        if (isset($http_response_header)) {
            list($version,$status_code,$msg) = explode(' ',$http_response_header[0], 3);
            if ($status_code == "200") {
                if (strpos($res, '{') == 0) {
                    $obj = json_decode($res);
                    return $obj;
                } else {
                    return $res;
                }
            } else {
                syslog(LOG_ERR, "failed status $status_code, $msg");
            }
        } else {
            syslog(LOG_ERR, "failed to access rank service");
        }
        return "";
    }

    public function add($id) {
        $data = array(
            "cmd"=> "add",
            "id"=> intval($id),
        );
        $obj = $this->rget($data);
        return $obj;
    }

    /*
     * ids should be int array
     * return array of rank,  not found rank is set to -1
     */
    public function queryRanks($ids) {
        $vals = array();
        for ($i=0;$i<count($ids);$i++) {
            $vals []= intval($ids[$i]);
        }
        return $this->rget(array(
            "cmd"=> "queryrank",
            "id"=> $vals,
        ));
    }

    /*
     * get rank of one user, return false if not found 
     */
    public function queryRank($id) {
        $ranks = $this->queryRanks(array($id));
        if (!$ranks || $ranks[0]==-1) 
            return false;
        return $ranks[0];
    }

    /* 
     * ranks should be int array
     * return array(uid, uid, uid...), uid set to -1 if not exists
     */
    public function queryUsers($ranks) {
        return $this->rget(array(
            "cmd"=> "queryuser",
            "rank"=> array_values($ranks),
        ));
    }

    public function preempt($user1, $user2) {
        return $this->rget(array(
            "cmd"=> "preempt",
            "winner"=> $user1,
            "loser"=> $user2,
        ));
    }
}

