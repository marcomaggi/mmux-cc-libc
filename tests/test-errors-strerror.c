/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 12, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-strerror";
  }

  /* strerror() */
  {
    mmux_asciizcp_t	result;

    if (mmux_libc_strerror(&result, MMUX_LIBC_EINVAL)) {
      handle_error();
    }
    printf_message("strerror result: %s", result);
  }

  /* strerror_r() */
  {
    mmux_asciizcp_t	result;
    auto		buflen = mmux_usize_literal(1024);
    mmux_libc_char_array(bufptr, buflen);

    if (mmux_libc_strerror_r(&result, bufptr, buflen, MMUX_LIBC_EINVAL)) {
      handle_error();
    }
    printf_message("strerror_r result: %s", result);
  }

  /* strerrorname_np() */
  {
    mmux_asciizcp_t	result;

    if (mmux_libc_strerrorname_np(&result, MMUX_LIBC_EINVAL)) {
      handle_error();
    }
    printf_message("strerrorname_np result: %s", result);
  }

  /* strerrordesc_np() */
  {
    mmux_asciizcp_t	result;

    if (mmux_libc_strerrordesc_np(&result, MMUX_LIBC_EINVAL)) {
      handle_error();
    }
    printf_message("strerrordesc_np result: %s", result);
  }

  /* program_invocation_name */
  {
    mmux_asciizcp_t	result;

    if (mmux_libc_program_invocation_name(&result)) {
      handle_error();
    }
    printf_message("program_invocation_name result: %s", result);
  }

  /* program_invocation_short_name */
  {
    mmux_asciizcp_t	result;

    if (mmux_libc_program_invocation_short_name(&result)) {
      handle_error();
    }
    printf_message("program_invocation_short_name result: %s", result);
  }

  mmux_libc_exit_success();
}

/* end of file */
