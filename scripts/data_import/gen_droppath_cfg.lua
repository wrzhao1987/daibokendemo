
local CfgCheck = require('cfg_check')
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile_mission.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'Drop.lua'

local rule_heropath = {
    sheet = "英雄掉落链接",
    index = {},
    table = {["英雄id"]="id", ["type"]="type", ["section"]="section"},
}

local rule_equippath = {
    sheet = "装备掉落链接",
    index = {},
    table = {["装备id"]="id", ["type"]="type", ["section"]="section"},
}


local excel = require('excel.excel')

local doc, err = excel.read(srcfile)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_heropath = excel.process(doc, rule_heropath)
local rawdata_equippath = excel.process(doc, rule_equippath)

CfgCheck.checkRuleOrExit(rawdata_heropath, rule_heropath, "hero path")
CfgCheck.checkRuleOrExit(rawdata_equippath, rule_equippath, "equip path")

--print(excel.save(rawdata_heropath, ""))
--print(excel.save(rawdata_equippath, ""))
--os.exit(0)

function generate_client_config(rawdata_path)
    local text, outf
    local cfg = {}

    for seq=1, #rawdata_path do
        local pdata = rawdata_path[seq]
        if not cfg[pdata['id']] then
            cfg[pdata['id']] = {}
        end
        local paths = cfg[pdata['id']]
        if pdata['type'] == 'atext' then
            paths['text'] = pdata['section']
        elseif pdata['type'] == 'text' then
            table.insert(paths, {type='text', text=pdata['section']})
        else
            table.insert(paths, {type=pdata['type'], section=pdata['section']})
        end
    end

    text = excel.save(cfg, "Cfg")
    outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write client config to "..client_outname)
end
client_outname="HeroDrop.lua"
generate_client_config(rawdata_heropath)
client_outname="EquipDrop.lua"
generate_client_config(rawdata_equippath)


