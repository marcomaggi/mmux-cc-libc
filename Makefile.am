## Process this file with automake to produce Makefile.in

ACLOCAL_AMFLAGS		= -I meta/autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= INSTALL
dist_doc_DATA		= README COPYING
AM_CFLAGS		= $(MMUX_CFLAGS) $(MMUX_CC_TYPES)
AM_CPPFLAGS		= -I$(srcdir)/src/ -I$(builddir)/src/
CLEANFILES		=
DISTCLEANFILES		=
BUILT_SOURCES		=

## --------------------------------------------------------------------

nodist_pkgconfig_DATA	= meta/scripts/mmux-cc-libc.pc


#### GNU m4 macros

EXTRA_DIST		+= \
	$(top_srcdir)/src/m4/macros-for-cc.m4	\
	$(top_srcdir)/src/m4/mmux-cc-libc-config.m4.in

MMUX_M4_FLAGS		=  $(M4FLAGS) --prefix-builtins --include=$(srcdir)/src/m4/
MMUX_M4_FLAGS		+= --include=$(builddir)/src/ --include=$(builddir)/src/m4

# These  are  used  to  preprocess C  language  files  with  extension
# ".c.m4".  Do not change the order of inclusion!!!
#
MMUX_M4_CC_MACROS	= \
	$(top_srcdir)/src/m4/macros-for-cc.m4	\
	$(builddir)/src/m4/mmux-cc-libc-config.m4


#### Automake dirstamp files

MMUX_AM_DIRSTAMP_FILES	=src/m4/$(am__dirstamp)

BUILT_SOURCES		+= $(MMUX_AM_DIRSTAMP_FILES)
DISTCLEANFILES		+= $(MMUX_AM_DIRSTAMP_FILES)

src/m4/$(am__dirstamp):
	@$(MKDIR_P) src/m4/
	@: > $(@)


#### support for GNU Emacs

# if WANT_EMACS
# sharelispdir		= $(datadir)/emacs/site-lisp
# dist_sharelisp_LISP	= src/emacs/mmux-cc-libc.el
# endif


#### documentation

AM_MAKEINFOFLAGS	= --no-split
AM_MAKEINFOHTMLFLAGS	= --split=node -c WORDS_IN_PAGE=0 --css-ref=mmux-cc-libc.css \
	-c PRE_BODY_CLOSE="<p>This document describes version <tt>$(PACKAGE_VERSION)</tt> of <em>$(PACKAGE_NAME)</em>.</p>"

info_TEXINFOS		=  doc/mmux-cc-libc.texi
EXTRA_DIST		+= doc/mmux-cc-libc.style.css
CLEANFILES		+= doc/mmux-cc-libc.css

doc_mmux_cc_libc_TEXINFOS	= \
	doc/macros.texi			\
	doc/overview-linking.texi	\
	doc/mmux-version.texi		\
	doc/gpl-3.0.texi		\
	doc/fdl-1.3.texi

## --------------------------------------------------------------------

doc/mmux-cc-libc.html/$(am__dirstamp): doc/$(am__dirstamp)
	@$(MKDIR_P) doc/mmux-cc-libc.html/
	@: > doc/mmux-cc-libc.html/$(am__dirstamp)

doc/mmux-cc-libc.html/mmux-cc-libc.css: \
	doc/mmux-cc-libc.style.css doc/mmux-cc-libc.html/$(am__dirstamp)
	$(INSTALL) -m 0444 "$(top_srcdir)/doc/mmux-cc-libc.style.css" "$(builddir)/doc/mmux-cc-libc.html/mmux-cc-libc.css"

## --------------------------------------------------------------------

html-local: doc/mmux-cc-libc.html/mmux-cc-libc.css

install-html-local:
	$(MKDIR_P) "$(DESTDIR)$(htmldir)/mmux-cc-libc.html/"
	$(INSTALL) -m 0444 $(builddir)/doc/mmux-cc-libc.html/mmux-cc-libc.css "$(DESTDIR)$(htmldir)/mmux-cc-libc.html/"


#### libraries

