ALL: serial/attach.so
LIBDEST=/usr/lib/$(shell uname -m)-linux-gnu

liblua5.2-attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.2 --cflags) -llua5.2 -o $@

liblua5.1-attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.1 --cflags) -llua5.1 -o $@

rsync: serial/attach.so
	rsync -va touch serial daemonize.lua linputattach 192.168.0.175::root/root/inputattach/

install:
	install -d $(DESTDIR)/usr/share/lua/5.1/touch
	install -m 0444 daemonize.lua $(DESTDIR)/usr/share/lua/5.1
	install -m 0444 touch/* $(DESTDIR)/usr/share/lua/5.1/touch
	install -d $(DESTDIR)/usr/share/lua/5.2/touch
	install -m 0444 daemonize.lua $(DESTDIR)/usr/share/lua/5.2
	install -m 0444 touch/* $(DESTDIR)/usr/share/lua/5.2/touch
	install -d $(DESTDIR)$(LIBDEST)/lua/5.1
	install -d $(DESTDIR)$(LIBDEST)/lua/5.2
	install -m liblua5.2-attach.so liblua5.1-attach.so $(DESTDIR)$(LIBDEST)
	ln -s ../../liblua5.2-attach.so $(DESTDIR)$(LIBDEST)/lua/5.2/attach.so
	ln -s ../../liblua5.1-attach.so $(DESTDIR)$(LIBDEST)/lua/5.1/attach.so
	install -d $(DESTDIR)/etc/linputattach

.PHONY: install
