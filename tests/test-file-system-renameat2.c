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

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_src = "./test-file-system-renameat2.src.ext";
static mmux_asciizcp_t	ptn_asciiz_dst = "./test-file-system-renameat2.dst.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-renameat2";
    cleanfiles_register(ptn_asciiz_src);
    cleanfiles_register(ptn_asciiz_dst);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz_src)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_fs_ptn_t	fs_ptn_src, fs_ptn_dst;

    /* Build the file system pathnames. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn_src, fs_ptn_factory, ptn_asciiz_src)) {
	handle_error();
      }
      if (mmux_libc_make_file_system_pathname(fs_ptn_dst, fs_ptn_factory, ptn_asciiz_dst)) {
	handle_error();
      }
    }

    /* Rename the file. */
    {
      mmux_libc_dirfd_t		dirfd;
      auto			flags = mmux_libc_renameat2_flags(MMUX_LIBC_RENAME_NOREPLACE);

      mmux_libc_at_fdcwd(dirfd);

      printf_message("renamat2-ing");
      if (mmux_libc_renameat2(dirfd, fs_ptn_src, dirfd, fs_ptn_dst, flags)) {
	printf_error("renamat2-ing");
	handle_error();
      }
    }

    /* Check file existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_dst)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("link pathname exists as a directory entry");
      } else {
	printf_error("link pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_is_regular(&result, fs_ptn_dst)) {
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
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn_src);
      mmux_libc_unmake_file_system_pathname(fs_ptn_dst);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
