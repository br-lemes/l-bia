##  Makefile to build L-Bia docs and htdocs

all: docs

docs: lbdoc.pdf

lbdoc.lout: lbdoc.t2t
lbdoc.pdf: lbdoc.lout
	@lout -PDF -o $@ $^ 2> /dev/null &&\
	echo lout wrote $@

htdocs:
	$(MAKE) -C htdocs

clean:
	$(RM) lbdoc.lout lbdoc.lout.ld lout.li

erase: clean
	$(RM) lbdoc.pdf

.PHONY: all docs htdocs clean clean-target erase

.SUFFIXES: .t2t .lout

.t2t.lout:
	@txt2tags -t lout $<
