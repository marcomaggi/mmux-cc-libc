/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 22, 2025

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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-truncate.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-truncate";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(src_pathname_asciiz)) {
      handle_error();
    }
  }

  mmux_libc_ptn_t	ptn;

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, src_pathname_asciiz)) {
    handle_error();
  }

  /* Do it. */
  {
    mmux_off_t		len = 10;

    printf_message("truncateing");
    if (mmux_libc_truncate(ptn, len)) {
      handle_error();
    }
  }

  /* Check size. */
  {
    mmux_libc_fd_t	dirfd;
    mmux_usize_t	len;

    mmux_libc_at_fdcwd(&dirfd);

    if (mmux_libc_file_system_pathname_file_size_ref(&len, dirfd, ptn)) {
      handle_error();
    } else {
      printf_message("size check: %lu", len);
    }

    if (10 != len) {
      print_error("wrong size");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
