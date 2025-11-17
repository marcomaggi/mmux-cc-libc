/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 17, 2025

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

static bool		got_signal = false;
static mmux_sint_t	associated_value = { .value = 0 };

static void
this_process_handler (mmux_standard_sint_t signum, mmux_libc_siginfo_arg_t siginfo,
		      mmux_pointer_t reserved_context MMUX_CC_LIBC_UNUSED)
{
  printf_message("%s: inside SIGUSR1 handler", __func__);
  {
    auto	ipxsig = mmux_libc_interprocess_signal(signum);

    got_signal = true;
    if (mmux_libc_interprocess_signal_equal(ipxsig, MMUX_LIBC_SIGUSR1)) {
      printf_message("%s: correctly got SIGUSR1", __func__);
    } else {
      printf_error("%s: wrongly got a signal different from SIGUSR1", __func__);
      handle_error();
    }

    {
      auto	expected_associated_value = mmux_sint_literal(123);

      mmux_libc_si_value_sival_int_ref(&associated_value, siginfo);
      if (mmux_ctype_equal(associated_value, expected_associated_value)) {
	printf_message("%s: correctly got associated value: %d", __func__, associated_value.value);
      } else {
	printf_error("%s: wrong associated value, expected '%d', got '%d'",
		     __func__, expected_associated_value.value, associated_value.value);
	handle_error();
      }
    }
  }
}


static void paren_wait_for_child_process_completion (mmux_libc_pid_t child_pid);

static void
play_parent (mmux_libc_pid_t child_pid)
{
  printf_message("paren: enter");

  /* Register the  signal handler for SIGUSR1  using "sigaction()".  Do it  in such a
     way that we expect a sigval associated to the signal. */
  {
    mmux_libc_sigaction_t  sigaction;
    mmux_libc_sigset_t	   action_blocking_mask;
    auto		   action_flags = mmux_libc_sigaction_flags(MMUX_LIBC_SA_SIGINFO);

    /* Block all the interprocess signals while "this_process_handler()" is running. */
    mmux_libc_sigfillset(action_blocking_mask);

    mmux_libc_sa_sigaction_set (sigaction, this_process_handler);
    mmux_libc_sa_mask_set      (sigaction, action_blocking_mask);
    mmux_libc_sa_flags_set     (sigaction, action_flags);

    mmux_libc_sigaction(MMUX_LIBC_SIGUSR1, sigaction, NULL);
  }

  /* Wait for a signal to arrive. */
  {
    mmux_libc_sigset_t  temporary_blocking_mask;

    mmux_libc_sigfillset(temporary_blocking_mask);
    mmux_libc_sigdelset(temporary_blocking_mask, MMUX_LIBC_SIGUSR1);
    mmux_libc_sigsuspend(temporary_blocking_mask);
  }

  /* Validate the after-signal scenario. */
  {
    auto	expected_associated_value = mmux_sint_literal(123);

    if (got_signal) {
      printf_message("paren: correctly handled an interprocess signal");
    } else {
      printf_error("paren: wrongly not-handled an interprocess signal");
      handle_error();
    }

    if (mmux_ctype_equal(associated_value, expected_associated_value)) {
      printf_message("paren: correctly got associated value: %d", associated_value.value);
    } else {
      printf_error("paren: wrong associated value, expected '%d', got '%d'",
		   expected_associated_value.value, associated_value.value);
      handle_error();
    }
  }

  /* Wait for the completion of the child process. */
  {
    paren_wait_for_child_process_completion(child_pid);
  }

  printf_message("paren: terminating");
  mmux_libc_exit_success();
}
void
paren_wait_for_child_process_completion (mmux_libc_pid_t child_pid)
{
  bool					process_completion_status_is_available;
  mmux_libc_pid_t			completed_process_pid;
  mmux_libc_process_completion_status_t	process_completion_status;
  auto	waiting_options = mmux_libc_process_completion_waiting_options(0);

  printf_message("paren: waiting for child process termination");
  if (mmux_libc_wait_process_id(&process_completion_status_is_available,
				&process_completion_status, &completed_process_pid,
				child_pid, waiting_options)) {
    printf_error("paren: waiting for child process termination");
    handle_error();
  } else {
    if (process_completion_status_is_available) {
      printf_message("paren: child process completion status: %d", process_completion_status.value);
    } else {
      printf_error("paren: no complete child process status");
      handle_error();
    }
  }
}


static void
play_child (void)
{
  printf_message("child: enter");
  {
    mmux_libc_pid_t			paren_pid;
    mmux_libc_interprocess_signal_t	ipxsig = MMUX_LIBC_SIGUSR1;
    mmux_libc_sigval_t			sigval;

    mmux_libc_getppid(&paren_pid);
    mmux_libc_sival_int_set(sigval, mmux_sint(123));

    printf_message("child: sigqueue-ing");
    if (mmux_libc_sigqueue(paren_pid, ipxsig, sigval)) {
      printf_error("child: sigqueue-ing");
      handle_error();
    }
  }
  printf_message("child: terminating");
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
    PROGNAME = "test-interprocess-signals-action";
  }

  {
    bool		this_is_the_parent_process;
    mmux_libc_pid_t	child_pid;

    if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
      print_error("forking");
      handle_error();
    } else if (this_is_the_parent_process) {
      play_parent(child_pid);
    } else {
      play_child();
    }

    /* We should never get here. */
    mmux_libc_exit_failure();
  }
}

/* end of file */
