/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 17, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-rmdir.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-mkdir";
    cleanfiles_register(ptn_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  {
    mmux_libc_fs_ptn_t	fs_ptn;

    /* Build file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	handle_error();
      }
    }

    /* Create the directory. */
    {
      auto	mode = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR | MMUX_LIBC_S_IXUSR);

      printf_message("mkdir-ing");
      if (mmux_libc_mkdir(fs_ptn, mode)) {
	printf_error("mkdir-ing");
	handle_error();
      }
    }

    /* Do it. */
    {
      printf_message("rmdir-ing");
      if (mmux_libc_rmdir(fs_ptn)) {
	printf_error("rmdir-ing");
	handle_error();
      }
    }

    /* Check directory existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn)) {
	printf_error("exists");
	handle_error();
      } else if (! result) {
	printf_message("mkdir pathname successfully removed");
      } else {
	printf_error("mkdir pathname does NOT removed");
	mmux_libc_exit_failure();
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
