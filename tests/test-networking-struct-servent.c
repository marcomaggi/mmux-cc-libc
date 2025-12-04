/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec  4, 2025

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
    PROGNAME = "test-networking-struct-servent";
  }

  /* Setting the IPv4 address from an ASCIIZ string. */
  {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    mmux_libc_setservent(true);
    {
      for (bool there_is_one_more = false;;) {
	mmux_libc_servent_t	servent;

	mmux_libc_getservent(&there_is_one_more, servent);
	if (there_is_one_more) {
	  mmux_libc_servent_dump(er, servent, NULL);
	} else {
	  break;
	}
      }
    }
    mmux_libc_endservent();
  }

  /* getservbyname() */
  {
    mmux_asciizcp_t	service_name  = "smtp";
    mmux_asciizcp_t	protocol_name = "tcp";
    bool		there_is_one;
    mmux_libc_servent_t	servent;

    printf_message("getting service by name");
    if (mmux_libc_getservbyname(&there_is_one, servent, service_name, protocol_name)) {
      handle_error();
    } else if (there_is_one) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_servent_dump(er, servent, NULL);
    }
  }

  /* getservbyport() */
  {
    auto		port  = mmux_libc_network_port_number_from_host_byteorder_literal(25);
    mmux_asciizcp_t	protocol_name = "tcp";
    bool		there_is_one;
    mmux_libc_servent_t	servent;

    printf_message("getting service by port");
    if (mmux_libc_getservbyport(&there_is_one, servent, port, protocol_name)) {
      handle_error();
    } else if (there_is_one) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_servent_dump(er, servent, NULL);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
