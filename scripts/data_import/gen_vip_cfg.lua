
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local server_outname = 'user_vip.json'
local client_outname = 'Vip.lua'


local rule = {
    sheet = "VIP功能",
    index = {"VIP等级"},
    table = {["充值金额"]="charge", ["能量购买次数"]="energy_purchase_limit", ["原力购买次数"]="pvp_energy_purchase_limit", 
        ["扫荡券"]="free_wipes", ["点金手次数"]="midas_limit", ["精英关卡重置"]="elite_section_pass_reset_limit", ["竞技场次数"]="challenge_limit",
        ["天神塔次数"]="worship_limit", ["神殿重置"]="karin_reset_limit"
    },
}

local rule_desc = {
    sheet = "VIP描述",
    index = {"VIP等级"},
    table = {["desc"]="desc"}
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

local rawdata_desc = excel.process(doc, rule_desc)
--print(excel.save(rawdata, ""))
--print(excel.save(rawdata_desc, ""))

function generate_client_config(rawdata, rawdata_desc)
    cfg = {}
    for vip,vdata in pairs(rawdata) do
        cfg[vip] = {
            charge = vdata["charge"],
            wipe_energy = vdata["free_wipes"],
        }
    end
    for vip,vdata in pairs(rawdata_desc) do
        cfg[vip]['desc'] = vdata['desc']
    end
    local text = excel.save(cfg, 'Vip')
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write equip client config to "..client_outname)
end

-- id=>{level=>{xxx}}
function generate_server_config(rawdata)
    cfg = {}
    for vip,vdata in pairs(rawdata) do
        cfg[vip] = {
            charge = vdata["charge"],
            wipe_energy = vdata["free_wipes"],
            karin_reset_time = vdata["worship_limit"],
            temple_worship_time = vdata["karin_reset_limit"],
        }
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


