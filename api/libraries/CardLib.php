<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-5-4
 * Time: 下午4:45
 */
namespace Cap\Libraries;

use Cap\Models\Db\UserCardModel;
use Cap\Models\Db\UserCardPieceModel;
use \Phalcon\Exception;

class CardLib extends BaseLib
{
    public static $CACHE_KEY_CARDS    = 'nami:cards:%s';
    public static $CACHE_KEY_SOULS    = 'nami:souls:%s';
    public static $CACHE_KEY_TRAIL    = 'nami:trail:%s:%s';
    public static $CACHE_KEY_CARD_IDS = 'nami:cardids:%s';
    public static $CACHE_KEY_SKILL_UP_COUNT = "nami:cards:skillup:%s";

    public static $SOUL_TRANS_RATE = 0.4;

    public function __construct()
    {
        parent::__construct();
        $this->_di->set('card_model', function()  {
            return new UserCardModel();
        }, true);
        $this->_di->set('piece_model', function() {
            return new UserCardPieceModel();
        }, true);
        $this->_di->set('resque_lib', function()  {
            return new ResqueLib();
        }, true);
        $this->_di->set('deck_lib', function ()   {
            return new DeckLib();
        }, true);
        $this->_di->set('equip_lib', function ()  {
            return new EquipLib();
        }, true);
        $this->_di->set('dball_lib', function ()  {
            return new DragonBallLib();
        }, true);
        $this->_di->set('user_lib', function ()   {
            return new UserLib();
        }, true);
        $this->_di->set('tech_lib', function ()   {
            return new TechLib();
        }, true);
    }

    public function getDeckCard($user_id, $no_offset = true)
    {
        $deck_lib = $this->_di->getShared('deck_lib');
        $deck = $deck_lib->getDeck($user_id);
        $leader_pos = DeckLib::$USER_DECK_LEADER_POSITION;
        $max_pos    = DeckLib::$USER_DECK_MAX_POSITION;
        $frd_pos    = DeckLib::$USER_DECK_FRIEND_POSITION;

        // cards
        $id_list = [];
        $no_card_pos = [];
        for ($i = $leader_pos; $i <= $max_pos; $i++) {
            $key = "card:{$i}";
            if ($deck[$key] == 0) {
                $no_card_pos[] = $i;
            } else {
                $id_list[] = $deck[$key];
            }
        }
        $cards = $this->getCards($user_id, $id_list);
		$card_pos = array_diff(range($leader_pos, $max_pos), $no_card_pos);
        // 魂淡，你卡组里根本没有牌，取个毛的卡组！
        if (empty ($card_pos)) {
            return false;
        }
        $cards = array_combine($card_pos, $cards);

        foreach ($cards as $pos => & $info) {
            if ($leader_pos == $pos) {
                $info['role'] = 1;
            } else {
                $info['role'] = 2;
            }

            // skills
            for ($i = 1; $i <= HERO_MAX_SKILL_COUNT; $i++) {
                $key = "slevel_{$i}";
                if (isset ($info[$key])) {
                    $info['skills'][] = $info[$key];
                    unset ($info[$key]);
                } else {
                    throw new Exception("skill level $i not found for user card {$info['id']}:{$user_id}", ERROR_CODE_DATA_INVALID_CARD);
                }
            }
            $info['pve_pos'] = $deck["pvepos:{$pos}"];
            $info['pvp_pos'] = $deck["pvppos:{$pos}"];
            $info['equips'] = [];
            $info['dragon_balls'] = [];
        }
        $this->assembleItems($user_id, $deck, $cards);

        // 添加科技对战斗力的影响
        $tech_lib = $this->_di->getShared('tech_lib');
        $tech = $tech_lib->getUserTechs($user_id);
        foreach ($card_pos as $i) {
			ksort($cards[$i]['equips']);
			ksort($cards[$i]['dragon_balls']);
            $cards[$i]['equips'] = array_values($cards[$i]['equips']);
            $cards[$i]['dragon_balls'] = array_values($cards[$i]['dragon_balls']);
			$cards[$i]['ucard_id'] = $cards[$i]['id'];
			unset ($cards[$i]['id']);
            $this->calADH($cards[$i]);
            // 添加科技对战斗力的影响
            $this->calStrength($cards[$i], $tech);
        }

        // 处理没有卡牌的卡组位置
        foreach ($no_card_pos as $pos) {
            $cards[$pos] = [
                'ucard_id' => 0,
                'card_id'  => 0,
            ];
        }
        // deal with friend pos
        $cards[$frd_pos]['role']    = 0;
        $cards[$frd_pos]['pvp_pos'] = 0;
        $cards[$frd_pos]['pve_pos'] = $deck["pvepos:{$frd_pos}"];
        ksort($cards);
        return $no_offset ? array_values($cards) : $cards;
    }

