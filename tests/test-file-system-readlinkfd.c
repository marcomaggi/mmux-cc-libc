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

static mmux_asciizcp_t	ptn_asciiz_original = "./test-file-system-readlinkfd.original.ext";
static mmux_asciizcp_t	ptn_asciiz_symlink  = "./test-file-system-readlinkfd.symlink.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-readlinkfd";
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
  printf_message("creating the symbolic link");
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

    if (mmux_libc_symlink(fs_ptn_original, fs_ptn_symlink)) {
      printf_error("creating the symbolic link");
      handle_error();
    }

    if (true) {
      printf_message("original link pathname: \"%s\"", fs_ptn_original->value);
      printf_message("symbolic link pathname: \"%s\"", fs_ptn_symlink->value);
    }

    mmux_libc_unmake_file_system_pathname(fs_ptn_symlink);
    mmux_libc_unmake_file_system_pathname(fs_ptn_original);
  }

  /* Do it. */
  {
    mmux_libc_fd_t	fd_symlink;
    mmux_libc_fs_ptn_t	fs_ptn_real;

    /* Open the symbolic-link file-descriptor. */
    {
      mmux_libc_fs_ptn_t	fs_ptn_symlink;

      /* Build the symbolic-link file-system-pathname. */
      {
	mmux_libc_fs_ptn_factory_t  fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn_symlink, fs_ptn_factory, ptn_asciiz_symlink)) {
	  printf_error("creating the symbolic link pathname");
	  handle_error();
	}
      }

      /* Open the symbolic-link. */
      {
	auto  flags = mmux_libc_open_flags(MMUX_LIBC_O_PATH | MMUX_LIBC_O_NOFOLLOW);
	auto  mode  = mmux_libc_mode_constant_zero();

	printf_message("opening symbolic-link file-descriptor");
	if (mmux_libc_open(fd_symlink, fs_ptn_symlink, flags, mode)) {
	  printf_error("opening symbolic-link file-descriptor");
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_symlink);
      }
    }

    /* Retrieve the real pathname. */
    {
      mmux_libc_fs_ptn_factory_copying_t  fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);

      printf_message("readlinkfd-ing");
      if (mmux_libc_readlinkfd(fs_ptn_real, fs_ptn_factory, fd_symlink)) {
	printf_error("readlinkfd-ing");
	handle_error();
      }
    }

    /* Check real file existence. */
    {
      mmux_libc_fs_ptn_t	fs_ptn_original;
      bool			result;

      /* Build the original file-system-pathname. */
      {
	mmux_libc_fs_ptn_factory_t  fs_ptn_factory;

	if (mmux_libc_make_file_system_pathname(fs_ptn_original, fs_ptn_factory, ptn_asciiz_original)) {
	  printf_error("creating the original link pathname");
	  handle_error();
	}
      }

      if (true) {
	printf_message("original link pathname: \"%s\"", fs_ptn_original->value);
	printf_message("readlink real pathname: \"%s\"", fs_ptn_real->value);
      }

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_real)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("readlink pathname exists as a directory entry");
      } else {
	printf_error("readlink pathname does NOT exist");
	handle_error();
      }

      if (mmux_libc_file_system_pathname_is_regular(&result, fs_ptn_real)) {
	printf_error("calling is_regular");
	handle_error();
      } else if (result) {
	printf_message("readlink pathname is a regular file");
      } else {
	printf_error("readlink pathname is NOT a regular file");
	handle_error();
      }

      if (mmux_libc_file_system_pathname_equal(&result, fs_ptn_real, fs_ptn_original)) {
	printf_error("comparin file system pathnames");
	handle_error();
      } else if (result) {
	printf_message("readlink pathname equals the original pathname");
      } else {
	printf_error("readlink pathname does NOT equal the original pathname");
	handle_error();
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_original);
      }
    }

    /* Final cleanup. */
    {
      if (mmux_libc_close(fd_symlink)) {
	printf_error("closing symbolic-link file-descriptor");
	handle_error();
      };
      mmux_libc_unmake_file_system_pathname(fs_ptn_real);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
