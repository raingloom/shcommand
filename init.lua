local M = {}
M.stdio = {
	stdin = 0,
	stdout = 1,
	stderr = 2,
}

setmetatable(M,M)

M.tmpdir = os.tmpfile

function M:__gc()
end

--TODO: redirect to other commands?
local Command = require"eject":extend"Command"

local function escape(str)
	local t = type(str)
	if t == "string" then
		return "'"..str:gsub("'","\'").."'"
	elseif t == "number" then
		return "&"..str
	end
end

function Command:initialize( opt )
	self.name = opt[1] or error"No command name provided, I need a path or a name"
	self.stdin = opt.stdin
	self.stdout = opt.stdout
	self.stderr = opt.stderr
	self.base = self:build()
end

function Command:build()
	local ret,i = {self.name},2
	for k,v in pairs{
		stdin = "<",
		stdout = "1>",
		stderr = "2>",
	} do
		ret[i],i = v..escape(self[k]),i+1
	end
	return table.concat(ret," ")
end

function Command:__call( t )
	local evalstr = {self.base}.." "..self:arg(t)
	evalstr
end

function Command:convertKV( k, v )
	--TODO: convert `foo="bar"` to `--foo=bar` or `--foo bar` and variants
	local t = type(v)
	if t == "string" then
		return "--"..k.."="..v
	--`foo=true` -> `--foo`
	elseif t == "bool" then
		return v and (#k > 1 and "--" or "-")..k or ""
	end
end
