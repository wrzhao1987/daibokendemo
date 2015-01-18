
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local script_outname = 'Tech.lua'
local server_outname = 'temple.json'

local rule = {
    sheet = "Sheet1",
    index = {"id"},
    table = {
        ["id"]="id", 
        ["name"]="name", 
        ["pic"]="pic", 
        ["key"]="key", 
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
    for tname,tdata in pairs(rawdata) do
    end
    local text = excel.save(cfg, 'Tech')
    print(text)
    local outf = io.open(script_outname, 'w')
    outf:write(text)
    outf:close()
    print("write tech client config to "..script_outname)
end

function generate_server_config(rawdata)
    cfg = {}
    for god_id,gdata in pairs(rawdata) do
        cfg[god_id] = {}
        local god = cfg[god_id]
        local str = gdata[1]['entry_access']
        local parts = string.split(str, ':')
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write tech server config to "..server_outname)
    outf:close()
end

--generate_client_config(rawdata)
generate_server_config(rawdata)


