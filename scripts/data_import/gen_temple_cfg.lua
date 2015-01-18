
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local script_outname = 'Temple.lua'
local server_outname = 'temple.json'

local rule = {
    sheet = "Sheet1",
    index = {"天神id", "天神等级"},
    table = {
        ["天神名称"]="name", 
        ["天神升级需要的次数"]="exp",
        ["奖励item_id"]="item_id",
        ["奖励sub_id"]="sub_id",
        ["奖励数量"]="count",
        ["box_item_id"]="box_item_id",
        ["box_sub_id"]="box_sub_id",
        ["chance"]="chance",
        ["膜拜开启时间1"]="open_time_1",
        ["膜拜结束时间1"]="close_time_1",
        ["膜拜开启时间2"]="open_time_2",
        ["膜拜结束时间2"]="close_time_2",
        ["膜拜次数对应花费的钻石数量"] = "cost",
        ["用户等级限制条件"] = "entry_access",
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

local rawdata = excel.process(doc, rule)

--print(excel.save(rawdata, ""))
--os.exit(0)

function generate_client_config(rawdata)
    cfg = {}
    for god_id,gdata in pairs(rawdata) do
        local god = {}
        cfg[god_id] = god
        god['icon_id'] = god_id
        god['name'] = gdata[1]['name']
        god["cost"] = gdata[1]['cost']
        god["max_level"] = #gdata
        god["times"] = {
            ["1"]= {
                gdata[1]['open_time_1'],
                gdata[1]['close_time_1']
            },
        }
        if gdata[1]['open_time_2'] ~= 0 then
            god["times"]["2"] = {
                gdata[1]['open_time_2'],
                gdata[1]['close_time_2']
            }
        end
        god["lvUp_count"] = {}
        god["bonus"] = {}
        local bonus = god["bonus"]
        local level_limit = god["lvUp_count"]
        for level, ldata in pairs(gdata) do
            bonus[level] = {
                [1] = {item_id = 2, sub_id=1, count=ldata['count']},
            }
            if ldata['chance'] and ldata['chance'] ~= 0 then
                bonus[level][2] = {item_id = 12, id=ldata['box_sub_id'], chance=ldata['chance']}
            end
            level_limit[level+1] = ldata['exp']
        end
        level_limit[#level_limit] = nil
    end
    local text = excel.save(cfg, 'Temple')
    print(text)
    local outf = io.open(script_outname, 'w')
    outf:write(text)
    outf:close()
    print("write temple client config to "..script_outname)
end

function generate_server_config(rawdata)
    cfg = {}
    for god_id,gdata in pairs(rawdata) do
        cfg[god_id] = {}
        local god = cfg[god_id]
        local str = gdata[1]['entry_access']
        local parts = string.split(str, ':')
        god["unlock_condition"] = {
            ["type"] = parts[1],
            ["value"] = parts[2]
        }
        god["open_time"] = {
            ["1"]= {
                ["start"] = gdata[1]['open_time_1'],
                ["end"] = gdata[1]['close_time_1']
            },
        }
        if gdata[1]['open_time_2'] ~= 0 then
            god["open_time"]["2"] = {
                ["start"] = gdata[1]['open_time_2'],
                ["end"] = gdata[1]['close_time_2']
            }
        end
        god["level_limit"] = {}
        god["bonus"] = {}
        local bonus = god["bonus"]
        local level_limit = god["level_limit"]
        for level, ldata in pairs(gdata) do
            bonus[level] = {
                sony = ldata['count'],
            }
            if ldata['chance'] and ldata['chance'] ~= 0 then
                bonus[level]['box'] = {id=ldata['box_sub_id'], chance=ldata['chance']}
            end
            level_limit[level] = ldata['exp']
        end
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


