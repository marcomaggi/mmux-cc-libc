/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 15, 2025

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
    PROGNAME = "test-interprocess-signals-pending";
  }

  /* Block all the signals. */
  {
    mmux_libc_sigset_t	new_blocking_mask;

    if (mmux_libc_sigfillset(new_blocking_mask)) {
      handle_error();
    }
    if (mmux_libc_interprocess_signals_blocking_mask_set(new_blocking_mask, NULL)) {
      handle_error();
    }
  }

  /* Send SIGUSR1 to this process itself. */
  {
    if (mmux_libc_raise(MMUX_LIBC_SIGUSR1)) {
      handle_error();
    }
  }

  /* Test if SIGUSR1 is pending. */
  {
    mmux_libc_sigset_t	pending_signals;

    if (mmux_libc_sigpending(pending_signals)) {
      handle_error();
    } else {
      bool  is_member;

      mmux_libc_sigismember(&is_member, pending_signals, MMUX_LIBC_SIGUSR1);
      if (is_member) {
	printf_message("pending signals set correctly does contain SIGUSR1");
      } else {
	printf_error("pending signals set wrongly does not contain SIGUSR1");
	handle_error();
      }
    }
  }

  /* Test if SIGUSR2 is pending. */
  {
    mmux_libc_sigset_t	pending_signals;

    if (mmux_libc_sigpending(pending_signals)) {
      handle_error();
    } else {
      bool  is_member;

      mmux_libc_sigismember(&is_member, pending_signals, MMUX_LIBC_SIGUSR2);
      if (is_member) {
	printf_error("pending signals set wrongly does contain SIGUSR2");
	handle_error();
      } else {
	printf_message("pending signals set correctly does not contain SIGUSR2");
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
