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
test_starting_blocking_mask_is_empty (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_libc_sigset_t	current_blocking_mask;

    printf_message("retrieving the starting mask");
    if (mmux_libc_interprocess_signals_blocking_mask_ref(current_blocking_mask)) {
      printf_error("retrieving the starting mask");
      handle_error();
    }

    /* Test for emptyness. */
    {
      bool	is_empty;

      printf_message("testing for emptyness");
      if (mmux_libc_sigisemptyset(&is_empty, current_blocking_mask)) {
	printf_error("testing for emptyness");
	handle_error();
      } if (is_empty) {
	printf_message("initial blocking mask correctly found as empty");
      } else {
	printf_error("initial blocking mask wrongly found as not empty");
	handle_error();
      }
    }
  }
  printf_message("%s: DONE\n", __func__);
}


static void
test_adding_to_blocking_mask (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_libc_sigset_t	ipxsigset;
    mmux_libc_sigset_t	old_blocking_mask;

    printf_message("initialising new set to empty");
    if (mmux_libc_sigemptyset(ipxsigset)) {
      printf_error("initialising new to empty");
      handle_error();
    }

    printf_message("adding SIGUSR1 to set");
    if (mmux_libc_sigaddset(ipxsigset, MMUX_LIBC_SIGUSR1)) {
      printf_error("adding SIGUSR1 to set");
      handle_error();
    }

    printf_message("adding set to blocking mask");
    if (mmux_libc_interprocess_signals_blocking_mask_add_set(ipxsigset, old_blocking_mask)) {
      printf_error("adding set to blocking mask");
      handle_error();
    }

    /* Test the old mask for emptyness. */
    {
      bool	is_empty;

      printf_message("testing old mask for emptyness");
      if (mmux_libc_sigisemptyset(&is_empty, old_blocking_mask)) {
	printf_error("testing old mask for emptyness");
	handle_error();
      } if (is_empty) {
	printf_message("old blocking mask correctly found as empty");
      } else {
	printf_error("old blocking mask wrongly found as not empty");
	handle_error();
      }
    }

    /* Retrieve the new blocking mask. */
    {
      mmux_libc_sigset_t	current_blocking_mask;

      printf_message("retrieving the current blocking mask");
      if (mmux_libc_interprocess_signals_blocking_mask_ref(current_blocking_mask)) {
	printf_error("retrieving the current blocking mask");
	handle_error();
      }

      /* Test the current mask for non-emptyness. */
      {
	bool	is_empty;

	printf_message("testing current mask for emptyness");
	if (mmux_libc_sigisemptyset(&is_empty, current_blocking_mask)) {
	  printf_error("testing current mask for emptyness");
	  handle_error();
	} if (is_empty) {
	  printf_error("current blocking mask wrongly found as empty");
	  handle_error();
	} else {
	  printf_message("current blocking mask correctly found as not empty");
	}
      }

      /* Test SIGUSR1 membership. */
      {
	bool  is_member;

	mmux_libc_sigismember(&is_member, current_blocking_mask, MMUX_LIBC_SIGUSR1);
	if (is_member) {
	  printf_message("current blocking mask correctly does contain SIGUSR1");
	} else {
	  printf_error("current blocking mask wrongly does not contain SIGUSR1");
	  handle_error();
	}
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_sigset_t	new_blocking_mask, current_blocking_mask;

      mmux_libc_sigemptyset(new_blocking_mask);
      mmux_libc_interprocess_signals_blocking_mask_set(new_blocking_mask, NULL);
      mmux_libc_interprocess_signals_blocking_mask_ref(current_blocking_mask);

      /* Test the current mask for emptyness. */
      {
	bool	is_empty;

	printf_message("testing current mask for emptyness");
	if (mmux_libc_sigisemptyset(&is_empty, current_blocking_mask)) {
	  printf_error("testing current mask for emptyness");
	  handle_error();
	} if (is_empty) {
	  printf_message("current blocking mask correctly found as empty");
	} else {
	  printf_error("current blocking mask wrongly found as not empty");
	  handle_error();
	}
      }
    }
  }
  printf_message("%s: DONE\n", __func__);
}


