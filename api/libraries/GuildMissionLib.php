<?php

namespace Cap\Libraries;


class GuildMissionLib extends BaseLib {

    public static $GBOSS_KEY = "gboss:%s:%s";      // placeholder: guild id, boss_uid
    public static $GUILD_KEY = "guild:%s";         // placeholder: guild id
    public static $DEAD_BOSS_EXPIRE = 3600;

    public static $UPGRADE_COST = array (
        "1"=> 600000,   // cost need when upgrade from this level
        "2"=> 900000,
        "3"=> 1600000,
        "4"=> 2400000,
        "5"=> 3300000,
        "6"=> 4400000,
        "7"=> 8000000,
        "8"=> 10000000,
        "9"=> 13000000,
        "10"=> 13000000,
        "11"=> 15000000,
    );


    public function __construct() {
        parent::__construct();
        $this->_di->set('user_lib', function(){
            return new UserLib();
        }, true);
        $this->_di->set('battle_lib', function(){
            return new BattleLib();
        }, true);
        $this->_di->set('mail_lib', function(){
            return new MailLib();
        }, true);
        $this->_di->set('guild_lib', function(){
            return new GuildLib();
        }, true);
    }

    public function upgradeMission($role_id) {
        syslog(LOG_DEBUG, "guild mission add exp ($role_id)");
        $rds = $this->_di->getShared('redis');
        $glib = $this->_di->getShared('guild_lib');

        // check operation permission
        $ginfo = $glib->status($role_id);
        if (!isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
            return array('code'=>403, 'msg'=>'you does not belong to any guild');
        }   
        if ($ginfo[GuildLib::$STATUS_FIELD_GRADE] > GuildLib::$MEMBER_TYPE_FUHUIZHANG) {
            syslog(LOG_ERR, "suspend guild upgrade operation for lower title");
            return array('code'=>403, 'msg'=>'operation not allowed');
        }
        $gid = $ginfo[GuildLib::$STATUS_FIELD_GID];

        // fetch current level
        $key_group = sprintf(self::$GUILD_KEY, $gid);

        do {
            $group = $rds->hgetall($key_group);
            if (isset($group['level'])) {
                $current_level = $group['level'];
            } else {
                $current_level = 1;
            }

            // deduct cost
            $cost = self::$UPGRADE_COST[$current_level];
            $remain = $glib->consumeGuildFund($role_id, $cost);
            syslog(LOG_DEBUG, "guild mission upgrade consume $cost, remain $remain");
            if ($remain === false) {
                syslog(LOG_ERR, "fail to consume guild fund to upgrade mission");
                return array('code'=> 403, 'msg'=> 'fail to consume fund');
            }

            if ($current_level == 1) {
                $r = $rds->hsetnx($key_group, 'level', 2);
                if (!$r) {
                    syslog(LOG_NOTICE, "current guild mission upgrade detected($key_group)");
                    // another process already set this value, retry
                    continue;
                }
                $lvl = 2;
            } else {
                $lvl = $rds->hincrBy($key_group, 'level', 1);
            }
            break;
        } while(true);

        return array('code'=>200, 'level'=> $lvl, 'guild_total_money'=> $remain);
    }


