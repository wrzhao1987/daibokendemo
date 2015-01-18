<?php
/**
 * Created by PhpStorm.
 * User: martin
 * Date: 14-7-7
 * Time: 下午10:23
 */
namespace Cap\Libraries;

use Cap\Models\Db\AnnounceModel;

class AnnounceLib extends BaseLib
{
    public function __construct() {
        parent::__construct();
        $this->_di->set("announce_model", function() {
            return new AnnounceModel();
        }, true);
    }

    public function getAnnounce()
    {
        $ancs = AnnounceModel::find([
            'conditions' => "start <= :date: and end >= :date:",
            'bind'       => ['date' => date('Y-m-d H:i:s')],
        ]);
        if ($ancs->count()) {
            $ancs = $ancs->toArray();
            usort($ancs, function ($a, $b) {
                if ($a['weight'] == $b['weight']) {
                    return 0;
                } else {
                    return $a['weight'] < $b['weight'] ? 1 : -1;
                }
            });
            return $ancs;
        } else {
            return [];
        }
    }
}