/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 30, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

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
    PROGNAME = "test-networking-struct-hostent";
  }

  /* Setting the IPv4 address from an ASCIIZ string. */
  {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    mmux_libc_sethostent(true);
    {
      for (bool there_is_one_more = false;;) {
	mmux_libc_hostent_t	hostent;

	mmux_libc_gethostent(&there_is_one_more, hostent);
	if (there_is_one_more) {
	  mmux_libc_hostent_dump(er, hostent, NULL);
	} else {
	  break;
	}
      }
    }
    mmux_libc_endhostent();
  }

  mmux_libc_exit_success();
}

/* end of file */
