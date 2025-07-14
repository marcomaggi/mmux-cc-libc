/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 14, 2025

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
    PROGNAME			= "test-file-system-pathname";
  }

  {
    mmux_libc_ptn_t	ptn;
    mmux_libc_fd_t	er;

    if (mmux_libc_make_file_system_pathname(&ptn, "/path/to/file.ext")) {
      handle_error();
    }

    mmux_libc_stder(&er);
    if (mmux_libc_dprintf_libc_ptn(er, ptn)) {
      handle_error();
    }
    mmux_libc_dprintfer_newline();
  }

  mmux_libc_exit_success();
}

/* end of file */
