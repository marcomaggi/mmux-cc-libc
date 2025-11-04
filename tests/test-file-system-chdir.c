/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 20, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-chdir";
  }

  /* mmux_libc_chdir() */
  {
    mmux_asciizcp_t	ptn_asciiz = "..";
    mmux_libc_fs_ptn_t	fs_ptn;

    /* Build file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	handle_error();
      }
    }

    /* Do it. */
    {
      printf_message("changing the current working directory");
      if (mmux_libc_chdir(fs_ptn)) {
	printf_error("changing the current working directory");
	handle_error();
      }
    }

    /* Check the new current working directory. */
    {
      mmux_libc_fs_ptn_t			fs_ptn_cwd;
      mmux_libc_fs_ptn_factory_copying_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
      if (mmux_libc_getcwd(fs_ptn_cwd, fs_ptn_factory)) {
	handle_error();
      } else {
	printf_message("the current working directory is: \"%s\"", fs_ptn_cwd->value);
	mmux_libc_unmake_file_system_pathname(fs_ptn_cwd);
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
