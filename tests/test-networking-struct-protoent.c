/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec  6, 2025

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
    PROGNAME = "test-networking-struct-protoent";
  }

  /* Setting the IPv4 address from an ASCIIZ string. */
  {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    mmux_libc_setprotoent(true);
    {
      for (bool there_is_one_more = false;;) {
	mmux_libc_protoent_t	protoent;

	mmux_libc_getprotoent(&there_is_one_more, protoent);
	if (there_is_one_more) {
	  mmux_libc_protoent_dump(er, protoent, NULL);
	} else {
	  break;
	}
      }
    }
    mmux_libc_endprotoent();
  }

  /* getprotobyname() */
  {
    mmux_asciizcp_t		protocol_name  = "tcp";
    bool			there_is_one;
    mmux_libc_protoent_t	protoent;

    printf_message("getting protocol by name");
    if (mmux_libc_getprotobyname(&there_is_one, protoent, protocol_name)) {
      handle_error();
    } else if (there_is_one) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_protoent_dump(er, protoent, NULL);
    }
  }

  /* getprotobynumber() */
  {
    auto			protocol_number  = MMUX_LIBC_IPPROTO_TCP;
    bool			there_is_one;
    mmux_libc_protoent_t	protoent;

    printf_message("getting protocol by number");
    if (mmux_libc_getprotobynumber(&there_is_one, protoent, protocol_number)) {
      handle_error();
    } else if (there_is_one) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_protoent_dump(er, protoent, NULL);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
