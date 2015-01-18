
local CfgCheck = require('cfg_check')
-- gen item store

if (not arg[2]) then
    print("usage: lua "..arg[0].." srcfile_basic.xml, srcfile_npc.xml")
    os.exit(0)
end

local srcfile_basic, srcfile_wave = arg[1], arg[2]
local client_outname = 'tower.lua'
local server_outname = 'karin_bonus.json'

local rule_basic = {
    sheet = "Sheet1",
    index = {"层数"},
    table = {["背景"]="bg_id", ["守卫模型"]="guardian_md", ["守卫阶"]="guardian_skn", ["卡牌经验"]="card_exp", 
        ["战队经验"]="exp", ["coin"]="coin", ["sub_id"]="box_sub_id"
    }
}

local rule_wave = {
    sheet = "Sheet1",
    index = {},
    table = {["层数"]="floor", ["wave"]="wave", ["出怪时间"]="time", ["出怪类型"]="npc_type", 
        ["上路怪id"]="npc_1", ["中路怪id"]="npc_2", ["下路怪id"]="npc_3"
    }
}

local excel = require('excel.excel')

local doc,err = excel.read(srcfile_basic)

if (err) then
    print(err)
    os.exit(1)
end

if (not doc) then
    print("fail to get doc")
    os.exit(0)
end

local doc_wave,err = excel.read(srcfile_wave)
if (err) then
    print(err)
    os.exit(1)
end

if (not doc_wave) then
    print("fail to get doc")
    os.exit(0)
end

local rawdata_basic = excel.process(doc, rule_basic)
local rawdata_wave = excel.process(doc_wave, rule_wave)

CfgCheck.checkRuleOrExit(rawdata_basic, rule_basic, "tower basic")
CfgCheck.checkRuleOrExit(rawdata_wave, rule_wave, "tower wave")

--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_wave, ""))
--os.exit(0)

function generate_client_config(rawdata_basic, rawdata_wave)
    local cfg = {}
    cfg['meta'] = {
        floorNum = #rawdata_basic,
        swipDiamondCost = 50,
        rankPrompt = [[每日5点刷新榜单排名，各位小伙伴大家加油哦！]],
        resetTimes = {
            [0] = 1,
            [1] = 1,
            [2] = 1,
            [3] = 1,
            [4] = 1,
            [5] = 1,
            [6] = 1,
            [7] = 1,
            [8] = 1,
            [9] = 1,
            [10] = 2,
            [11] = 2,
            [12] = 2,
            [13] = 2,
            [14] = 2,
            [15] = 2,
        }
    }
    cfg['data'] = {}
    local data = cfg['data']
    for floor, fdata in pairs(rawdata_basic) do
        data[floor] = {
            id = floor,
            bg_id = fdata['bg_id'],
            guardian = {md=fdata['guardian_md'], skn=fdata['guardian_skn']},
            card_exp = fdata['card_exp'],
            exp = fdata['exp'],
            bg_id = fdata['bg_id'],
            coin = fdata['coin'],
            drop = {},
            wave = {}
        }
        local drops = data[floor]['drop']
        if fdata['box_sub_id'] ~= 0 then
            drops[#drops+1] = {
                item_id = 12,
                sub_id = fdata['box_sub_id'],
                count = 1
            }
        end
    end
    for id, wdata in pairs(rawdata_wave) do
        local waves = data[wdata['floor']]['wave']
        local wave_id = wdata['wave']
        waves[wave_id] = waves[wave_id] or {}
        local index = #waves[wave_id] + 1
        waves[wave_id][index] = {time=wdata['time'], npcs={wdata['npc_1'], wdata['npc_2'], wdata['npc_3']}}
    end

    local text = excel.save(cfg, 'TowerConfig')
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    print("written karin tower client config to "..client_outname)
    outf:close()
end

function generate_server_config(rawdata_basic)
    local cfg = {}
    
    for floor,fdata in pairs(rawdata_basic) do
        cfg[floor] = {
            sony = fdata["coin"]
        }
        if fdata['box_sub_id'] ~= 0 then
            cfg[floor]['box'] = fdata['box_sub_id']
        end
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("written karin tower server config to "..server_outname)
    outf:close()
end

generate_client_config(rawdata_basic, rawdata_wave)
generate_server_config(rawdata_basic)


