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

check_PROGRAMS	= tests/test-version

mmux_cc_libc_tests_cppflags	= $(AM_CPPFLAGS) -I$(srcdir)/tests
mmux_cc_libc_tests_ldadd	= $(AM_LDFLAGS) libmmux-cc-libc.la

TESTS				= $(check_PROGRAMS)

## ------------------------------------------------------------------------

tests_test_version_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_version_LDADD				= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## errors

check_PROGRAMS	+= \
	tests/test-strerror

tests_test_strerror_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_strerror_LDADD				= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## persona

check_PROGRAMS	+= \
	tests/test-persona-getuid				\
	tests/test-persona-getgid				\
	tests/test-persona-geteuid				\
	tests/test-persona-getegid				\
	tests/test-persona-getgroups				\
	tests/test-persona-getgrouplist				\
	tests/test-persona-setuid				\
	tests/test-persona-seteuid				\
	tests/test-persona-setreuid				\
	tests/test-persona-setgid				\
	tests/test-persona-setegid				\
	tests/test-persona-setregid				\
	tests/test-persona-getlogin				\
	tests/test-persona-getlogin-r				\
	tests/test-persona-getpwuid				\
	tests/test-persona-getpwnam				\
	tests/test-persona-passwd				\
	tests/test-persona-getgrgid				\
	tests/test-persona-getgrnam				\
	tests/test-persona-group				\
	tests/test-persona-group-member

tests_test_persona_getuid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getuid_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getgid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getgid_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_geteuid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_geteuid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getegid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getegid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getgroups_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getgroups_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getgrouplist_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getgrouplist_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_setuid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_setuid_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_seteuid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_seteuid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_setreuid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_setreuid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_setgid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_setgid_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_setegid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_setegid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_setregid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_setregid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getlogin_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getlogin_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getlogin_r_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getlogin_r_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getpwuid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getpwuid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getpwnam_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getpwnam_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_passwd_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_passwd_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getgrgid_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getgrgid_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_getgrnam_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_getgrnam_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_group_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_group_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_persona_group_member_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_persona_group_member_LDADD			= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## processes

check_PROGRAMS	+= \
	tests/test-processes-fork				\
	tests/test-processes-wait				\
	tests/test-processes-wait-any-process			\
	tests/test-processes-wait-group-id			\
	tests/test-processes-wait-my-process-group		\
	tests/test-processes-wait-process-id

tests_test_processes_fork_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_processes_fork_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_processes_wait_any_process_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_processes_wait_any_process_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_processes_wait_my_process_group_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_processes_wait_my_process_group_LDADD	= $(mmux_cc_libc_tests_ldadd)

tests_test_processes_wait_process_id_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_processes_wait_process_id_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_processes_wait_group_id_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_processes_wait_group_id_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_processes_wait_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_processes_wait_LDADD				= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## file descriptors

check_PROGRAMS	+= \
	tests/test-file-descriptors-copy-file-range		\
	tests/test-file-descriptors-fcntl-flock			\
	tests/test-file-descriptors-memfd			\
	tests/test-file-descriptors-open-pwrite-pread-close	\
	tests/test-file-descriptors-open-write-read-close	\
	tests/test-file-descriptors-openat-write-read-close	\
	tests/test-file-descriptors-openat2-write-read-close	\
	tests/test-file-descriptors-preadv-pwritev		\
	tests/test-file-descriptors-preadv2-pwritev2		\
	tests/test-file-descriptors-readv-writev		\
	tests/test-file-descriptors-select			\
	tests/test-file-descriptors-select-fd			\
	tests/test-file-descriptors-struct-flock		\
	tests/test-file-descriptors-struct-iovec		\
	tests/test-file-descriptors-struct-iovec-array		\
	tests/test-file-descriptors-file-size

tests_test_file_descriptors_select_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_select_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_select_fd_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_select_fd_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_open_write_read_close_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_open_write_read_close_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_open_pwrite_pread_close_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_open_pwrite_pread_close_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_openat_write_read_close_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_openat_write_read_close_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_openat2_write_read_close_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_openat2_write_read_close_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_memfd_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_memfd_LDADD					= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_struct_iovec_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_struct_iovec_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_struct_iovec_array_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_struct_iovec_array_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_readv_writev_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_readv_writev_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_preadv_pwritev_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_preadv_pwritev_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_preadv2_pwritev2_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_preadv2_pwritev2_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_copy_file_range_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_copy_file_range_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_struct_flock_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_struct_flock_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_fcntl_flock_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_fcntl_flock_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_file_descriptors_file_size_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_file_descriptors_file_size_LDADD				= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------
## file system

