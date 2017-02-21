local Command = require"eject":extend"Command"

function Command:initialize( exec, stdin, stdout, stderr )
	self.exec = exec
end

function Command:__call( t )
	local args = {}
	for i, v in ipairs( t ) do
		args[i] = v
	end
	self.exec
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

local function sh(...)
	return Command:new(...)
end
