/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Jul 20, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc.h>
#include <test-common.h>

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-fchownat.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-fchownat";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  mmux_libc_ptn_t	ptn;
  mmux_libc_uid_t	uid;
  mmux_libc_gid_t	gid;

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

  /* Acquire UID and GID. */
  {
    mmux_asciizcp_t		name;
    mmux_libc_passwd_t *	PW;


    if (mmux_libc_getlogin(&name)) {
      handle_error();
    }

    if (mmux_libc_getpwnam(&PW, name)) {
      handle_error();
    }

    mmux_libc_pw_uid_ref(&uid, PW);
    mmux_libc_pw_gid_ref(&gid, PW);
  }

  /* Do it. */
  {
    mmux_libc_fd_t	dirfd;
    mmux_sint_t		flags = MMUX_LIBC_AT_SYMLINK_NOFOLLOW;

    mmux_libc_at_fdcwd(&dirfd);

    printf_message("fchownating");
    if (mmux_libc_fchownat(dirfd, ptn, uid, gid, flags)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
