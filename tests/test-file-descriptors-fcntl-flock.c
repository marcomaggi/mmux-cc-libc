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

#include <test-common.h>

static mmux_asciizcp_t	pathname_asciiz = "./test-fcntl-flock.ext";


/** --------------------------------------------------------------------
 ** Parent process.
 ** ----------------------------------------------------------------- */

__attribute__((__noreturn__)) static void
play_parent (mmux_libc_pid_t child_pid)
{
  mmux_libc_fd_t	fd;
  bool			the_child_acquired_the_lock;

  /* Obtain the file descriptor. */
  {
    mmux_libc_fs_ptn_t	fs_ptn;

    /* Build the file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, pathname_asciiz)) {
	handle_error();
      }
    }

    /* Open the data file. */
    {
      auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR);
      auto	mode  = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR);

      printf_message("paren process: open data file: \"%s\"", pathname_asciiz);
      if (mmux_libc_open(fd, fs_ptn, flags, mode)) {
	print_error("opening data file");
	handle_error();
      }
    }

    /* Local cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn);
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
    mmux_libc_l_start_set  (&flo, mmux_off_literal(11));
    mmux_libc_l_len_set    (&flo, mmux_off_literal(21));
    mmux_libc_l_pid_set    (&flo, pid);

    if (true) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_flock_dump(er, &flo, "paren struct flock before requesting lock status")) {
	handle_error();
      }
    }

    printf_message("paren process: check that the alpha portion of the file is locked");
    if (mmux_libc_fcntl(fd, MMUX_LIBC_F_GETLK, &flo)) {
      print_error("setting lock with fcntl()");
      handle_error();
    }

    if (true) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_flock_dump(er, &flo, "paren struct flock after requesting lock status")) {
	handle_error();
      }
    }

    /* Check if something acquired the lock. */
    {
      mmux_libc_file_lock_type_t	l_type;

      mmux_libc_l_type_ref(&l_type, &flo);
      if (l_type.value != MMUX_LIBC_F_UNLCK.value) {
	printf_message("paren process: something acquired the lock, as expected");
	{
	  mmux_libc_pid_t	the_pid;

	  mmux_libc_l_pid_ref(&the_pid, &flo);
	  if (mmux_libc_pid_equal(the_pid, child_pid)) {
	    printf_message("paren process: the child acquired the lock");
	    the_child_acquired_the_lock = true;
	  } else {
	    printf_error("paren process: something acquired the lock, but NOT THE CHILD PROCESS");
	    the_child_acquired_the_lock = false;
	  }
	}
      } else {
	printf_error("paren process: nobody acquired the lock, NOT expected");
	the_child_acquired_the_lock = false;
      }
    }
  }

  /* Final cleanup. */
  {
    printf_message("paren process: close the file");
    if (mmux_libc_close(fd)) {
      handle_error();
    }
  }

  /* Send a signal to the child process, so it will exit. */
  {
    auto	ipxsignal = MMUX_LIBC_SIGUSR1;

    printf_message("paren process: delivering SIGUSR1 to child process");
    if (mmux_libc_kill(child_pid, ipxsignal)) {
      handle_error();
    }
  }

  /* Wait for child process completion. */
  {
    bool					process_completion_status_is_available;
    mmux_libc_process_completion_status_t	process_completion_status;
    mmux_libc_pid_t				completed_process_pid;
    auto	waiting_options = mmux_libc_process_completion_waiting_options(0);

    printf_message("paren process: waiting for child process completion");
    if (mmux_libc_wait_process_id(&process_completion_status_is_available,
				  &process_completion_status,
				  &completed_process_pid,
				  child_pid, waiting_options)) {
      print_error("paren process: waiting for process completion");
      handle_error();
    } else if (process_completion_status_is_available) {
      bool	child_process_has_exited;

      printf_message("paren process: child process completion status: %d", process_completion_status.value);

      mmux_libc_WIFEXITED(&child_process_has_exited, process_completion_status);
      if (child_process_has_exited) {
	mmux_sint_t	child_process_exit_status;

	mmux_libc_WEXITSTATUS(&child_process_exit_status, process_completion_status);
	printf_message("paren process: child process has exited with status: %d", child_process_exit_status.value);

	if (the_child_acquired_the_lock) {
	  printf_message("paren process: child process successfully acquired the lock");
	  printf_message("paren process: exit successfully");
	  mmux_libc_exit_success();
	} else {
	  printf_error("paren process: child process did NOT acquire the lock");
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
child_process_signal_handler (mmux_standard_sint_t signum MMUX_CC_LIBC_UNUSED)
{
  return;
}

__attribute__((__noreturn__)) static void
play_child (void)
{
  mmux_libc_fd_t	fd;

  /* Obtain the file descriptor. */
  {
    mmux_libc_fs_ptn_t	fs_ptn;

    /* Build the file system pathname. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, pathname_asciiz)) {
	handle_error();
      }
    }

    /* Open the data file. */
    {
      auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR);
      auto	mode  = mmux_libc_mode_constant_zero();

      printf_message("child process: open data file: \"%s\"", pathname_asciiz);
      if (mmux_libc_open(fd, fs_ptn, flags, mode)) {
	print_error("opening data file");
	handle_error();
      }
    }

    /* Local cleanup. */
    {
      mmux_libc_unmake_file_system_pathname(fs_ptn);
    }
  }

  /* Lock the alpha portion of the file with a write lock. */
  {
    mmux_libc_flock_t	flo;
    mmux_libc_pid_t	pid;

    /* When requesting to set  a write lock: we set the  field "l_type" to "F_WRLCK";
       the field "l_pid" is unused, so we just set it to zero. */
    if (mmux_libc_make_pid_zero(&pid)) {
      handle_error();
    }

    mmux_libc_l_type_set   (&flo, MMUX_LIBC_F_WRLCK);
    mmux_libc_l_whence_set (&flo, MMUX_LIBC_SEEK_SET);
    mmux_libc_l_start_set  (&flo, mmux_off_literal(11));
    mmux_libc_l_len_set    (&flo, mmux_off_literal(21));
    mmux_libc_l_pid_set    (&flo, pid);

    if (true) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_flock_dump(er, &flo, "child struct flock to request lock")) {
	handle_error();
      }
    }

    printf_message("child process: acquire the lock");
    if (mmux_libc_fcntl(fd, MMUX_LIBC_F_SETLK, &flo)) {
      print_error("setting lock with fcntl()");
      handle_error();
    }

    if (true) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_flock_dump(er, &flo, "child struct flock after request lock")) {
	handle_error();
      }
    }
  }

  /* Register the handler for SIGUSR1. */
  {
    auto			ipxsignal = MMUX_LIBC_SIGUSR1;
    mmux_libc_sighandler_t *	the_old_handler;

    printf_message("child process: registering the handler for SIGUSR1");
    if (mmux_libc_signal(&the_old_handler, ipxsignal, child_process_signal_handler)) {
      handle_error();
    }
  }

  /* Pause until the parent sends the child a signal. */
  {
    printf_message("child process: pause until the paren sends a signal");
    MMUX_LIBC_IGNORE_RETVAL(mmux_libc_pause());
    printf_message("child process: waking up because signal received");
  }

  /* Final cleanup. */
  {
    printf_message("child process: close the file");
    if (mmux_libc_close(fd)) {
      handle_error();
    }
  }

  printf_message("child process: exit successfully");
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
    if (test_create_data_file(pathname_asciiz)) {
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
