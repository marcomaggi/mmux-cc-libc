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
    PROGNAME = "test-struct-flock";
  }

  mmux_libc_flock_t	flo;
  mmux_libc_pid_t	pid;

  if (mmux_libc_make_pid(&pid, 0)) {
    handle_error();
  }

  mmux_libc_l_type_set   (&flo, MMUX_LIBC_F_RDLCK);
  mmux_libc_l_whence_set (&flo, MMUX_LIBC_SEEK_SET);
  mmux_libc_l_start_set  (&flo, 11);
  mmux_libc_l_len_set    (&flo, 33);
  mmux_libc_l_pid_set    (&flo, pid);

  {
    mmux_libc_fd_t	fd;

    mmux_libc_stdou(&fd);
    if (mmux_libc_flock_dump(fd, &flo, NULL)) {
      handle_error();
    }
    if (mmux_libc_flock_dump(fd, &flo, "mystruct")) {
      handle_error();
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
