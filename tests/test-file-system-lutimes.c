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

static mmux_asciizcp_t	ptn_asciiz_original = "./test-file-system-lutimes.original.ext";
static mmux_asciizcp_t	ptn_asciiz_symlink  = "./test-file-system-lutimes.symlink.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-lutimes";
    cleanfiles_register(ptn_asciiz_original);
    cleanfiles_register(ptn_asciiz_symlink);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz_original)) {
      handle_error();
    }
  }

  {
    mmux_libc_fs_ptn_t	fs_ptn_symlink, fs_ptn_original;

    /* Build the file system pathnames. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn_original, fs_ptn_factory, ptn_asciiz_original)) {
	handle_error();
      }
      if (mmux_libc_make_file_system_pathname(fs_ptn_symlink, fs_ptn_factory, ptn_asciiz_symlink)) {
	handle_error();
      }
    }

    /* Make the symbolic link. */
    {
      printf_message("symlink-ing");
      if (mmux_libc_symlink(fs_ptn_original, fs_ptn_symlink)) {
	printf_error("symlink-ing");
	handle_error();
      }
    }

    /* Do it. */
    {
      mmux_libc_timeval_t	access_timeval, modification_timeval;

      /* Initialise the "timeval" values. */
      {
	mmux_time_t	T1, T2;
	auto		microsecs1 = mmux_slong_literal(123);
	auto		microsecs2 = mmux_slong_literal(456);

	mmux_libc_time(&T1);
	mmux_libc_time(&T2);
	mmux_libc_timeval_set(&access_timeval,       T1, microsecs1);
	mmux_libc_timeval_set(&modification_timeval, T2, microsecs2);
      }

      printf_message("lutimes-ing");
      if (mmux_libc_lutimes(fs_ptn_symlink, access_timeval, modification_timeval)) {
	printf_error("lutimes-ing");
	handle_error();
      }

      {
	mmux_libc_oufd_t	fd;

	mmux_libc_stder(fd);
	if (mmux_libc_timeval_dump(fd, &access_timeval, "access_timeval")) {
	  handle_error();
	}
	if (mmux_libc_timeval_dump(fd, &modification_timeval, "modification_timeval")) {
	  handle_error();
	}
      }
    }

    /* Check mode. */
    {
      mmux_libc_stat_t	stat;
      mmux_libc_oufd_t	fd;

      mmux_libc_stder(fd);
      if (mmux_libc_lstat(stat, fs_ptn_symlink)) {
	handle_error();
      } else if (mmux_libc_stat_dump(fd, stat, NULL)) {
	handle_error();
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn_symlink);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
