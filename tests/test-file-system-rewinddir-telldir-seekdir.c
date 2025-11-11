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

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Helpers.
 ** ----------------------------------------------------------------- */

static bool
read_one_directory_entry (mmux_libc_dirstream_t dirstream)
{
  mmux_libc_dirent_t	direntry;
  bool			there_are_more_entries;

  if (mmux_libc_readdir(&there_are_more_entries, direntry, dirstream)) {
    printf_error("readdir-ing directory entry");
    handle_error();
  } else if (there_are_more_entries) {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
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
    mmux_asciizcp_t		ptn_asciiz = ".";
    mmux_libc_dirstream_t	dirstream;

    /* Obtain the directory stream. */
    {
      mmux_libc_fs_ptn_t	fs_ptn_directory;

      /* Build the file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn_directory, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      /* Open the directory stream. */
      {
	printf_message("opening directory stream");
	if (mmux_libc_opendir(dirstream, fs_ptn_directory)) {
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_directory);
      }
    }

    /* Perform directory stream operations. */
    {
      mmux_libc_dirstream_position_t	dirpos;

      if (mmux_libc_telldir(&dirpos, dirstream)) {
	handle_error();
      }

      if (read_one_directory_entry(dirstream)) {
	handle_error();
      }

      if (mmux_libc_seekdir(dirstream, dirpos)) {
	handle_error();
      }

      if (read_one_directory_entry(dirstream)) {
	handle_error();
      }

      if (mmux_libc_rewinddir(dirstream)) {
	handle_error();
      }

      if (read_one_directory_entry(dirstream)) {
	handle_error();
      }
    }

    /* Final cleanup. */
    {
      printf_message("closing directory stream");
      if (mmux_libc_closedir(dirstream)) {
	printf_error("closing directory stream");
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
