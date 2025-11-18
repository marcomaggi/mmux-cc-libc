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

  mmux_libc_sigfd_t	sigfd;

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

  /* Obtain the signal file descriptor. */
  {
    mmux_libc_sigset_t	signals_to_wait_for;
    auto		flags = mmux_libc_signalfd_flags(MMUX_LIBC_SFD_CLOEXEC);

    mmux_libc_sigemptyset(signals_to_wait_for);
    mmux_libc_sigaddset(signals_to_wait_for, MMUX_LIBC_SIGUSR1);
    mmux_libc_sigaddset(signals_to_wait_for, MMUX_LIBC_SIGUSR2);

    printf_message("paren: making a new signal file descriptor");
    if (mmux_libc_make_signalfd(sigfd, signals_to_wait_for, flags)) {
      printf_error("paren: making a new signal file descriptor");
      handle_error();
    }
  }

  /* Wait for SIGUSR1 and SIGUSR2 by reading from sigfd, blocking as needed. */
  {
    mmux_libc_signalfd_siginfo_t	delivered_ipxsigset;
    mmux_usize_t	nbytes_done, buflen = mmux_usize(sizeof(*delivered_ipxsigset));

    printf_message("paren: reading the signalfd_siginfo, blocking as needed");
    if (mmux_libc_read(&nbytes_done, sigfd, delivered_ipxsigset, buflen)) {
      printf_error("paren: reading the signalfd_siginfo");
      handle_error();
    } else {
      mmux_libc_ipxsig_t	delivered_signal;

      printf_message("paren: a signal was received");

      mmux_libc_ssi_signo_ref(&delivered_signal, delivered_ipxsigset);
      if (mmux_libc_interprocess_signal_equal(delivered_signal, MMUX_LIBC_SIGUSR1)) {
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
    PROGNAME = "test-interprocess-signals-make-signalfd";
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
