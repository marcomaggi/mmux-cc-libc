/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct  5, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


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

  /* malloc() */
  {
    auto			nbytes = mmux_usize_literal(213);
    mmux_standard_octet_t *	ptr;

    if (mmux_libc_malloc(&ptr, nbytes)) {
      handle_error();
    }
    for (unsigned i=0; i<213; ++i) {
      ptr[i] = i;
    }
    if (mmux_libc_free(ptr)) {
      handle_error();
    }
    printf_string(" malloc,");
  }

  /* calloc() */
  {
    {
      auto			item_num = mmux_usize_literal(12);
      auto			item_len = mmux_usize_literal(34);
      mmux_standard_octet_t *	ptr;

      if (mmux_libc_calloc(&ptr, item_num, item_len)) {
	handle_error();
      }
      for (unsigned i=0; i<(12 * 34); ++i) {
	ptr[i] = i;
      }
      if (mmux_libc_free(ptr)) {
	handle_error();
      }
    }
    {
      auto			item_num = mmux_usize_literal(12);
      auto			item_len = mmux_flonumd128_sizeof();
      mmux_flonumd128_t *	ptr;

      if (mmux_libc_calloc(&ptr, item_num, item_len)) {
	handle_error();
      }
      for (auto i=mmux_usize_constant_zero(); mmux_ctype_less(i, item_num); mmux_ctype_incr_variable(i)) {
	ptr[i.value] = mmux_flonumd128(i.value);
      }
      if (false) {
	for (auto i=mmux_usize_constant_zero(); mmux_ctype_less(i, item_num); mmux_ctype_incr_variable(i)) {
	  MMUX_LIBC_IGNORE_RETVAL(mmux_ctype_dprintf(2, ptr[i.value]));
	  MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer_newline());
	}
      }
      if (mmux_libc_free(ptr)) {
	handle_error();
      }
    }
    printf_string(" calloc,");
  }

  /* realloc() */
  {
    auto			nbytes1 = mmux_usize_literal(56);
    auto			nbytes2 = mmux_usize_literal(89);
    mmux_standard_octet_t *	ptr;

    if (mmux_libc_malloc(&ptr, nbytes1)) {
      handle_error();
    }
    for (unsigned i=0; i<56; ++i) {
      ptr[i] = i;
    }
    if (mmux_libc_realloc(&ptr, nbytes2)) {
      handle_error();
    }
    for (unsigned i=56; i<89; ++i) {
      ptr[i] = i;
    }
    if (false) {
      for (unsigned i=0; i<89;++i) {
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%u", (unsigned)ptr[i]));
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer_newline());
      }
    }
    if (mmux_libc_free(ptr)) {
      handle_error();
    }
    printf_string(" realloc,");
  }

  /* reallocarray() */
  {
    auto		item_num1 = mmux_usize_literal(12);
    auto		item_num2 = mmux_usize_literal(34);
    auto		item_len  = mmux_flonumd128_sizeof();
    mmux_flonumd128_t *	ptr;

    if (mmux_libc_calloc(&ptr, item_num1, item_len)) {
      handle_error();
    }

    for (mmux_standard_usize_t i=0; i<item_num1.value; ++i) {
      ptr[i] = mmux_flonumd128(i);
    }

    if (mmux_libc_reallocarray(&ptr, item_num2, item_len)) {
      handle_error();
    }

    for (mmux_standard_usize_t i=item_num1.value; i<item_num2.value; ++i) {
      ptr[i] = mmux_flonumd128(i);
    }

    if (false) {
      mmux_libc_fd_t	fd;

      mmux_libc_stder(fd);
      for (mmux_standard_usize_t i=0; i<item_num2.value;++i) {
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintf_flonumd128(fd, ptr[i]));
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer_newline());
      }
    }
    if (mmux_libc_free(ptr)) {
      handle_error();
    }
    printf_string(" reallocarray,");
  }

  /* malloc_and_copy() */
  {
    {
      auto			buflen = mmux_usize_literal(12);
      mmux_standard_byte_t	srcbuf[buflen.value];
      mmux_standard_byte_t *	dstbuf;

      for (mmux_standard_usize_t i=0; i<buflen.value; ++i) {
	srcbuf[i] = (mmux_standard_byte_t) i;
      }
      if (mmux_libc_malloc_and_copy(&dstbuf, srcbuf, buflen)) {
	handle_error();
      }
      if (false) {
	for (mmux_standard_usize_t i=0; i<buflen.value; ++i) {
	  MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%u\n", dstbuf[i]));
	}
      }
      if (mmux_libc_free(dstbuf)) {
	handle_error();
      }
    }

    {
      mmux_standard_char_t *	srcbuf = "the colour of water";
      mmux_standard_char_t *	dstbuf;
      mmux_usize_t		buflen;

      mmux_libc_strlen_plus_nil(&buflen, srcbuf);

      if (mmux_libc_malloc_and_copy(&dstbuf, srcbuf, buflen)) {
	handle_error();
      }
      if (false) {
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("{%s}\n", dstbuf));
      }
      if (mmux_libc_free(dstbuf)) {
	handle_error();
      }
    }

    printf_string(" malloc_and_copy,");
  }

  printf_string(" DONE.\n");
  mmux_libc_exit_success();
}

/* end of file */
