if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local script_outname = 'Npc.lua'
local career_type = {
    ["剑"] = 1,
    ["枪"] = 2,
    ["盾"] = 5,
    ["魔"] = 4,
    ["医"] = 3,
}

local rule_npc = {
    sheet = "Sheet1",
    index = {"id"},
    table = {
        ["模型"]="md", ["等级"]="level", ["阶"]="skn", ["体积"]="sz", ["职业"]="car",
        ["atk"]="atk", ["def"]="def", ["hp"]="hp", ["移动速度"]="spd",
        ["攻击方式"]="atk_md", ["攻击速度"]="atk_spd", ["攻击范围"]="atk_scp",
        ["子弹类型"]="atk_bltp", ["召唤技能类型"]="conjure_type",
        ["触发概率"]="conjure_rate", ["持续时间"]="conjure_time",
        ["数值"]="conjure_value"
    },
    filter = function(key, value)
        if (key=="car") then
            if (not career_type[value]) then
                print("unknown type ["..value.."]")
                os.exit(1)
            end
            return career_type[value]
        end
    end
}

local excel = require('excel.excel')

local doc_npc,err = excel.read(srcfile)
if (err) then
    print(err)
    os.exit(1)
end

local rawdata_npc = excel.process(doc_npc, rule_npc)

function generate_client_config(rawdata_npc)
    local text, outf
    local npc_cfg = {}

    -- npc
    for id,tdata in pairs(rawdata_npc) do
        npc = {}
        npc['md'] = tdata['md']
        npc['skn'] = tdata['skn']
        npc['sz'] = tdata['sz']
        npc['car'] = tdata['car']
        npc['atk'] = tdata['atk']
        npc['def'] = tdata['def']
        npc['hp'] = tdata['hp']
        npc['spd'] = tdata['spd']
        npc['atkpr'] = {md=tdata['atk_md'], spd=tdata['atk_spd'], scp=tdata['atk_scp'], bltp=tdata['atk_bltp']}
        npc['conjure'] = {type=tdata['conjure_type'], rate=tdata['conjure_rate'], time=tdata['conjure_time'], value=tdata['conjure_value']}
        npc_cfg[id] = npc
    end

    print("write Npc client config to "..script_outname)
    text = excel.save(npc_cfg, 'Npc')
    outf = io.open(script_outname, 'w')
    outf:write(text)
    outf:close()
end

generate_client_config(rawdata_npc)