local gt=require"touch.generic"
local M=gt:new()
local p=require"posix"
M.protocol=0x20
M.tcattr.cflag=p.B9600 + M.tcattr.cflag

return M
