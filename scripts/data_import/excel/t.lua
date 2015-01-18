local SLAXML = require('excel.slaxdom')

local function GetAttribute(attr, name)
    for _,v in pairs(attr) do
        if v.name==name then
            return v.value
        end
    end
end

local function GetDataValue(data)
    local type = GetAttribute(data.attr, 'Type')
    for _,v in pairs(data.kids) do
        if v.name=='#text' then
            if type=='Number' then
                return tonumber(v.value)
            else
                return v.value
            end
        end
    end
end

function test()
    ExcelParser(path)
end

local function ExcelParser(path)
	local file, err = io.open(path, "r")
	if file then
		local text = file:read("*a")
		file:close()

		local doc = SLAXML:dom(text, {simple=true})
		for k,v in pairs(doc.kids) do
            print("key:"..k..', type'..type(k))
            if v.type=='element' then
            else
            end

        end
	else
		return false, err
	end
end

test()
