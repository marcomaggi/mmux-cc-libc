/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 16, 2025

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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-fstatat.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-fstatat";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  mmux_libc_ptn_t	ptn;

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(src_pathname_asciiz)) {
      handle_error();
    }
  }

  if (mmux_libc_make_file_system_pathname(&ptn, src_pathname_asciiz)) {
    handle_error();
  }

  /* Do it. */
  {
    mmux_libc_stat_t	ST[1];
    mmux_sint_t		flags = MMUX_LIBC_AT_SYMLINK_NOFOLLOW;
    mmux_libc_fd_t	dirfd;

    mmux_libc_at_fdcwd(&dirfd);

    printf_message("fstatatting");
    if (mmux_libc_fstatat(dirfd, ptn, ST, flags)) {
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

  mmux_libc_exit_success();
}

/* end of file */
