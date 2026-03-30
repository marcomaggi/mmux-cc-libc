/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 14, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025, 2026 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_old = "./test-file-system-linkat.src.ext";
static mmux_asciizcp_t	ptn_asciiz_new = "./test-file-system-linkat.dst.ext";


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
    cleanfiles_register(ptn_asciiz_old);
    cleanfiles_register(ptn_asciiz_new);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz_old)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_fs_ptn_t  fs_ptn_old, fs_ptn_new;

    {
      mmux_libc_fs_ptn_factory_t  fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn_old, fs_ptn_factory, ptn_asciiz_old)) {
	printf_error("making old file pathname");
	handle_error();
      }
      if (mmux_libc_make_file_system_pathname(fs_ptn_new, fs_ptn_factory, ptn_asciiz_new)) {
	printf_error("making new file pathname");
	handle_error();
      }
    }
    {
      mmux_libc_dirfd_t  dirfd_old, dirfd_new;
      auto               flags = mmux_libc_linkat_flags(MMUX_LIBC_AT_SYMLINK_FOLLOW);

      mmux_libc_at_fdcwd(dirfd_old);
      mmux_libc_at_fdcwd(dirfd_new);

      printf_message("linkat-ing");
      if (mmux_libc_linkat(dirfd_old, fs_ptn_old, dirfd_new, fs_ptn_new, flags)) {
	printf_error("linkat-ing");
	handle_error();
      }
    }

    /* Check file existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_new)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("link pathname exists as a directory entry");
      } else {
	printf_error("link pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_is_regular(&result, fs_ptn_new)) {
	printf_error("calling is_regular");
	handle_error();
      } else if (result) {
	printf_message("link pathname is a regular file");
      } else {
	printf_error("link pathname is NOT a regular file");
	mmux_libc_exit_failure();
      }
    }

    /* Final cleanup. */
    mmux_libc_file_system_pathname_final(fs_ptn_old);
    mmux_libc_file_system_pathname_final(fs_ptn_new);
  }

  mmux_libc_exit_success();
}

/* end of file */
