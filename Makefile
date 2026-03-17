ifeq ($(OS),Windows_NT)
$(error Windows is not supported)
endif

HOMEPAGE_URL := https://github.com/oWretch/tree-sitter-bicep
VERSION := 1.1.0

TS ?= tree-sitter

# install directory layout
PREFIX ?= /usr/local
INCLUDEDIR ?= $(PREFIX)/include
LIBDIR ?= $(PREFIX)/lib
PCLIBDIR ?= $(LIBDIR)/pkgconfig

# flags
ARFLAGS ?= rcs
override CFLAGS += -std=c11 -fPIC

ifneq ($(filter $(shell uname),FreeBSD NetBSD DragonFly),)
	PCLIBDIR := $(PREFIX)/libdata/pkgconfig
endif

# OS-specific bits
ifeq ($(shell uname),Darwin)
	SOEXT = dylib
else
	SOEXT = so
endif

define build_parser
LANGUAGE_NAME_$(1) := tree-sitter-$(1)
SRC_DIR_$(1) := $(2)/src

PARSER_$(1) := $$(SRC_DIR_$(1))/parser.c
EXTRAS_$(1) := $$(filter-out $$(PARSER_$(1)),$$(wildcard $$(SRC_DIR_$(1))/*.c))
OBJS_$(1) := $$(patsubst %.c,%.o,$$(PARSER_$(1)) $$(EXTRAS_$(1)))

SONAME_MAJOR_$(1) = $$(shell sed -n 's/\#define LANGUAGE_VERSION //p' $$(PARSER_$(1)))
SONAME_MINOR_$(1) = $$(word 1,$$(subst ., ,$$(VERSION)))

ifeq ($$(shell uname),Darwin)
	SOEXTVER_MAJOR_$(1) = $$(SONAME_MAJOR_$(1)).$$(SOEXT)
	SOEXTVER_$(1) = $$(SONAME_MAJOR_$(1)).$$(SONAME_MINOR_$(1)).$$(SOEXT)
	LINKSHARED_$(1) = -dynamiclib -Wl,-install_name,$$(LIBDIR)/lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_$(1)),-rpath,@executable_path/../Frameworks
else
	SOEXTVER_MAJOR_$(1) = $$(SOEXT).$$(SONAME_MAJOR_$(1))
	SOEXTVER_$(1) = $$(SOEXT).$$(SONAME_MAJOR_$(1)).$$(SONAME_MINOR_$(1))
	LINKSHARED_$(1) = -shared -Wl,-soname,lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_$(1))
endif

$$(SRC_DIR_$(1))/%.o: $$(SRC_DIR_$(1))/%.c
	$$(CC) $$(CFLAGS) -I$$(SRC_DIR_$(1)) -c $$< -o $$@

lib$$(LANGUAGE_NAME_$(1)).a: $$(OBJS_$(1))
	$$(AR) $$(ARFLAGS) $$@ $$^

lib$$(LANGUAGE_NAME_$(1)).$$(SOEXT): $$(OBJS_$(1))
	$$(CC) $$(LDFLAGS) $$(LINKSHARED_$(1)) $$^ $$(LDLIBS) -o $$@
ifneq ($$(STRIP),)
	$$(STRIP) $$@
endif

$$(LANGUAGE_NAME_$(1)).pc: bindings/c/$$(LANGUAGE_NAME_$(1)).pc.in
	sed -e 's|@PROJECT_VERSION@|$$(VERSION)|' \
		-e 's|@CMAKE_INSTALL_LIBDIR@|$$(LIBDIR:$$(PREFIX)/%=%)|' \
		-e 's|@CMAKE_INSTALL_INCLUDEDIR@|$$(INCLUDEDIR:$$(PREFIX)/%=%)|' \
		-e 's|@PROJECT_DESCRIPTION@|$$(DESCRIPTION)|' \
		-e 's|@PROJECT_HOMEPAGE_URL@|$$(HOMEPAGE_URL)|' \
		-e 's|@CMAKE_INSTALL_PREFIX@|$$(PREFIX)|' $$< > $$@

ALL_LIBS += lib$$(LANGUAGE_NAME_$(1)).a lib$$(LANGUAGE_NAME_$(1)).$$(SOEXT) $$(LANGUAGE_NAME_$(1)).pc
ALL_OBJS += $$(OBJS_$(1))
ALL_INSTALL += install-$(1)
ALL_UNINSTALL += uninstall-$(1)

install-$(1): lib$$(LANGUAGE_NAME_$(1)).a lib$$(LANGUAGE_NAME_$(1)).$$(SOEXT) $$(LANGUAGE_NAME_$(1)).pc
	install -d '$$(DESTDIR)$$(INCLUDEDIR)'/tree_sitter '$$(DESTDIR)$$(PCLIBDIR)' '$$(DESTDIR)$$(LIBDIR)'
	install -m644 bindings/c/$$(LANGUAGE_NAME_$(1)).h '$$(DESTDIR)$$(INCLUDEDIR)'/tree_sitter/$$(LANGUAGE_NAME_$(1)).h
	install -m644 $$(LANGUAGE_NAME_$(1)).pc '$$(DESTDIR)$$(PCLIBDIR)'/$$(LANGUAGE_NAME_$(1)).pc
	install -m644 lib$$(LANGUAGE_NAME_$(1)).a '$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).a
	install -m755 lib$$(LANGUAGE_NAME_$(1)).$$(SOEXT) '$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_$(1))
	ln -sf lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_$(1)) '$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_MAJOR_$(1))
	ln -sf lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_MAJOR_$(1)) '$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).$$(SOEXT)

uninstall-$(1):
	$$(RM) '$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).a \
		'$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_$(1)) \
		'$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).$$(SOEXTVER_MAJOR_$(1)) \
		'$$(DESTDIR)$$(LIBDIR)'/lib$$(LANGUAGE_NAME_$(1)).$$(SOEXT) \
		'$$(DESTDIR)$$(INCLUDEDIR)'/tree_sitter/$$(LANGUAGE_NAME_$(1)).h \
		'$$(DESTDIR)$$(PCLIBDIR)'/$$(LANGUAGE_NAME_$(1)).pc

endef

$(eval $(call build_parser,bicep,bicep))
$(eval $(call build_parser,bicep-params,bicep_params))

all: $(ALL_LIBS)

install: $(ALL_INSTALL)

uninstall: $(ALL_UNINSTALL)

clean:
	$(RM) $(ALL_OBJS) $(ALL_LIBS)

test:
	cd bicep && $(TS) test
	cd bicep_params && $(TS) test

.PHONY: all install uninstall clean test
