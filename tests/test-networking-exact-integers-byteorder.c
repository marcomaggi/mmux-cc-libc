/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 20, 2025

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
    PROGNAME = "test-networking-sockets-byteorder";
  }

  {
    auto					A = mmux_libc_host_byteorder_uint16_literal(0x1122);
    mmux_libc_network_byteorder_uint16_t	B;

    mmux_libc_htons(&B, A);
    printf_message("host byteorder uint16 is '0x%x', corresponding network byte order is: '0x%x'",
		   A.value, B.value);
  }

  {
    auto				A = mmux_libc_network_byteorder_uint32(0x11223344);
    mmux_libc_host_byteorder_uint32_t	B;

    mmux_libc_ntohl(&B, A);
    printf_message("network byteorder uint32 is '0x%x', corresponding host byte order is: '0x%x'",
		   A.value, B.value);
  }

  {
    auto					A = mmux_libc_host_byteorder_uint32(0x11223344);
    mmux_libc_network_byteorder_uint32_t	B;

    mmux_libc_htonl(&B, A);
    printf_message("host byteorder uint32 is '0x%x', corresponding network byte order is: '0x%x'",
		   A.value, B.value);
  }

  {
    auto				A = mmux_libc_network_byteorder_uint16(0x1122);
    mmux_libc_host_byteorder_uint16_t	B;

    mmux_libc_ntohs(&B, A);
    printf_message("network byteorder uint16 is '0x%x', corresponding host byte order is: '0x%x'",
		   A.value, B.value);
  }

  mmux_libc_exit_success();
}

/* end of file */
