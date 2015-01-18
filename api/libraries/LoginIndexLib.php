<?php

class LoginIndexLib {

    # [script_name=>code]
    public static $SCRIPT_CODE = array(
        'login_update'=> "
            local uid=ARGV[1];
            local t=ARGV[2];
            local level=ARGV[3];
            local r=redis.call('zadd', 'lvl:'..level..':login', t, uid);
            if r==1 then
                redis.call('hincrBy', 'lvl_distr', level, 1);
            end
            return r;
        ",
        'levelup_update'=>"
            local uid=ARGV[1];
            local old_level=ARGV[2];
            local new_level=ARGV[3];
            local time=ARGV[4];
            local remed=redis.call('zrem', 'lvl:'..old_level..':login', uid);
            if remed==1 then
                redis.call('hincrBy', 'lvl_distr', old_level, -1);
            end;
            local added=redis.call('zadd', 'lvl:'..new_level..':login', time, uid);
            if added==1 then
                redis.call('hincrBy', 'lvl_distr', new_level, 1);
            end;
            return added;
        ",
        'find_users'=>"
            local start_level = tonumber(ARGV[1]);
            local end_level = tonumber(ARGV[2]);
            local num = tonumber(ARGV[3]);
            local rseed = tonumber(ARGV[4]);
            local hd = redis.call('hgetall', 'lvl_distr');
            
            local sum = 0;
        
            local d = {};
            local i=1;
            while i<=table.getn(hd) do
                d[tonumber(hd[i])] = tonumber(hd[i+1]);
                i = i+2;
            end;
            for k=start_level,end_level do
                if d[k]==false or d[k]==nil  or d[k]==0 or d[k]=='0' then
                else
                    sum = sum+d[k];
                end;
            end;
            local users={};
            local idx = 1;
            if sum<=num then
                for i=start_level,end_level do
                    if d[i]==false or d[i]==nil or d[i]==0 or d[i]=='0' then
                    else
                        local ss = redis.call('zrange', 'lvl:'..i..':login', 0, -1);
                        for j=1,#(ss) do
                            users[idx] = ss[j];
                            idx = idx+1;
                        end;
                    end;
                end;
            else
                math.randomseed(rseed);
                local offsets = {}
                for i=1,num do
                    offsets[i] = math.random(1,sum);
                end;
                table.sort(offsets);
                local k = 1;
                local ac = 0;
                for i=start_level,end_level do
                    if d[i]==false or d[i]==nil or d[i]==0 or d[i]=='0' then
                    else
                        if false then
                            return d[i];
                        end;
                        while offsets[k]~=nil and offsets[k]<= ac+d[i] do
                            local offset = offsets[k]-ac-1;
                            local ss = redis.call('zrange', 'lvl:'..i..':login', offset, offset);
                            users[k] = ss[1];
                            k = k+1;
                        end;
                        if offsets[k]==nil then
                            break;
                        end;
                        ac = ac+d[i];
                    end;
                end;
            end;
            return users;
        ",
        'clear_data'=>"
            local time=ARGV[1];
            local total=0;
            for i=1,100 do
                local remed=redis.call('ZREMRANGEBYSCORE', 'lvl:'..i..':login', 0, time);
                if remed>0 then
                    redis.call('hincrby', 'lvl_distr', i..'', -remed);
                    total=total+remed;
                end;
            end;
            return total;
        ",
    );

    public static $USER_PROF_KEY = 'role:%s';
    public static $USER_PROF_FIELD_LEVEL = 'level';

    public function __construct() {
        $rds = new \redis();
        $rds->connect('localhost', 6371);
        $rds->select(2);
        $this->redis = $rds;
    }

