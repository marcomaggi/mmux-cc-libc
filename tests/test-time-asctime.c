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
    PROGNAME = "test-time-asctime";
  }

  /* mmux_libc_asctime() */
  {
    mmux_time_t		T;
    mmux_libc_tm_t	BT;
    mmux_asciizcp_t	bufptr;

    mmux_libc_time(&T);
    mmux_libc_localtime_r(BT, T);
    mmux_libc_asctime(&bufptr, BT);
    if (mmux_libc_dprintfer("the timestamp from asctime is: \"%s\"\n", bufptr)) {
      handle_error();
    }
  }

  /* mmux_libc_asctime_r() */
  {
    mmux_time_t		T;
    mmux_libc_tm_t	BT;
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK		512
    char		bufptr[IS_THIS_ENOUGH_QUESTION_MARK];

    mmux_libc_time(&T);
    mmux_libc_localtime_r(BT, T);
    mmux_libc_asctime_r(bufptr, BT);
    if (mmux_libc_dprintfer("the timestamp from asctime_r is: \"%s\"\n", bufptr)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
