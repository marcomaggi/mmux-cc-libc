/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 22, 2025

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

static mmux_asciizcp_t	ptn_asciiz_src = "./test-file-system-symlinkat.src.ext";
static mmux_asciizcp_t	ptn_asciiz_dst = "./test-file-system-symlinkat.dst.ext";


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

    {
      mmux_libc_dirfd_t		dirfd_dst;

      mmux_libc_at_fdcwd(dirfd_dst);

      printf_message("symlinkat-ing");
      if (mmux_libc_symlinkat(fs_ptn_src, dirfd_dst, fs_ptn_dst)) {
	handle_error();
	printf_error("symlinkat-ing");
      }
    }

    if (false) {
      printf_message("original link pathname: \"%s\"", fs_ptn_src->value);
      printf_message("symbolic link pathname: \"%s\"", fs_ptn_dst->value);
    }

    /* Check file existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_dst)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("symlink pathname exists as a directory entry");
      } else {
	printf_error("symlink pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_is_symlink(&result, fs_ptn_dst)) {
	printf_error("calling is_symlink");
	handle_error();
      } else if (result) {
	printf_message("symlink pathname is a symbolic link");
      } else {
	printf_error("symlink pathname is NOT a symbolic link");
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