    // 根据卡牌阶级和基础攻防血，计算当前攻防血
    private function calADH(& $card_info)
    {
        if (
            isset ($card_info['phase']) &&
            isset ($card_info['card_id']) &&
            isset ($card_info['atk']) &&
            isset ($card_info['def']) &&
            isset ($card_info['hp']) &&
            isset ($card_info['level'])
        ) {
            $phase_cfg = self::getGameConfig('hero_phase');
            if (! isset ($phase_cfg[$card_info['card_id']])) {
                throw new Exception("Phase Config Not Defined For Card ID:{$card_info['card_id']}", ERROR_CODE_CONFIG_NOT_FOUND);
            }
            $card_info['atk'] = $card_info['atk'] + $card_info['level'] * $phase_cfg[$card_info['card_id']][$card_info['phase']]['delta_atk'];
            $card_info['def'] = $card_info['def'] + $card_info['level'] * $phase_cfg[$card_info['card_id']][$card_info['phase']]['delta_def'];
            $card_info['hp']  = $card_info['hp']  + $card_info['level'] * $phase_cfg[$card_info['card_id']][$card_info['phase']]['delta_hp'];
        }
    }
    private function assembleItems($user_id, $deck, & $cards)
    {
        $equip_ids = [];
        $dball_ids = [];
        foreach ($deck as $key => $value) {
            $tmp = explode(':', $key);
            // 如果是装备的key
            if ('equip' == $tmp[0]) {
                $equip_ids[$key] = $value;
            } else if ('dball' == $tmp[0]) {
                $dball_ids[$key] = $value;
            }
        }
        $equip_ids_not_0 = array_filter($equip_ids);
        $dball_ids_not_0 = array_filter($dball_ids);

        $equip_lib = $this->_di->getShared('equip_lib');
        $dball_lib = $this->_di->getShared('dball_lib');

        $equips = $equip_lib->getEquips($user_id, $equip_ids_not_0);
        if ($equips) {
            foreach ($equips as $user_equip_id => $detail) {
                $deck_equip_key = array_search($user_equip_id, $equip_ids_not_0);
				if ($deck_equip_key) {
					list ($no_use, $pos, $equip_pos) = explode(':', $deck_equip_key);
					$cards[$pos]['equips'][$equip_pos] = $detail;
				}
            }

            $equip_ids_0 = array_keys(array_diff($equip_ids, $equip_ids_not_0));
            foreach ($equip_ids_0 as $value) {
                list ($no_use, $pos, $equip_pos) = explode(':', $value);
                $cards[$pos]['equips'][$equip_pos] = [];
            }
        }
        $dballs = $dball_lib->getByUser($user_id, $dball_ids_not_0);
        if ($dballs) {
            foreach ($dballs as $user_dball_id => $detail) {
                $deck_dball_key = array_search($user_dball_id, $dball_ids_not_0);
				if ($deck_dball_key) {
					list ($no_use, $pos, $dball_pos) = explode(':', $deck_dball_key);
					$cards[$pos]['dragon_balls'][$dball_pos] = $detail;
				}
            }

            $dball_ids_0 = array_keys(array_diff($dball_ids, $dball_ids_not_0));
            foreach ($dball_ids_0 as $value) {
                list ($no_use, $pos, $dball_pos) = explode(':', $value);
                $cards[$pos]['dragon_balls'][$dball_pos] = [];
            }
        }
    }

