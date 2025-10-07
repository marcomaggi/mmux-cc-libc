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


static void
init_buffer_with_octets (mmux_standard_octet_t * bufptr, mmux_usize_t buflen)
{
  for (mmux_standard_usize_t i=0; i<buflen.value; ++i) {
    bufptr[i] = (mmux_standard_octet_t) i;
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
    PROGNAME = "test-strerror";
  }

  /* ------------------------------------------------------------------ */

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
    printf_string(" memset,");
  }

  /* ------------------------------------------------------------------ */

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
    printf_string(" memzero,");
  }

  /* ------------------------------------------------------------------ */

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
    printf_string(" memcpy,");
  }

  /* ------------------------------------------------------------------ */

  {
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
    printf_string(" mempcpy,");
  }

  /* ------------------------------------------------------------------ */

  {
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
    printf_string(" memccpy,");
  }

  /* ------------------------------------------------------------------ */

  printf_string(" DONE.\n");
  mmux_libc_exit_success();
}

/* end of file */
