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

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-attributes-mode.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-attributes-mode";
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

    /* Do it. */
    {
      mmux_libc_stat_t	stat;

      printf_message("stat-ing");
      if (mmux_libc_stat(stat, fs_ptn)) {
	printf_error("stat-ing");
	handle_error();
      } else {
	mmux_libc_fd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_stat_dump(er, stat, NULL)) {
	  handle_error();
	}

	/* Inspec the whole "stat". */
	{
	  /* S_TYPEISMQ */
	  {
	    bool	result;

	    if (mmux_libc_S_TYPEISMQ(&result, stat)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a POSIX message queue");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a POSIX message queue");
	    }
	  }

	  /* S_TYPEISSEM */
	  {
	    bool	result;

	    if (mmux_libc_S_TYPEISSEM(&result, stat)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a POSIX semaphore");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a POSIX semaphore");
	    }
	  }

	  /* S_TYPEISSHM */
	  {
	    bool	result;

	    if (mmux_libc_S_TYPEISSHM(&result, stat)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a POSIX shared memory device");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a POSIX shared memory device");
	    }
	  }
	}

	/* Inspect the field "st_mode". */
	{
	  mmux_libc_mode_t	st_mode;

	  mmux_libc_st_mode_ref(&st_mode, stat);

	  /* S_ISDIR */
	  {
	    bool	result;

	    if (mmux_libc_S_ISDIR(&result, st_mode)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a directory");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a directory");
	    }
	  }

	  /* S_ISCHR */
	  {
	    bool	result;

	    if (mmux_libc_S_ISCHR(&result, st_mode)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a character device");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a character device");
	    }
	  }

	  /* S_ISBLK */
	  {
	    bool	result;

	    if (mmux_libc_S_ISBLK(&result, st_mode)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a block device");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a block device");
	    }
	  }

	  /* S_ISREG */
	  {
	    bool	result;

	    if (mmux_libc_S_ISREG(&result, st_mode)) {
	      handle_error();
	    } else if (result) {
	      printf_message("data file is correctly a regular file");
	    } else {
	      printf_error("data file is INCORRECTLY not a regular file");
	      handle_error();
	    }
	  }

	  /* S_ISFIFO */
	  {
	    bool	result;

	    if (mmux_libc_S_ISFIFO(&result, st_mode)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a FIFO device");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a FIFO device");
	    }
	  }

	  /* S_ISLNK */
	  {
	    bool	result;

	    if (mmux_libc_S_ISLNK(&result, st_mode)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a symbolic link");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a symbolic link");
	    }
	  }

	  /* S_ISSOCK */
	  {
	    bool	result;

	    if (mmux_libc_S_ISSOCK(&result, st_mode)) {
	      handle_error();
	    } else if (result) {
	      printf_error("data file is INCORRECTLY a socket");
	      handle_error();
	    } else {
	      printf_message("data file is correctly not a socket");
	    }
	  }
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
