/*
  Part of: MMUX CC Libc
  Contents: public header file
  Date: Dec  8, 2024

  Abstract

	This is the public  header file of the library, defining  the public API.  It
	must be included in all the code that uses the library.

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

#ifndef MMUX_CC_LIBC_H
#define MMUX_CC_LIBC_H 1

#ifdef __cplusplus
extern "C" {
#endif


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-types.h>
#include <mmux-cc-libc-config.h>
#include <mmux-cc-libc-constants.h>
/* at the end we include mmux-cc-libc-functions.h */


/** --------------------------------------------------------------------
 ** Type definitions.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_dirtream_t { mmux_pointer_t value; } mmux_libc_dirstream_t;

typedef struct mmux_libc_timeval_t  { mmux_uint8_t value[MMUX_LIBC_SIZEOF_TIMEVAL];  } mmux_libc_timeval_t;
typedef struct mmux_libc_timespec_t { mmux_uint8_t value[MMUX_LIBC_SIZEOF_TIMESPEC]; } mmux_libc_timespec_t;
typedef struct mmux_libc_tm_t       { mmux_uint8_t value[MMUX_LIBC_SIZEOF_TM];       } mmux_libc_tm_t;
typedef struct mmux_libc_iovec_t    { mmux_uint8_t value[MMUX_LIBC_SIZEOF_IOVEC];    } mmux_libc_iovec_t;
typedef struct mmux_libc_flock_t    { mmux_uint8_t value[MMUX_LIBC_SIZEOF_FLOCK];    } mmux_libc_flock_t;
typedef struct mmux_libc_fd_set_t   { mmux_uint8_t value[MMUX_LIBC_SIZEOF_FD_SET];   } mmux_libc_fd_set_t;
typedef struct mmux_libc_rlimit_t   { mmux_uint8_t value[MMUX_LIBC_SIZEOF_RLIMIT];   } mmux_libc_rlimit_t;
typedef struct mmux_libc_passwd_t   { mmux_uint8_t value[MMUX_LIBC_SIZEOF_PASSWD];   } mmux_libc_passwd_t;
typedef struct mmux_libc_group_t    { mmux_uint8_t value[MMUX_LIBC_SIZEOF_GROUP];    } mmux_libc_group_t;
typedef struct mmux_libc_utimbuf_t  { mmux_uint8_t value[MMUX_LIBC_SIZEOF_UTIMBUF];  } mmux_libc_utimbuf_t;
typedef struct mmux_libc_open_how_t { mmux_uint8_t value[MMUX_LIBC_SIZEOF_OPEN_HOW]; } mmux_libc_open_how_t;
typedef struct mmux_libc_dirent_t   { mmux_uint8_t value[MMUX_LIBC_SIZEOF_DIRENT];   } mmux_libc_dirent_t;

typedef struct mmux_libc_file_system_stat_t {
  mmux_uint8_t value[MMUX_LIBC_SIZEOF_STAT];
} mmux_libc_file_system_stat_t;

typedef struct mmux_libc_iovec_array_t {
  mmux_libc_iovec_t *	iova_base;
  mmux_standard_usize_t	iova_len;
} mmux_libc_iovec_array_t;

/* This must be big enough to contain any "struct sockaddr_*" value. */
typedef struct mmux_libc_sockaddr_t		{ mmux_uint8_t value[256];                             } mmux_libc_sockaddr_t;

typedef struct mmux_libc_in_addr_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_IN_ADDR];        } mmux_libc_in_addr_t;
typedef struct mmux_libc_insix_addr_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_IN6_ADDR];       } mmux_libc_insix_addr_t;
typedef struct mmux_libc_if_nameindex_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_IF_NAMEINDEX];   } mmux_libc_if_nameindex_t;
typedef struct mmux_libc_addrinfo_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_ADDRINFO];       } mmux_libc_addrinfo_t;
typedef struct mmux_libc_sockaddr_un_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_SOCKADDR_UN];    } mmux_libc_sockaddr_un_t;
typedef struct mmux_libc_sockaddr_in_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_SOCKADDR_IN];    } mmux_libc_sockaddr_in_t;
typedef struct mmux_libc_sockaddr_insix_t	{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_SOCKADDR_IN6];   } mmux_libc_sockaddr_insix_t;
typedef struct mmux_libc_hostent_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_HOSTENT];        } mmux_libc_hostent_t;
typedef struct mmux_libc_servent_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_SERVENT];        } mmux_libc_servent_t;
typedef struct mmux_libc_protoent_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_PROTOENT];       } mmux_libc_protoent_t;
typedef struct mmux_libc_netent_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_NETENT];         } mmux_libc_netent_t;
typedef struct mmux_libc_linger_t		{ mmux_uint8_t value[MMUX_LIBC_SIZEOF_LINGER];         } mmux_libc_linger_t;

typedef mmux_libc_in_addr_t *		mmux_libc_in_addr_ptr_t;
typedef mmux_libc_insix_addr_t *	mmux_libc_insix_addr_ptr_t;
typedef mmux_libc_if_nameindex_t *	mmux_libc_if_nameindex_ptr_t;
typedef mmux_libc_addrinfo_t *		mmux_libc_addrinfo_ptr_t;
typedef mmux_libc_sockaddr_t *		mmux_libc_sockaddr_ptr_t;
typedef mmux_libc_sockaddr_un_t *	mmux_libc_sockaddr_un_ptr_t;
typedef mmux_libc_sockaddr_in_t *	mmux_libc_sockaddr_in_ptr_t;
typedef mmux_libc_sockaddr_insix_t *	mmux_libc_sockaddr_insix_ptr_t;
typedef mmux_libc_hostent_t *		mmux_libc_hostent_ptr_t;
typedef mmux_libc_servent_t *		mmux_libc_servent_ptr_t;
typedef mmux_libc_protoent_t *		mmux_libc_protoent_ptr_t;
typedef mmux_libc_netent_t *		mmux_libc_netent_ptr_t;
typedef mmux_libc_linger_t *		mmux_libc_linger_ptr_t;

#include <mmux-cc-libc-typedefs.h>


/** --------------------------------------------------------------------
 ** Global variables.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl mmux_libc_file_system_pathname_class_t const mmux_libc_file_system_pathname_static_class;
mmux_cc_libc_decl mmux_libc_file_system_pathname_class_t const mmux_libc_file_system_pathname_dynami_class;
mmux_cc_libc_decl mmux_libc_interface_specification_t const * mmux_libc_interface_specification;


/** --------------------------------------------------------------------
 ** Done.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc-functions.h>
#include <mmux-cc-libc-generics.h>

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* MMUX_CC_LIBC_H */

/* end of file */
