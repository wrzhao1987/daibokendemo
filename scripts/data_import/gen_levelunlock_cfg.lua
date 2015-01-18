
local CfgCheck = require('cfg_check')
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'LevelUnlock.lua'

local rule_basic = {
    sheet = "Sheet1",
    index = {"level"},
    table = {["unlock"]="unlock"},
}


local excel = require('excel.excel')

local doc, err = excel.read(srcfile)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_basic = excel.process(doc, rule_basic)

CfgCheck.checkRuleOrExit(rawdata_basic, rule_basic, "level unlock basic")

--print(excel.save(rawdata_basic, ""))
--os.exit(0)

function generate_client_config(rawdata)
    local text, outf
    local cfg = {}

    for level, data in pairs(rawdata) do
        cfg[level] = {data['unlock']}
    end

    text = excel.save(cfg, "Cfg")
    outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write client config to "..client_outname)
end
generate_client_config(rawdata_basic)


