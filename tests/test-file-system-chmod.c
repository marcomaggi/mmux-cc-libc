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

#include <mmux-cc-libc.h>
#include <test-common.h>

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-chmod.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-chmod";
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

  /* Do it. */
  {
    mmux_libc_ptn_t	ptn;
    mmux_mode_t		mode = 0755;

    if (mmux_libc_make_file_system_pathname(&ptn, src_pathname_asciiz)) {
      handle_error();
    }

    printf_message("chmoding");
    if (mmux_libc_chmod(ptn, mode)) {
      handle_error();
    }

    /* Check mode. */
    {
      mmux_libc_stat_t	ST[1];
      mmux_libc_fd_t	fd;
      mmux_mode_t	st_mode;

      mmux_libc_stder(&fd);
      if (mmux_libc_stat(ptn, ST)) {
	handle_error();
      } else if (mmux_libc_stat_dump(fd, ST, NULL)) {
	handle_error();
      }

      mmux_libc_st_mode_ref(&st_mode, ST);

      if ((MMUX_LIBC_S_IRWXU                       == (MMUX_LIBC_S_IRWXU & st_mode)) &&
	  ((MMUX_LIBC_S_IRGRP | MMUX_LIBC_S_IXGRP) == (MMUX_LIBC_S_IRWXG & st_mode)) &&
	  ((MMUX_LIBC_S_IROTH | MMUX_LIBC_S_IXOTH) == (MMUX_LIBC_S_IRWXO & st_mode))) {
	printf_message("mode checks out");
      } else {
	printf_message("mode does NOT check out");
	mmux_libc_exit_failure();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
