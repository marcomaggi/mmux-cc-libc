/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 20, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-dirfd";
  }

  {
    mmux_asciizcp_t		ptn_asciiz = ".";
    mmux_libc_dirstream_t	dirstream;
    mmux_libc_dirfd_t		dirfd;

    /* Open the directory stream. */
    {
      mmux_libc_fs_ptn_t	fs_ptn_directory;

      /* Build file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn_directory, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      /* Do it. */
      {
	printf_message("opening directory stream");
	if (mmux_libc_opendir(dirstream, fs_ptn_directory)) {
	  printf_error("opening directory stream");
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_directory);
      }
    }

    /* Obtain the directory file descriptor. */
    {
      printf_message("dirfd-ing");
      if (mmux_libc_dirfd(dirfd, dirstream)) {
	printf_error("dirfd-ing");
	handle_error();
      }
    }

    /* Print stat. */
    {
      mmux_libc_stat_t	stat;

      printf_message("fstat-ing");
      if (mmux_libc_fstat(dirfd, stat)) {
	printf_error("fstat-ing");
	handle_error();
      } else {
	mmux_libc_fd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_stat_dump(er, stat, NULL)) {
	  handle_error();
	}
      }
    }

    /* Final cleanup. */
    {
      printf_message("closing directory stream");
      if (mmux_libc_closedir(dirstream)) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
