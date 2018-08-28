ALL: binary
LIBDEST=/usr/lib/$(shell uname -m)-linux-gnu

binary: liblua5.2-attach.so liblua5.1-attach.so
.PHONY: binary

liblua5.2-attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.2 --cflags) -llua5.2 -o $@

liblua5.1-attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.1 --cflags) -llua5.1 -o $@

liblua5.3-attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.3 --cflags) -llua5.3 -o $@

rsync: serial/attach.so
	rsync -va touch serial daemonize.lua linputattach 192.168.0.175::root/root/inputattach/

clean:
	-rm -f *.so
.PHONY: clean

install:
	install -d $(DESTDIR)/usr/share/lua/5.1/touch
	install -m 0644 daemonize.lua $(DESTDIR)/usr/share/lua/5.1
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
