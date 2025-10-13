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

#include <mmux-cc-libc.h>
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
    PROGNAME = "test-time-ctime";
  }

  /* mmux_libc_ctime() */
  {
    mmux_time_t		T;
    mmux_asciizcp_t	bufptr;

    mmux_libc_time(&T);
    mmux_libc_ctime(&bufptr, T);
    if (mmux_libc_dprintfer("the timestamp from ctime is: \"%s\"\n", bufptr)) {
      handle_error();
    }
  }

  /* mmux_libc_ctime_r() */
  {
    constexpr auto	buflen = mmux_standard_usize_literal(512);
    char		bufptr[buflen];
    mmux_time_t		T;

    mmux_libc_time(&T);
    mmux_libc_ctime_r(bufptr, T);
    if (mmux_libc_dprintfer("the timestamp from ctime_r is: \"%s\"\n", bufptr)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
