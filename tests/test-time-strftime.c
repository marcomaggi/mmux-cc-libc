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
    PROGNAME = "test-time-strftime";
  }

  /* mmux_libc_strftime_required_nbytes_including_nil() */
  {
    mmux_time_t		T;
    mmux_libc_tm_t * 	BT;
    mmux_asciizcp_t	template = "%Y-%m-%dT%H:%M:%S%z";
    mmux_usize_t	required_nbytes_including_nil;

    mmux_libc_time(&T);
    mmux_libc_localtime(&BT, T);
    if (mmux_libc_strftime_required_nbytes_including_nil(&required_nbytes_including_nil, template, BT)) {
      print_error("strftime returned error");
      handle_error();
    }
    printf_message("required_nbytes_including_nil: %lu", required_nbytes_including_nil);
  }

  /* mmux_libc_strftime() */
  {
    mmux_time_t		T;
    mmux_libc_tm_t * 	BT;
    mmux_asciizcp_t	template = "%Y-%m-%dT%H:%M:%S%z";
    mmux_usize_t	required_nbytes_including_nil;

    mmux_libc_time(&T);
    mmux_libc_localtime(&BT, T);
    if (mmux_libc_strftime_required_nbytes_including_nil(&required_nbytes_including_nil, template, BT)) {
      print_error("strftime returned error");
      handle_error();
    }
    printf_message("required_nbytes_including_nil: %lu", required_nbytes_including_nil);

    {
      mmux_usize_t	buflen = required_nbytes_including_nil;
      mmux_char_t	bufptr[buflen];
      mmux_usize_t	required_nbytes_without_zero;

      if (mmux_libc_strftime(&required_nbytes_without_zero, bufptr, buflen, template, BT)) {
	print_error("strftime returned error");
	handle_error();
      }
      {
	mmux_usize_t	buf_strlen;

	mmux_libc_strlen(&buf_strlen, bufptr);
	printf_message("required_nbytes_without_zero %lu, strlen(timestamp)=%lu, formatted timestamp: %s",
		       required_nbytes_without_zero, buf_strlen, bufptr);
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
