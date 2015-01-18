if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local server_outname_normal = 'mission_star_bonus.json'
local server_outname_elite  = 'elite_mission_star_bonus.json'
local frontend_outname_normal = 'MissionBonus.lua'
local frontend_outname_elite = 'MissionBonusElite.lua'


local rule_normal = {
    sheet = "Sheet1",
    index = {},
    table = {
        ["章节"]    = "chapter",
        ["宝箱序号"] = "bonus_no",
        ["item_id"] = "item_id",
        ["sub_id"]  = "sub_id",
        ["count"]   = "count",
    }
}

local rule_elite = {
    sheet = "Sheet2",
    index = {},
    table = {
        ["章节"]    = "chapter",
        ["宝箱序号"] = "bonus_no",
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

local rawdata_normal = excel.process(doc, rule_normal)
local rawdata_elite  = excel.process(doc, rule_elite)

function generate_server_config(rawdata_normal, rawdata_elite)

    local cfg_normal = {}
    local cfg_elite  = {}

    for id, tdata in pairs(rawdata_normal) do
        local chapter = tdata["chapter"]
        local bonus_no = tdata["bonus_no"]
        local item_id = tdata["item_id"]
        local sub_id = tdata["sub_id"]
        local count = tdata["count"]

        if cfg_normal[chapter] == nil then
            cfg_normal[chapter] = {}
        end
        if cfg_normal[chapter][bonus_no] == nil then
            cfg_normal[chapter][bonus_no] = {}
        end
        table.insert(cfg_normal[chapter][bonus_no], {
            item_id = item_id,
            sub_id  = sub_id,
            count   = count,
        })
    end

    for id, tdata in pairs(rawdata_elite) do
        local chapter = tdata["chapter"]
        local bonus_no = tdata["bonus_no"]
        local item_id = tdata["item_id"]
        local sub_id = tdata["sub_id"]
        local count = tdata["count"]

        if cfg_elite[chapter] == nil then
            cfg_elite[chapter] = {}
        end
        if cfg_elite[chapter][bonus_no] == nil then
            cfg_elite[chapter][bonus_no] = {}
        end
        table.insert(cfg_elite[chapter][bonus_no], {
            item_id = item_id,
            sub_id  = sub_id,
            count   = count,
        })
    end

    local json_fmt = require('json_fomatter')

    local text = json_fmt(cfg_normal, true)
    local outf = io.open(server_outname_normal, 'w')
    outf:write(text)
    print("write config 1 to "..server_outname_normal)
    outf:close()

    local outf = io.open(frontend_outname_normal, 'w')
    local text = excel.save(cfg_normal, 'MissionBonus')
    outf:write(text)
    print("write config 2 to "..frontend_outname_normal)


    local text = json_fmt(cfg_elite, true)
    local outf = io.open(server_outname_elite, 'w')
    outf:write(text)
    print("write config 3 to "..server_outname_elite)
    outf:close()

    local outf = io.open(frontend_outname_elite, 'w')
    local text = excel.save(cfg_elite, 'MissionBonusElite')
    outf:write(text)
    print("write config 4 to "..frontend_outname_elite)
end

generate_server_config(rawdata_normal, rawdata_elite)
