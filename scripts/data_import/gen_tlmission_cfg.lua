
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile_mission.xml")
    os.exit(0)
end

local srcfile_mission = arg[1]
local server_outname = 'mission_rabbit.json'
local client_outname_1 = 'MissionRabbit.lua'
local chapter_boundary = {10,20,30,40,50,60,70,80,90,100}

local career_type = { 
    ["剑"] = 1,
    ["枪"] = 2,
    ["盾"] = 5,
    ["魔"] = 4,
    ["医"] = 3,
}

local rule_meta = {
    sheet = "Sheet1",
    index = {"mission_id"},
    table = {["name"]="name", ["daily_pass_limit"]="daily_pass_limit", ["open_day"]="open_wday", 
        ["item_id_1"]="item_id_1", ["sub_id_1"]="sub_id_1", 
        ["item_id_2"]="item_id_2", ["sub_id_2"]="sub_id_2", 
        ["item_id_3"]="item_id_3", ["sub_id_3"]="sub_id_3",
    },
}

local rule_basic = {
    sheet = "Sheet2",
    index = {"mission_id", "section_id"},
    table = {["bg_id"]="bg_id", ["energy_cost"]="energy_cost", ["role_exp"]="role_exp", ["card_exp"]="card_exp",  ["required_level"]="required_level"},
}

local rule_drop = {
    sheet = "Sheet3",
    index = {},
    table = {["mission_id"]="mission_id", ["section_id"]="section_id", ["item_id"]="item_id", ["sub_id"]="sub_id", ["chance"]="ratio"},
}

local rule_wave = {
    sheet = "Sheet4",
    index = {},
    table = {
        ["mission_id"]="mission_id", ["section_id"]="section_id", ["wave"]="wave", 
        ["出怪时间"]="time", ["出怪类型"]="type", 
        ["上路怪id"]="npc_1", ["中路怪id"]="npc_2", ["下路怪id"]="npc_3",
    }
}

local excel = require('excel.excel')

local doc_meta,err = excel.read(srcfile_mission)
if (err) then
    print(err)
    os.exit(1)
end

local doc_basic,err = excel.read(srcfile_mission)
if (err) then
    print(err)
    os.exit(1)
end

local doc_drop,err = excel.read(srcfile_mission)
if (err) then
    print(err)
    os.exit(1)
end

local doc_wave,err = excel.read(srcfile_mission)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_meta = excel.process(doc_meta, rule_meta)
local rawdata_basic = excel.process(doc_basic, rule_basic)
local rawdata_drop = excel.process(doc_drop, rule_drop)
local rawdata_wave = excel.process(doc_wave, rule_wave)


--print(excel.save(rawdata_meta, ""))
--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_drop, ""))
--print(excel.save(rawdata_wave, ""))
--os.exit(0)

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

