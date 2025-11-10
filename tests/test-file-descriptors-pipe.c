/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 10, 2025

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
    PROGNAME = "test-file-descriptors-pipe";
  }

  {
    mmux_libc_infd_t	infd;
    mmux_libc_oufd_t	oufd;

    printf_message("pipe-ing");
    if (mmux_libc_pipe(infd, oufd)) {
      printf_error("pipe-ing");
      handle_error();
    }

    /* Writing data to pipe. */
    {
      mmux_asciizcp_t	bufptr = "The colour of water and quicksilver.";
      mmux_usize_t	buflen, nbytes_done;

      mmux_libc_strlen(&buflen, bufptr);
      printf_message("writing data to the oufd");
      if (mmux_libc_write(&nbytes_done, oufd, bufptr, buflen)) {
	printf_error("writing data to the oufd");
	handle_error();
      } else {
	printf_message("of %lu bytes to write to pipe, %lu written to pipe", buflen.value, nbytes_done.value);
      }

      if (mmux_ctype_not_equal(nbytes_done, buflen)) {
	printf_error("number of bytes written to oufd not equal to the bufsize");
	handle_error();
      }
    }

    /* Reading data from pipe. */
    {
      auto		buflen = mmux_usize_literal(1024);
      char		bufptr[buflen.value];
      mmux_usize_t	nbytes_done;

      {
	printf_message("reading data from the infd");
	if (mmux_libc_read(&nbytes_done, infd, bufptr, buflen)) {
	  printf_error("writing data to the oufd");
	  handle_error();
	} else {
	  printf_message("of %lu bytes to read from pipe, %lu read from pipe", buflen.value, nbytes_done.value);
	}
      }

      /* Validate the data read from the INFD. */
      {
	mmux_asciizcp_t		expected_bufptr = "The colour of water and quicksilver.";
	mmux_usize_t		expected_buflen;
	mmux_ternary_comparison_result_t	cmpnum;

	mmux_libc_strlen(&expected_buflen, expected_bufptr);
	if (mmux_libc_strncmp(&cmpnum, expected_bufptr, bufptr, nbytes_done)) {
	  handle_error();
	}
	if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	  printf_message("data read from pipe correctly equals data written to pipe");
	} else {
	  printf_error("data read from pipe WRONGLY differs from data written to pipe");
	  handle_error();
	}
      }
    }

    /* Final cleanup. */
    {
      if (mmux_libc_close(infd)) {
	handle_error();
      }
      if (mmux_libc_close(oufd)) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
