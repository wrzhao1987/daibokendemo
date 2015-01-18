
local cfg = require('Midas')
local json_fmt = require('json_fomatter')

local server_outname = "midas.json"

text = json_fmt(cfg, true)
outf = io.open(server_outname, 'w')
outf:write(text)
print("write midas server config to "..server_outname)
outf:close()
