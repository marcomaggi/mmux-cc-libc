/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 18, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	src_pathname_asciiz = "./test-file-descriptors-file-size.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-descriptors-file-size.c";
    cleanfiles_register(src_pathname_asciiz);
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

  {
    mmux_libc_fd_t	fd;

    /* Obtain the file descriptor. */
    {
      mmux_libc_fs_ptn_t	fs_ptn;

      /* Build the file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, src_pathname_asciiz)) {
	  handle_error();
	}
      }

      /* Open the file. */
      {
	mmux_libc_dirfd_t	dirfd;
	auto		flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR);
	auto		mode  = mmux_libc_mode_constant_zero();

	mmux_libc_at_fdcwd(dirfd);

	printf_message("open-ing the file");
	if (mmux_libc_openat(fd, dirfd, fs_ptn, flags, mode)) {
	  printf_error("open-ing the file");
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn);
      }
    }

    /* Do it. */
    {
      mmux_usize_t	result;

      printf_message("file_descriptor_file_size_refing");
      if (mmux_libc_file_descriptor_file_size_ref(&result, fd)) {
	handle_error();
      }

      printf_message("file size: %lu", result.value);
    }

    /* Final cleanup. */
    {
      if (mmux_libc_close(fd)) {
	printf_error("closing the file descriptor");
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
