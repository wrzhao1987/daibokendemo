local CfgCheck = require('cfg_check')

if (not arg[1] or not arg[2] or not arg[3]) then
    print("usage: lua "..arg[0].." srcfile_basic.xml srcfile_level.xml srcfile_phase.xml")
    os.exit(0)
end

local srcfile_basic = arg[1]
local srcfile_level = arg[2]
local srcfile_phase = arg[3]
local server_outname_1 = 'hero_basic.json'
local server_outname_2 = 'hero_level.json'
local server_outname_3 = 'hero_phase.json'
local client_outname = 'Card.lua'

local career_type = {
    ["剑"] = 1,
    ["枪"] = 2,
    ["盾"] = 5,
    ["魔"] = 4,
    ["医"] = 3,
}

local rule_basic = {
    sheet = "Sheet1",
    index = {"角色ID"},
    table = {["名称"]="name", ["职业"]="career", ["星级"]="star", ["是否飞在空中"]="flying", ["攻击类型"]="atk_mode", ["攻击范围"]="atk_range", ["子弹类型"]="atk_bltp",["移动速度"]="spd", ["攻击怒气"]="atk_angry", ["防御怒气"]="def_angry", ["描述"]="desc", ["合成所需灵魂石"]="soul", ["1次突破灵魂石"]="bthrough_soul_1", ["2次突破灵魂石"]="bthrough_soul_2", ["3次突破灵魂石"]="bthrough_soul_3"},
    filter = function(key, value)
        if (key=="career") then
            if (not career_type[value]) then
                print("unknown type ["..value.."]")
                os.exit(1)
            end
            return career_type[value]
        end
    end
}

local rule_level = {
    sheet = "Sheet1",
    index = {"角色ID", "等级"},
    table = {["delta_atk"]="delta_atk", ["delta_def"]="delta_def", ["delta_hp"]="delta_hp", ["delta_potential"]="delta_potential", ["卡牌升级经验（总）"]="exp", ["卡牌科技经验"]="tech_exp", ["speed"]="speed"},
    filter = function(key, value)
    end
}

local rule_phase = {
    sheet = "Sheet1",
    index = {"id", "突破阶段"},
    table = {["atk"]="atk", ["def"]="def", ["hp"]="hp", ["突破潜能点"]="potential"},
}

local excel = require('excel.excel')

local doc_basic,err = excel.read(srcfile_basic)
if (err) then
    print(err)
    os.exit(1)
end

local doc_level,err = excel.read(srcfile_level)
if (err) then
    print(err)
    os.exit(1)
end

local doc_phase,err = excel.read(srcfile_phase)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_basic = excel.process(doc_basic, rule_basic)
local rawdata_level = excel.process(doc_level, rule_level)
local rawdata_phase = excel.process(doc_phase, rule_phase)

CfgCheck.checkRuleOrExit(rawdata_basic, rule_basic, "card rule basic")
CfgCheck.checkRuleOrExit(rawdata_level, rule_level, "card level basic")
CfgCheck.checkRuleOrExit(rawdata_phase, rule_phase, "card phase basic")


--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_level, ""))
--print(excel.save(rawdata_phase, ""))
--os.exit(0)

