local tty="/dev/ttyUSB1"
local td=require "touch.mtouch"

local ts=td:open{tty=tty}

ts:attach()


