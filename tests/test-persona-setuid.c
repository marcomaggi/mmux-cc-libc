/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Jul 18, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

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
    PROGNAME = "test-persona-setuid";
  }

  /* Do it. */
  {
    mmux_libc_uid_t	uid;

    if (mmux_libc_getuid(&uid)) {
      handle_error();
    }
    if (mmux_libc_setuid(uid)) {
      handle_error();
    }

    {
      mmux_libc_fd_t	fd;

      mmux_libc_stder(fd);
      if (mmux_libc_dprintfer("the UID is: ")) {
	handle_error();
      }
      if (mmux_libc_dprintf_libc_uid(fd, uid)) {
	handle_error();
      }
      if (mmux_libc_dprintfer_newline()) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
