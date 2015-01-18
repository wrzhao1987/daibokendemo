
function format(t)
	if type(t)~="table" then return tostring(t) end
	local function ser_table(tbl,level)
		level = level or 1
		local align = "\n" .. string.rep("\t", level-1)
		local indent = string.rep("\t", level)

		local tmp = {}
		for k,v in pairs(tbl) do
            local key
            key = '"'..k..'"'
			if type(v)=="table" then
				table.insert(tmp, indent..key.." : "..ser_table(v, level + 1))
			else
				if type(v)=="number" then
					table.insert(tmp, indent..key..":"..v)
				elseif type(v)=="string" then
					table.insert(tmp, indent..key..":\""..v.."\"")
				end
			end
		end
		return align .. "{\n" .. table.concat(tmp,",\n") .. align .. "}"
	end

	return ser_table(t).."\n"
end

return format

