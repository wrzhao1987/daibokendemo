<?php

namespace Cap\Models\db;

class CardRaffleModel extends BaseModel {

    
    public $sql_array = array(
        'create_new' => 'INSERT INTO __TABLE_NAME__ (user_id, type, free, seq, user_card_id, card_id, created_at) 
            values (:user_id:, :type:, :free:, :seq:, :user_card_id:, :card_id:, now())'
    );
    
    public function getSource() {
        return 'card_raffle_record';
    }

    public function addRecord($user_id, $type, $free, $seq, $card_id, $user_card_id) {
        $r = $this->execute('create_new', array('user_id'=>$user_id, 'type'=>$type, 
            'free'=>$free, 'seq'=>$seq, 'card_id'=>$card_id, 'user_card_id'=>$user_card_id));
        if ($r->success()) {
            return $r->getModel()->id;
        } else {
            $message = ""; 
            foreach ($result->getMessages() as $msg) {
                $message .= $msg . "\n";
            }
            syslog(LOG_ERR, "error in add card raffle record ($user_id, $type, $seq, $card_id, $user_card_id):$message");
            return false;
        }
    }

}

// end of file
