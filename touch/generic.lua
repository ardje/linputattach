local p=require"posix"
local attach=require"serial.attach"

local M={}

--[[ We can only do shallow inheritance, this is deep
M.tcattr={}
M.tcattr.cflag=p.B9600 + p.CS8 +p.CREAD+p.HUPCL + p.CLOCAL
M.tcattr.iflag=p.IGNBRK+p.IGNPAR
M.tcattr.oflag=0
M.tcattr.lflag=0
M.tcattr.cc={ VMIN=1, VTIME=0}
M.speed=B9600
]]

function M:new()
	local o={}
	o.tcattr={}
	o.tcattr.cflag=p.CS8 +p.CREAD+p.HUPCL + p.CLOCAL
	o.tcattr.iflag=p.IGNBRK+p.IGNPAR
	o.tcattr.oflag=0
	o.tcattr.lflag=0
	o.tcattr.cc={ VMIN=1, VTIME=0}
	o.protocol=0
	o.id=0
	o.extra=0
	setmetatable(o,{__index=self})
	return o
end

function M:_setflags()
	self.tcattr.cflag=p.CS8 +p.CREAD+p.HUPCL + p.CLOCAL
	self.tcattr.iflag=p.IGNBRK+p.IGNPAR
	self.tcattr.oflag=0
	self.tcattr.lflag=0
	self.tcattr.cc={ VMIN=1, VTIME=0}
end

function M:open(n)
	local tty=n.tty
	local fd,err
	local o
	if getmetatable(self)==nil then
		o=M:new()	
	else
		o=self
	end
	if tty==nil then
		return nil, "No device given"
	end
	fd,err=assert(p.open(tty,p.O_RDWR + p.O_NOCTTY+ p.O_NONBLOCK))
	--print(self.tcattr)
	local tcattr=p.tcgetattr(fd)
	self.tcattr=tcattr
	self:_setflags()
	self:setflags()
	p.tcsetattr(fd, p.TCSANOW, tcattr)
	o.fd=fd
	o.tty=tty
	return o
end
function M:attach()
	self.ldisc=assert(attach.setldisc(self.fd))
	assert(attach.settype(self.fd,self.protocol,self.id,self.extra))
	local n=p.read(self.fd,1)
	p.sleep(3600)
end
function M:write(message)
	p.tcdrain(self.fd)
	local n,e=assert(p.write(self.fd,message))
end

function M:close()
	if self.fd ~= nil then
		assert(p.close(self.fd))
		self.fd=nil
	end
end

return M

