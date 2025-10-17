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
 ** Helpers.
 ** ----------------------------------------------------------------- */

static void
my_sigusr1_handler (mmux_standard_sint_t signum MMUX_CC_LIBC_UNUSED)
{
  printf_message("%s: inside SIGUSR1 handler", __func__);
  return;
}


/** --------------------------------------------------------------------
 ** Test: delivery and handling of SIGUSR1.
 ** ----------------------------------------------------------------- */

static bool
test_delivery_and_handling (void)
{
  printf_message("running test: %s", __func__);

  bool                    this_is_the_parent_process;
  mmux_libc_pid_t         child_pid;

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
	print_error("parent prpocess: waiting");
	handle_error();
      } else {
	if (process_completion_status_available) {
	  printf_message("paren process: the child process had completed with completion status: '%d'",
			 process_completion_status.value);

	  /* The child process handles SIGUSR1, so  we expect it to exit successfully
	     after having handled the event. */
	  {
	    bool	child_process_has_exited;
	    bool	child_process_has_been_signaled;

	    assert(false == mmux_libc_WIFSIGNALED (&child_process_has_been_signaled, process_completion_status));
	    assert(false == mmux_libc_WIFEXITED   (&child_process_has_exited,        process_completion_status));

	    if (child_process_has_been_signaled) {
	      printf_error("parent process: the child process has been signaled with something different from SIGUSR1");
	      return true;
	    } else if (child_process_has_exited) {
	      mmux_libc_process_exit_status_t	status;

	      assert(false == mmux_libc_WEXITSTATUS(&status, process_completion_status));
	      printf_message("parent process: the child process has exited with exit status: '%d'", status.value);
	      return false;
	    } else {
	      print_error("parent process: why did the child process exit?  We should never be here!");
	      return true;
	    }
	  }
	} else {
	  printf_error("paren process: no complete child process status\n");
	  return true;
	}
      }
    }
  } else {
    printf_message("child process: entering");

    /* Register the handler for SIGUSR1. */
    {
      mmux_libc_sighandler_t *	the_old_handler;

      printf_message("child process: registering SIGUSR1 handler");
      if (mmux_libc_signal(&the_old_handler, MMUX_LIBC_SIGUSR1, my_sigusr1_handler)) {
	handle_error();
      }
    }

    /* In   the   child  process:   we   are   handling   the  signal   SIGUSR1,   so
       "mmux_libc_pause()"  will return  whenever SIGUSR1  is received,  and it  will
       return "true".  If the child process is terminated by some other event, like a
       signal different from SIGUSR1: "mmux_libc_pause()" will not return. */
    printf_message("child process: pausing until termination by signal");
    if (mmux_libc_pause()) {
      /* By convention: the  successful execution of "mmux_libc_pause()"  is to pause
	 the process forever; so it if returns it is considered a failure. */
      printf_message("child process: successfully exiting after handling the SIGUSR1 signal");
      mmux_libc_exit_success();
    } else {
      printf_error("child process: unexpected return value from pause()");
      mmux_libc_exit_failure();
    }
  }

  return true;
}


/** --------------------------------------------------------------------
 ** Test: delivery and termination.
 ** ----------------------------------------------------------------- */

static bool
test_delivery_and_termination (void)
{
  printf_message("running test: %s", __func__);

  bool                    this_is_the_parent_process;
  mmux_libc_pid_t         child_pid;

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
	print_error("parent process: waiting");
	handle_error();
      } else {
	if (process_completion_status_available) {
	  printf_message("paren process: the child process has completed with completion status: '%d'",
			 process_completion_status.value);
	  {
	    bool	child_process_has_been_signaled;

	    assert(false == mmux_libc_WIFSIGNALED(&child_process_has_been_signaled, process_completion_status));
	    if (child_process_has_been_signaled) {
	      printf_message("paren process: the child process has been signaled, as we expected");
	      {
		mmux_libc_interprocess_signal_t		ipxsig, expected_ipxsig = MMUX_LIBC_SIGUSR1;
		bool					the_signal_is_the_expected_one;

		assert(false == mmux_libc_WTERMSIG(&ipxsig, process_completion_status));
		assert(false == mmux_sint_equal_p(&the_signal_is_the_expected_one, &ipxsig, &expected_ipxsig));
		if (the_signal_is_the_expected_one) {
		  printf_message("parent process: the child process was correctly terminated by SIGUSR1, as we expected");
		  return false;
		} else {
		  printf_error("parent process: expected the child process to be terminated by SIGUSR1");
		  return true;
		}
	      }
	    } else {
	      printf_error("paren process: the child process terminated for some reason different from being signaled");
	      return true;
	    }
	  }
	} else {
	  printf_message("paren process: no complete child process status\n");
	  return true;
	}
      }
    }
  } else {
    printf_message("child process: entering");

    /* In the child  process: we are NOT handling any  signal, so "mmux_libc_pause()"
       will never return. */
    printf_message("child process: pausing until termination by signal");
    mmux_libc_pause();
    printf_error("child process: unexpected return from pause()");
    mmux_libc_exit_failure();
  }
  return true;
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
    PROGNAME = "test-interprocess-signals-raise-pause";
  }

  if (test_delivery_and_handling()) {
    mmux_libc_exit_failure();
  }
  print_newline();
  if (test_delivery_and_termination()) {
    mmux_libc_exit_failure();
  }
  mmux_libc_exit_success();
}

/* end of file */
