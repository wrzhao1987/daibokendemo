function serialize(t, var)
	if type(t)~="table" then return tostring(t) end --
	local function ser_table(tbl,level)
		level = level or 1
		local align = "\n" .. string.rep("\t", level-1)
		local indent = string.rep("\t", level)

		local tmp = {}
		for k,v in pairs(tbl) do
			--local key = type(k)=="number" and "["..k.."]" or k
			local key = tonumber(k) and "["..k.."]" or k
			if type(v)=="table" then
				table.insert(tmp, indent..key.." = "..ser_table(v, level + 1))
			else
				--table.insert(tmp, indent..key.." = "..v)
				if type(v)=="number" then
					table.insert(tmp, indent..key.."="..v)
				elseif type(v)=="string" then
					table.insert(tmp, indent..key.."=[["..v.."]]")
				end
			end
		end
		return align .. "{\n" .. table.concat(tmp,",\n") .. align .. "}"
	end

	return "local "..var.." = " .. ser_table(t) .. "\nreturn "..var.."\n"
end

return serialize
