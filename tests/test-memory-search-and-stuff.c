/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct  6, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


MMUX_CC_LIBC_UNUSED static void
init_buffer_with_octets (mmux_standard_octet_t * bufptr, mmux_usize_t buflen)
{
  for (mmux_standard_usize_t i=0; i<buflen.value; ++i) {
    bufptr[i] = (mmux_standard_octet_t) i;
  }
}
MMUX_CC_LIBC_UNUSED static void
print_buffer_with_octets (mmux_standard_octet_t * bufptr, mmux_usize_t buflen)
{
  for (mmux_standard_usize_t i=0; i<buflen.value; ++i) {
    assert(! mmux_libc_dprintfer(" %u", (mmux_standard_uint_t)bufptr[i]));
  }
}
MMUX_CC_LIBC_UNUSED static void
print_buffer_with_chars (mmux_standard_char_t * bufptr, mmux_usize_t buflen)
{
  for (mmux_standard_usize_t i=0; i<buflen.value; ++i) {
    assert(! mmux_libc_dprintfer(" %c", bufptr[i]));
  }
}


static void
test_memset (void)
{
  printf_string("%s: ", __func__);
  {
    auto			value  = mmux_octet(13);
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	bufptr[buflen.value];

    if (mmux_libc_memset(bufptr, value, buflen)) {
      handle_error();
    }
    if (false) {
      for (mmux_standard_usize_t i = 0; i<buflen.value; ++i) {
	printf_string("%u ", bufptr[i]);
      }
    }
  }
  printf_string(" DONE\n");
}


static void
test_memzero (void)
{
  printf_string("%s: ", __func__);
  {
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	bufptr[buflen.value];

    if (mmux_libc_memzero(bufptr, buflen)) {
      handle_error();
    }
    if (false) {
      for (mmux_standard_usize_t i = 0; i<buflen.value; ++i) {
	printf_string("%u ", bufptr[i]);
      }
    }
  }
  printf_string(" DONE\n");
}


static void
test_memcpy (void)
{
  printf_string("%s: ", __func__);
  {
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	srcptr[buflen.value];
    mmux_standard_octet_t	dstptr[buflen.value];

    init_buffer_with_octets(srcptr, buflen);
    if (mmux_libc_memcpy(dstptr, srcptr, buflen)) {
      handle_error();
    }
    if (false) {
      for (mmux_standard_usize_t i = 0; i<buflen.value; ++i) {
	printf_string("%u ", dstptr[i]);
      }
    }
  }
  printf_string(" DONE\n");
}


static void
test_mempcpy (void)
{
  printf_string("%s: ", __func__);
  {
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	srcptr[buflen.value];
    mmux_standard_octet_t	dstptr[buflen.value];
    mmux_standard_octet_t *	nxtptr;

    init_buffer_with_octets(srcptr, buflen);
    if (mmux_libc_mempcpy(&nxtptr, dstptr, srcptr, buflen)) {
      handle_error();
    }
    assert( (mmux_standard_usize_t)(nxtptr - dstptr) == buflen.value);
    if (false) {
      for (mmux_standard_octet_t * ptr = dstptr; ptr < nxtptr; ++ptr) {
	printf_string("%u ", *ptr);
      }
    }
  }
  {
    mmux_standard_char_t *	srcptr = "the colour of water";
    mmux_usize_t		buflen;

    mmux_libc_strlen(&buflen, srcptr);
    {
      mmux_standard_char_t	dstptr[buflen.value];
      mmux_standard_char_t *	nxtptr;

      if (mmux_libc_mempcpy(&nxtptr, dstptr, srcptr, buflen)) {
	handle_error();
      }
      assert( (mmux_standard_usize_t)(nxtptr - dstptr) == buflen.value);
      if (false) {
	for (mmux_standard_char_t * ptr = dstptr; ptr < nxtptr; ++ptr) {
	  printf_string("%c ", *ptr);
	}
      }
    }
  }
  printf_string(" DONE\n");
}


