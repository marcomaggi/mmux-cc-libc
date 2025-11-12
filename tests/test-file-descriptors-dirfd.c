/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 12, 2025

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
    PROGNAME = "test-file-system-dirfd";
  }

  {
    mmux_asciizcp_t		ptn_asciiz = ".";
    mmux_libc_dirfd_t		dirfd;

    /* Obtain the directory file descriptor. */
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

      /* Open the directory file descriptor. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_DIRECTORY | MMUX_LIBC_O_PATH);
	auto	mode  = mmux_libc_mode_constant_zero();

	printf_message("open-ing directory pathname");
	if (mmux_libc_open(dirfd, fs_ptn_directory, flags, mode)) {
	  printf_error("open-ing directory pathname");
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn_directory);
      }
    }

    /* Some checking. */
    {
      {
	bool	it_is_directory;

	assert(false == mmux_libc_file_descriptor_identity_is_directory(&it_is_directory, dirfd));
	if (it_is_directory) {
	  printf_message("dirfd correctly identified as directory");
	} else {
	  printf_error("dirfd WRONGLY identified as non-directory");
	  handle_error();
	}
      }

      {
	bool	it_is_path_only;

	assert(false == mmux_libc_file_descriptor_identity_is_path_only(&it_is_path_only, dirfd));
	if (it_is_path_only) {
	  printf_message("dirfd correctly identified as path-only");
	} else {
	  printf_error("dirfd WRONGLY identified as non-path-only");
	  handle_error();
	}
      }

      {
	bool	it_is_networking_socket;

	assert(false == mmux_libc_file_descriptor_identity_is_networking_socket(&it_is_networking_socket, dirfd));
	if (it_is_networking_socket) {
	  printf_error("dirfd WRONGLY identified as networking-socket");
	  handle_error();
	} else {
	  printf_message("dirfd correctly identified as non-networking-socket");
	}
      }
    }

    /* Final cleanup. */
    {
      printf_message("closing dirfd");
      if (mmux_libc_close(dirfd)) {
	printf_error("closing dirfd");
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
