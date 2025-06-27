/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jun 25, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc.h>

static mmux_asciizcp_t	PROGNAME = "mmux_libc_fork";

static void
print_error (mmux_asciizcp_t errmsg)
{
  mmux_libc_dprintfer("%s: error: %s\n", PROGNAME, errmsg);
}
static void
handle_error (void)
{
  mmux_sint_t		errnum;
  mmux_asciizcp_t	errmsg;

  mmux_libc_errno_consume(&errnum);
  if (errnum) {
    if (mmux_libc_strerror(&errmsg, errnum)) {
      mmux_libc_exit_failure();
    } else {
      print_error(errmsg);
    }
  }
  mmux_libc_exit_failure();
}
static void
wait_for_some_time (void)
{
  mmux_libc_timespec_t    requested_time;
  mmux_libc_timespec_t    remaining_time;

  mmux_libc_timespec_set(&requested_time, 0, 5000000);
  if (mmux_libc_nanosleep(&requested_time, &remaining_time)) {
    print_error("nanosleep");
    handle_error();
  }
}


/** --------------------------------------------------------------------
 ** Parent stuff.
 ** ----------------------------------------------------------------- */

static void paren_play (mmux_libc_fd_t read_fr_child_fd, mmux_libc_fd_t writ_to_child_fd, mmux_libc_pid_t child_pid);
static void paren_wait_for_child_process_completion (mmux_libc_pid_t child_pid);
static void paren_give_child_process_time_to_start (void);
static void paren_give_child_process_time_to_exit (void);

void
paren_play (mmux_libc_fd_t read_fr_child_fd, mmux_libc_fd_t writ_to_child_fd, mmux_libc_pid_t child_pid)
/* We expect the child to greet the parent first, then the parent replies. */
{
  mmux_libc_fd_set_t      read_fd_set[1], writ_fd_set[1], exce_fd_set[1];
  mmux_uint_t             nfds_ready;
  mmux_uint_t             maximum_nfds_to_check = MMUX_LIBC_FD_SETSIZE;
  mmux_libc_timeval_t     timeout[1];
  bool                    isset;

  paren_give_child_process_time_to_start();

  /* Setup the arguments of "mmux_libc_select()". */
  {
    mmux_libc_FD_ZERO(read_fd_set);
    mmux_libc_FD_ZERO(writ_fd_set);
    mmux_libc_FD_ZERO(exce_fd_set);

    mmux_libc_FD_SET(read_fr_child_fd, read_fd_set);
    mmux_libc_FD_SET(writ_to_child_fd, writ_fd_set);
    mmux_libc_FD_SET(read_fr_child_fd, exce_fd_set);
    mmux_libc_FD_SET(writ_to_child_fd, exce_fd_set);

    mmux_libc_timeval_set(timeout, 1, 0);
  }

  if (mmux_libc_select(&nfds_ready, maximum_nfds_to_check,
		       read_fd_set, writ_fd_set, exce_fd_set,
		       timeout)) {
    print_error("parent: selecting fd events");
    handle_error();
  }

  /* Check that no exceptional event happened. */
  {
    mmux_libc_FD_ISSET(&isset, read_fr_child_fd, exce_fd_set);
    if (isset) {
      print_error("parent: unexpected exceptional event on read_fr_child_fd");
      handle_error();
    }
    mmux_libc_FD_ISSET(&isset, writ_to_child_fd, exce_fd_set);
    if (isset) {
      print_error("parent: unexpected exceptional event on writ_to_child_fd");
      handle_error();
    }
  }

  /* Check for a read event on the "read_fr_child_fd". */
  {
    mmux_usize_t	nbytes_done;
    mmux_usize_t	buflen = 4096;
    mmux_uint8_t	bufptr[buflen];

    mmux_libc_dprintfer("parent: reading from child\n");
    mmux_libc_memset(bufptr, buflen, 0);

    mmux_libc_FD_ISSET(&isset, read_fr_child_fd, read_fd_set);
    if (! isset) {
      print_error("parent: expected read event on read_fr_child_fd");
      mmux_libc_errno_set(1);
      handle_error();
    } else if (mmux_libc_read(&nbytes_done, read_fr_child_fd, bufptr, buflen)) {
      print_error("parent: reading from read_fr_child_fd");
      handle_error();
    } else {
      mmux_sint_t	result;
      mmux_asciizcp_t	expected_greetings = "hello parent\n";
      mmux_usize_t	expected_greetings_len;

      mmux_libc_strlen(&expected_greetings_len, expected_greetings);
      mmux_libc_dprintfer("parent: recevied greetings from child: '%s'\n", bufptr);

      mmux_libc_strncmp(&result, expected_greetings, (mmux_asciizcp_t)bufptr, expected_greetings_len);
      if (0 != result) {
	print_error("parent: wrong greetings string from child");
	handle_error();
      }
    }
  }

  if (mmux_libc_dprintf(writ_to_child_fd, "hello child\n")) {
    print_error("parent: greetings to child");
    handle_error();
  }

  if (mmux_libc_close(read_fr_child_fd)) {
    print_error("parent: closing read_fr_child_fd");
    handle_error();
  }

  if (mmux_libc_close(writ_to_child_fd)) {
    print_error("parent: closing writ_to_child_fd");
    handle_error();
  }

  paren_give_child_process_time_to_exit();
  paren_wait_for_child_process_completion(child_pid);
}
void
paren_give_child_process_time_to_start (void)
{
  wait_for_some_time();
}
void
paren_give_child_process_time_to_exit (void)
{
  wait_for_some_time();
}
void
paren_wait_for_child_process_completion (mmux_libc_pid_t child_pid)
{
  bool					completed_process_status_available;
  mmux_libc_pid_t			completed_process_pid;
  mmux_libc_completed_process_status_t	completed_process_status;

  if (mmux_libc_wait_process_id(&completed_process_status_available, &completed_process_pid,
				&completed_process_status, child_pid, MMUX_LIBC_WNOHANG)) {
    print_error("parent: waiting");
    handle_error();
  } else {
    if (completed_process_status_available) {
      if (mmux_libc_WIFEXITED(completed_process_status)) {
	if (MMUX_LIBC_EXIT_SUCCESS == mmux_libc_WEXITSTATUS(completed_process_status)) {
	  mmux_libc_exit_success();
	} else {
	  print_error("parent: child process exited unsuccessfully");
	  handle_error();
	}
      } else {
	print_error("parent: child process not exited");
	handle_error();
      }
    } else {
      print_error("parent: no complete child process status");
      handle_error();
    }
  }
}