    /* summon or get the current boss info */
    public function summon($gid, $role_id, $boss_id) {
        syslog(LOG_DEBUG, "GuildMission summon($gid, $role_id, $boss_id)");
        /*
         * query current boss, create if absent or dead
         * TODO: check requirements and permission
         */
        $code = <<<EOF
    local group_id, boss_id, summoner, boss_hp, ts = ARGV[1], ARGV[2], ARGV[3], ARGV[4], ARGV[5]
    local key_group = 'guild:'..group_id
    local groupinfo=redis.call('hgetall', key_group)
    local getprop = function(props, prop)
        for i=1, #props,2 do
            if props[i]==prop then
                return props[i+1]
            end
        end
        return nil
    end
    --[[
    if #groupinfo == 0 then
        return 'guild not found'
    end
    ]]
    -- local boss_uid = getprop(groupinfo, 'boss_uid')
    -- find alive bosses
    local boss_uid
    local old_boss_uid
    for i=1, #groupinfo, 2 do
        if string.sub(groupinfo[i],1,5) == 'boss:' then
            if tonumber(groupinfo[i+1]) > 0 then
                boss_uid = tonumber(groupinfo[i+1])
                break
            end
            --if true then return string.sub(groupinfo[i], 6) end
            if string.sub(groupinfo[i], 6) == boss_id then
                old_boss_uid = -tonumber(groupinfo[i+1])
            end
        end
    end
    --if true then return old_boss_uid or 'AAA' end
    if boss_uid then
        -- exist another alive boss, return it
        local key_boss = 'gboss:'..group_id..':'..boss_uid
        local result_boss = redis.call('hgetall', key_boss)
        local hp = getprop(result_boss, 'hp')
        if hp and tonumber(hp)>0 then
            return result_boss
        end
    end

    -- detach the dead boss
    if old_boss_uid then
        local key_boss = 'gboss:'..group_id..':'..old_boss_uid
        redis.call('expire', key_boss, 3600)
    end

    boss_uid = redis.call("hincrby", key_group, 'boss_uid_gen', 1)
    redis.call('hset', key_group, 'boss:'..boss_id, boss_uid)
    local key_boss = 'gboss:'..group_id..':'..boss_uid
    redis.call('hmset', key_boss, 'boss_uid', boss_uid, 'boss_id', boss_id, 'hp', boss_hp, 'birth_time', ts, 'summoner', summoner)
    return  {'boss_uid', boss_uid, 'boss_id', boss_id, 'hp', boss_hp, 'birth_time', ts, 'summoner', summoner}
EOF;
        $gm_cfg = self::getGameConfig('guild_boss');
        if (!isset($gm_cfg[$boss_id])) {
            syslog(LOG_ERR, print_r($gm_cfg, true));
            return array('code'=>404, 'msg'=>'boss not exists');
        }
        $boss_cfg = $gm_cfg[$boss_id];

        $glib = $this->_di->getShared('guild_lib');
        // check operation permission
        $ginfo = $glib->status($role_id);
        if (!isset($ginfo[GuildLib::$STATUS_FIELD_GID])) {
            return array('code'=>403, 'msg'=>'you does not belong to any guild');
        }
        if ($ginfo[GuildLib::$STATUS_FIELD_GRADE] > GuildLib::$MEMBER_TYPE_FUHUIZHANG) {
            syslog(LOG_ERR, "suspend guild upgrade operation for lower title");
            return array('code'=>403, 'msg'=>'operation not allowed');
        }
        // deduct cost
        $remain = $glib->consumeGuildFund($role_id, $boss_cfg['summon_cost']);
        syslog(LOG_DEBUG, "consume $boss_cfg[summon_cost], remain $remain");
        if ($remain===false) {
            syslog(LOG_DEBUG, "lack money or not authroized to summon boss");
            return array('code'=>403, 'msg'=>'insufficient moneny or unauthorized for summon');
        }

        $rds = $this->_di->getShared('redis');
        $hp = $boss_cfg['hp'];
        $boss = $rds->eval($code, array($gid, $boss_id, $role_id, $hp, time()), 0);
        $res = array('code'=> 200);
        if (is_string($boss)) {
            $res['code'] = 400;
            $res['msg'] = $boss;
        } else if ($boss==false) {
            $res['code'] = 500;
            $res['msg'] = 'fail to summon boss';
        } else {
            $res['boss'] = self::AssocLuaTable($boss);
            $res['guild_total_money'] = $remain;
        }

        return $res;
    }

    public function query($gid) {
        $rds = $this->_di->getShared('redis');
        $key_group = sprintf(self::$GUILD_KEY, $gid);
        $group = $rds->hgetall($key_group);
        $target_key_len = strlen('boss:');
        $bosses = array();
        foreach ($group as $k=>$v) {
            if (strncmp($k, 'boss:', $target_key_len)==0) {
                $boss_id = substr($k, $target_key_len);
                if ($v<0) {
                    $v = -$v;
                }
                $key_boss = sprintf(self::$GBOSS_KEY, $gid, $v);
                $boss = $rds->hgetall($key_boss);
                $bosses[$boss_id] = $boss;
            }
        }
        if (isset($group['level'])) {
            $level = $group['level'];
        } else {
            $level = 1;
        }
        return array('level'=>$level, 'bosses'=>$bosses);
    }

