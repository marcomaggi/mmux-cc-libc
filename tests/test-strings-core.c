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


static void
test_strings_copying (void)
{
  printf_string("%s: ", __func__);

  /* strcpy() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    char		dstptr[20];
    mmux_usize_t	buflen;

    assert(false == mmux_libc_strlen(&buflen, srcptr));

    assert(false == mmux_libc_strcpy(dstptr, srcptr));
    assert('\0' == dstptr[19]);
    assert(false == mmux_libc_dprintfer("strcpy: %s\n", dstptr));
  }

  /* strncpy() copy the full strings */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    auto		dstlen = mmux_usize_literal(64);
    char		dstptr[dstlen.value];

    assert(false == mmux_libc_strncpy(dstptr, srcptr, dstlen));
    assert('\0' == dstptr[19]);
    assert(false == mmux_libc_dprintfer("strncpy: %s\n", dstptr));
  }

  /* stpcpy() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    char		dstptr[20];
    mmux_asciizp_t	next_dstptr;

    assert(false == mmux_libc_stpcpy(&next_dstptr, dstptr, srcptr));
    assert('\0' == *next_dstptr);
    assert(false == mmux_libc_dprintfer("stpcpy: %s\n", dstptr));
  }

  /* stpncpy() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    auto		dstlen = mmux_usize_literal(64);
    char		dstptr[dstlen.value];
    mmux_asciizp_t	next_dstptr;

    assert(false == mmux_libc_stpncpy(&next_dstptr, dstptr, srcptr, dstlen));
    assert('\0' == *next_dstptr);
    assert(false == mmux_libc_dprintfer("stpncpy: %s\n", dstptr));
  }

  /* strdup() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    mmux_asciizcp_t	dstptr;

    if (mmux_libc_strdup(&dstptr, srcptr)) {
      handle_error();
    } else {
      assert(false == mmux_libc_dprintfer("strdup: %s\n", dstptr));
      mmux_libc_free((mmux_pointer_t)dstptr);
    }
  }

  /* strndup() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    auto		dstlen = mmux_usize_literal(11);
    mmux_asciizp_t	dstptr;

    if (mmux_libc_strndup((mmux_asciizcp_t *)&dstptr, srcptr, dstlen)) {
      handle_error();
    } else {
      dstptr[10] = '\0';
      assert(false == mmux_libc_dprintfer("strndup: %s\n", dstptr));
      mmux_libc_free((mmux_pointer_t)dstptr);
    }
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
  if (1) {	test_strings_copying();		}

  mmux_libc_exit_success();
}

/* end of file */
