
-- gen item store

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'Store.lua'
local server_outname = 'store_goods_2.json'

local rule = {
    sheet = "Sheet1",
    index = {"commodity_id"},
    table = {["commodity_name"]="commodity_name", ["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count", 
        ["currency_type"]="currency_type", ["price"]="price"
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

function generate_server_config(rawdata)
    local cfg = {}
    local w = 1
    
    for cid,cdata in pairs(rawdata) do
        cfg[cid] = {
            items = {
                {
                    type = 1,
                    item_id = cdata['item_id'],
                    sub_id = cdata['sub_id'],
                    count = cdata['count'],
                }
            },
            price = {
                currency = cdata['currency_type'],
                val = cdata['price'],
            },
            purchase_restriction = {
                type = 0
            },
            weight = w
        }
        w = w + 1
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    print(text)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("written item store server config to "..server_outname)
    outf:close()
end

generate_server_config(rawdata)


