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

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-faccessat.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-faccessat";
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
    mmux_libc_fs_ptn_t	fs_ptn;

    /* Build the file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	handle_error();
      }
    }

    /* Set permissions. */
    {
      auto	mode = mmux_libc_mode_literal(0600);

      printf_message("chmod-ing");
      if (mmux_libc_chmod(fs_ptn, mode)) {
	printf_error("chmod-ing");
	handle_error();
      }
    }

    /* Check mode. */
    {
      mmux_libc_stat_t	stat;
      mmux_libc_fd_t	fd;
      mmux_libc_mode_t	st_mode;

      mmux_libc_stder(fd);
      if (mmux_libc_stat(stat, fs_ptn)) {
	handle_error();
      } else if (mmux_libc_stat_dump(fd, stat, NULL)) {
	handle_error();
      }

      mmux_libc_st_mode_ref(&st_mode, stat);

      if (0600 == ((MMUX_LIBC_S_IRWXU | MMUX_LIBC_S_IRWXG | MMUX_LIBC_S_IRWXO) & st_mode.value)) {
	printf_message("mode checks out");
      } else {
	printf_message("mode does NOT check out");
	handle_error();
      }
    }

    /* Do it. */
    if (true) {
      mmux_libc_dirfd_t	dirfd;
      auto  how   = mmux_libc_access_how(MMUX_LIBC_F_OK | MMUX_LIBC_R_OK | MMUX_LIBC_W_OK);
      auto  flags = mmux_libc_faccessat_flags(MMUX_LIBC_AT_SYMLINK_NOFOLLOW);
      bool  access_is_permitted;

      mmux_libc_at_fdcwd(dirfd);

      printf_message("faccessat-ing first time");
      if (mmux_libc_faccessat(&access_is_permitted, dirfd, fs_ptn, how, flags)) {
	printf_error("faccessat-ing first time");
	handle_error();
      } else if (access_is_permitted) {
	printf_message("the read-write access is correctly permitted");
      } else {
	print_error("the read-write access is wrongly DENIED");
	mmux_libc_exit_failure();
      }
    }

    /* Do it again. */
    if (true) {
      mmux_libc_dirfd_t	dirfd;
      auto  how   = mmux_libc_access_how(MMUX_LIBC_X_OK);
      auto  flags = mmux_libc_faccessat_flags(MMUX_LIBC_AT_SYMLINK_NOFOLLOW);
      bool  access_is_permitted;

      mmux_libc_at_fdcwd(dirfd);

      printf_message("faccessat-ing second time");
      if (mmux_libc_faccessat(&access_is_permitted, dirfd, fs_ptn, how, flags)) {
	printf_error("faccessat-ing second time");
	handle_error();
      } else if (! access_is_permitted) {
	printf_message("the execution access is correctly denied");
      } else {
	print_error("the execution access is wrongly PERMITTED");
	mmux_libc_exit_failure();
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
