/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 20, 2025

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
    PROGNAME = "test-file-system-dirfd";
  }

  {
    mmux_libc_ptn_t		dirptn;
    mmux_libc_dirstream_t	dirstream;
    mmux_libc_fd_t		dirfd;

    if (mmux_libc_make_file_system_pathname(&dirptn, ".")) {
      handle_error();
    }

    printf_message("opening directory stream");
    if (mmux_libc_opendir(&dirstream, dirptn)) {
      handle_error();
    }

    printf_message("dirfding");
    if (mmux_libc_dirfd(&dirfd, dirstream)) {
      handle_error();
    }

    /* Print stat. */
    {
      mmux_libc_stat_t	ST[1];

      printf_message("fstatting");
      if (mmux_libc_fstat(dirfd, ST)) {
	handle_error();
      }

      {
	mmux_libc_fd_t	er;

	mmux_libc_stder(&er);
	if (mmux_libc_stat_dump(er, ST, NULL)) {
	  handle_error();
	}
      }
    }

    printf_message("closing directory stream");
    if (mmux_libc_closedir(dirstream)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
