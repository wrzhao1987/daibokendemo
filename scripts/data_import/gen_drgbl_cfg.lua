
if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'DragonBall.lua'
local server_outname = 'dragon_ball_exp.json'

local desc = {
    [1]="暴击",
    [2]="免暴击",
    [3]="攻击提升",
    [4]="防御提升",
    [5]="血量提升",
    [6]="伤害提升",
    [7]="伤害减免",
}
local name = {
    [1]="金色一星球",
    [2]="金色二星球",
    [3]="金色三星球",
    [4]="金色四星球",
    [5]="金色五星球",
    [6]="金色六星球",
    [7]="金色七星球",
}

local rule = 
{
    sheet = "Sheet1",
    index = {"id", "等级"},
    table = {["附加属性"]="type", ["数值"]="val", ["经验下限"]="exp_low", ["经验上限"]="exp_up",},
    filter = function(key, value) --过滤函数，在其中处理复杂数据
        if key=="type" then
            for i=1,#desc do
                if (desc[i] == value) then
                    return i
                end
            end
        elseif key=="val" then
            return value*1000
        end
    end
}

local excel = require('excel.excel')

local doc,err = excel.read(srcfile)

if (err) then
    print(err)
    os.exit(1)
end

local rawdata = excel.process(doc, rule)

function generate_client_config(rawdata)
    cfg = {}
    for no=1, #rawdata do
        local dl = rawdata[no]
        cfg[no] = {}
        cfg[no]['name'] = name[no]
        cfg[no]['desc'] = desc[dl[1]['type']]
        cfg[no]['type'] = dl[1]['type']
        cfg[no]['cls'] = 1
        local vals = {}
        local exps = {}
        for lvl=1, #dl do
            local data = dl[lvl]
            exps[lvl] = data['exp_low']
            vals[lvl] = data['val']
        end
        cfg[no]['value'] = vals
        cfg[no]['exp'] = exps
    end
    local text = excel.save(cfg, 'DragonBall')
    local outf = io.open(client_outname, 'w')
    outf:write(text)
    outf:close()
    print("write dragonball client config to "..client_outname)
end

function generate_server_config(rawdata)
    cfg = {}
    for no=1, #rawdata do
        local dl = rawdata[no]
        cfg[no] = {}
        for lvl=1, #dl-1 do
            local data = dl[lvl]
            cfg[no][lvl] = {exp_limit=(data['exp_up']+1)}
        end
        cfg[no][#dl] = cfg[no][#dl-1]
    end
    local json_fmt = require('json_fomatter')
    local text = json_fmt(cfg, true)
    local outf = io.open(server_outname, 'w')
    outf:write(text)
    print("write dragonball server config to "..server_outname)
    outf:close()
end

generate_client_config(rawdata)
generate_server_config(rawdata)


