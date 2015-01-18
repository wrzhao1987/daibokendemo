
local CfgCheck = require('cfg_check')
-- gen refresh store

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local server_outname = 'rstore.json'

local rule = {
    sheet = "Sheet1",
    index = {},
    table = {["商城id"]="store_id", ["c_id"]="cid", ["item_id"]="item_id", ["sub_id"]="sub_id", ["count"]="count", 
        ["currency"]="currency", ["price"]="price", ["weight"]="weight",
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
CfgCheck.checkRuleOrExit(rawdata, rule, "rstore")

function generate_server_config(rawdata)
    local cfg = {}
    local w = 1

    for seq=1, #rawdata do
        local cdata = rawdata[seq]
        if not cfg[cdata['store_id']] then
            cfg[cdata['store_id']] = {
                refresh_price = {
                    currency= cdata['currency'],
                    diff= {
                        [1]= 0, -- first free refresh
                        [2]= 10,
                        [3]= 50,
                        [4]= 100,
                        [5]= 200,
                        [6]= 500,
                        [7]= 1000,
                    }
                },
                presents_count= 0,
                fix_commodities= {},
                commodities = {},
            }
        end
        local store = cfg[cdata['store_id']]
        store.commodities[cdata['cid']] = {
            items = {
                [0] = {
                    type = 1,
                    item_id = cdata['item_id'],
                    sub_id = cdata['sub_id'],
                    count = cdata['count'],
                }
            },
            price = {
                currency = cdata['currency'],
                val = cdata['price'],
            },
            purchase_restriction = {
                type = 1,
                amount = 1,
            },
            weight = cdata['weight'],
        }
        store.presents_count = store.presents_count + 1
        table.insert(store.fix_commodities, cdata['cid'])
    end
    
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("written item store server config to "..server_outname)
    outf:close()
end

generate_server_config(rawdata)


