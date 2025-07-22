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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-futimes.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-futimes";
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
  mmux_libc_fd_t	fd;

  if (mmux_libc_make_file_system_pathname(&ptn, src_pathname_asciiz)) {
    handle_error();
  }

  /* Open the file. */
  {
    mmux_sint_t		flags = MMUX_LIBC_O_RDONLY;
    mmux_mode_t		mode  = 0;

    printf_message("open the data file");
    if (mmux_libc_open(&fd, ptn, flags, mode)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_time_t			T1, T2;
    mmux_slong_t		microsecs1, microsecs2;
    mmux_libc_timeval_t		access_timeval, modification_timeval;

    mmux_libc_time(&T1);
    mmux_libc_time(&T2);

    microsecs1 = 123;
    microsecs2 = 456;

    mmux_libc_timeval_set(&access_timeval,       T1, microsecs1);
    mmux_libc_timeval_set(&modification_timeval, T2, microsecs2);

    printf_message("futimesing");
    if (mmux_libc_futimes(fd, access_timeval, modification_timeval)) {
      handle_error();
    }

    {
      mmux_libc_fd_t	er;

      mmux_libc_stdou(&er);
      if (mmux_libc_timeval_dump(er, &modification_timeval, "access_timeval")) {
	handle_error();
      }
      if (mmux_libc_timeval_dump(er, &modification_timeval, "modification_timeval")) {
	handle_error();
      }
    }
  }

  /* Check mode. */
  {
    mmux_libc_stat_t	ST[1];
    mmux_libc_fd_t	er;

    mmux_libc_stder(&er);
    if (mmux_libc_stat(ptn, ST)) {
      handle_error();
    } else if (mmux_libc_stat_dump(er, ST, NULL)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
