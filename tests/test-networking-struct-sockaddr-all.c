/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec 10, 2025

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
test_sockaddr_local (void)
{
  printf_message("testing: %s", __func__);

  /* Instantiate and inspect a sockaddr_local. */
  {
    mmux_libc_sockaddr_local_t	sockaddr_local;

    /* Initialise the address. */
    {
      mmux_libc_fs_ptn_t	fs_ptn;

      /* Build socket's file system pathname. */
      {
	mmux_asciizcp_t			ptn_asciiz = "/path/to/socket.sock";
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      /* Initialise the fields. */
      {
	if (mmux_libc_sockaddr_local_family_set(sockaddr_local, MMUX_LIBC_AF_LOCAL)) {
	  handle_error();
	}
	if (mmux_libc_sockaddr_local_path_set(sockaddr_local, fs_ptn)) {
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	if (mmux_libc_unmake_file_system_pathname(fs_ptn)) {
	  handle_error();
	}
      }
    }

    /* Dump the data structure as a sockaddr_local. */
    printf_message("dump data structure as sockaddr_local");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_sockaddr_local_dump(er, sockaddr_local, NULL)) {
	handle_error();
      }
    }

    /* Dump the data structure as a sockaddr. */
    printf_message("dump data structure as sockaddr");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_sockaddr_dump(er, sockaddr_local, NULL)) {
	handle_error();
      }
    }

    /* Extract and check the address family as sockaddr_local. */
    {
      mmux_libc_network_address_family_t	family;

      mmux_libc_sockaddr_local_family_ref(&family, sockaddr_local);
      if (MMUX_LIBC_VALUEOF_AF_LOCAL == family.value) {
	printf_message("correct family as sockaddr_local");
      } else {
	printf_error("wrong family");
	handle_error();
      }
    }

    /* Extract and check the address family as sockaddr. */
    {
      mmux_libc_network_address_family_t	family;

      mmux_libc_sockaddr_family_ref(&family, sockaddr_local);
      if (MMUX_LIBC_VALUEOF_AF_LOCAL == family.value) {
	printf_message("correct family as sockaddr object");
      } else {
	printf_error("wrong family");
	handle_error();
      }
    }

    /* Extract and check the path. */
    {
      mmux_libc_fs_ptn_t			expected_fs_ptn;
      mmux_libc_fs_ptn_t			field_fs_ptn;
      bool					are_equal;

      /* Extract the field. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_sockaddr_local_path_ref(field_fs_ptn, fs_ptn_factory, sockaddr_local)) {
	  handle_error();
	}
      }

      /* Build expected pathname. */
      {
	mmux_asciizcp_t			expected_ptn_asciiz = "/path/to/socket.sock";
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(expected_fs_ptn, fs_ptn_factory, expected_ptn_asciiz)) {
	  handle_error();
	}
      }

      if (mmux_libc_file_system_pathname_equal(&are_equal, field_fs_ptn, expected_fs_ptn)) {
	handle_error();
      } else if (are_equal) {
	printf_message("correct pathname");
      } else {
	printf_error("wrong pathname");
	handle_error();
      }

      /* Final cleanup. */
      {
	if (mmux_libc_unmake_file_system_pathname(field_fs_ptn)) {
	  handle_error();
	}
	if (mmux_libc_unmake_file_system_pathname(expected_fs_ptn)) {
	  handle_error();
	}
      }
    }
  }

  /* Compare objects of type sockaddr_local. */
  {
    /* Compare equal sockaddr_local objects. */
    {
      mmux_libc_sockaddr_local_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_fs_ptn_t		fs_ptn;

	/* Build socket's file system pathname. */
	{
	  mmux_asciizcp_t		ptn_asciiz = "/path/to/socket.sock";
	  mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	  mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	  if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	    handle_error();
	  }
	}

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_local_family_set(sockaddr1, MMUX_LIBC_AF_LOCAL)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_local_family_set(sockaddr2, MMUX_LIBC_AF_LOCAL)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_local_path_set(sockaddr1, fs_ptn)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_local_path_set(sockaddr2, fs_ptn)) {
	    handle_error();
	  }
	}

	/* Local cleanup. */
	{
	  if (mmux_libc_unmake_file_system_pathname(fs_ptn)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_local. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_local_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_message("correctly equal local socket addresses as sockaddr_local");
	} else {
	  printf_error("wrongly different local socket addresses as sockaddr_local");
	  handle_error();
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_message("correctly equal local socket addresses as sockaddr");
	} else {
	  printf_error("wrongly different local socket addresses as sockaddr");
	  handle_error();
	}
      }
    }

    /* Compare different sockaddr_local objects. */
    {
      mmux_libc_sockaddr_local_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_fs_ptn_t		fs_ptn1, fs_ptn2;

	/* Build socket's file system pathname. */
	{
	  mmux_asciizcp_t		ptn_asciiz1 = "/path/to/socket.one";
	  mmux_asciizcp_t		ptn_asciiz2 = "/path/to/socket.two";
	  mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	  mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	  if (mmux_libc_make_file_system_pathname(fs_ptn1, fs_ptn_factory, ptn_asciiz1)) {
	    handle_error();
	  }
	  if (mmux_libc_make_file_system_pathname(fs_ptn2, fs_ptn_factory, ptn_asciiz2)) {
	    handle_error();
	  }
	}

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_local_family_set(sockaddr1, MMUX_LIBC_AF_LOCAL)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_local_family_set(sockaddr2, MMUX_LIBC_AF_LOCAL)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_local_path_set(sockaddr1, fs_ptn1)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_local_path_set(sockaddr2, fs_ptn2)) {
	    handle_error();
	  }
	}

	/* Local cleanup. */
	{
	  if (mmux_libc_unmake_file_system_pathname(fs_ptn1)) {
	    handle_error();
	  }
	  if (mmux_libc_unmake_file_system_pathname(fs_ptn2)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_local. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_local_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal local socket addresses as sockaddr_local");
	  handle_error();
	} else {
	  printf_message("correctly different local socket addresses as sockaddr_local");
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal local socket addresses as sockaddr");
	  handle_error();
	} else {
	  printf_message("correctly different local socket addresses as sockaddr");
	}
      }
    }
  }

  printf_message("DONE: %s\n", __func__);
}


