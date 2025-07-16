/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 15, 2025

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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-lstat.src.ext";
static mmux_asciizcp_t		dst_pathname_asciiz = "./test-file-system-lstat.dst.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-lstat";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles_register(dst_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  mmux_libc_ptn_t	src_ptn, dst_ptn;

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(src_pathname_asciiz)) {
      handle_error();
    }
  }

  if (mmux_libc_make_file_system_pathname(&src_ptn, src_pathname_asciiz)) {
    handle_error();
  }

  if (mmux_libc_make_file_system_pathname(&dst_ptn, dst_pathname_asciiz)) {
    handle_error();
  }

  /* Create the symbolic link. */
  {
    printf_message("create the symbolic link");
    if (mmux_libc_symlink(src_ptn, dst_ptn)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_stat_t	ST[1];

    printf_message("lstatting");
    if (mmux_libc_lstat(dst_ptn, ST)) {
      handle_error();
    } else {
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
