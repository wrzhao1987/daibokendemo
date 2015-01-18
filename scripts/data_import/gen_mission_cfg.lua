
local CfgCheck = require('cfg_check')
if (not arg[1] or not arg[2] or not arg[3] or not arg[4] or not arg[5]) then
    print("usage: lua "..arg[0].." srcfile_basic.xml srcfile_drop.xml srcfile_npc.xml srcfile_boss.xml srcfile_wave.xml")
    os.exit(0)
end

local srcfile_basic = arg[1]
local srcfile_drop = arg[2]
local srcfile_npc = arg[3]
local srcfile_boss = arg[4]
local srcfile_wave = arg[5]
local server_outname = 'mission_map.json'
local client_outname_1 = 'Mission.lua'
local client_outname_2 = 'Npc.lua'
local client_outname_3 = 'Boss.lua'
local chapter_boundary = {10,20,30,40,50,60,70,80,90,100}

local career_type = { 
    ["剑"] = 1,
    ["枪"] = 2,
    ["盾"] = 5,
    ["魔"] = 4,
    ["医"] = 3,
}


local rule_basic = {
    sheet = "Sheet1",
    index = {"关卡id"},
    table = {["背景id"]="bg_id", ["关卡名"]="name", ["能量消耗"]="energy", ["账号经验"]="exp", ["卡牌经验"]="card_exp", ["索尼币"]="coin", ["每日通关次数"]="total_play", ["掉落显示"]="show_count", ["等级限制"]="required_level"},
}

local rule_drop = {
    sheet = "Sheet1",
    index = {"关卡id", "item_id", "sub_id"},
    table = {["item_id"]="item_id", ["sub_id"]="sub_id", ["ratio"]="ratio", ["count"]="count"},
}

local rule_npc = {
    sheet = "Sheet1",
    index = {"id"},
    table = {
        ["模型"]="md", ["等级"]="level", ["阶"]="skn", ["体积"]="sz", ["职业"]="car", 
        ["atk"]="atk", ["def"]="def", ["hp"]="hp", ["移动速度"]="spd", 
        ["攻击方式"]="atk_md", ["攻击速度"]="atk_spd", ["攻击范围"]="atk_scp", 
        ["子弹类型"]="atk_bltp", ["召唤技能类型"]="conjure_type", 
        ["触发概率"]="conjure_rate", ["持续时间"]="conjure_time", 
        ["数值"]="conjure_value" 
    },
    filter = function(key, value)
        if (key=="car") then
            if (not career_type[value]) then
                print("unknown type ["..value.."]")
                os.exit(1)
            end 
            return career_type[value]
        end
    end

}
local rule_boss = {
    sheet = "Sheet1",
    index = {"id"},
    table = {
        ["模型"]="md", ["等级"]="level", ["阶"]="skn", ["体积"]="sz", ["职业"]="car", ["atk"]="atk",
        ["def"]="def", ["hp"]="hp", ["移动速度"]="spd", ["攻击方式"]="atk_md", 
        ["攻击速度"]="atk_spd", ["攻击范围"]="atk_scp", ["子弹类型"]="atk_bltp", 
        ["攻击获得怒气"]="atk_anger", ["防御获得怒气"]="def_anger", 
        ["技能id"]="skill_id", ["type"]="skill_type", 
        ["range"]="mode", ["range_value"]="scope", ["bullet_type"]="skill_bullet_type",
        ["技能名称"]="skill_name", ["技能消耗"]="skill_cost", ["技能数值"]="skill_value",
    },
    filter = function(key, value)
        if (key=="car") then
            if (not career_type[value]) then
                print("unknown type ["..value.."]")
                os.exit(1)
            end 
            return career_type[value]
        end
    end
}

local rule_wave = {
    sheet = "Sheet1",
    index = {},
    table = {
        ["关卡id"]="sec_id", ["wave"]="wave", 
        ["出怪时间"]="time", ["出怪类型"]="type", 
        ["上路怪id"]="npc_1", ["中路怪id"]="npc_2", ["下路怪id"]="npc_3",
    }
}

