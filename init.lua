local M = {}
M.stdio = {
	stdin = 0,
	stdout = 1,
	stderr = 2,
}
--for reverse lookup
for k, v in pairs(M.stdio) do
	M.stdio[v]=k
end

setmetatable(M,M)

function M:__gc()
end

--TODO: redirect to other commands?
local Command = require"eject":extend"Command"

--[[
	Creates two handles, one for Lua (standard io file) and one for the shell (escaped string, to be used as file name)
	file: a string, number or file handle, in the latter case, you also have to provide the original name, since Lua can't figure out what name a handle was created by
	mode: the mode of the Lua file handle
	?name: the filename used to create the handle, if one was provided. Whether this is the correct filename is not checked, as it is not possible with the standard library.
]]
local function toFileHandles(file, mode, name)
	local lf,sf
	if type(file) == "string" then
		--file name
		lf = assert(io.open(file, mode))
		sf = "'"..file:gmatch("'","\\%1").."'"
	elseif M.stdio[file] the
		lf = assert(io.open(io.tmpname(),mode))
		sf = "&"..file
	elseif io.type(file) == "file" then
		--this is not a good idea, but go on
		lf = file
		sf = "'"..file:gmatch("'","\\%1").."'"
	end
	return lf, sf
end

function Command:initialize( opt )
	self.name = opt[1] or error"No command name provided, I need a path or a name"
	self.stdin = opt.stdin
	self.stdout = opt.stdout
	self.stderr = opt.stderr
	self.base = self:build()
end

function Command:build()
	local k
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
