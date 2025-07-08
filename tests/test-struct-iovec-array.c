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

static mmux_asciizcp_t	PROGNAME = "test-struct-iovec-array";


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
  mmux_usize_t const		array_length = 16;
  mmux_libc_iovec_t		array_pointer[array_length];
  mmux_libc_iovec_array_t	iova;

  mmux_libc_iova_pointer_set (&iova, array_pointer);
  mmux_libc_iova_length_set  (&iova, array_length);

  {
    mmux_usize_t	the_array_length;
    mmux_libc_iovec_t *	the_array_pointer;

    mmux_libc_iova_length_ref  (&the_array_length,  &iova);
    mmux_libc_iova_pointer_ref (&the_array_pointer, &iova);

    assert(the_array_length  == array_length);
    assert(the_array_pointer == array_pointer);
  }

  {
    mmux_libc_fd_t	fd;

    mmux_libc_stdou(&fd);
    if (mmux_libc_iovec_array_dump(fd, &iova, NULL)) {
      handle_error();
    }
    if (mmux_libc_iovec_array_dump(fd, &iova, "mystruct")) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