static void
test_sockaddr_ipfour (void)
{
  printf_message("testing: %s", __func__);
  {
    mmux_libc_sockaddr_ipfour_t  sockaddr_ipfour;

    /* Initialise the address. */
    {
      mmux_libc_ipfour_addr_t  address_ipfour;

      /* Build the IPv4 address. */
      {
	mmux_asciizcp_t	dotted_quad = "127.0.0.1";

	if (mmux_libc_make_ipfour_addr_from_asciiz(address_ipfour, dotted_quad)) {
	  handle_error();
	}
      }

      /* Initialise the fields. */
      {
	if (mmux_libc_sockaddr_ipfour_family_set(sockaddr_ipfour, MMUX_LIBC_AF_INET)) {
	  handle_error();
	}
	if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr_ipfour, address_ipfour)) {
	  handle_error();
	}
	{
	  /* SMTP port number is 25 in host byteorder, 0x1900 in network byteorder. */
          auto	port_num = mmux_libc_host_byteorder_uint16_literal(25);
	  auto	port     = mmux_libc_network_port_number_from_host_byteorder_value(port_num);

	  if (mmux_libc_sockaddr_ipfour_port_set(sockaddr_ipfour, port)) {
	    handle_error();
	  }
	}
      }
    }

    /* Dump the data structure as a sockaddr_ipfour. */
    printf_message("dump data structure as sockaddr_ipfour");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_sockaddr_ipfour_dump(er, sockaddr_ipfour, NULL)) {
	handle_error();
      }
    }

    /* Dump the data structure as a sockaddr. */
    printf_message("dump data structure as sockaddr");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_sockaddr_dump(er, sockaddr_ipfour, NULL)) {
	handle_error();
      }
    }

    /* Extract and check the address family as sockaddr_ipfour. */
    {
      mmux_libc_network_address_family_t	family;

      mmux_libc_sockaddr_ipfour_family_ref(&family, sockaddr_ipfour);
      if (MMUX_LIBC_VALUEOF_AF_INET == family.value) {
	printf_message("correct family as sockaddr_ipfour");
      } else {
	printf_error("wrong family");
	handle_error();
      }
    }

    /* Extract and check the address family as sockaddr. */
    {
      mmux_libc_network_address_family_t	family;

      mmux_libc_sockaddr_family_ref(&family, sockaddr_ipfour);
      if (MMUX_LIBC_VALUEOF_AF_INET == family.value) {
	printf_message("correct family as sockaddr object");
      } else {
	printf_error("wrong family");
	handle_error();
      }
    }

    /* Extract and check the Internet Protocol address. */
    {
      mmux_libc_ipfour_addr_t	field_address_ipfour;
      mmux_libc_ipfour_addr_t	expected_address_ipfour;
      bool			are_equal;

      if (mmux_libc_sockaddr_ipfour_addr_ref(field_address_ipfour, sockaddr_ipfour)) {
	handle_error();
      }
      {
	mmux_asciizcp_t	dotted_quad = "127.0.0.1";

	if (mmux_libc_make_ipfour_addr_from_asciiz(expected_address_ipfour, dotted_quad)) {
	  handle_error();
	}
      }

      mmux_libc_ipfour_addr_equal(&are_equal, field_address_ipfour, expected_address_ipfour);
      if (are_equal) {
	printf_message("correct IPv4 address from sockaddr_ipfour field");
      } else {
	printf_error("wrong IPv4 address from sockaddr_ipfour field");
	handle_error();
      }
    }

    /* Extract and check the port number. */
    {
      auto	expected_port_num = mmux_libc_host_byteorder_uint16_literal(25);
      auto	expected_port     = mmux_libc_network_port_number_from_host_byteorder_value(expected_port_num);
      mmux_libc_network_port_number_t	field_port;

      if (mmux_libc_sockaddr_ipfour_port_ref(&field_port, sockaddr_ipfour)) {
	handle_error();
      }
      if (field_port.value == expected_port.value) {
	printf_message("correct port number from sockaddr_ipfour field");
      } else {
	printf_error("wrong port number from sockaddr_ipfour field");
	handle_error();
      }
    }
  }

  /* Compare objects of type sockaddr_ipfour. */
  {
    /* Compare equal sockaddr_ipfour objects. */
    {
      mmux_libc_sockaddr_ipfour_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_ipfour_addr_t			ipaddr;
	mmux_libc_network_port_number_t		ipport;

	/* Build the IPv4 address. */
	{
	  mmux_asciizcp_t	dotted_quad = "127.0.0.1";

	  if (mmux_libc_make_ipfour_addr_from_asciiz(ipaddr, dotted_quad)) {
	    handle_error();
	  }
	}

	ipport = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(25));

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_ipfour_family_set(sockaddr1, MMUX_LIBC_AF_INET)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_family_set(sockaddr2, MMUX_LIBC_AF_INET)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr1, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr2, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_port_set(sockaddr1, ipport)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_port_set(sockaddr2, ipport)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_ipfour. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_ipfour_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_message("correctly equal ipfour socket addresses as sockaddr_ipfour");
	} else {
	  printf_error("wrongly different ipfour socket addresses as sockaddr_ipfour");
	  handle_error();
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_message("correctly equal ipfour socket addresses as sockaddr");
	} else {
	  printf_error("wrongly different ipfour socket addresses as sockaddr");
	  handle_error();
	}
      }
    }

    /* Compare sockaddr_ipfour objects, different by IP address. */
    {
      mmux_libc_sockaddr_ipfour_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_ipfour_addr_t			ipaddr1, ipaddr2;
	mmux_libc_network_port_number_t		ipport;

	/* Build the IPv4 address. */
	{
	  mmux_asciizcp_t	dotted_quad1 = "127.0.0.1";
	  mmux_asciizcp_t	dotted_quad2 = "127.0.0.2";

	  if (mmux_libc_make_ipfour_addr_from_asciiz(ipaddr1, dotted_quad1)) {
	    handle_error();
	  }
	  if (mmux_libc_make_ipfour_addr_from_asciiz(ipaddr2, dotted_quad2)) {
	    handle_error();
	  }
	}

	ipport = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(25));

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_ipfour_family_set(sockaddr1, MMUX_LIBC_AF_INET)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_family_set(sockaddr2, MMUX_LIBC_AF_INET)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr1, ipaddr1)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr2, ipaddr2)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_port_set(sockaddr1, ipport)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_port_set(sockaddr2, ipport)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_ipfour. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_ipfour_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipfour socket addresses as sockaddr_ipfour");
	  handle_error();
	} else {
	  printf_message("correctly different ipfour socket addresses as sockaddr_ipfour");
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipfour socket addresses as sockaddr");
	  handle_error();
	} else {
	  printf_message("correctly different ipfour socket addresses as sockaddr");
	}
      }
    }

    /* Compare sockaddr_ipfour objects, different by IP port. */
    {
      mmux_libc_sockaddr_ipfour_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_ipfour_addr_t			ipaddr;
	mmux_libc_network_port_number_t		ipport1, ipport2;

	/* Build the IPv4 address. */
	{
	  mmux_asciizcp_t	dotted_quad = "127.0.0.1";

	  if (mmux_libc_make_ipfour_addr_from_asciiz(ipaddr, dotted_quad)) {
	    handle_error();
	  }
	}

	ipport1 = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(25));
	ipport2 = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(80));

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_ipfour_family_set(sockaddr1, MMUX_LIBC_AF_INET)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_family_set(sockaddr2, MMUX_LIBC_AF_INET)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr1, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_addr_set(sockaddr2, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_port_set(sockaddr1, ipport1)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipfour_port_set(sockaddr2, ipport2)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_ipfour. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_ipfour_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipfour socket addresses as sockaddr_ipfour");
	  handle_error();
	} else {
	  printf_message("correctly different ipfour socket addresses as sockaddr_ipfour");
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipfour socket addresses as sockaddr");
	  handle_error();
	} else {
	  printf_message("correctly different ipfour socket addresses as sockaddr");
	}
      }
    }
  }

  printf_message("DONE: %s\n", __func__);
}