static void
test_removing_from_blocking_mask (void)
{
  printf_message("%s: running test", __func__);
  {
    {
      mmux_libc_sigset_t	ipxsigset;
      mmux_libc_sigset_t	old_blocking_mask;

      printf_message("initialising new set to empty");
      if (mmux_libc_sigemptyset(ipxsigset)) {
	printf_error("initialising new to empty");
	handle_error();
      }

      printf_message("adding SIGUSR1 to set");
      if (mmux_libc_sigaddset(ipxsigset, MMUX_LIBC_SIGUSR1)) {
	printf_error("adding SIGUSR1 to set");
	handle_error();
      }

      printf_message("adding set to blocking mask");
      if (mmux_libc_interprocess_signals_blocking_mask_add_set(ipxsigset, old_blocking_mask)) {
	printf_error("adding set to blocking mask");
	handle_error();
      }

      /* Test the old mask for emptyness. */
      {
	bool	is_empty;

	printf_message("testing old mask for emptyness");
	if (mmux_libc_sigisemptyset(&is_empty, old_blocking_mask)) {
	  printf_error("testing old mask for emptyness");
	  handle_error();
	} if (is_empty) {
	  printf_message("old blocking mask correctly found as empty");
	} else {
	  printf_error("old blocking mask wrongly found as not empty");
	  handle_error();
	}
      }
    }

    /* Retrieve the new blocking mask. */
    {
      mmux_libc_sigset_t	current_blocking_mask;

      printf_message("retrieving the current blocking mask");
      if (mmux_libc_interprocess_signals_blocking_mask_ref(current_blocking_mask)) {
	printf_error("retrieving the current blocking mask");
	handle_error();
      }

      /* Test the current mask for non-emptyness. */
      {
	bool	is_empty;

	printf_message("testing current mask for emptyness");
	if (mmux_libc_sigisemptyset(&is_empty, current_blocking_mask)) {
	  printf_error("testing current mask for emptyness");
	  handle_error();
	} if (is_empty) {
	  printf_error("current blocking mask wrongly found as empty");
	  handle_error();
	} else {
	  printf_message("current blocking mask correctly found as not empty");
	}
      }

      /* Test SIGUSR1 membership. */
      {
	bool  is_member;

	mmux_libc_sigismember(&is_member, current_blocking_mask, MMUX_LIBC_SIGUSR1);
	if (is_member) {
	  printf_message("current blocking mask correctly does contain SIGUSR1");
	} else {
	  printf_error("current blocking mask wrongly does not contain SIGUSR1");
	  handle_error();
	}
      }
    }

    /* Remove SIGUSR1 from the current mask. */
    {
      mmux_libc_sigset_t	ipxsigset;

      if (mmux_libc_sigemptyset(ipxsigset)) {
	handle_error();
      }
      if (mmux_libc_sigaddset(ipxsigset, MMUX_LIBC_SIGUSR1)) {
	handle_error();
      }

      printf_message("removing SIGUSR1 from current blocking mask");
      if (mmux_libc_interprocess_signals_blocking_mask_remove_set(ipxsigset, NULL)) {
	printf_error("removing SIGUSR1 from current blocking mask");
	handle_error();
      }

      /* Test the current blocking mask. */
      {
	mmux_libc_sigset_t	current_blocking_mask;

	if (mmux_libc_interprocess_signals_blocking_mask_ref(current_blocking_mask)) {
	  handle_error();
	}

	/* Test SIGUSR1 membership. */
	{
	  bool  is_member;

	  mmux_libc_sigismember(&is_member, current_blocking_mask, MMUX_LIBC_SIGUSR1);
	  if (is_member) {
	    printf_error("current blocking mask wrongly does contain SIGUSR1");
	    handle_error();
	  } else {
	    printf_message("current blocking mask correctly does not contain SIGUSR1");
	  }
	}
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_sigset_t	new_blocking_mask, current_blocking_mask;

      mmux_libc_sigemptyset(new_blocking_mask);
      mmux_libc_interprocess_signals_blocking_mask_set(new_blocking_mask, NULL);
      mmux_libc_interprocess_signals_blocking_mask_ref(current_blocking_mask);

      /* Test the current mask for emptyness. */
      {
	bool	is_empty;

	printf_message("testing current mask for emptyness");
	if (mmux_libc_sigisemptyset(&is_empty, current_blocking_mask)) {
	  printf_error("testing current mask for emptyness");
	  handle_error();
	} if (is_empty) {
	  printf_message("current blocking mask correctly found as empty");
	} else {
	  printf_error("current blocking mask wrongly found as not empty");
	  handle_error();
	}
      }
    }
  }
  printf_message("%s: DONE\n", __func__);
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

  if (true) {	test_starting_blocking_mask_is_empty();	}
  if (true) {	test_adding_to_blocking_mask();		}
  if (true) {	test_removing_from_blocking_mask();	}

  mmux_libc_exit_success();
}

/* end of file */
