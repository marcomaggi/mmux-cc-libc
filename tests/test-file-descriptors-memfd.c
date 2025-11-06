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

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Tests: small string.
 ** ----------------------------------------------------------------- */

static void
test_small_string (void)
{
  mmux_asciizcp_t	asciiz_string = "ciao mamma";
  mmux_libc_memfd_t	fd;

  /* Open the memfd. */
  {
    if (mmux_libc_make_memfd(fd)) {
      print_error("creating mfd");
      handle_error();
    }
  }

  /* Write the ASCIIZ string into the memfd. */
  {
    if (mmux_libc_memfd_write_asciiz(fd, asciiz_string)) {
      print_error("printing to mfd");
      handle_error();
    }
  }

  /* Check that the length of the data  in the device underlying the memfd equals the
     length of the ASCIIZ string. */
  {
    mmux_usize_t	asciiz_string_len;
    mmux_usize_t	nbytes_length;

    mmux_libc_strlen(&asciiz_string_len, asciiz_string);

    if (mmux_libc_memfd_length(&nbytes_length, fd)) {
      print_error("computing the length of mfd");
      handle_error();
    } else if (mmux_ctype_not_equal(asciiz_string_len, nbytes_length)) {
      print_error("wrong mfd length");
      handle_error();
    } else {
      if (mmux_libc_dprintfer("%s: mfd length is (expected %lu): %lu\n",
			      __func__, asciiz_string_len.value, nbytes_length.value)) {
	print_error("printing length of mfd to stderr");
	handle_error();
      }
    }
  }

  /* Extract all the data from the memfd into a local buffer "bufptr". */
  {
    auto			buflen = mmux_usize_literal(4096);
    mmux_standard_uint8_t	bufptr[buflen.value];
    mmux_usize_t		nbytes_done;

    mmux_libc_memzero(bufptr, buflen);

    /* Seek the memfd to the beginning. */
    {
      auto	offset = mmux_off_constant_zero();

      if (mmux_libc_lseek(fd, &offset, MMUX_LIBC_SEEK_SET)) {
	print_error("seeking to beginning to mfd");
	handle_error();
      }
    }

    /* Read the contents into "bufptr". */
    {
      if (mmux_libc_read(&nbytes_done, fd, bufptr, buflen)) {
	print_error("printing to mfd");
	handle_error();
      }
    }

    /* Dump the string to stderr, so we can see it in the tests log. */
    if (mmux_libc_dprintfer("%s: string is (expected \"%s\"): \"%s\"\n",
			    __func__, asciiz_string, bufptr)) {
      print_error("printing bufptr");
      handle_error();
    }

    /* Validate the string read from the mfd. */
    {
      mmux_ternary_comparison_result_t	cmpnum;

      if (mmux_libc_memcmp(&cmpnum, bufptr, asciiz_string, nbytes_done)) {
	print_error("comparing bufptr");
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	printf_message("%s: correct buffer contents", __func__);
      } else {
	printf_error("wrong bufptr contents (cmpnum.value=%d)", cmpnum.value);
	handle_error();
      }
    }
  }

  /* Dump the string to stdout. */
  if (true) {
    printf_message("dump of string to stdout: ");
    if (mmux_libc_memfd_copyou(fd)) {
      print_error("dumping to stdout");
      handle_error();
    }
    if (mmux_libc_dprintfou_newline()) {
      print_error("printing newline");
      handle_error();
    }
  }

  /* Final cleanup. */
  {
    if (mmux_libc_close(fd)) {
      print_error("closing mfd");
      handle_error();
    }
  }
}


/** --------------------------------------------------------------------
 ** Tests: big string.
 ** ----------------------------------------------------------------- */

static void
test_big_string (void)
{
  auto			asciiz_string_len = mmux_usize_constant_zero();
  mmux_libc_memfd_t	fd;

  /* Open the memfd. */
  {
    if (mmux_libc_make_memfd(fd)) {
      print_error("creating mfd");
      handle_error();
    }
  }

  /* Fill the memfd  with a lot of data.   Notice that we do NOT  print a terminating
     zero octet. */
  {
    for (mmux_standard_sint_t i=0; i<4096; ++i) {
      //                         01234567890
      if (mmux_libc_dprintf(fd, "ciao mamma %5d\n", i)) {
	print_error("printing to mfd");
	handle_error();
      }
      /* We write  "ciao mamma " whose  length is 11,  then a field of  5 characters,
	 finally a newline. */
      mmux_ctype_add_to_variable(asciiz_string_len, mmux_usize(11 + 5 + 1));
    }
  }

  /* Check that the length of the data  in the device underlying the memfd equals the
     length of the ASCIIZ string. */
  {
    mmux_usize_t	nbytes_length;

    if (mmux_libc_memfd_length(&nbytes_length, fd)) {
      print_error("computing the length of mfd");
      handle_error();
    } else if (mmux_ctype_not_equal(asciiz_string_len, nbytes_length)) {
      print_error("wrong mfd length");
      handle_error();
    } else {
      if (mmux_libc_dprintfer("%s: mfd length is (expected %lu): %lu\n",
			      __func__, asciiz_string_len.value, nbytes_length.value)) {
	print_error("printing length of mfd to stderr");
	handle_error();
      }
    }
  }

  /* Extract all the data from the memfd into a local buffer "bufptr". */
  {
    auto			buflen = asciiz_string_len;
    mmux_standard_uint8_t	bufptr[1 + buflen.value];
    mmux_usize_t		nbytes_done;

    mmux_libc_memzero(bufptr, buflen);
    bufptr[1 + buflen.value] = '\0';

    /* Seek the memfd to the beginning. */
    {
      auto	offset = mmux_off_constant_zero();

      if (mmux_libc_lseek(fd, &offset, MMUX_LIBC_SEEK_SET)) {
	print_error("seeking to beginning to mfd");
	handle_error();
      }
    }

    /* Read the contents into "bufptr". */
    {
      if (mmux_libc_read(&nbytes_done, fd, bufptr, buflen)) {
	print_error("printing to mfd");
	handle_error();
      }
    }

    /* Dump the string to stderr, so we can see it in the tests log. */
    if (false) {
      if (mmux_libc_dprintfer("%s: string is: \"%s\"\n", __func__, bufptr)) {
	print_error("printing bufptr");
	handle_error();
      }
    }
  }

  /* Dumping the  string to stdout.   It is  very long, so  do it only  for debugging
     purposes. */
  if (false) {
    if (mmux_libc_memfd_copyou(fd)) {
      print_error("dumping to stdout");
      handle_error();
    }
    if (mmux_libc_dprintfou_newline()) {
      print_error("printing newline");
      handle_error();
    }
  }

  /* Final cleanup. */
  {
    if (mmux_libc_close(fd)) {
      print_error("closing mfd");
      handle_error();
    }
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
