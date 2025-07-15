/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 14, 2025

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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-symlink.src.ext";
static mmux_asciizcp_t		dst_pathname_asciiz = "./test-file-system-symlink.dst.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-symlink";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles_register(dst_pathname_asciiz);
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

  /* Do it. */
  {
    mmux_libc_ptn_t	src_ptn, dst_ptn;

    if (mmux_libc_make_file_system_pathname(&src_ptn, src_pathname_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(&dst_ptn, dst_pathname_asciiz)) {
      handle_error();
    }

    printf_message("symlinking");
    if (mmux_libc_symlink(src_ptn, dst_ptn)) {
      handle_error();
    }

    if (0) {
      printf_message("original link pathname: \"%s\"", src_ptn.value);
      printf_message("symbolic link pathname: \"%s\"", dst_ptn.value);
    }

    /* Check file existence. */
    {
      bool	result;

      if (mmux_libc_file_exists(&result, dst_ptn)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("symlink pathname exists as a directory entry");
      } else {
	printf_error("symlink pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_is_symlink(&result, dst_ptn)) {
	printf_error("calling is_symlink");
	handle_error();
      } else if (result) {
	printf_message("symlink pathname is a symbolic link");
      } else {
	printf_error("symlink pathname is NOT a symbolic link");
	mmux_libc_exit_failure();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
