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
    PROGNAME = "test-networking-sockets-interface-names";
  }

  /* Converting a network interface name to its conventional index. */
  {
    mmux_asciizcp_t			 network_interface_name = "eth0";
    mmux_libc_network_interface_index_t	 network_interface_index;

    if (mmux_libc_if_nametoindex(&network_interface_index, network_interface_name)) {
      handle_error();
    } else {
      printf_message("the network interface index associated to the name '%s' is: '%u'",
		     network_interface_name, network_interface_index.value);
    }
  }

  /* Converting a conventional network interface index to its name. */
  {
    auto	network_interface_index = mmux_libc_network_interface_index(2);
    char	network_interface_name[MMUX_LIBC_IFNAMSIZ];

    if (mmux_libc_if_indextoname(network_interface_name, network_interface_index)) {
      handle_error();
    } else {
      printf_message("the network interface name associated to the index '%u' is: '%s'",
		     network_interface_index.value, network_interface_name);
    }
  }

  /* Inspecting the whole name/index association. */
  {
    mmux_libc_network_interface_name_index_t const *	nameindex;

    /* Obtain a pointer to the association array. */
    {
      if (mmux_libc_if_nameindex(&nameindex)) {
	handle_error();
      }
    }

    /* Iterate over the array. */
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      for (mmux_standard_uint_t i=0; ; ++i) {
	mmux_libc_network_interface_name_index_t const *  iter = &(nameindex[i]);
	mmux_libc_network_interface_index_t	if_index;
	mmux_asciizcp_t				if_name;

	mmux_libc_if_index_ref (&if_index, iter);
	mmux_libc_if_name_ref  (&if_name,  iter);

	if (if_index.value) {
	  mmux_libc_if_nameindex_dump(er, iter, NULL);
	} else {
	  break;
	}
      }
    }

    /* Final cleanup. */
    {
      if (mmux_libc_if_freenameindex(nameindex)) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
