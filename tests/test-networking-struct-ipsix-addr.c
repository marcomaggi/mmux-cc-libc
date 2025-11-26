/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 23, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>


static void
test_address_make_from_string (void)
/* Setting the IPv6 address from an ASCIIZ string. */
{
  mmux_asciizcp_t		address_presentation = "1:2:3:4:5:6:7:8";
  mmux_libc_ipsix_addr_t	address;

  if (mmux_libc_make_ipsix_addr_from_asciiz(address, address_presentation)) {
    handle_error();
  } else {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    mmux_libc_ipsix_addr_dump(er, address, NULL);
  }
}


static void
test_address_any (void)
{
  mmux_libc_ipsix_addr_t	address;

  if (mmux_libc_make_ipsix_addr_any(address)) {
    handle_error();
  } else {
    if (true) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipsix_addr_dump(er, address, NULL);
    }
    {
      auto	buflen = mmux_usize_literal(1024);
      char	bufptr[buflen.value];

      mmux_libc_inet_ntop(bufptr, buflen, MMUX_LIBC_AF_INET6, address);
      {
	mmux_ternary_comparison_result_t	cmpnum;

	mmux_libc_strcmp(&cmpnum, bufptr, "::");
	if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	  printf_message("correct IPv6 address 'any' string representation");
	} else {
	  printf_message("wrong IPv6 address 'any' string representation");
	  handle_error();
	}
      }
    }
  }
}


static void
test_address_loopback (void)
{
  mmux_libc_ipsix_addr_t	address;

  if (mmux_libc_make_ipsix_addr_loopback(address)) {
    handle_error();
  } else {
    if (true) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipsix_addr_dump(er, address, NULL);
    }
    {
      auto	buflen = mmux_usize_literal(1024);
      char	bufptr[buflen.value];

      mmux_libc_inet_ntop(bufptr, buflen, MMUX_LIBC_AF_INET6, address);
      {
	mmux_ternary_comparison_result_t	cmpnum;

	mmux_libc_strcmp(&cmpnum, bufptr, "::1");
	if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	  printf_message("correct IPv6 address 'loopback' string representation");
	} else {
	  printf_message("wrong IPv6 address 'loopback' string representation");
	  handle_error();
	}
      }
    }
  }
}


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-networking-sockets-struct-infour-six";
  }

  if (true) {	test_address_make_from_string();	}
  if (true) {	test_address_any();			}
  if (true) {	test_address_loopback();		}

  mmux_libc_exit_success();
}

/* end of file */
