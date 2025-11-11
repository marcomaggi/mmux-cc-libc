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
    PROGNAME = "test-time-mktime";
  }

  /* mmux_libc_mktime() */
  {
    mmux_time_t		T1, T2;
    mmux_libc_tm_t	BT[1];

    mmux_libc_time(&T1);
    mmux_libc_localtime_r(BT, T1);
    mmux_libc_mktime(&T2, BT);
    {
      mmux_libc_memfd_t	fd;

      if (mmux_libc_make_memfd(fd)) {
	handle_error();
      } else if (mmux_libc_dprintf(fd, "the time in seconds since the Epoch is: \"")) {
	handle_error();
      } else if (mmux_libc_dprintf_time(fd, T2)) {
	handle_error();
      } if (mmux_libc_dprintf(fd, "\"\n")) {
	handle_error();
      } if (mmux_libc_memfd_copyer(fd)) {
	handle_error();
      } else if (mmux_libc_close(fd)) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
