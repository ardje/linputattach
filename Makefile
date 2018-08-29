ALL: binary
LIBDEST=/usr/lib/$(shell uname -m)-linux-gnu

binary: liblua5.2-attach.so liblua5.1-attach.so
.PHONY: binary

attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.2 --cflags) -llua5.2 -o $@

clean:
	-rm -f *.so
.PHONY: clean

install:
	install -d $(LUA_LIBDIR)/touch
	install -m 0644 daemonize.lua $(LUA_LIBDIR)
	install -m 0644 touch/* $(DESTDIR)/usr/share/lua/5.1/touch
	install -d $(DESTDIR)/usr/share/lua/5.2/touch
	install -m 0644 daemonize.lua $(DESTDIR)/usr/share/lua/5.2
	install -m 0644 touch/* $(DESTDIR)/usr/share/lua/5.2/touch
	install -d $(DESTDIR)/usr/share/lua/5.3/touch
	install -m 0644 daemonize.lua $(DESTDIR)/usr/share/lua/5.3
	install -m 0644 touch/* $(DESTDIR)/usr/share/lua/5.3/touch
	install -d $(DESTDIR)$(LIBDEST)/lua/5.1/serial
	install -d $(DESTDIR)$(LIBDEST)/lua/5.2/serial
	install -d $(DESTDIR)$(LIBDEST)/lua/5.3/serial
	install -m 0644 liblua5.2-attach.so liblua5.1-attach.so liblua5.3-attach.so $(DESTDIR)$(LIBDEST)
	ln -s ../../../liblua5.2-attach.so $(DESTDIR)$(LIBDEST)/lua/5.2/serial/attach.so
	ln -s ../../../liblua5.1-attach.so $(DESTDIR)$(LIBDEST)/lua/5.1/serial/attach.so
	ln -s ../../../liblua5.3-attach.so $(DESTDIR)$(LIBDEST)/lua/5.3/serial/attach.so
	install -d $(DESTDIR)/etc/linputattach
	install -d $(DESTDIR)/usr/bin
	install -m 0755 linputattach $(DESTDIR)/usr/bin

.PHONY: install
