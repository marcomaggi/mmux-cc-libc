/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec 17, 2025

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
test_sockfd_raw_initialisation (void)
{
  printf_message("testing: %s", __func__);
  {
    mmux_libc_sockfd_t	sockfd;

    printf_message("raw initialisation of sockfd");
    if (mmux_libc_make_network_socket(sockfd, 123)) {
      printf_error("raw initialisation of sockfd");
      handle_error();
    }
  }
  printf_message("DONE: %s\n", __func__);
}


static void
test_sockfd_function_socket (void)
{
  printf_message("testing: %s", __func__);
  {
    /* Creating and closing. */
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

      printf_message("closing socket");
      if (mmux_libc_close(sockfd)) {
	printf_error("closing socket");
	handle_error();
      }
    }

    /* Creating and shutting down.  Shutting down is successful only if the socket is
       connected. */
    if (false) {
      mmux_libc_sockfd_t	sockfd;
      auto	namespace = MMUX_LIBC_PF_INET;
      auto	style     = MMUX_LIBC_SOCK_STREAM;
      auto	ipproto   = MMUX_LIBC_IPPROTO_TCP;

      printf_message("socket-ing");
      if (mmux_libc_socket(sockfd, namespace, style, ipproto)) {
	printf_error("socket-ing");
	handle_error();
      }

      printf_message("shutting down socket");
      if (mmux_libc_shutdown(sockfd, MMUX_LIBC_SHUT_RDWR)) {
	printf_error("shutting down socket");
	handle_error();
      }
    }
  }
  printf_message("DONE: %s\n", __func__);
}


static void
test_sockfd_function_socketpair (void)
{
  printf_message("testing: %s", __func__);
  {
    /* Creating and closing. */
    {
      mmux_libc_sockfd_t	sockfd1, sockfd2;
      auto	namespace = MMUX_LIBC_PF_LOCAL;
      auto	style     = MMUX_LIBC_SOCK_STREAM;
      auto	ipproto   = MMUX_LIBC_IPPROTO_IP;

      printf_message("socketpair-ing");
      if (mmux_libc_socketpair(sockfd1, sockfd2, namespace, style, ipproto)) {
	printf_error("socketpair-ing");
	handle_error();
      }

      /* Write to a socket. */
      {
	if (mmux_libc_dprintf(sockfd1, "the colour of water and quicksilver")) {
	  printf_error("writing to socket");
	  handle_error();
	}
      }

      /* Read from the other socket. */
      {
	mmux_usize_t	nbytes_done;
	auto		buflen = mmux_usize_literal(128);
	char		bufptr[buflen.value];

	if (mmux_libc_read(&nbytes_done, sockfd2, bufptr, buflen)) {
	  printf_error("reading from socket");
	  handle_error();
	}
	bufptr[nbytes_done.value] = '\0';
	{
	  bool	are_equal;

	  if (mmux_libc_strequ(&are_equal, bufptr, "the colour of water and quicksilver")) {
	    handle_error();
	  } else if (are_equal) {
	    printf_message("correct string read from socket-pair");
	  } else {
	    printf_error("wrong string read from socket-pair");
	    handle_error();
	  }
	}
      }

      /* Final cleanup */
      {
	printf_message("closing socket");
	if (mmux_libc_close(sockfd1)) {
	  printf_error("closing socket");
	  handle_error();
	}
	if (mmux_libc_close(sockfd2)) {
	  printf_error("closing socket");
	  handle_error();
	}
      }
    }
  }
  printf_message("DONE: %s\n", __func__);
}


static void
test_sockfd_function_getpeername (void)
{
  printf_message("testing: %s", __func__);
  {
    /* Creating and closing. */
    {
      mmux_libc_sockfd_t	sockfd1, sockfd2;
      auto	namespace = MMUX_LIBC_PF_LOCAL;
      auto	style     = MMUX_LIBC_SOCK_STREAM;
      auto	ipproto   = MMUX_LIBC_IPPROTO_IP;

      printf_message("socketpair-ing");
      if (mmux_libc_socketpair(sockfd1, sockfd2, namespace, style, ipproto)) {
	printf_error("socketpair-ing");
	handle_error();
      }

      /* getpeername */
      {
	auto			buflen = mmux_libc_socklen_literal(512);
	mmux_standard_octet_t	bufptr[buflen.value];
	auto			sockaddr = (mmux_libc_sockaddr_t) bufptr;
	auto			sockaddr_length = buflen;

	mmux_libc_memzero_socklen(bufptr, buflen);

	printf_error("getpeername-ing");
	if (mmux_libc_getpeername(sockfd1, sockaddr, &sockaddr_length)) {
	  printf_error("getpeername-ing");
	  handle_error();
	}

	{
	  mmux_libc_oufd_t	er;

	  mmux_libc_stder(er);
	  if (mmux_libc_sockaddr_dump(er, sockaddr, NULL)) {
	    handle_error();
	  }
	}
      }

      /* Final cleanup */
      {
	printf_message("closing socket");
	if (mmux_libc_close(sockfd1)) {
	  printf_error("closing socket");
	  handle_error();
	}
	if (mmux_libc_close(sockfd2)) {
	  printf_error("closing socket");
	  handle_error();
	}
      }
    }
  }
  printf_message("DONE: %s\n", __func__);
}


