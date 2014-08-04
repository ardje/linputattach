local gt=require"touch.generic"
local M=gt:new()
local p=require"posix"
M.protocol=0x30
M.tcattr.cflag=p.B9600 + M.tcattr.cflag
--[[
Mtouch protocol:
byte
00    0x80 | 0x40 == touch
01    0x00..0x7F Low byte X
02    0x00..0x7F "high" byte X
03    0x00..0x7F Low byte Y
04    0x00..0x7F "high" byte Y

A lead in of 0x01 is possible, then the end fo message is 0x0d
It is unknown what is passed in those cases

-- ]]

return M
