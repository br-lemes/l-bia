##  Makefile to build Lua Buit-In program (L-Bia)

ifndef FPC
FPC=fpc
endif

all: l-bia$(SUFFIX)

release: win32 win64 linux32 linux64

win32:
	@$(MAKE) FPC=ppc386.exe SUFFIX=-w32.exe

win64:
	@$(MAKE) FPC=ppcrossx64.exe SUFFIX=-w64.exe

linux32:
	@$(MAKE) FPC=ppc386 SUFFIX=-linux32

linux64:
	@$(MAKE) FPC=ppcx64 SUFFIX=-linux64

l-bia$(SUFFIX): l-bia.pas lbaux.pas
	@$(FPC) l-bia -o$@

clean:
	$(RM) -f *.o *.ppu *.bak

erase: clean
	$(RM) -f *.exe l-bia l-bia-*

.PHONY: all release win32 win64 linux32 linux64 clean erase
