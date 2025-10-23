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

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_original = "./test-file-system-readlinkat.original.ext";
static mmux_asciizcp_t	ptn_asciiz_symlink  = "./test-file-system-readlinkat.symlink.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-readlinkat";
    cleanfiles_register(ptn_asciiz_original);
    cleanfiles_register(ptn_asciiz_symlink);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz_original)) {
      handle_error();
    }
  }

  /* Create a symbolic link to the data file. */
  {
    mmux_libc_fs_ptn_t		fs_ptn_original, fs_ptn_symlink;
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn_original, fs_ptn_factory, ptn_asciiz_original)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(fs_ptn_symlink, fs_ptn_factory, ptn_asciiz_symlink)) {
      handle_error();
    }

    printf_message("creating symbolic link to original file");
    if (mmux_libc_symlink(fs_ptn_original, fs_ptn_symlink)) {
      printf_error("creating symbolic link to original file");
      handle_error();
    }

    if (true) {
      printf_message("original link pathname: \"%s\"", fs_ptn_original->value);
      printf_message("symbolic link pathname: \"%s\"", fs_ptn_symlink->value);
    }
  }

  /* Do it. */
  {
    mmux_libc_fs_ptn_t		fs_ptn_original, fs_ptn_symlink, fs_ptn_real;

    /* Build the file system pathnames. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn_original, fs_ptn_factory, ptn_asciiz_original)) {
	handle_error();
      }
      if (mmux_libc_make_file_system_pathname(fs_ptn_symlink, fs_ptn_factory, ptn_asciiz_symlink)) {
	handle_error();
      }
    }

    /* Retrieve the real file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;
      mmux_libc_dirfd_t			dirfd_symlink;

      mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
      mmux_libc_at_fdcwd(dirfd_symlink);

      printf_message("readlinkat-ing");
      if (mmux_libc_readlinkat(fs_ptn_real, fs_ptn_factory, dirfd_symlink, fs_ptn_symlink)) {
	printf_error("readlinkat-ing");
	handle_error();
      }
    }

    if (true) {
      printf_message("original link pathname: \"%s\"",   fs_ptn_original->value);
      printf_message("symbolic link pathname: \"%s\"",   fs_ptn_symlink->value);
      printf_message("readlinkat real pathname: \"%s\"", fs_ptn_real->value);
    }

    /* Validate the real file system pathname. */
    {
      bool		result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_real)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("readlinkat pathname exists as a directory entry");
      } else {
	printf_error("readlinkat pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_is_regular(&result, fs_ptn_real)) {
	printf_error("calling is_regular");
	handle_error();
      } else if (result) {
	printf_message("readlinkat pathname is a regular file");
      } else {
	printf_error("readlinkat pathname is NOT a regular file");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_equal(&result, fs_ptn_original, fs_ptn_real)) {
	handle_error();
      } else if (result) {
	printf_message("readlinkat pathname equals the original pathname");
      } else {
	printf_error("readlinkat pathname does NOT equal the original pathname");
	mmux_libc_exit_failure();
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn_original);
      mmux_libc_unmake_file_system_pathname(fs_ptn_symlink);
      mmux_libc_unmake_file_system_pathname(fs_ptn_real);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
