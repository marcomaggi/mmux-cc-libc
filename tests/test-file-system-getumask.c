/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 21, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

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
    PROGNAME			= "test-file-system-getumask";
  }

  {
    mmux_mode_t		old_mask;

    if (mmux_libc_getumask(&old_mask)) {
      handle_error();
    }

    printf_message("the old mask is: 0%lo", (mmux_ulong_t)old_mask);
  }

  mmux_libc_exit_success();
}

/* end of file */
