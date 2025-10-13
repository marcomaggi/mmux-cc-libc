/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 16, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-time-time";
  }

  /* mmux_libc_time() */
  {
    mmux_time_t		T;
    mmux_libc_memfd_t	fd;

    mmux_libc_time(&T);

    if (mmux_libc_make_memfd(fd)) {
      handle_error();
    } else if (mmux_libc_dprintf(fd, "the time in seconds since the Epoch is: \"")) {
      handle_error();
    } else if (mmux_libc_dprintf_time(fd, T)) {
      handle_error();
    } if (mmux_libc_dprintf(fd, "\"\n")) {
      handle_error();
    } if (mmux_libc_memfd_copyer(fd)) {
      handle_error();
    } else if (mmux_libc_close(fd)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
