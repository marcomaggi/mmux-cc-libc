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

#undef NDEBUG
#include <mmux-cc-libc.h>
#include <assert.h>

static mmux_asciizcp_t	PROGNAME = "test-preadv-pwritev";


/** --------------------------------------------------------------------
 ** Helpers.
 ** ----------------------------------------------------------------- */

static void
print_error (mmux_asciizcp_t errmsg)
{
  mmux_libc_dprintfer("%s: error: %s\n", PROGNAME, errmsg);
}
static void
handle_error (void)
{
  mmux_sint_t		errnum;
  mmux_asciizcp_t	errmsg;

  mmux_libc_errno_consume(&errnum);
  if (errnum) {
    if (mmux_libc_strerror(&errmsg, errnum)) {
      mmux_libc_exit_failure();
    } else {
      print_error(errmsg);
    }
  }
  mmux_libc_exit_failure();
}


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  mmux_libc_fd_t	mfd;

  if (mmux_libc_make_mfd(&mfd)) {
    handle_error();
  }

  /* Write. */
  {
    mmux_usize_t const		bufnum = 4;
    mmux_usize_t const		buflen = 8;
    mmux_octet_t		bufptr[bufnum][buflen];
    mmux_libc_iovec_t		iov[bufnum];

    mmux_libc_iovec_array_t	iova;

    for (mmux_uint_t i=0; i<bufnum; ++i) {
      mmux_libc_iov_len_set  (&(iov[i]), buflen);
      mmux_libc_iov_base_set (&(iov[i]), &(bufptr[i][0]));
    }

    mmux_libc_iova_len_set  (&iova, bufnum);
    mmux_libc_iova_base_set (&iova, iov);

    /* Fill the buffers. */
    for (mmux_uint_t i=0; i<bufnum; ++i) {
      for (mmux_uint_t j=0; j<buflen; ++j) {
	bufptr[i][j] = 10 * i + j;
      }
    }

    /* Perform the writing. */
    {
      mmux_usize_t	nbytes_done;
      mmux_off_t	offset = 0;

      if (mmux_libc_pwritev(&nbytes_done, mfd, &iova, offset)) {
	print_error("writev");
	handle_error();
      }

      assert(nbytes_done == (buflen * bufnum));
    }
  }

  {
    mmux_off_t	position = 0;

    if (mmux_libc_lseek(mfd, &position, MMUX_LIBC_SEEK_SET)) {
      print_error("seeking");
      handle_error();
    }
  }

  /* Read. */
  {
    mmux_usize_t const		bufnum = 4;
    mmux_usize_t const		buflen = 8;
    mmux_octet_t		bufptr[bufnum][buflen];
    mmux_libc_iovec_t		iov[bufnum];

    mmux_libc_iovec_array_t	iova;

    for (mmux_uint_t i=0; i<bufnum; ++i) {
      mmux_libc_iov_len_set  (&(iov[i]), buflen);
      mmux_libc_iov_base_set (&(iov[i]), &(bufptr[i][0]));
    }

    mmux_libc_iova_len_set  (&iova, bufnum);
    mmux_libc_iova_base_set (&iova, iov);

    /* Perform the reading. */
    {
      mmux_usize_t	nbytes_done;
      mmux_off_t	offset = 0;

      if (mmux_libc_preadv(&nbytes_done, mfd, &iova, offset)) {
	print_error("readv");
	handle_error();
      }

      if (0) {
	mmux_libc_dprintfer("after reading: nbytes_done=%lu, buflen*bufnum=%lu\n", nbytes_done, buflen * bufnum);
      }
      assert(nbytes_done == (buflen * bufnum));
    }

    /* Check the buffers. */
    for (mmux_uint_t i=0; i<bufnum; ++i) {
      for (mmux_uint_t j=0; j<buflen; ++j) {
	if (0) {
	  mmux_libc_dprintfer("bufptr[%u][%u] = %u\n", i, j, bufptr[i][j]);
	}
	assert(bufptr[i][j] == (10 * i + j));
      }
    }
  }

  if (mmux_libc_close(mfd)) {
    handle_error();
  }

  mmux_libc_exit_success();
}

/* end of file */
