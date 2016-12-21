#
# $Id: Makefile 358 2005-05-04 12:46:02Z paul $
#

PKG_NAME=sem
PKG_PREFIX=ocaml-
DOCROOT=/usr/local/share/doc

OCAMLMAKEFILE=OCamlMakefile

SOURCES	= sem_stubs.c \
	  sem.mli \
	  sem.ml

RESULT= sem

PACKS= unix

ANNOTATE = yes

CFLAGS+=-g -O2 -fPIC -DPIC -Wall -Wno-unused
OCAMLDOCFLAGS+=-stars -intro intro.mldoc -colorize-code -t "OCaml-Sem" -css-style style.css

all: bcl ncl docs

install: libinstall

uninstall: libuninstall

docuninstall:
	rm -rf $(DOCROOT)/$(PKG_PREFIX)$(PKG_NAME)

clean: docclean

docclean:
	rm -rf doc

tests:
	gmake -f test.mk

docs: htdoc installcss

installcss: style.css
	cp style.css doc/html

include $(OCAMLMAKEFILE)
