/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 21, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-fchmod.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-fchmod";
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

      /* Build file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      /* Open the file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR);
	auto	mode  = mmux_libc_mode_constant_zero();

	printf_message("opening the file");
	if (mmux_libc_open(fd, fs_ptn, flags, mode)) {
	  printf_error("opening the file");
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
      auto	mode = mmux_libc_mode_literal(0755);

      printf_message("fchmod-ing");
      if (mmux_libc_fchmod(fd, mode)) {
	printf_error("fchmod-ing");
	handle_error();
      }
    }

    /* Check mode. */
    {
      mmux_libc_fs_ptn_t	fs_ptn;

      /* Build file system pathname, for checking purpose. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      {
	mmux_libc_stat_t	stat;
	mmux_libc_mode_t	st_mode;
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_stat(stat, fs_ptn)) {
	  handle_error();
	} else if (mmux_libc_stat_dump(er, stat, NULL)) {
	  handle_error();
	}

	mmux_libc_st_mode_ref(&st_mode, stat);

	if ((MMUX_LIBC_S_IRWXU                       == (MMUX_LIBC_S_IRWXU & st_mode.value)) &&
	    ((MMUX_LIBC_S_IRGRP | MMUX_LIBC_S_IXGRP) == (MMUX_LIBC_S_IRWXG & st_mode.value)) &&
	    ((MMUX_LIBC_S_IROTH | MMUX_LIBC_S_IXOTH) == (MMUX_LIBC_S_IRWXO & st_mode.value))) {
	  printf_message("mode checks out");
	} else {
	  printf_message("mode does NOT check out");
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn);
      }
    }

    /* Final cleanup. */
    {
      if (mmux_libc_close(fd)) {
	handle_error();
      }
    }
  }
  mmux_libc_exit_success();
}

/* end of file */
