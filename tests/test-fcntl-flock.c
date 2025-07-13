/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 11, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc.h>
#include <test-common.h>

static mmux_asciizcp_t		pathname_asciiz = "./test-fcntl-flock.ext";


/** --------------------------------------------------------------------
 ** Helpers.
 ** ----------------------------------------------------------------- */

static bool
test_create_data_file (void)
{
  mmux_libc_ptn_t	ptn;

  if (mmux_libc_make_file_system_pathname(&ptn, pathname_asciiz)) {
    handle_error();
  }

  mmux_sint_t const	flags = MMUX_LIBC_O_RDWR | MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL;
  mmux_mode_t const	mode  = MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR;
  mmux_libc_fd_t	fd;

  if (mmux_libc_open(&fd, ptn, flags, mode)) {
    handle_error();
  }

  /* Write data to the source file. */
  {
    mmux_usize_t	nbytes_done;
    //                            01234567890123456789012345678901234567890
    //                            0         1         2         3         4
    mmux_asciizcp_t	bufptr = "0123456789abcdefghilmnopqrstuvz0123456789";
    mmux_usize_t	buflen;

    mmux_libc_strlen(&buflen, bufptr);

    if (mmux_libc_write(&nbytes_done, fd, bufptr, buflen)) {
      handle_error();
    }
    if (nbytes_done != buflen) {
      handle_error();
    }
  }

  if (mmux_libc_close(fd)) {
    handle_error();
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Parent process.
 ** ----------------------------------------------------------------- */

__attribute__((__noreturn__)) static void
play_parent (mmux_libc_pid_t child_pid)
{
  mmux_libc_fd_t	fd;
  bool			the_child_acquired_the_lock;

  /* Open the data file. */
  {
    mmux_libc_ptn_t	ptn;
    mmux_sint_t const	flags = MMUX_LIBC_O_RDWR;
    mmux_mode_t const	mode  = MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR;

    if (mmux_libc_make_file_system_pathname(&ptn, pathname_asciiz)) {
      handle_error();
    }

    printf_message("paren process: open data file: \"%s\"", pathname_asciiz);
    if (mmux_libc_open(&fd, ptn, flags, mode)) {
      print_error("opening data file");
      handle_error();
    }
  }

  printf_message("paren process: give child some time to acquire the lock");
  wait_for_some_time();

  /* Check that the alpha portion of the file is locked. */
  {
    mmux_libc_flock_t	flo;
    mmux_libc_pid_t	pid;

    if (mmux_libc_make_pid_zero(&pid)) {
      handle_error();
    }

    mmux_libc_l_type_set   (&flo, MMUX_LIBC_F_WRLCK);
    mmux_libc_l_whence_set (&flo, MMUX_LIBC_SEEK_SET);
    mmux_libc_l_start_set  (&flo, 11);
    mmux_libc_l_len_set    (&flo, 21);
    mmux_libc_l_pid_set    (&flo, pid);

    printf_message("paren process: check that the alpha portion of the file is locked");
    if (mmux_libc_fcntl(fd, MMUX_LIBC_F_GETLK, &flo)) {
      print_error("setting lock with fcntl()");
      handle_error();
    }

    if (1) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(&er);
      if (mmux_libc_flock_dump(er, &flo, "paren struct flock")) {
	handle_error();
      }
    }

    {
      mmux_libc_pid_t	the_pid;

      mmux_libc_l_pid_ref(&the_pid, &flo);
      if (mmux_libc_pid_equal(the_pid, child_pid)) {
	printf_message("paren process: the child acquired the lock");
	the_child_acquired_the_lock = true;
      } else {
	printf_message("paren process: something acquired the lock");
	the_child_acquired_the_lock = false;
      }
    }
  }

  printf_message("paren process: close the file");
  if (mmux_libc_close(fd)) {
    handle_error();
  }

  /* Send a signal to the child process, so it will exit. */
  {
    mmux_libc_interprocess_signal_t         ipxsignal;

    mmux_libc_make_interprocess_signal(&ipxsignal, MMUX_LIBC_SIGUSR1);
    printf_message("paren process: delivering SIGUSR1 to child process");
    if (mmux_libc_kill(child_pid, ipxsignal)) {
      handle_error();
    }
  }

  /* Wait for child process completion. */
  {
    bool					completed_process_status_available;
    mmux_libc_pid_t				completed_process_pid;
    mmux_libc_completed_process_status_t	completed_process_status;
    mmux_sint_t					process_wait_flags = 0;

    printf_message("paren process: waiting for child process completion");
    if (mmux_libc_wait_process_id(&completed_process_status_available, &completed_process_pid,
				  &completed_process_status, child_pid, process_wait_flags)) {
      print_error("paren process: waiting for process completion");
      handle_error();
    } else if (completed_process_status_available) {
      bool	child_process_has_exited;

      printf_message("paren process: child process completion status: %d", completed_process_status.value);

      mmux_libc_WIFEXITED(&child_process_has_exited, completed_process_status);
      if (child_process_has_exited) {
	mmux_sint_t	child_process_exit_status;

	mmux_libc_WEXITSTATUS(&child_process_exit_status, completed_process_status);
	printf_message("paren process: child process has exited with status: %d", child_process_exit_status);

	if (the_child_acquired_the_lock) {
	  mmux_libc_exit_success();
	} else {
	  mmux_libc_exit_failure();
	}
      } else {
	printf_message("paren process: child process has not exited, it was terminated in some other way");
	mmux_libc_exit_failure();
      }
    } else {
      print_error("no complete child process status");
      mmux_libc_exit_failure();
    }
  }
}


/** --------------------------------------------------------------------
 ** Child process.
 ** ----------------------------------------------------------------- */

static void
child_process_signal_handler (mmux_sint_t signum MMUX_CC_LIBC_UNUSED)
{
  return;
}

__attribute__((__noreturn__)) static void
play_child (void)
{
  mmux_libc_ptn_t	ptn;
  mmux_libc_fd_t	fd;

  if (mmux_libc_make_file_system_pathname(&ptn, pathname_asciiz)) {
    handle_error();
  }

  /* Open the data file. */
  {
    mmux_sint_t const	flags = MMUX_LIBC_O_RDWR;
    mmux_mode_t const	mode  = MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR;

    printf_message("child process: open data file: \"%s\"", pathname_asciiz);
    if (mmux_libc_open(&fd, ptn, flags, mode)) {
      print_error("opening data file");
      handle_error();
    }
  }

  /* Lock the alpha portion of the file. */
  {
    mmux_libc_flock_t	flo;
    mmux_libc_pid_t	pid;

    if (mmux_libc_make_pid_zero(&pid)) {
      handle_error();
    }

    mmux_libc_l_type_set   (&flo, MMUX_LIBC_F_WRLCK);
    mmux_libc_l_whence_set (&flo, MMUX_LIBC_SEEK_SET);
    mmux_libc_l_start_set  (&flo, 11);
    mmux_libc_l_len_set    (&flo, 21);
    mmux_libc_l_pid_set    (&flo, pid);

    printf_message("child process: acquire the lock");
    if (mmux_libc_fcntl(fd, MMUX_LIBC_F_SETLK, &flo)) {
      print_error("setting lock with fcntl()");
      handle_error();
    }

    if (1) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(&er);
      if (mmux_libc_flock_dump(er, &flo, "child struct flock")) {
	handle_error();
      }
    }
  }

  /* Register the handler for SIGUSR1. */
  {
    mmux_libc_interprocess_signal_t       ipxsignal;
    mmux_libc_sighandler_t *              the_old_handler;

    mmux_libc_make_interprocess_signal(&ipxsignal, MMUX_LIBC_SIGUSR1);
    printf_message("child process: registering the handler for SIGUSR1");
    if (mmux_libc_signal(&the_old_handler, ipxsignal, child_process_signal_handler)) {
      handle_error();
    }
  }

  /* Pause until the parent sends the child a signal. */
  {
    printf_message("child process: pause until the paren sends a signal");
    mmux_libc_pause();
    printf_message("child process: waking up because signal received");
  }

  printf_message("child process: close the file");
  if (mmux_libc_close(fd)) {
    handle_error();
  }

  printf_message("child process: exit");
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
    PROGNAME = "test-fcntl-flock";
    cleanfiles_register(pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }


  /* Create the data file. */
  {
    printf_message("main  process: create the data file");
    if (test_create_data_file()) {
      handle_error();
    }
  }

  /* Run a child  process.  The child process acquires the  lock.  The parent process
     detects the lock.  The child exits.  The parent exits. */
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
  }
}

/* end of file */
