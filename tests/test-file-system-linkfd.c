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

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_old = "./test-file-system-linkfd.src.ext";
static mmux_asciizcp_t	ptn_asciiz_new = "./test-file-system-linkfd.dst.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-linkfd";
    cleanfiles_register(ptn_asciiz_old);
    cleanfiles_register(ptn_asciiz_new);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file %s", ptn_asciiz_old);
    if (test_create_data_file(ptn_asciiz_old)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_fd_t	fd_old;
    mmux_libc_fs_ptn_t  fs_ptn_new;

    {
      mmux_libc_fs_ptn_t  fs_ptn_old;

      /* Create the file pathnames. */
      {
	mmux_libc_fs_ptn_factory_t  fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn_old, fs_ptn_factory, ptn_asciiz_old)) {
	  printf_error("making old file pathname");
	  handle_error();
	}
	if (mmux_libc_make_file_system_pathname(fs_ptn_new, fs_ptn_factory, ptn_asciiz_new)) {
	  printf_error("making new file pathname");
	  handle_error();
	}
      }

      /* Open the old file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_PATH);
	auto	mode  = mmux_libc_mode_constant_zero();

	printf_message("opening the old file %s", ptn_asciiz_old);
	if (mmux_libc_open(fd_old, fs_ptn_old, flags, mode)) {
	  printf_error("opening the old pathname");
	  handle_error();
	}
      }

      /* Check old file existence, because I have to debug. */
      {
	bool	result;

	if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_old)) {
	  printf_error("exists");
	  handle_error();
	} else if (result) {
	  printf_message("old link pathname exists as a directory entry");
	} else {
	  printf_error("old link pathname does NOT exist");
	  handle_error();
	}

	if (mmux_libc_file_system_pathname_is_regular(&result, fs_ptn_old)) {
	  printf_error("calling is_regular");
	  handle_error();
	} else if (result) {
	  printf_message("old link pathname is a regular file");
	} else {
	  printf_error("old link pathname is NOT a regular file");
	  handle_error();
	}
      }

      /* Intermediate cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_old);
      }
    }

    /* Create the link. */
    {
      mmux_libc_dirfd_t  dirfd_new;
      auto               flags = mmux_libc_linkat_flags(0);

      mmux_libc_at_fdcwd(dirfd_new);

      printf_message("linkfd-ing ptn_new=%s", fs_ptn_new->value);
      if (mmux_libc_linkfd(fd_old, dirfd_new, fs_ptn_new, flags)) {
	mmux_libc_errno_t	errnum;
	mmux_asciizcp_t		errname;

	mmux_libc_errno_ref(&errnum);
	mmux_libc_strerrorname_np(&errname, errnum);
	printf_error("linkfd-ing errno=%s", errname);
	if (true) {
	  // This test  fails if the  executor does not have  the CAP_DAC_READ_SEARCH
	  // capability (see capabilities(7)) (Marco Maggi; Nov  1, 2025)
	  mmux_libc_exit(mmux_libc_process_exit_status(77));
	} else {
	  handle_error();
	}
      }
    }

    /* Check new file existence. */
    {
      bool	result;

      if (mmux_libc_file_system_pathname_exists(&result, fs_ptn_new)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("link pathname exists as a directory entry");
      } else {
	printf_error("link pathname does NOT exist");
	handle_error();
      }

      if (mmux_libc_file_system_pathname_is_regular(&result, fs_ptn_new)) {
	printf_error("calling is_regular");
	handle_error();
      } else if (result) {
	printf_message("link pathname is a regular file");
      } else {
	printf_error("link pathname is NOT a regular file");
	handle_error();
      }
    }

    /* Final cleanup. */
    {
      if (mmux_libc_close(fd_old)) {
	printf_error("closing the old pathname file descriptor");
	handle_error();
      }
      mmux_libc_unmake_file_system_pathname(fs_ptn_new);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
