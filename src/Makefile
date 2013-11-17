##  Makefile to build Lua Buit-In program (L-Bia)

LUA51=lua-5.1.5
LUA52=lua-5.2.2

FPC?=fpc

ifeq ($(shell which $(FPC)),)
$(error Free Pascal Compiler not found, please check $(FPC))
endif

TO:=$(shell $(FPC) -iTO 2>/dev/null)
TP:=$(shell $(FPC) -iTP 2>/dev/null)

ifeq ($(TO),win32)
MYCFLAGS=-DLUA_BUILD_AS_DLL
MYLIBS=
PREFIX=win32
SUFFIX=.exe
LIB=
DLL=.dll
CC=i686-w64-mingw32-gcc
STRIP=i686-w64-mingw32-strip --strip-unneeded
else

ifeq ($(TO),win64)
MYCFLAGS=-DLUA_BUILD_AS_DLL
MYLIBS=
PREFIX=win64
SUFFIX=.exe
LIB=
DLL=.dll
CC=x86_64-w64-mingw32-gcc
STRIP=x86_64-w64-mingw32-strip --strip-unneeded
else

ifeq ($(TO),linux)
MYCFLAGS=-DLUA_USE_POSIX -DLUA_USEDLOPEN -fPIC
MYLIBS=-Wl,-E -ldl
STRIP=strip --strip-unneeded
SUFFIX=
LIB=lib
DLL=.so
ifeq ($(TP),i386)
PREFIX=linux32
CC=gcc -m32
else
ifeq ($(TP),x86_64)
PREFIX=linux64
CC=gcc -m64
else
ifeq ($(TP),arm)
# WARNING: I always use armhf (raspberrypi)
PREFIX=linux-armhf
CC=gcc
else
$(error Unsupported system $(TO)-$(TP))
endif
endif
endif
else
$(error Unsupported system $(TO)-$(TP))
endif
endif
endif

.PHONY: all echo release win32 win64 linux32 linux64 clean erase purge

all: $(PREFIX)/l-bia$(SUFFIX) $(PREFIX)/$(LIB)lua5.1$(DLL) $(PREFIX)/$(LIB)lua52$(DLL)

echo:
	@echo "MYCFLAGS:\t$(MYCFLAGS)"
	@echo "MYLIBS:\t\t$(MYLIBS)"
	@echo "PREFIX:\t\t$(PREFIX)"
	@echo "SUFFIX:\t\t$(SUFFIX)"
	@echo "LIB:\t\t$(LIB)"
	@echo "DLL:\t\t$(DLL)"
	@echo "CC:\t\t$(CC)"
	@echo "STRIP:\t\t$(STRIP)"

release: win32 win64 linux32 linux64

win32:
	$(MAKE) FPC=ppc386.exe

win64:
	$(MAKE) FPC=ppcrossx64.exe

linux32:
	$(MAKE) FPC=ppc386

linux64:
	$(MAKE) FPC=ppcx64

clean:
	$(RM) -f *.o */*.o *.or *.res */*.res */*.or *.ppu */*.ppu *.bak

erase: clean
	$(RM) -f *.exe */*.exe l-bia */l-bia

purge: erase
	$(RM) -rf $(LUA51) $(LUA52) linux-armhf linux32 linux64 win32 win64

distclean: purge
	$(RM) -rf $(LUA51).tar.gz $(LUA52).tar.gz

$(PREFIX)/l-bia$(SUFFIX): l-bia.pas lbaux.pas
	mkdir -p $(PREFIX)
	[ -e $(PREFIX)/l-bia.lua ] || ln -s ../l-bia.lua $(PREFIX)
	$(FPC) -FE$(PREFIX) l-bia

$(PREFIX)/$(LIB)lua5.1$(DLL): $(LUA51)
$(PREFIX)/$(LIB)lua52$(DLL): $(LUA52)
$(PREFIX)/$(LIB)%$(DLL):
	@echo $@ $<
	make -C $</src "MYCFLAGS=$(MYCFLAGS)" MYLDFLAGS=-s "MYLIBS=$(MYLIBS)" \
		"AR=$(CC) -Wl,-E -shared -o" "RANLIB=$(STRIP)" "CC=$(CC)" \
		LUA_A=../../$@ ../../$@
	make -C $</src clean

$(LUA51): $(LUA51).tar.gz
$(LUA52): $(LUA52).tar.gz
%: %.tar.gz
	tar xzf $<
	patch -d $@ -Np1 -i ../../etc/$@.patch
	touch $@

$(LUA51).tar.gz:
$(LUA52).tar.gz:
lua-%.tar.gz:
	wget http://www.lua.org/ftp/$@
