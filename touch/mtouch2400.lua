local gt=require"touch.generic"
local M=gt:new()
local p=require"posix"
M.tcattr.cflag=p.B2400 + M.tcattr.cflag
M.protocol=0x30

return M
