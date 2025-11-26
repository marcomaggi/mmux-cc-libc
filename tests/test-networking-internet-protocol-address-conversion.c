/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 21, 2025

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
test_inet_pton (void)
/* Setting the IPv4 address from an ASCIIZ string. */
{
  printf_message("%s: running test", __func__);

  {
    mmux_asciizcp_t	        dotted_quad = "127.0.0.1";
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_inet_pton(address, MMUX_LIBC_AF_INET, dotted_quad)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, NULL);
    }
  }

  {
    mmux_asciizcp_t         presentation = "1:2:3:4:5:6:7:8";
    mmux_libc_ipsix_addr_t  address;

    if (mmux_libc_inet_pton(address, MMUX_LIBC_AF_INET6, presentation)) {
      handle_error();
    } else {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipsix_addr_dump(er, address, NULL);
    }
  }

  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_ntop (void)
{
  printf_message("%s: running test", __func__);

  {
    mmux_libc_ipfour_addr_t     address;

    if (mmux_libc_make_ipfour_addr_broadcast(address)) {
      handle_error();
    } else {
      auto	buflen = mmux_usize_literal(32);
      char	bufptr[buflen.value];

      if (mmux_libc_inet_ntop(bufptr, buflen, MMUX_LIBC_AF_INET, address)) {
	handle_error();
      } else {
	if (false) {
	  mmux_libc_oufd_t	er;

	  mmux_libc_stder(er);
	  mmux_libc_ipfour_addr_dump(er, address, NULL);
	}
	printf_message("presentation: %s", bufptr);
      }
    }
  }

  {
    mmux_libc_ipsix_addr_t     address;

    if (mmux_libc_make_ipsix_addr_loopback(address)) {
      handle_error();
    }
    {
      auto	buflen = mmux_usize_literal(32);
      char	bufptr[buflen.value];

      if (mmux_libc_inet_ntop(bufptr, buflen, MMUX_LIBC_AF_INET6, address)) {
	handle_error();
      } else {
	if (false) {
	  mmux_libc_oufd_t	er;

	  mmux_libc_stder(er);
	  mmux_libc_ipsix_addr_dump(er, address, NULL);
	}
	printf_message("presentation: %s", bufptr);
      }
    }
  }

  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_aton (void)
{
  printf_message("%s: running test", __func__);

  mmux_asciizcp_t		dotted_quad = "127.0.0.1";
  mmux_libc_ipfour_addr_t	address;

  if (mmux_libc_inet_aton(address, dotted_quad)) {
    handle_error();
  } else {
    if (false) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, NULL);
    }

    {
      mmux_libc_ipfour_addr_t	expected_address;
      bool			they_are_equal;

      mmux_libc_make_ipfour_addr_loopback(expected_address);
      mmux_libc_ipfour_addr_equal(&they_are_equal, address, expected_address);
      if (they_are_equal) {
	printf_message("addresses are correctly equal");
      } else {
	printf_error("addresses are wrongly different");
      }
    }
  }

  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_ntoa (void)
{
  printf_message("%s: running test", __func__);

  mmux_libc_ipfour_addr_t	address;

  if (mmux_libc_make_ipfour_addr_loopback(address)) {
    handle_error();
  }

  {
    auto	buflen = mmux_usize_literal(1024);
    char	bufptr[buflen.value];

    if (mmux_libc_inet_ntoa(bufptr, buflen, address)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	cmpnum;

      mmux_libc_strcmp(&cmpnum, bufptr, "127.0.0.1");
      if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	printf_message("correct address presentation");
      } else {
	printf_error("wrong address presentation");
	handle_error();
      }
    }
  }

  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_addr (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciizcp_t		address_presentation = "127.0.0.1";
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_inet_addr(address, address_presentation)) {
      handle_error();
    }

    if (false) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, NULL);
    }

    {
      mmux_libc_ipfour_addr_t	expected_address;
      bool			are_equal;

      mmux_libc_make_ipfour_addr_loopback(expected_address);
      mmux_libc_ipfour_addr_equal(&are_equal, address, expected_address);
      if (are_equal) {
	printf_message("correct address");
      } else {
	printf_error("wrong address");
	handle_error();
      }
    }
  }
  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_network (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciizcp_t		address_presentation = "192.168.0.0";
    mmux_libc_ipfour_addr_t	address;

    if (mmux_libc_inet_network(address, address_presentation)) {
      handle_error();
    }

    if (true) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_ipfour_addr_dump(er, address, NULL);
    }

    {
      mmux_asciizcp_t		expected_address_presentation = "192.168.0.0";
      mmux_libc_ipfour_addr_t	expected_address;
      bool			are_equal;

      mmux_libc_make_ipfour_addr_from_asciiz(expected_address, expected_address_presentation);
      mmux_libc_ipfour_addr_equal(&are_equal, address, expected_address);
      if (are_equal) {
	printf_message("correct address");
      } else {
	printf_error("wrong address");
	handle_error();
      }
    }
  }
  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_makeaddr (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_libc_host_byteorder_uint32_t	local_network_address_number, network_address_number;
    mmux_libc_ipfour_addr_t		original_address;

    {
      mmux_asciizcp_t	original_address_presentation = "192.168.77.88";

      if (mmux_libc_make_ipfour_addr_from_asciiz(original_address, original_address_presentation)) {
	handle_error();
      }
    }

    if (mmux_libc_inet_lnaof(&local_network_address_number, original_address)) {
      handle_error();
    }

    if (mmux_libc_inet_netof(&network_address_number, original_address)) {
      handle_error();
    }

    {
      mmux_libc_ipfour_addr_t	recombined_address;

      if (mmux_libc_inet_makeaddr(recombined_address, network_address_number, local_network_address_number)) {
	handle_error();
      }

      if (true) {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	mmux_libc_ipfour_addr_dump(er, original_address, "original address");
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("local network address number: %X [host byteorder]\n",
						    local_network_address_number.value));
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("network address number: %X [host byteorder]\n",
						    network_address_number.value));
	mmux_libc_ipfour_addr_dump(er, recombined_address, "recombined address");
      }

      {
	bool	are_equal;

	mmux_libc_ipfour_addr_equal(&are_equal, original_address, recombined_address);
	if (are_equal) {
	  printf_message("original address correctly equals recombined address");
	} else {
	  printf_message("original address wrongly different from recombined address");
	  handle_error();
	}
      }
    }
  }
  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_net_pton (void)
