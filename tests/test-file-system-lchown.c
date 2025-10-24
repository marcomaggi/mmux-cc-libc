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

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz_original = "./test-file-system-lchown.original.ext";
static mmux_asciizcp_t	ptn_asciiz_symlink  = "./test-file-system-lchown.symlink.ext";


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
    cleanfiles_register(ptn_asciiz_original);
    cleanfiles_register(ptn_asciiz_symlink);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(ptn_asciiz_original)) {
      handle_error();
    }
  }

  {
    mmux_libc_fs_ptn_t	fs_ptn_symlink;
    mmux_libc_uid_t	uid;
    mmux_libc_gid_t	gid;

    /* Make the symbolic link. */
    {
      mmux_libc_fs_ptn_t	fs_ptn_original;

      /* Build the file system pathnames. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn_original, fs_ptn_factory, ptn_asciiz_original)) {
	  handle_error();
	}
	if (mmux_libc_make_file_system_pathname(fs_ptn_symlink, fs_ptn_factory, ptn_asciiz_symlink)) {
	  handle_error();
	}
      }

      /* Create the symbolic link. */
      {
	printf_message("create the symbolic link");
	if (mmux_libc_symlink(fs_ptn_original, fs_ptn_symlink)) {
	  printf_error("creating the symbolic link");
	  handle_error();
	}

	if (false) {
	  printf_message("original link pathname: \"%s\"", fs_ptn_original->value);
	  printf_message("symbolic link pathname: \"%s\"", fs_ptn_symlink->value);
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_original);
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
      printf_message("lchown-ing");
      if (mmux_libc_lchown(fs_ptn_symlink, uid, gid)) {
	printf_error("lchown-ing");
	handle_error();
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn_symlink);
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
