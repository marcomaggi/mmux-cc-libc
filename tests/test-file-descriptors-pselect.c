/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 16, 2025

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
  mmux_libc_fd_set_t	read_fd_set, writ_fd_set, exce_fd_set;
  mmux_uint_t		nfds_ready;
  auto			maximum_nfds_to_check = MMUX_LIBC_FD_SETSIZE;
  mmux_libc_timespec_t	timeout;
  bool			isset;

  /* Setting blocking mode for input fd. */
  if (true) {
    mmux_sint_t		parameter;

    printf_message("paren: set blocking mode for input fd");

    /* Acquire current file descriptor flags. */
    if (mmux_libc_fcntl(read_fr_child_fd, MMUX_LIBC_F_GETFL, &parameter)) {
      printf_error("paren: setting blocking mode for input fd: acquiring current flags");
      handle_error();
    }

    /* Null the non-block flag. */
    parameter.value &= (~ MMUX_LIBC_O_NONBLOCK);

    /* Set the new flags. */
    if (mmux_libc_fcntl(read_fr_child_fd, MMUX_LIBC_F_SETFL, &parameter)) {
      printf_error("paren: setting blocking mode for input fd: setting flags");
      handle_error();
    }
  }

  /* Setup the arguments of "mmux_libc_pselect()". */
  {
    printf_message("paren: setting up fd sets");

    mmux_libc_FD_ZERO(read_fd_set);
    mmux_libc_FD_ZERO(writ_fd_set);
    mmux_libc_FD_ZERO(exce_fd_set);

    mmux_libc_FD_SET(read_fr_child_fd, read_fd_set);
    mmux_libc_FD_SET(writ_to_child_fd, writ_fd_set);
    mmux_libc_FD_SET(read_fr_child_fd, exce_fd_set);
    mmux_libc_FD_SET(writ_to_child_fd, exce_fd_set);

    mmux_libc_timespec_set(timeout, mmux_time(10), mmux_slong_literal(0));
  }

  paren_give_child_process_time_to_start();

  printf_message("paren: calling pselect()");
  if (mmux_libc_pselect(&nfds_ready, maximum_nfds_to_check,
			read_fd_set, writ_fd_set, exce_fd_set,
			timeout, NULL)) {
    printf_error("paren: selecting fd events");
    handle_error();
  }

  if (mmux_ctype_is_zero(nfds_ready)) {
    printf_error("child: no fds ready");
    handle_error();
  } else {
    MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%s: paren: number of ready fds: %d\n", PROGNAME, nfds_ready.value));
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
    mmux_usize_t		nbytes_done;
    auto			buflen = mmux_usize_literal(4096);
    mmux_standard_octet_t	bufptr[buflen.value];

    mmux_libc_memzero(bufptr, buflen);

    printf_message("paren: checking for read fd event");

    mmux_libc_FD_ISSET(&isset, read_fr_child_fd, read_fd_set);
    if (! isset) {
      printf_error("paren: expected read event on read_fr_child_fd");
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
	mmux_ternary_comparison_result_t	cmpnum;
	mmux_asciizcp_t	expected_greetings = "hello parent\n";
	mmux_usize_t	expected_greetings_len;

	mmux_libc_strlen(&expected_greetings_len, expected_greetings);

	mmux_libc_strncmp(&cmpnum, expected_greetings, (mmux_asciizcp_t)bufptr, expected_greetings_len);
	if (mmux_ternary_comparison_result_is_not_equal(cmpnum)) {
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
  bool					process_completion_status_is_available;
  mmux_libc_process_completion_status_t	process_completion_status;
  mmux_libc_pid_t			completed_process_pid;
  auto	waiting_options = mmux_libc_process_completion_waiting_options(0);

  printf_message("paren: wait child process completion");

  if (mmux_libc_wait_process_id(&process_completion_status_is_available,
				&process_completion_status,
				&completed_process_pid,
				child_pid, waiting_options)) {
    printf_error("paren: waiting");
    handle_error();
  } else {
    if (process_completion_status_is_available) {
      bool	has_exited;

      if (mmux_libc_WIFEXITED(&has_exited, process_completion_status)) {
	handle_error();
      } else if (has_exited) {
	mmux_libc_process_exit_status_t		exit_status;

	if (mmux_libc_WEXITSTATUS(&exit_status, process_completion_status)) {
	  handle_error();
	} else if (MMUX_LIBC_EXIT_SUCCESS.value == exit_status.value) {
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
  mmux_libc_infd_t	in;
  mmux_libc_oufd_t	ou;

  /* Replace the stdin file descriptor with "read_fr_paren_fd". */
  if (true) {
    printf_message("child: making the pipe input fd into stdin");

    mmux_libc_stdin(in);
    if (mmux_libc_close(in)) {
      handle_error();
    }
    if (mmux_libc_dup(in, read_fr_paren_fd)) {
      handle_error();
    }
    if (mmux_libc_close(read_fr_paren_fd)) {
      handle_error();
    }
  }

  /* Replace the stdout file descriptor with "writ_to_paren_fd". */
  if (true) {
    printf_message("child: making the pipe output fd into stdout");

    mmux_libc_stdou(ou);
    if (mmux_libc_close(ou)) {
      handle_error();
    }
    if (mmux_libc_dup(ou, writ_to_paren_fd)) {
      handle_error();
    }
    if (mmux_libc_close(writ_to_paren_fd)) {
      handle_error();
    }
  }

  /* Setting blocking mode for input fd. */
  if (true) {
    mmux_sint_t		parameter;

    printf_message("child: set blocking mode for input fd");

    /* Acquire current file descriptor flags. */
    if (mmux_libc_fcntl(in, MMUX_LIBC_F_GETFL, &parameter)) {
      printf_error("child: setting blocking mode for input fd: acquiring current flags");
      handle_error();
    }

    /* Null the non-block flag. */
    parameter.value &= (~ MMUX_LIBC_O_NONBLOCK);

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
    mmux_libc_fd_set_t		read_fd_set, writ_fd_set, exce_fd_set;
    mmux_uint_t			nfds_ready;
    auto			maximum_nfds_to_check = MMUX_LIBC_FD_SETSIZE;
    mmux_libc_timespec_t	timeout;
    bool			isset;

    /* Setup the arguments of "mmux_libc_pselect()". */
    {
      printf_message("child: setting up fd sets");

      mmux_libc_FD_ZERO(read_fd_set);
      mmux_libc_FD_ZERO(writ_fd_set);
      mmux_libc_FD_ZERO(exce_fd_set);

      mmux_libc_FD_SET(in, read_fd_set);
      if (0) {
	/* We do not register  "ou" to be checked for writing: it  would be ready for
	   writing immediately, unblocking "pselect()".  We want "pselect()" to block
	   until a read event is ready. */
	mmux_libc_FD_SET(ou, writ_fd_set);
      }
      mmux_libc_FD_SET(in, exce_fd_set);
      mmux_libc_FD_SET(ou, exce_fd_set);

      mmux_libc_timespec_set(timeout, mmux_time_literal(10), mmux_slong_literal(0));
    }

    printf_message("child: calling pselect()");
    if (mmux_libc_pselect(&nfds_ready, maximum_nfds_to_check,
			  read_fd_set, writ_fd_set, exce_fd_set,
			  timeout, NULL)) {
      printf_error("child: selecting fd events");
      handle_error();
    }

    if (mmux_ctype_is_zero(nfds_ready)) {
      printf_error("child: no fds ready");
      handle_error();
    } else {
      MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%s: child: number of ready fds: %d\n", PROGNAME, nfds_ready.value));
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
      handle_error();
    } else {
      mmux_usize_t		nbytes_done;
      auto			buflen = mmux_usize_literal(4096);
      mmux_standard_octet_t	bufptr[buflen.value];

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
	  mmux_ternary_comparison_result_t	cmpnum;
	  mmux_asciizcp_t	expected_greetings = "hello child\n";
	  mmux_usize_t		expected_greetings_len;

	  mmux_libc_strlen(&expected_greetings_len, expected_greetings);

	  mmux_libc_strncmp(&cmpnum, expected_greetings, (mmux_asciizcp_t)bufptr, expected_greetings_len);
	  if (mmux_ternary_comparison_result_is_not_equal(cmpnum)) {
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
    PROGNAME = "test-file-descriptors-pselect";
  }

  {
    mmux_libc_infd_t	read_fr_paren_fd;
    mmux_libc_oufd_t	writ_to_paren_fd;

    mmux_libc_infd_t	read_fr_child_fd;
    mmux_libc_oufd_t	writ_to_child_fd;

    if (mmux_libc_pipe(read_fr_paren_fd, writ_to_child_fd)) {
      handle_error();
    }
    if (mmux_libc_pipe(read_fr_child_fd, writ_to_paren_fd)) {
      handle_error();
    }

    {
      bool		this_is_the_paren_process;
      mmux_libc_pid_t	child_pid;

      printf_message("fork-ing");
      if (mmux_libc_fork(&this_is_the_paren_process, &child_pid)) {
	printf_error("fork-ing");
	handle_error();
      } else if (this_is_the_paren_process) {
	printf_message("running the parent");
	paren_play(read_fr_child_fd, writ_to_child_fd, child_pid);
      } else {
	printf_message("running the child");
	child_play(read_fr_paren_fd, writ_to_paren_fd);
      }
    }
  }

  /* We shold never get here. */
  mmux_libc_exit_failure();
}

/* end of file */