/* Setting the IPv4 address from an ASCIIZ string. */
{
  printf_message("%s: running test", __func__);

  /* Convert 127.0.0.1 */
  {
    mmux_asciizcp_t	        dotted_quad = "127.0.0.1";
    mmux_libc_ipfour_addr_t	address;
    mmux_uint_t			number_of_bits;

    if (mmux_libc_inet_net_pton(address, &number_of_bits, MMUX_LIBC_AF_INET, dotted_quad)) {
      handle_error();
    } else {
      if (true) {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	mmux_libc_ipfour_addr_dump(er, address, NULL);
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("number of bits in the address: %u\n", number_of_bits.value));
      }
    }

    /* Validate the result. */
    {
      if (32 == number_of_bits.value) {
	printf_message("correct number of bits");
      } else {
	printf_error("wrong number of bits");
	handle_error();
      }
    }
  }

  /* Convert 193.168.1.128/24 */
  {
    mmux_asciizcp_t	        dotted_quad = "193.168.1.128/24";
    mmux_libc_ipfour_addr_t	address;
    mmux_uint_t			number_of_bits;

    if (mmux_libc_inet_net_pton(address, &number_of_bits, MMUX_LIBC_AF_INET, dotted_quad)) {
      handle_error();
    } else {
      if (true) {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	mmux_libc_ipfour_addr_dump(er, address, NULL);
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("number of bits in the address: %u\n", number_of_bits.value));
      }
    }

    /* Validate the result. */
    {
      if (24 == number_of_bits.value) {
	printf_message("correct number of bits");
      } else {
	printf_error("wrong number of bits");
	handle_error();
      }
    }
  }

  printf_message("%s: DONE\n", __func__);
}


static void
test_inet_net_ntop (void)
{
  printf_message("%s: running test", __func__);

  {
    mmux_libc_ipfour_addr_t     address;

    /* Build a network address. */
    {
      mmux_asciizcp_t	        dotted_quad = "193.168.1.128";

      if (mmux_libc_inet_pton(address, MMUX_LIBC_AF_INET, dotted_quad)) {
	handle_error();
      }
    }

    /* Build the presentation from the data structure. */
    {
      auto	number_of_bits = mmux_uint_literal(24);
      auto	buflen = mmux_usize_literal(32);
      char	bufptr[buflen.value];

      if (mmux_libc_inet_net_ntop(bufptr, buflen, MMUX_LIBC_AF_INET, address, number_of_bits)) {
	handle_error();
      } else {
	if (true) {
	  mmux_libc_oufd_t	er;

	  mmux_libc_stder(er);
	  mmux_libc_ipfour_addr_dump(er, address, NULL);
	}

	/* Validate the resulting presentation. */
	{
	  bool	are_equal;

	  mmux_libc_strequ(&are_equal, bufptr, "193.168.1/24");
	  if (are_equal) {
	    printf_message("correct presentation: %s", bufptr);
	  } else {
	    printf_error("wrong presentation: %s", bufptr);
	  }
	}
      }
    }
  }

  printf_message("%s: DONE\n", __func__);
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
    PROGNAME = "test-networking-sockets-address-conversion";
  }

  if (true) {	test_inet_pton();	}
  if (true) {	test_inet_ntop();	}

  if (true) {	test_inet_aton();	}
  if (true) {	test_inet_ntoa();	}

  if (true) {	test_inet_addr();	}
  if (true) {	test_inet_network();	}
  if (true) {	test_inet_makeaddr();	}

  if (true) {	test_inet_net_pton();	}
  if (true) {	test_inet_net_ntop();	}

  mmux_libc_exit_success();
}

/* end of file */