/** --------------------------------------------------------------------
 ** Child stuff.
 ** ----------------------------------------------------------------- */

static void child_play (mmux_libc_fd_t read_fr_paren_fd, mmux_libc_fd_t writ_to_paren_fd);
static void child_give_paren_process_time_to_start (void);

void
child_play (mmux_libc_fd_t read_fr_paren_fd, mmux_libc_fd_t writ_to_paren_fd)
{
  /* Replace the stdin file descriptor with "read_fr_paren_fd". */
  if (1) {
    mmux_libc_fd_t	in;

    mmux_libc_stdin(&in);
    if (mmux_libc_close(in)) {
      handle_error();
    }
    if (mmux_libc_dup(&in, read_fr_paren_fd)) {
      handle_error();
    }
    if (mmux_libc_close(read_fr_paren_fd)) {
      handle_error();
    }

    read_fr_paren_fd = in;
    if (1) {
      mmux_libc_dprintfer("child: in.value %d\n", in.value);
    }
  }

  /* Replace the stdout file descriptor with "writ_to_paren_fd". */
  if (1) {
    mmux_libc_fd_t	ou;

    mmux_libc_stdou(&ou);
    if (mmux_libc_close(ou)) {
      handle_error();
    }
    if (mmux_libc_dup(&ou, writ_to_paren_fd)) {
      handle_error();
    }
    if (mmux_libc_close(writ_to_paren_fd)) {
      handle_error();
    }

    writ_to_paren_fd = ou;
    if (1) {
      mmux_libc_dprintfer("child: ou.value %d\n", ou.value);
    }
  }

  /* Send greetings to parent. */
  {
    mmux_libc_dprintfer("child: sending greetings to parent: hello parent\n");
    if (mmux_libc_dprintfou("hello parent\n")) {
      print_error("sending greetings to parent");
      handle_error();
    }
  }

  child_give_paren_process_time_to_start();

  /* Read parent's reply. */
  {
    mmux_libc_fd_set_t      read_fd_set[1], writ_fd_set[1], exce_fd_set[1];
    mmux_uint_t             nfds_ready;
    mmux_uint_t             maximum_nfds_to_check = MMUX_LIBC_FD_SETSIZE;
    mmux_libc_timeval_t     timeout[1];
    bool                    isset;

    /* Setup the arguments of "mmux_libc_select()". */
    {
      mmux_libc_FD_ZERO(read_fd_set);
      mmux_libc_FD_ZERO(writ_fd_set);
      mmux_libc_FD_ZERO(exce_fd_set);

      mmux_libc_dprintfer("child: read_fr_paren.value %d\n", read_fr_paren_fd.value);
      mmux_libc_dprintfer("child: writ_to_paren.value %d\n", writ_to_paren_fd.value);

      mmux_libc_FD_SET(read_fr_paren_fd, read_fd_set);
      mmux_libc_FD_SET(writ_to_paren_fd, writ_fd_set);
      mmux_libc_FD_SET(read_fr_paren_fd, exce_fd_set);
      mmux_libc_FD_SET(writ_to_paren_fd, exce_fd_set);

      mmux_libc_timeval_set(timeout, 1, 0);
    }

    mmux_libc_dprintfer("child: selecting fd events\n");
    if (mmux_libc_select(&nfds_ready, maximum_nfds_to_check,
			 read_fd_set, writ_fd_set, exce_fd_set,
			 timeout)) {
      print_error("child: selecting fd events");
      handle_error();
    }

    /* Check that no exceptional event happened. */
    {
      mmux_libc_FD_ISSET(&isset, read_fr_paren_fd, exce_fd_set);
      if (isset) {
	print_error("child: unexpected exceptional event on read_fr_paren_fd");
	handle_error();
      }
      mmux_libc_FD_ISSET(&isset, writ_to_paren_fd, exce_fd_set);
      if (isset) {
	print_error("child: unexpected exceptional event on writ_to_paren_fd");
	handle_error();
      }
    }

    /* Check for a read event on the "read_fr_paren_fd". */
    mmux_libc_FD_ISSET(&isset, read_fr_paren_fd, read_fd_set);
    if (! isset) {
      print_error("child: expected read event on read_fr_paren_fd");
      mmux_libc_errno_set(1);
      handle_error();
    } else {
      mmux_usize_t	nbytes_done;
      mmux_usize_t	buflen = 4096;
      mmux_uint8_t	bufptr[buflen];

      mmux_libc_dprintfer("child: reading from parent\n");
      mmux_libc_memset(bufptr, buflen, 0);

      if (mmux_libc_read(&nbytes_done, read_fr_paren_fd, bufptr, buflen)) {
	print_error("child: reading from read_fr_paren_fd");
	handle_error();
      } else {
	mmux_sint_t	result;
	mmux_asciizcp_t	expected_greetings = "hello child\n";
	mmux_usize_t	expected_greetings_len;

	mmux_libc_strlen(&expected_greetings_len, expected_greetings);
	mmux_libc_dprintfer("child: received greetings from parent: '%s'\n", bufptr);

	mmux_libc_strncmp(&result, expected_greetings, (mmux_asciizcp_t)bufptr, expected_greetings_len);
	if (0 != result) {
	  print_error("child: wrong greetings string from parent");
	  handle_error();
	}
      }
    }
  }

  mmux_libc_exit_success();
}
void
child_give_paren_process_time_to_start (void)
{
  wait_for_some_time();
}


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  mmux_cc_libc_init();
  {
    bool		this_is_the_paren_process;
    mmux_libc_pid_t	child_pid;
    mmux_libc_fd_t	paren_to_child_fds[2];
    mmux_libc_fd_t	paren_fr_child_fds[2];

    if (mmux_libc_pipe(paren_to_child_fds)) {
      handle_error();
    } else if (mmux_libc_pipe(paren_fr_child_fds)) {
      handle_error();
    } else if (mmux_libc_fork(&this_is_the_paren_process, &child_pid)) {
      print_error("forking");
      handle_error();
    } else if (this_is_the_paren_process) {
      paren_play(paren_fr_child_fds[0], paren_to_child_fds[1], child_pid);
    } else {
      child_play(paren_to_child_fds[0], paren_fr_child_fds[1]);
    }
  }
  /* We shold never get here. */
  mmux_libc_exit_failure();
}

/* end of file */
