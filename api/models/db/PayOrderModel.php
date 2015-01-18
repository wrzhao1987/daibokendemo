<?php
namespace Cap\Models\Db;

class PayOrderModel extends BaseModel
{
    public function onConstruct()
    {
        $this->setConnectionService('account_db');
    }

    public function getSource()
    {
        return 'pay_order';
    }

    public function createOrder($source, $server_id, $user_id, $order_id, $package_id, $amount)
    {
		$db = $this->getDI()->getShared('account_db');
		$table = $this->getSource();
		$SQL = "INSERT INTO $table
				(source, server_id, user_id, order_id, package_id, amount, status, update_time, create_time)
                VALUES (?, ?, ?, ?, ?, ?, 1, NOW(), NOW())";
        $ret = $db->execute($SQL, [
            $source, $server_id, $user_id, $order_id, $package_id, $amount,
		]);
		return $ret;
    }

    public function getOrderByOrderID($order_id)
    {
        $SQL = "SELECT * FROM __TABLE_NAME__ WHERE order_id = '$order_id'";
        $ret = $this->executeSQL($SQL, []);
        return $ret->count() ? $ret->toArray()[0] : '';
    }

    public function updateOrderStatus($order_id, $status)
    {
        $SQL = "UPDATE __TABLE_NAME__ SET status = '$status', update_time = NOW() WHERE order_id = '$order_id'";
        $ret = $this->executeSQL($SQL, []);
        return $ret->success();
    }

    public function updateOrder($order_id, $update_info)
    {
        $columns = [];
        foreach ($update_info as $key => $val) {
            $columns[] = "$key = '$val'";
        }
        $columns[] = 'update_time = NOW()';
        $columns = implode(',', $columns);
        $SQL = "UPDATE __TABLE_NAME__ SET $columns WHERE order_id = $order_id";
        $ret = $this->executeSQL($SQL, []);
        return $ret->success();
    }


}
