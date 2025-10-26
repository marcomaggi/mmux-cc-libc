/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 26, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-attributes-fields.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-attributes-fields";
    cleanfiles_register(ptn_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_fs_ptn_t	fs_ptn;

    /* Build the file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	handle_error();
      }
    }

    /* File size from file system pathname. */
    {
      mmux_usize_t	st_size, expected_st_size = mmux_usize_literal(41);
      mmux_libc_dirfd_t	dirfd;

      mmux_libc_at_fdcwd(dirfd);
      if (mmux_libc_file_system_pathname_file_size_ref(&st_size, dirfd, fs_ptn)) {
	handle_error();
      } else if (mmux_ctype_equal(st_size, expected_st_size)) {
	printf_message("size is correct");
      } else {
	printf_error("size is wrong");
	handle_error();
      }
    }

    /* File size from file descriptor. */
    {
      mmux_libc_fd_t	fd;

      /* Open the data file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_PATH | MMUX_LIBC_O_NOFOLLOW);
	auto	mode  = mmux_libc_mode_constant_zero();

	if (mmux_libc_open(fd, fs_ptn, flags, mode)) {
	  handle_error();
	}
      }

      {
	mmux_usize_t	st_size, expected_st_size = mmux_usize_literal(41);

	if (mmux_libc_file_descriptor_file_size_ref(&st_size, fd)) {
	  handle_error();
	} else if (mmux_ctype_equal(st_size, expected_st_size)) {
	  printf_message("size is correct");
	} else {
	  printf_error("size is wrong");
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	if (mmux_libc_close(fd)) {
	  handle_error();
	}
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn);
    }

  }

  mmux_libc_exit_success();
}

/* end of file */
