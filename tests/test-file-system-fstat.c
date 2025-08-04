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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-fstat.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-fstat";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  mmux_libc_ptn_t	ptn;
  mmux_libc_fd_t	fd;

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(src_pathname_asciiz)) {
      handle_error();
    }
  }

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, src_pathname_asciiz)) {
    handle_error();
  }

  /* Open the data file. */
  {
    mmux_sint_t		flags = MMUX_LIBC_O_PATH | MMUX_LIBC_O_NOFOLLOW;
    mmux_mode_t		mode  = 0;

    if (mmux_libc_open(&fd, ptn, flags, mode)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_stat_t	ST[1];

    printf_message("fstatting");
    if (mmux_libc_fstat(fd, ST)) {
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
