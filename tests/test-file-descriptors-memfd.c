/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul  3, 2025

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
 ** Tests: small string.
 ** ----------------------------------------------------------------- */

static void
test_small_string (void)
{
  mmux_asciizcp_t	asciiz_string = "ciao mamma";
  mmux_usize_t		asciiz_string_len;
  mmux_libc_fd_t	fd;

  mmux_libc_strlen(&asciiz_string_len, asciiz_string);

  if (mmux_libc_make_memfd(&fd)) {
    print_error("creating mfd");
    handle_error();
  }

  if (mmux_libc_memfd_write_asciiz(fd, asciiz_string)) {
    print_error("printing to mfd");
    handle_error();
  }

  {
    mmux_usize_t	nbytes_length;

    if (mmux_libc_memfd_length(&nbytes_length, fd)) {
      print_error("computing the length of mfd");
      handle_error();
    } else if (asciiz_string_len != nbytes_length) {
      print_error("wrong mfd length");
      handle_error();
    } else {
      if (mmux_libc_dprintfer("mfd length is (expected %lu): %lu\n", asciiz_string_len, nbytes_length)) {
	print_error("printing length of mfd to stderr");
	handle_error();
      }
    }
  }

  {
    mmux_usize_t	buflen = 4096;
    mmux_uint8_t	bufptr[buflen];

    mmux_libc_memzero(bufptr, buflen);

    {
      mmux_off_t	offset = 0;

      if (mmux_libc_lseek(fd, &offset, MMUX_LIBC_SEEK_SET)) {
	print_error("seeking to beginning to mfd");
	handle_error();
      }
    }

    /* Seek the mfd to the beginning. */
    {
      mmux_usize_t                    nbytes_done;

      if (mmux_libc_read(&nbytes_done, fd, bufptr, buflen)) {
	print_error("printing to mfd");
	handle_error();
      }
    }

    /* Validate the string read from the mfd. */
    {
      mmux_sint_t	result;

      if (mmux_libc_memcmp(&result, bufptr, asciiz_string, buflen)) {
	print_error("printing bufptr");
	handle_error();
      }
    }

    /* Dump the string to stderr, so we can see it in the tests log. */
    if (mmux_libc_dprintfer("string is (expected \"%s\"): \"%s\"\n", asciiz_string, bufptr)) {
      print_error("printing bufptr");
      handle_error();
    }
  }

  /* Dumping the string to stdout. */
  {
    if (mmux_libc_memfd_copyou(fd)) {
      print_error("dumping to stdout");
      handle_error();
    }
    if (mmux_libc_dprintfou_newline()) {
      print_error("printing newline");
      handle_error();
    }
  }

  if (mmux_libc_close(fd)) {
    print_error("closing mfd");
    handle_error();
  }
}


/** --------------------------------------------------------------------
 ** Tests: big string.
 ** ----------------------------------------------------------------- */

static void
test_big_string (void)
{
  mmux_usize_t		asciiz_string_len = 0;
  mmux_libc_fd_t	fd;

  if (mmux_libc_make_memfd(&fd)) {
    print_error("creating mfd");
    handle_error();
  }

  /* Fill the string with a lot of data. */
  {
    for (mmux_sint_t i=0; i<4096; ++i) {
      if (mmux_libc_dprintf(fd, "ciao mamma %5d\n", i)) {
	print_error("printing to mfd");
	handle_error();
      }
      asciiz_string_len += 11 + 5 + 1;
    }
  }

  {
    mmux_usize_t	nbytes_length;

    if (mmux_libc_memfd_length(&nbytes_length, fd)) {
      print_error("computing the length of mfd");
      handle_error();
    } else if (asciiz_string_len != nbytes_length) {
      print_error("wrong mfd length");
      handle_error();
    } else {
      if (mmux_libc_dprintfer("mfd length is (expected %lu): %lu\n", asciiz_string_len, nbytes_length)) {
	print_error("printing length of mfd to stderr");
	handle_error();
      }
    }
  }

  {
    mmux_usize_t	buflen = 2 * 4096;
    mmux_uint8_t	bufptr[buflen];

    mmux_libc_memzero(bufptr, buflen);

    {
      mmux_off_t	offset = 0;

      if (mmux_libc_lseek(fd, &offset, MMUX_LIBC_SEEK_SET)) {
	print_error("seeking to beginning to mfd");
	handle_error();
      }
    }

    /* Seek the mfd to the beginning. */
    {
      mmux_usize_t                    nbytes_done;

      if (mmux_libc_read(&nbytes_done, fd, bufptr, buflen)) {
	print_error("printing to mfd");
	handle_error();
      }
    }

#if 0
    /* Validate the string read from the mfd. */
    {
      mmux_sint_t	result;

      if (mmux_libc_memcmp(&result, bufptr, asciiz_string, buflen)) {
	print_error("printing bufptr");
	handle_error();
      }
    }

    /* Dump the string to stderr, so we can see it in the tests log. */
    if (mmux_libc_dprintfer("string is (expected \"%s\"): \"%s\"\n", asciiz_string, bufptr)) {
      print_error("printing bufptr");
      handle_error();
    }
#endif
  }

  /* Dumping the string to stdout. */
  if (0) {
    if (mmux_libc_memfd_copyou(fd)) {
      print_error("dumping to stdout");
      handle_error();
    }
    if (mmux_libc_dprintfou_newline()) {
      print_error("printing newline");
      handle_error();
    }
  }

  if (mmux_libc_close(fd)) {
    print_error("closing mfd");
    handle_error();
  }
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
    PROGNAME			= "test-memfd";
  }

  test_small_string();
  test_big_string();

  mmux_libc_exit_success();
}

/* end of file */
