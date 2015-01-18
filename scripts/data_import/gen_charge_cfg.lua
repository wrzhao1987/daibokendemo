
local chargeCfg = require('Charge')
local json_fmt = require('json_fomatter')

local server_outname = "charge.json"


text = json_fmt(chargeCfg, true)
outf = io.open(server_outname, 'w')
outf:write(text)
print("write charge server config to "..server_outname)
outf:close()