    public function attack($role_id, $gid, $boss_uid, $paid) {
        syslog(LOG_DEBUG, "gboss attack($role_id, $gid, $boss_uid, $paid)");
        /*
         * 1. check role, group, boss relation
         * 2. check boss presence or health point
         * 3. check & deduct cost
         * 4. return boss info
         */
        $rds = $this->_di->getShared('redis');
        $key_group = sprintf(self::$GUILD_KEY, $gid);
        $key_boss = sprintf(self::$GBOSS_KEY, $gid, $boss_uid);
        $boss = $rds->hgetall($key_boss);
        if (empty($boss)) {
            syslog(LOG_ERR, "boss not found when attack($role_id, $gid, $boss_uid)");
            return array('code'=> 404, 'msg'=> 'boss not found');
        }
        if ($boss['hp']<=0) {
            syslog(LOG_INFO, "boss is dead when attack($role_id, $gid, $boss_uid)");
            return array('code'=> 302, 'msg'=> 'boss is dead');
        }
        $boss_id = $boss['boss_id'];
        $saved_boss_uid = $rds->hget($key_group, 'boss:'.$boss_id);
        if ($saved_boss_uid != $boss_uid) {
            syslog(LOG_ERR, "gboss attack($role_id, $gid, $boss_uid), boss_uid not match $saved_boss_uid");
            return array('code'=> 400, 'msg'=>'boss uid not in current guild');
        }

        $config = self::getGameConfig('guild_boss');
        $cfgboss = $config[$boss['boss_id']];
        $now = time();
        if ($paid) {
            // deduct cost
            $user_lib = $this->_di->getShared('user_lib');
            $challenge_cost = $cfgboss['challenge_cost'];
            $remain = $user_lib->consumeFieldAsync($role_id, UserLib::$USER_PROF_FIELD_GOLD, $challenge_cost);
            if ($remain === false) {
                return array('code'=> 400, 'msg'=>'gold insufficient');
            }
        } else {
            if (isset($boss['lfat:'.$role_id])) {
                // check last attack time
                $challenge_interval = $cfgboss['challenge_interval'];
                $last_attack_time = $boss['lfat:'.$role_id];
                syslog(LOG_DEBUG, "check last attack time $last_attack_time + $challenge_interval vs $now");
                if (($last_attack_time + $challenge_interval) > $now) {
                    syslog(LOG_INFO, "can not free challenge guild boss until $last_attack_time+$challenge_interval vs $now");
                    return array('code'=> 403, 'msg'=> 'cannot challenge free at this moment');
                }
            }
            // set last free attack time
            $boss['lfat:'.$role_id] = $now;
            $rds->hset($key_boss, 'lfat:'.$role_id, $now);
        }

        $battle_lib = $this->_di->getShared('battle_lib');
        $battle_type = \Cap\Libraries\BattleLib::$BATTLE_TYPE_GUILD_BOSS;
        $battle_data = array('gid'=>$gid);
        $battle_id = $battle_lib->prepareBattle($role_id, $boss_uid, $battle_data, $battle_type, $rds);
        $res = array('code'=> 200, 'battle_id'=>$battle_id, 'boss'=>$boss);
        if (isset($remain)) {
            $res['gold'] = $remain;
        }
        return $res;
    }

    public function commit($role_id, $battle_id, $damage) {
        syslog(LOG_DEBUG, "gboss commit($role_id, $battle_id, $damage)");
        $rds = $this->_di->getShared('redis');
        $battle_lib = $this->_di->getShared('battle_lib');
        $battle_type = \Cap\Libraries\BattleLib::$BATTLE_TYPE_GUILD_BOSS;
        $battle_info = $battle_lib->commitBattle($role_id, $battle_id, $battle_type, 0, array(), $rds);
        if ($battle_info===false) {
            syslog(LOG_ERR, "group battle commit battle commit failed ($role_id, $battle_id)");
            return array('code'=> 400, 'msg'=> 'battle_id not exists or exipred or invalid');
        }
        $boss_uid = $battle_info['target'];
        $gid = $battle_info['gid'];
        syslog(LOG_DEBUG, "gboss damage $damage to $gid:$boss_uid by $role_id");
        $key_boss = sprintf(self::$GBOSS_KEY, $gid, $boss_uid);
        $hp = $rds->hincrBy($key_boss, 'hp', -$damage);
        if ($hp <= -$damage) {
            // already dead before this commit
            syslog(LOG_DEBUG, "gboss commit($role_id, $battle_id, $damage) -- already dead");
            $hp = $rds->hincrBy($key_boss, 'hp', $damage);
            $boss = $rds->hgetall($key_boss);
            //$res = array('code'=> 201, 'msg'=> 'already dead');
            $res = array('code'=> 200, 'boss'=>$boss);
        } else if ($hp <= 0) {
            // died at this commit
            $damage = $hp + $damage;        // strip overflow damage
            syslog(LOG_DEBUG, "gboss commit($role_id, $battle_id, $damage) -- final kill");
            $rds->hincrBy($key_boss, 'dmg:'.$role_id, $damage);

            // boss deadth actions
            //$rds->expire($key_boss, self::$DEAD_BOSS_EXPIRE);
            $key_group = sprintf(self::$GUILD_KEY, $gid);
            $boss = $rds->hgetall($key_boss);
            $rds->hset($key_group, 'boss:'.$boss['boss_id'], -$boss_uid);  // indicates dead 
            $this->bossDeath($boss);

            $boss = $rds->hgetall($key_boss);
            $res = array('code'=> 200, 'boss'=>$boss);
        } else {
            // still alive
            $rds->hincrBy($key_boss, 'dmg:'.$role_id, $damage);
            $boss = $rds->hgetall($key_boss);
            $res = array('code'=> 200, 'boss'=>$boss);
        }
        return $res;
    }