local excel = require('excel.excel')

local doc_basic,err = excel.read(srcfile_basic)
if (err) then
    print(err)
    os.exit(1)
end

local doc_drop,err = excel.read(srcfile_drop)
if (err) then
    print(err)
    os.exit(1)
end

local doc_npc,err = excel.read(srcfile_npc)
if (err) then
    print(err)
    os.exit(1)
end

local doc_boss,err = excel.read(srcfile_boss)
if (err) then
    print(err)
    os.exit(1)
end

local doc_wave,err = excel.read(srcfile_wave)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_basic = excel.process(doc_basic, rule_basic)
local rawdata_drop = excel.process(doc_drop, rule_drop)
local rawdata_npc = excel.process(doc_npc, rule_npc)
local rawdata_boss = excel.process(doc_boss, rule_boss)
local rawdata_wave = excel.process(doc_wave, rule_wave)

CfgCheck.checkRuleOrExit(rawdata_basic, rule_basic, "mission basic")
CfgCheck.checkRuleOrExit(rawdata_drop, rule_drop, "mission drop")
CfgCheck.checkRuleOrExit(rawdata_npc, rule_npc, "mission npc")
CfgCheck.checkRuleOrExit(rawdata_boss, rule_boss, "mission boss")
CfgCheck.checkRuleOrExit(rawdata_wave, rule_wave, "mission wave")


--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_drop, ""))
--print(excel.save(rawdata_npc, ""))
--print(excel.save(rawdata_boss, ""))
--print(excel.save(rawdata_wave, ""))

function getSection(section_cfg, sec_id)
    local seq = sec_id
    local ch=1
    while ch <= #chapter_boundary do
        if (sec_id <= chapter_boundary[ch]) then
            break
        end
        seq = sec_id - chapter_boundary[ch]
        ch = ch + 1
    end
    if not section_cfg[ch] then section_cfg[ch]={} end
    if not section_cfg[ch][seq] then section_cfg[ch][seq]={} end
    return section_cfg[ch][seq]
end

