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
#include <test-common.h>


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

  /* Setting blocking mode for input fd. */
  if (1) {
    mmux_sint_t		parameter;

    printf_message("paren: set blocking mode for input fd");

    /* Acquire current file descriptor flags. */
    if (mmux_libc_fcntl(read_fr_child_fd, MMUX_LIBC_F_GETFL, &parameter)) {
      printf_error("paren: setting blocking mode for input fd: acquiring current flags");
      handle_error();
    }

    /* Null the non-block flag. */
    parameter &= (~ MMUX_LIBC_O_NONBLOCK);

    /* Set the new flags. */
    if (mmux_libc_fcntl(read_fr_child_fd, MMUX_LIBC_F_SETFL, &parameter)) {
      printf_error("paren: setting blocking mode for input fd: setting flags");
      handle_error();
    }
  }

  /* Setup the arguments of "mmux_libc_select()". */
  {
    printf_message("paren: setting up fd sets");

    mmux_libc_FD_ZERO(read_fd_set);
    mmux_libc_FD_ZERO(writ_fd_set);
    mmux_libc_FD_ZERO(exce_fd_set);

    mmux_libc_FD_SET(read_fr_child_fd, read_fd_set);
    mmux_libc_FD_SET(writ_to_child_fd, writ_fd_set);
    mmux_libc_FD_SET(read_fr_child_fd, exce_fd_set);
    mmux_libc_FD_SET(writ_to_child_fd, exce_fd_set);

    mmux_libc_timeval_set(timeout, 10, 0);
  }

  paren_give_child_process_time_to_start();

  printf_message("paren: calling select()");
  if (mmux_libc_select(&nfds_ready, maximum_nfds_to_check,
		       read_fd_set, writ_fd_set, exce_fd_set,
		       timeout)) {
    printf_error("paren: selecting fd events");
    handle_error();
  }

  if (0 == nfds_ready) {
    printf_error("child: no fds ready");
    handle_error();
  } else {
    MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%s: paren: number of ready fds: %d\n", PROGNAME, nfds_ready));
  }

  /* Check that no exceptional event happened. */
  {
    printf_message("paren: checking for no exceptional fd events");

    mmux_libc_FD_ISSET(&isset, read_fr_child_fd, exce_fd_set);
    if (isset) {
      printf_error("paren: unexpected exceptional event on read_fr_child_fd");
      handle_error();
    }
    mmux_libc_FD_ISSET(&isset, writ_to_child_fd, exce_fd_set);
    if (isset) {
      printf_error("paren: unexpected exceptional event on writ_to_child_fd");
      handle_error();
    }
  }

  /* Check for a read event on the "read_fr_child_fd". */
  {
    mmux_usize_t	nbytes_done;
    mmux_usize_t	buflen = 4096;
    mmux_uint8_t	bufptr[buflen];

    mmux_libc_memzero(bufptr, buflen);

    printf_message("paren: checking for read fd event");

    mmux_libc_FD_ISSET(&isset, read_fr_child_fd, read_fd_set);
    if (! isset) {
      printf_error("paren: expected read event on read_fr_child_fd");
      mmux_libc_errno_set(1);
      handle_error();
    } else if (mmux_libc_read(&nbytes_done, read_fr_child_fd, bufptr, buflen)) {
      printf_error("paren: reading from read_fr_child_fd");
      handle_error();
    } else {
      MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%s: paren: received greetings from child: \"", PROGNAME));
      if (mmux_libc_write_buffer_to_stder(bufptr, buflen)) {
	handle_error();
      }
      MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("\"\n"));

      {
	mmux_sint_t	result;
	mmux_asciizcp_t	expected_greetings = "hello parent\n";
	mmux_usize_t	expected_greetings_len;

	mmux_libc_strlen(&expected_greetings_len, expected_greetings);

	mmux_libc_strncmp(&result, expected_greetings, (mmux_asciizcp_t)bufptr, expected_greetings_len);
	if (0 != result) {
	  printf_error("paren: wrong greetings string from child");
	  handle_error();
	}
      }
    }
  }

  printf_message("paren: sending greetings to child");
  if (mmux_libc_dprintf(writ_to_child_fd, "hello child\n")) {
    printf_error("paren: greetings to child");
    handle_error();
  }

  paren_give_child_process_time_to_exit();

  printf_message("paren: closing file descriptors");
  {
    if (mmux_libc_close(read_fr_child_fd)) {
      printf_error("paren: closing read_fr_child_fd");
      handle_error();
    }

    if (mmux_libc_close(writ_to_child_fd)) {
      printf_error("paren: closing writ_to_child_fd");
      handle_error();
    }
  }

  paren_wait_for_child_process_completion(child_pid);
}
void
paren_give_child_process_time_to_start (void)
{
  printf_message("paren: give child time to start");
  wait_for_some_time();
}
void
paren_give_child_process_time_to_exit (void)
{
  printf_message("paren: give child time to exit");
  wait_for_some_time();
}
void
paren_wait_for_child_process_completion (mmux_libc_pid_t child_pid)
{
  bool					completed_process_status_available;
  mmux_libc_pid_t			completed_process_pid;
  mmux_libc_completed_process_status_t	completed_process_status;

  printf_message("paren: wait child process completion");

  if (mmux_libc_wait_process_id(&completed_process_status_available, &completed_process_pid,
				&completed_process_status, child_pid, MMUX_LIBC_WNOHANG)) {
    printf_error("paren: waiting");
    handle_error();
  } else {
    if (completed_process_status_available) {
      bool	has_exited;

      if (mmux_libc_WIFEXITED(&has_exited, completed_process_status)) {
	handle_error();
      } else if (has_exited) {
	mmux_sint_t	exit_status;

	if (mmux_libc_WEXITSTATUS(&exit_status, completed_process_status)) {
	  handle_error();
	} else if (MMUX_LIBC_EXIT_SUCCESS == exit_status) {
	  mmux_libc_exit_success();
	} else {
	  printf_error("paren: child process exited unsuccessfully");
	  handle_error();
	}
      } else {
	printf_error("paren: child process not exited");
	handle_error();
      }
    } else {
      printf_error("paren: no complete child process status");
      handle_error();
    }
  }
}


