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
    PROGNAME = "test-persona-group-member";
  }

  /* Do it. */
  {
    mmux_libc_gid_t	gid;
    bool		this_process_belongs_to_group;

    if (mmux_libc_getgid(&gid)) {
      handle_error();
    } else if (mmux_libc_group_member(&this_process_belongs_to_group, gid)) {
      handle_error();
    } else if (this_process_belongs_to_group) {
      printf_message("it belongs");
    } else {
      printf_message("it does NOT belong");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
