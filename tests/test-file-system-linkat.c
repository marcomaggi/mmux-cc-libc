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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-linkat.src.ext";
static mmux_asciizcp_t		dst_pathname_asciiz = "./test-file-system-linkat.dst.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-linkat";
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
    mmux_libc_fd_t	fd;
    mmux_sint_t		flags = MMUX_LIBC_AT_SYMLINK_FOLLOW;

    if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &src_ptn, src_pathname_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &dst_ptn, dst_pathname_asciiz)) {
      handle_error();
    }

    mmux_libc_at_fdcwd(&fd);

    printf_message("linkating");
    if (mmux_libc_linkat(fd, src_ptn, fd, dst_ptn, flags)) {
      handle_error();
    }

    /* Check file existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, dst_ptn)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("link pathname exists as a directory entry");
      } else {
	printf_error("link pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_is_regular(&result, dst_ptn)) {
	printf_error("calling is_regular");
	handle_error();
      } else if (result) {
	printf_message("link pathname is a regular file");
      } else {
	printf_error("link pathname is NOT a regular file");
	mmux_libc_exit_failure();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
