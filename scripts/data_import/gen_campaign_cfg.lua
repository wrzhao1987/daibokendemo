
local ccfg = require('Campaign')
local json_fmt = require('json_fomatter')

local server_outname = "event.json"

local cfg = {
    [1] = {
        start_time = '2014-11-14 05:00',
        end_time = '2014-12-31 05:00',
        conf = {},
    },
    [2] = {
        start_time = '2014-11-14 05:00',
        end_time = '2014-12-31 05:00',
        conf = {},
    },
}

for i=1, #ccfg[1]['awards'] do
    cfg[1].conf[i] = {
        bonus=ccfg[1]['awards'][i]['items'],
    }
end
for i=1, #ccfg[2]['awards'] do
    cfg[2].conf[i] = {
        condition = ccfg[2]['awards'][i].level,
        bonus=ccfg[2]['awards'][i]['items'],
    }
end

text = json_fmt(cfg, true)
outf = io.open(server_outname, 'w')
outf:write(text)
print("write charge server config to "..server_outname)
outf:close()
