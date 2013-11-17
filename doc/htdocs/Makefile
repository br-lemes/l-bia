##  Makefile to build L-Bia htdocs

HTDOCS=license.html history.html index.html

all: htdocs

htdocs: $(HTDOCS)

license.html: license.t2t ../../LICENSE lbtopbar.html ../config
history.html: history.t2t ../../HISTORY lbtopbar.html ../config
index.html: index.t2t ../../README lbtopbar.html ../config

clean:
	$(RM) $(HTDOCS)

erase: clean

.PHONY: all htdocs clean erase

.SUFFIXES: .t2t .html

.t2t.html:
	@txt2tags -t html $<
