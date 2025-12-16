/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec 16, 2025

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
test_getnameinfo_string_results (void)
{
  printf_message("testing: %s", __func__);
  {
    auto	hostlen = MMUX_LIBC_NI_MAXHOST;
    auto	servlen = MMUX_LIBC_NI_MAXSERV;
    char	hostname[hostlen.value];
    char	servname[servlen.value];

    {
      mmux_libc_sockaddr_ipfour_t	sockaddr_ipfour;
      mmux_libc_socklen_t		sockaddr_length;
      mmux_libc_gai_errno_t		gai_errno;
      auto				flags = mmux_libc_getnameinfo_flags(0);

      /* Initialise the socket address. */
      {
	mmux_libc_ipfour_addr_t  address_ipfour;

	if (mmux_libc_make_ipfour_addr_from_asciiz(address_ipfour, "127.0.0.1")) {
	  handle_error();
	}
	mmux_libc_sockaddr_ipfour_family_set(sockaddr_ipfour, MMUX_LIBC_AF_INET);
	mmux_libc_sockaddr_ipfour_addr_set(sockaddr_ipfour, address_ipfour);
	mmux_libc_sockaddr_ipfour_port_set(sockaddr_ipfour,
					   mmux_libc_network_port_number_from_host_byteorder_literal(25));
      }

      mmux_libc_sockaddr_bind_length(&sockaddr_length, sockaddr_ipfour);

      printf_message("getnameinfo-ing");
      if (mmux_libc_getnameinfo(hostname, hostlen, servname, servlen,
				&gai_errno, sockaddr_ipfour, sockaddr_length, flags)) {
	mmux_asciizcp_t	gai_errmsg;

	mmux_libc_gai_strerror(&gai_errmsg, gai_errno);
	printf_error("getaddrinfo-ing: %s", gai_errmsg);
	handle_error();
      }
    }

    printf_message("found host '%s' and service '%s'", hostname, servname);
  }
  printf_message("DONE: %s\n", __func__);
}


static void
test_getnameinfo_numeric_results (void)
{
  printf_message("testing: %s", __func__);
  {
    auto	hostlen = MMUX_LIBC_NI_MAXHOST;
    auto	servlen = MMUX_LIBC_NI_MAXSERV;
    char	hostname[hostlen.value];
    char	servname[servlen.value];

    {
      mmux_libc_sockaddr_ipfour_t	sockaddr_ipfour;
      mmux_libc_socklen_t		sockaddr_length;
      mmux_libc_gai_errno_t		gai_errno;
      auto				flags = mmux_libc_getnameinfo_flags(MMUX_LIBC_NI_NUMERICHOST | MMUX_LIBC_NI_NUMERICSERV);

      /* Initialise the socket address. */
      {
	mmux_libc_ipfour_addr_t  address_ipfour;

	if (mmux_libc_make_ipfour_addr_from_asciiz(address_ipfour, "127.0.0.1")) {
	  handle_error();
	}
	mmux_libc_sockaddr_ipfour_family_set(sockaddr_ipfour, MMUX_LIBC_AF_INET);
	mmux_libc_sockaddr_ipfour_addr_set(sockaddr_ipfour, address_ipfour);
	mmux_libc_sockaddr_ipfour_port_set(sockaddr_ipfour,
					   mmux_libc_network_port_number_from_host_byteorder_literal(25));
      }

      mmux_libc_sockaddr_bind_length(&sockaddr_length, sockaddr_ipfour);

      printf_message("getnameinfo-ing");
      if (mmux_libc_getnameinfo(hostname, hostlen, servname, servlen,
				&gai_errno, sockaddr_ipfour, sockaddr_length, flags)) {
	mmux_asciizcp_t	gai_errmsg;

	mmux_libc_gai_strerror(&gai_errmsg, gai_errno);
	printf_error("getaddrinfo-ing: %s", gai_errmsg);
	handle_error();
      }
    }

    printf_message("found host '%s' and service '%s'", hostname, servname);
  }
  printf_message("DONE: %s\n", __func__);
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
    PROGNAME = "test-networking-getnameinfo";
  }

  if (true)  {	test_getnameinfo_string_results();	}
  if (true)  {	test_getnameinfo_numeric_results();	}

  mmux_libc_exit_success();
}

/* end of file */
