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

  mmux_libc_exit_success();
}

/* end of file */
