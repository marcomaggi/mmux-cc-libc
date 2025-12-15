/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec 15, 2025

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
initialise_hints_addrinfo_with_localhost (mmux_libc_addrinfo_t addrinfo)
{
  /* Initialise the field ai_family. */
  {
    if (mmux_libc_addrinfo_family_set(addrinfo, MMUX_LIBC_AF_UNSPEC)) {
      handle_error();
    }
  }

  /* Initialise the field ai_socktype. */
  {
    if (mmux_libc_addrinfo_socket_communication_style_set(addrinfo, MMUX_LIBC_SOCK_STREAM)) {
      handle_error();
    }
  }

  /* Initialise the field ai_protocol. */
  {
    if (mmux_libc_addrinfo_internet_protocol_set(addrinfo, MMUX_LIBC_IPPROTO_IP)) {
      handle_error();
    }
  }

  /* Initialise the field ai_flags. */
  {
    auto	ai_flags = mmux_libc_network_addrinfo_flags(MMUX_LIBC_AI_PASSIVE |
							    MMUX_LIBC_AI_CANONNAME);

    if (mmux_libc_addrinfo_flags_set(addrinfo, ai_flags)) {
      handle_error();
    }
  }

  /* Initialise the field ai_addrlen. */
  {
    if (mmux_libc_addrinfo_addrlen_set(addrinfo, mmux_libc_socklen_constant_zero())) {
      handle_error();
    }
  }

  /* Initialise the field ai_addr. */
  {
    if (mmux_libc_addrinfo_sockaddr_set(addrinfo, NULL)) {
      handle_error();
    }
  }

  /* Initialise the field ai_canonname. */
  {
    if (mmux_libc_addrinfo_canonname_set(addrinfo, "localhost")) {
      handle_error();
    }
  }

  /* Initialise the field ai_next. */
  {
    if (mmux_libc_addrinfo_next_set(addrinfo, NULL)) {
      handle_error();
    }
  }

  if (true) {
    printf_message("dump the hints addrinfo");
    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_addrinfo_dump(er, addrinfo, "hints_addrinfo")) {
	handle_error();
      }
    }
  }
}


static void
test_getaddrinfo_with_hints (void)
{
  printf_message("testing: %s", __func__);
  {
    bool			there_is_one_more;
    mmux_libc_first_addrinfo_t	first_addrinfo;
    mmux_libc_addrinfo_t	ai_next;
    mmux_sint_t			error_code;
    mmux_asciizcp_t		node = "localhost", service = "smtp";
    mmux_libc_addrinfo_t	hints_addrinfo;

    initialise_hints_addrinfo_with_localhost(hints_addrinfo);

    printf_message("getaddrinfo-ing");
    if (mmux_libc_getaddrinfo(&there_is_one_more, first_addrinfo, ai_next, &error_code,
			      node, service, hints_addrinfo)) {
      mmux_asciizcp_t	error_message;

      mmux_libc_gai_strerror(&error_message, error_code);
      printf_error("getaddrinfo-ing: %s", error_message);
      handle_error();
    }
    if (there_is_one_more) {
      do {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_addrinfo_dump(er, ai_next, NULL)) {
	  handle_error();
	}
	mmux_libc_addrinfo_next_ref(&there_is_one_more, ai_next, ai_next);
      } while (there_is_one_more);
      printf_message("freeaddrinfo-ing");
      if (mmux_libc_freeaddrinfo(first_addrinfo)) {
	printf_error("freeaddrinfo-ing");
	handle_error();
      }
    }

  }
  printf_message("DONE: %s\n", __func__);
}


static void
test_getaddrinfo_no_hints (void)
{
  printf_message("testing: %s", __func__);
  {
    bool			there_is_one_more;
    mmux_libc_first_addrinfo_t	first_addrinfo;
    mmux_libc_addrinfo_t	ai_next;
    mmux_sint_t			error_code;
    mmux_asciizcp_t		node = "localhost", service = "smtp";

    printf_message("getaddrinfo-ing");
    if (mmux_libc_getaddrinfo(&there_is_one_more, first_addrinfo, ai_next, &error_code,
			      node, service, NULL)) {
      mmux_asciizcp_t	error_message;

      mmux_libc_gai_strerror(&error_message, error_code);
      printf_error("getaddrinfo-ing: %s", error_message);
      handle_error();
    }
    if (there_is_one_more) {
      do {
	mmux_libc_oufd_t	er;

	mmux_libc_stder(er);
	if (mmux_libc_addrinfo_dump(er, ai_next, NULL)) {
	  handle_error();
	}
	mmux_libc_addrinfo_next_ref(&there_is_one_more, ai_next, ai_next);
      } while (there_is_one_more);
      printf_message("freeaddrinfo-ing");
      if (mmux_libc_freeaddrinfo(first_addrinfo)) {
	printf_error("freeaddrinfo-ing");
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
    PROGNAME = "test-networking-struct-addrinfo";
  }

  if (true) {	test_getaddrinfo_with_hints();		}
  if (true) {	test_getaddrinfo_no_hints();		}

  mmux_libc_exit_success();
}

/* end of file */
