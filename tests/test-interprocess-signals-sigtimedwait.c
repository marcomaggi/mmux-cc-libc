/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 18, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


static void
play_paren (mmux_libc_pid_t child_pid)
{
  printf_message("paren: starting");

  /* Block all the signals. */
  {
    mmux_libc_sigset_t	new_blocking_mask;

    mmux_libc_sigfillset(new_blocking_mask);

    printf_message("paren: blocking all the signals");
    if (mmux_libc_interprocess_signals_blocking_mask_set(new_blocking_mask, NULL)) {
      printf_error("paren: blocking all the signals");
      handle_error();
    }
  }

  /* Wait for SIGUSR1 and SIGUSR2. */
  {
    mmux_libc_siginfo_t		delivered_siginfo;
    mmux_libc_sigset_t		ipxsigset_to_wait_for;
    mmux_libc_timespec_t	timeout;

    mmux_libc_sigemptyset(ipxsigset_to_wait_for);
    mmux_libc_sigaddset(ipxsigset_to_wait_for, MMUX_LIBC_SIGUSR1);
    mmux_libc_sigaddset(ipxsigset_to_wait_for, MMUX_LIBC_SIGUSR2);

    mmux_libc_timespec_set(timeout, mmux_time_literal(1), mmux_slong_literal(0));

    printf_message("paren: wait for SIGUSR1 and SIGUSR2");
    if (mmux_libc_sigtimedwait(delivered_siginfo, ipxsigset_to_wait_for, timeout)) {
      mmux_libc_errno_t	errnum;

      mmux_libc_errno_consume(&errnum);
      if (mmux_libc_errno_equal(errnum, MMUX_LIBC_EAGAIN)) {
	printf_error("paren: no signal was delivered in the given timeout");
	handle_error();
      } else {
	printf_error("paren: wait for SIGUSR1 and SIGUSR2");
	handle_error();
      }
    } else {
      mmux_libc_interprocess_signal_t	delivered_ipxsig;

      mmux_libc_si_signo_ref(&delivered_ipxsig, delivered_siginfo);
      if (mmux_libc_interprocess_signal_equal(delivered_ipxsig, MMUX_LIBC_SIGUSR1)) {
	printf_message("paren: successufully received SIGUSR1");
      } else {
	printf_message("paren: expected SIGUSR1, got some other signal");
	handle_error();
      }
    }
  }

  /* Wait for the child to terminate. */
  {
    bool				   process_completion_status_is_available;
    mmux_libc_process_completion_status_t  process_completion_status;
    mmux_libc_pid_t			   completed_process_pid;
    auto  waiting_options = mmux_libc_process_completion_waiting_options(0);

    if (mmux_libc_wait_process_id(&process_completion_status_is_available,
				  &process_completion_status,
				  &completed_process_pid,
				  child_pid, waiting_options)) {
      handle_error();
    } else if (process_completion_status_is_available) {
      bool	child_terminated_with_exit;

      mmux_libc_WIFEXITED(&child_terminated_with_exit, process_completion_status);
      if (child_terminated_with_exit) {
	printf_message("paren: successfully gathered child termination");
	{
	  mmux_libc_process_exit_status_t	exit_status;

	  mmux_libc_WEXITSTATUS(&exit_status, process_completion_status);
	  if (mmux_libc_process_exit_status_equal(exit_status, MMUX_LIBC_EXIT_SUCCESS)) {
	    printf_message("paren: the child exited successfully");
	  } else {
	    printf_error("paren: the child exited UNsuccessfully");
	  }
	}
      } else {
	printf_error("paren: abnormal termination of child process");
	handle_error();
      }
    } else {
      printf_error("paren: waiting for child termination: no completed process status was collected");
      handle_error();
    }
  }

  printf_message("paren: exiting");
  mmux_libc_exit_success();
}


static void
play_child (void)
{
  printf_message("child: starting");

  /* Give the paren some time to get ready. */
  {
    wait_for_some_time();
  }

  /* Send SIGUSR1 to the paren. */
  {
    mmux_libc_pid_t	paren_pid;

    mmux_libc_getppid(&paren_pid);

    printf_message("child: sending the parent the SIGUSR1 signal");
    if (mmux_libc_kill(paren_pid, MMUX_LIBC_SIGUSR1)) {
      printf_error("child: sending the parent the SIGUSR1 signal");
      handle_error();
    }
  }

  printf_message("child: exiting");
  mmux_libc_exit_success();
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
    PROGNAME = "test-interprocess-signals-sigtimedwait";
  }

  {
    bool		this_is_the_paren_process;
    mmux_libc_pid_t	child_pid;

    if (mmux_libc_fork(&this_is_the_paren_process, &child_pid)) {
      handle_error();
    } else if (this_is_the_paren_process) {
      play_paren(child_pid);
    } else {
      play_child();
    }
  }

  /* We should never get here. */
  mmux_libc_exit_failure();
}

/* end of file */
