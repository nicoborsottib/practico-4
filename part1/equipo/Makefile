obj-m += equipo.o

KDIR ?= /lib/modules/$(shell uname -r)/build

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean

# Firma el .ko con la clave MOK (ver Parte 3 de GUIA.md)
firmar: all
	../../scripts/firmar.sh equipo.ko
