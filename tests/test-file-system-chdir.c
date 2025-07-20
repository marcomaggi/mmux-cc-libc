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
    PROGNAME = "test-file-system-chdir";
  }

  /* mmux_libc_chdir() */
  {
    mmux_libc_file_system_pathname_t	ptn;

    if (mmux_libc_make_file_system_pathname(&ptn, "..")) {
      handle_error();
    } else {
      printf_message("changing the current working directory");
      if (mmux_libc_chdir(ptn)) {
	handle_error();
      } else {
	mmux_libc_file_system_pathname_t	new_ptn;

	if (mmux_libc_getcwd_pathname(&new_ptn)) {
	  handle_error();
	} else {
	  printf_message("the current working directory is: \"%s\"", new_ptn.value);
	  mmux_libc_file_system_pathname_free(new_ptn);
	}
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
