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


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-fdopendir-readdir-closedir";
  }

  {
    mmux_libc_file_descriptor_t		dirfd;
    mmux_libc_dirstream_t		dirstream;

    /* Open the directory's file descriptor. */
    {
      mmux_libc_ptn_t	dirptn;
      mmux_sint_t	flags = MMUX_LIBC_O_RDONLY;
      mmux_mode_t	mode  = 0;

      if (mmux_libc_make_file_system_pathname(&dirptn, ".")) {
	handle_error();
      }

      if (mmux_libc_open(&dirfd, dirptn, flags, mode)) {
	handle_error();
      };
    }

    printf_message("fdopening directory stream");
    if (mmux_libc_fdopendir(&dirstream, dirfd)) {
      handle_error();
    }

    {
      mmux_libc_dirent_t *	direntry;
      mmux_libc_fd_t		er;

      mmux_libc_stder(&er);

      for (;;) {
	if (mmux_libc_readdir(&direntry, dirstream)) {
	  handle_error();
	} else if (direntry) {
	  mmux_asciizcp_t		name;
	  mmux_uintmax_t		fileno;

	  mmux_libc_d_name_ref   (&name,   direntry);
	  mmux_libc_d_fileno_ref (&fileno, direntry);
	  printf_message("directory entry name: %s", name);
	  printf_message("directory entry fileno: %lu", (mmux_usize_t)fileno);

	  if (mmux_libc_dirent_dump(er, direntry, NULL)) {
	    handle_error();
	  }
	} else {
	  printf_message("no more entries");
	  break;
	}
      }
    }

    printf_message("closing directory stream");
    if (mmux_libc_closedir(dirstream)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
