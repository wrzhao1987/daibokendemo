<?php
/**
 * Created by PhpStorm.
 * User: Martin
 * Date: 14-3-11
 * Time: 上午10:04
 */
namespace Cap\Controllers;

use Cap\Libraries\CardLib;
use Cap\Libraries\UserLib;
use Cap\Libraries\DeckLib;
use Cap\Libraries\ItemLib;

class CardController extends AuthorizedController {

	public function onConstruct() {

		parent::onConstruct();
		$this->_di->set('card_lib', function() {
			return new CardLib();
		}, true);
		$this->_di->set('user_lib', function() {
			return new UserLib();
		}, true);
		$this->_di->set('deck_lib', function() {
			return new DeckLib();
		}, true);
        $this->_di->set('item_lib', function() {
            return new ItemLib();
        }, true);
	}

	public function allAction()
	{
		$card_lib = $this->getDI()->getShared('card_lib');
		$all_card = $card_lib->getCardList($this->role_id);

		return json_encode($all_card, JSON_NUMERIC_CHECK);
	}

	public function deckAction()
	{
		$card_lib = $this->getDI()->getShared('card_lib');
		$card_deck = $card_lib->getDeckCard($this->role_id);

		return json_encode($card_deck, JSON_NUMERIC_CHECK);
	}

	public function deckUpAction()
	{
		$pos          = $this->request_data['pos'];
		$user_card_id = $this->request_data['user_card_id'];
		$deck_lib = $this->getDI()->getShared('deck_lib');
		$result = $deck_lib->updateDeckCard($this->role_id, $pos, $user_card_id);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
	}

    public function formUpAction()
    {
        $update_info = $this->request_data['form'];
        $deck_type   = $this->request_data['type'];
        $deck_lib = $this->getDI()->getShared('deck_lib');
        $result = $deck_lib->updateDeckFormation($this->role_id, $deck_type, $update_info);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

    public function equipUpAction()
    {
        $pos     = $this->request_data['pos'];
        $equip_pos = $this->request_data['equip_pos'];
        $user_equip_id = $this->request_data['uequip_id'];
        $deck_lib = $this->getDI()->getShared('deck_lib');
        $result = $deck_lib->updateDeckEquip($this->role_id, $pos, $equip_pos, $user_equip_id);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

    public function dragonBallUpAction()
    {
        $pos = $this->request_data['pos'];
        $dragon_ball_pos = $this->request_data['db_pos'];
        $user_ball_id  = $this->request_data['udb_id'];
        $deck_lib = $this->getDI()->getShared('deck_lib');
        $result = $deck_lib->updateDeckDragonBall($this->role_id, $pos, $dragon_ball_pos, $user_ball_id);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);

    }

	public function trailCalAction()
	{
		$user_card_id = $this->request_data['user_card_id'];
		$type = $this->request_data['type'];
		$card_lib = $this->getDI()->getShared('card_lib');
		$item_lib = $this->getDI()->getShared('item_lib');

        $result = false;
        // 消耗经验药水
        if ($item_lib->useItem($this->role_id, ITEM_TYPE_TRAIL_MEDICINE, 1, 1))
        {
            $result = $card_lib->calTrail($this->role_id, $user_card_id, $type);
        }
        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

	public function trailCommitAction()
	{
		$token = $this->request_data['token'];
		$card_lib = $this->getDI()->getShared('card_lib');
		$result = $card_lib->commitTrail($token);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

	public function composeAction()
	{
		$card_id = $this->request_data['card_id'];
		$card_lib = $this->getDI()->getShared('card_lib');
		$result = $card_lib->composeWithPiece($this->role_id, $card_id);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

	public function phaseUpAction()
	{
        $card_id = $this->request_data['card_id'];
        $card_lib = $this->getDI()->getShared('card_lib');
		$result = $card_lib->composeWithPiece($this->role_id, $card_id);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

	public function eatAction()
	{
		$user_card_id = $this->request_data['user_card_id'];
		$eat_id = $this->request_data['eat_id'];

		$card_lib = $this->getDI()->getShared('card_lib');
		$result = $card_lib->eatCard($this->role_id, $user_card_id, $eat_id);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

    public function skillUpAction()
    {
        $user_card_id = $this->request_data['user_card_id'];
        $skill_pos = $this->request_data['spos'];
        $card_lib = $this->getDI()->getShared('card_lib');

        $result = $card_lib->skillLevelUp($this->role_id, $user_card_id, $skill_pos);

        return json_encode(['result' => $result], JSON_NUMERIC_CHECK);
    }

    public function oneKeySkillUpAction()
    {
        if (($r = $this->checkParameter(['user_card_id', 'spos'])) !== true) {
            return $r;
        }
        $user_card_id = $this->request_data['user_card_id'];
        $skill_pos = $this->request_data['spos'];
        $card_lib = $this->getDI()->getShared('card_lib');
        $result = $card_lib->oneKeySkillUp($this->role_id, $user_card_id, $skill_pos);
        return json_encode($result, JSON_NUMERIC_CHECK);
    }
}

