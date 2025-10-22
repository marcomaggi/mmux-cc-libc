/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul  9, 2025

  Abstract

	Common facilities for testing.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#undef NDEBUG
#include <assert.h>
#include <mmux-cc-libc.h>

#define BOOL_STRING(BOOL)	((true == BOOL)? "true" : "false")


/** --------------------------------------------------------------------
 ** External declarations.
 ** ----------------------------------------------------------------- */

static mmux_asciizcp_t		PROGNAME;
static mmux_asciizcp_t		CLEANFILES_PATHNAMES_ASCIIZ[16];
static mmux_standard_usize_t	CLEANFILES_PATHNAMES_COUNT = 0;


/** --------------------------------------------------------------------
 ** Prototypes.
 ** ----------------------------------------------------------------- */

void print_newline (void);
void print_error (mmux_asciizcp_t errmsg);
void printf_error (mmux_asciizcp_t errmsg_template, ...);
void printf_string (mmux_asciizcp_t template, ...);
void printf_message (mmux_asciizcp_t template, ...);
void handle_error (void);

void wait_for_some_time (void);

void cleanfiles (void);
void cleanfiles_register (mmux_asciizcp_t pathname_asciiz);
bool test_create_data_file (mmux_asciizcp_t pathname_ascii);


/** --------------------------------------------------------------------
 ** Printing functions.
 ** ----------------------------------------------------------------- */

__attribute__((__nonnull__(1))) void
print_error (mmux_asciizcp_t errmsg)
{
  if (mmux_libc_dprintfer("%s: error: %s\n", PROGNAME, errmsg)) {;};
}
void
print_newline (void)
{
  if (mmux_libc_dprintfer("\n")) {;};
}
__attribute__((__nonnull__(1),__format__(__printf__,1,2))) void
printf_error (mmux_asciizcp_t errmsg_template, ...)
{
  mmux_libc_memfd_t	mfd;

  if (mmux_libc_make_memfd(mfd)) {
    return;
  }
  {
    if (mmux_libc_dprintf(mfd, "%s: error: ", PROGNAME)) {
      return;
    } else {
      bool	rv;
      va_list	ap;

      va_start(ap, errmsg_template);
      {
	rv = mmux_libc_vdprintf(mfd, errmsg_template, ap);
      }
      va_end(ap);
      if (rv) {
	return;
      } else {
	if (mmux_libc_dprintf_newline(mfd)) {
	  return;
	}
      }
    }
    if (mmux_libc_memfd_copyer(mfd)) {
      return;
    }
  }
  if (mmux_libc_close(mfd)) {;};
}
__attribute__((__nonnull__(1),__format__(__printf__,1,2))) void
printf_message (mmux_asciizcp_t template, ...)
{
  mmux_libc_memfd_t	mfd;

  if (mmux_libc_make_memfd(mfd)) {
    return;
  }
  {
    if (mmux_libc_dprintf(mfd, "%s: ", PROGNAME)) {
      return;
    } else {
      bool	rv;
      va_list	ap;

      va_start(ap, template);
      {
	rv = mmux_libc_vdprintf(mfd, template, ap);
      }
      va_end(ap);
      if (rv) {
	return;
      } else {
	if (mmux_libc_dprintf_newline(mfd)) {
	  return;
	}
      }
    }
    if (mmux_libc_memfd_copyer(mfd)) {
      return;
    }
  }
  if (mmux_libc_close(mfd)) {
    return;
  }
}
__attribute__((__nonnull__(1),__format__(__printf__,1,2))) void
printf_string (mmux_asciizcp_t template, ...)
{
  mmux_libc_memfd_t	mfd;

  if (mmux_libc_make_memfd(mfd)) {
    return;
  }
  {
    bool	rv;
    va_list	ap;

    va_start(ap, template);
    {
      rv = mmux_libc_vdprintf(mfd, template, ap);
    }
    va_end(ap);
    if (rv) {
      goto end;
    } else if (mmux_libc_memfd_copyer(mfd)) {
      goto end;
    }
  }
 end:
  if (mmux_libc_close(mfd)) {
    return;
  }
}
__attribute__((__noreturn__)) void
handle_error (void)
{
  mmux_libc_errno_t	errnum;
  mmux_asciizcp_t	errmsg;

  mmux_libc_errno_consume(&errnum);
  if (errnum.value) {
    if (mmux_libc_strerror(&errmsg, errnum)) {
      mmux_libc_exit_failure();
    } else {
      print_error(errmsg);
    }
  }
  mmux_libc_exit_failure();
}


