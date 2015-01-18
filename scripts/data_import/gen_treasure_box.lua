--
-- Created by IntelliJ IDEA.
-- User: martin
-- Date: 14-8-2
-- Time: 下午5:34
-- To change this template use File | Settings | File Templates.
--
if (not arg[1]) then
    print("usage: lua " ..arg[0].. "srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = "TreasureBox.lua"
local server_outname = "treasure_box.json"

local rule_server = {
    sheet = "Sheet2",
    index = {},
    table = {
        ["box_id"]  = "box_id",
        ["item_id"] = "item_id",
        ["sub_id"] = "sub_id",
        ["count"] = "count",
        ["chance"] = "chance",
    },
}

local rule_client = {
    sheet = "Sheet1",
    index = {"sub_id"},
    table = {
        ["name"] = "name",
        ["model_id"] = "model_id",
        ["key"] = "key",
		["value"] = "value",
		["detail"] = "detail",
    },
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

local rawdata_server = excel.process(doc, rule_server)
local rawdata_client = excel.process(doc, rule_client)

--print(excel.save(rawdata_server, ""))
--os.exit(0)

function generate_client_config(rawdata_client)
    local cfg = {}
    cfg[12] = {}
    for box_id, detail in pairs(rawdata_client) do
        cfg[12][box_id] = {
            name = detail['name'],
            value = detail['value'],
            model_id = detail['model_id'],
            detail = detail['detail'],
            key = detail['key']
        }
    end
    local text = excel.save(cfg, 'TreasureBox')
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write task client config to "..client_outname)
end

function generate_server_config(rawdata_server, rawdata_client)
    local cfg = {}
    for id, data in pairs(rawdata_server) do
        local box_id = data['box_id']
        if cfg[box_id] == nil then
            cfg[box_id] = {}
        end
        if cfg[box_id]['content'] == nil then
            cfg[box_id]['content'] = {}
        end
        table.insert(cfg[box_id]['content'], {
            item_id = data['item_id'],
            sub_id  = data['sub_id'],
            count   = data['count'],
            chance  = data['chance'],
        })
    end

    for box_id, detail in pairs(rawdata_client) do
        cfg[box_id]['key'] = detail['key']
    end

    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write treasure box server config to "..server_outname)
    outf:close()
end

generate_server_config(rawdata_server, rawdata_client)
generate_client_config(rawdata_client)




