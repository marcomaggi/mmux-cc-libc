/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jun 23, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

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
    PROGNAME = "test-wait";
  }

  bool                    this_is_the_parent_process;
  mmux_libc_pid_t         child_pid;

  mmux_cc_libc_init();

  if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
    print_error("forking");
    goto error;
  } else if (this_is_the_parent_process) {
    /* Give the child process a bit of time to exit. */
    {
      mmux_libc_timespec_t    requested_time;
      mmux_libc_timespec_t    remaining_time;

      mmux_libc_timespec_set(&requested_time, mmux_time_literal(0), mmux_slong_literal(5000000));
      if (mmux_libc_nanosleep(&requested_time, &remaining_time)) {
	print_error("nanosleep");
	goto error;
      }
    }

    /* Wait for child process. */
    {
      bool					process_completion_status_available;
      mmux_libc_pid_t				completed_process_pid;
      mmux_libc_process_completion_status_t	process_completion_status;

      if (mmux_libc_wait(&process_completion_status_available,
			 &process_completion_status,
			 &completed_process_pid)) {
	print_error("waiting");
	goto error;
      } else {
	if (process_completion_status_available) {
	  printf_message("child process completion status: %d\n", process_completion_status.value);
	  if (mmux_libc_pid_equal(completed_process_pid, child_pid)) {
	    mmux_libc_exit_success();
	  } else {
	    print_error("unexpected completed process PID\n");
	    mmux_libc_exit_failure();
	  }
	} else {
	  printf_error("no complete child process status\n");
	  mmux_libc_exit_failure();
	}
      }
    }
  } else {
    MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfou("%s: child process: exiting\n", PROGNAME));
    mmux_libc_exit_success();
  }

 error:
  {
    mmux_libc_errno_t	errnum;
    mmux_asciizcp_t	errmsg;

    mmux_libc_errno_consume(&errnum);
    if (mmux_libc_strerror(&errmsg, errnum)) {
      mmux_libc_exit_failure();
    } else {
      print_error(errmsg);
    }
    mmux_libc_exit_failure();
  }
}

/* end of file */
