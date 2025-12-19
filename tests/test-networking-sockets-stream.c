/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Dec 18, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	local_socket_ptn_asciiz = "./test-networking-sockets-stream-local.sock";


static void
build_sockaddr_ipfour (mmux_libc_sockaddr_ipfour_t sockaddr, mmux_libc_socklen_t * sockaddr_length_p)
/* Build the IPv4 sockaddr to be used by both the client and the server. */
{
  mmux_libc_ipfour_addr_t	ipfour_addr;
  mmux_asciizcp_t		presentation = "127.0.0.1";

  if (mmux_libc_make_ipfour_addr_from_asciiz(ipfour_addr, presentation)) {
    handle_error();
  }
  mmux_libc_sockaddr_ipfour_family_set(sockaddr, MMUX_LIBC_AF_INET);
  mmux_libc_sockaddr_ipfour_addr_set(sockaddr, ipfour_addr);
  mmux_libc_sockaddr_ipfour_port_set(sockaddr, mmux_libc_network_port_number_from_host_byteorder_literal(8080));

  mmux_libc_sockaddr_bind_length(sockaddr_length_p, sockaddr);
}
static void
build_sockaddr_ipsix (mmux_libc_sockaddr_ipsix_t sockaddr, mmux_libc_socklen_t * sockaddr_length_p)
/* Build the IPv6 sockaddr to be used by both the client and the server. */
{
  mmux_libc_ipsix_addr_t	ipsix_addr;

  if (mmux_libc_make_ipsix_addr_loopback(ipsix_addr)) {
    handle_error();
  }
  mmux_libc_sockaddr_ipsix_family_set(sockaddr, MMUX_LIBC_AF_INET6);
  mmux_libc_sockaddr_ipsix_addr_set(sockaddr, ipsix_addr);
  mmux_libc_sockaddr_ipsix_port_set(sockaddr, mmux_libc_network_port_number_from_host_byteorder_literal(8081));

  mmux_libc_sockaddr_bind_length(sockaddr_length_p, sockaddr);
}

static void
build_sockaddr_local (mmux_libc_sockaddr_local_t sockaddr, mmux_libc_socklen_t * sockaddr_length_p)
/* Build the local sockaddr to be used by both the client and the server. */
{
  mmux_libc_fs_ptn_t  fs_ptn;

  /* Build socket's file system pathname. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, local_socket_ptn_asciiz)) {
      handle_error();
    }
  }

  /* Initialise the fields. */
  {
    if (mmux_libc_sockaddr_local_family_set(sockaddr, MMUX_LIBC_AF_LOCAL)) {
      handle_error();
    }
    if (mmux_libc_sockaddr_local_path_set(sockaddr, fs_ptn)) {
      handle_error();
    }
  }

  /* Local cleanup. */
  {
    if (mmux_libc_unmake_file_system_pathname(fs_ptn)) {
      handle_error();
    }
  }

  mmux_libc_sockaddr_bind_length(sockaddr_length_p, sockaddr);
}


static void
server_wait_for_child_process_successful_completion (mmux_libc_pid_t child_pid)
/* Wait for the completion of the child process. */
{
  bool						process_completion_status_is_available;
  mmux_libc_pid_t				completed_process_pid;
  mmux_libc_process_completion_status_t		process_completion_status;
  auto	waiting_options = mmux_libc_process_completion_waiting_options(0);

  printf_message("parent: waiting for child process completion");
  if (mmux_libc_wait_process_id(&process_completion_status_is_available,
				&process_completion_status, &completed_process_pid,
				child_pid, waiting_options)) {
    printf_error("parent: waiting for child process completion");
    handle_error();
  } else {
    if (process_completion_status_is_available) {
      printf_message("parent: child process completion status: %d", process_completion_status.value);
    } else {
      printf_error("parent: no child-process completion-status");
      handle_error();
    }
  }
}