function generate_client_config(rawdata_basic, rawdata_drop, rawdata_npc, rawdata_boss, rawdata_wave)
    local text, outf
    local section_cfg = {}
    local npc_cfg = {}
    local boss_cfg = {}
    -- basic
    for id,tdata in pairs(rawdata_basic) do
        sec = getSection(section_cfg, id)
        sec['id'] = id
        sec['bg_id'] = tdata['bg_id']
        sec['name'] = tdata['name']
        sec['energy'] = tdata['energy']
        sec['exp'] = tdata['exp']
        sec['card_exp'] = tdata['card_exp']
        sec['coin'] = tdata['coin']
        sec['total_play'] = tdata['total_play']
        sec['required_level'] = tdata['required_level']
        sec['show_count'] = tdata['show_count']
    end
    -- drop
    for id,tdata in pairs(rawdata_drop) do
        sec = getSection(section_cfg, id)
        if not sec then
            print("section "..id.." not configured, when config drop")
            os.exit(1)
        end
        local drops = {}
        for item_id,idata in pairs(tdata) do
            for sub_id,sdata in pairs(idata) do
                drops[#drops+1]={item_id=item_id, sub_id=sub_id}
            end
        end
        sec['drop'] = drops
    end
    -- npc
    for id,tdata in pairs(rawdata_npc) do
        npc = {}
        npc['md'] = tdata['md']
        npc['skn'] = tdata['skn']
        npc['sz'] = tdata['sz']
        npc['car'] = tdata['car']
        npc['atk'] = tdata['atk']
        npc['def'] = tdata['def']
        npc['hp'] = tdata['hp']
        npc['spd'] = tdata['spd']
        npc['atkpr'] = {md=tdata['atk_md'], spd=tdata['atk_spd'], scp=tdata['atk_scp'], bltp=tdata['atk_bltp']} 
        npc['conjure'] = {type=tdata['conjure_type'], rate=tdata['conjure_rate'], time=tdata['conjure_time'], value=tdata['conjure_value']}
        npc_cfg[id] = npc
    end
    -- boss
    for id,tdata in pairs(rawdata_boss) do
        boss = {}
        boss['md'] = tdata['md']
        boss['skn'] = tdata['skn']
        boss['sz'] = tdata['sz']
        boss['car'] = tdata['car']
        boss['atk'] = tdata['atk']
        boss['def'] = tdata['def']
        boss['hp'] = tdata['hp']
        boss['spd'] = tdata['spd']
        boss['atkpr'] = {md=tdata['atk_md'], spd=tdata['atk_spd'], scp=tdata['atk_scp'], bltp=tdata['atk_bltp']} 
        boss['drp'] = {energy={tdata['atk_anger'], tdata['def_anger']}}
        boss['skl'] = {
            id=tdata['skill_id'],
            type=tdata['skill_type'],
            value=tdata['skill_value'],
            mode=tdata['mode'],
            scope=tdata['scope'],
            bulletType=tdata['skill_bullet_type'],
            energy=tdata['skill_cost'],
        }
        boss['spd'] = tdata['spd']
        boss_cfg['b'..id] = boss
    end
    -- wave
    for seq,tdata in pairs(rawdata_wave) do
        sec = getSection(section_cfg, tdata['sec_id'])
        if (not sec) then
            print("section "..tdata['sec_id'].." not configured for wave")
            os.exit(1)
        end
        if not sec['wave'] then
            sec['wave'] = {}
        end
        local waves = sec['wave']
        local wave = tdata['wave']
        if not waves[wave] then
            waves[wave] = {}
        end
        local index = #waves[wave]+1
        if tdata['type'] == 1 then
            waves[wave][index] = {time=tdata['time'], npcs={tdata['npc_1'], tdata['npc_2'], tdata['npc_3']}}
        else
            waves[wave][index] = {time=tdata['time'], boss={tdata['npc_1'], tdata['npc_2'], tdata['npc_3']}}
        end
    end
    print("write mission client config to "..client_outname_1)
    text = excel.save(section_cfg, 'Mission')
    outf = io.open(client_outname_1, 'w')
    outf:write(text)
    outf:close()

    print("write Npc client config to "..client_outname_2)
    text = excel.save(npc_cfg, 'Npc')
    outf = io.open(client_outname_2, 'w')
    outf:write(text)
    outf:close()

    print("write Boss client config to "..client_outname_3)
    text = excel.save(boss_cfg, 'Boss')
    outf = io.open(client_outname_3, 'w')
    outf:write(text)
    outf:close()
end

function generate_server_config(rawdata_basic, rawdata_drop, rawdata_npc, rawdata_boss, rawdata_wave)
    local json_fmt = require('json_fomatter')
    local text, outf
    local sections = {}
    local section_cfg = {sections=sections, chapter_boundary={}}
    -- basic
    for id,tdata in pairs(rawdata_basic) do
        sec = {['id']=id}
        sec['energy_cost'] = tdata['energy']
        sec['role_exp'] = tdata['exp']
        sec['card_exp'] = tdata['card_exp']
        sec['coin'] = tdata['coin']
        sec['daily_pass_limit'] = tdata['total_play']
        sec['required_level'] = tdata['required_level']
        section_cfg['sections'][id] = sec
    end
    -- drop
    for id,tdata in pairs(rawdata_drop) do
        sec = section_cfg['sections'][id]
        if (not sec) then
            print("section "..id.." not configured")
            os.exit(1)
        end
        local drops = {}
        for item_id,idata in pairs(tdata) do
            for sub_id,sdata in pairs(idata) do
                drops[#drops+1]={item_id=item_id, sub_id=sub_id, chance=sdata['ratio']/1000}
            end
        end
        sec['drops'] = drops
    end
    text = json_fmt(section_cfg, true)
    outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write mission server config to "..server_outname)
    outf:close()
end

generate_client_config(rawdata_basic, rawdata_drop, rawdata_npc, rawdata_boss, rawdata_wave)
generate_server_config(rawdata_basic, rawdata_drop, rawdata_npc, rawdata_boss, rawdata_wave)


