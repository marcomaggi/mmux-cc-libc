/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec 22, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>


static void
test_socket_option_keepalive (void)
{
  printf_message("testing: %s", __func__);
  {
    mmux_libc_sockfd_t	sockfd;
    auto	namespace = MMUX_LIBC_PF_INET;
    auto	style     = MMUX_LIBC_SOCK_STREAM;
    auto	ipproto   = MMUX_LIBC_IPPROTO_TCP;

    printf_message("socket-ing");
    if (mmux_libc_socket(sockfd, namespace, style, ipproto)) {
      printf_error("socket-ing");
      handle_error();
    }

    /* Setting the option. */
    {
      auto	optval = mmux_standard_sint_literal(1);
      auto	optlen = mmux_libc_socklen(sizeof(int));

      printf_message("setting option SO_KEEPALIVE");
      if (mmux_libc_setsockopt(sockfd, MMUX_LIBC_SOL_SOCKET, MMUX_LIBC_SO_KEEPALIVE,
			       &optval, optlen)) {
	printf_error("setting option SO_KEEPALIVE");
	handle_error();
      }
    }

    /* Getting the option. */
    {
      mmux_standard_sint_t	optval;
      mmux_libc_socklen_t	optlen;

      printf_message("getting option SO_KEEPALIVE");
      if (mmux_libc_getsockopt(&optval, &optlen,
			       sockfd, MMUX_LIBC_SOL_SOCKET, MMUX_LIBC_SO_KEEPALIVE)) {
	printf_error("getting option SO_KEEPALIVE");
	handle_error();
      }

      if (0 != optval) {
	printf_message("correct value for SO_KEEPALIVE option");
      } else {
	printf_error("wrong value for SO_KEEPALIVE option");
	handle_error();
      }
    }

    printf_message("closing socket");
    if (mmux_libc_close(sockfd)) {
      printf_error("closing socket");
      handle_error();
    }
  }
  printf_message("DONE: %s\n", __func__);
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
    PROGNAME = "test-networking-sockets-file-descriptors";
  }

  if (true) {	test_socket_option_keepalive();		}

  mmux_libc_exit_success();
}

/* end of file */
