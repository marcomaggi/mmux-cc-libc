/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 13, 2025

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

  /* mmux_libc_sleep() */
  {
    auto	seconds = mmux_uint_literal(2);
    mmux_uint_t	leftover;

    assert(false == mmux_libc_sleep(&leftover, seconds));
    assert(mmux_ctype_is_zero(leftover));
  }

  {
    mmux_libc_timespec_t    requested_time;
    mmux_libc_timespec_t    remaining_time;
    {
      auto	seconds     = mmux_time_constant_zero(0);
      auto	nanoseconds = mmux_slong_literal(34);
      mmux_libc_timespec_set(&requested_time, seconds, nanoseconds);
    }
    if (mmux_libc_nanosleep(&requested_time, &remaining_time)) {
      handle_error();
    }
  }
  mmux_libc_exit_success();
}

/* end of file */
