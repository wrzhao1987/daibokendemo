<?php

namespace Cap\Controllers;


class ArenaController extends AuthorizedController {

    public static $ACCEPT_FIELDS = array(
        'opponents'=> 1,  // 获取挑战对手
        'rank'=> 2,       // 当前排名
        'best_rank'=> 3,  // 获取最好排名
        'new_award'=> 4,  // 检查pvp新奖项
        'top_ranks'=> 5,  // 获取前30名用户信息
        'energy'=> 6,     // 获取挑战能量
        'deck'=> 7,       // 获取出战阵列
        'tech'=> 8,       // 获取出战阵列
        'history'=> 9,    // battle history 
    );

    public function onConstruct() {
        parent::onConstruct();
        $this->_di->set("rank_lib", function() {
            return new \Cap\Libraries\RankLib();
        }, true);
        $this->_di->set("arena_lib", function() {
            return new \Cap\Libraries\ArenaLib();
        }, true);
        $this->_di->set("card_lib", function() {
            return new \Cap\Libraries\CardLib();
        }, true);
        $this->_di->set("award_lib", function() {
            return new \Cap\Libraries\AwardLib();
        }, true);
        $this->_di->set("tech_lib", function() {
            return new \Cap\Libraries\TechLib();
        }, true);
    }

    public function joinAction() {
        $role_id = $this->session->get("role_id");
        $rank_lib = $this->_di->getShared("rank_lib");
        $rank = $rank_lib->add($role_id);
        if ($rank) {
            # update best rank
            $arena_lib = $this->_di->getShared("arena_lib");
            $arena_lib->addPlayer($role_id, $rank);
            $rdata = array(
                "code"=> 200,
                "rank"=> $rank,
            );
        } else {
            $rdata = array(
                "code"=> 500,
                "desc"=> "无法加入排行"
            );
        }
        return json_encode($rdata);
    }

    public function queryAction() {
        $role_id = $this->session->get("role_id");
        $rank_lib = $this->_di->getShared("rank_lib");
        $ranks = $rank_lib->queryRanks(array($role_id));
        $rank = -1;
        if ($ranks && is_array($ranks)) {
            $rank = $ranks[0];
            $arena_lib = $this->_di->getShared("arena_lib");
            $best_rank = $arena_lib->getBestRank($role_id);
            $opportunities = $arena_lib->getOpportunities($role_id);
            $rdata = array(
                "code"=> 200,
                "rank"=> $rank,
                "opportunities"=> $opportunities,
            );
            if ($best_rank) {
                $rdata["best_rank"] = $best_rank;
            }
        } else {
            $rdata = array(
                "code"=> 601,
                "desc"=> "没有找到该用户",
            );
        }
        return json_encode($rdata);
    }

    public function searchAction() {
        $role_id = $this->session->get("role_id");
        $rank_lib = $this->_di->getShared("rank_lib");
        $ranks = $rank_lib->queryRanks(array($role_id));
        syslog(LOG_DEBUG, "search opponents for $role_id");
        $rank = -1;
        if ($ranks && is_array($ranks)) {
            $rank = $ranks[0];
            // generate several rank and find corresponding user
            $arena_lib = $this->_di->getShared("arena_lib");
            $opponents = $arena_lib->findOpponents($role_id);
            $rdata = array(
                "code"=> 200,
                "users"=> $opponents,
            );
        } else {
            $rdata = array(
                "code"=> 601,
                "desc"=> "没有找到该用户",
            );
        }
        return json_encode($rdata, JSON_FORCE_OBJECT);
    }