EXTRA_DIST	+= \
	src/mmux-cc-libc.h.m4				\
	src/mmux-cc-libc-internals.h.m4			\
	src/mmux-cc-libc-constants.h.m4			\
	src/mmux-cc-libc-functions.h.m4			\
	src/mmux-cc-libc-characters.c.m4		\
	src/mmux-cc-libc-errors.c.m4			\
	src/mmux-cc-libc-file-descriptors.c.m4		\
	src/mmux-cc-libc-file-system.c.m4		\
	src/mmux-cc-libc-library.c.m4			\
	src/mmux-cc-libc-memory.c.m4			\
	src/mmux-cc-libc-persona.c.m4			\
	src/mmux-cc-libc-processes.c.m4			\
	src/mmux-cc-libc-signals.c.m4			\
	src/mmux-cc-libc-sockets.c.m4			\
	src/mmux-cc-libc-strings.c.m4			\
	src/mmux-cc-libc-system-configuration.c.m4	\
	src/mmux-cc-libc-time.c.m4

MMUX_CC_LIBC_BUILT_SOURCES	= \
	src/mmux-cc-libc.h				\
	src/mmux-cc-libc-internals.h			\
	src/mmux-cc-libc-constants.h			\
	src/mmux-cc-libc-functions.h			\
	src/mmux-cc-libc-characters.c			\
	src/mmux-cc-libc-errors.c			\
	src/mmux-cc-libc-file-descriptors.c		\
	src/mmux-cc-libc-file-system.c			\
	src/mmux-cc-libc-library.c			\
	src/mmux-cc-libc-memory.c			\
	src/mmux-cc-libc-persona.c			\
	src/mmux-cc-libc-processes.c			\
	src/mmux-cc-libc-signals.c			\
	src/mmux-cc-libc-sockets.c			\
	src/mmux-cc-libc-strings.c			\
	src/mmux-cc-libc-system-configuration.c		\
	src/mmux-cc-libc-time.c

BUILT_SOURCES	+= $(MMUX_CC_LIBC_BUILT_SOURCES)
CLEANFILES	+= $(MMUX_CC_LIBC_BUILT_SOURCES)
DISTCLEANFILES	+= $(MMUX_CC_LIBC_BUILT_SOURCES)

mmux_cc_libc_CURRENT		= @mmux_cc_libc_VERSION_INTERFACE_CURRENT@
mmux_cc_libc_REVISION		= @mmux_cc_libc_VERSION_INTERFACE_REVISION@
mmux_cc_libc_AGE		= @mmux_cc_libc_VERSION_INTERFACE_AGE@
mmux_cc_libc_LINKER_VERSION	= -version-info $(mmux_cc_libc_CURRENT):$(mmux_cc_libc_REVISION):$(mmux_cc_libc_AGE)

include_HEADERS				= \
	src/mmux-cc-libc.h			\
	src/mmux-cc-libc-config.h		\
	src/mmux-cc-libc-constants.h		\
	src/mmux-cc-libc-functions.h

lib_LTLIBRARIES			= libmmux-cc-libc.la
libmmux_cc_libc_la_CPPFLAGS	= $(AM_CPPFLAGS) -I$(builddir)/src
libmmux_cc_libc_la_CFLAGS	= $(AM_CFLAGS) $(BASH_CFLAGS)
libmmux_cc_libc_la_LDFLAGS	= $(mmux_cc_libc_LINKER_VERSION) $(AM_LDFLAGS)
libmmux_cc_libc_la_LIBADD	= $(MMUX_CC_TYPES_LIBS)
libmmux_cc_libc_la_SOURCES	= \
	src/mmux-cc-libc.h				\
	src/mmux-cc-libc-config.h			\
	src/mmux-cc-libc-internals.h			\
	src/mmux-cc-libc-constants.h			\
	src/mmux-cc-libc-functions.h			\
	src/mmux-cc-libc-characters.c			\
	src/mmux-cc-libc-errors.c			\
	src/mmux-cc-libc-file-descriptors.c		\
	src/mmux-cc-libc-file-system.c			\
	src/mmux-cc-libc-library.c			\
	src/mmux-cc-libc-memory.c			\
	src/mmux-cc-libc-persona.c			\
	src/mmux-cc-libc-processes.c			\
	src/mmux-cc-libc-signals.c			\
	src/mmux-cc-libc-sockets.c			\
	src/mmux-cc-libc-strings.c			\
	src/mmux-cc-libc-system-configuration.c		\
	src/mmux-cc-libc-time.c

.PHONY: library

library: libmmux-cc-libc.la

src/%.h: src/%.h.m4 $(MMUX_M4_CC_MACROS)
	$(M4_PROGRAM) $(MMUX_M4_FLAGS) $(MMUX_M4_CC_MACROS) $< >$@