static void
server_kill_child_process_wait_for_its_completion (mmux_libc_pid_t child_pid)
/* An error occurred in the parent-process, server-process: send SIGTERM to the child
   process, then wait for its completion. */
{
  printf_message("parent: kill the child process, then wait for its completion");

  /* Send SIGTERM to the child process. */
  {
    printf_message("parent: deliver SIGTERM to the child process");
    if (mmux_libc_kill(child_pid, MMUX_LIBC_SIGTERM)) {
      printf_error("parent: deliver SIGTERM to the child process");
      handle_error();
    }
  }

  /* Wait for the child process completion. */
  {
    bool					process_completion_status_is_available;
    mmux_libc_pid_t				completed_process_pid;
    mmux_libc_process_completion_status_t	process_completion_status;
    auto	waiting_options = mmux_libc_process_completion_waiting_options(0);

    printf_message("parent: waiting for chid process completion");
    if (mmux_libc_wait_process_id(&process_completion_status_is_available,
				  &process_completion_status, &completed_process_pid,
				  child_pid, waiting_options)) {
      printf_error("parent: waiting for child process completion");
      handle_error();
    } else {
      if (process_completion_status_is_available) {
	printf_message("parent: child process completion status: %d", process_completion_status.value);
      } else {
	printf_error("parent: no child-process completion-status");
	handle_error();
      }
    }
  }
}


static void
server_doit (mmux_libc_pid_t child_pid, bool use_accept4,
	     mmux_libc_network_protocol_family_t family, mmux_libc_network_internet_protocol_t ipproto,
	     mmux_libc_sockaddr_arg_t server_sockaddr, mmux_libc_socklen_t server_sockaddr_length)
{
  mmux_libc_sockfd_t	server_sockfd, client_connection_sockfd;

  /* Dump the server_sockaddr for debugging purposes. */
  if (true) {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_sockaddr_dump(er, server_sockaddr, "server_sockaddr")) {
      goto error;
    }
  }

  /* Build the server socket. */
  {
    printf_message("parent: server: make server socket");
    if (mmux_libc_socket(server_sockfd, family, MMUX_LIBC_SOCK_STREAM, ipproto)) {
      printf_error("parent: server: make server socket");
      goto error;
    }
  }

  /* Bind the server socket to the server_sockaddr. */
  {
    printf_message("parent: server: bind server socket to server_sockaddr");
    if (mmux_libc_bind(server_sockfd, server_sockaddr, server_sockaddr_length)) {
      printf_error("parent: server: bind server socket to server_sockaddr");
      goto error;
    }
  }

  /* Listening for client connections to the server socket. */
  {
    printf_message("parent: server: listening to the server socket");
    if (mmux_libc_listen(server_sockfd, mmux_uint_literal(5))) {
      printf_error("parent: server: listening to the server socket");
      goto error;
    }
  }

  /* Accept a connection from the server. */
  {
    auto			client_connection_sockaddr_buflen = mmux_libc_socklen_literal(512);
    mmux_standard_octet_t	client_connection_sockaddr_bufptr[client_connection_sockaddr_buflen.value];
    auto			client_connection_sockaddr = (mmux_libc_sockaddr_t)client_connection_sockaddr_bufptr;
    auto			client_connection_sockaddr_length = client_connection_sockaddr_buflen;

    if (false == use_accept4) {
      printf_message("parent: server: accepting connection from client");
      if (mmux_libc_accept(client_connection_sockfd,
			   client_connection_sockaddr, &client_connection_sockaddr_length,
			   server_sockfd)) {
	printf_error("parent: server: accepting connection from client");
	goto error;
      }
    } else {
      auto	flags = mmux_libc_accept4_flags(MMUX_LIBC_SOCK_NONBLOCK);

      printf_message("parent: server: accept4-ing connection from client");
      if (mmux_libc_accept4(client_connection_sockfd,
			    client_connection_sockaddr, &client_connection_sockaddr_length,
			    server_sockfd, flags)) {
	printf_error("parent: server: accept4-ing connection from client");
	goto error;
      }
    }

    /* Dump the client connection address. */
    if (true) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_dprintf(er, "parent: server: client sockaddr length %lu\n",
			    (mmux_standard_ulong_t) client_connection_sockaddr_length.value)) {
	handle_error();
      }
      if (mmux_libc_sockaddr_dump(er, client_connection_sockaddr, "client_connection_sockaddr")) {
	printf_error("parent: server: dumping the client connection sockaddr");
      }
    }
  }

  /* Read from the connected socket. */
  {
    mmux_usize_t	nbytes_done;
    auto		buflen = mmux_usize_literal(128);
    char		bufptr[buflen.value];
    auto		flags = mmux_libc_recv_flags(0);

    printf_message("parent: server: receiving data from socket");
    if (mmux_libc_recv(&nbytes_done, client_connection_sockfd, bufptr, buflen, flags)) {
      printf_error("parent: server: receiving data from socket");
      handle_error();
    }
    bufptr[nbytes_done.value] = '\0';

    /* Check the received data. */
    {
      bool	are_equal;

      if (mmux_libc_strequ(&are_equal, bufptr, "the colour of water and quicksilver")) {
	handle_error();
      } else if (are_equal) {
	printf_message("parent: server: correct string read from client connection socket: '%s'", bufptr);
      } else {
	printf_error("parent: server: wrong string read from client connection socket");
	handle_error();
      }
    }
  }

  /* Final cleanup */
  {
    printf_message("parent: server: closing sockets");

    if (mmux_libc_close(client_connection_sockfd)) {
      printf_error("parent: server: closing client connection socket");
      handle_error();
    }

    if (mmux_libc_close(server_sockfd)) {
      printf_error("parent: server: closing server socket");
      handle_error();
    }
  }

  server_wait_for_child_process_successful_completion(child_pid);
  printf_message("parent: server: returning to main successfully");
  return;

 error:
  {
    mmux_libc_errno_t	errnum;
    mmux_asciizcp_t	errmsg;

    mmux_libc_errno_consume(&errnum);
    if (errnum.value) {
      if (mmux_libc_strerror(&errmsg, errnum)) {
	mmux_libc_exit_failure();
      } else {
	print_error(errmsg);
      }
    }
  }
  server_kill_child_process_wait_for_its_completion(child_pid);
  printf_message("parent: server: exiting process after error");
  mmux_libc_exit_failure();
}


