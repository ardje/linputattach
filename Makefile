ALL: binary
LIBDEST=/usr/lib/$(shell uname -m)-linux-gnu

binary: attach.so
.PHONY: binary

attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config $(LUA) --cflags) -l$(LUA) -o $@

clean:
	-rm -f *.so
.PHONY: clean

install:
	install -d $(LUA_LIBDIR)/serial
	install -m 0644 attach.so $(LUA_LIBDIR)/serial
	install -d $(DESTDIR)/etc/linputattach
	install -d $(DESTDIR)/usr/bin
	install -m 0755 linputattach $(DESTDIR)/usr/bin

.PHONY: install
