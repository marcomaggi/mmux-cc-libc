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
    PROGNAME = "test-time-strptime";
  }

  /* mmux_libc_strptime() */
  {
    mmux_asciizcp_t	template     = "The timestamp is: %a, %d %b %Y %H:%M:%S %z";
    mmux_asciizcp_t	input_string = "The timestamp is: Fri, 15 Nov 2024 23:11:20 +0100, and that's it!";
    mmux_libc_tm_t	BT[1];
    mmux_asciizp_t	first_unprocessed_after_timestamp;

    if (mmux_libc_strptime(&first_unprocessed_after_timestamp, input_string, template, BT)) {
      handle_error();
    }
    {
      mmux_libc_fd_t	fd;

      mmux_libc_stder(fd);
      if (mmux_libc_tm_dump(fd, BT, NULL)) {
	handle_error();
      } else if (mmux_libc_dprintf(fd, "the leftover string is: \"%s\"\n", first_unprocessed_after_timestamp)) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
