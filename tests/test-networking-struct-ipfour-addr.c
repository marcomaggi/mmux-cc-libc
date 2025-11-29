/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 19, 2025

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
    PROGNAME = "test-networking-sockets-struct-infour-addr";
  }

  /* Setting the IPv4 address from an ASCIIZ string. */
  {
    mmux_asciizcp_t		dotted_quad = "127.0.0.1";
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_make_ipfour_addr_from_asciiz(address, dotted_quad)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, NULL);
    }
  }

  /* Making the IPv4 address value from a raw exact integer. */
  {
    auto			numeric_address = mmux_libc_network_byteorder_uint32_literal(16777343);
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_make_ipfour_addr(address, numeric_address)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, NULL);
    }
  }

  /* Setting the IPv4 address value from a raw exact integer. */
  {
    auto			numeric_address = mmux_libc_network_byteorder_uint32_literal(16777343);
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_s_addr_set(address, numeric_address)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, NULL);
    }
  }

  /* Setting the IPv4 address value to INADDR_NONE. */
  {
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_make_ipfour_addr_none(address)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, "INADDR_NONE");
    }
  }

  /* Setting the IPv4 address value to INADDR_ANY. */
  {
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_make_ipfour_addr_any(address)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, "INADDR_ANY");
    }
  }

  /* Setting the IPv4 address value to INADDR_BROADCAST. */
  {
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_make_ipfour_addr_broadcast(address)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, "INADDR_BROADCAST");
    }
  }

  /* Setting the IPv4 address value to INADDR_LOOPBACK. */
  {
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_make_ipfour_addr_loopback(address)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, "INADDR_LOOPBACK");
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
