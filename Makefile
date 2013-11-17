##  Makefile to build L-Bia binaries, docs and packages

# L-Bia name and version
LB_NAME=l-bia
LB_VERSION=0.3.2

all: release docs

release:
	@$(MAKE) -sC src release

docs:
	@$(MAKE) -sC doc

clean:
	@$(MAKE) -sC src clean
	@$(MAKE) -sC doc clean
	@$(MAKE) -sC doc/htdocs clean
	
erase:
	@$(MAKE) -sC src erase
	@$(MAKE) -sC doc erase
	@$(MAKE) -sC doc/htdocs erase

# packages

LB_SFILES=HISTORY  LICENSE  Makefile  README  doc  src
LB_HFILES=index.html license.html history.html lbstyle.css lblogo.png \
          luapowered-white.png gnubanner-2.png t2tpowered-white.png
LB_BFILES=doc/lbdoc.pdf src/l-bia.lua

pkg-all: pkg-src pkg-htdocs pkg-w32 pkg-w64 pkg-linux32 pkg-linux64

LB_SRC=$(LB_NAME)-$(LB_VERSION)
pkg-src: erase
	@echo Building $(LB_SRC).tar.bz2 package...
	@mkdir $(LB_SRC)
	@cp -r $(LB_SFILES) $(LB_SRC)
	@tar cjf ../$(LB_SRC).tar.bz2 $(LB_SRC) --exclude=*.so --exclude=*.dll
	@rm -rf $(LB_SRC)

LB_HTDOCS=$(LB_NAME)-$(LB_VERSION)-htdocs
pkg-htdocs:
	@echo Building $(LB_HTDOCS).zip package...
	@mkdir $(LB_HTDOCS)
	@cd doc/htdocs && $(MAKE) -s && cp $(LB_HFILES) ../../$(LB_HTDOCS)
	@zip -q -9 -r ../$(LB_HTDOCS).zip $(LB_HTDOCS)
	@rm -rf $(LB_HTDOCS)

LB_W32=$(LB_NAME)-$(LB_VERSION)-w32
pkg-w32: release docs
	@echo Building $(LB_W32).zip package...
	@mkdir $(LB_W32)
	@cp -r $(LB_BFILES) $(LB_W32)
	@cp src/l-bia-w32.exe $(LB_W32)/l-bia.exe
	@zip -q -9 -r ../$(LB_W32).zip $(LB_W32)
	@rm -rf $(LB_W32)

LB_W64=$(LB_NAME)-$(LB_VERSION)-w64
pkg-w64: release docs
	@echo Building $(LB_W64).zip package...
	@mkdir $(LB_W64)
	@cp -r $(LB_BFILES) $(LB_W64)
	@cp src/l-bia-w64.exe $(LB_W64)/l-bia.exe
	@zip -q -9 -r ../$(LB_W64).zip $(LB_W64)
	@rm -rf $(LB_W64)

LB_LINUX32=$(LB_NAME)-$(LB_VERSION)-linux32
pkg-linux32: release docs
	@echo Building $(LB_LINUX32).tar.bz2 package...
	@mkdir $(LB_LINUX32)
	@cp -r $(LB_BFILES) $(LB_LINUX32)
	@cp src/l-bia-linux32 $(LB_LINUX32)/l-bia
	@tar cjf ../$(LB_LINUX32).tar.bz2 $(LB_LINUX32)
	@rm -rf $(LB_LINUX32)

LB_LINUX64=$(LB_NAME)-$(LB_VERSION)-linux64
pkg-linux64: release docs
	@echo Building $(LB_LINUX64).tar.bz2 package...
	@mkdir $(LB_LINUX64)
	@cp -r $(LB_BFILES) $(LB_LINUX64)
	@cp src/l-bia-linux64 $(LB_LINUX64)/l-bia
	@tar cjf ../$(LB_LINUX64).tar.bz2 $(LB_LINUX64)
	@rm -rf $(LB_LINUX64)

.PHONY: all release docs clean erase pkg-all pkg-src pkg-htdocs pkg-w32 pkg-w64 pkg-linux32 pkg-linux64
