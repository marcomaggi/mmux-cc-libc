/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 23, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_original      = "./test-file-system-canonicalize-file-name.d/../test-file-system-canonicalize-file-name.ext";
static mmux_asciizcp_t	ptn_asciiz_directory     = "./test-file-system-canonicalize-file-name.d";
static mmux_asciizcp_t	ptn_asciiz_canonicalised = "./test-file-system-canonicalize-file-name.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-canonicalize-file-name";
    cleanfiles_register(ptn_asciiz_original);
    cleanfiles_register(ptn_asciiz_directory);
    cleanfiles_register(ptn_asciiz_canonicalised);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the directory. */
  {
    printf_message("create the directory");
    if (test_create_directory(ptn_asciiz_directory)) {
      handle_error();
    }
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz_canonicalised)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_fs_ptn_t	fs_ptn_canonicalised, fs_ptn_original;

    /* Build the original file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t  fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn_original, fs_ptn_factory, ptn_asciiz_original)) {
	printf_error("creating the original pathname");
	handle_error();
      }
    }

    /* Retrieve the canonicalised pathname. */
    {
      mmux_libc_fs_ptn_factory_t  fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);

      printf_message("canonicalize-file-name-ing");
      if (mmux_libc_canonicalize_file_name(fs_ptn_canonicalised, fs_ptn_factory, fs_ptn_original)) {
	printf_error("canonicalize-file-name-ing");
	handle_error();
      }
    }

    if (true) {
      printf_message("original pathname:      \"%s\"", fs_ptn_original->value);
      printf_message("canonicalised pathname: \"%s\"", fs_ptn_canonicalised->value);
    }

    /* Check real file existence. */
    {
      bool		result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_canonicalised)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("canonicalize-file-name pathname exists as a directory entry");
      } else {
	printf_error("canonicalize-file-name pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_is_regular(&result, fs_ptn_canonicalised)) {
	printf_error("calling is_regular");
	handle_error();
      } else if (result) {
	printf_message("canonicalize-file-name pathname is a regular file");
      } else {
	printf_error("canonicalize-file-name pathname is NOT a regular file");
	mmux_libc_exit_failure();
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn_original);
      mmux_libc_unmake_file_system_pathname(fs_ptn_canonicalised);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
