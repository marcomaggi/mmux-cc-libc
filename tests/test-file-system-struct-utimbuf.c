/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 22, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc.h>
#include <test-common.h>


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-struct-utimbuf";
  }

  mmux_libc_utimbuf_t	UTB[1];
  mmux_time_t		T1, T2;

  mmux_libc_time(&T1);
  mmux_libc_time(&T2);
  mmux_libc_actime_set  (UTB, T1);
  mmux_libc_modtime_set (UTB, T2);

  {
    mmux_libc_fd_t	fd;

    mmux_libc_stdou(&fd);
    if (mmux_libc_utimbuf_dump(fd, UTB, NULL)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
