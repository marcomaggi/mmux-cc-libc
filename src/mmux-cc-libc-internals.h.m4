/*
  Part of: MMUX CC Libcn
  Contents: private header file
  Date: Dec  8, 2024

  Abstract

	This header file is for internal definitions.  It must be included by all the
	source files in this package.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  This program is free  software: you can redistribute it and/or  modify it under the
  terms  of  the  GNU General  Public  License  as  published  by the  Free  Software
  Foundation, either version 3 of the License, or (at your option) any later version.

  This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
  WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
  PARTICULAR PURPOSE.  See the GNU General Public License for more details.

  You should have received  a copy of the GNU General Public  License along with this
  program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef MMUX_CC_LIBC_INTERNALS_H
#define MMUX_CC_LIBC_INTERNALS_H 1

#ifdef __cplusplus
extern "C" {
#endif


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

/* Look  into "configure.ac"  and "config.h"  for  the definition  of C  preprocessor
   symbols that enable  some standardised features. */
#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <stdarg.h>
#include <mmux-cc-types.h>
#include <mmux-cc-libc-config.h>
#include <mmux-cc-libc-constants.h>
/* at the end we include mmux-cc-libc-functions.h */
/* at the end we include mmux-cc-libc-generics.h */

#ifdef HAVE_INTTYPES_H
#  include <inttypes.h>
#endif

#ifdef HAVE_STDINT_H
#  include <stdint.h>
#endif

#ifdef HAVE_STDIO_H
#  include <stdio.h>
#endif

#ifdef HAVE_STDLIB_H
#  include <stdlib.h>
#endif

#ifdef HAVE_STRING_H
#  include <string.h>
#endif

#ifdef HAVE_STRINGS_H
#  include <strings.h>
#endif

#ifdef HAVE_SYS_STAT_H
#  include <sys/stat.h>
#endif

/* for the type: mode_t, uid_t, gid_t */
#ifdef HAVE_SYS_TYPES_H
#  include <sys/types.h>
#endif

/* for the type: ssize_t, pid_t */
#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif

/* ------------------------------------------------------------------ */

#ifdef HAVE_ARPA_INET_H
#  include <arpa/inet.h>
#endif

#ifdef HAVE_ASSERT_H
#  include <assert.h>
#endif

#ifdef HAVE_COMPLEX_H
#  include <complex.h>
#endif

#ifdef HAVE_CTYPE_H
#  include <ctype.h>
#endif

#ifdef HAVE_DIRENT_H
#  include <dirent.h>
#endif

#ifdef HAVE_ERRNO_H
#  include <errno.h>
#endif

#ifdef HAVE_FCNTL_H
#  include <fcntl.h>
#endif

#ifdef HAVE_FLOAT_H
#  include <float.h>
#endif

#ifdef HAVE_GRP_H
#  include <grp.h>
#endif

#ifdef HAVE_LIMITS_H
#  include <limits.h>
#endif

#ifdef HAVE_LINUX_OPENAT2_H
#  include <linux/openat2.h>
#endif

#ifdef HAVE_MATH_H
#  include <math.h>
#endif

#ifdef HAVE_NETDB_H
#  include <netdb.h>
#endif

#ifdef HAVE_NETINET_IN_H
#  include <netinet/in.h>
#endif

#ifdef HAVE_NET_IF_H
#  include <net/if.h>
#endif

#ifdef HAVE_PWD_H
#  include <pwd.h>
#endif

#ifdef HAVE_UTIME_H
#  include <utime.h>
#endif

#ifdef HAVE_STDARG_H
#  include <stdarg.h>
#endif

#ifdef HAVE_SIGNAL_H
#  include <signal.h>
#endif

#ifdef HAVE_STDBOOL_H
#  include <stdbool.h>
#endif

#ifdef HAVE_SYS_IOCTL_H
#  include <sys/ioctl.h>
#endif

#ifdef HAVE_SYS_MMAN_H
#  include <sys/mman.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#  include <sys/socket.h>
#endif

#ifdef HAVE_SYS_SYSCALL_H
#  include <sys/syscall.h>
#endif

#ifdef HAVE_SYS_TIME_H
#  include <sys/time.h>
#endif

#ifdef HAVE_TIME_H
#  include <time.h>
#endif

#ifdef HAVE_SYS_UIO_H
#  include <sys/uio.h>
#endif

#ifdef HAVE_SYS_UN_H
#  include <sys/un.h>
#endif

#ifdef HAVE_SYS_RESOURCE_H
#  include <sys/resource.h>
#endif

#ifdef HAVE_SYS_WAIT_H
#  include <sys/wait.h>
#endif

#ifdef HAVE_WCHAR_H
#  include <wchar.h>
#endif

/* ------------------------------------------------------------------ */

#ifdef HAVE_REGEX_H
#  include <regex.h>
#endif


/** --------------------------------------------------------------------
 ** Constants.
 ** ----------------------------------------------------------------- */

#define MMUX_LIBC_FD_MAXIMUM_STRING_REPRESENTATION_LENGTH	256
#define MMUX_LIBC_PID_MAXIMUM_STRING_REPRESENTATION_LENGTH	256
#define MMUX_LIBC_UID_MAXIMUM_STRING_REPRESENTATION_LENGTH	256
#define MMUX_LIBC_GID_MAXIMUM_STRING_REPRESENTATION_LENGTH	256