static void
test_sockfd_function_getsockname (void)
{
  printf_message("testing: %s", __func__);
  {
    /* Creating and closing. */
    {
      mmux_libc_sockfd_t	sockfd1, sockfd2;
      auto	namespace = MMUX_LIBC_PF_LOCAL;
      auto	style     = MMUX_LIBC_SOCK_STREAM;
      auto	ipproto   = MMUX_LIBC_IPPROTO_IP;

      printf_message("socketpair-ing");
      if (mmux_libc_socketpair(sockfd1, sockfd2, namespace, style, ipproto)) {
	printf_error("socketpair-ing");
	handle_error();
      }

      /* getsockname */
      {
	auto			buflen = mmux_libc_socklen_literal(512);
	mmux_standard_octet_t	bufptr[buflen.value];
	auto			sockaddr = (mmux_libc_sockaddr_t) bufptr;
	auto			sockaddr_length = buflen;

	mmux_libc_memzero_socklen(bufptr, buflen);

	printf_error("getsockname-ing");
	if (mmux_libc_getsockname(sockfd1, sockaddr, &sockaddr_length)) {
	  printf_error("getsockname-ing");
	  handle_error();
	}

	{
	  mmux_libc_oufd_t	er;

	  mmux_libc_stder(er);
	  if (mmux_libc_sockaddr_dump(er, sockaddr, NULL)) {
	    handle_error();
	  }
	}
      }

      /* Final cleanup */
      {
	printf_message("closing socket");
	if (mmux_libc_close(sockfd1)) {
	  printf_error("closing socket");
	  handle_error();
	}
	if (mmux_libc_close(sockfd2)) {
	  printf_error("closing socket");
	  handle_error();
	}
      }
    }
  }
  printf_message("DONE: %s\n", __func__);
}


static void
test_sockfd_function_send_recv_socketpair (void)
{
  printf_message("testing: %s", __func__);
  {
    mmux_libc_sockfd_t	sockfd1, sockfd2;

    /* Create the socket-pair. */
    {
      printf_message("socketpair-ing");
      if (mmux_libc_socketpair(sockfd1, sockfd2, MMUX_LIBC_PF_LOCAL, MMUX_LIBC_SOCK_STREAM, MMUX_LIBC_IPPROTO_IP)) {
	printf_error("socketpair-ing");
	handle_error();
      }
    }

    /* Write to a socket. */
    {
      mmux_asciizcp_t	bufptr = "the colour of water and quicksilver";
      mmux_usize_t	buflen, nbytes_done;
      auto		flags = mmux_libc_send_flags(0);

      mmux_libc_strlen(&buflen, bufptr);
      if (mmux_libc_send(&nbytes_done, sockfd1, bufptr, buflen, flags)) {
	printf_error("sending data to socket");
	handle_error();
      }

      {
	if (mmux_usize_equal(buflen, nbytes_done)) {
	  printf_message("correctly sent all data");
	} else {
	  print_error("wrongly sent not all data");
	  handle_error();
	}
      }
    }

    /* Read from the other socket. */
    {
      mmux_usize_t	nbytes_done;
      auto		buflen = mmux_usize_literal(128);
      char		bufptr[buflen.value];
      auto		flags = mmux_libc_recv_flags(0);

      printf_message("receiving data from socket");
      if (mmux_libc_recv(&nbytes_done, sockfd2, bufptr, buflen, flags)) {
	printf_error("receiving data from socket");
	handle_error();
      }
      bufptr[nbytes_done.value] = '\0';
      {
	bool	are_equal;

	if (mmux_libc_strequ(&are_equal, bufptr, "the colour of water and quicksilver")) {
	  handle_error();
	} else if (are_equal) {
	  printf_message("correct string read from socket-pair: '%s'", bufptr);
	} else {
	  printf_error("wrong string read from socket-pair");
	  handle_error();
	}
      }
    }

    /* Final cleanup */
    {
      printf_message("closing socket");
      if (mmux_libc_close(sockfd1)) {
	printf_error("closing socket");
	handle_error();
      }
      if (mmux_libc_close(sockfd2)) {
	printf_error("closing socket");
	handle_error();
      }
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

  if (true) {	test_sockfd_raw_initialisation();		}
  if (true) {	test_sockfd_function_socket();			}
  if (true) {	test_sockfd_function_socketpair();		}
  if (true) {	test_sockfd_function_getpeername();		}
  if (true) {	test_sockfd_function_getsockname();		}
  if (true) {	test_sockfd_function_send_recv_socketpair();	}

  mmux_libc_exit_success();
}

/* end of file */
