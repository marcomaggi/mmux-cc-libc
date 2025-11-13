/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Oct 15, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

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
    PROGNAME = "test-processes-completion-status";
  }

  /* Constructor. */
  {
    mmux_libc_process_completion_status_t	pcs;

    assert(false == mmux_libc_make_process_completion_status(&pcs, 123));
  }

  /* Equality. */
  {
    {
      mmux_libc_process_completion_status_t	pcs1, pcs2;
      bool					result;

      assert(false == mmux_libc_make_process_completion_status(&pcs1, 123));
      assert(false == mmux_libc_make_process_completion_status(&pcs2, 456));
      assert(false == mmux_libc_process_completion_status_equal(&result, pcs1, pcs2));
      assert(false == result);
    }
    {
      mmux_libc_process_completion_status_t	pcs1, pcs2;
      bool					result;

      assert(false == mmux_libc_make_process_completion_status(&pcs1, 123));
      assert(false == mmux_libc_make_process_completion_status(&pcs2, 123));
      assert(false == mmux_libc_process_completion_status_equal(&result, pcs1, pcs2));
      assert(true  == result);
    }
  }

  /* Non-equality. */
  {
    {
      mmux_libc_process_completion_status_t	pcs1, pcs2;
      bool					result;

      assert(false == mmux_libc_make_process_completion_status(&pcs1, 123));
      assert(false == mmux_libc_make_process_completion_status(&pcs2, 456));
      assert(false == mmux_libc_process_completion_status_not_equal(&result, pcs1, pcs2));
      assert(true  == result);
    }
    {
      mmux_libc_process_completion_status_t	pcs1, pcs2;
      bool					result;

      assert(false == mmux_libc_make_process_completion_status(&pcs1, 123));
      assert(false == mmux_libc_make_process_completion_status(&pcs2, 123));
      assert(false == mmux_libc_process_completion_status_not_equal(&result, pcs1, pcs2));
      assert(false == result);
    }
  }

  /* Printing */
  {
    mmux_libc_process_completion_status_t	pcs;
    mmux_libc_oufd_t				fd;

    mmux_libc_stder(fd);
    assert(false == mmux_libc_make_process_completion_status(&pcs, 123));
    assert(false == mmux_libc_dprintfer("%s: process completion status: '", __func__));
    assert(false == mmux_libc_dprintf_process_completion_status(fd, pcs));
    assert(false == mmux_libc_dprintfer("'\n"));
  }

  mmux_libc_exit_success();
}

/* end of file */