    private function calStrength(& $card_info, $tech)
    {
        $strength = 0;
        $hero_conf = self::getGameConfig('hero_basic');
        $equip_config = self::getGameConfig('equip');

        $atk = $card_info['atk'];
        $def = $card_info['def'];
        $hp  = $card_info['hp'];

        if (is_array($tech) && count($tech) > 0) {
            $tech_conf = self::getGameConfig('tech');
            foreach ($tech as $v) {
                $var_name   = $tech_conf[$v['id']]['mod_type'];
                $$var_name += $tech_conf[$v['id']]['level_cfg'][$v['lvl']]['mod_value'];
            }
        }
        $atk_spd = $hero_conf[$card_info['card_id']]['atk_spd'];

        $dragon_balls = isset ($card_info['dragon_balls']) ? $card_info['dragon_balls'] : [];
        $equips = isset ($card_info['equips']) ? $card_info['equips'] : [];
        $skills = $card_info['skills'];

        $strength += array_sum($skills);

        foreach ($dragon_balls as $item) {
            if (! empty ($item)) {
                $strength += $item['level'] * 5.0;
            }
        }

        foreach ($equips as $item) {
            if (! empty ($item)) {
                if (isset ($equip_config[$item['equip_id']])) {
                    $equip_level = $item['level'];
                    $equip_type  = $item['type'];
                    $delta = $equip_config[$item['equip_id']]['value'][$equip_level];
                    switch ($equip_type) {
                        case 1:
                            $atk += $delta;
                            break;
                        case 2:
                            $def += $delta;
                            break;
                        case 3:
                            $hp += $delta;
                            break;
                        case 4:
                            $atk_spd = $hero_conf[$card_info['card_id']]['atk_spd'] + $delta;
                            break;
                        default:
                    }
                } else {
                    throw new Exception("equip config not found for equip:{$item['equip_id']}", ERROR_CODE_CONFIG_NOT_FOUND);
                }
            }
        }
        $card_info['strength'] = floor((($atk * 8.0 / 3000.0 * $atk_spd) + 16.0 * $def + $hp) / 10.0 + $strength);
    }

    public function addCard($user_id, $card_id, $level = 1)
    {
        $cards = $this->getCards($user_id);
        $all_card_ids = array_column($cards, 'card_id');
        $new_user_card_id = 0;
        if (in_array($card_id, $all_card_ids)) {
            $hero_phase_config = self::getGameConfig('hero_phase');
            if (isset ($hero_phase_config[$card_id])) {
                $hero_phase_config = $hero_phase_config[$card_id];
                // 打散成碎片时，碎片个数是合成时需要碎片的40%
                $piece_count = intval($hero_phase_config[0]['need_piece'] * self::$SOUL_TRANS_RATE);
                $this->updateCardPiece($user_id, $card_id, $piece_count);
            } else {
                throw new Exception("phase config for $card_id not found", ERROR_CODE_CONFIG_NOT_FOUND);
            }
        } else {
            $card_model = $this->getDI()->getShared('card_model');
            $new_card_info = $this->generateNewCardInfo($card_id, $level);
            $new_user_card_id = $card_model->addCard($user_id, $new_card_info);
            if (intval($new_user_card_id) > 0) {
                $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
				$new_card_info['id'] = $new_user_card_id;
                $this->redis->hSetNx($cache_key, $new_user_card_id, json_encode($new_card_info));

                // 新卡的话，直接放到卡组里面去
                $deck_lib = $this->getDI()->getShared('deck_lib');
                $deck = $deck_lib->getDeck($user_id);
                $leader_pos = DeckLib::$USER_DECK_LEADER_POSITION;
                $max_pos    = DeckLib::$USER_DECK_MAX_POSITION;
                for ($i = $leader_pos; $i <= $max_pos; $i++) {
                    $key = "card:{$i}";
                    if ($deck[$key] == 0) {
                        $deck_lib->updateDeckCard($user_id, $i, $new_user_card_id);
                        $deck_lib->setCardPvePosition($user_id, $i, $deck);
                        break;
                    }
                }
            } else {
                throw new Exception("failed to add card", ERROR_CODE_DB_ERROR_MYSQL);
            }
        }
        // 为了完成任务系统的需求，需要知道用户历史获得的最多卡牌种类，故做了以下改动
        $list_key = sprintf(self::$CACHE_KEY_CARD_IDS, $user_id);
        if (! $this->redis->sIsMember($list_key, $card_id)) {
            $this->redis->sAdd($list_key, $card_id);
        }
        return $new_user_card_id;
    }

    // 获得用户历史获得的卡牌数量
    public function cardHisCount($user_id)
    {
        $list_key = sprintf(self::$CACHE_KEY_CARD_IDS, $user_id);
        $count = $this->redis->sCard($list_key);
        return $count ? $count : 0;
    }

    // 获得用户历史获得的卡牌的详细
    public function cardHisDetail($user_id)
    {
        $list_key = sprintf(self::$CACHE_KEY_CARD_IDS, $user_id);
        $card_ids = $this->redis->sMembers($list_key);
        return empty($card_ids) ? [] : $card_ids;
    }

