/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct  9, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


static void
test_strings_strlen (void)
{
  printf_string("%s: ", __func__);

  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	bufptr = "the colour of water";
    mmux_usize_t	buflen;

    assert(false == mmux_libc_strlen(&buflen, bufptr));
    assert(19 == buflen.value);
  }

  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	bufptr = "the colour of water";
    mmux_usize_t	buflen;

    assert(false == mmux_libc_strlen_plus_nil(&buflen, bufptr));
    assert(20 == buflen.value);
  }

  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	bufptr = "the colour of water";
    auto		maxlen = mmux_usize_literal(10);
    typeof(maxlen)	buflen;

    assert(false == mmux_libc_strnlen(&buflen, bufptr, maxlen));
    assert(10 == buflen.value);
  }

  printf_string(" DONE\n");
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
    PROGNAME = "test-strings-core";
  }

  if (1) {	test_strings_strlen();		}

  mmux_libc_exit_success();
}

/* end of file */
