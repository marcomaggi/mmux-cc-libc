/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec 14, 2025

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
test_addrinfo_initialisation (void)
{
  printf_message("testing: %s", __func__);

  /* Instantiate and inspect a addrinfo. */
  {
    mmux_libc_addrinfo_t	addrinfo;

    /* Initialise the fields of addrinfo. */
    {
      mmux_libc_sockaddr_ipfour_t	sockaddr;

      /* Initialise the fields of sockaddr. */
      {
	mmux_libc_ipfour_addr_t		ipaddr;

	/* Build the IPv4 address. */
	{
	  mmux_asciizcp_t	presentation = "127.0.0.1";

	  if (mmux_libc_make_ipfour_addr_from_asciiz(ipaddr, presentation)) {
	    handle_error();
	  }
	}

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_ipfour_family_set(sockaddr, MMUX_LIBC_AF_INET)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr, ipaddr)) {
	    handle_error();
	  }
	  {
	    /* SMTP port number is 25 in host byteorder, 0x1900 in network byteorder. */
	    auto	ipport = mmux_libc_network_port_number_from_host_byteorder_literal(25);

	    if (mmux_libc_sockaddr_ipfour_port_set(sockaddr, ipport)) {
	      handle_error();
	    }
	  }
	}
      }

      /* Initialise the field ai_family. */
      {
	if (mmux_libc_addrinfo_family_set(addrinfo, MMUX_LIBC_AF_INET)) {
	  handle_error();
	}
      }

      /* Initialise the field ai_socktype. */
      {
	if (mmux_libc_addrinfo_socket_communication_style_set(addrinfo, MMUX_LIBC_SOCK_STREAM)) {
	  handle_error();
	}
      }

      /* Initialise the field ai_protocol. */
      {
	if (mmux_libc_addrinfo_internet_protocol_set(addrinfo, MMUX_LIBC_IPPROTO_TCP)) {
	  handle_error();
	}
      }

      /* Initialise the field ai_flags. */
      {
	auto	ai_flags = mmux_libc_network_addrinfo_flags(MMUX_LIBC_AI_V4MAPPED |
							    MMUX_LIBC_AI_ADDRCONFIG |
							    MMUX_LIBC_AI_CANONNAME);

	if (mmux_libc_addrinfo_flags_set(addrinfo, ai_flags)) {
	  handle_error();
	}
      }

      /* Initialise the field ai_addrlen. */
      {
	mmux_libc_socklen_t	addrlen;

	mmux_libc_sockaddr_bind_length(&addrlen, sockaddr);
	if (mmux_libc_addrinfo_addrlen_set(addrinfo, addrlen)) {
	  handle_error();
	}
      }

      /* Initialise the field ai_addr. */
      {
	if (mmux_libc_addrinfo_sockaddr_set(addrinfo, sockaddr)) {
	  handle_error();
	}
      }

      /* Initialise the field ai_canonname. */
      {
	if (mmux_libc_addrinfo_canonname_set(addrinfo, "localhost")) {
	  handle_error();
	}
      }

      /* Initialise the field ai_next. */
      {
	if (mmux_libc_addrinfo_next_set(addrinfo, NULL)) {
	  handle_error();
	}
      }
    }

    /* Dump the data structure as a addrinfo. */
    printf_message("dump data structure as addrinfo");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_addrinfo_dump(er, addrinfo, NULL)) {
	handle_error();
      }
    }

    /* Check the field getter for "ai_family". */
    {
      mmux_libc_network_address_family_t	ai_family;

      if (mmux_libc_addrinfo_family_ref(&ai_family, addrinfo)) {
	handle_error();
      }
      if (ai_family.value == MMUX_LIBC_VALUEOF_AF_INET) {
	printf_message("correct field value ai_family");
      } else {
	printf_error("wrong field value ai_family");
	handle_error();
      }
    }

    /* Check the field getter for "ai_socktype". */
    {
      mmux_libc_network_socket_communication_style_t	ai_socktype;

      if (mmux_libc_addrinfo_socket_communication_style_ref(&ai_socktype, addrinfo)) {
	handle_error();
      }
      if (ai_socktype.value == MMUX_LIBC_VALUEOF_SOCK_STREAM) {
	printf_message("correct field value ai_socktype");
      } else {
	printf_error("wrong field value ai_socktype");
	handle_error();
      }
    }

    /* Check the field getter for "ai_protocol". */
    {
      mmux_libc_network_internet_protocol_t	ai_protocol;

      if (mmux_libc_addrinfo_internet_protocol_ref(&ai_protocol, addrinfo)) {
	handle_error();
      }
      if (ai_protocol.value == MMUX_LIBC_VALUEOF_IPPROTO_TCP) {
	printf_message("correct field value ai_protocol");
      } else {
	printf_error("wrong field value ai_protocol");
	handle_error();
      }
    }

    /* Check the field getter for "ai_flags". */
    {
      mmux_libc_network_addrinfo_flags_t	ai_flags;

      if (mmux_libc_addrinfo_flags_ref(&ai_flags, addrinfo)) {
	handle_error();
      }
      if (ai_flags.value == (MMUX_LIBC_AI_V4MAPPED |
			     MMUX_LIBC_AI_ADDRCONFIG |
			     MMUX_LIBC_AI_CANONNAME)) {
	printf_message("correct field value ai_flags");
      } else {
	printf_error("wrong field value ai_flags");
	handle_error();
      }
    }

    /* Check the field getter for "ai_addrlen". */
    {
      mmux_libc_socklen_t	ai_addrlen;

      if (mmux_libc_addrinfo_addrlen_ref(&ai_addrlen, addrinfo)) {
	handle_error();
      }
      if (ai_addrlen.value == sizeof(mmux_libc_network_socket_address_ipfour_t)) {
	printf_message("correct field value ai_addrlen");
      } else {
	printf_error("wrong field value ai_addrlen");
	handle_error();
      }
    }

    /* Check the field getter for "ai_addr". */
    {
      mmux_libc_socklen_t	ai_addrlen;

      if (mmux_libc_addrinfo_addrlen_ref(&ai_addrlen, addrinfo)) {
	handle_error();
      }
      {
	mmux_standard_octet_t	bufptr[ai_addrlen.value];
	auto			ai_addr = (mmux_libc_sockaddr_t) bufptr;
	bool			are_equal;

	mmux_libc_addrinfo_sockaddr_ref(ai_addr, addrinfo);
	{
	  mmux_libc_sockaddr_ipfour_t	expected_ai_addr;
	  mmux_libc_ipfour_addr_t	ipaddr;
	  mmux_asciizcp_t		presentation = "127.0.0.1";

	  mmux_libc_make_ipfour_addr_from_asciiz(ipaddr, presentation);
	  mmux_libc_sockaddr_ipfour_family_set(expected_ai_addr, MMUX_LIBC_AF_INET);
	  mmux_libc_sockaddr_ipfour_addr_set(expected_ai_addr, ipaddr);
	  mmux_libc_sockaddr_ipfour_port_set(expected_ai_addr,
					     mmux_libc_network_port_number_from_host_byteorder_literal(25));

	  mmux_libc_sockaddr_equal(&are_equal, ai_addr, expected_ai_addr);
	}
	if (are_equal) {
	  printf_message("correct field value ai_addr");
	} else {
	  printf_error("wrong field value ai_addr");
	  handle_error();
	}
      }
    }

    /* Check the field getter for "ai_canonname". */
    {
      mmux_asciizcp_t	ai_canonname;
      bool		are_equal;

      if (mmux_libc_addrinfo_canonname_ref(&ai_canonname, addrinfo)) {
	handle_error();
      }
      mmux_libc_strequ(&are_equal, ai_canonname, "localhost");
      if (are_equal) {
	printf_message("correct field value ai_canonname");
      } else {
	printf_error("wrong field value ai_canonname");
	handle_error();
      }
    }

    /* Check the field getter for "ai_next". */
    {
      bool			there_is_one_more;
      mmux_libc_addrinfo_t	ai_next;

      if (mmux_libc_addrinfo_next_ref(&there_is_one_more, ai_next, addrinfo)) {
	handle_error();
      }
      if (false == there_is_one_more) {
	printf_message("correct field value ai_next");
      } else {
	printf_error("wrong field value ai_next");
	handle_error();
      }
    }

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
    PROGNAME = "test-networking-struct-addrinfo";
  }

  if (true) {	test_addrinfo_initialisation();		}

  mmux_libc_exit_success();
}

/* end of file */
