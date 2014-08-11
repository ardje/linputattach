ALL: serial/attach.so

serial/attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.2 --cflags) -llua5.2 -o $@

rsync: serial/attach.so
	rsync -va touch serial daemonize.lua linputattach 192.168.0.175::root/root/inputattach/

install:
	install -d $(DESTDIR)/usr/share/lua/5.2/touch
	install -m 0444 daemonize.lua $(DESTDIR)/usr/share/lua/5.2
	install -m 0444 touch/* $(DESTDIR)/usr/share/lua/5.2/touch
	

.PHONY: install
