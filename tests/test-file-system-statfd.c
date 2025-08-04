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

#include <mmux-cc-libc.h>
#include <test-common.h>

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-statfd.src.ext";


/** --------------------------------------------------------------------
 ** Test data file.
 ** ----------------------------------------------------------------- */

static bool
test_data_file (void)
{
  mmux_libc_ptn_t	ptn;
  mmux_libc_fd_t	fd;

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(src_pathname_asciiz)) {
      handle_error();
    }
  }

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, src_pathname_asciiz)) {
    handle_error();
  }

  /* Open the data file. */
  {
    mmux_sint_t		flags = MMUX_LIBC_O_PATH | MMUX_LIBC_O_NOFOLLOW;
    mmux_mode_t		mode  = 0;

    if (mmux_libc_open(&fd, ptn, flags, mode)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    mmux_libc_stat_t	ST[1];
    mmux_sint_t		flags = MMUX_LIBC_AT_SYMLINK_NOFOLLOW;

    printf_message("statfding");
    if (mmux_libc_statfd(fd, ST, flags)) {
      handle_error();
    }

    {
      mmux_libc_fd_t	er;

      mmux_libc_stder(&er);
      if (mmux_libc_stat_dump(er, ST, NULL)) {
	handle_error();
      }
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Test current directory.
 ** ----------------------------------------------------------------- */

static bool
test_current_directory (void)
{
  mmux_libc_fd_t	dirfd;
  mmux_libc_stat_t	ST[1];
  mmux_sint_t		flags = 0;

  mmux_libc_at_fdcwd(&dirfd);

  printf_message("statfding");
  if (mmux_libc_statfd(dirfd, ST, flags)) {
    handle_error();
  } else {
    mmux_libc_fd_t	er;

    mmux_libc_stder(&er);
    if (mmux_libc_stat_dump(er, ST, NULL)) {
      handle_error();
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-statfd";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  if (test_data_file()) {
    mmux_libc_exit_failure();
  }

  if (test_current_directory()) {
    mmux_libc_exit_failure();
  }

  mmux_libc_exit_success();
}

/* end of file */
