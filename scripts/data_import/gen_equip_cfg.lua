
if (not arg[2]) then
    print("usage: lua "..arg[0].." srcfile.xml, srcfile_desc.xml")
    os.exit(0)
end

local srcfile, srcfile_desc = arg[1], arg[2]
local server_outname = 'equip.json'
local client_outname = 'Equip.lua'

local rmod_type = {
    ["武器"] = 1,
    ["护甲"] = 2,
    ["戒指"] = 3,
    ["项链"] = 4,
}
local type_desc = {
    [1] = "增加用户防御数值",
    [2] = "增加用户攻击数值",
    [3] = "增加用户生命数值",
}

local rule_desc = {
    sheet = "装备名称及id",
    index = {"编号"},
    table = {["类别"]="type", ["名称"]="name", ["星级"]="star", ["加持"]="mod", ["描述"]="desc"}
}

local rule = {
    sheet = "Sheet1",
    index = {"ID", "等级"},
    table = {["名称"]="name", ["等级"]="level", ["星级"]="star", ["部位"]="type", ["属性"]="val", ["强化花费"]="cost", ["折算科技经验"]="tech_exp", ["出售价格"]="price"},
    filter = function(key, value)
        if (key=="type") then
            if (not rmod_type[value]) then
                print("unknown type ["..value.."]")
                os.exit(1)
            end
            return rmod_type[value]
        end
    end
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

local doc_desc,err = excel.read(srcfile_desc)

if (err) then
    print(err)
    os.exit(1)
end

if (not doc_desc) then
    print("fail to get doc desc")
    os.exit(0)
end

local rawdata = excel.process(doc, rule)
local rawdata_desc = excel.process(doc_desc, rule_desc)


--print(excel.save(rawdata, ""))
--print(excel.save(rawdata_desc, ""))

function generate_client_config(rawdata, rawdata_desc)
    cfg = {}
    for id,tdata in pairs(rawdata) do
        cfg[id] = {}
        cfg[id]['name'] = tdata[1]['name']
        cfg[id]['type'] = tdata[1]['type']
        cfg[id]['star'] = tdata[1]['star']
        cfg[id]['desc'] = rawdata_desc[id]['desc']

        costs = {}
        values = {}
        tech_exps = {}
        prices = {}
        cfg[id]['value'] = values
        cfg[id]['cost'] = costs
        cfg[id]['exp'] = tech_exps
        cfg[id]['price'] = prices
        for lvl=1, #tdata do
            local ldata = tdata[lvl]
            costs[lvl] = ldata['cost']
            tech_exps[lvl] = ldata['tech_exp']
            values[lvl] = ldata['val']
            prices[lvl] = ldata['price']
        end
    end
    local text = excel.save(cfg, 'Equip')
    local client_outname = 'Equip.lua'
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write equip client config to "..client_outname)
end

-- id=>{level=>{xxx}}
function generate_server_config(rawdata)
    cfg = {}
    for id,tdata in pairs(rawdata) do
        cfg[id] = {}
        --cfg[id]['name'] = tdata[1]['name']
        cfg[id]['type'] = tdata[1]['type']
        cfg[id]['star'] = tdata[1]['star']

        costs = {}
        tech_exps = {}
        values = {}
        prices = {}
        cfg[id]['cost'] = costs
        cfg[id]['tech_exp'] = tech_exps
        cfg[id]['value'] = values
        cfg[id]['price'] = prices
        tech_exps = cfg[id]['tech_exp']
        for lvl=1, #tdata do
            local ldata = tdata[lvl]
            costs[lvl] = ldata['cost']
            tech_exps[lvl] = ldata['tech_exp']
            values[lvl] = ldata['val']
            prices[lvl] = ldata['price']
        end
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    --print(text)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write equip server config to "..server_outname)
    outf:close()
end

generate_client_config(rawdata, rawdata_desc)
generate_server_config(rawdata)