    public function challengeAction() {
        if (property_exists($this, "request_data")) {
            $data = $this->request_data;
        }
        if (!isset($data) || !isset($data['opponent'])) {
            syslog(LOG_INFO, "miss parameters:".$this->request->getPost('data'));
            return json_encode(array("code"=>400, "desc"=>"miss parameters"));
        }
        $attacker = $this->session->get('role_id');
        $defender = $data['opponent'];
        $arena_lib = $this->_di->getShared("arena_lib");
        $res = $arena_lib->challenge($attacker, $defender);
        if ($res['code'] != 200) {
            return json_encode($res);
        }

        $card_lib = $this->_di->getShared('card_lib');
        if (isset($data['get_deck'])) {
            // add self deck info
            $deck_info = $card_lib->getDeckCard($attacker);
            $res['deck'] = $deck_info;
        }

        $deck_lib = $this->_di->getShared('deck_lib');
        if (isset($data['deck_update'])) {
            $deck_lib->updateDeckFormation($role_id, DECK_TYPE_PVP, $data['deck_update']);
        }

        // done: add target deck info 
        $opponent_deck_info = $card_lib->getDeckCard($defender);
        $res['target_deck'] = $opponent_deck_info;

        # get tech info
        $tech_lib = $this->_di->getShared('tech_lib');
        $r = $tech_lib->getUserTechs($defender);
        $res['tech'] = $r;

        return json_encode($res, JSON_NUMERIC_CHECK);
    }

    public function challengeResultAction() {
        if (($r=$this->checkParameter(array('result', 'challenge_id'))) !== true) {
            return $r;
        }
        $data = $this->request_data;
        $challenge_id = $data['challenge_id'];
        $result = $data['result'];

        $arena_lib = $this->_di->getShared("arena_lib");
        $res = $arena_lib->commitChallenge($challenge_id, $result, array());
        return json_encode($res, JSON_FORCE_OBJECT|JSON_NUMERIC_CHECK);
    }

    public function generalAction() {
        $data = $this->request->getPost('data');
        $obj = json_decode($data, true);
        if (!$obj || !is_array($obj)) {
            return json_encode(array('code'=>'400', 'desc'=>'data required'));
        }

        $role_id = $this->session->get('role_id');
        $arena_lib = $this->_di->getShared("arena_lib");
        $rank_lib = $this->_di->getShared("rank_lib");

        $res = array('code'=>200);
        foreach ($obj as $field=>$v) {
            if (!isset(self::$ACCEPT_FIELDS[$field])) {
                syslog(LOG_INFO, "arena general action: skip unknown field $field");
                continue;
            }
            if (isset($res[$field])) continue;

            $k = self::$ACCEPT_FIELDS[$field];

            switch ($k) {
            case 1:
                # get opponents
                $r = $arena_lib->findOpponents($role_id);
                break;
            case 2:
                # get rank of self
                $r = $arena_lib->getRank($role_id);
                break;
            case 3:
                # get best rank of self
                $r = $arena_lib->getBestRank($role_id);
                break;
            case 4:
                # check new awards
                $award_lib = $this->_di->getShared('award_lib');
                $atype = \Cap\Libraries\AwardLib::$AWARD_CTGRY_PVP_RANK_ACHIEVEMENT;
                $r = $award_lib->checkAward($role_id, $atype);
                break;
            case 5:
                # get top ranks
                $r = $arena_lib->getTopUsers(30);
                break;
            case 6:
                # get challenge energy
                $r = $arena_lib->getOpportunities($role_id);
                break;
            case 7:
                # get deck info
                $card_lib = $this->_di->getShared('card_lib');
                $r = $card_lib->getDeckCard($role_id);
                break;
            case 8:
                # get tech info
                $tech_lib = $this->_di->getShared('tech_lib');
                $r = $tech_lib->getUserTechs($role_id);
				break;
            case 9:
                # get pvp history
                $r = $arena_lib->getHistory($role_id);
				break;
            default:
                $r = 'unknown field';
                break;
            }
            if ($r===false) {
                $res['code'] = 500;
                $res['msg'] = "fail to fetch $field";
                break;
            }
            $res[$field] = $r;
        }

        return json_encode($res, JSON_NUMERIC_CHECK);
    }

}
