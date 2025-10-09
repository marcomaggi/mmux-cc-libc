/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Aug  3, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"

#define mmux_ctype_loop_from_to(ITERNAME, ITERFIRST, ITERPAST)	\
  auto ITERNAME = ITERFIRST;					\
  mmux_ctype_less(ITERNAME, ITERPAST);				\
  mmux_ctype_incr_variable(ITERNAME)


/** --------------------------------------------------------------------
 ** Default allocator.
 ** ----------------------------------------------------------------- */

static void
test_default_allocator_malloc (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_mall_t	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      auto			buflen = mmux_usize(4096);
      mmux_standard_octet_t *	bufptr;

      if (mmux_libc_memory_allocator_malloc(AP, &bufptr, buflen)) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_ctype_loop_from_to(i,mmux_usize_constant_zero(),buflen)) {
	  bufptr[i.value] = i.value;
	  if (false) {
	    printf_message("bufptr[%lu]=%u", i.value, bufptr[i.value]);
	  }
	}
      }
      if (mmux_libc_memory_allocator_free(AP, bufptr)) {
	print_error("freeing memory with default memory allocator");
	handle_error();
      }
    }
  }
}

static void
test_default_allocator_calloc (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_mall_t	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      mmux_standard_octet_t *	bufptr;
      auto			item_num = mmux_usize(4096);
      auto			item_len = mmux_octet_sizeof();

      if (mmux_libc_memory_allocator_calloc(AP, &bufptr, item_num, item_len)) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_standard_usize_t i=0; i<item_num.value; ++i) {
	  bufptr[i] = (mmux_standard_octet_t) i;
	  if (false) {
	    printf_message("bufptr[%lu]=%u", i, bufptr[i]);
	  }
	}
      }
      if (mmux_libc_memory_allocator_free(AP, bufptr)) {
	print_error("freeing memory with default memory allocator");
	handle_error();
      }
    }
  }
}
static void
test_default_allocator_calloc_realloc (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_mall_t	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      auto			item_num1 = mmux_usize_literal(73);
      auto			item_len  = mmux_octet_sizeof();
      mmux_standard_octet_t *	bufptr;

      if (mmux_libc_memory_allocator_calloc(AP, &bufptr, item_num1, item_len)) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_ctype_loop_from_to(i, mmux_usize_constant_zero(), item_num1)) {
	  bufptr[i.value] = (mmux_standard_octet_t) i.value;
	  if (false) {
	    printf_message("bufptr[%lu]=%u", i.value, bufptr[i.value]);
	  }
	}
      }
      {
	auto	item_num2 = mmux_ctype_mul(mmux_usize_constant_two(), item_num1);
	auto	buflen    = mmux_ctype_mul(item_num2, mmux_octet_sizeof());

	if (mmux_libc_memory_allocator_realloc(AP, &bufptr, buflen)) {
	  print_error("allocating memory with default memory allocator");
	  handle_error();
	}
	for (mmux_ctype_loop_from_to(i, item_num1, item_num2)) {
	  bufptr[i.value] = i.value;
	  if (false) {
	    printf_message("bufptr[%lu]=%u", i.value, bufptr[i.value]);
	  }
	}
      }
      if (mmux_libc_memory_allocator_free(AP, bufptr)) {
	print_error("freeing memory with default memory allocator");
	handle_error();
      }
    }
  }
}
static void
test_default_allocator_calloc_reallocarray (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_mall_t	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      auto			item_num1 = mmux_usize_literal(73);
      auto			item_len  = mmux_octet_sizeof();
      mmux_standard_octet_t *	bufptr;

      if (mmux_libc_memory_allocator_calloc(AP, &bufptr, item_num1, item_len)) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_ctype_loop_from_to(i, mmux_usize_constant_zero(), item_num1)) {
	  bufptr[i.value] = (mmux_standard_octet_t) i.value;
	  if (false) {
	    printf_message("bufptr[%lu]=%u", i.value, bufptr[i.value]);
	  }
	}
      }
      {
	auto	item_num2 = mmux_ctype_mul(mmux_usize_constant_two(), item_num1);

	if (mmux_libc_memory_allocator_reallocarray(AP, &bufptr, item_num2, item_len)) {
	  print_error("allocating memory with default memory allocator");
	  handle_error();
	}
	for (mmux_ctype_loop_from_to(i, item_num1, item_num2)) {
	  bufptr[i.value] = (mmux_standard_octet_t) i.value;
	  if (false) {
	    printf_message("bufptr[%lu]=%u", i.value, bufptr[i.value]);
	  }
	}
      }
      if (mmux_libc_memory_allocator_free(AP, bufptr)) {
	print_error("freeing memory with default memory allocator");
	handle_error();
      }
    }
  }
}
static void
test_default_allocator_malloc_and_copy (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_mall_t	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      auto			srclen = mmux_usize_literal(73);
      mmux_standard_octet_t	srcptr[srclen.value];
      mmux_standard_octet_t *	dstptr;

      /* Fill the source buffer with data. */
      {
	for (mmux_ctype_loop_from_to(i, mmux_usize_constant_zero(), srclen)) {
	  srcptr[i.value] = (mmux_standard_octet_t) i.value;
	  if (false) {
	    printf_message("srcptr[%lu]=%u", i.value, srcptr[i.value]);
	  }
	}
      }

      if (mmux_libc_memory_allocator_malloc_and_copy(AP, &dstptr, srcptr, srclen)) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	/* Simulate an error. */
	if (false) {
	  dstptr[13] = 0;
	}

	for (mmux_ctype_loop_from_to(i, mmux_usize_constant_zero(), srclen)) {
	  if (false) {
	    printf_message("srcptr[%lu]=%u", i.value, srcptr[i.value]);
	  }
	  if (srcptr[i.value] != dstptr[i.value]) {
	    printf_error("invalid value at offset %lu of dstptr, expected %u, got %u",
			 i.value, srcptr[i.value], dstptr[i.value]);
	    mmux_libc_exit_failure();
	  }
	}
      }
      if (mmux_libc_memory_allocator_free(AP, dstptr)) {
	print_error("freeing memory with default memory allocator");
	handle_error();
      }
    }
  }
}


