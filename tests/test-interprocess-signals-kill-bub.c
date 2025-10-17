/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 13, 2025

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
 ** Test: delivery and handling of SIGUSR1.
 ** ----------------------------------------------------------------- */

static bool
test_delivery_and_handling (void)
{
  bool                    this_is_the_parent_process;
  mmux_libc_pid_t         child_pid;

  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-interprocess-signals-raise-pause";
  }

  if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
    print_error("forking");
    handle_error();
  } else if (this_is_the_parent_process) {

    /* Give the child process a bit of time to exit. */
    printf_message("paren process: giving child process some time to start");
    wait_for_some_time();

    /* Deliver SIGUSR1 to the child process. */
    {
      printf_message("paren process: delivering SIGUSR1 to child process");
      if (mmux_libc_kill(child_pid, MMUX_LIBC_SIGUSR1)) {
	handle_error();
      }
    }

    /* Wait for child process completion. */
    {
      bool					process_completion_status_available;
      mmux_libc_process_completion_status_t	process_completion_status;
      mmux_libc_pid_t				completed_process_pid;
      auto	waiting_options = mmux_libc_process_completion_waiting_options(0);

      printf_message("paren process: waiting for child process completion");
      if (mmux_libc_wait_process_id(&process_completion_status_available,
				    &process_completion_status,
				    &completed_process_pid,
				    child_pid, waiting_options)) {
	print_error("waiting");
	handle_error();
      } else {
	if (process_completion_status_available) {
	  printf_message("paren process: child process completion status: %d\n", process_completion_status.value);
	  return false;
	} else {
	  printf_message("paren process: no complete child process status\n");
	  return true;
	}
      }
    }
  } else {
    bool	delivered;

    printf_message("child process: entering");

    printf_message("child process: initialising BUB API");
    if (mmux_libc_interprocess_signals_bub_init()) {
      handle_error();
    }

    printf_message("child process: waiting");
    wait_for_some_time();

    printf_message("child process: acuiring BUB delivered signals");
    if (mmux_libc_interprocess_signals_bub_acquire()) {
      handle_error();
    }

    /* Check if SIGUSR1 was received. */
    {
      if (mmux_libc_interprocess_signals_bub_delivered(&delivered, MMUX_LIBC_SIGUSR1)) {
	handle_error();
      }
    }

    printf_message("child process: finalising BUB API");
    if (mmux_libc_interprocess_signals_bub_final()) {
      handle_error();
    }

    printf_message("child process: exiting");
    if (delivered) {
      printf_message("child process: SIGUSR1 was received");
      mmux_libc_exit_success();
    } else {
      printf_message("child process: no SIGUSR1 was received");
      mmux_libc_exit_failure();
    }
  }

  return true;
}


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  if (test_delivery_and_handling()) {
    mmux_libc_exit_failure();
  }
  mmux_libc_exit_success();
}

/* end of file */