src/%.c: src/%.c.m4 $(MMUX_M4_CC_MACROS)
	$(M4_PROGRAM) $(MMUX_M4_FLAGS) $(MMUX_M4_CC_MACROS) $< >$@

src/%.$(OBJEXT): \
	src/mmux-cc-libc-internals.h		\
	src/mmux-cc-libc-constants.h		\
	src/mmux-cc-libc-functions.h		\
	src/mmux-cc-libc-config.h


#### TESTS

EXTRA_DIST	+= tests/test-common.h

check_PROGRAMS	= \
	tests/test-version				\
	tests/test-strerror				\
	\
	tests/test-fork					\
	tests/test-wait					\
	tests/test-wait-any-process			\
	tests/test-wait-group-id			\
	tests/test-wait-my-process-group		\
	tests/test-wait-process-id			\
	\
	tests/test-select				\
	tests/test-select-fd				\
	\
	tests/test-copy-file-range			\
	tests/test-fcntl-flock				\
	tests/test-memfd				\
	tests/test-open-pwrite-pread-close		\
	tests/test-open-write-read-close		\
	tests/test-openat-write-read-close		\
	tests/test-openat2-write-read-close		\
	tests/test-preadv-pwritev			\
	tests/test-preadv2-pwritev2			\
	tests/test-readv-writev				\
	tests/test-struct-flock				\
	tests/test-struct-iovec				\
	tests/test-struct-iovec-array			\
	\
	tests/test-file-system-pathname			\
	\
	tests/test-interprocess-signals-kill-pause	\
	tests/test-interprocess-signals-kill-bub

mmux_cc_libc_tests_cppflags	= $(AM_CPPFLAGS) -I$(srcdir)/tests
mmux_cc_libc_tests_ldadd	= $(AM_LDFLAGS) libmmux-cc-libc.la

TESTS				= $(check_PROGRAMS)

## ------------------------------------------------------------------------

tests_test_version_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_version_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_strerror_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_strerror_LDADD			= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## processes

tests_test_fork_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_fork_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_wait_any_process_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_wait_any_process_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_wait_my_process_group_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_wait_my_process_group_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_wait_process_id_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_wait_process_id_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_wait_group_id_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_wait_group_id_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_wait_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_wait_LDADD				= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## waiting for input/output

tests_test_select_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_select_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_select_fd_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_select_fd_LDADD			= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## file descriptors

tests_test_open_write_read_close_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_open_write_read_close_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_open_pwrite_pread_close_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_open_pwrite_pread_close_LDADD	= $(mmux_cc_libc_tests_ldadd)

tests_test_openat_write_read_close_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_openat_write_read_close_LDADD	= $(mmux_cc_libc_tests_ldadd)

tests_test_openat2_write_read_close_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_openat2_write_read_close_LDADD	= $(mmux_cc_libc_tests_ldadd)

tests_test_memfd_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_memfd_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_struct_iovec_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_struct_iovec_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_struct_iovec_array_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_struct_iovec_array_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_readv_writev_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_readv_writev_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_preadv_pwritev_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_preadv_pwritev_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_preadv2_pwritev2_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_preadv2_pwritev2_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_copy_file_range_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_copy_file_range_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_struct_flock_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_struct_flock_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_fcntl_flock_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_fcntl_flock_LDADD			= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------

tests_test_file_system_pathname_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_pathname_LDADD		= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------

tests_test_interprocess_signals_kill_pause_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_interprocess_signals_kill_pause_LDADD	= $(mmux_cc_libc_tests_ldadd)

tests_test_interprocess_signals_kill_bub_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_interprocess_signals_kill_bub_LDADD		= $(mmux_cc_libc_tests_ldadd)


#### interface to "make installcheck"

installcheck-local: $(TESTS)
	@RV=0										      ;\
	for FILE in $(TESTS)								      ;\
	do echo "make installcheck: running: '$(builddir)/$$FILE'"			      ;\
	    if "$(builddir)/$$FILE"							      ;\
	    then :									      ;\
	    else RV=$$?									      ;\
		echo "make installcheck: test file '$(builddir)/$$FILE' exit status: $$RV"    ;\
	        if test "$$RV" != 77; then break; fi					      ;\
	    fi										      ;\
	done										      ;\
	if test "$$RV" = 77; then exit 0; else exit $$RV; fi				      ;


#### common rules

include $(top_srcdir)/meta/automake/mmux-makefile-rules

### end of file
