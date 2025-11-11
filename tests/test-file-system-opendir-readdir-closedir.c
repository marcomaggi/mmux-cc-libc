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


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-opendir-readdir-closedir";
  }

  {
    mmux_asciizcp_t		ptn_asciiz = ".";
    mmux_libc_dirstream_t	dirstream;

    /* Open the directory stream. */
    {
      mmux_libc_fs_ptn_t	fs_ptn_directory;

      /* Build file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn_directory, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      /* Do it. */
      {
	printf_message("opening directory stream");
	if (mmux_libc_opendir(dirstream, fs_ptn_directory)) {
	  printf_error("opening directory stream");
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_directory);
      }
    }

    /* Inspect the directory entries. */
    {
      mmux_libc_dirent_t	direntry;
      mmux_libc_oufd_t		er;

      mmux_libc_stder(er);

      for (;;) {
	bool	there_are_more_entries;

	if (mmux_libc_readdir(&there_are_more_entries, direntry, dirstream)) {
	  handle_error();
	} else if (there_are_more_entries) {
	  mmux_asciizcp_t	name;
	  mmux_uintmax_t	fileno;

	  mmux_libc_d_name_ref   (&name,   direntry);
	  mmux_libc_d_fileno_ref (&fileno, direntry);
	  printf_message("directory entry name: %s", name);
	  printf_message("directory entry fileno: %lu", (mmux_standard_usize_t)(fileno.value));

	  if (mmux_libc_dirent_dump(er, direntry, NULL)) {
	    handle_error();
	  }
	} else {
	  printf_message("no more entries");
	  break;
	}
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
