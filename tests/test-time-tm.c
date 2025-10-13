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
    PROGNAME = "test-time-tm";
  }

  /* acquiring and dumping */
  {
    mmux_time_t		T;
    mmux_libc_tm_t	TM[1];

    assert(false == mmux_libc_time(&T));
    assert(false == mmux_libc_localtime_r(TM, T));
    {
      mmux_libc_fd_t	fd;
      assert(false == mmux_libc_stder(fd));
      assert(false == mmux_libc_tm_dump(fd, TM, NULL));
    }
    assert(false == mmux_libc_tm_reset(TM));
    {
      mmux_libc_fd_t	fd;
      assert(false == mmux_libc_stder(fd));
      assert(false == mmux_libc_tm_dump(fd, TM, NULL));
    }
  }

  /* setters and getters */
  {
    mmux_libc_tm_t	TM[1];

    auto		sec	= mmux_sint_literal(47);
    auto		min	= mmux_sint_literal(4);
    auto		hour	= mmux_sint_literal(7);
    auto		mday	= mmux_sint_literal(12);
    auto		mon	= mmux_sint_literal(9);
    auto		year	= mmux_sint_literal(125);
    auto		wday	= mmux_sint_literal(0);
    auto		yday	= mmux_sint_literal(284);
    auto		gmtoff	= mmux_slong_literal(7200);
    auto		isdst	= mmux_sint_literal(+1);
    mmux_asciizcp_t	zone	= "CEST";

    assert(false == mmux_libc_tm_sec_set	(TM, sec));
    assert(false == mmux_libc_tm_min_set	(TM, min));
    assert(false == mmux_libc_tm_hour_set	(TM, hour));
    assert(false == mmux_libc_tm_mday_set	(TM, mday));
    assert(false == mmux_libc_tm_mon_set	(TM, mon));
    assert(false == mmux_libc_tm_year_set	(TM, year));
    assert(false == mmux_libc_tm_wday_set	(TM, wday));
    assert(false == mmux_libc_tm_yday_set	(TM, yday));
    assert(false == mmux_libc_tm_isdst_set	(TM, isdst));
    assert(false == mmux_libc_tm_gmtoff_set	(TM, gmtoff));
    assert(false == mmux_libc_tm_zone_set	(TM, zone));
    {
      mmux_libc_fd_t	fd;

      assert(false == mmux_libc_stder(fd));
      if (mmux_libc_tm_dump(fd, TM, NULL)) {
	handle_error();
      }
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_sec_ref(&field, TM));
      assert(mmux_ctype_equal(field, sec));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_min_ref(&field, TM));
      assert(mmux_ctype_equal(field, min));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_hour_ref(&field, TM));
      assert(mmux_ctype_equal(field, hour));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_mday_ref(&field, TM));
      assert(mmux_ctype_equal(field, mday));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_mon_ref(&field, TM));
      assert(mmux_ctype_equal(field, mon));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_year_ref(&field, TM));
      assert(mmux_ctype_equal(field, year));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_wday_ref(&field, TM));
      assert(mmux_ctype_equal(field, wday));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_yday_ref(&field, TM));
      assert(mmux_ctype_equal(field, yday));
    }

    {
      mmux_sint_t	field;
      assert(false == mmux_libc_tm_isdst_ref(&field, TM));
      assert(mmux_ctype_equal(field, isdst));
    }

    {
      mmux_slong_t	field;
      assert(false == mmux_libc_tm_gmtoff_ref(&field, TM));
      assert(mmux_ctype_equal(field, gmtoff));
    }

    {
      mmux_asciizcp_t	field;
      bool		result;
      assert(false == mmux_libc_tm_zone_ref(&field, TM));
      assert(false == mmux_libc_strequ(&result, field, zone));
      assert(result);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
