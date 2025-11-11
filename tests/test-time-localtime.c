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
    PROGNAME = "test-time-localtime";
  }

  /* mmux_libc_localtime() */
  {
    mmux_time_t		T;
    mmux_libc_tm_t *	BT;
    mmux_libc_oufd_t	fd;

    mmux_libc_time(&T);
    mmux_libc_localtime(&BT, T);

    mmux_libc_stder(fd);
    if (mmux_libc_tm_dump(fd, BT, NULL)) {
      handle_error();
    }
  }

  /* mmux_libc_localtime_r() */
  {
    mmux_time_t		T;
    mmux_libc_tm_t	BT[1];
    mmux_libc_oufd_t	fd;

    mmux_libc_time(&T);
    mmux_libc_localtime_r(BT, T);

    mmux_libc_stder(fd);
    if (mmux_libc_tm_dump(fd, BT, NULL)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