static void
test_sockaddr_ipsix (void)
{
  printf_message("testing: %s", __func__);
  {
    mmux_libc_sockaddr_ipsix_t  sockaddr_ipsix;

    /* Initialise the address. */
    {
      mmux_libc_ipsix_addr_t  address_ipsix;

      /* Build the IPv6 address. */
      {
	mmux_asciizcp_t		presentation = "1:2:3:4:5:6:7:8";

	if (mmux_libc_make_ipsix_addr_from_asciiz(address_ipsix, presentation)) {
	  handle_error();
	}
      }

      /* Initialise the fields. */
      {
	if (mmux_libc_sockaddr_ipsix_family_set(sockaddr_ipsix, MMUX_LIBC_AF_INET6)) {
	  handle_error();
	}
	if (mmux_libc_sockaddr_ipsix_addr_set(sockaddr_ipsix, address_ipsix)) {
	  handle_error();
	}
	{
	  /* SMTP port number is 25 in host byteorder, 0x1900 in network byteorder. */
          auto	port_num = mmux_libc_host_byteorder_uint16_literal(25);
	  auto	port     = mmux_libc_network_port_number_from_host_byteorder_value(port_num);

	  if (mmux_libc_sockaddr_ipsix_port_set(sockaddr_ipsix, port)) {
	    handle_error();
	  }
	}
	if (mmux_libc_sockaddr_ipsix_flowinfo_set(sockaddr_ipsix, mmux_uint32_constant_zero())) {
	  handle_error();
	}
	if (mmux_libc_sockaddr_ipsix_scope_id_set(sockaddr_ipsix, mmux_uint32_constant_zero())) {
	  handle_error();
	}
      }
    }

    /* Dump the data structure as a sockaddr_ipsix. */
    printf_message("dump data structure as sockaddr_ipsix");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_sockaddr_ipsix_dump(er, sockaddr_ipsix, NULL)) {
	handle_error();
      }
    }

    /* Dump the data structure as a sockaddr. */
    printf_message("dump data structure as sockaddr");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_sockaddr_dump(er, sockaddr_ipsix, NULL)) {
	handle_error();
      }
    }

    /* Extract and check the address family as sockaddr_ipsix. */
    {
      mmux_libc_network_address_family_t	family;

      mmux_libc_sockaddr_ipsix_family_ref(&family, sockaddr_ipsix);
      if (MMUX_LIBC_VALUEOF_AF_INET6 == family.value) {
	printf_message("correct family as sockaddr_ipsix");
      } else {
	printf_error("wrong family");
	handle_error();
      }
    }

    /* Extract and check the address family as sockaddr. */
    {
      mmux_libc_network_address_family_t	family;

      mmux_libc_sockaddr_family_ref(&family, sockaddr_ipsix);
      if (MMUX_LIBC_VALUEOF_AF_INET6 == family.value) {
	printf_message("correct family as sockaddr object");
      } else {
	printf_error("wrong family");
	handle_error();
      }
    }

    /* Extract and check the Internet Protocol address. */
    {
      mmux_libc_ipsix_addr_t	field_address_ipsix;
      mmux_libc_ipsix_addr_t	expected_address_ipsix;
      bool			are_equal;

      if (mmux_libc_sockaddr_ipsix_addr_ref(field_address_ipsix, sockaddr_ipsix)) {
	handle_error();
      }
      {
	mmux_asciizcp_t		presentation = "1:2:3:4:5:6:7:8";

	if (mmux_libc_make_ipsix_addr_from_asciiz(expected_address_ipsix, presentation)) {
	  handle_error();
	}
      }

      mmux_libc_ipsix_addr_equal(&are_equal, field_address_ipsix, expected_address_ipsix);
      if (are_equal) {
	printf_message("correct IPv6 address from sockaddr_ipsix field");
      } else {
	printf_error("wrong IPv6 address from sockaddr_ipsix field");
	handle_error();
      }
    }

    /* Extract and check the port number. */
    {
      auto	expected_port_num = mmux_libc_host_byteorder_uint16_literal(25);
      auto	expected_port     = mmux_libc_network_port_number_from_host_byteorder_value(expected_port_num);
      mmux_libc_network_port_number_t	field_port;

      if (mmux_libc_sockaddr_ipsix_port_ref(&field_port, sockaddr_ipsix)) {
	handle_error();
      }
      if (field_port.value == expected_port.value) {
	printf_message("correct port number from sockaddr_ipsix field");
      } else {
	printf_error("wrong port number from sockaddr_ipsix field");
	handle_error();
      }
    }
  }

  /* Compare objects of type sockaddr_ipsix. */
  {
    /* Compare equal sockaddr_ipsix objects. */
    {
      mmux_libc_sockaddr_ipsix_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_ipsix_addr_t			ipaddr;
	mmux_libc_network_port_number_t		ipport;

	/* Build the IPv6 address. */
	{
	  mmux_asciizcp_t	presentation = "1:2:3:4:5:6:7:8";

	  if (mmux_libc_make_ipsix_addr_from_asciiz(ipaddr, presentation)) {
	    handle_error();
	  }
	}

	ipport = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(25));

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_ipsix_family_set(sockaddr1, MMUX_LIBC_AF_INET6)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_family_set(sockaddr2, MMUX_LIBC_AF_INET6)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_addr_set(sockaddr1, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_addr_set(sockaddr2, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_flowinfo_set(sockaddr1, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_flowinfo_set(sockaddr2, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_scope_id_set(sockaddr1, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_scope_id_set(sockaddr2, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_port_set(sockaddr1, ipport)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_port_set(sockaddr2, ipport)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_ipsix. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_ipsix_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_message("correctly equal ipsix socket addresses as sockaddr_ipsix");
	} else {
	  printf_error("wrongly different ipsix socket addresses as sockaddr_ipsix");
	  handle_error();
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_message("correctly equal ipsix socket addresses as sockaddr");
	} else {
	  printf_error("wrongly different ipsix socket addresses as sockaddr");
	  handle_error();
	}
      }
    }

    /* Compare sockaddr_ipsix objects, different by IP address. */
    {
      mmux_libc_sockaddr_ipsix_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_ipsix_addr_t			ipaddr1, ipaddr2;
	mmux_libc_network_port_number_t		ipport;

	/* Build the IPv6 address. */
	{
	  mmux_asciizcp_t	presentation1 = "1:2:3:4:5:6:7:8";
	  mmux_asciizcp_t	presentation2 = "1:2:3:4:5:6:7:0";

	  if (mmux_libc_make_ipsix_addr_from_asciiz(ipaddr1, presentation1)) {
	    handle_error();
	  }
	  if (mmux_libc_make_ipsix_addr_from_asciiz(ipaddr2, presentation2)) {
	    handle_error();
	  }
	}

	ipport = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(25));

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_ipsix_family_set(sockaddr1, MMUX_LIBC_AF_INET6)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_family_set(sockaddr2, MMUX_LIBC_AF_INET6)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_addr_set(sockaddr1, ipaddr1)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_addr_set(sockaddr2, ipaddr2)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_flowinfo_set(sockaddr2, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_scope_id_set(sockaddr1, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_scope_id_set(sockaddr2, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_port_set(sockaddr1, ipport)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_port_set(sockaddr2, ipport)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_ipsix. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_ipsix_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipsix socket addresses as sockaddr_ipsix");
	  handle_error();
	} else {
	  printf_message("correctly different ipsix socket addresses as sockaddr_ipsix");
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipsix socket addresses as sockaddr");
	  handle_error();
	} else {
	  printf_message("correctly different ipsix socket addresses as sockaddr");
	}
      }
    }

    /* Compare sockaddr_ipsix objects, different by IP port. */
    {
      mmux_libc_sockaddr_ipsix_t	sockaddr1, sockaddr2;

      /* Initialise the objects. */
      {
	mmux_libc_ipsix_addr_t			ipaddr;
	mmux_libc_network_port_number_t		ipport1, ipport2;

	/* Build the IPv6 address. */
	{
	  mmux_asciizcp_t	presentation = "1:2:3:4:5:6:7:8";

	  if (mmux_libc_make_ipsix_addr_from_asciiz(ipaddr, presentation)) {
	    handle_error();
	  }
	}

	ipport1 = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(25));
	ipport2 = mmux_libc_network_port_number_from_host_byteorder_value(mmux_libc_host_byteorder_uint16_literal(80));

	/* Initialise the fields. */
	{
	  if (mmux_libc_sockaddr_ipsix_family_set(sockaddr1, MMUX_LIBC_AF_INET6)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_family_set(sockaddr2, MMUX_LIBC_AF_INET6)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_addr_set(sockaddr1, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_addr_set(sockaddr2, ipaddr)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_flowinfo_set(sockaddr2, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_scope_id_set(sockaddr1, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_scope_id_set(sockaddr2, mmux_uint32_constant_zero())) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_port_set(sockaddr1, ipport1)) {
	    handle_error();
	  }
	  if (mmux_libc_sockaddr_ipsix_port_set(sockaddr2, ipport2)) {
	    handle_error();
	  }
	}
      }

      /* Compare the objects as sockaddr_ipsix. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_ipsix_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipsix socket addresses as sockaddr_ipsix");
	  handle_error();
	} else {
	  printf_message("correctly different ipsix socket addresses as sockaddr_ipsix");
	}
      }

      /* Compare the objects as sockaddr. */
      {
	bool	are_equal;

	if (mmux_libc_sockaddr_equal(&are_equal, sockaddr1, sockaddr2)) {
	  handle_error();
	}
	if (are_equal) {
	  printf_error("wrongly equal ipsix socket addresses as sockaddr");
	  handle_error();
	} else {
	  printf_message("correctly different ipsix socket addresses as sockaddr");
	}
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
    PROGNAME = "test-networking-struct-sockaddr-all";
  }

  if (true) {	test_sockaddr_local();		}
  if (true) {	test_sockaddr_ipfour();		}
  if (true) {	test_sockaddr_ipsix();		}

  mmux_libc_exit_success();
}

/* end of file */