    /*
     * boss dead, give drops
     */
    public function bossDeath($boss) {
        $gm_cfg = self::getGameConfig('guild_boss');
        $boss_cfg = $gm_cfg[$boss['boss_id']];
        $dmg_key_len = strlen('dmg:');
        $damage_offsets = array();
        $total_dmg = 0;
        $top_dmg = 0;
        $top_dmg_uids = array();
        $result = array();
        $drops = array_values($boss_cfg['drops']);
        foreach ($boss as $k=>$v) {
            if (strncmp($k, 'dmg:', $dmg_key_len)==0) {
                $uid = intval(substr($k, $dmg_key_len));
                $total_dmg += $v;
                $damage_offsets[$total_dmg] = $uid;
                syslog(LOG_DEBUG, "$uid cause $v damage");
                $result[$uid] = $drops;
                if ($top_dmg < $v) {
                    $top_dmg = $v;
                    $top_dmg_uids = array($uid);
                } else if ($top_dmg == $v) {
                    $top_dmg_uids []= $uid;
                }
            }
        }
        if ($total_dmg != $boss_cfg['hp']) {
            syslog(LOG_ERR, "damage not equal to boss hp, some error must happened");
        }
        // random shared drop to users
        $shared_drops = $boss_cfg['shared_drops'];
        ksort($damage_offsets, SORT_NUMERIC);
        foreach ($shared_drops as $item) {
            for ($c=0; $c<$item['count']; $c++) {
                $factor = rand(1, $total_dmg);
                foreach ($damage_offsets as $dmg=>$uid) {
                    if ($factor <= $dmg) {
                        break;
                    }
                }
                $result[$uid][] = $item;
                syslog(LOG_DEBUG, "gboss drop item $item[item_id] to $uid");
            }
        }

        $mail_lib = $this->_di->getShared('mail_lib');
        foreach ($result as $uid=>$items) {
            // group items by item_id and sub_id
            $hitem = array();
            foreach ($items as $item) {
                $ikey = $item['item_id'].":".$item['sub_id'];
                if (!isset($hitem[$ikey])) {
                    $hitem[$ikey] = array('item_id'=>$item['item_id'], 'sub_id'=>$item['sub_id'], 'count'=>1);
                } else {
                    $hitem[$ikey]['count']++;
                }
            }
            $text = "公会BOSS击杀奖励\n恭喜所有成员，通过大家的不懈努力成功的将$boss_cfg[name]杀死，并且获得了它的所有宝藏。系统根据伤害排名，将宝藏公平的分配给所有参与本轮boss战的成员们！大家记得领取奖励哦！";
            $mail_lib->sendMail(0, array($uid), $text, array_values($hitem), "系统管理员");
        }

        // top damage award
        $top_drops = array_values($boss_cfg['top_drops']);
        syslog(LOG_DEBUG, "give top drops to top damage users ".implode(',', $top_dmg_uids));
        foreach ($top_dmg_uids as $uid) {
            $text = "公会BOSS最高伤害奖励\n公会boss$boss_cfg[name]刚刚被击杀了，你被评为最高伤害输出者，获得如下奖励:";
            $mail_lib->sendMail(0, array($uid), $text, array_values($top_drops), "系统管理员");
        }
        
    }

    /*
     * convert number indexed(even index indicate key) table to associate table
     */
    public static function AssocLuaTable($numeric_index_table) {
        $arr = array();
        $len = count($numeric_index_table);
        for ($i=0;$i<$len;$i+=2) {
            $arr[$numeric_index_table[$i]] = $numeric_index_table[$i+1];
        }
        return $arr;
    }

    public function releaseMission($gid) {
        syslog(LOG_DEBUG, "release guild mission $gid");
        $rds = $this->_di->getShared('redis');
        $key_group = sprintf(self::$GUILD_KEY, $gid);
        $group = $rds->hgetall($key_group);
        $target_key_len = strlen('boss:');
        $bosses = array();
        foreach ($group as $k=>$v) {
            if (strncmp($k, 'boss:', $target_key_len)==0) {
                $boss_id = substr($k, $target_key_len);
                if ($v<0) {
                    $v = -$v;
                }
                $key_boss = sprintf(self::$GBOSS_KEY, $gid, $v);
                syslog(LOG_DEBUG, "expire boss $key_boss");
                $rds->expire($key_boss, self::$DEAD_BOSS_EXPIRE);
            }
        }
        $rds->expire($key_group, self::$DEAD_BOSS_EXPIRE);
    }

}

// end of file
