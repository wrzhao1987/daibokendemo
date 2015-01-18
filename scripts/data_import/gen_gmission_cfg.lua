local CfgCheck = require('cfg_check')

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'GuildMission.lua'
local server_outname = 'guild_boss.json'

local drop_type_map = {
    [1] = "drops",
    [2] = "shared_drops",
    [3] = "top_drops",
}

local npc_type_map = {
    [1] = "npcs",
    [2] = "boss",
}

local rule_basic = {
    sheet = "Sheet1",
    index = {"BOSS_ID"},
    table = {
        ['血量'] = 'hp',
        ['需求召唤大厅等级'] = 'required_group_level',
        ['背景id'] = 'bg_id',
        ['BOSS模型'] = 'model_id',
        ['皮肤'] = 'skin',
        ['名称'] = 'name',
        ['挑战间隔'] = 'challenge_interval',
        ['加速花费'] = 'challenge_cost',
        ['召唤花费'] = 'summon_cost',
    },
}

local rule_wave = {
    sheet = "Sheet2",
    index = {},
    table = {
        ['关卡id'] = 'boss_id',
        ['wave'] = 'wave_id',
        ['出怪时间'] = 'time',
        ['出怪类型'] = 'type',
        ['上路怪id'] = 'npc_1',
        ['中路怪id'] = 'npc_2',
        ['下路怪id'] = 'npc_3',
    }
}


local rule_drop = {
    sheet = "Sheet3",
    index = {},
    table = {
        ['关卡id'] = 'boss_id',
        ['掉落类型'] = 'type',
        ['item_id'] = 'item_id',
        ['sub_id'] = 'sub_id',
        ['count'] = 'count',
    }
}

local excel = require('excel.excel')

local doc_basic,err = excel.read(srcfile)
if (err) then
    print(err)
    os.exit(1)
end

local doc_wave,err = excel.read(srcfile)
if (err) then
    print(err)
    os.exit(1)
end

local doc_drop,err = excel.read(srcfile)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_basic = excel.process(doc_basic, rule_basic)
local rawdata_wave = excel.process(doc_wave, rule_wave)
local rawdata_drop = excel.process(doc_drop, rule_drop)

CfgCheck.checkRuleOrExit(rawdata_basic, rule_basic, "guildmission rule basic")
CfgCheck.checkRuleOrExit(rawdata_wave, rule_wave, "guildmission rule wave")
CfgCheck.checkRuleOrExit(rawdata_drop, rule_drop, "guildmission rule drop")

--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_wave, ""))
--print(excel.save(rawdata_drop, ""))
--os.exit(0)

function generate_client_config(rawdata_basic, rawdata_wave, rawdata_drop)
    local json_fmt = require('json_fomatter')
    local text, outf
    local cfg = {
        min_title_for_summon=1,
        min_title_for_upgrade=2,
        upgrade_cost = {
            [1]= 600000,
            [2]= 900000,
            [3]= 1600000,
            [4]= 2400000,
            [5]= 3300000,
            [6]= 4400000,
            [7]= 8000000,
            [8]= 10000000,
            [9]= 13000000,
            [10]= 13000000,
            [11]= 15000000,
        },
        boss = {}
    }
    local scfg = {}

    local bosses = cfg.boss
    -- basic
    for boss_id,data in pairs(rawdata_basic) do
        bosses[boss_id] = {
            hp = data['hp'],
            required_group_level = data['required_group_level'],
            hp = data['hp'],
            bg_id = data['bg_id'],
            model_id = data['model_id'],
            skin = data['skin'],
            name = data['name'],
            challenge_interval = data['challenge_interval'],
            challenge_cost = data['challenge_cost'],
            summon_cost = data['summon_cost'],
            drops = {},
            shared_drops = {},
            top_drops = {},
            wave = {},
        }
        scfg[boss_id] = {
            hp = data['hp'],
            required_group_level = data['required_group_level'],
            hp = data['hp'],
            challenge_interval = data['challenge_interval'],
            challenge_cost = data['challenge_cost'],
            summon_cost = data['summon_cost'],
            drops = {},
            shared_drops = {},
            top_drops = {},
            name = data['name'],
        }
    end

    -- wave
    for i=1,#rawdata_wave do
        local data = rawdata_wave[i]
        local waves = bosses[data['boss_id']]['wave']
        waves[data['wave_id']] = waves[data['wave_id']] or {}
        table.insert(waves[data['wave_id']], {
            time = data['time'],
            [npc_type_map[data['type']]] = {
                [1] = data['npc_1'],
                [2] = data['npc_2'],
                [3] = data['npc_3'],
            },
        })
    end

    local count = function (tbl)
        local c = 0
        for k,v in pairs(tbl) do
            c = c+1
        end
        return c
    end

    -- drops
    for i=1, #rawdata_drop do
        local data = rawdata_drop[i]
        local field = drop_type_map[data['type']]
        local item = {
            item_id = data['item_id'],
            sub_id = data['sub_id'],
            count = data['count'],
        }
        table.insert(bosses[data['boss_id']][field], item)
        --table.insert(scfg[data['boss_id']][field], item)
        scfg[data['boss_id']][field][count(scfg[data['boss_id']][field])] = item
    end

    -- to server config
    print("write Npc server config to "..server_outname)
    text = json_fmt(scfg, true)
    outf = io.open(server_outname, 'w')
    outf:write(text)
    outf:close()

    -- to client config
    print("write Npc client config to "..client_outname)
    text = excel.save(cfg, 'Cfg')
    outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
end

generate_client_config(rawdata_basic, rawdata_wave, rawdata_drop)
