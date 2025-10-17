/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jun 23, 2025

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
  bool                    this_is_the_parent_process;
  mmux_libc_pid_t         child_pid;

  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-fork";
  }

  if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
    print_error("forking");
    goto error;
  } else if (this_is_the_parent_process) {
    /* Give the child process a bit of time to exit. */
    wait_for_some_time();

    /* Wait for the completion of the child process. */
    {
      bool						process_completion_status_is_available;
      mmux_libc_pid_t					completed_process_pid;
      mmux_libc_process_completion_status_t		process_completion_status;
      auto	waiting_options = mmux_libc_process_completion_waiting_options(MMUX_LIBC_WNOHANG);

      if (mmux_libc_wait_process_id(&process_completion_status_is_available,
				    &process_completion_status, &completed_process_pid,
				    child_pid, waiting_options)) {
	print_error("waiting");
	goto error;
      } else {
	if (process_completion_status_is_available) {
	  if (mmux_libc_dprintfer("%s: child process completion status: %d\n",
				  PROGNAME, process_completion_status.value)) {;};
	  mmux_libc_exit_success();
	} else {
	  if (mmux_libc_dprintfer("%s: no complete child process status\n", PROGNAME)) {;};
	  mmux_libc_exit_failure();
	}
      }
    }
  } else {
    if (mmux_libc_dprintfer("%s: child process: exiting\n", PROGNAME)) {;};
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
