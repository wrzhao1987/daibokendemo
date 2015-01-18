
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'User.lua'
local server_outname = 'user_level.json'

local rule = {
    sheet = "Sheet1",
    index = {"level"},
    table = {["exp"]="exp", ["pve_energy"]="pve_energy", ["pvp_energy"]="pvp_energy", ["card_level_limited"]="card_level_limited"}
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

function generate_client_config(rawdata)
    cfg = {}
    for lvl,ldata in pairs(rawdata) do
        cfg[lvl] = {}
        cfg[lvl]["exp"] = ldata["exp"]
        --cfg[lvl]["exp"] = rawdata[lvl]["exp"] - (rawdata[lvl-1] and rawdata[lvl-1]["exp"] or 0)
        cfg[lvl]["energy"] = ldata["pve_energy"]
        cfg[lvl]["rob_energy"] = ldata["pvp_energy"]
        cfg[lvl]["card_level_limited"] = ldata["card_level_limited"]
    end
    local text = excel.save(cfg, 'User')
    --print(text)
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("written user client config to "..client_outname)
end

function generate_server_config(rawdata)
    local cfg = {}
    cfg["rob_energy_limit"] = rawdata[1]["pvp_energy"]
    cfg["level_exp_boundary"] = {};
    cfg["level_config"] = {}
    lcfg = cfg["level_config"]
    lboundary = cfg["level_exp_boundary"]
    lboundary[0] = 0
    for lvl,ldata in pairs(rawdata) do
        lcfg[lvl] = {}
        lcfg[lvl]["mission_energy_limit"] = ldata["pve_energy"]
        lcfg[lvl]["card_level_limit"] = ldata["card_level_limited"]
        lboundary[lvl] = ldata["exp"]
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    --print(text)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("written user server config to "..server_outname)
    outf:close()
end

generate_client_config(rawdata)
generate_server_config(rawdata)


