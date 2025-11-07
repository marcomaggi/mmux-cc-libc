/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul  9, 2025

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
    PROGNAME = "test-file-descriptors-preadv2-pwritev2";
  }

  {
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }

    /* Write to  the memfd  a number  of buffers equal  to "bufnum",  each containing
       "buflen" octets. */
    {
      auto const		bufnum = mmux_usize_literal(4);
      auto const		buflen = mmux_usize_literal(8);
      mmux_standard_octet_t	bufptr[bufnum.value][buflen.value];
      mmux_libc_iovec_t		iov[bufnum.value];
      mmux_libc_iovec_array_t	iova;

      /* Initialise the "iova" array. */
      {
	for (mmux_standard_uint_t i=0; i<bufnum.value; ++i) {
	  mmux_libc_iov_len_set  (&(iov[i]), buflen);
	  mmux_libc_iov_base_set (&(iov[i]), &(bufptr[i][0]));
	}

	mmux_libc_iova_len_set  (&iova, bufnum);
	mmux_libc_iova_base_set (&iova, iov);

	/* Fill the buffers with data. */
	{
	  for (mmux_standard_uint_t i=0; i<bufnum.value; ++i) {
	    for (mmux_standard_uint_t j=0; j<buflen.value; ++j) {
	      bufptr[i][j] = 10 * i + j;
	    }
	  }
	}
      }

      /* Perform the writing. */
      {
	mmux_usize_t	nbytes_done;
	auto		offset = mmux_off_constant_zero();
	auto		flags  = mmux_libc_scatter_gather_flags(MMUX_LIBC_RWF_HIPRI);

	printf_message("pwritev2-ing");
	if (mmux_libc_pwritev2(&nbytes_done, mfd, &iova, offset, flags)) {
	  printf_error("pwritev2-ing");
	  handle_error();
	}

	/* Validate the number of octets written. */
	{
	  auto	expected_nbytes_written = mmux_ctype_mul(buflen, bufnum);

	  if (mmux_ctype_not_equal(nbytes_done, expected_nbytes_written)) {
	    printf_error("wrong number of written octets, expected %lu got %lu",
			 expected_nbytes_written.value, nbytes_done.value);
	    handle_error();
	  }
	}
      }
    }

    /* Seek the file descriptor to the beginning. */
    {
      auto	position = mmux_off_constant_zero();

      printf_message("lseek-ing");
      if (mmux_libc_lseek(mfd, &position, MMUX_LIBC_SEEK_SET)) {
	printf_error("lseek-ing");
	handle_error();
      }
    }

    /* Read. */
    {
      auto const		bufnum = mmux_usize_literal(4);
      auto const		buflen = mmux_usize_literal(8);
      mmux_standard_octet_t	bufptr[bufnum.value][buflen.value];
      mmux_libc_iovec_t		iov[bufnum.value];
      mmux_libc_iovec_array_t	iova;

      /* Initialise the "iova" array. */
      {
	for (mmux_standard_uint_t i=0; i<bufnum.value; ++i) {
	  mmux_libc_iov_len_set  (&(iov[i]), buflen);
	  mmux_libc_iov_base_set (&(iov[i]), &(bufptr[i][0]));
	}

	mmux_libc_iova_len_set  (&iova, bufnum);
	mmux_libc_iova_base_set (&iova, iov);
      }

      /* Perform the reading. */
      {
	mmux_usize_t	nbytes_done;
	auto		offset = mmux_off_constant_zero();
	auto		flags  = mmux_libc_scatter_gather_flags(MMUX_LIBC_RWF_HIPRI);

	printf_message("preadv2-ing");
	if (mmux_libc_preadv2(&nbytes_done, mfd, &iova, offset, flags)) {
	  printf_error("preadv2-ing");
	  handle_error();
	}

	/* Validate the number of octets read. */
	{
	  auto	expected_nbytes_written = mmux_ctype_mul(buflen, bufnum);

	  if (mmux_ctype_not_equal(nbytes_done, expected_nbytes_written)) {
	    printf_error("wrong number of written octets, expected %lu got %lu",
			 expected_nbytes_written.value, nbytes_done.value);
	    handle_error();
	  }
	}
      }

      /* Check if the read buffers contain the expected data. */
      {
	for (mmux_standard_uint_t i=0; i<bufnum.value; ++i) {
	  for (mmux_standard_uint_t j=0; j<buflen.value; ++j) {
	    mmux_standard_octet_t	expected_octet = (10 * i + j);
	    if (false) {
	      if (mmux_libc_dprintfer("bufptr[%u][%u] = %u\n", i, j, bufptr[i][j])) {
		handle_error();
	      }
	    }
	    if (bufptr[i][j] != expected_octet) {
	      printf_error("wrong octet at bufptr[%u][%u], expected %u got %u\n",
			   i, j, expected_octet, bufptr[i][j]);
	      handle_error();
	    }
	  }
	}
	printf_message("correct buffer contents");
      }
    }

    /* Final cleanup. */
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
