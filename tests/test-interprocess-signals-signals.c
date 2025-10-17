/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 17, 2025

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
    PROGNAME = "test-interprocess-signals-signals";
  }

  /* Dumping signals. */
  {
    auto		ipxsig = MMUX_LIBC_SIGUSR1;
    mmux_libc_fd_t	fd;

    assert(false == mmux_libc_stder(fd));
    printf_string("signal representation: ");
    assert(false == mmux_libc_interprocess_signal_dump(fd, ipxsig));
    print_newline();
  }

  /* Parsing */
  {
    {
      mmux_asciizcp_t			input_string = "SIGUSR1";
      mmux_libc_interprocess_signal_t	ipxsig;

      if (mmux_libc_interprocess_signal_parse(&ipxsig, input_string, __func__)) {
	handle_error();
      } else if (MMUX_LIBC_VALUEOF_SIGUSR1 == ipxsig.value) {
	printf_message("successfully parsed: %s", input_string);
      } else {
	printf_error("error parsing: %s", input_string);
	mmux_libc_exit_failure();
      }
    }

    /* Invalid input. */
    {
      mmux_asciizcp_t			input_string = "SIGCIAO";
      mmux_libc_interprocess_signal_t	ipxsig;

      if (! mmux_libc_interprocess_signal_parse(&ipxsig, input_string, __func__)) {
	printf_error("expected error parsing input string");
	mmux_libc_exit_failure();
      }
    }

    /* Invalid input. */
    {
      mmux_asciizcp_t			input_string = "CIAO";
      mmux_libc_interprocess_signal_t	ipxsig;

      if (! mmux_libc_interprocess_signal_parse(&ipxsig, input_string, __func__)) {
	printf_error("expected error parsing input string");
	mmux_libc_exit_failure();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