/** --------------------------------------------------------------------
 ** Fake allocator.
 ** ----------------------------------------------------------------- */

static void
test_fake_allocator_malloc_and_copy (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_mall_t	AP;

    if (mmux_libc_fake_memory_allocator_ref(&AP)) {
      print_error("retrieving fake memory allocator, should never happen");
      handle_error();
    } else {
      auto			srclen = mmux_usize(73);
      mmux_standard_octet_t	srcptr[srclen.value];
      mmux_standard_octet_t *	dstptr;

      /* Fill the source buffer with data. */
      {
	for (mmux_ctype_loop_from_to(i,mmux_usize_constant_zero(),srclen)) {
	  srcptr[i.value] = (mmux_standard_octet_t) i.value;
	  if (false) {
	    printf_message("srcptr[%lu]=%u", i.value, srcptr[i.value]);
	  }
	}
      }

      if (mmux_libc_memory_allocator_malloc_and_copy(AP, &dstptr, srcptr, srclen)) {
	print_error("allocating memory with fake memory allocator");
	handle_error();
      }
      {
	if (srcptr != dstptr) {
	  printf_error("invalid dstptr pointer, expected %p, got %p",
		       (mmux_pointer_t)srcptr, (mmux_pointer_t)dstptr);
	  mmux_libc_exit_failure();
	}

	for (mmux_ctype_loop_from_to(i,mmux_usize_constant_zero(),srclen)) {
	  if (true) {
	    printf_message("dstptr[%lu]=%u", i.value, dstptr[i.value]);
	  }
	  if (srcptr[i.value] != dstptr[i.value]) {
	    printf_error("invalid value at offset %lu of dstptr, expected %u, got %u",
			 i.value, srcptr[i.value], dstptr[i.value]);
	    mmux_libc_exit_failure();
	  }
	}
      }
      if (mmux_libc_memory_allocator_free(AP, dstptr)) {
	print_error("freeing memory with fake memory allocator");
	handle_error();
      }
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
    PROGNAME = "test-memory-allocator";
  }

  if (1) {	test_default_allocator_malloc();		}
  if (1) {	test_default_allocator_calloc();		}
  if (1) {	test_default_allocator_calloc_realloc();	}
  if (1) {	test_default_allocator_calloc_reallocarray();	}
  if (1) {	test_default_allocator_malloc_and_copy();	}

  if (1) {	test_fake_allocator_malloc_and_copy();		}

  mmux_libc_exit_success();
}

/* end of file */
