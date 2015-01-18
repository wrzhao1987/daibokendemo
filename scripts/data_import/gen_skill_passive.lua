local CfgCheck = require('cfg_check')

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local script_outname = 'SkillConjure.lua'
local script_outname_server = 'skill_2.json'

local rule_basic = {
    sheet = "Sheet1",
    index = {"id"},
    table = {
        ["技能名"]="name", ["type"]="type", ["desc1"]="desc", 
        ["desc2"]="desc2", ["desc3"]="desc3",
        ["变化对应字段"]="changeindex",
        ["数值是否百分比"]="percent",
    }
}

local rule_level = {
    sheet = "Sheet2",
    index = {"id", "等级"},
    table = {
        ["id"]="id", ["等级"]="level", ["rate"]="rate", 
        ["time"]="time", ["value"]="value", ["update_cost"]="cost"
    }
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

local rawdata_basic = excel.process(doc, rule_basic)
local rawdata_level = excel.process(doc, rule_level)

CfgCheck.checkRuleOrExit(rawdata_basic, rule_basic, "skill rule basic")
CfgCheck.checkRuleOrExit(rawdata_level, rule_level, "skill rule level")

--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_level, ""))

function generate_server_config(rawdata_basic, rawdata_level)
    local cfg = {}
    for id,tdata in pairs(rawdata_basic) do
        cfg[id] = {
            update_cost={}
        }
    end
    for id, idata in pairs(rawdata_level) do
        local costs = cfg[id]['update_cost']
        for level, ldata in pairs(idata) do
            costs[level] = ldata['cost']
        end
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg)
    local outf = io.open(script_outname_server, 'w')
    outf:write(text)
    outf:close()
    print("write skill server config to "..script_outname_server)
end

function generate_client_config(rawdata_basic, rawdata_level)
    local cfg = {}
    for id,tdata in pairs(rawdata_basic) do
        cfg[id] = {
            type = tdata['type'],
            name = tdata['name'],
            desc = tdata['desc'],
            desc2 = tdata['desc2'],
            desc3 = tdata['desc3'],
            changeindex = tdata['changeindex'],
            percent = tdata['percent'],
            time = {},
            rate = {},
            value = {},
            update_cost = {},
        }
    end
    for id, idata in pairs(rawdata_level) do
        local vals = cfg[id]['value']
        local costs = cfg[id]['update_cost']
        local times = cfg[id]['time']
        local rates = cfg[id]['rate']
        for level, ldata in pairs(idata) do
            vals[level] = ldata['value']
            costs[level] = ldata['cost']
            times[level] = ldata['time']
            rates[level] = ldata['rate']*10000
        end
    end
    local text = excel.save(cfg, 'SkillConjure')
    local outf = io.open(script_outname, 'w')
    outf:write(text)
    outf:close()
    print("write tech client config to "..script_outname)
end

generate_client_config(rawdata_basic, rawdata_level)
generate_server_config(rawdata_basic, rawdata_level)