/** --------------------------------------------------------------------
 ** System stuff.
 ** ----------------------------------------------------------------- */

void
wait_for_some_time (void)
{
  mmux_libc_timespec_t	requested_time;
  mmux_libc_timespec_t	remaining_time;
  auto			seconds     = mmux_time(0);
  auto			nanoseconds = mmux_slong(5000000);

  mmux_libc_timespec_set(&requested_time, seconds, nanoseconds);
  if (mmux_libc_nanosleep(&requested_time, &remaining_time)) {
    printf_error("nanosleep");
    handle_error();
  }
}


/** --------------------------------------------------------------------
 ** Files functions.
 ** ----------------------------------------------------------------- */

void
cleanfiles_register (mmux_asciizcp_t pathname_asciiz)
/* Register a file pathname as file to cleanup by "cleanfiles()".*/
{
  CLEANFILES_PATHNAMES_ASCIIZ[CLEANFILES_PATHNAMES_COUNT] = pathname_asciiz;
  printf_message("common: registered cleanfile[%lu]: \"%s\"", CLEANFILES_PATHNAMES_COUNT, pathname_asciiz);
  ++CLEANFILES_PATHNAMES_COUNT;
}
void
cleanfiles (void)
/* Clean all the files registered in "CLEANFILES_PATHNAMES_ASCIIZ[]". */
{
  for (mmux_standard_usize_t i=0; i < CLEANFILES_PATHNAMES_COUNT; ++i) {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;
    mmux_libc_fs_ptn_t		fs_ptn;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, CLEANFILES_PATHNAMES_ASCIIZ[i])) {
      continue;
    } else {
      bool	exists;

      if (mmux_libc_file_system_pathname_exists(&exists, fs_ptn)) {
	continue;
      } else if (exists) {
	printf_message("common: removing existent cleanfile[%lu]: \"%s\"", i, fs_ptn->value);
	if (mmux_libc_remove(fs_ptn)) {
	  printf_error("common: removing \"%s\"", fs_ptn->value);
	}
      } else {
	printf_message("common: unexistent cleanfile[%lu]: \"%s\"", i, fs_ptn->value);
      }
    }
    mmux_libc_unmake_file_system_pathname(fs_ptn);
  }
}

bool
test_create_data_file (mmux_asciizcp_t pathname_asciiz)
{
  mmux_libc_fd_t	fd;

  {
    mmux_libc_fs_ptn_t	fs_ptn;

    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, pathname_asciiz)) {
	handle_error();
      }
    }

    {
      auto const	flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR  | MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL);
      auto const	mode  = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR);

      if (mmux_libc_open(fd, fs_ptn, flags, mode)) {
	handle_error();
      }
    }

    mmux_libc_unmake_file_system_pathname(fs_ptn);
  }

  /* Write data to the source file. */
  {
    mmux_usize_t	nbytes_done;
    //                            01234567890123456789012345678901234567890
    //                            0         1         2         3         4
    mmux_asciizcp_t	bufptr = "0123456789abcdefghilmnopqrstuvz0123456789";
    mmux_usize_t	buflen;

    if (mmux_libc_strlen(&buflen, bufptr)) {
      return true;
    } else if (mmux_libc_write(&nbytes_done, fd, bufptr, buflen)) {
      handle_error();
    } else if (mmux_ctype_not_equal(nbytes_done, buflen)) {
      handle_error();
    }
  }

  if (mmux_libc_close(fd)) {
    handle_error();
  }

  return false;
}

/* end of file */
