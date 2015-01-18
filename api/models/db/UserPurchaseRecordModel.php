<?php

namespace Cap\Models\db;

class UserPurchaseRecordModel extends BaseModel {

    private $current_ts;

    public $sql_array = array(
        'create_new'=> 'INSERT INTO __TABLE_NAME__ (user_id, store_id, commodity_id, count, cost, currency)
                values (:user_id:, :store_id:, :commodity_id:, :count:, :cost:, :currency:)',
    );

    public function addRecord($user_id, $store_id, $commodity_id, $count, $cost, $currency) {
        $r = $this->execute('create_new', array('user_id'=>$user_id, 'store_id'=>$store_id, 
            'commodity_id'=>$commodity_id, 'count'=>$count, 'cost'=>$cost, 'currency'=>$currency));
        if ($r->success()) {
            return true;
        } else {
            syslog(LOG_INFO, "fail to insert purchase record($user_id, $store_id, $commodity_id, $count, $cost, $currency)");
            return false;
        }
    }

    public function getRecord($start_date, $end_date) {
        $this->current_ts = strtotime($start_date);
        $sql = "SELECT * FROM __TABLE_NAME__ WHERE created_at >= :start: AND created_at < :end:";
        $result = $this->executeSQL($sql, [
            'start' => $start_date,
            'end'   => $end_date,
        ]);
        return $result->count() > 0 ? $result->toArray() : [];
    }

    public function getSource() {
        if (!isset($this->current_ts)) {
            $this->current_ts = time();
        }
        $month = date('Y_m', $this->current_ts);
        return 'user_purchase_record_'.$month; // add shard suffix
    }
}