static void
test_memccpy (void)
{
  printf_string("%s: ", __func__);
  {
    auto			it     = mmux_octet(3);
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	srcptr[buflen.value];
    mmux_standard_octet_t	dstptr[buflen.value];
    mmux_standard_octet_t *	nxtptr;

    init_buffer_with_octets(srcptr, buflen);
    if (mmux_libc_memccpy(&nxtptr, dstptr, srcptr, it, buflen)) {
      handle_error();
    }
    assert( (mmux_standard_usize_t)(nxtptr - dstptr) == 4);
    if (false) {
      for (mmux_standard_octet_t * ptr = dstptr; ptr < nxtptr; ++ptr) {
	printf_string("%u ", *ptr);
      }
    }
  }
  {
    //                                  01234567890123456789
    mmux_standard_char_t *	srcptr = "the colour of water";
    mmux_usize_t		buflen;

    mmux_libc_strlen(&buflen, srcptr);
    {
      auto			it = mmux_octet('w');
      mmux_standard_char_t	dstptr[buflen.value];
      mmux_standard_char_t *	nxtptr;

      if (mmux_libc_memccpy(&nxtptr, dstptr, srcptr, it, buflen)) {
	handle_error();
      }
      assert( (mmux_standard_usize_t)(nxtptr - dstptr) == 15);
      if (false) {
	for (mmux_standard_char_t * ptr = dstptr; ptr < nxtptr; ++ptr) {
	  printf_string("%c ", *ptr);
	}
      }
    }
  }
  printf_string(" DONE\n");
}


static void
test_memmove (void)
{
  printf_string("%s: ", __func__);
  {
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	srcptr[buflen.value];
    mmux_standard_octet_t	dstptr[buflen.value];

    init_buffer_with_octets(srcptr, buflen);
    if (mmux_libc_memmove(dstptr, srcptr, buflen)) {
      handle_error();
    }
    if (false) {
      print_buffer_with_octets(dstptr, buflen);
    }
  }
  {
    mmux_standard_char_t *	srcptr = "the colour of water";
    mmux_usize_t		buflen;

    mmux_libc_strlen_plus_nil(&buflen, srcptr);
    {
      mmux_standard_char_t	dstptr[buflen.value];

      if (mmux_libc_memmove(dstptr, srcptr, buflen)) {
	handle_error();
      }
      if (false) {
	printf_string(" %s", dstptr);
      }
    }
  }
  printf_string(" DONE\n");
}


static void
test_memcmp (void)
{
  printf_string("%s: ", __func__);
  {
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	bufptr1[buflen.value];
    mmux_standard_octet_t	bufptr2[buflen.value];
    mmux_sint_t			ternary_result;

    init_buffer_with_octets(bufptr1, buflen);
    init_buffer_with_octets(bufptr2, buflen);
    if (mmux_libc_memcmp(&ternary_result, bufptr1, bufptr2, buflen)) {
      handle_error();
    }
    assert(0 == ternary_result.value);
  }
  {
    mmux_standard_char_t *	bufptr1 = "the colour of water";
    mmux_standard_char_t *	bufptr2 = "the colour of water and quicksilver";
    mmux_usize_t		buflen;
    mmux_sint_t			ternary_result;

    mmux_libc_strlen(&buflen, bufptr1);
    if (mmux_libc_memcmp(&ternary_result, bufptr1, bufptr2, buflen)) {
      handle_error();
    }
    assert(0 == ternary_result.value);
    assert(mmux_ctype_is_zero(ternary_result));
  }
  printf_string(" DONE\n");
}


static void
test_memchr (void)
{
  printf_string("%s: ", __func__);
  {
    auto			it     = mmux_octet(3);
    auto			buflen = mmux_usize_literal(5);
    mmux_standard_octet_t	bufptr[buflen.value];
    mmux_standard_octet_t *	result;

    init_buffer_with_octets(bufptr, buflen);
    if (mmux_libc_memchr(&result, bufptr, it, buflen)) {
      handle_error();
    }
    assert( (mmux_standard_usize_t)(result - bufptr) == 3);
  }
  {
    //                                    01234567890123456789
    mmux_standard_char_t *	bufptr = "the colour of water";
    mmux_usize_t		buflen;
    auto			it     = mmux_octet('w');
    mmux_standard_char_t *	result;

    mmux_libc_strlen(&buflen, bufptr);
    if (mmux_libc_memchr(&result, bufptr, it, buflen)) {
      handle_error();
    }
    assert( (mmux_standard_usize_t)(result - bufptr) == 14);
  }
  printf_string(" DONE\n");
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
    PROGNAME = "test-memory-search-and-stuff";
  }

  if (1) {	test_memset();		}
  if (1) {	test_memzero();		}
  if (1) {	test_memcpy();		}
  if (1) {	test_mempcpy();		}
  if (1) {	test_memccpy();		}
  if (1) {	test_memmove();		}
  if (1) {	test_memcmp();		}
  if (1) {	test_memchr();		}

  mmux_libc_exit_success();
}

/* end of file */
