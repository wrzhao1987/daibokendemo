local CfgCheck = require('cfg_check')

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local script_outname = 'SkillActive.lua'
local script_outname_server = 'skill_1.json'

local rule_basic = {
    sheet = "Sheet1",
    index = {"id"},
    table = {
        ["name"]="name", ["type"]="type", ["range"]="range", 
        ["range_value"]="range_value", ["bullet"]="bullet", 
        ["description"]="desc", ["description2"]="desc2", ["description3"]="desc3", ["energy"]="energy"
    }
}

local rule_level = {
    sheet = "Sheet2",
    index = {"英雄id", "等级"},
    table = {["英雄id"]="id", ["等级"]="level", ["数值"]="val", ["update_cost"]="update_cost"}
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
            costs[level] = ldata['update_cost']
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
            range = tdata['range'],
            bullet = tdata['bullet'],
            name = tdata['name'],
            desc = tdata['desc'],
            desc2 = tdata['desc2'],
            desc3 = tdata['desc3'],
            range_value = {tdata['range_value']},
            energy = tdata['energy'],
            value = {},
            update_cost = {},
        }
    end
    for id, idata in pairs(rawdata_level) do
        local vals = cfg[id]['value']
        local costs = cfg[id]['update_cost']
        for level, ldata in pairs(idata) do
            vals[level] = ldata['val']
            costs[level] = ldata['update_cost']
        end
    end
    local text = excel.save(cfg, 'SkillActive')
    local outf = io.open(script_outname, 'w')
    outf:write(text)
    outf:close()
    print("write skill client config to "..script_outname)
end

generate_client_config(rawdata_basic, rawdata_level)
generate_server_config(rawdata_basic, rawdata_level)


