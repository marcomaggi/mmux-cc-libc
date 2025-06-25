/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jun 23, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/

#include <mmux-cc-libc.h>

static mmux_asciizcp_t	PROGNAME = "mmux_libc_wait_any_process";

static void
print_error (mmux_asciizcp_t errmsg)
{
  mmux_libc_dprintfer("%s: error: %s\n", PROGNAME, errmsg);
}

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  bool                    this_is_the_parent_process;
  mmux_libc_pid_t         child_pid;

  mmux_cc_libc_init();

  if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
    print_error("forking");
    goto error;
  } else if (this_is_the_parent_process) {
    bool					completed_process_status_available;
    mmux_libc_pid_t				completed_process_pid;
    mmux_libc_completed_process_status_t	completed_process_status;

    /* Give the child process a bit of time to exit. */
    {
      mmux_libc_timespec_t    requested_time;
      mmux_libc_timespec_t    remaining_time;

      mmux_libc_timespec_set(&requested_time, 0, 5000000);
      if (mmux_libc_nanosleep(&requested_time, &remaining_time)) {
	print_error("nanosleep");
	goto error;
      }
    }

    if (mmux_libc_wait_any_process(&completed_process_status_available, &completed_process_pid,
				   &completed_process_status, MMUX_LIBC_WNOHANG)) {
      print_error("waiting");
      goto error;
    } else {
      if (completed_process_status_available) {
	mmux_libc_dprintfou("%s: child process completion status: %d\n", PROGNAME, completed_process_status);
	if (mmux_libc_pid_equal(completed_process_pid, child_pid)) {
	  if (mmux_libc_WIFEXITED(completed_process_status)) {
	    mmux_libc_exit_success();
	  } else {
	    print_error("child process not exited normally");
	    mmux_libc_exit_failure();
	  }
	} else {
	  print_error("unexpected completed process PID\n");
	  mmux_libc_exit_failure();
	}
      } else {
	mmux_libc_dprintfou("%s: no complete child process status\n", PROGNAME, completed_process_status);
	mmux_libc_exit_failure();
      }
    }
  } else {
    mmux_libc_dprintfou("%s: child process: exiting\n", PROGNAME);
    mmux_libc_exit_success();
  }

 error:
  {
    mmux_sint_t         errnum;
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