check_PROGRAMS	+= \
	tests/test-file-system-chdir				\
	tests/test-file-system-chown				\
	tests/test-file-system-chownfd				\
	tests/test-file-system-fchdir				\
	tests/test-file-system-fchown				\
	tests/test-file-system-fchownat				\
	tests/test-file-system-fdopendir-readdir-closedir	\
	tests/test-file-system-fstat				\
	tests/test-file-system-fstatat				\
	tests/test-file-system-getcwd				\
	tests/test-file-system-lchown				\
	tests/test-file-system-link				\
	tests/test-file-system-linkat				\
	tests/test-file-system-lstat				\
	tests/test-file-system-mkdir				\
	tests/test-file-system-mkdirat				\
	tests/test-file-system-opendir-readdir-closedir		\
	tests/test-file-system-pathname				\
	tests/test-file-system-pathname-file-size		\
	tests/test-file-system-readlink				\
	tests/test-file-system-readlink-malloc			\
	tests/test-file-system-readlinkat			\
	tests/test-file-system-readlinkat-malloc		\
	tests/test-file-system-readlinkfd			\
	tests/test-file-system-readlinkfd-malloc		\
	tests/test-file-system-remove				\
	tests/test-file-system-rename				\
	tests/test-file-system-renameat				\
	tests/test-file-system-renameat2			\
	tests/test-file-system-rmdir				\
	tests/test-file-system-stat				\
	tests/test-file-system-statfd				\
	tests/test-file-system-symlink				\
	tests/test-file-system-unlink				\
	tests/test-file-system-unlinkat

tests_test_file_system_pathname_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_pathname_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_getcwd_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_getcwd_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_link_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_link_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_linkat_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_linkat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_symlink_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_symlink_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_mkdir_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_mkdir_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_mkdirat_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_mkdirat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_rmdir_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_rmdir_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_unlink_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_unlink_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_unlinkat_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_unlinkat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_remove_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_remove_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_rename_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_rename_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_renameat_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_renameat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_renameat2_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_renameat2_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_readlink_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_readlink_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_readlink_malloc_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_readlink_malloc_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_readlinkat_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_readlinkat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_readlinkat_malloc_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_readlinkat_malloc_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_readlinkfd_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_readlinkfd_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_readlinkfd_malloc_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_readlinkfd_malloc_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_stat_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_stat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_fstat_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_fstat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_lstat_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_lstat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_fstatat_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_fstatat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_statfd_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_statfd_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_pathname_file_size_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_pathname_file_size_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_chown_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_chown_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_fchown_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_fchown_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_lchown_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_lchown_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_fchownat_CPPFLAGS		= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_fchownat_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_chownfd_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_chownfd_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_chdir_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_chdir_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_fchdir_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_fchdir_LDADD			= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_opendir_readdir_closedir_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_opendir_readdir_closedir_LDADD		= $(mmux_cc_libc_tests_ldadd)

tests_test_file_system_fdopendir_readdir_closedir_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_file_system_fdopendir_readdir_closedir_LDADD		= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------

check_PROGRAMS	+= \
	tests/test-interprocess-signals-kill-bub		\
	tests/test-interprocess-signals-kill-pause

tests_test_interprocess_signals_kill_pause_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_interprocess_signals_kill_pause_LDADD	= $(mmux_cc_libc_tests_ldadd)

tests_test_interprocess_signals_kill_bub_CPPFLAGS	= $(mmux_cc_libc_tests_cppflags)
tests_test_interprocess_signals_kill_bub_LDADD		= $(mmux_cc_libc_tests_ldadd)

## ------------------------------------------------------------------------

check_PROGRAMS	+= \
	tests/test-time-time					\
	tests/test-time-localtime				\
	tests/test-time-gmtime					\
	tests/test-time-asctime					\
	tests/test-time-ctime					\
	tests/test-time-mktime					\
	tests/test-time-timegm					\
	tests/test-time-strftime				\
	tests/test-time-strptime

tests_test_time_time_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_time_time_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_localtime_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_time_localtime_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_gmtime_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_time_gmtime_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_asctime_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_time_asctime_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_ctime_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_time_ctime_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_mktime_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_time_mktime_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_timegm_CPPFLAGS				= $(mmux_cc_libc_tests_cppflags)
tests_test_time_timegm_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_strftime_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_time_strftime_LDADD				= $(mmux_cc_libc_tests_ldadd)

tests_test_time_strptime_CPPFLAGS			= $(mmux_cc_libc_tests_cppflags)
tests_test_time_strptime_LDADD				= $(mmux_cc_libc_tests_ldadd)


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