    public function getCardList($user_id)
    {
        $card_basic_cfg = self::getGameConfig('hero_basic');

        $deck_lib = $this->_di->getShared('deck_lib');
        $deck     = $deck_lib->getDeck($user_id);
        $cards    = $this->getCards($user_id);
        $souls    = $this->getCardPiece($user_id);
        $ldr_pos  = DeckLib::$USER_DECK_LEADER_POSITION;
        $max_pos  = DeckLib::$USER_DECK_MAX_POSITION;

        foreach ($cards as $user_card_id => & $detail) {
            $detail['weight'] = 0;
            $detail['role'] = 0;
            // deal deck pos weight
            $search_for_pos = array_keys($deck, $user_card_id);
            foreach ($search_for_pos as $key) {
                $tmp = explode(':', $key);
                if ('card' == $tmp[0]) {
                    $detail['weight'] += (7 -$tmp[1]) * pow(10, 7);
                    if ($ldr_pos == $tmp[1]) {
                        $detail['role'] = 1;
                    } else if ($ldr_pos < $tmp[1] && $tmp[1] <= $max_pos) {
                        $detail['role'] = 2;
                    }
                }
            }

            // deal card star
            $star = $card_basic_cfg [$detail['card_id']] ['star'];
            $detail['weight'] += $star * pow(10, 5);

            // deal card level
            $detail['weight'] += $detail['level'] * pow(10, 3);

            // skills
            for ($i = 1; $i <= HERO_MAX_SKILL_COUNT; $i++) {
                $key = "slevel_{$i}";
                $detail['skills'][] = $detail[$key];
                unset ($detail[$key]);
            }
            $detail['card_count'] = 1;
            $detail['soul_count'] = 0;
        }

        // sort
        usort ($cards, function ($a, $b) {
            if ($a['weight'] == $b['weight']) {
                return 0;
            }
            return ($a['weight'] > $b['weight']) ? -1 : 1;
        });

        // remove unused var
        // recal 攻防血
        foreach ($cards as & $item) {
            $this->calADH($item);
            $item['ucard_id'] = $item['id'];
            unset ($item['id']);
            unset ($item['weight']);
        }

        // souls
        arsort($souls);
        $card_ids = array_column($cards, 'card_id');
        foreach ($souls as $card_id => $count) {
            $key = array_search($card_id, $card_ids);
            if (false !== $key) {
                $cards[$key]['soul_count'] = $souls[$card_id];
            } else {
                array_push($cards, [
                    'role'         => 0,
                    'card_id'      => $card_id,
                    'ucard_id'     => 0,
                    'phase'        => 0,
                    'level'        => 0,
                    'card_count'   => 0,
                    'soul_count'   => $count,
                    'exp'          => 0,
                    'skills'       => [],
                ]);
            }
        }
        return array_values($cards);
    }

    private function generateNewCardInfo($card_id, $level = 1)
    {
        $card_config = self::getGameConfig('hero_basic');
        if (! isset ($card_config[$card_id])) {
            throw new Exception("card config not found, card id:$card_id", ERROR_CODE_CONFIG_NOT_FOUND);
        }
        $card_config = $card_config[$card_id];
        $new_card_info = [
            'card_id'   => $card_id,
            'exp'       => 0,
            'level'     => 1,
            'phase'     => 0,
            'atk'       => $card_config['atk'],
            'def'       => $card_config['def'],
            'hp'        => $card_config['hp'],
			'potential' => 100,
            // slevel是指技能等级
            'slevel_1'  => 1,
            'slevel_2'  => 0,
            'slevel_3'  => 0,
            'slevel_4'  => 0,
        ];
        if (intval($level) > 1)
        {
            $level_config = self::getGameConfig('hero_level');
            if (! isset ($level_config[$card_id])) {
                throw new Exception("card config not found, card id:$card_id", ERROR_CODE_CONFIG_NOT_FOUND);
            }
            $level_config = $level_config[$card_id];
            for ($i = 2; $i <= $level; $i++)
            {
                $new_card_info['atk'] += $level_config[$i]['delta_atk'];
                $new_card_info['def'] += $level_config[$i]['delta_def'];
                $new_card_info['hp']  += $level_config[$i]['delta_hp'];
            }
            $new_card_info['exp'] = $level_config[$level - 1]['exp_limit'];
            $new_card_info['level'] = $level;
        }
        return $new_card_info;
    }

