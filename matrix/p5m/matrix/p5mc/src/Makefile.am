## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = p5mc.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(P5MC_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = p5mc

p5mc_SOURCES = \
	main.c \
	p5mc.h \
	p5mc.c	


p5mc_LDFLAGS =

p5mc_LDADD = $(P5MC_LIBS)


if PLATFORM_WIN32
p5mc_LDFLAGS += -Wl,--export-all-symbols
else
p5mc_LDFLAGS += -Wl,--export-dynamic
endif

if NATIVE_WIN32
p5mc_LDFLAGS += -mwindows
endif


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

