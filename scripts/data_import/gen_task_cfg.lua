
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local server_outname = 'quest.json'
local client_outname = 'Task.lua'


local rule_basic = {
    sheet = "local Task",
    index = {"id"},
    table = {
        ["name"]="name", ["type"]="type", ["desc"]="desc", ["limit"]="limit", ["next_id"]="next_id"
    },
}

local rule_bonus = {
    sheet = "bonus",
    index = {},
    table = {["id"]="id", ["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count"}
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
local rawdata_bonus = excel.process(doc, rule_bonus)
--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_bonus, ""))
--os.exit(0)

function generate_client_config(rawdata_basic, rawdata_bonus)
    cfg = {}
    for tid,tdata in pairs(rawdata_basic) do
        cfg[tid] = {
            name = tdata['name'],
            desc = tdata['desc'],
            type = tdata['type'],
            limit = tdata['limit'],
            next_id = tdata['next_id'],
            bonus = {}
        }
        if type(tdata['limit']) == 'string' then
            cfg[tid]['limit'] = loadstring('return '..tdata['limit'])()
        end
    end
    for _,bdata in pairs(rawdata_bonus) do
        local tid = bdata['id']
        local bonus = cfg[tid]['bonus']
        bonus[#bonus+1] = {
            item_id = bdata['item_id'],
            sub_id = bdata['sub_id'],
            count = bdata['count'],
        }
    end
    local text = excel.save(cfg, 'Task')
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write task client config to "..client_outname)
end

function generate_server_config(rawdata_basic, rawdata_bonus)
    cfg = {}
    for tid,tdata in pairs(rawdata_basic) do
        cfg[tid] = {
            type = tdata['type'],
            limit = tdata['limit'],
            next_id = tdata['next_id'],
            bonus = {}
        }
        if type(tdata['limit']) == 'string' then
            cfg[tid]['limit'] = loadstring('return '..tdata['limit'])()
        end
    end
    for _,bdata in pairs(rawdata_bonus) do
        local tid = bdata['id']
        local bonus = cfg[tid]['bonus']
        bonus[#bonus+1] = {
            item_id = bdata['item_id'],
            sub_id = bdata['sub_id'],
            count = bdata['count'],
        }
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write task server config to "..server_outname)
    outf:close()
end

generate_client_config(rawdata_basic, rawdata_bonus)
generate_server_config(rawdata_basic, rawdata_bonus)


