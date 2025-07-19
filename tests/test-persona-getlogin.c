/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Jul 18, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc.h>
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
    PROGNAME = "test-persona-getlogin";
  }

  /* Do it. */
  {
    mmux_asciizcp_t	name;

    if (mmux_libc_getlogin(&name)) {
      handle_error();
    }
    printf_message("the name is: %s", name);
  }

  mmux_libc_exit_success();
}

/* end of file */
