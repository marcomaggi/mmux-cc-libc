/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 15, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


static void
start_with_an_empty_set (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_libc_sigset_t	ipxsigset;

    printf_message("initialising to empty");
    if (mmux_libc_sigemptyset(ipxsigset)) {
      printf_error("initialising to empty");
      handle_error();
    }

    /* Test for emptyness. */
    {
      bool	is_empty;

      printf_message("testing for emptyness");
      if (mmux_libc_sigisemptyset(&is_empty, ipxsigset)) {
	printf_error("testing for emptyness");
	handle_error();
      } if (is_empty) {
	printf_message("set correctly found as empty");
      } else {
	printf_error("set wrongly found as not empty");
	handle_error();
      }
    }

    printf_message("adding SIGUSR1");
    if (mmux_libc_sigaddset(ipxsigset, MMUX_LIBC_SIGUSR1)) {
      printf_error("adding SIGUSR1");
      handle_error();
    }

    /* Test SIGUSR1 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR1 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR1)) {
	printf_error("testing SIGUSR1 membership");
	handle_error();
      } else if (is_member) {
	printf_message("SIGUSR1 correctly found as member");
      } else {
	printf_error("SIGUSR1 wrongly not found as member");
	handle_error();
      }
    }

    /* Test SIGUSR2 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR2 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR2)) {
	printf_error("testing SIGUSR2 membership");
	handle_error();
      } else if (is_member) {
	printf_error("SIGUSR2 wrongly found as member");
	handle_error();
      } else {
	printf_message("SIGUSR2 correctly not found as member");
      }
    }

    printf_message("removing SIGUSR1");
    if (mmux_libc_sigdelset(ipxsigset, MMUX_LIBC_SIGUSR1)) {
      printf_error("removing SIGUSR1");
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
start_with_a_full_set (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_libc_sigset_t	ipxsigset;

    printf_message("initialising to full");
    if (mmux_libc_sigfillset(ipxsigset)) {
      printf_error("initialising to full");
      handle_error();
    }

    /* Test for emptyness. */
    {
      bool	is_empty;

      printf_message("testing for emptyness");
      if (mmux_libc_sigisemptyset(&is_empty, ipxsigset)) {
	printf_error("testing for emptyness");
	handle_error();
      } if (is_empty) {
	printf_error("set wrongly found as empty");
	handle_error();
      } else {
	printf_message("set correctly found as not empty");
      }
    }

    printf_message("adding SIGUSR1");
    if (mmux_libc_sigaddset(ipxsigset, MMUX_LIBC_SIGUSR1)) {
      printf_error("adding SIGUSR1");
      handle_error();
    }

    /* Test SIGUSR1 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR1 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR1)) {
	printf_error("testing SIGUSR1 membership");
	handle_error();
      } else if (is_member) {
	printf_message("SIGUSR1 correctly found as member");
      } else {
	printf_error("SIGUSR1 wrongly not found as member");
	handle_error();
      }
    }

    /* Test SIGUSR2 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR2 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR2)) {
	printf_error("testing SIGUSR2 membership");
	handle_error();
      } else if (is_member) {
	printf_message("SIGUSR2 correctly found as member");
      } else {
	printf_error("SIGUSR2 wrongly not found as member");
	handle_error();
      }
    }

    printf_message("removing SIGUSR1");
    if (mmux_libc_sigdelset(ipxsigset, MMUX_LIBC_SIGUSR1)) {
      printf_error("removing SIGUSR1");
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
sets_union (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_libc_sigset_t	ipxsigset, ipxsigset1, ipxsigset2;

    if (mmux_libc_sigemptyset(ipxsigset)) {
      handle_error();
    }
    if (mmux_libc_sigemptyset(ipxsigset1)) {
      handle_error();
    }
    if (mmux_libc_sigemptyset(ipxsigset2)) {
      handle_error();
    }

    if (mmux_libc_sigaddset(ipxsigset1, MMUX_LIBC_SIGUSR1)) {
      handle_error();
    }
    if (mmux_libc_sigaddset(ipxsigset2, MMUX_LIBC_SIGUSR2)) {
      handle_error();
    }
    if (mmux_libc_sigorset(ipxsigset, ipxsigset1, ipxsigset2)) {
      handle_error();
    }

    /* Test SIGUSR1 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR1 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR1)) {
	printf_error("testing SIGUSR1 membership");
	handle_error();
      } else if (is_member) {
	printf_message("SIGUSR1 correctly found as member");
      } else {
	printf_error("SIGUSR1 wrongly not found as member");
	handle_error();
      }
    }

    /* Test SIGUSR2 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR2 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR2)) {
	printf_error("testing SIGUSR2 membership");
	handle_error();
      } else if (is_member) {
	printf_message("SIGUSR2 correctly found as member");
      } else {
	printf_error("SIGUSR2 wrongly not found as member");
	handle_error();
      }
    }

    /* Test SIGTERM membership. */
    {
      bool	is_member;

      printf_message("testing SIGTERM membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGTERM)) {
	printf_error("testing SIGTERM membership");
	handle_error();
      } else if (is_member) {
	printf_error("SIGTERM wrongly found as member");
	handle_error();
      } else {
	printf_message("SIGTERM correctly found as not member");
      }
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
sets_intersection (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_libc_sigset_t	ipxsigset, ipxsigset1, ipxsigset2;

    if (mmux_libc_sigemptyset(ipxsigset)) {
      handle_error();
    }
    if (mmux_libc_sigemptyset(ipxsigset1)) {
      handle_error();
    }
    if (mmux_libc_sigemptyset(ipxsigset2)) {
      handle_error();
    }

    /* Add signals to "ipxsigset1". */
    {
      if (mmux_libc_sigaddset(ipxsigset1, MMUX_LIBC_SIGUSR1)) {
	handle_error();
      }
      if (mmux_libc_sigaddset(ipxsigset1, MMUX_LIBC_SIGUSR2)) {
	handle_error();
      }
    }

    /* Add signals to "ipxsigset2". */
    {
      if (mmux_libc_sigaddset(ipxsigset2, MMUX_LIBC_SIGUSR1)) {
	handle_error();
      }
      if (mmux_libc_sigaddset(ipxsigset2, MMUX_LIBC_SIGTERM)) {
	handle_error();
      }
    }

    if (mmux_libc_sigandset(ipxsigset, ipxsigset1, ipxsigset2)) {
      handle_error();
    }

    /* Test SIGUSR1 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR1 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR1)) {
	printf_error("testing SIGUSR1 membership");
	handle_error();
      } else if (is_member) {
	printf_message("SIGUSR1 correctly found as member");
      } else {
	printf_error("SIGUSR1 wrongly not found as member");
	handle_error();
      }
    }

    /* Test SIGUSR2 membership. */
    {
      bool	is_member;

      printf_message("testing SIGUSR2 membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGUSR2)) {
	printf_error("testing SIGUSR2 membership");
	handle_error();
      } else if (is_member) {
	printf_error("SIGUSR2 wrongly found as member");
	handle_error();
      } else {
	printf_message("SIGUSR2 correctly not found as member");
      }
    }

    /* Test SIGTERM membership. */
    {
      bool	is_member;

      printf_message("testing SIGTERM membership");
      if (mmux_libc_sigismember(&is_member, ipxsigset, MMUX_LIBC_SIGTERM)) {
	printf_error("testing SIGTERM membership");
	handle_error();
      } else if (is_member) {
	printf_error("SIGTERM wrongly found as member");
	handle_error();
      } else {
	printf_message("SIGTERM correctly not found as member");
      }
    }
  }
  printf_message("%s: DONE", __func__);
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
    PROGNAME = "test-interprocess-signals-struct-sigset";
  }

  if (true) {	start_with_an_empty_set();	}
  if (true) {	start_with_a_full_set();	}
  if (true) {	sets_union();			}
  if (true) {	sets_intersection();		}

  mmux_libc_exit_success();
}

/* end of file */