    public function __fillScriptCache() {
        $code_cache = array();
        syslog(LOG_DEBUG, "redis_lua loading scirpts...");
        foreach (self::$SCRIPT_CODE as $k=>$code) {
            $sha1 = $this->redis->script('load', $code);
            if (!$sha1) {
                syslog(LOG_ERR, "fail to load script $k");
            }
            $code_cache[$k] = $sha1;
        }
        syslog(LOG_DEBUG, "loaded scirpts to cache:".json_encode($code_cache));
        apc_store('redis_lua_cache', $code_cache);
        return $code_cache;
    }

    public function getScriptSha($name) {
        if (!isset(self::$SCRIPT_CODE[$name])) {
            return false;
        }
        $cache = apc_fetch('redis_lua_cache');
        if (!$cache || !isset($cache[$name])) {
            syslog(LOG_WARNING, "fail to find cached sha1 for $name, try to reload");
            $cache = $this->__fillScriptCache();
        }
        return $cache[$name];
    }

    /*
     * load a script and return sha1 digest
     */
    public function loadScript($script_code) {
        $sha1 = $this->redis->script('load', $script_code);
        if (!$sha1) {
            syslog(LOG_ERR, "fail to load script{$script_code}");
        }
        return $sha1;
    }

    public function loginEvent($role_id, $time, $level) {
        syslog(LOG_DEBUG, "loginindex: loginEvent($role_id, $time, $level)");
        $sha1 = $this->getScriptSha('login_update');
        if (!$sha1) {
            syslog(LOG_ERR, "loginEvent: fail to load script");
            return false;
        }
        $r = $this->redis->evalSha($sha1, array($role_id, $time, $level), 0);
        syslog(LOG_DEBUG, "loginindex: loginEvent--".print_r($r, true));
        return $r;
    }

    /*
     * update index due to level up, login time should be provided
     */
    public function levelUpEvent($role_id, $old_level, $new_level, $time) {
        syslog(LOG_DEBUG, "loginindex: levelUpEvent($role_id, $old_level, $new_level, $time)");
        if ($time+24*3600<time()) {
            return;
        }
        $sha1 = $this->getScriptSha('levelup_update');
        if (!$sha1) {
            syslog(LOG_ERR, "levelUpEvent: fail to load script");
            return false;
        }
        $r = $this->redis->evalSha($sha1, array($role_id, $old_level, $new_level, $time), 0);
        return $r;
    }

    public function findUsers($start_level, $end_level, $num, $rseed) {
        $sha1 = $this->getScriptSha('find_users');
        if (!$sha1) {
            syslog(LOG_ERR, "findUsers: fail to load script");
            return false;
        }
        $r = $this->redis->evalSha($sha1, array($start_level, $end_level, $num, $rseed), 0);
        $users = array();
        if ($r) {
            foreach ($r as $v) {
                if ($v)
                    $users[$v] = 1;
            }
        }
        syslog(LOG_DEBUG, "find_users($start_level, $end_level, $num, $rseed): got ".count($users));
        return $users;
    }

    /*
     * delete uid from zset whose login timestamp less than given time
     * return elements deleted
     */
    public function clearDataBefore($time) {
        $sha1 = $this->getScriptSha('clear_data');
        if (!$sha1) {
            syslog(LOG_ERR, "clearDataBefore: fail to load script");
            return false;
        }
        $r = $this->redis->evalSha($sha1, array($time), 0);
        return $r;
    }
}

function test_redislua() {
    $t = new LoginIndexLib();
    $code = "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}";
    $code = "return redis.call('set', 'b', KEYS[1])";
    #$code = "return 1";
    #$sha1 = $t->loadScript($code);
    #var_dump($sha1);
    #$t->evalSha1($sha1);
    $t->loginEvent(162, time(), 2);
    $t->levelUpEvent(162, 2, 3, time());
    $users = $t->findUsers(0,4, 5, gettimeofday()['usec']);
    var_dump($users);
    #$t->clearDataBefore(10000);
    echo "test end\n";
}

#openlog("zcc-cap", LOG_PID|LOG_PERROR, LOG_LOCAL0);
#test_redislua();

