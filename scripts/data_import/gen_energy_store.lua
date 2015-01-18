
local json = require('cjson')
local excel = require('excel.excel')

-- gen energy store

if (not arg[1]) then
    print("usage: lua "..arg[0].." srcfile.xml")
    os.exit(0)
end

local srcfile = arg[1]
local client_outname = 'eStore.lua'

local file = io.open(srcfile, "r")
local line = file:read()
local content = ''
while (line) do
    content = content..line
    line = file:read()
end
local a = json.decode(content)

local text = excel.save(a, "")

local outf = io.open(client_outname, 'w')
outf:write(text)
print("written energy store client config to "..client_outname)
outf:close()


