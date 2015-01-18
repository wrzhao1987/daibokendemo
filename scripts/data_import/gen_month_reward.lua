--
-- Created by IntelliJ IDEA.
-- User: martin
-- Date: 14-9-25
-- Time: 下午6:34
-- To change this template use File | Settings | File Templates.
--
if (not arg[1]) then
    print("usage: lua " ..arg[0].. " srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local month = tonumber(arg[2])
local server_outname = "login_bonus.json"

local month_days = {
    [1] = 31,
    [2] = 28,
    [3] = 31,
    [4] = 30,
    [5] = 31,
    [6] = 30,
    [7] = 31,
    [8] = 31,
    [9] = 30,
    [10] = 31,
    [11] = 30,
    [12] = 31,
}

local rule_server_normal = {
    sheet = "Sheet1",
    index = {"date"},
    table = {
        ["item_id"] = "item_id",
        ["sub_id"] = "sub_id",
        ["count"] = "count",
    }
}

local rule_server_total = {
    sheet = "Sheet2",
    index = {},
    table = {
        ["累计次数"] = "total_count",
        ["item_id"] = "item_id",
        ["sub_id"]  = "sub_id",
        ["count"]   = "count",
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

local rawdata_normal = excel.process(doc, rule_server_normal)
local rawdata_total  = excel.process(doc, rule_server_total)

function generate_server_config(rawdata_normal, rawdata_total)
    local cfg = {}

    for date, data in pairs(rawdata_normal) do
        if cfg[date] == nil then
            cfg[date] = {}
        end
        if cfg[date]["award"] == nil then
            cfg[date]["award"] = {}
        end
        cfg[date]["award"][#cfg[date]["award"]] = {
            item_id = data["item_id"],
            sub_id  = data["sub_id"],
            count   = data["count"],
        }
    end

    if cfg["accumulator"] == nil then
        cfg["accumulator"] = {}
    end
    for id, data in pairs(rawdata_total) do
        local check_count = data["total_count"]
        if cfg["accumulator"][check_count] == nil then
            cfg["accumulator"][check_count] = {}
        end
        local c = 0
        for k,v in pairs(cfg["accumulator"][check_count]) do
            c = c + 1
        end
        print(c)
        cfg["accumulator"][check_count][c] = {
            item_id = data["item_id"],
            sub_id  = data["sub_id"],
            count   = data["count"],
        }
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write treasure box server config to "..server_outname)
    outf:close()
end

generate_server_config(rawdata_normal, rawdata_total)

