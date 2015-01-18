<?php

namespace Cap\Libraries;

class NameLib extends BaseLib {

    public static $UNUSED_NAMES = "unused_names";
    public static $FORBIDDEN_NAMES = "forbidden_names";
    public static $RENAME_COOLDOWN = 604800;
    public static $CACHE_KEY_RENAME_COOLDOWN = 'nami:cooldown:rename:%s';

    /*
     * once a name is used, remove it from set
     */
    public function removeName($name) {
        syslog(LOG_DEBUG, "removeName($name)");
        $rds = $this->_di->getShared('redis');
        $rds->srem(self::$UNUSED_NAMES, $name);
    }

    public function getNames($num) {
        $rds = $this->_di->getShared('redis');
        $names = $rds->srandmember(self::$UNUSED_NAMES, $num);
        return $names;
    }

    public function isForbidden($name) {
        $rds = $this->_di->getShared('redis');
        return $rds->sismember(self::$FORBIDDEN_NAMES, $name);
    }

    public function getRenameCoolDown($role_id) {
        $cache_key = sprintf(self::$CACHE_KEY_RENAME_COOLDOWN, $role_id);
        $cool_down = $this->redis->ttl($cache_key);
        return intval($cool_down) > 0  ? $cool_down : 0;
    }
}
