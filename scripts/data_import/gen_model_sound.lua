local CfgCheck = require('cfg_check')

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local script_outname = 'ModelSound.lua'

local rule = {
    sheet = "Sheet1",
    index = {"id"},
    table = {["attack"]="attack",["die"]="die",["hit"]="hit",["skill"]="skill",["role"]="role"}
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

CfgCheck.checkRuleOrExit(rawdata, rule, "model sound rule")

--print(excel.save(rawdata, ""))

function generate_client_config(rawdata)
    cfg = {}
    for id,data in pairs(rawdata) do
        cfg[id] = {
            attack = data.attack,
            die = data.die,
            hit = data.hit,
            skill = data.skill,
            role = data.role,
        }
    end
    local text = excel.save(cfg, 'Cfg')
    local outf = io.open(script_outname, 'w')
    outf:write(text)
    outf:close()
    print("write sound client config to "..script_outname)
end

generate_client_config(rawdata)


