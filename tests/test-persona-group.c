/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Jul 19, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

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
    PROGNAME = "test-persona-group";
  }

  /* Print the database. */
  {
    mmux_libc_setgrent();
    {
      mmux_libc_group_t *	PW;
      mmux_libc_fd_t		fd;

      mmux_libc_stder(&fd);
      for (;;) {
	mmux_libc_getgrent(&PW);
	if (NULL == PW) {
	  break;
	} else if (mmux_libc_group_dump(fd, PW, NULL)) {
	  handle_error();
	}
      }
    }
    mmux_libc_endgrent();
  }

  mmux_libc_exit_success();
}

/* end of file */
