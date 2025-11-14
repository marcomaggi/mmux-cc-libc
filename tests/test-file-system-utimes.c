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

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-utimes.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-utimes";
    cleanfiles_register(ptn_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz)) {
      handle_error();
    }
  }

  {
    mmux_libc_fs_ptn_t	fs_ptn;

    /* Build the file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	handle_error();
      }
    }

    /* Do it. */
    {
      mmux_libc_timeval_t	access_timeval, modification_timeval;

      {
	mmux_time_t	T1, T2;
	auto		microsecs1 = mmux_slong_literal(123);
	auto		microsecs2 = mmux_slong_literal(456);

	mmux_libc_time(&T1);
	mmux_libc_time(&T2);
	mmux_libc_timeval_set(access_timeval,       T1, microsecs1);
	mmux_libc_timeval_set(modification_timeval, T2, microsecs2);
      }

      printf_message("utimes-ing");
      if (mmux_libc_utimes(fs_ptn, access_timeval, modification_timeval)) {
	printf_error("utimes-ing");
	handle_error();
      }

      {
	mmux_libc_oufd_t	fd;

	mmux_libc_stder(fd);
	if (mmux_libc_timeval_dump(fd, modification_timeval, "access_timeval")) {
	  handle_error();
	}
	if (mmux_libc_timeval_dump(fd, modification_timeval, "modification_timeval")) {
	  handle_error();
	}
      }
    }

    /* Check mode. */
    {
      mmux_libc_stat_t	stat;
      mmux_libc_oufd_t	fd;

      mmux_libc_stder(fd);
      if (mmux_libc_stat(stat, fs_ptn)) {
	handle_error();
      } else if (mmux_libc_stat_dump(fd, stat, NULL)) {
	handle_error();
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
