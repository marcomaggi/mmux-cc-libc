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

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_file      = "./test-file-system-unlinkat.src.ext";
static mmux_asciizcp_t	ptn_asciiz_directory = "./test-file-system-unlinkat.d";


static void
unlink_file (void)
{
  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz_file)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_fs_ptn_t	fs_ptn;

    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz_file)) {
	handle_error();
      }
    }

    {
      mmux_libc_dirfd_t	dirfd;
      auto		flags = mmux_libc_unlinkat_flags(0);

      mmux_libc_at_fdcwd(dirfd);

      printf_message("unlinkat-ing");
      if (mmux_libc_unlinkat(dirfd, fs_ptn, flags)) {
	printf_error("unlinkat-ing");
	handle_error();
      }
    }

    /* Check file existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn)) {
	printf_error("exists");
	handle_error();
      } else if (! result) {
	printf_message("link pathname has been unlinkated");
      } else {
	printf_error("link pathname has NOT been unlinkated");
	mmux_libc_exit_failure();
      }
    }

    /* Cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn);
    }
  }
}


static void
unlink_directory (void)
{
  /* Create the data file. */
  {
    printf_message("create the directory");
    if (test_create_directory(ptn_asciiz_directory)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_fs_ptn_t	fs_ptn;

    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz_directory)) {
	handle_error();
      }
    }

    {
      mmux_libc_dirfd_t	dirfd;
      auto		flags = mmux_libc_unlinkat_flags(MMUX_LIBC_AT_REMOVEDIR);

      mmux_libc_at_fdcwd(dirfd);

      printf_message("unlinkat-ing");
      if (mmux_libc_unlinkat(dirfd, fs_ptn, flags)) {
	printf_error("unlinkat-ing");
	handle_error();
      }
    }

    /* Check file existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn)) {
	printf_error("exists");
	handle_error();
      } else if (! result) {
	printf_message("link pathname has been unlinkated");
      } else {
	printf_error("link pathname has NOT been unlinkated");
	mmux_libc_exit_failure();
      }
    }

    /* Cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn);
    }
  }
}


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-unlinkat";
    cleanfiles_register(ptn_asciiz_file);
    cleanfiles_register(ptn_asciiz_directory);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  unlink_file();
  unlink_directory();

  mmux_libc_exit_success();
}

/* end of file */
