/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 14, 2025

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
    PROGNAME			= "test-file-system-pathname";
  }

  /* Print a file system pathname. */
  if (1) {
    mmux_libc_ptn_t	ptn;
    mmux_libc_fd_t	er;

    if (mmux_libc_make_file_system_pathname(&ptn, "/path/to/file.ext")) {
      handle_error();
    }

    mmux_libc_stder(&er);
    if (mmux_libc_dprintf_libc_ptn(er, ptn)) {
      handle_error();
    }
    mmux_libc_dprintfer_newline();
  }

  /* Allocate a pathname in dynamic memory using standard functions. */
  if (1) {
    //                                     012345678901234567
    mmux_asciizcp_t	pathname_asciiz = "/path/to/file.ext";
    mmux_usize_t	buflen;
    mmux_asciizp_t	bufptr;
    mmux_libc_ptn_t	ptn;

    if (mmux_libc_strlen(&buflen, pathname_asciiz)) {
      handle_error();
    }
    if (mmux_libc_calloc(&bufptr, sizeof(mmux_char_t), buflen)) {
      handle_error();
    }
    bufptr[++buflen]='\0';
    if (mmux_libc_strncpy(bufptr, pathname_asciiz, buflen)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(&ptn, bufptr)) {
      handle_error();
    }
    {
      mmux_libc_fd_t	er;

      mmux_libc_stder(&er);
      if (mmux_libc_dprintf_libc_ptn(er, ptn)) {
	handle_error();
      }
      mmux_libc_dprintfer_newline();
    }
    if (mmux_libc_file_system_pathname_free(ptn)) {
      handle_error();
    }
  }

  /* Allocate       a       pathname        in       dynamic       memory       using
     "mmux_libc_file_system_pathname_malloc()". */
  if (1) {
    mmux_asciizcp_t	pathname_asciiz = "/path/to/file.ext";
    mmux_libc_ptn_t	ptn;

    if (mmux_libc_file_system_pathname_malloc(&ptn, pathname_asciiz)) {
      printf_error("error allocating");
      handle_error();
    }
    {
      mmux_libc_fd_t	er;

      mmux_libc_stder(&er);
      if (mmux_libc_dprintf_libc_ptn(er, ptn)) {
	handle_error();
      }
      mmux_libc_dprintfer_newline();
    }
    if (mmux_libc_file_system_pathname_free(ptn)) {
      handle_error();
    }
  }

  /* Determine the length of a file system pathname. */
  if (1) {
    mmux_libc_ptn_t	ptn;
    mmux_usize_t	len;

    //                                             012345678901234567
    if (mmux_libc_make_file_system_pathname(&ptn, "/path/to/file.ext")) {
      handle_error();
    } else if (mmux_libc_file_system_pathname_length(&len, ptn)) {
      handle_error();
    } else if (17 != len) {
      handle_error();
    }

    printf_message("the pathname length is: %lu", len);
  }

  /* Compare two equal pathnames. */
  if (1) {
    mmux_libc_ptn_t	ptn1, ptn2;
    mmux_libc_fd_t	er;
    bool		equal;

    if (mmux_libc_make_file_system_pathname(&ptn1, "/path/to/file.ext")) {
      handle_error();
    }

    if (mmux_libc_make_file_system_pathname(&ptn2, "/path/to/file.ext")) {
      handle_error();
    }

    if (mmux_libc_file_system_pathname_equal(&equal, ptn1, ptn2)) {
      handle_error();
    }
    if (! equal) {
      print_error("pathnames are not equal");
      mmux_libc_exit_failure();
    }

    mmux_libc_stder(&er);
    if (mmux_libc_dprintf_libc_ptn(er, ptn1)) {
      handle_error();
    }
    mmux_libc_dprintfer_newline();
    if (mmux_libc_dprintf_libc_ptn(er, ptn2)) {
      handle_error();
    }
    mmux_libc_dprintfer_newline();
  }

  /* Compare two different pathnames. */
  if (1) {
    mmux_libc_ptn_t	ptn1, ptn2;
    mmux_libc_fd_t	er;
    bool		equal;

    if (mmux_libc_make_file_system_pathname(&ptn1, "/path/to/file.ext")) {
      handle_error();
    }

    if (mmux_libc_make_file_system_pathname(&ptn2, "/path/to/other-file.ext")) {
      handle_error();
    }

    if (mmux_libc_file_system_pathname_equal(&equal, ptn1, ptn2)) {
      handle_error();
    }
    if (equal) {
      print_error("pathnames are equal");
      mmux_libc_exit_failure();
    }

    mmux_libc_stder(&er);
    if (mmux_libc_dprintf_libc_ptn(er, ptn1)) {
      handle_error();
    }
    mmux_libc_dprintfer_newline();
    if (mmux_libc_dprintf_libc_ptn(er, ptn2)) {
      handle_error();
    }
    mmux_libc_dprintfer_newline();
  }

  mmux_libc_exit_success();
}

/* end of file */
