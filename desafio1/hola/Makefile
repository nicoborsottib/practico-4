# checkinstall corre `make install` y registra en un .deb cada archivo que se copia.
PREFIX ?= /usr/local
CFLAGS ?= -Wall -O2

all: hola-sdc

hola-sdc: hola.c
	$(CC) $(CFLAGS) -o $@ $<

install: hola-sdc
	install -D -m 755 hola-sdc $(DESTDIR)$(PREFIX)/bin/hola-sdc

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/hola-sdc

clean:
	rm -f hola-sdc *.deb *.tgz description-pak

.PHONY: all install uninstall clean
