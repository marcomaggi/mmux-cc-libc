/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 15, 2025

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

static mmux_asciizcp_t		src_pathname_asciiz = "./test-file-system-readlinkfd.src.ext";
static mmux_asciizcp_t		lnk_pathname_asciiz = "./test-file-system-readlinkfd.lnk.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-system-readlinkfd";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles_register(lnk_pathname_asciiz);
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

  /* Create a symbolic link to the data file. */
  {
    mmux_libc_ptn_t	src_ptn, lnk_ptn;

    if (mmux_libc_make_file_system_pathname(&src_ptn, src_pathname_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(&lnk_ptn, lnk_pathname_asciiz)) {
      handle_error();
    }

    printf_message("symlinking");
    if (mmux_libc_symlink(src_ptn, lnk_ptn)) {
      handle_error();
    }

    if (0) {
      printf_message("original link pathname: \"%s\"", src_ptn.value);
      printf_message("symbolic link pathname: \"%s\"", lnk_ptn.value);
    }
  }

  /* Do it. */
  {
    mmux_libc_ptn_t	src_ptn, lnk_ptn, rea_ptn;
    mmux_libc_fd_t	lnkfd;

    if (mmux_libc_make_file_system_pathname(&src_ptn, src_pathname_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(&lnk_ptn, lnk_pathname_asciiz)) {
      handle_error();
    }

    /* Open the link. */
    {
      mmux_sint_t	flags = MMUX_LIBC_O_PATH | MMUX_LIBC_O_NOFOLLOW;
      mmux_mode_t	mode  = 0;

      if (mmux_libc_open(&lnkfd, lnk_ptn, flags, mode)) {
	handle_error();
      }
    }

    {
      mmux_usize_t	provided_nbytes_with_nul = 1024;
      char		bufptr[provided_nbytes_with_nul];
      mmux_usize_t	nbytes_done_no_nul;

      mmux_libc_memzero(bufptr, provided_nbytes_with_nul);

      printf_message("readlinkfd");
      if (mmux_libc_readlinkfd(&nbytes_done_no_nul, lnkfd, bufptr, provided_nbytes_with_nul-1)) {
	handle_error();
      } else if (nbytes_done_no_nul == provided_nbytes_with_nul) {
	/* not enough bytes in the provided buffer */
	handle_error();
      }
      if (mmux_libc_file_system_pathname_malloc(&rea_ptn, bufptr)) {
	handle_error();
      }
    }

    if (1) {
      printf_message("original link pathname: \"%s\"", src_ptn.value);
      printf_message("symbolic link pathname: \"%s\"", lnk_ptn.value);
      printf_message("readlinkfd real pathname: \"%s\"", rea_ptn.value);
    }

    /* Check file existence. */
    {
      bool		result;

      if (mmux_libc_file_exists(&result, rea_ptn)) {
	printf_error("exists");
	handle_error();
      } else if (result) {
	printf_message("readlinkfd pathname exists as a directory entry");
      } else {
	printf_error("readlinkfd pathname does NOT exist");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_is_regular(&result, rea_ptn)) {
	printf_error("calling is_regular");
	handle_error();
      } else if (result) {
	printf_message("readlinkfd pathname is a regular file");
      } else {
	printf_error("readlinkfd pathname is NOT a regular file");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_equal(&result, src_ptn, rea_ptn)) {
	handle_error();
      } else if (result) {
	printf_message("readlinkfd pathname equals the original pathname");
      } else {
	printf_error("readlinkfd pathname does NOT equal the original pathname");
	mmux_libc_exit_failure();
      }

      if (mmux_libc_file_system_pathname_free(rea_ptn)) {
	handle_error();
      }

      if (mmux_libc_close(lnkfd)) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
