/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 11, 2025

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
    PROGNAME = "test-time-timeval";
  }

  {
    mmux_libc_timeval_t	TV[1];

    /* setters and getters */
    {
      {
	auto	sec  = mmux_time_literal(12);
	auto	usec = mmux_slong_literal(34);

	mmux_libc_tv_sec_set  (TV, sec);
	mmux_libc_tv_usec_set (TV, usec);
      }
      {
	mmux_time_t	sec;
	mmux_slong_t	usec;

	mmux_libc_tv_sec_ref  (&sec,  TV);
	mmux_libc_tv_usec_ref (&usec, TV);

	assert(mmux_ctype_equal(mmux_time_literal(12),  sec));
	assert(mmux_ctype_equal(mmux_slong_literal(34), usec));
      }
    }

    /* the other setter and the same getters */
    {
      {
	auto	sec  = mmux_time_literal(56);
	auto	usec = mmux_slong_literal(78);

	mmux_libc_timeval_set(TV, sec, usec);
      }
      {
	mmux_time_t	sec;
	mmux_slong_t	usec;

	mmux_libc_tv_sec_ref  (&sec,  TV);
	mmux_libc_tv_usec_ref (&usec, TV);

	assert(mmux_ctype_equal(mmux_time_literal(56),  sec));
	assert(mmux_ctype_equal(mmux_slong_literal(78), usec));
      }
    }

    {
      mmux_libc_oufd_t	fd;

      mmux_libc_stder(fd);
      assert(false == mmux_libc_timeval_dump(fd, TV, NULL));
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
