/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 15, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_original = "./test-file-system-lstat.original.ext";
static mmux_asciizcp_t	ptn_asciiz_symlink  = "./test-file-system-lstat.symlink.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-lstat";
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

  /* Create the symbolic link. */
  {
    mmux_libc_fs_ptn_t	fs_ptn_original, fs_ptn_symlink;

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

    /* Do it. */
    {
      printf_message("create the symbolic link");
      if (mmux_libc_symlink(fs_ptn_original, fs_ptn_symlink)) {
	printf_error("creating the symbolic link");
	handle_error();
      }
    }

    /* Local cleanup */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn_original);
      mmux_libc_unmake_file_system_pathname(fs_ptn_symlink);
    }
  }

  /* Inspect the symbolic link. */
  {
    mmux_libc_fs_ptn_t	fs_ptn_symlink;

    /* Build the file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn_symlink, fs_ptn_factory, ptn_asciiz_symlink)) {
	handle_error();
      }
    }

    /* Do it. */
    {
      mmux_libc_stat_t	stat;

      printf_message("lstat-ing");
      if (mmux_libc_lstat(fs_ptn_symlink, stat)) {
	printf_error("lstat-ing");
	handle_error();
      } else {
	mmux_libc_fd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_stat_dump(er, stat, NULL)) {
	  handle_error();
	}
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
