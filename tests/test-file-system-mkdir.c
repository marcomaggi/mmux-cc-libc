/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 17, 2025

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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-mkdir.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-mkdir";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Do it. */
  {
    mmux_libc_ptn_t	src_ptn;
    mmux_mode_t		mode = MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR | MMUX_LIBC_S_IXUSR;

    if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &src_ptn, src_pathname_asciiz)) {
      handle_error();
    }
    printf_message("mkdiring");
    if (mmux_libc_mkdir(src_ptn, mode)) {
      handle_error();
    }

    /* Check directory existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, src_ptn)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("mkdir pathname exists as a directory entry");
      } else {
	printf_error("mkdir pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_is_directory(&result, src_ptn)) {
	printf_error("calling is_directory");
	handle_error();
      } else if (result) {
	printf_message("mkdir pathname is a directory");
      } else {
	printf_error("mkdir pathname is NOT a directory");
	mmux_libc_exit_failure();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
