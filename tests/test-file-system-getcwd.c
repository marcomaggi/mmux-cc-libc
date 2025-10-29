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
    PROGNAME = "test-file-system-getcwd";
  }

  /* mmux_libc_getcwd_to_buffer() */
  {
    auto	buflen = mmux_usize_literal(4096);
    char	bufptr[buflen.value];

    printf_message("getting the current working directory: mmux_libc_getcwd_to_buffer");
    if (mmux_libc_getcwd_to_buffer(bufptr, buflen)) {
      handle_error();
    } else {
      printf_message("the current working directory is: \"%s\"", bufptr);
    }
  }

  /* mmux_libc_getcwd() */
  {
    mmux_libc_fs_ptn_t		fs_ptn;

    /* Build the file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);

      printf_message("getting the current working directory: mmux_libc_getcwd");
      if (mmux_libc_getcwd(fs_ptn, fs_ptn_factory)) {
	handle_error();
      }
    }

    {
      printf_message("the current working directory is: \"%s\"", fs_ptn->value);
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