static void
client_doit (mmux_libc_network_protocol_family_t family,
	     mmux_libc_network_internet_protocol_t ipproto,
	     mmux_libc_sockaddr_arg_t server_sockaddr, mmux_libc_socklen_t server_sockaddr_length)
{
  mmux_libc_sockfd_t	client_sockfd;

  {
    printf_message("child: client: wait for the server to set itself up");
    wait_for_some_time();
  }

  /* Build the client socket. */
  {
    printf_message("child: client: creating the socket");
    if (mmux_libc_socket(client_sockfd, family, MMUX_LIBC_SOCK_STREAM, ipproto)) {
      printf_error("child: client: creating the socket");
      handle_error();
    }
  }

  /* Connect the client socket to the server_sockaddr. */
  {
    printf_message("child: client: connecting to the server");
    if (mmux_libc_connect(client_sockfd, server_sockaddr, server_sockaddr_length)) {
      printf_error("child: client: connecting to the server");
      handle_error();
    }
  }

  /* Write a message to the server. */
  {
    mmux_asciizcp_t	bufptr = "the colour of water and quicksilver";
    mmux_usize_t	buflen, nbytes_done;
    auto		flags = mmux_libc_send_flags(0);

    mmux_libc_strlen(&buflen, bufptr);
    printf_message("child: client: sending data to socket");
    if (mmux_libc_send(&nbytes_done, client_sockfd, bufptr, buflen, flags)) {
      printf_error("child: client: sending data to socket");
      handle_error();
    }

    /* Check that all the data has been sent. */
    {
      if (mmux_usize_equal(buflen, nbytes_done)) {
	printf_message("child: client: correctly sent all data");
      } else {
	print_error("child: client: wrongly sent not all data");
	handle_error();
      }
    }
  }

  /* Final cleanup. */
  {
    printf_message("child: client: closing the client socket");
    if (mmux_libc_close(client_sockfd)) {
      printf_error("child: client: closing the client socket");
    }
  }

  printf_message("child: client: exiting process successfully");
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
    PROGNAME = "test-networking-sockets-stream";
  }

  if (true) {
    print_newline();
    printf_message("Do it for local addresses.");
    mmux_libc_sockaddr_local_t	sockaddr;
    mmux_libc_socklen_t		sockaddr_length;

    build_sockaddr_local(sockaddr, &sockaddr_length);

    /* Fork a child process. */
    {
      bool		this_is_the_parent_process;
      mmux_libc_pid_t	child_pid;

      printf_message("forking for local addresses");
      if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
	printf_error("forking for local addresses");
	handle_error();
      } else if (this_is_the_parent_process) {
	/* Final cleanup only in the parent process. */
	if (true) {
	  cleanfiles_register(local_socket_ptn_asciiz);
	  cleanfiles();
	  mmux_libc_atexit(cleanfiles);
	}
	{
	  server_doit(child_pid, false,
		      MMUX_LIBC_PF_LOCAL, MMUX_LIBC_IPPROTO_IP,
		      sockaddr, sockaddr_length);
	}
	if (true) {
	  cleanfiles();
	}
      } else {
	client_doit(MMUX_LIBC_PF_LOCAL, MMUX_LIBC_IPPROTO_IP, sockaddr, sockaddr_length);
      }
    }
  }

  if (true) {
    print_newline();
    printf_message("Do it for IPv4 addresses with 'accept()'.");
    mmux_libc_sockaddr_ipfour_t	sockaddr;
    mmux_libc_socklen_t		sockaddr_length;

    build_sockaddr_ipfour(sockaddr, &sockaddr_length);

    /* Fork a child process. */
    {
      bool		this_is_the_parent_process;
      mmux_libc_pid_t	child_pid;

      printf_message("forking for IPv4 addresses");
      if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
	printf_error("forking for IPv4 addresses");
	handle_error();
      } else if (this_is_the_parent_process) {
	server_doit(child_pid, false,
		    MMUX_LIBC_PF_INET, MMUX_LIBC_IPPROTO_TCP, sockaddr, sockaddr_length);
      } else {
	client_doit(MMUX_LIBC_PF_INET, MMUX_LIBC_IPPROTO_TCP, sockaddr, sockaddr_length);
      }
    }
  }

  if (true) {
    print_newline();
    printf_message("Do it for IPv4 addresses with 'accept4()'.");
    mmux_libc_sockaddr_ipfour_t	sockaddr;
    mmux_libc_socklen_t		sockaddr_length;

    build_sockaddr_ipfour(sockaddr, &sockaddr_length);

    /* Fork a child process. */
    {
      bool		this_is_the_parent_process;
      mmux_libc_pid_t	child_pid;

      printf_message("forking for IPv4 addresses");
      if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
	printf_error("forking for IPv4 addresses");
	handle_error();
      } else if (this_is_the_parent_process) {
	server_doit(child_pid, false, MMUX_LIBC_PF_INET, MMUX_LIBC_IPPROTO_TCP, sockaddr, sockaddr_length);
      } else {
	client_doit(MMUX_LIBC_PF_INET, MMUX_LIBC_IPPROTO_TCP, sockaddr, sockaddr_length);
      }
    }
  }

  if (true) {
    print_newline();
    printf_message("Do it for IPv6 addresses.");
    mmux_libc_sockaddr_ipsix_t	sockaddr;
    mmux_libc_socklen_t		sockaddr_length;

    build_sockaddr_ipsix(sockaddr, &sockaddr_length);

    /* Fork a child process. */
    {
      bool		this_is_the_parent_process;
      mmux_libc_pid_t	child_pid;

      printf_message("forking for IPv6 addresses");
      if (mmux_libc_fork(&this_is_the_parent_process, &child_pid)) {
	printf_error("forking for IPv6 addresses");
	handle_error();
      } else if (this_is_the_parent_process) {
	server_doit(child_pid, false, MMUX_LIBC_PF_INET6, MMUX_LIBC_IPPROTO_TCP, sockaddr, sockaddr_length);
      } else {
	client_doit(MMUX_LIBC_PF_INET6, MMUX_LIBC_IPPROTO_TCP, sockaddr, sockaddr_length);
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
