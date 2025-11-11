/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 16, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-fstat.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-fstat";
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

  {
    mmux_libc_fd_t	fd;

    /* Obtain the file descriptor. */
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

      /* Open the data file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_PATH | MMUX_LIBC_O_NOFOLLOW);
	auto	mode  = mmux_libc_mode_constant_zero();

	if (mmux_libc_open(fd, fs_ptn, flags, mode)) {
	  handle_error();
	}
      }

      /* Local cleanup */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn);
      }
    }

    /* Do it. */
    {
      mmux_libc_stat_t	stat;

      printf_message("fstat-ing");
      if (mmux_libc_fstat(stat, fd)) {
	printf_error("fstat-ing");
	handle_error();
      } else {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_stat_dump(er, stat, NULL)) {
	  handle_error();
	}
      }
    }

    /* Final cleanup */
    {
      if (mmux_libc_close(fd)) {
	printf_error("closing file descriptor");
	handle_error();
      }
    }

  }
  mmux_libc_exit_success();
}

/* end of file */
