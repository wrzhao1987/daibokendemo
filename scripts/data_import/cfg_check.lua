
local CfgCheck = {}

function checkRowFields(row, fields)
    for ofield, field in pairs(fields) do
        if not row[field] then
            print("misss field "..ofield.."=>"..field)
            return false
        end
    end
    return true
end

function indexRecursively(data, fields, i, n)
    if i==n then
        for _,row in pairs(data) do
            if not checkRowFields(row, fields) then
                return false
            end
        end
        return true
    end
    for _,idata in pairs(data) do
        if not indexRecursively(idata, fields, i+1, n) then
            return false
        end
    end
    return true
end

function CfgCheck.checkRule(data, rule)
    if not data or type(data)~='table' then
        print("data not available")
        return false
    end
    local has_mem = false
    for _,v in pairs(data) do
        has_mem = true
        break
    end
    if not has_mem then
        print("empty data")
        return
    end
    local index, row_fields = rule.index, rule.table
    if #index == 0 then
        return indexRecursively(data, row_fields, 1, 1)
    else
        return indexRecursively(data, row_fields, 1, #index)
    end
end

function CfgCheck.checkRuleOrExit(data, rule, name)
    if not CfgCheck.checkRule(data, rule) then
        print(name.." failed check")
        os.exit(1)
    end
end

return CfgCheck
