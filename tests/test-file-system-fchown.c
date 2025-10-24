/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Jul 19, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-system-fchown.src.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-fchown";
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
    mmux_libc_uid_t	uid;
    mmux_libc_gid_t	gid;

    /* Acquire the file descriptor. */
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

      /* Open the file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR);
	auto	mode  = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR);

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
      printf_message("fchown-ing");
      if (mmux_libc_fchown(fd, uid, gid)) {
	printf_error("fchown-ing");
	handle_error();
      }
    }

    /* Final cleanup. */
    {
      printf_message("close the file");
      if (mmux_libc_close(fd)) {
	handle_error();
	printf_error("close the file");
      }
    }
  }

  mmux_libc_exit_success();
}
/* end of file */
