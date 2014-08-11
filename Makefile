ALL: serial/attach.so

serial/attach.so: attach.c
	$(CC) -Wall $^ -shared -fpic $(shell pkg-config lua5.2 --cflags) -llua5.2 -o $@

install: serial/attach.so
	rsync -va touch/ serial/ daemonize.lua linputattach 192.168.0.175::root/inputattach/
	

.PHONY: install
