/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul  8, 2025

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
    PROGNAME = "test-struct-iovec-array";
  }

  {
    auto const		bufnum = mmux_usize_literal(4);
    auto const		buflen = mmux_usize_literal(4096);
    mmux_octet_t	bufptr[bufnum.value][buflen.value];
    mmux_libc_iovec_t	iov[bufnum.value];

    mmux_libc_iovec_array_t	iova;

    for (mmux_standard_uint_t i=0; i<bufnum.value; ++i) {
      mmux_libc_iov_len_set  (&(iov[i]), buflen);
      mmux_libc_iov_base_set (&(iov[i]), &(bufptr[i][0]));
    }

    mmux_libc_iova_len_set  (&iova, bufnum);
    mmux_libc_iova_base_set (&iova, iov);

    /* Validate array's fields. */
    {
      mmux_usize_t		the_array_length;
      mmux_libc_iovec_t *	the_array_pointer;

      mmux_libc_iova_len_ref  (&the_array_length,  &iova);
      mmux_libc_iova_base_ref (&the_array_pointer, &iova);

      assert(mmux_ctype_equal(the_array_length, bufnum));
      assert(the_array_pointer == iov);
    }

    /* Dump array's fields. */
    {
      mmux_libc_oufd_t	fd;

      mmux_libc_stdou(fd);
      if (mmux_libc_iovec_array_dump(fd, &iova, NULL)) {
	handle_error();
      }
      if (mmux_libc_iovec_array_dump(fd, &iova, "mystruct")) {
	handle_error();
      }
    }

  }
  mmux_libc_exit_success();
}

/* end of file */
