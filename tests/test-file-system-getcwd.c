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

#include <mmux-cc-libc.h>
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

  /* mmux_libc_getcwd() */
  {
    mmux_usize_t	buflen = 4096;
    mmux_char_t		bufptr[buflen];

    printf_message("getting the current working directory: mmux_libc_getcwd");
    if (mmux_libc_getcwd(bufptr, buflen)) {
      handle_error();
    } else {
      printf_message("the current working directory is: \"%s\"", bufptr);
    }
  }

  /* mmux_libc_getcwd_malloc() */
  {
    mmux_asciizcp_t	bufptr;

    printf_message("getting the current working directory: mmux_libc_getcwd_malloc");
    if (mmux_libc_getcwd_malloc(&bufptr)) {
      handle_error();
    } else {
      printf_message("the current working directory is: \"%s\"", bufptr);
      mmux_libc_free((mmux_pointer_t)bufptr);
    }
  }

  /* mmux_libc_getcwd_pathname() */
  {
    mmux_libc_file_system_pathname_t	ptn;

    printf_message("getting the current working directory: mmux_libc_getcwd_pathname");
    if (mmux_libc_getcwd_pathname(&ptn)) {
      handle_error();
    } else {
      printf_message("the current working directory is: \"%s\"", ptn.value);
      mmux_libc_file_system_pathname_free(ptn);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
