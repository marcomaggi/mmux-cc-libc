/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 16, 2025

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
 ** Helpers.
 ** ----------------------------------------------------------------- */

static bool got_sigusr1 = false;
static bool got_sigusr2 = false;

static void
this_process_handler (mmux_standard_sint_t signum MMUX_CC_LIBC_UNUSED)
{
  printf_message("%s: inside SIGUSR1 handler", __func__);

  switch (signum) {
  case MMUX_LIBC_VALUEOF_SIGUSR1:
    got_sigusr1 = true;
    break;

  case MMUX_LIBC_VALUEOF_SIGUSR2:
    got_sigusr2 = true;
    break;
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
    PROGNAME = "test-interprocess-signals-action";
  }

  {
    mmux_libc_sigaction_t  sigaction;
    mmux_libc_sigset_t	   action_blocking_mask;
    auto		   action_flags = mmux_libc_sigaction_flags(0);

    /* Block all the interprocess signals while "this_process_handler()" is running. */
    mmux_libc_sigfillset(action_blocking_mask);

    mmux_libc_sa_handler_set (sigaction, this_process_handler);
    mmux_libc_sa_mask_set    (sigaction, action_blocking_mask);
    mmux_libc_sa_flags_set   (sigaction, action_flags);

    mmux_libc_sigaction(MMUX_LIBC_SIGUSR1, sigaction, NULL);
    mmux_libc_sigaction(MMUX_LIBC_SIGUSR2, sigaction, NULL);

    if (mmux_libc_raise(MMUX_LIBC_SIGUSR1)) {
      handle_error();
    }
    if (mmux_libc_raise(MMUX_LIBC_SIGUSR2)) {
      handle_error();
    }

    if (got_sigusr1) {
      printf_message("correctly handled SIGUSR1");
    } else {
      printf_error("wrongly not-handled SIGUSR1");
      handle_error();
    }
    if (got_sigusr2) {
      printf_message("correctly handled SIGUSR2");
    } else {
      printf_error("wrongly not-handled SIGUSR2");
      handle_error();
    }
  }
  mmux_libc_exit_success();
}

/* end of file */
