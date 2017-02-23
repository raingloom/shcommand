local Command = require"shcommand".Command

files = Command:new{"file", background = true}
files.argparse.onlyLong = true
sed = Command:new{"sed", stdin = files.stdout}
files("/usr/share/lua",type="f")
print(sed("").stdout:read"*")