/** --------------------------------------------------------------------
 ** Child stuff.
 ** ----------------------------------------------------------------- */

static void child_play (mmux_libc_fd_t read_fr_paren_fd, mmux_libc_fd_t writ_to_paren_fd);
static void child_give_paren_process_time_to_start (void);
static void child_give_paren_process_time_to_reply (void);

void
child_play (mmux_libc_fd_t read_fr_paren_fd, mmux_libc_fd_t writ_to_paren_fd)
{
  mmux_libc_fd_t	in, ou;

  /* Replace the stdin file descriptor with "read_fr_paren_fd". */
  if (1) {
    printf_message("child: making the pipe input fd into stdin");

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
  }

  /* Replace the stdout file descriptor with "writ_to_paren_fd". */
  if (1) {
    printf_message("child: making the pipe output fd into stdout");

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
  }

  /* Setting blocking mode for input fd. */
  if (1) {
    mmux_sint_t		parameter;

    printf_message("child: set blocking mode for input fd");

    /* Acquire current file descriptor flags. */
    if (mmux_libc_fcntl(in, MMUX_LIBC_F_GETFL, &parameter)) {
      printf_error("child: setting blocking mode for input fd: acquiring current flags");
      handle_error();
    }

    /* Null the non-block flag. */
    parameter &= (~ MMUX_LIBC_O_NONBLOCK);

    /* Set the new flags. */
    if (mmux_libc_fcntl(in, MMUX_LIBC_F_SETFL, &parameter)) {
      printf_error("child: setting blocking mode for input fd: setting flags");
      handle_error();
    }
  }

  if (0) {
    child_give_paren_process_time_to_start();
  }

  /* Send greetings to parent. */
  {
    printf_message("child: sending greetings to parent: \"hello parent\n\"");
    if (mmux_libc_dprintfou("hello parent\n")) {
      printf_error("child: sending greetings to parent");
      handle_error();
    }
  }

  child_give_paren_process_time_to_reply();

  /* Read parent's reply. */
  {
    mmux_libc_fd_set_t      read_fd_set[1], writ_fd_set[1], exce_fd_set[1];
    mmux_uint_t             nfds_ready;
    mmux_uint_t             maximum_nfds_to_check = MMUX_LIBC_FD_SETSIZE;
    mmux_libc_timeval_t     timeout[1];
    bool                    isset;

    /* Setup the arguments of "mmux_libc_select()". */
    {
      printf_message("child: setting up fd sets");

      mmux_libc_FD_ZERO(read_fd_set);
      mmux_libc_FD_ZERO(writ_fd_set);
      mmux_libc_FD_ZERO(exce_fd_set);

      mmux_libc_FD_SET(in, read_fd_set);
      if (0) {
	/* We do not register  "ou" to be checked for writing: it  would be ready for
	   writing immediately,  unblocking "select()".  We want  "select()" to block
	   until a read event is ready. */
	mmux_libc_FD_SET(ou, writ_fd_set);
      }
      mmux_libc_FD_SET(in, exce_fd_set);
      mmux_libc_FD_SET(ou, exce_fd_set);

      mmux_libc_timeval_set(timeout, 10, 0);
    }

    printf_message("child: calling select()");
    if (mmux_libc_select(&nfds_ready, maximum_nfds_to_check,
			 read_fd_set, writ_fd_set, exce_fd_set,
			 timeout)) {
      printf_error("child: selecting fd events");
      handle_error();
    }

    if (0 == nfds_ready) {
      printf_error("child: no fds ready");
      handle_error();
    } else {
      MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%s: child: number of ready fds: %d\n", PROGNAME, nfds_ready));
    }

    /* Check that no exceptional event happened. */
    {
      printf_message("child: checking for no exceptional fd events");

      mmux_libc_FD_ISSET(&isset, in, exce_fd_set);
      if (isset) {
	printf_error("child: unexpected exceptional event on read_fr_paren_fd");
	handle_error();
      }
      mmux_libc_FD_ISSET(&isset, ou, exce_fd_set);
      if (isset) {
	printf_error("child: unexpected exceptional event on writ_to_paren_fd");
	handle_error();
      }
    }

    /* Check for a read event on the "read_fr_paren_fd". */
    printf_message("child: checking for read fd event");
    mmux_libc_FD_ISSET(&isset, in, read_fd_set);
    if (! isset) {
      printf_error("child: expected read event on read_fr_paren_fd");
      mmux_libc_errno_set(1);
      handle_error();
    } else {
      mmux_usize_t	nbytes_done;
      mmux_usize_t	buflen = 4096;
      mmux_uint8_t	bufptr[buflen];

      mmux_libc_memzero(bufptr, buflen);

      printf_message("child: reading from parent");

      if (mmux_libc_read(&nbytes_done, in, bufptr, buflen)) {
	printf_error("child: reading from read_fr_paren_fd");
	handle_error();
      } else {
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%s: child: received greetings from paren: \"", PROGNAME));
	if (mmux_libc_write_buffer_to_stder(bufptr, buflen)) {
	  handle_error();
	}
	MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("\"\n"));

	{
	  mmux_sint_t		result;
	  mmux_asciizcp_t	expected_greetings = "hello child\n";
	  mmux_usize_t		expected_greetings_len;

	  mmux_libc_strlen(&expected_greetings_len, expected_greetings);

	  mmux_libc_strncmp(&result, expected_greetings, (mmux_asciizcp_t)bufptr, expected_greetings_len);
	  if (0 != result) {
	    printf_error("child: wrong greetings string from child");
	    handle_error();
	  }
	}
      }
    }
  }

  mmux_libc_exit_success();
}
void
child_give_paren_process_time_to_start (void)
{
  printf_message("child: give paren process time to start");
  wait_for_some_time();
}
void
child_give_paren_process_time_to_reply (void)
{
  printf_message("child: give paren process time to reply");
  wait_for_some_time();
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
    PROGNAME = "test-select";
  }

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
      printf_error("forking");
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
