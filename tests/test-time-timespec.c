/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 12, 2025

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
    PROGNAME = "test-time-timespec";
  }

  {
    mmux_libc_timespec_t	TS[1];

    /* setters and getters */
    {
      {
	auto	sec  = mmux_time_literal(12);
	auto	nsec = mmux_slong_literal(34);

	mmux_libc_ts_sec_set  (TS, sec);
	mmux_libc_ts_nsec_set (TS, nsec);
      }
      {
	mmux_time_t	sec;
	mmux_slong_t	nsec;

	mmux_libc_ts_sec_ref  (&sec,  TS);
	mmux_libc_ts_nsec_ref (&nsec, TS);

	assert(mmux_ctype_equal(mmux_time_literal(12),  sec));
	assert(mmux_ctype_equal(mmux_slong_literal(34), nsec));
      }
    }

    /* the other setter and the same getters */
    {
      {
	auto	sec  = mmux_time_literal(56);
	auto	nsec = mmux_slong_literal(78);

	mmux_libc_timespec_set(TS, sec, nsec);
      }
      {
	mmux_time_t	sec;
	mmux_slong_t	nsec;

	mmux_libc_ts_sec_ref  (&sec,  TS);
	mmux_libc_ts_nsec_ref (&nsec, TS);

	{
	  auto	expected_sec  = mmux_time_literal(56);
	  auto	expected_nsec = mmux_slong_literal(78);
	  bool	result;

	  mmux_ctype_equal_p(&result, &expected_sec,  &sec);
	  assert(result);
	  mmux_ctype_equal_p(&result, &expected_nsec, &nsec);
	  assert(result);
	}
      }
    }

    {
      mmux_libc_fd_t	fd;

      mmux_libc_stder(fd);
      assert(false == mmux_libc_timespec_dump(fd, TS, NULL));
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
