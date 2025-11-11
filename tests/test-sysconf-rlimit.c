/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 14, 2025

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
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-sysconf-rlimit";
  }

  /* struct mmux_libc_rlimit_t */
  {
    auto	cur = mmux_libc_rlim_literal(12);
    auto	max = mmux_libc_rlim_literal(34);
    mmux_libc_rlimit_t	RL[1];

    mmux_libc_rlim_cur_set(RL, cur);
    mmux_libc_rlim_max_set(RL, max);
    {
      mmux_libc_oufd_t	er;

      if (mmux_libc_dprintfer("setter/getter ")) {
	handle_error();
      }
      mmux_libc_stder(er);
      if (mmux_libc_rlimit_dump(er, RL, NULL)) {
	handle_error();
      }
    }

    {
      mmux_libc_rlim_t	cur1, max1;

      mmux_libc_rlim_cur_ref(&cur1, RL);
      mmux_libc_rlim_max_ref(&max1, RL);
      assert(mmux_ctype_equal(cur1, cur));
      assert(mmux_ctype_equal(max1, max));
    }
  }

  /* struct mmux_libc_rlimit_t */
  {
    auto	cur = mmux_libc_rlim_literal(12);
    auto	max = MMUX_LIBC_RLIM_INFINITY;
    mmux_libc_rlimit_t	RL[1];

    mmux_libc_rlimit_set(RL, cur, max);
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_rlimit_dump(er, RL, NULL)) {
	handle_error();
      }
    }
  }

  /* mmux_libc_getrlimit() */
  {
    mmux_libc_rlimit_t	RL[1];

    if (mmux_libc_getrlimit(RL, MMUX_LIBC_RLIMIT_FSIZE))  {
      handle_error();
    }
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_dprintfer("getrlimit ")) {
	handle_error();
      }
      if (mmux_libc_rlimit_dump(er, RL, NULL)) {
	handle_error();
      }
    }
  }

  /* mmux_libc_setrlimit() */
  {
    auto	cur = mmux_libc_rlim_literal(120000);
    auto	max = mmux_libc_rlim_literal(340000);
    mmux_libc_rlimit_t	RL[1];

    mmux_libc_rlimit_set(RL, cur, max);
    if (mmux_libc_setrlimit(MMUX_LIBC_RLIMIT_FSIZE, RL))  {
      handle_error();
    }
    if (mmux_libc_getrlimit(RL, MMUX_LIBC_RLIMIT_FSIZE))  {
      handle_error();
    }
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_dprintfer("setrlimit ")) {
	handle_error();
      }
      if (mmux_libc_rlimit_dump(er, RL, NULL)) {
	handle_error();
      }
    }
  }

  /* mmux_libc_prlimit() */
  {
    /* setting and getting */
    {
      auto	cur = mmux_libc_rlim_literal(1000000);
      auto	max = mmux_libc_rlim_literal(1100000);
      mmux_libc_rlimit_t	old_RL[1], new_RL[1];
      mmux_libc_pid_t	pid;

      mmux_libc_getpid(&pid);
      mmux_libc_rlimit_set(new_RL, cur, max);
      if (mmux_libc_prlimit(old_RL, pid, MMUX_LIBC_RLIMIT_STACK, new_RL))  {
	handle_error();
      }
      {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_dprintfer("prlimit ")) {
	  handle_error();
	}
	if (mmux_libc_rlimit_dump(er, old_RL, NULL)) {
	  handle_error();
	}
      }
    }

    /* only getting */
    {
      mmux_libc_rlimit_t	old_RL[1];
      mmux_libc_pid_t		pid;

      mmux_libc_getpid(&pid);
      if (mmux_libc_prlimit(old_RL, pid, MMUX_LIBC_RLIMIT_STACK, NULL))  {
	handle_error();
      }
      {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_dprintfer("prlimit only getting ")) {
	  handle_error();
	}
	if (mmux_libc_rlimit_dump(er, old_RL, NULL)) {
	  handle_error();
	}
      }
    }

    /* only setting and only getting */
    {
      auto	cur = mmux_libc_rlim_literal(1000000);
      auto	max = mmux_libc_rlim_literal(1100000);
      mmux_libc_rlimit_t	new_RL[1], old_RL[1];
      mmux_libc_pid_t		pid;

      mmux_libc_getpid(&pid);
      mmux_libc_rlimit_set(new_RL, cur, max);
      if (mmux_libc_prlimit(NULL, pid, MMUX_LIBC_RLIMIT_STACK, new_RL))  {
	handle_error();
      }
      if (mmux_libc_prlimit(old_RL, pid, MMUX_LIBC_RLIMIT_STACK, NULL))  {
	handle_error();
      }
      {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_dprintfer("prlimit only setting and only getting ")) {
	  handle_error();
	}
	if (mmux_libc_rlimit_dump(er, old_RL, NULL)) {
	  handle_error();
	}
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
