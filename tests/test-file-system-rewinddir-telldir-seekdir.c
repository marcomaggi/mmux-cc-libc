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


/** --------------------------------------------------------------------
 ** Helpers.
 ** ----------------------------------------------------------------- */

static bool
read_directory (mmux_libc_dirstream_t dirstream)
{
  mmux_libc_dirent_t *		direntry;

  if (mmux_libc_readdir(&direntry, dirstream)) {
    handle_error();
  } else if (direntry) {
    mmux_libc_fd_t	er;

    mmux_libc_stder(&er);
    if (mmux_libc_dirent_dump(er, direntry, NULL)) {
      handle_error();
    }
  } else {
    printf_message("no more entries");
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
    PROGNAME = "test-file-system-rewinddir-telldir-seekdir";
  }

  {
    mmux_libc_ptn_t         dirptn;
    mmux_libc_dirstream_t   dirstream;

    if (mmux_libc_make_file_system_pathname(&dirptn, ".")) {
      handle_error();
    }

    printf_message("opening directory stream");
    if (mmux_libc_opendir(&dirstream, dirptn)) {
      handle_error();
    }

    {
      mmux_libc_dirstream_position_t	dirpos;

      if (mmux_libc_telldir(&dirpos, dirstream)) {
	handle_error();
      }

      if (read_directory(dirstream)) {
	handle_error();
      }

      if (mmux_libc_seekdir(dirstream, dirpos)) {
	handle_error();
      }

      if (read_directory(dirstream)) {
	handle_error();
      }

      if (mmux_libc_rewinddir(dirstream)) {
	handle_error();
      }

      if (read_directory(dirstream)) {
	handle_error();
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