    public function skillLevelUp($user_id, $user_card_id, $skill_pos) {

        $user_card = $this->getCard($user_id, $user_card_id);
        $card_id = $user_card['card_id'];
        $skill_var_name = "slevel_{$skill_pos}";
        $skill_level = $user_card[$skill_var_name];
        if ($skill_pos >= 1 && $skill_pos <= 4) {
            $conf_name = "skill_{$skill_pos}";
            $skill_conf = self::getGameConfig($conf_name);
        }
        if (isset ($skill_conf)) {
            if ($user_card['level'] < $skill_level + 1) {
                throw new Exception('卡牌技能等级不得超越所属卡牌等级.', ERROR_CODE_DATA_INVALID_CARD);
            }
            // 获得升级技能所需索尼币
            $cost = $skill_conf[$card_id]['update_cost'][$skill_level];
            $user_lib = $this->getDI()->getShared('user_lib');
            $ret = $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, $cost);
            if ($ret!==false) {
                // 扣钱成功，给用户升级技能
                $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
                $user_card[$skill_var_name] = $skill_level + 1;
                $this->redis->hSet($cache_key, $user_card_id, json_encode($user_card));
                $resque_lib = $this->_di->getShared('resque_lib');
                $job_is_set = $resque_lib->setJob('card', 'ProfUp', [
                    'user_id'  => $user_id,
                    'ucard_id' => $user_card_id,
                    'prof'     => [$skill_var_name => $skill_level + 1],
                ]);
                $this->incrSkillUpCount($user_id);
                return $job_is_set ? true : false;
            } else {
                throw new Exception('没有足够的索尼币升级该技能', ERROR_CODE_FAIL);
            }
        }
        return false;
    }

    public function oneKeySkillUp($user_id, $user_card_id, $skill_pos)
    {
        $user_lib = $this->getDI()->getShared('user_lib');
        $user     = $user_lib->getUser($user_id);
        $user_coin  = $user[UserLib::$USER_PROF_FIELD_COIN];

        $user_card = $this->getCard($user_id, $user_card_id);
        if ($user_card) {
            $card_id = $user_card['card_id'];
            $skill_var_name = "slevel_{$skill_pos}";
            $skill_level = $user_card[$skill_var_name];
            if ($skill_pos >= 1 && $skill_pos <= 4) {
                $conf_name = "skill_{$skill_pos}";
                $skill_conf = self::getGameConfig($conf_name);
            } else {
                return ['code' => 500, 'msg' => 'Skill Pos is not good.'];
            }
            $cost = 0;
            for ($i = $skill_level; $i < $user_card['level']; $i++) {
                $cost += $skill_conf[$card_id]['update_cost'][$i];
                if ($cost > $user_coin) {
                    $cost -= $skill_conf[$card_id]['update_cost'][$i];
                    break;
                }
            }
            $delta = $i - $skill_level;
            if (intval($delta) > 0) {
                $remain = $user_lib->consumeFieldAsync($user_id, UserLib::$USER_PROF_FIELD_COIN, $cost);
                if ($remain !== false) {
                    $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
                    $user_card[$skill_var_name] = $skill_level + $delta;
                    $this->redis->hSet($cache_key, $user_card_id, json_encode($user_card));
                    $resque_lib = $this->_di->getShared('resque_lib');
                    $resque_lib->setJob('card', 'ProfUp', [
                        'user_id'  => $user_id,
                        'ucard_id' => $user_card_id,
                        'prof'     => [$skill_var_name => $skill_level + $delta],
                    ]);
                    $this->incrSkillUpCount($user_id, $delta);
                    return ['code' => 200, 'level' => $i, 'cost' => $cost];
                }
            } else {
                return [
                    'code'  => 200,
                    'level' => $skill_level,
                    'cost'  => 0,
                ];
            }
        }


    }

    public function addExpForCards($user_id, $user_card_ids, $exp)
    {
        if (empty ($user_id) && empty($user_card_ids))
        {
            return false;
        }
        $result = [];
        $resque_lib = $this->_di->getShared('resque_lib');
        $cards = $this->getCards($user_id, $user_card_ids);

        if (! empty ($cards)) {
            $user_lib = $this->_di->getShared('user_lib');
            $user     = $user_lib->getUser($user_id);
            $user_level = $user[UserLib::$USER_PROF_FIELD_LEVEL];

            $update_info = [];
            foreach ($cards as $user_card_id => $detail) {
                $cal_result = $this->calLevelUp($detail, $exp, $user_level);
                $result[$user_card_id] = [
                    'level' => intval($cal_result['level']),
                    'exp'   => intval($cal_result['exp']),
                ];
                $job_is_set = $resque_lib->setJob('card', 'ProfUp', [
                    'user_id'  => $user_id,
                    'ucard_id' => $user_card_id,
                    'prof'     => $cal_result,
                ]);
                if ($job_is_set) {
                    foreach ($cal_result as $field => $value) {
                        $detail[$field] = $value;
                    }
                    $update_info[$user_card_id] = json_encode($detail);
                }
            }
            $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
            $update_info && $this->redis->hMSet($cache_key, $update_info);
            return $result;
        }
        return false;
    }

    private function calLevelUp($card, $delta, $user_level)
    {
        $hero_level_config = self::getGameConfig('hero_level');
        $user_level_config = self::getGameConfig('user_level');
        if (! isset ($hero_level_config)) {
            throw new Exception("Card Id Not Defined:{$card['card_id']}", ERROR_CODE_CONFIG_NOT_FOUND);
        }
        $hero_level_config = $hero_level_config[$card['card_id']];
        $max_level         = $user_level_config['level_config'][$user_level]['card_level_limit'];
        $max_exp           = $hero_level_config[$max_level]['exp_limit'];

        if ($card['exp'] + $delta >= $hero_level_config[$card['level']]['exp_limit'])
        {
            $i = $card['level'];
            $delta_atk       = 0;
            $delta_def       = 0;
            $delta_hp        = 0;
            $delta_potential = 0;
            while ($hero_level_config [$i] ['exp_limit'] <= ($card['exp'] + $delta))
            {
                // 累加攻击力、防御力和血量的增量
                $i++;
				// 卡牌等级不得超越指定用户等级的战队等级限制
				if ($i > $max_level) {
					$i = $max_level;
					break;
				}
                $delta_atk       += $hero_level_config [$i] ['delta_atk'];
                $delta_def       += $hero_level_config [$i] ['delta_def'];
                $delta_hp        += $hero_level_config [$i] ['delta_hp'];
                $delta_potential += $hero_level_config [$i] ['delta_potential'];
            }
            // 卡牌达到的最终级别
            $current_level = $i;
            $cal_result = [
                'atk'       => $delta_atk + $card['atk'],
                'def'       => $delta_def + $card['def'],
                'hp'        => $delta_hp  + $card['hp'],
                'level'     => $current_level,
                'exp'       => min($max_exp, $card['exp'] + $delta) ,
                'potential' => $card['potential'] + $delta_potential,
            ];
        }
        else
        {
            $cal_result = [
                'atk'       => $card['atk'],
                'def'       => $card['def'],
                'hp'        => $card['hp'],
                'level'     => $card['level'],
                'exp'       => $card['exp'] + $delta,
                'potential' => $card['potential'],
            ];
        }

        return $cal_result;
    }

    private function getCardPiece($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_SOULS, $user_id);
        $all_piece = $this->redis->hGetAll($cache_key);
        if (empty ($all_piece)) {
            $piece_model = $this->getDI()->getShared('piece_model');
            $all_piece = $piece_model->getAllPiece($user_id);
            $this->redis->hMSet($cache_key, $all_piece);
        }
        return $all_piece;
    }


    public function updateCardPiece($user_id, $card_id, $delta)
    {
        $resque_lib = $this->getDI()->getShared('resque_lib');
        if ($resque_lib->setJob('card', 'PieceUp', [
            'user_id' => $user_id,
            'card_id' => $card_id,
            'delta'   => $delta,
        ])) {
            $cache_key = sprintf(self::$CACHE_KEY_SOULS, $user_id);
            $result = $this->redis->hIncrBy($cache_key, $card_id, $delta);
            if (intval($result) < 0) {
                $this->redis->hIncrBy($cache_key, $card_id, - $delta);
                return false;
            } else if (intval($result) == 0) {
                $this->redis->hDel($cache_key, $card_id);
            }
            return true;
        }
        return false;
    }

    public function updatePieceBatch($user_id, $piece_delta = [])
    {
        $result = [];
        if (empty ($piece_delta)) {
            return array();
        }
        foreach ($piece_delta as $card_id => $delta) {
            if ($card_id && $delta) {
                $result[$card_id] = $this->updateCardPiece($user_id, $card_id, $delta);
            }
        }
        return $result;
    }

    public function eatCard($user_id, $user_card_id, $eat_id)
    {
        $deck_lib = $this->_di->getShared('deck_lib');
        if ($deck_lib->isInDeck($user_id, $eat_id)) {
            return false;
        }
        $card_B = $this->getCard($user_id, $eat_id);
        if ($card_B) {
            $exp = $card_B['exp'];
            if ($this->addExpForCards($user_id, [$user_card_id], $exp)) {
                $this->deleteUserCard($user_id, $eat_id, false);
                return true;
            }
        }
        return false;
    }

    public function deleteUserCard($user_id, $user_card_id, $need_detail = true)
    {
        $result = true;
        if ($need_detail) {
            $result = $this->getCard($user_id, $user_card_id);
        }
        $resque_lib = $this->getDI()->getShared('resque_lib');
        if ($resque_lib->setJob('card', 'Delete', [
            'user_id' => $user_id,
            'ucard_id' => $user_card_id,
        ])) {
            $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
            $this->redis->hDel($cache_key, $user_card_id);
            return $result;
        }
        return false;
    }

    public function composeWithPiece($user_id, $card_id)
    {
        $cards = $this->getCards($user_id);
        $all_card_ids = array_column($cards, 'card_id', 'id');

        $hero_phase_config = self::getGameConfig('hero_phase');
        if (! isset ($hero_phase_config)) {
            throw new Exception("Phase Config Not Defined For Card ID:{$card_id}", ERROR_CODE_CONFIG_NOT_FOUND);
        }
        $hero_phase_config = $hero_phase_config[$card_id];

        // 玩家手中有此张牌，做突破操作
        if (in_array($card_id, $all_card_ids)) {
            $user_card_id = array_search($card_id, $all_card_ids);
            $card = $cards[$user_card_id];
            // 不能超过最高可突破等级
            if ($card['phase'] >= HERO_MAX_PHASE) {
                throw new Exception("User Card Has Reached Max Phase", ERROR_CODE_FAIL);
            }
            $need_piece = $hero_phase_config [$card['phase'] + 1] ['need_piece'];
            $delta_potential = $hero_phase_config [$card['phase'] + 1] ['delta_potential'];
            $soul_ret = $this->updateCardPiece($user_id, $card_id, - $need_piece);
            if (! $soul_ret) {
                throw new Exception("Soul Not Enough", ERROR_CODE_FAIL);
            }
            $update_info = [];
            // 解锁新技能
            $var_name = "slevel_" . strval($card['phase'] + 2);
            $update_info[$var_name] = 1;
            $update_info['phase'] = $card['phase'] + 1;
            $update_info['potential'] = $card['potential'] + $delta_potential;

            $card = array_merge($card, $update_info);
            $resque_lib = $this->_di->getShared('resque_lib');
            if ($resque_lib->setJob('card', 'ProfUp', [
                'user_id'  => $user_id,
                'ucard_id' => $user_card_id,
                'prof'     => $update_info,
            ]))
            {
                $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
                $this->redis->hSet($cache_key, $user_card_id, json_encode($card));
                return true;
            }
        } else {
            $need_piece = $hero_phase_config[0]['need_piece'];
            if ($this->updateCardPiece($user_id, $card_id, - $need_piece)) {
                return $this->addCard($user_id, $card_id);
            } else {
                throw new Exception("Soul Not Enough", ERROR_CODE_FAIL);
            }
        }
        return false;
    }

    public function calTrail($user_id, $user_card_id, $type)
    {
        if (empty ($user_id) || empty ($user_card_id)) {
            return false;
        }
        $card = $this->getCard($user_id, $user_card_id);
        $prop_array = [HERO_PROPERTY_ATK, HERO_PROPERTY_DEF, HERO_PROPERTY_HP];
        shuffle($prop_array);
        $prop_minus = array_pop($prop_array);
        $prop_add   = array_pop($prop_array);

        switch ($type) {
            case NORMAL_TRAIL:
                $minus = mt_rand(1, 3);
                $delta = mt_rand(NORMAL_TRAIL_MIN_DELTA, NORMAL_TRAIL_MAX_DELTA);
                $add   = $minus + $delta;
                break;
            case NORMAL_TRAIL_10:
                $minus = 10 * mt_rand(1, 3);
                $delta = 10 * mt_rand(NORMAL_TRAIL_MIN_DELTA, NORMAL_TRAIL_MAX_DELTA);
                $add   = $minus + $delta;
                break;
            case PREMIUM_TRAIL:
                $minus = mt_rand(1, 3);
                $delta = mt_rand(PREMIUM_TRAIL_MIN_DELTA, PREMIUM_TRAIL_MAX_DELTA);
                $add   = $minus + $delta;
                break;
            case PREMIUM_TRAIL_10:
                $minus = 10 * mt_rand(1, 3);
                $delta = 10 * mt_rand(PREMIUM_TRAIL_MIN_DELTA, PREMIUM_TRAIL_MAX_DELTA);
                $add   = $minus + $delta;
                break;
            default:
                $minus = 0;
                $delta = 0;
                $add   = 0;
        }
        if ($card['potential'] < $delta) {
            $minus = $card['potential'];
            $delta = $card['potential'];
            $add   = $minus + $delta;
        }

        $result = [
            $prop_minus => -$minus,
            $prop_add   => $add,
            'potential' => $delta,
        ];
        $cache_key = sprintf(self::$CACHE_KEY_TRAIL, $user_id, $user_card_id);
        $this->redis->del($cache_key);
        $this->redis->hMSet($cache_key, $result);
        $this->redis->expire($cache_key, 3600);
        $result['token'] = $cache_key;
        return $result;
    }


    // 按照修炼结果更新卡片
    public function commitTrail($token)
    {
        $trail_result = $this->redis->hGetAll($token);
        if (! empty ($trail_result))
        {
            list($no_use_1, $no_use_2, $user_id, $user_card_id) = explode(':', $token);
            $card = $this->getCard($user_id, $user_card_id);
            $update_info  = [];
            foreach ($trail_result as $key => $value)
            {
                switch ($key)
                {
                    case HERO_PROPERTY_ATK:
                        $update_info['atk'] = $card['atk'] + $value;
                        break;
                    case HERO_PROPERTY_DEF:
                        $update_info['def'] = $card['def'] + $value;
                        break;
                    case HERO_PROPERTY_HP;
                        $update_info['hp']  = $card['hp']  + $value;
                        break;
                    case 'potential':
                        $card['potential'] = $update_info['potential'] = $card['potential'] - $value;
                        break;
                    default:
                }
            }
            $resque_lib = $this->_di->getShared('resque_lib');
            if ($resque_lib->setJob('card', 'ProfUp', [
                'user_id'  => $user_id,
                'ucard_id' => $user_card_id,
                'prof'     => $update_info,
            ]))
            {
                $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
                $card = array_merge($card, $update_info);
                $this->redis->hSet($cache_key, $user_card_id, json_encode($card));
                return true;
            }
        }
        return false;
    }

    public function getCards($user_id, $id_list = [])
    {
        $id_list = array_filter($id_list);
        $ret = [];
        $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);

        if (empty ($id_list)) {
            $tmp = $this->redis->hGetAll($cache_key);
        } else {
            $tmp = $this->redis->hMGet($cache_key, $id_list);
        }
        if (! empty($tmp) && (false === array_search(false, $tmp))) {
            foreach ($tmp as $id => $card_info) {
                $ret[$id] = json_decode($card_info, true);
            }
        } else {
            $card_model = $this->getDI()->getShared('card_model');
            if ($tmp = $card_model->getByUser($user_id)) {
                $cache_content = [];
                foreach ($tmp as $id => $card_info) {
                    $cache_content[$id] = json_encode($card_info);
                }
                $this->redis->hMSet($cache_key, $cache_content);
                if (empty ($id_list)) {
                    $ret = array_combine(array_column($tmp, 'id'), $tmp);
                } else {
                    foreach ($id_list as $id) {
                        $ret[$id] = $tmp[$id];
                    }
                }
            }
        }
        return $ret;
    }

    private function getCard($user_id, $user_card_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_CARDS, $user_id);
        $card = $this->redis->hGet($cache_key, $user_card_id);
        return empty ($card) ? false : json_decode($card, true);
    }

    public function getDeckCardId($user_id) {
        $deck_lib = $this->_di->getShared('deck_lib');
        $deck = $deck_lib->getDeck($user_id);
        $leader_pos = DeckLib::$USER_DECK_LEADER_POSITION;
        $max_pos    = DeckLib::$USER_DECK_MAX_POSITION;

        // cards
        $id_list = [];
        for ($i = $leader_pos; $i <= $max_pos; $i++) {
            $key = "card:{$i}";
            $id_list[] = $deck[$key];
        }
        $cards = $this->getCards($user_id, $id_list);
        $card_ids = array_column($cards, 'card_id');
        return $card_ids;

    }

    public function getDeckCardsOverview($user_id) {
        $deck_info = $this->getDeckCard($user_id);
        $deck_cards = [];

        foreach ($deck_info as $detail) {
            if (! empty ($detail)
                && isset($detail['card_id'])
                && isset($detail['level'])
                && isset($detail['strength']))
            {
                $deck_cards[] = array(
                    'card_id'  => $detail['card_id'],
                    'level'    => $detail['level'],
                    'strength' => $detail['strength'],
                );
            } else {
                $deck_cards[] = 0;
            }
        }
        return $deck_cards;
    }

    public function getSkillUpCount($user_id)
    {
        $cache_key = sprintf(self::$CACHE_KEY_SKILL_UP_COUNT, $user_id);
        $count = $this->redis->get($cache_key);
        return $count ? intval($count) : 0;
    }

    public function incrSkillUpCount($user_id, $delta = 1)
    {
        $cache_key = sprintf(self::$CACHE_KEY_SKILL_UP_COUNT, $user_id);
        $expire = self::getDefaultExpire();

        if ($this->redis->exists($cache_key)) {
            $count = $this->redis->incrBy($cache_key, $delta);
        } else {
            $count = $this->redis->incrBy($cache_key, $delta);
            $this->redis->expireAt($cache_key, $expire);
        }
        return $count;
    }
}