#define MMUX_LIBC_PROCESS_COMPLETION_STATUS_MAXIMUM_STRING_REPRESENTATION_LENGTH	256
#define MMUX_LIBC_INTERPROCESS_SIGNAL_MAXIMUM_STRING_REPRESENTATION_LENGTH		256

#define MMUX_LIBC_GETGROUPLIST_MAXIMUM_GROUPS_NUMBER		4096

#undef  MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_WITH_NUL_ARBITRARY_LIMIT
#define MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_WITH_NUL_ARBITRARY_LIMIT	mmux_usize_literal(4096)

#undef  MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_NO_NUL_ARBITRARY_LIMIT
#define MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_NO_NUL_ARBITRARY_LIMIT	mmux_usize_literal(4095)


/** --------------------------------------------------------------------
 ** Type definitions.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_dirtream_t	{ DIR * value; } mmux_libc_dirstream_t;

typedef struct timeval		mmux_libc_timeval_t;
typedef struct timespec		mmux_libc_timespec_t;
typedef struct tm		mmux_libc_tm_t;

typedef struct iovec		mmux_libc_iovec_t;
#if ((defined HAVE_OPEN_HOW) && (1 == HAVE_OPEN_HOW))
typedef struct open_how		mmux_libc_open_how_t;
#else
typedef struct mmux_libc_open_how_t {
  mmux_standard_uint64_t	flags;
  mmux_standard_uint64_t	mode;
  mmux_standard_uint64_t	resolve;
} mmux_libc_open_how_t;
#endif
typedef struct flock		mmux_libc_flock_t;
typedef fd_set			mmux_libc_fd_set_t;
typedef struct rlimit		mmux_libc_rlimit_t;
typedef struct passwd		mmux_libc_passwd_t;
typedef struct group		mmux_libc_group_t;
typedef struct stat		mmux_libc_stat_t;
typedef struct utimbuf		mmux_libc_utimbuf_t;
typedef struct dirent		mmux_libc_dirent_t;

typedef struct mmux_libc_iovec_array_t {
  mmux_libc_iovec_t *	iova_base;
  mmux_standard_usize_t	iova_len;
} mmux_libc_iovec_array_t;

typedef struct mmux_libc_in_addr_t	{ struct in_addr  value; } mmux_libc_in_addr_t;
typedef struct mmux_libc_insix_addr_t	{ struct in6_addr value; } mmux_libc_insix_addr_t;

typedef struct if_nameindex			mmux_libc_if_nameindex_t;
typedef struct addrinfo				mmux_libc_addrinfo_t;
typedef struct sockaddr				mmux_libc_sockaddr_t;
typedef struct sockaddr_un			mmux_libc_sockaddr_un_t;
typedef struct sockaddr_in			mmux_libc_sockaddr_in_t;
typedef struct sockaddr_in6			mmux_libc_sockaddr_insix_t;
typedef struct hostent				mmux_libc_hostent_t;
typedef struct servent				mmux_libc_servent_t;
typedef struct protoent				mmux_libc_protoent_t;
typedef struct netent				mmux_libc_netent_t;
typedef struct linger				mmux_libc_linger_t;

typedef mmux_libc_in_addr_t *			mmux_libc_in_addr_ptr_t;
typedef mmux_libc_insix_addr_t *		mmux_libc_insix_addr_ptr_t;

typedef mmux_libc_if_nameindex_t *		mmux_libc_if_nameindex_ptr_t;
typedef mmux_libc_addrinfo_t *			mmux_libc_addrinfo_ptr_t;
typedef mmux_libc_sockaddr_t *			mmux_libc_sockaddr_ptr_t;
typedef mmux_libc_sockaddr_un_t *		mmux_libc_sockaddr_un_ptr_t;
typedef mmux_libc_sockaddr_in_t *		mmux_libc_sockaddr_in_ptr_t;
typedef mmux_libc_sockaddr_insix_t *		mmux_libc_sockaddr_insix_ptr_t;
typedef mmux_libc_hostent_t *			mmux_libc_hostent_ptr_t;
typedef mmux_libc_servent_t *			mmux_libc_servent_ptr_t;
typedef mmux_libc_protoent_t *			mmux_libc_protoent_ptr_t;
typedef mmux_libc_netent_t *			mmux_libc_netent_ptr_t;
typedef mmux_libc_linger_t *			mmux_libc_linger_ptr_t;

#include <mmux-cc-libc-typedefs.h>


/** --------------------------------------------------------------------
 ** Global variables.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_private_decl mmux_libc_memory_allocator_t const mmux_libc_default_memory_allocator;
mmux_cc_libc_private_decl mmux_libc_memory_allocator_t const mmux_libc_fake_memory_allocator;

mmux_cc_libc_decl mmux_libc_file_system_pathname_class_t const mmux_libc_file_system_pathname_static_class;
mmux_cc_libc_decl mmux_libc_file_system_pathname_class_t const mmux_libc_file_system_pathname_dynami_class;


/** --------------------------------------------------------------------
 ** Helper macros and functions.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_in_addr_t
mmux_libc_in_addr (struct in_addr value)
{
  return (mmux_libc_in_addr_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_insix_addr_t
mmux_libc_insix_addr (struct in6_addr value)
{
  return (mmux_libc_insix_addr_t) { .value = value };
}


/** --------------------------------------------------------------------
 ** Done.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc-functions.h>
#include <mmux-cc-libc-generics.h>

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* MMUX_CC_LIBC_INTERNALS_H */

/* end of file */
