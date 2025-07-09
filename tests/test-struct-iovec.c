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

#include <mmux-cc-libc.h>
#include <assert.h>

static mmux_asciizcp_t	PROGNAME = "test-struct-iovec";


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
  mmux_usize_t const	bufnum = 16;
  mmux_usize_t const	buflen = 4096;
  mmux_octet_t		bufptr[bufnum][buflen];
  mmux_libc_iovec_t	iov[bufnum];

  for (mmux_uint_t i=0; i<bufnum; ++i) {
    mmux_libc_iov_len_set  (&(iov[i]), buflen);
    mmux_libc_iov_base_set (&(iov[i]), &(bufptr[i][0]));
  }

  {
    mmux_usize_t	the_buflen;
    mmux_octet_t *	the_bufptr;

    mmux_libc_iov_len_ref  (&the_buflen, &(iov[0]));
    mmux_libc_iov_base_ref ((mmux_pointer_t)&the_bufptr, &(iov[0]));

    assert(the_buflen == buflen);
    assert((mmux_pointer_t)the_bufptr == (mmux_pointer_t)&(bufptr[0]));
  }

  {
    mmux_libc_fd_t	fd;

    mmux_libc_stdou(&fd);
    if (mmux_libc_iovec_dump(fd, &(iov[0]), NULL)) {
      handle_error();
    }
    if (mmux_libc_iovec_dump(fd, &(iov[0]), "mystruct")) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
