
-- gen gacha raffle

local CfgCheck = require('cfg_check')

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local server_outname = 'raffle_set.json'

local rule1 = {
    sheet = "Sheet1",
    index = {},
    table = {["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count", ["weight"]="weight"}
}

local rule2 = {
    sheet = "Sheet2",
    index = {},
    table = {["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count", ["weight"]="weight"}
}

local rule3 = {
    sheet = "Sheet3",
    index = {},
    table = {["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count", ["weight"]="weight"}
}

local rule4 = {
    sheet = "Sheet4",
    index = {},
    table = {["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count", ["weight"]="weight"}
}

local rule5 = {
    sheet = "Sheet5",
    index = {},
    table = {["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count", ["weight"]="weight"}
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

local rawdata1 = excel.process(doc, rule1)
local rawdata2 = excel.process(doc, rule2)
local rawdata3 = excel.process(doc, rule3)
local rawdata4 = excel.process(doc, rule4)
local rawdata5 = excel.process(doc, rule5)

CfgCheck.checkRuleOrExit(rawdata1, rule1, "gacha 1")
CfgCheck.checkRuleOrExit(rawdata2, rule2, "gacha 2")
CfgCheck.checkRuleOrExit(rawdata3, rule3, "gacha 3")
CfgCheck.checkRuleOrExit(rawdata4, rule4, "gacha 4")
CfgCheck.checkRuleOrExit(rawdata5, rule5, "gacha 5")

function generate_server_config(...)
    local arg = {...}
    local cfg = {}
    local w = 1
    
    for i=1, #arg do
        rawdata = arg[i]
        cfg[i] = {}
        for j=1, #rawdata do
            table.insert(cfg[i], rawdata[j])
        end
    end

    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("written gacha item set server config to "..server_outname)
    outf:close()
end

generate_server_config(rawdata1, rawdata2, rawdata3, rawdata4, rawdata5)


