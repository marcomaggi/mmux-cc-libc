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

#include <mmux-cc-libc.h>
#include <test-common.h>

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-lchown.src.ext";
static mmux_asciizcp_t		dst_pathname_asciiz = "./test-file-system-lchown.dst.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-lchown";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles_register(dst_pathname_asciiz);
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

  mmux_libc_ptn_t	src_ptn, dst_ptn;
  mmux_libc_uid_t	uid;
  mmux_libc_gid_t	gid;

  if (mmux_libc_make_file_system_pathname(&src_ptn, src_pathname_asciiz)) {
    handle_error();
  }
  if (mmux_libc_make_file_system_pathname(&dst_ptn, dst_pathname_asciiz)) {
    handle_error();
  }

  /* Create the symbolic link. */
  {
    printf_message("create the symbolic link");
    if (mmux_libc_symlink(src_ptn, dst_ptn)) {
      handle_error();
    }

    if (0) {
      printf_message("original link pathname: \"%s\"", src_ptn.value);
      printf_message("symbolic link pathname: \"%s\"", dst_ptn.value);
    }
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
    printf_message("lchowning");
    if (mmux_libc_lchown(dst_ptn, uid, gid)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
