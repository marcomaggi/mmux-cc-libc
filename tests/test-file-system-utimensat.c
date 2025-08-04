/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 22, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc.h>
#include <test-common.h>

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-utimensat.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-utimensat";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(src_pathname_asciiz)) {
      handle_error();
    }
  }

  mmux_libc_ptn_t	ptn;

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, src_pathname_asciiz)) {
    handle_error();
  }

  /* Do it. */
  {
    mmux_libc_fd_t		dirfd;
    mmux_time_t			T1, T2;
    mmux_slong_t		nanosecs1, nanosecs2;
    mmux_libc_timespec_t	access_timespec, modification_timespec;
    mmux_sint_t			flags = MMUX_LIBC_AT_SYMLINK_NOFOLLOW;

    mmux_libc_at_fdcwd(&dirfd);

    mmux_libc_time(&T1);
    mmux_libc_time(&T2);

    nanosecs1 = 123;
    nanosecs2 = 456;

    mmux_libc_timespec_set(&access_timespec,       T1, nanosecs1);
    mmux_libc_timespec_set(&modification_timespec, T2, nanosecs2);

    printf_message("utimensating");
    if (mmux_libc_utimensat(dirfd, ptn, access_timespec, modification_timespec, flags)) {
      handle_error();
    }

    {
      mmux_libc_fd_t	fd;

      mmux_libc_stdou(&fd);
      if (mmux_libc_timespec_dump(fd, &modification_timespec, "access_timespec")) {
	handle_error();
      }
      if (mmux_libc_timespec_dump(fd, &modification_timespec, "modification_timespec")) {
	handle_error();
      }
    }
  }

  /* Check mode. */
  {
    mmux_libc_stat_t	ST[1];
    mmux_libc_fd_t	fd;

    mmux_libc_stder(&fd);
    if (mmux_libc_stat(ptn, ST)) {
      handle_error();
    } else if (mmux_libc_stat_dump(fd, ST, NULL)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