function generate_client_config(rawdata_basic, rawdata_level, rawdata_phase)
    cfg = {}
    -- basic
    for id,tdata in pairs(rawdata_basic) do
        cfg[id] = {}
        cfg[id]['star'] = tdata['star']
        cfg[id]['career'] = tdata['career']
        cfg[id]['flying'] = tdata['flying']
        cfg[id]['model_id'] = id
        cfg[id]['name'] = tdata['name']
        cfg[id]['desc'] = tdata['desc']
        cfg[id]['atk_spd'] = rawdata_level[id][1]['speed']
        cfg[id]['atk_mode'] = tdata['atk_mode']
        cfg[id]['atk_range'] = tdata['atk_range']
        cfg[id]['atk_bltp'] = tdata['atk_bltp']
        cfg[id]['spd'] = tdata['spd']
        cfg[id]['skills'] = {4, 1, 1, 0}  -- TODO
        cfg[id]['atk_angry'] = tdata['atk_angry']
        cfg[id]['def_angry'] = tdata['def_angry']
        cfg[id]['soul'] = tdata['soul']
        cfg[id]['bthrough_soul'] = {tdata['bthrough_soul_1'], tdata['bthrough_soul_2'], tdata['bthrough_soul_3']}
    end
    -- level
    for id,tdata in pairs(rawdata_level) do
        delta_atks = {}
        delta_defs = {}
        delta_hps = {}
        exps = {}
        tech_exps = {}
        cfg[id]['def'] = delta_defs
        cfg[id]['atk'] = delta_atks
        cfg[id]['hp'] = delta_hps
        cfg[id]['exp'] = exps
        cfg[id]['tech_exp'] = tech_exps

        for lvl=1,#tdata do
            delta_atks[lvl] = tdata[lvl]['delta_atk']
            delta_defs[lvl] = tdata[lvl]['delta_def']
            delta_hps[lvl] = tdata[lvl]['delta_hp']
            exps[lvl] = tdata[lvl]['exp']
            tech_exps[lvl] = tdata[lvl]['tech_exp']
        end
    end
    -- phase
    for id,tdata in pairs(rawdata_phase) do
        factor_atks = {tdata[0]['atk'], tdata[1]['atk'], tdata[2]['atk'], tdata[3]['atk'],}
        factor_defs = {tdata[0]['def'], tdata[1]['def'], tdata[2]['def'], tdata[3]['def'],}
        factor_hps = {tdata[0]['hp'], tdata[1]['hp'], tdata[2]['hp'], tdata[3]['hp'],}
        cfg[id]['phase_def'] = factor_defs
        cfg[id]['phase_atk'] = factor_atks
        cfg[id]['phase_hp'] = factor_hps

    end
    local text = excel.save(cfg, 'Card')
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write card client config to "..client_outname)
end

-- id=>{level=>{xxx}}
function generate_server_config(rawdata_basic, rawdata_level, rawdata_phase)
    local json_fmt = require('json_fomatter')
    local text, outf
    cfg_basic = {}
    -- basic
    for id,tdata in pairs(rawdata_basic) do
        cfg_basic[id] = {['star']=tdata['star']}
        cfg_basic[id]['atk'] = rawdata_level[id][1]['delta_atk']
        cfg_basic[id]['def'] = rawdata_level[id][1]['delta_def']
        cfg_basic[id]['hp'] = rawdata_level[id][1]['delta_hp']
        cfg_basic[id]['atk_spd'] = rawdata_level[id][1]['speed']
    end
    text = json_fmt(cfg_basic, true)
    outf = io.open(server_outname_1, 'w')
    outf:write(text)
    print("write basic hero server config to "..server_outname_1)
    outf:close()

    -- level
    cfg_level = {}
    for id,tdata in pairs(rawdata_level) do
        cfg_level[id] = {}
        for lvl=1,#tdata do
            local temp = {}
            cfg_level[id][lvl] = temp
            temp['delta_atk'] = tdata[lvl]['delta_atk']
            temp['delta_def'] = tdata[lvl]['delta_def']
            temp['delta_hp'] = tdata[lvl]['delta_hp']
            temp['exp_limit'] = tdata[lvl]['exp']
            temp['tech_exp'] = tdata[lvl]['tech_exp']
            temp['delta_potential'] = tdata[lvl]['delta_potential']
        end
    end
    text = json_fmt(cfg_level, true)
    outf = io.open(server_outname_2, 'w')
    outf:write(text)
    print("write level hero server config to "..server_outname_2)
    outf:close()

    -- phase
    cfg_phase = {}
    for id,tdata in pairs(rawdata_phase) do
        cfg_phase[id] = {}
        for phase, pdata in pairs(tdata) do
            cfg_phase[id][phase] = {}
            cfg_phase[id][phase]['delta_atk'] = pdata['atk']
            cfg_phase[id][phase]['delta_def'] = pdata['def']
            cfg_phase[id][phase]['delta_hp'] = pdata['hp']
            cfg_phase[id][phase]['delta_potential'] = pdata['potential']
        end
        cfg_phase[id][0]['need_piece'] = rawdata_basic[id]['soul']
        cfg_phase[id][1]['need_piece'] = rawdata_basic[id]['bthrough_soul_1']
        cfg_phase[id][2]['need_piece'] = rawdata_basic[id]['bthrough_soul_2']
        cfg_phase[id][3]['need_piece'] = rawdata_basic[id]['bthrough_soul_3']
    end
    text = json_fmt(cfg_phase, true)
    outf = io.open(server_outname_3, 'w')
    outf:write(text)
    print("write phase hero server config to "..server_outname_3)
    outf:close()
end

generate_client_config(rawdata_basic, rawdata_level, rawdata_phase)
generate_server_config(rawdata_basic, rawdata_level, rawdata_phase)


