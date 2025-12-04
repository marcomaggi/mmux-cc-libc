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
    PROGNAME = "test-networking-network-port-numbers";
  }

  /* Build  a  network  port  number  from   a  wrapped  16-bit  integer  in  network
     byteorder. */
  {
    auto	value = mmux_libc_network_byteorder_uint16_literal(0x1900);
    auto	port  = mmux_libc_network_port_number(value);

    if (0x1900 == port.value) {
      printf_message("correct: network byteorder uint16 '0x%x', port network byteorder is: '0x%x'",
		     value.value, port.value);
    } else {
      printf_error("error: network byteorder uint16 '0x%x', port network byteorder is: '0x%x'",
		   value.value, port.value);
      handle_error();
    }
  }

  /* Build a network port number from  a standard 16-bit integer in network byteorder
     literal. */
  {
    auto	port  = mmux_libc_network_port_number_literal(0x1900);

    if (0x1900 == port.value) {
      printf_message("correct: port network byteorder is: '0x%x'", port.value);
    } else {
      printf_error("error: port network byteorder is: '0x%x'", port.value);
      handle_error();
    }
  }

  /* Build  a  network  port  number  from   a  wrapped  16-bit  integer  in  network
     byteorder. */
  {
    auto	value = mmux_libc_host_byteorder_uint16_literal(25);
    auto	port  = mmux_libc_network_port_number_from_host_byteorder_value(value);

    if (0x1900 == port.value) {
      printf_message("correct: host byteorder uint16 '%u', port network byteorder is: '0x%x'",
		     value.value, port.value);
    } else {
      printf_error("error: host byteorder uint16 '%u', port network byteorder is: '0x%x'",
		   value.value, port.value);
      handle_error();
    }
  }

  /* Build a network port number from a standard 16-bit integer in host byteorder. */
  {
    auto	port  = mmux_libc_network_port_number_from_host_byteorder_literal(25);

    if (0x1900 == port.value) {
      printf_message("correct: port network byteorder is: '0x%x'", port.value);
    } else {
      printf_error("error: port network byteorder is: '0x%x'", port.value);
      handle_error();
    }
  }

  /* Build  a  network  port  number  from  a  standard  16-bit  integer  in  network
     byteorder. */
  {
    auto	port  = mmux_libc_network_port_number_from_network_byteorder_literal(0x1900);

    if (0x1900 == port.value) {
      printf_message("correct: port network byteorder is: '0x%x'", port.value);
    } else {
      printf_error("error: port network byteorder is: '0x%x'", port.value);
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
