/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 22, 2025

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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-access.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-access";
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

  mmux_libc_ptn_t	ptn;

  if (mmux_libc_make_file_system_pathname(&ptn, src_pathname_asciiz)) {
    handle_error();
  }

  /* Set permissions. */
  {
    mmux_mode_t		mode = 0600;

    printf_message("chmoding");
    if (mmux_libc_chmod(ptn, mode)) {
      handle_error();
    }
  }

  /* Check mode. */
  {
    mmux_libc_stat_t	ST[1];
    mmux_libc_fd_t	fd;
    mmux_mode_t	st_mode;

    mmux_libc_stder(&fd);
    if (mmux_libc_stat(ptn, ST)) {
      handle_error();
    } else if (0 && mmux_libc_stat_dump(fd, ST, NULL)) {
      handle_error();
    }

    mmux_libc_st_mode_ref(&st_mode, ST);

    if (0600 == ((MMUX_LIBC_S_IRWXU | MMUX_LIBC_S_IRWXG | MMUX_LIBC_S_IRWXO) & st_mode)) {
      printf_message("mode checks out");
    } else {
      printf_message("mode does NOT check out");
      mmux_libc_exit_failure();
    }
  }

  /* Do it. */
  if (1) {
    mmux_sint_t		how = MMUX_LIBC_F_OK | MMUX_LIBC_R_OK | MMUX_LIBC_W_OK;
    bool		access_is_permitted;

    printf_message("accessing first time");
    if (mmux_libc_access(&access_is_permitted, ptn, how)) {
      handle_error();
    } else if (access_is_permitted) {
      printf_message("the read-write access is permitted");
    } else {
      print_error("the read-write access is DENIED");
      mmux_libc_exit_failure();
    }
  }

  /* Do it again. */
  if (1) {
    mmux_sint_t		how = MMUX_LIBC_X_OK;
    bool		access_is_permitted;

    printf_message("accessing second time");
    if (mmux_libc_access(&access_is_permitted, ptn, how)) {
      handle_error();
    } else if (! access_is_permitted) {
      printf_message("the execution access is denied");
    } else {
      print_error("the execution access is PERMITTED");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
