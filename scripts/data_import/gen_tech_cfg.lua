
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local script_outname = 'Tech.lua'
local server_outname = 'tech.json'

local name = {
    [1] = "攻",
    [2] = "防",
    [3] = "血",
}
local mod_type = {
    [1] = "atk",
    [2] = "def",
    [3] = "hp",
}
local rname = {
    ["攻"] = 1,
    ["防"] = 2,
    ["血"] = 3,
}

local rule = {
    sheet = "Sheet1",
    index = {"科技名称", "等级"},
    table = {["科技名称"]="name", ["等级"]="level", ["开启条件（等级）"]="required_level", ["累积经验"]="exp_low", ["增加属性值_攻击"]="atk", ["增加属性值_防御"]="def", ["增加属性值_血量"]="hp"},
}

local excel = require('excel.excel')

local doc,err = excel.read(srcfile)

if (err) then
    print(err)
    os.exit(1)
end

if (not doc) then
    print("fail to get doc")
    os.exit(0)
end

local rawdata = excel.process(doc, rule)


print(excel.save(rawdata, ""))

function generate_client_config(rawdata)
    -- name = 'attack'
    -- required_levels = {1,2, ...}
    -- exps = {10,20,30,...}
    -- values = {2,4,6,...}
    cfg = {}
    for tname,tdata in pairs(rawdata) do
        tech_id = rname[tname]
        cfg[tech_id] = {}
        cfg[tech_id]['name'] = tname
        rlevels = {}
        values = {}
        exps = {}
        cfg[tech_id]['required_levels'] = rlevels
        cfg[tech_id]['values'] = values
        cfg[tech_id]['exps'] = exps
        local mod_field = mod_type[tech_id]
        rlevels[1] = tdata[1]['required_level']
        exps[1] = 0
        values[1] = 0
        -- level 0 == index 1
        for lvl=1, #tdata do
            local ldata = tdata[lvl]
            rlevels[lvl+1] = ldata['required_level']
            exps[lvl+1] = ldata['exp_low']
            values[lvl+1] = ldata[mod_field]
        end
    end
    local text = excel.save(cfg, 'Tech')
    local outf = io.open(script_outname, 'w')
    outf:write(text)
    outf:close()
    print("write tech client config to "..script_outname)
end

function generate_server_config(rawdata)
    cfg = {}
    for tname,tdata in pairs(rawdata) do
        tech_id = rname[tname]
        cfg[tech_id] = {}
        local tmp = cfg[tech_id]
        local level_cfg = {}
        local mod_field = mod_type[tech_id]
        cfg[tech_id]['mod_type'] = mod_field
        --level_cfg[0] = {mod_value=0, exp_limit=tdata[1]['exp_low'], required_level=20}
        -- [0~exp_limit_0) == level 0
        for lvl=0, #tdata-1 do
            local ldata = tdata[lvl]
            level_cfg[lvl] = {mod_value=ldata[mod_field], exp_limit=tdata[lvl+1]['exp_low'], required_level=ldata['required_level']}
        end
        lvl = #tdata
        level_cfg[lvl] = {mod_value=tdata[lvl][mod_field], exp_limit=tdata[lvl]['exp_low'], required_level=tdata[lvl]['required_level']}

        cfg[tech_id]['level_cfg'] = level_cfg
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write tech server config to "..server_outname)
    outf:close()
end

generate_client_config(rawdata)
generate_server_config(rawdata)


