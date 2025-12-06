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
    PROGNAME = "test-networking-struct-netent";
  }

  /* Setting the IPv4 address from an ASCIIZ string. */
  {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    mmux_libc_setnetent(true);
    {
      for (bool there_is_one_more = false;;) {
	mmux_libc_netent_t	netent;

	mmux_libc_getnetent(&there_is_one_more, netent);
	if (there_is_one_more) {
	  mmux_libc_netent_dump(er, netent, NULL);
	} else {
	  break;
	}
      }
    }
    mmux_libc_endnetent();
  }

  /* getnetbyname() */
  {
    mmux_asciizcp_t	network_name  = "loopback";
    bool		there_is_one;
    mmux_libc_netent_t	netent;

    printf_message("getting network by name");
    if (mmux_libc_getnetbyname(&there_is_one, netent, network_name)) {
      handle_error();
    } else if (there_is_one) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_netent_dump(er, netent, NULL);
    }
  }

  /* getnetbyaddr() */
  {
    mmux_libc_ipfour_addr_t	network_address;
    bool			there_is_one;
    mmux_libc_netent_t		netent;

    if (mmux_libc_make_ipfour_addr_from_asciiz(network_address, "127.0.0.0")) {
      handle_error();
    }

    printf_message("getting network by address");
    if (mmux_libc_getnetbyaddr(&there_is_one, netent, network_address, MMUX_LIBC_AF_INET)) {
      handle_error();
    } else if (there_is_one) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_netent_dump(er, netent, NULL);
    } else {
      printf_message("there is no matching network");
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
