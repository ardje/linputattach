#include <lua.h>
#include <lauxlib.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/serio.h>
//#include "serio-ids.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>


static int pusherror(lua_State *L, const char *info)
{
        lua_pushnil(L);
        if (info==NULL)
                lua_pushstring(L, strerror(errno));
        else
                lua_pushfstring(L, "%s: %s", info, strerror(errno));
        lua_pushinteger(L, errno);
        return 3;
}

static int Psetldisc(lua_State *L)
{

	int fd = luaL_checkinteger(L, 1);
	int ldisc = luaL_optinteger(L,2,N_MOUSE);
        if (ioctl(fd, TIOCSETD, &ldisc) < 0) {
		return pusherror(L, "setldisc: can't set line discipline");
        }
        lua_pushinteger(L, ldisc);
	return 1;
}

static int Psettype(lua_State *L)
{

	int fd = luaL_checkinteger(L, 1);
	unsigned type = luaL_checkinteger(L,2);
	unsigned id= luaL_optinteger(L,3,0);
	unsigned extra=luaL_optinteger(L,4,0);
	unsigned long devt;
        devt = type | (id << 8) | (extra << 16);

        if (ioctl(fd, SPIOCSTYPE, &devt) < 0) {
		return pusherror(L, "settype: can't set device type");
        }
	printf("%ld %d %d %d", devt,type,id,extra);
        lua_pushinteger(L, 0);
	return 1;
}



static const struct luaL_Reg mylib [] = {
	{"setldisc", Psetldisc},
	{"settype", Psettype},
	{NULL, NULL} /* sentinel */
};

int luaopen_serial_attach (lua_State *L) {
	luaL_newlib(L, mylib);
	return 1;
}
