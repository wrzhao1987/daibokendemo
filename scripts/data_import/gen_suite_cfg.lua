
local CfgCheck = require('cfg_check')
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile_mission.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'EquipSet.lua'

local rule_basic = {
    sheet = "Sheet1",
    index = {"套装id"},
    table = {["套装名称"]="name", ["id_1"]="equip_1", ["id_2"]="equip_2", ["id_3"]="equip_3", ["id_4"]="equip_4",
        ["装备两件属性加成"] = "desc_2",
        ["装备三件属性加成"] = "desc_3",
        ["装备四件属性加成"] = "desc_4",
    },
}

local rule_props = {
    sheet = "Sheet2",
    index = {},
    table = {["套装id"]="sid", ["装备数"]="num", ["type"]="type", ["mode"]="mode", ["value"]="value"},
}

local excel = require('excel.excel')

local doc, err = excel.read(srcfile)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_basic = excel.process(doc, rule_basic)
local rawdata_props = excel.process(doc, rule_props)

CfgCheck.checkRuleOrExit(rawdata_basic, rule_basic, "equip set basic")
CfgCheck.checkRuleOrExit(rawdata_props, rule_props, "equip set props")

--print(excel.save(rawdata_basic, ""))
--print(excel.save(rawdata_props, ""))
--os.exit(0)

function generate_client_config(rawdata_basic, rawdata_props)
    local text, outf
    local cfg = {}

    -- basic
    for id,adata in ipairs(rawdata_basic) do
        cfg[id] = {
            equips = {adata['equip_1'], adata['equip_2'], adata['equip_3'], adata['equip_4']},
            name = adata['name'],
            descs = {
                [2] = adata['desc_2'],
                [3] = adata['desc_3'],
                [4] = adata['desc_4'],
            },
            prop = {
                [2] = {},
                [3] = {},
                [4] = {},
            }
        }
    end

    -- prop
    for seq=1, #rawdata_props do
        local pdata = rawdata_props[seq]
        local props = cfg[pdata['sid']].prop
        if not props then
            print("suite "..pdata['sid']..' not configured')
        end
        table.insert(props[pdata['num']],
            {
                type = pdata['type'],
                mode = pdata['mode'],
                value = pdata['value'],
            }
        )
    end

    text = excel.save(cfg, "Cfg")
    outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write client config to "..client_outname)
end

function generate_server_config(rawdata_meta, rawdata_basic, rawdata_drop, rawdata_wave)
end

generate_client_config(rawdata_basic, rawdata_props)
generate_server_config(rawdata_basic, rawdata_props)


