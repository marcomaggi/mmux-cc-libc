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

#include <mmux-cc-libc.h>
#include "test-common.h"


/** --------------------------------------------------------------------
 ** Default allocator.
 ** ----------------------------------------------------------------- */

static void
test_default_allocator_malloc (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_memory_allocator_t const *	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      mmux_usize_t	buflen = 4096;
      mmux_usize_t *	bufptr;

      if (mmux_libc_memory_allocator_malloc(AP, &bufptr, buflen * sizeof(mmux_usize_t))) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_usize_t i=0; i<buflen; ++i) {
	  bufptr[i] = i;
	  if (0) {
	    printf_message("bufptr[%lu]=%lu", i, bufptr[i]);
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
    mmux_libc_memory_allocator_t const *	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      mmux_usize_t	buflen = 4096;
      mmux_usize_t *	bufptr;

      if (mmux_libc_memory_allocator_calloc(AP, &bufptr, buflen, sizeof(mmux_usize_t))) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_usize_t i=0; i<buflen; ++i) {
	  bufptr[i] = i;
	  if (0) {
	    printf_message("bufptr[%lu]=%lu", i, bufptr[i]);
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
    mmux_libc_memory_allocator_t const *	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      mmux_usize_t	buflen1 = 4096;
      mmux_usize_t	buflen2 = 2 * buflen1;
      mmux_usize_t *	bufptr;

      if (mmux_libc_memory_allocator_calloc(AP, &bufptr, buflen1, sizeof(mmux_usize_t))) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_usize_t i=0; i<buflen1; ++i) {
	  bufptr[i] = i;
	  if (0) {
	    printf_message("bufptr[%lu]=%lu", i, bufptr[i]);
	  }
	}
      }
      if (mmux_libc_memory_allocator_realloc(AP, &bufptr, buflen2 * sizeof(mmux_usize_t))) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_usize_t i=buflen1; i<buflen2; ++i) {
	  bufptr[i] = i;
	  if (0) {
	    printf_message("bufptr[%lu]=%lu", i, bufptr[i]);
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
    mmux_libc_memory_allocator_t const *	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      mmux_usize_t	buflen1 = 4096;
      mmux_usize_t	buflen2 = 2 * buflen1;
      mmux_usize_t *	bufptr;

      if (mmux_libc_memory_allocator_calloc(AP, &bufptr, buflen1, sizeof(mmux_usize_t))) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_usize_t i=0; i<buflen1; ++i) {
	  bufptr[i] = i;
	  if (0) {
	    printf_message("bufptr[%lu]=%lu", i, bufptr[i]);
	  }
	}
      }
      if (mmux_libc_memory_allocator_reallocarray(AP, &bufptr, buflen2, sizeof(mmux_usize_t))) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	for (mmux_usize_t i=buflen1; i<buflen2; ++i) {
	  bufptr[i] = i;
	  if (0) {
	    printf_message("bufptr[%lu]=%lu", i, bufptr[i]);
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
    mmux_libc_memory_allocator_t const *	AP;

    if (mmux_libc_default_memory_allocator_ref(&AP)) {
      print_error("retrieving default memory allocator, should never happen");
      handle_error();
    } else {
      mmux_usize_t	srclen = 4096;
      mmux_usize_t	srcptr[srclen];
      mmux_usize_t *	dstptr;

      /* Fill the source buffer with data. */
      {
	for (mmux_usize_t i=0; i<srclen; ++i) {
	  srcptr[i] = i;
	  if (0) {
	    printf_message("srcptr[%lu]=%lu", i, srcptr[i]);
	  }
	}
      }

      if (mmux_libc_memory_allocator_malloc_and_copy(AP, &dstptr, srcptr, srclen * sizeof(mmux_usize_t))) {
	print_error("allocating memory with default memory allocator");
	handle_error();
      }
      {
	/* Simulate an error. */
	if (0) {
	  dstptr[123] = 0;
	}

	for (mmux_usize_t i=0; i<srclen; ++i) {
	  if (0) {
	    printf_message("srcptr[%lu]=%lu", i, srcptr[i]);
	  }
	  if (srcptr[i] != dstptr[i]) {
	    printf_error("invalid value at offset %lu of dstptr, expected %lu, got %lu",
			 i, srcptr[i], dstptr[i]);
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
    mmux_libc_memory_allocator_t const *	AP;

    if (mmux_libc_fake_memory_allocator_ref(&AP)) {
      print_error("retrieving fake memory allocator, should never happen");
      handle_error();
    } else {
      mmux_usize_t	srclen = 4096;
      mmux_usize_t	srcptr[srclen];
      mmux_usize_t *	dstptr;

      /* Fill the source buffer with data. */
      {
	for (mmux_usize_t i=0; i<srclen; ++i) {
	  srcptr[i] = i;
	  if (0) {
	    printf_message("srcptr[%lu]=%lu", i, srcptr[i]);
	  }
	}
      }

      if (mmux_libc_memory_allocator_malloc_and_copy(AP, &dstptr, srcptr, srclen * sizeof(mmux_usize_t))) {
	print_error("allocating memory with fake memory allocator");
	handle_error();
      }
      {
	/* Simulate an error. */
	if (0) {
	  dstptr[123] = 0;
	}

	if (srcptr != dstptr) {
	  printf_error("invalid dstptr pointer, expected %p, got %p",
		       (mmux_pointer_t)srcptr, (mmux_pointer_t)dstptr);
	  mmux_libc_exit_failure();
	}

	for (mmux_usize_t i=0; i<srclen; ++i) {
	  if (0) {
	    printf_message("srcptr[%lu]=%lu", i, srcptr[i]);
	  }
	  if (srcptr[i] != dstptr[i]) {
	    printf_error("invalid value at offset %lu of dstptr, expected %lu, got %lu",
			 i, srcptr[i], dstptr[i]);
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