function generate_client_config(rawdata_meta, rawdata_basic, rawdata_drop, rawdata_wave)
    local text, outf
    local missions = {}
    -- meta
    for mid, mdata in pairs(rawdata_meta) do
        missions[mid] = {
            name = mdata["name"],
            daily_pass_limit = mdata["daily_pass_limit"],
            open_wday = loadstring('return '..mdata["open_wday"])(),
            drops = {
            },
            sections = {
            },
        }
        if mdata["item_id_1"] and tonumber(mdata["item_id_1"])~= 0 then
            table.insert(missions[mid].drops, {item_id=mdata["item_id_1"], sub_id=mdata["sub_id_1"]})
        end
        if mdata["item_id_2"] and tonumber(mdata["item_id_2"])~= 0 then
            table.insert(missions[mid].drops, {item_id=mdata["item_id_2"], sub_id=mdata["sub_id_2"]})
        end
        if mdata["item_id_3"] and tonumber(mdata["item_id_3"])~= 0 then
            table.insert(missions[mid].drops, {item_id=mdata["item_id_3"], sub_id=mdata["sub_id_3"]})
        end
    end
    -- basic
    for mid,mdata in pairs(rawdata_basic) do
        mission = missions[mid]
        for sec_id,tdata in pairs(mdata) do
            local sec = {}
            mission['sections'][sec_id] = sec
            sec['id'] = sec_id
            sec['bg_id'] = tdata['bg_id']
            sec['energy_cost'] = tdata['energy_cost']
            sec['role_exp'] = tdata['role_exp']
            sec['card_exp'] = tdata['card_exp']
            sec['required_level'] = tdata['required_level']
            sec['drops'] = {}
            sec['wave'] = {}
        end
    end
    -- drop 
    for seq,drop_data in pairs(rawdata_drop) do
        mission = missions[drop_data['mission_id']]
        section = mission['sections'][drop_data['section_id']]
        table.insert(section.drops, {item_id=drop_data['item_id'], sub_id=drop_data['sub_id'], chance=drop_data['ratio']})
    end

    -- wave
    for seq,tdata in pairs(rawdata_wave) do
        mission = missions[tdata['mission_id']]
        sec = mission['sections'][tdata['section_id']]
        if (not sec) then
            print("section "..tdata['section_id'].." not configured for wave")
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
    for mid, mission in pairs(missions) do
        local outname = 'Mission'..mission['name']..".lua"
        print("write mission client config to "..outname)
        text = excel.save(mission, 'Mission')
        outf = io.open(outname, 'w')
        outf:write(text)
        outf:close()
    end

end

function generate_server_config(rawdata_meta, rawdata_basic, rawdata_drop, rawdata_wave)
    local json_fmt = require('json_fomatter')
    local text, outf
    local missions = {}
    -- meta
    for mid, mdata in pairs(rawdata_meta) do
        missions[mid] = {
            name = mdata["name"],
            daily_pass_limit = mdata["daily_pass_limit"],
            open_wday = loadstring('return '..mdata["open_wday"])(),
            drops = {
            },
            sections = {
            },
        }
        if mdata["item_id_1"] and tonumber(mdata["item_id_1"])~= 0 then
            table.insert(missions[mid].drops, {item_id=mdata["item_id_1"], sub_id=mdata["sub_id_1"]})
        end
        if mdata["item_id_2"] and tonumber(mdata["item_id_2"])~= 0 then
            table.insert(missions[mid].drops, {item_id=mdata["item_id_2"], sub_id=mdata["sub_id_2"]})
        end
        if mdata["item_id_3"] and tonumber(mdata["item_id_3"])~= 0 then
            table.insert(missions[mid].drops, {item_id=mdata["item_id_3"], sub_id=mdata["sub_id_3"]})
        end
    end
    -- basic
    for mid,mdata in pairs(rawdata_basic) do
        mission = missions[mid]
        for sec_id,tdata in pairs(mdata) do
            local sec = {}
            mission['sections'][sec_id] = sec
            sec['id'] = sec_id
            sec['bg_id'] = tdata['bg_id']
            sec['energy_cost'] = tdata['energy_cost']
            sec['role_exp'] = tdata['role_exp']
            sec['card_exp'] = tdata['card_exp']
            sec['required_level'] = tdata['required_level']
            sec['drops'] = {}
            sec['coin'] = 0
            sec['daily_pass_limit'] = mission.daily_pass_limit
        end
    end
    -- drop 
    for seq,drop_data in pairs(rawdata_drop) do
        mission = missions[drop_data['mission_id']]
        section = mission['sections'][drop_data['section_id']]
        table.insert(section.drops, {item_id=drop_data['item_id'], sub_id=drop_data['sub_id'], chance=drop_data['ratio']/1000})
    end

    for mid, mission in pairs(missions) do
        local outname = 'mission_'..string.lower(mission['name'])..".json"
        print("write mission server config to "..outname)
        text = json_fmt(mission, true)
        outf = io.open(outname, 'w')
        outf:write(text)
        outf:close()
    end
end

generate_client_config(rawdata_meta, rawdata_basic, rawdata_drop, rawdata_wave)
generate_server_config(rawdata_meta, rawdata_basic, rawdata_drop, rawdata_wave)


