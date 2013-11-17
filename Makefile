##  Makefile to build L-Bia binaries, docs and packages

# L-Bia name and version
LB_NAME=l-bia
LB_VERSION=0.3.3
LB_VERNAME=$(LB_NAME)-$(LB_VERSION)

.PHONY: all docs htdocs clean erase purge distclean pkg-all pkg-src \
	pkg-htdocs pkg-win32 pkg-win64 pkg-linux32 pkg-linux64 pkg-linux-armhf

all:
	@$(MAKE) -C src

docs:
	@$(MAKE) -C doc

htdocs:
	@$(MAKE) -s doc/htdocs

clean:
	@$(MAKE) -C src clean
	@$(MAKE) -C doc clean
	@$(MAKE) -C doc/htdocs clean
	@$(RM) *.tar.bz2

erase:
	@$(MAKE) -C src erase
	@$(MAKE) -C doc erase
	@$(MAKE) -C doc/htdocs erase
	$(RM) *.tar.bz2

purge:
	@$(MAKE) -C src purge
	$(RM) *.tar.bz2

distclean:
	@$(MAKE) -C src purge
	$(RM) *.tar.bz2

# packages

pkg-all: pkg-src pkg-htdocs pkg-win32 pkg-win64 pkg-linux32 pkg-linux64

pkg-src: $(LB_VERNAME).tar.bz2
$(LB_VERNAME).tar.bz2:
	@echo Building $@ package...
	@tar --transform 's#\.#$(LB_VERNAME)#' --exclude=.git \
	--exclude=.gitignore --exclude-from=.gitignore -cf $@ .

pkg-htdocs: htdocs $(LB_VERNAME)-htdocs.tar.bz2
$(LB_VERNAME)-htdocs.tar.bz2:
	@echo Building $@ package...
	@tar --transform 's#\.#$(LB_VERNAME)#' --exclude=doc/htdocs/*.t2t \
	--exclude=doc/htdocs/lbtopbar.html -cf $@ ./doc/htdocs

pkg-win32: docs $(LB_VERNAME)-win32.tar.bz2
$(LB_VERNAME)-win32.tar.bz2:
	@$(MAKE) -C src win32
	@echo Building $@ package...
	@tar --transform 's#.*/#$(LB_VERNAME)/#' -cf $@ \
	doc/lbdoc.pdf src/l-bia.lua src/win32/l-bia.exe src/win32/lua*.dll

pkg-win64: docs $(LB_VERNAME)-win64.tar.bz2
$(LB_VERNAME)-win64.tar.bz2:
	@$(MAKE) -C src win64
	@echo Building $@ package...
	@tar --transform 's#.*/#$(LB_VERNAME)/#' -cf $@ \
	doc/lbdoc.pdf src/l-bia.lua src/win64/l-bia.exe src/win64/lua*.dll

pkg-linux32: docs $(LB_VERNAME)-linux32.tar.bz2
$(LB_VERNAME)-linux32.tar.bz2:
	@$(MAKE) -C src linux32
	@echo Building $@ package...
	@tar --transform 's#.*/#$(LB_VERNAME)/#' -cf $@ \
	doc/lbdoc.pdf src/l-bia.lua src/linux32/l-bia src/linux32/liblua*.so

pkg-linux64: docs $(LB_VERNAME)-linux64.tar.bz2
$(LB_VERNAME)-linux64.tar.bz2:
	@$(MAKE) -C src linux64
	@echo Building $@ package...
	@tar --transform 's#.*/#$(LB_VERNAME)/#' -cf $@ \
	doc/lbdoc.pdf src/l-bia.lua src/linux64/l-bia src/linux64/liblua*.so

pkg-linux-armhf: docs $(LB_VERNAME)-linux-armhf.tar.bz2
$(LB_VERNAME)-linux-armhf.tar.bz2:
	@$(MAKE) -C src linux-armhf
	@echo Building $@ package...
	@tar --transform 's#.*/#$(LB_VERNAME)/#' -cf $@ \
	doc/lbdoc.pdf src/l-bia.lua src/linux-armhf/l-bia src/linux-armhf/liblua*.so
