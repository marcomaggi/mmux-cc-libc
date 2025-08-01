/*
  Part of: MMUX CC Libc
  Contents: public header file
  Date: Dec 14, 2024

  Abstract

	This header file declares function prototypes.

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

#ifndef MMUX_CC_LIBC_FUNCTIONS_H
#define MMUX_CC_LIBC_FUNCTIONS_H 1


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <stdarg.h>

#define MMUX_LIBC_IGNORE_RETVAL(STATEMENT)	if (STATEMENT) { ; }


/** --------------------------------------------------------------------
 ** Initialisation functions.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_cc_libc_init (void);


/** --------------------------------------------------------------------
 ** Version functions.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl mmux_asciizcp_t	 mmux_cc_libc_version_string		(void);
mmux_cc_libc_decl mmux_sint_t		mmux_cc_libc_version_interface_current	(void);
mmux_cc_libc_decl mmux_sint_t		mmux_cc_libc_version_interface_revision	(void);
mmux_cc_libc_decl mmux_sint_t		mmux_cc_libc_version_interface_age	(void);


/** --------------------------------------------------------------------
 ** Errors.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_errno_ref (mmux_sint_t * result_errnum_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_errno_set (mmux_sint_t errnum);

mmux_cc_libc_decl bool mmux_libc_errno_consume (mmux_sint_t * result_errnum_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_strerror (mmux_asciizcp_t * result_error_message_p, mmux_sint_t errnum)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_strerror_r (mmux_asciizcpp_t result_p,
					     mmux_asciizp_t bufptr, mmux_usize_t buflen,
					     mmux_sint_t errnum)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strerrorname_np (mmux_asciizcpp_t result_p, mmux_sint_t errnum)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_strerrordesc_np (mmux_asciizcpp_t result_p, mmux_sint_t errnum)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_program_invocation_name (mmux_asciizcpp_t result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_program_invocation_short_name (mmux_asciizcpp_t result_p)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Strings.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_strlen (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strlen_plus_nil (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strnlen (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr, mmux_usize_t maxlen)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strcpy (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strncpy (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_stpcpy(mmux_asciizp_t * result_after_ptr_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_stpncpy(mmux_asciizp_t * result_after_ptr_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strdup (mmux_asciizcp_t * result_oustr_p, mmux_asciizcp_t instr)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strndup (mmux_asciizcp_t * result_oustr_p, mmux_asciizcp_t instr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strcat (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strncat (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strcmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strncmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strcasecmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strncasecmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strverscmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strcoll (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strxfrm (mmux_usize_t * result_size_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strchr (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_schar_t schar)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strchrnul (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_schar_t schar)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strrchr (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_schar_t schar)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strstr (mmux_asciizcp_t * result_p, mmux_asciizcp_t haystack, mmux_asciizcp_t needle)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strcasestr (mmux_asciizcp_t * result_p, mmux_asciizcp_t haystack, mmux_asciizcp_t needle)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strspn (mmux_usize_t * result_len_p, mmux_asciizcp_t str, mmux_asciizcp_t skipset)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strcspn (mmux_usize_t * result_len_p, mmux_asciizcp_t str, mmux_asciizcp_t stopset)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strpbrk (mmux_asciizcp_t * result_p, mmux_asciizcp_t str, mmux_asciizcp_t stopset)
  __attribute__((__nonnull__(1,2,3)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strtok (mmux_asciizcp_t * result_p, mmux_asciizp_t newstring, mmux_asciizcp_t delimiters)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_basename (mmux_asciizcp_t * result_p, mmux_asciizcp_t pathname)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_dirname (mmux_asciizcp_t * result_p, mmux_asciizcp_t pathname)
  __attribute__((__nonnull__(1,2)));


/** --------------------------------------------------------------------
 ** Characters.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_islower (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isupper (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isalpha (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isdigit (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isalnum (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isxdigit (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ispunct (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isspace (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isblank (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isgraph (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isprint (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_iscntrl (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isascii (bool * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_tolower (mmux_schar_t * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_toupper (mmux_schar_t * result_p, mmux_schar_t ch)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Memory.
 ** ----------------------------------------------------------------- */

#define mmux_libc_malloc(P_P,LEN)		mmux_libc_malloc_((mmux_pointer_t *)(P_P),(LEN))
#define mmux_libc_calloc(P_P,INUM,ILEN)		mmux_libc_calloc_((mmux_pointer_t *)(P_P),(INUM),(ILEN))
#define mmux_libc_realloc(P_P,LEN)		mmux_libc_realloc_((mmux_pointer_t *)(P_P),(LEN))
#define mmux_libc_reallocarray(P_P,INUM,ILEN)	mmux_libc_reallocarray_((mmux_pointer_t *)(P_P),(INUM),(ILEN))

mmux_cc_libc_decl bool mmux_libc_malloc_ (mmux_pointer_t * P_p, mmux_usize_t len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_calloc_ (mmux_pointer_t * P_p, mmux_usize_t item_num, mmux_usize_t item_len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_realloc_ (mmux_pointer_t * P_p, mmux_usize_t newlen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_reallocarray_ (mmux_pointer_t * P_p, mmux_usize_t item_num, mmux_usize_t item_len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_free (mmux_pointer_t p)
  __attribute__((__nonnull__));

mmux_cc_libc_decl bool mmux_libc_memset (mmux_pointer_t ptr, mmux_uint8_t octet, mmux_usize_t len)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_memzero (mmux_pointer_t ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_memcpy (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_mempcpy (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_memccpy (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr,
					  mmux_uint8_t octet, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_memmove (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_memcmp (mmux_sint_t * result_p, mmux_pointerc_t ptr1, mmux_pointerc_t ptr2, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_memchr (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_rawmemchr (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_memrchr (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_memmem (mmux_pointer_t * result_p,
					 mmux_pointer_t haystack_ptr, mmux_usize_t haystack_len,
					 mmux_pointer_t needle_ptr,   mmux_usize_t needle_len)
  __attribute__((__nonnull__(1,2,4)));


/** --------------------------------------------------------------------
 ** Times and dates: mmux_libc_timeval_t.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(timeval,	tv_sec,		mmux_time_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(timeval,	tv_usec,	mmux_slong_t)

mmux_cc_libc_decl bool mmux_libc_timeval_set (mmux_libc_timeval_t * timeval_p, mmux_time_t seconds, mmux_slong_t microseconds)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_timeval_dump (mmux_libc_file_descriptor_t fd, mmux_libc_timeval_t const * timeval_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));


/** --------------------------------------------------------------------
 ** Times and dates: mmux_libc_timespec_t.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(timespec,	ts_sec,		mmux_time_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(timespec,	ts_nsec,	mmux_slong_t)

mmux_cc_libc_decl bool mmux_libc_timespec_set (mmux_libc_timespec_t * timespec_p, mmux_time_t seconds, mmux_slong_t nanoseconds)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_timespec_dump (mmux_libc_file_descriptor_t fd, mmux_libc_timespec_t const * timespec_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));


/** --------------------------------------------------------------------
 ** Times and dates: mmux_libc_tm_t.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_sec,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_min,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_hour,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_mday,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_mon,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_year,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_wday,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_yday,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_isdst,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_gmtoff,	mmux_slong_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(tm,	tm_zone,	mmux_asciizcp_t)

mmux_cc_libc_decl bool mmux_libc_tm_dump (mmux_libc_file_descriptor_t fd, mmux_libc_tm_t const * tm_p,
					  mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_tm_reset (mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Times and dates: functions.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_time      (mmux_time_t * result_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_localtime   (mmux_libc_tm_t * * result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_localtime_r (mmux_libc_tm_t * result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gmtime      (mmux_libc_tm_t * * result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gmtime_r    (mmux_libc_tm_t * result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ctime       (mmux_asciizcpp_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ctime_r     (mmux_asciizp_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_mktime    (mmux_time_t * result_p, mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_timegm    (mmux_time_t * result_p, mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_asctime   (mmux_asciizcp_t * result_p, mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_asctime_r (mmux_asciizp_t result_p, mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strftime_required_nbytes_including_nil (mmux_usize_t * required_nbytes_including_nil_p,
									 mmux_asciizcp_t template, mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(1,2),__format__(__strftime__,2,0)));

mmux_cc_libc_decl bool mmux_libc_strftime (mmux_usize_t * required_nbytes_without_zero_p,
					   mmux_asciizp_t bufptr, mmux_usize_t buflen,
					   mmux_asciizcp_t template, mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(1,2,4,5),__format__(__strftime__,4,0),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strptime (char ** first_unprocessed_after_timestamp_p,
					   mmux_asciizcp_t input_string, mmux_asciizcp_t template, mmux_libc_tm_t * tm_p)
  __attribute__((__nonnull__(2,3,4),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sleep     (mmux_uint_t * result_p, mmux_uint_t seconds)
       __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_nanosleep (mmux_libc_timespec_t * requested_time, mmux_libc_timespec_t * remaining_time)
  __attribute__((__nonnull__(1,2)));


/** --------------------------------------------------------------------
 ** Input/output: file descriptor core API.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_make_fd (mmux_libc_file_descriptor_t * result_p, mmux_sint_t fd_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_stdin (mmux_libc_file_descriptor_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_stdou (mmux_libc_file_descriptor_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_stder (mmux_libc_file_descriptor_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_at_fdcwd (mmux_libc_file_descriptor_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_fd_equal (mmux_libc_fd_t one, mmux_libc_fd_t two);

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_fd_parse (mmux_libc_fd_t * p_value, mmux_asciizcp_t s_value, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fd_sprint (char * ptr, mmux_usize_t len, mmux_libc_fd_t fd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fd_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_fd_t fd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_dprintf (mmux_libc_file_descriptor_t fd, mmux_asciizcp_t template, ...)
  __attribute__((__nonnull__(2),__format__(__printf__,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfou (mmux_asciizcp_t template, ...)
  __attribute__((__nonnull__(1),__format__(__printf__,1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfer (mmux_asciizcp_t template, ...)
  __attribute__((__nonnull__(1),__format__(__printf__,1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_strerror (mmux_libc_fd_t fd, mmux_sint_t errnum)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_strftime (mmux_libc_fd_t fd, mmux_asciizcp_t template, mmux_libc_tm_t * BT)
  __attribute__((__nonnull__(2,3),__warn_unused_result__,__format__(__strftime__,2,0)));

mmux_cc_libc_decl bool mmux_libc_vdprintf (mmux_libc_file_descriptor_t fd, mmux_asciizcp_t template, va_list ap)
  __attribute__((__nonnull__(2),__format__(__printf__,2,0),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_vdprintfou (mmux_asciizcp_t template, va_list ap)
  __attribute__((__nonnull__(1),__format__(__printf__,1,0),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_vdprintfer (mmux_asciizcp_t template, va_list ap)
  __attribute__((__nonnull__(1),__format__(__printf__,1,0),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_newline   (mmux_libc_file_descriptor_t fd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfou_newline (void)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfer_newline (void)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_open (mmux_libc_file_descriptor_t * fd, mmux_libc_file_system_pathname_t pathname,
				       mmux_sint_t flags, mmux_mode_t mode)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_openat (mmux_libc_file_descriptor_t * fd, mmux_libc_file_descriptor_t dirfd,
					 mmux_libc_file_system_pathname_t pathname, mmux_sint_t flags, mmux_mode_t mode)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_open_how_flags_set (mmux_libc_open_how_t * const P, mmux_uint64_t value)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_open_how_flags_ref (mmux_uint64_t * result_p, mmux_libc_open_how_t const * const P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_open_how_mode_set (mmux_libc_open_how_t * const P, mmux_uint64_t value)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_open_how_mode_ref (mmux_uint64_t * result_p, mmux_libc_open_how_t const * const P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_open_how_resolve_set (mmux_libc_open_how_t * const P, mmux_uint64_t value)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_open_how_resolve_ref (mmux_uint64_t * result_p, mmux_libc_open_how_t const * const P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_open_how_dump (mmux_libc_file_descriptor_t fd, mmux_libc_open_how_t const * const open_how_p,
						char const * struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_openat2 (mmux_libc_file_descriptor_t * fd, mmux_libc_file_descriptor_t dirfd,
					  mmux_libc_file_system_pathname_t pathname, mmux_libc_open_how_t const * const how_p)
  __attribute__((__nonnull__(1,4),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_close (mmux_libc_file_descriptor_t fd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_read (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd,
				       mmux_pointer_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd,
					mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write_buffer (mmux_libc_fd_t fd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write_buffer_to_stdou (mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write_buffer_to_stder (mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pread (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd,
					mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_off_t offset)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pwrite (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd,
					 mmux_pointerc_t bufptr, mmux_usize_t buflen, mmux_off_t offset)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lseek (mmux_libc_file_descriptor_t fd, mmux_off_t * offset_p, mmux_sint_t whence)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dup (mmux_libc_file_descriptor_t * new_fd_p, mmux_libc_file_descriptor_t old_fd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dup2 (mmux_libc_file_descriptor_t old_fd, mmux_libc_file_descriptor_t new_fd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dup3 (mmux_libc_file_descriptor_t old_fd, mmux_libc_file_descriptor_t new_fd, mmux_sint_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pipe (mmux_libc_file_descriptor_t fds[2])
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_close_pipe (mmux_libc_file_descriptor_t fds[2])
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: selecting file descriptors.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_FD_ZERO  (mmux_libc_fd_set_t * fd_set_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_FD_SET   (mmux_libc_file_descriptor_t fd, mmux_libc_fd_set_t * fd_set_p)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_FD_CLR   (mmux_libc_file_descriptor_t fd, mmux_libc_fd_set_t * fd_set_p)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_FD_ISSET (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_fd_set_t const * fd_set_p)
  __attribute__((__nonnull__(1,3)));

mmux_cc_libc_decl bool mmux_libc_select (mmux_uint_t * nfds_ready,
					 mmux_uint_t maximum_nfds_to_check,
					 mmux_libc_fd_set_t * read_fd_set_p,
					 mmux_libc_fd_set_t * write_fd_set_p,
					 mmux_libc_fd_set_t * except_fd_set_p,
					 mmux_libc_timeval_t * timeout_p)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_select_fd_for_reading (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_timeval_t * timeout_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_select_fd_for_writing (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_timeval_t * timeout_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_select_fd_for_exception (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_timeval_t * timeout_p)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Input/output: file descriptor scatter-gather API.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec,	iov_base,	mmux_pointer_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec,	iov_len,	mmux_usize_t)

mmux_cc_libc_decl bool mmux_libc_iovec_dump (mmux_libc_file_descriptor_t fd, mmux_libc_iovec_t const * iovec_p,
					     mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec_array,	iova_base,	mmux_libc_iovec_t *)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec_array,	iova_len,	mmux_usize_t)

mmux_cc_libc_decl bool mmux_libc_iovec_array_dump (mmux_libc_file_descriptor_t fd, mmux_libc_iovec_array_t const * iova_p,
						   mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_readv (mmux_usize_t * nbytes_read_p, mmux_libc_file_descriptor_t fd,
					mmux_libc_iovec_array_t * iova_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_writev (mmux_usize_t * nbytes_written_p, mmux_libc_file_descriptor_t fd,
					 mmux_libc_iovec_array_t * iova_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_preadv (mmux_usize_t * nbytes_read_p, mmux_libc_file_descriptor_t fd,
					 mmux_libc_iovec_array_t * iova_p, mmux_off_t offset)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pwritev (mmux_usize_t * nbytes_written_p, mmux_libc_file_descriptor_t fd,
					  mmux_libc_iovec_array_t * iova_p, mmux_off_t offset)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_preadv2 (mmux_usize_t * nbytes_read_p, mmux_libc_file_descriptor_t fd,
					  mmux_libc_iovec_array_t * iova_p, mmux_off_t offset, mmux_sint_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pwritev2 (mmux_usize_t * nbytes_written_p, mmux_libc_file_descriptor_t fd,
					   mmux_libc_iovec_array_t * iova_p, mmux_off_t offset, mmux_sint_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: file locking API.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(flock,	l_type,		mmux_sshort_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(flock,	l_whence,	mmux_sshort_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(flock,	l_start,	mmux_off_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(flock,	l_len,		mmux_off_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(flock,	l_pid,		mmux_libc_pid_t)

mmux_cc_libc_decl bool mmux_libc_flock_dump (mmux_libc_file_descriptor_t fd, mmux_libc_flock_t const * flock_p, mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_flag_to_symbol_struct_flock_l_type (mmux_asciizcp_t* str_p, mmux_sint_t flag)
  __attribute__((__nonnull__(1),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: file locking API.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_copy_file_range (mmux_usize_t * number_of_bytes_copied_p,
						  mmux_libc_file_descriptor_t input_fd, mmux_sint64_t * input_position_p,
						  mmux_libc_file_descriptor_t ouput_fd, mmux_sint64_t * ouput_position_p,
						  mmux_usize_t number_of_bytes_to_copy, mmux_sint_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: control.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_fcntl (mmux_libc_file_descriptor_t fd, mmux_sint_t command, mmux_pointer_t parameter_p)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fcntl_command_flag_to_symbol (mmux_asciizcp_t* str_p, mmux_sint_t flag)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_ioctl (mmux_libc_file_descriptor_t fd, mmux_sint_t command, mmux_pointer_t parameter_p)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Memfd buffers.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_memfd_create (mmux_libc_file_descriptor_t * fd_p, mmux_asciizcp_t name, mmux_sint_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_memfd (mmux_libc_file_descriptor_t * fd_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_length (mmux_usize_t * len_p, mmux_libc_file_descriptor_t fd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_write_buffer (mmux_libc_file_descriptor_t mfd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_write_asciiz (mmux_libc_file_descriptor_t mfd, mmux_asciizcp_t bufptr)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_copy (mmux_libc_file_descriptor_t ou, mmux_libc_file_descriptor_t mfd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_copyou (mmux_libc_file_descriptor_t mfd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_copyer (mmux_libc_file_descriptor_t mfd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_strerror (mmux_libc_fd_t mfd, mmux_sint_t errnum)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_read_buffer (mmux_libc_fd_t mfd, mmux_pointer_t bufptr, mmux_usize_t maximum_buflen)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Printing types.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_PRINTER_PROTO]]],
  [[[MMUX_CONDITIONAL_CODE([[[$2]]],[[[mmux_cc_libc_decl bool mmux_libc_dprintf_$1 (mmux_libc_file_descriptor_t fd, mmux_$1_t value)
  __attribute__((__warn_unused_result__));]]])]]])

DEFINE_PRINTER_PROTO([[[pointer]]])

DEFINE_PRINTER_PROTO([[[schar]]])
DEFINE_PRINTER_PROTO([[[uchar]]])
DEFINE_PRINTER_PROTO([[[sshort]]])
DEFINE_PRINTER_PROTO([[[ushort]]])
DEFINE_PRINTER_PROTO([[[sint]]])
DEFINE_PRINTER_PROTO([[[uint]]])
DEFINE_PRINTER_PROTO([[[slong]]])
DEFINE_PRINTER_PROTO([[[ulong]]])
DEFINE_PRINTER_PROTO([[[sllong]]],		[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
DEFINE_PRINTER_PROTO([[[ullong]]],		[[[MMUX_HAVE_CC_TYPE_ULLONG]]])

DEFINE_PRINTER_PROTO([[[sint8]]])
DEFINE_PRINTER_PROTO([[[uint8]]])
DEFINE_PRINTER_PROTO([[[sint16]]])
DEFINE_PRINTER_PROTO([[[uint16]]])
DEFINE_PRINTER_PROTO([[[sint32]]])
DEFINE_PRINTER_PROTO([[[uint32]]])
DEFINE_PRINTER_PROTO([[[sint64]]])
DEFINE_PRINTER_PROTO([[[uint64]]])

DEFINE_PRINTER_PROTO([[[float]]])
DEFINE_PRINTER_PROTO([[[double]]])
DEFINE_PRINTER_PROTO([[[ldouble]]],		[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_PRINTER_PROTO([[[float32]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
DEFINE_PRINTER_PROTO([[[float64]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
DEFINE_PRINTER_PROTO([[[float128]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

DEFINE_PRINTER_PROTO([[[float32x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
DEFINE_PRINTER_PROTO([[[float64x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
DEFINE_PRINTER_PROTO([[[float128x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

DEFINE_PRINTER_PROTO([[[decimal32]]],		[[[MMUX_HAVE_CC_TYPE_DECIMAL32]]])
DEFINE_PRINTER_PROTO([[[decimal64]]],		[[[MMUX_HAVE_CC_TYPE_DECIMAL64]]])
DEFINE_PRINTER_PROTO([[[decimal128]]],	[[[MMUX_HAVE_CC_TYPE_DECIMAL128]]])

DEFINE_PRINTER_PROTO([[[complexf]]])
DEFINE_PRINTER_PROTO([[[complexd]]])
DEFINE_PRINTER_PROTO([[[complexld]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXLD]]])

DEFINE_PRINTER_PROTO([[[complexf32]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])
DEFINE_PRINTER_PROTO([[[complexf64]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])
DEFINE_PRINTER_PROTO([[[complexf128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

DEFINE_PRINTER_PROTO([[[complexf32x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])
DEFINE_PRINTER_PROTO([[[complexf64x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])
DEFINE_PRINTER_PROTO([[[complexf128x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])

DEFINE_PRINTER_PROTO([[[complexd32]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD32]]])
DEFINE_PRINTER_PROTO([[[complexd64]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD64]]])
DEFINE_PRINTER_PROTO([[[complexd128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD128]]])

DEFINE_PRINTER_PROTO([[[usize]]])
DEFINE_PRINTER_PROTO([[[ssize]]])

DEFINE_PRINTER_PROTO([[[sintmax]]])
DEFINE_PRINTER_PROTO([[[uintmax]]])
DEFINE_PRINTER_PROTO([[[sintptr]]])
DEFINE_PRINTER_PROTO([[[uintptr]]])
DEFINE_PRINTER_PROTO([[[ptrdiff]]])
DEFINE_PRINTER_PROTO([[[mode]]])
DEFINE_PRINTER_PROTO([[[off]]])
DEFINE_PRINTER_PROTO([[[pid]]])
DEFINE_PRINTER_PROTO([[[uid]]])
DEFINE_PRINTER_PROTO([[[gid]]])
DEFINE_PRINTER_PROTO([[[wchar]]])
DEFINE_PRINTER_PROTO([[[wint]]])
DEFINE_PRINTER_PROTO([[[time]]])
DEFINE_PRINTER_PROTO([[[socklen]]])
DEFINE_PRINTER_PROTO([[[rlim]]])

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_fd (mmux_libc_file_descriptor_t fd, mmux_libc_file_descriptor_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_pid (mmux_libc_file_descriptor_t fd, mmux_libc_pid_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_uid (mmux_libc_file_descriptor_t fd, mmux_libc_uid_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_gid (mmux_libc_file_descriptor_t fd, mmux_libc_gid_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_ptn (mmux_libc_file_descriptor_t fd, mmux_libc_file_system_pathname_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_ptn_extension (mmux_libc_fd_t fd, mmux_libc_ptn_extension_t E)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_ptn_segment (mmux_libc_fd_t fd, mmux_libc_ptn_segment_t E)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_completed_process_status (mmux_libc_file_descriptor_t fd,
									mmux_libc_completed_process_status_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_libc_interprocess_signal (mmux_libc_file_descriptor_t fd,
								   mmux_libc_interprocess_signal_t value)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** System configuration.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_sysconf (mmux_slong_t * result_p, mmux_sint_t parameter)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_confstr_size (mmux_usize_t * required_nbytes_p, mmux_sint_t parameter);
mmux_cc_libc_decl bool mmux_libc_confstr (mmux_sint_t parameter, char * bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_pathconf (mmux_slong_t * result_p, mmux_libc_file_system_pathname_t pathname, mmux_sint_t parameter)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fpathconf (mmux_slong_t * result_p, mmux_libc_file_descriptor_t fd, mmux_sint_t parameter)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(rlimit,	rlim_cur,	mmux_rlim_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(rlimit,	rlim_max,	mmux_rlim_t)

mmux_cc_libc_decl bool mmux_libc_rlimit_dump (mmux_libc_file_descriptor_t fd, mmux_libc_rlimit_t * rlimit_pointer,
					      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_getrlimit (mmux_sint_t resource, mmux_libc_rlimit_t * rlimit_p)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setrlimit (mmux_sint_t resource, mmux_libc_rlimit_t * rlimit_p)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_prlimit (mmux_libc_pid_t pid, mmux_sint_t resource,
					  mmux_libc_rlimit_t * new_rlimit_p, mmux_libc_rlimit_t * old_rlimit_p)
  __attribute__((__nonnull__(3,4),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Processes.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_make_pid (mmux_libc_pid_t * result_p, mmux_pid_t pid_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_pid_zero (mmux_libc_pid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_pid_minus_one (mmux_libc_pid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_pid_equal (mmux_libc_pid_t one, mmux_libc_pid_t two);

mmux_cc_libc_decl bool mmux_libc_pid_parse (mmux_libc_pid_t * p_value, mmux_asciizcp_t s_value, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_pid_sprint (char * ptr, mmux_usize_t len, mmux_libc_pid_t pid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pid_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_pid_t pid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_completed_process_status (mmux_libc_completed_process_status_t * result_p, mmux_sint_t status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_completed_process_status_equal (mmux_libc_completed_process_status_t one,
								 mmux_libc_completed_process_status_t two);

mmux_cc_libc_decl bool mmux_libc_completed_process_status_parse (mmux_libc_completed_process_status_t * p_value,
								 mmux_asciizcp_t s_value, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_completed_process_status_sprint (char * ptr, mmux_usize_t len,
								  mmux_libc_completed_process_status_t pid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_completed_process_status_sprint_size (mmux_usize_t * required_nchars_p,
								       mmux_libc_completed_process_status_t pid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getpid  (mmux_libc_pid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getppid (mmux_libc_pid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gettid (mmux_libc_pid_t * result_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_fork (bool * this_is_the_parent_process_p, mmux_libc_pid_t * child_process_pid_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_wait_any_process (bool * completed_process_status_available_p,
						   mmux_libc_pid_t * completed_process_pid_p,
						   mmux_libc_completed_process_status_t * completed_process_status_p,
						   mmux_sint_t options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait_my_process_group (bool * completed_process_status_available_p,
							mmux_libc_pid_t * completed_process_pid_p,
							mmux_libc_completed_process_status_t * completed_process_status_p,
							mmux_sint_t options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait_process_id (bool * completed_process_status_available_p,
						  mmux_libc_pid_t * completed_process_pid_p,
						  mmux_libc_completed_process_status_t * completed_process_status_p,
						  mmux_libc_pid_t pid, mmux_sint_t options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait_group_id (bool * completed_process_status_available_p,
						mmux_libc_pid_t * completed_process_pid_p,
						mmux_libc_completed_process_status_t * completed_process_status_p,
						mmux_libc_gid_t gid, mmux_sint_t options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait (bool * completed_process_status_available_p,
				       mmux_libc_pid_t * completed_process_pid_p,
				       mmux_libc_completed_process_status_t * completed_process_status_p)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_WIFEXITED (bool * result_p, mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WEXITSTATUS (mmux_sint_t * result_p, mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WIFSIGNALED (bool * result_p, mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WTERMSIG (mmux_libc_interprocess_signal_t * result_p,
					   mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WCOREDUMP (bool * result_p, mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WIFSTOPPED (bool * result_p, mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WSTOPSIG (mmux_libc_interprocess_signal_t * result_p,
					   mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WIFCONTINUED (bool * result_p,
					       mmux_libc_completed_process_status_t completed_process_status)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_exit (mmux_sint_t status)
  __attribute__((__noreturn__));
mmux_cc_libc_decl bool mmux_libc_exit_success (void)
  __attribute__((__noreturn__));
mmux_cc_libc_decl bool mmux_libc_exit_failure (void)
  __attribute__((__noreturn__));

mmux_cc_libc_decl bool mmux_libc__exit (mmux_sint_t status)
  __attribute__((__noreturn__));

mmux_cc_libc_decl bool mmux_libc_atexit (void (*function_pointer) (void));

mmux_cc_libc_decl bool mmux_libc_abort (void)
  __attribute__((__noreturn__));


/** --------------------------------------------------------------------
 ** Interprocess signals.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_make_interprocess_signal (mmux_libc_interprocess_signal_t * result_p, mmux_sint_t signal_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_interprocess_signal_equal (mmux_libc_interprocess_signal_t one, mmux_libc_interprocess_signal_t two);

mmux_cc_libc_decl bool mmux_libc_interprocess_signal_parse (mmux_libc_interprocess_signal_t * p_value, mmux_asciizcp_t s_value, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_interprocess_signal_sprint (char * ptr, mmux_usize_t len, mmux_libc_interprocess_signal_t signum)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_interprocess_signal_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_interprocess_signal_t signum)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_raise (mmux_libc_interprocess_signal_t ipxsignal)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_kill (mmux_libc_pid_t pid, mmux_libc_interprocess_signal_t ipxsignal)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_kill_all_processes_in_same_group (mmux_libc_interprocess_signal_t ipxsignal)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_kill_group (mmux_libc_gid_t gid, mmux_libc_interprocess_signal_t ipxsignal)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_kill_all_processes (mmux_libc_interprocess_signal_t ipxsignal)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_tgkill (mmux_libc_pid_t pid, mmux_libc_pid_t tid, mmux_libc_interprocess_signal_t ipxsignal)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_bub_init (void)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_bub_final (void)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_bub_acquire (void)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_bub_delivered (bool * result_p, mmux_libc_interprocess_signal_t ipxsignal)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_retrieve_signal_handler_SIG_DFL (mmux_libc_sighandler_t ** result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_retrieve_signal_handler_SIG_IGN (mmux_libc_sighandler_t ** result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_retrieve_signal_handler_SIG_ERR (mmux_libc_sighandler_t ** result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_signal (mmux_libc_sighandler_t ** result_p, mmux_libc_interprocess_signal_t ipxsignal,
					 mmux_libc_sighandler_t action)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pause (void)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Persona.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(passwd,	pw_name,	mmux_asciizcp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(passwd,	pw_passwd,	mmux_asciizcp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(passwd,	pw_uid,		mmux_libc_uid_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(passwd,	pw_gid,		mmux_libc_gid_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(passwd,	pw_gecos,	mmux_asciizcp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(passwd,	pw_dir,		mmux_asciizcp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(passwd,	pw_shell,	mmux_asciizcp_t)

mmux_cc_libc_decl bool mmux_libc_passwd_dump (mmux_libc_file_descriptor_t fd, mmux_libc_passwd_t const * passw_p,
					      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

DEFINE_STRUCT_SETTER_GETTER_PROTOS(group,	gr_name,	mmux_asciizcp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(group,	gr_gid,		mmux_libc_gid_t)

mmux_cc_libc_decl bool mmux_libc_gr_mem_set (mmux_libc_group_t * const P, mmux_asciizcp_t * value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gr_mem_ref (mmux_asciizcp_t * * result_p, mmux_libc_group_t const * const P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_group_dump (mmux_libc_file_descriptor_t fd, mmux_libc_group_t const * passw_p,
					     mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_uid (mmux_libc_uid_t * result_p, mmux_uid_t uid_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_uid_parse (mmux_libc_uid_t * p_value, mmux_asciizcp_t s_value, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_uid_sprint (char * ptr, mmux_usize_t len, mmux_libc_uid_t uid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_uid_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_uid_t uid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_gid (mmux_libc_gid_t * result_p, mmux_gid_t gid_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gid_parse (mmux_libc_gid_t * p_value, mmux_asciizcp_t s_value, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_gid_sprint (char * ptr, mmux_usize_t len, mmux_libc_gid_t gid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_gid_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_gid_t gid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getuid (mmux_libc_uid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getgid (mmux_libc_gid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_geteuid (mmux_libc_uid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getegid (mmux_libc_gid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getgroups_size (mmux_usize_t * ngroups_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getgroups (mmux_usize_t * ngroups_p, mmux_libc_gid_t * groups_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getgrouplist_size (mmux_usize_t * result_ngroups_p, mmux_asciizcp_t username, mmux_libc_gid_t gid)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getgrouplist (mmux_asciizcp_t username, mmux_libc_gid_t gid,
					       mmux_usize_t * ngroups_p, mmux_libc_gid_t * groups_p)
  __attribute__((__nonnull__(1,3,4),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_setuid   (mmux_libc_uid_t uid)
    __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_seteuid  (mmux_libc_uid_t uid)
    __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setreuid (mmux_libc_uid_t uid, mmux_libc_uid_t euid)
    __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setgid   (mmux_libc_gid_t gid)
    __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setegid  (mmux_libc_gid_t gid)
    __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setregid (mmux_libc_gid_t gid, mmux_libc_gid_t egid)
    __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getlogin (mmux_asciizcpp_t username_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getlogin_r (mmux_asciizp_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getpwuid (mmux_libc_passwd_t * * result_passwd_pp, mmux_libc_uid_t uid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getpwnam (mmux_libc_passwd_t * * result_passwd_pp, mmux_asciizcp_t username)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getgrgid (mmux_libc_group_t * * result_group_pp, mmux_libc_gid_t gid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getgrnam (mmux_libc_group_t * * result_group_pp, mmux_asciizcp_t username)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_group_member (bool * result_is_member_p, mmux_libc_gid_t gid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setpwent (void);
mmux_cc_libc_decl bool mmux_libc_endpwent (void);
mmux_cc_libc_decl bool mmux_libc_getpwent (mmux_libc_passwd_t * * result_passwd_pp)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_setgrent (void);
mmux_cc_libc_decl bool mmux_libc_endgrent (void);
mmux_cc_libc_decl bool mmux_libc_getgrent (mmux_libc_group_t * * result_group_pp)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** File system.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_d_name_ref (mmux_asciizcpp_t result_p, mmux_libc_dirent_t const * DE)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_d_fileno_ref (mmux_uintmax_t * result_p, mmux_libc_dirent_t const * DE)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_dirent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_dirent_t const * dirent_p,
					      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname (mmux_libc_file_system_pathname_t * pathname_p,
							    mmux_asciizcp_t asciiz_pathname)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_ptr_ref (mmux_asciizcp_t * result_p,
							       mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_len_ref (mmux_usize_t * result_p,
							       mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_malloc (mmux_libc_file_system_pathname_t * pathname_p,
								   mmux_asciizcp_t asciiz_pathname)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_malloc_from_buffer
  (mmux_libc_file_system_pathname_t * pathname_p, mmux_asciizcp_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_free (mmux_libc_file_system_pathname_t pathname);

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_compare (mmux_sint_t * result_p,
							       mmux_libc_file_system_pathname_t ptn1,
							       mmux_libc_file_system_pathname_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_equal (bool * result_p,
							     mmux_libc_file_system_pathname_t ptn1,
							     mmux_libc_file_system_pathname_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_not_equal (bool * result_p,
								 mmux_libc_file_system_pathname_t ptn1,
								 mmux_libc_file_system_pathname_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_less (bool * result_p,
							    mmux_libc_file_system_pathname_t ptn1,
							    mmux_libc_file_system_pathname_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_greater (bool * result_p,
							       mmux_libc_file_system_pathname_t ptn1,
							       mmux_libc_file_system_pathname_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_less_equal (bool * result_p,
								  mmux_libc_file_system_pathname_t ptn1,
								  mmux_libc_file_system_pathname_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_greater_equal (bool * result_p,
								     mmux_libc_file_system_pathname_t ptn1,
								     mmux_libc_file_system_pathname_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_special_directory (bool * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_standalone_dot (bool * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_standalone_double_dot (bool * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_standalone_slash (bool * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_absolute (bool * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_relative (bool * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_rootname (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_dirname (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_tailname (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_filename (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_normalised (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_extension (mmux_libc_ptn_extension_t * result_p,
								      mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_extension_raw (mmux_libc_ptn_extension_t * result_p,
									  mmux_asciizcp_t ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_extension_raw_asciiz (mmux_libc_ptn_extension_t * result_p,
										 mmux_asciizcp_t ptr)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_ptr_ref (mmux_asciizcpp_t result_p,
									 mmux_libc_file_system_pathname_extension_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_len_ref (mmux_usize_t * result_p,
									 mmux_libc_file_system_pathname_extension_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_is_empty (bool * result_p,
									  mmux_libc_ptn_extension_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_has_extension (bool * result_p,
								     mmux_libc_ptn_t ptn, mmux_libc_ptn_extension_t ext)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_compare (mmux_sint_t * result_p,
									 mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
  __attribute__((__nonnull__(1)));

typedef bool mmux_libc_file_system_pathname_extension_comparison_predicate_t (bool * result_p,
									      mmux_libc_ptn_extension_t E1,
									      mmux_libc_ptn_extension_t E2);

mmux_cc_libc_decl mmux_libc_file_system_pathname_extension_comparison_predicate_t mmux_libc_file_system_pathname_extension_equal
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_extension_comparison_predicate_t mmux_libc_file_system_pathname_extension_not_equal
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_extension_comparison_predicate_t mmux_libc_file_system_pathname_extension_less
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_extension_comparison_predicate_t mmux_libc_file_system_pathname_extension_greater
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_extension_comparison_predicate_t mmux_libc_file_system_pathname_extension_less_equal
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_extension_comparison_predicate_t mmux_libc_file_system_pathname_extension_greater_equal
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_segment_raw (mmux_libc_ptn_segment_t * result_p,
									mmux_asciizcp_t ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_segment_raw_asciiz (mmux_libc_ptn_segment_t * result_p,
									       mmux_asciizcp_t ptr)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_find_last (mmux_libc_ptn_segment_t * result_p, mmux_libc_ptn_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_ptr_ref (mmux_asciizcpp_t result_p,
								       mmux_libc_file_system_pathname_segment_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_len_ref (mmux_usize_t * result_p,
								       mmux_libc_file_system_pathname_segment_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_compare (mmux_sint_t * result_p,
								       mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
  __attribute__((__nonnull__(1)));

typedef bool mmux_libc_file_system_pathname_segment_comparison_predicate_t (bool * result_p,
									      mmux_libc_ptn_segment_t E1,
									      mmux_libc_ptn_segment_t E2);

mmux_cc_libc_decl mmux_libc_file_system_pathname_segment_comparison_predicate_t mmux_libc_file_system_pathname_segment_equal
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_segment_comparison_predicate_t mmux_libc_file_system_pathname_segment_not_equal
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_segment_comparison_predicate_t mmux_libc_file_system_pathname_segment_less
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_segment_comparison_predicate_t mmux_libc_file_system_pathname_segment_greater
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_segment_comparison_predicate_t mmux_libc_file_system_pathname_segment_less_equal
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl mmux_libc_file_system_pathname_segment_comparison_predicate_t mmux_libc_file_system_pathname_segment_greater_equal
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_is_dot (bool * result_p, mmux_libc_ptn_segment_t seg)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_is_double_dot (bool * result_p, mmux_libc_ptn_segment_t seg)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_is_slash (bool * result_p, mmux_libc_ptn_segment_t seg)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_opendir (mmux_libc_dirstream_t * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fdopendir (mmux_libc_dirstream_t * result_p, mmux_libc_file_descriptor_t fd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_closedir (mmux_libc_dirstream_t DS)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readdir (mmux_libc_dirent_t ** result_p, mmux_libc_dirstream_t dirstream)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dirfd (mmux_libc_file_descriptor_t * result_p, mmux_libc_dirstream_t dirstream)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_rewinddir (mmux_libc_dirstream_t dirstream);

mmux_cc_libc_decl bool mmux_libc_telldir (mmux_libc_dirstream_position_t * result_p, mmux_libc_dirstream_t dirstream)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_seekdir (mmux_libc_dirstream_t dirstream, mmux_libc_dirstream_position_t dirpos);

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getcwd (mmux_asciizp_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getcwd_malloc (mmux_asciizcpp_t result_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getcwd_pathname (mmux_libc_file_system_pathname_t * result_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_chdir (mmux_libc_file_system_pathname_t dirptn)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchdir (mmux_libc_file_descriptor_t fd)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_chroot (mmux_libc_file_system_pathname_t ptn)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pivot_root (mmux_libc_file_system_pathname_t new_root_ptn, mmux_libc_file_system_pathname_t put_old_ptn)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_link (mmux_libc_file_system_pathname_t oldname, mmux_libc_file_system_pathname_t newname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_linkat (mmux_libc_file_descriptor_t oldfd, mmux_libc_file_system_pathname_t oldname,
					 mmux_libc_file_descriptor_t newfd, mmux_libc_file_system_pathname_t newname,
					 mmux_sint_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_symlink (mmux_libc_file_system_pathname_t oldname, mmux_libc_file_system_pathname_t newname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlink (mmux_usize_t * required_nbytes_p, mmux_libc_file_system_pathname_t linkname,
					   mmux_asciizp_t buffer, mmux_usize_t provided_nbytes)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlink_malloc (mmux_libc_file_system_pathname_t * result_pathname_p,
						  mmux_libc_file_system_pathname_t linkname)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlinkat (mmux_usize_t * required_nbytes_p, mmux_libc_file_descriptor_t dirfd,
					     mmux_libc_file_system_pathname_t linkname,
					     mmux_asciizp_t buffer, mmux_usize_t provided_nbytes)
  __attribute__((__nonnull__(1,4),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlinkat_malloc (mmux_libc_file_system_pathname_t * result_pathname_p,
						    mmux_libc_file_descriptor_t dirfd,
						    mmux_libc_file_system_pathname_t linkname)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlinkfd (mmux_usize_t * required_nbytes_p, mmux_libc_file_descriptor_t dirfd,
					     mmux_asciizp_t buffer, mmux_usize_t provided_nbytes)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlinkfd_malloc (mmux_libc_file_system_pathname_t * result_pathname_p,
						    mmux_libc_file_descriptor_t dirfd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_canonicalize_file_name (mmux_libc_file_system_pathname_t * result_pathname_p,
							 mmux_libc_file_system_pathname_t input_pathname)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_realpath (mmux_libc_file_system_pathname_t * result_pathname_p,
					   mmux_libc_file_system_pathname_t input_pathname)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_unlink (mmux_libc_file_system_pathname_t pathname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_unlinkat (mmux_libc_file_descriptor_t dirfd,
					   mmux_libc_file_system_pathname_t pathname, mmux_sint_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_rmdir (mmux_libc_file_system_pathname_t pathname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_remove (mmux_libc_file_system_pathname_t pathname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_rename (mmux_libc_file_system_pathname_t oldname, mmux_libc_file_system_pathname_t newname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_renameat (mmux_libc_file_descriptor_t olddirfd, mmux_libc_file_system_pathname_t oldname,
					   mmux_libc_file_descriptor_t newdirfd, mmux_libc_file_system_pathname_t newname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_renameat2 (mmux_libc_file_descriptor_t olddirfd, mmux_libc_file_system_pathname_t oldname,
					    mmux_libc_file_descriptor_t newdirfd, mmux_libc_file_system_pathname_t newname,
					    mmux_uint_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_mkdir (mmux_libc_file_system_pathname_t pathname, mmux_mode_t mode)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_mkdirat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname, mmux_mode_t mode)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_chown (mmux_libc_file_system_pathname_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchown (mmux_libc_file_descriptor_t fd, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lchown (mmux_libc_file_system_pathname_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchownat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname,
					   mmux_libc_uid_t uid, mmux_libc_gid_t gid, mmux_sint_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_chownfd (mmux_libc_file_descriptor_t fd, mmux_libc_uid_t uid, mmux_libc_gid_t gid, mmux_sint_t flags)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_umask (mmux_mode_t * old_mask_p, mmux_mode_t new_mask)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getumask (mmux_mode_t * current_mask_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_chmod (mmux_libc_file_system_pathname_t pathname, mmux_mode_t mode)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchmod (mmux_libc_file_descriptor_t fd, mmux_mode_t mode)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchmodat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname,
					   mmux_mode_t mode, mmux_sint_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_access (bool * access_is_permitted_p, mmux_libc_file_system_pathname_t pathname, mmux_sint_t how)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_faccessat (bool * access_is_permitted_p, mmux_libc_file_descriptor_t dirfd,
					    mmux_libc_file_system_pathname_t pathname, mmux_sint_t how, mmux_sint_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_faccessat2 (bool * access_is_permitted_p, mmux_libc_file_descriptor_t dirfd,
					     mmux_libc_file_system_pathname_t pathname, mmux_sint_t how, mmux_sint_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_truncate (mmux_libc_file_system_pathname_t pathname, mmux_off_t len)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_ftruncate (mmux_libc_file_descriptor_t fd, mmux_off_t len)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_mode,	mmux_mode_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_ino,		mmux_uintmax_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_dev,		mmux_uintmax_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_nlink,	mmux_uintmax_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_uid,		mmux_libc_uid_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_gid,		mmux_libc_gid_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_size,	mmux_off_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_atime_sec,	mmux_time_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_atime_nsec,	mmux_slong_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_mtime_sec,	mmux_time_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_mtime_nsec,	mmux_slong_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_ctime_sec,	mmux_time_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_ctime_nsec,	mmux_slong_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_blocks,	mmux_uintmax_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(stat,	st_blksize,	mmux_uint_t)

mmux_cc_libc_decl bool mmux_libc_stat_dump (mmux_libc_file_descriptor_t fd, mmux_libc_stat_t const * stat_p,
					    mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_stat (mmux_libc_file_system_pathname_t pathname, mmux_libc_stat_t * stat_p)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fstat (mmux_libc_file_descriptor_t fd, mmux_libc_stat_t * stat_p)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lstat (mmux_libc_file_system_pathname_t pathname, mmux_libc_stat_t * stat_p)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fstatat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname,
					  mmux_libc_stat_t * stat_p, mmux_sint_t flags)
  __attribute__((__nonnull__(3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_statfd (mmux_libc_file_descriptor_t fd, mmux_libc_stat_t * stat_p, mmux_sint_t flags)
  __attribute__((__nonnull__(2),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_S_TYPEISMQ (bool * result_p, mmux_libc_stat_t * stat_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_S_TYPEISSEM (bool * result_p, mmux_libc_stat_t * stat_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_S_TYPEISSHM (bool * result_p, mmux_libc_stat_t * stat_p)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_S_ISDIR (bool * result_p, mmux_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISCHR (bool * result_p, mmux_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISBLK (bool * result_p, mmux_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISREG (bool * result_p, mmux_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISFIFO (bool * result_p, mmux_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISLNK (bool * result_p, mmux_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISSOCK (bool * result_p, mmux_mode_t mode)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_exists (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_regular (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_symlink (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_directory (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_character_special (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_block_special (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_fifo (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_socket (bool * result_p, mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_regular (bool * result_p, mmux_libc_file_descriptor_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_symlink (bool * result_p, mmux_libc_file_descriptor_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_directory (bool * result_p, mmux_libc_file_descriptor_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_character_special (bool * result_p, mmux_libc_file_descriptor_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_block_special (bool * result_p, mmux_libc_file_descriptor_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_fifo (bool * result_p, mmux_libc_file_descriptor_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_socket (bool * result_p, mmux_libc_file_descriptor_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_file_size_ref (mmux_usize_t * result_p, mmux_libc_fd_t dirfd,
								     mmux_libc_file_system_pathname_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_file_size_ref (mmux_usize_t * result_p, mmux_libc_fd_t fd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(utimbuf, actime,  mmux_time_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(utimbuf, modtime, mmux_time_t)

mmux_cc_libc_decl bool mmux_libc_utimbuf_dump (mmux_libc_file_descriptor_t fd, mmux_libc_utimbuf_t const * utimbuf_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_utime (mmux_libc_file_system_pathname_t pathname, mmux_libc_utimbuf_t utimbuf)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_utimes (mmux_libc_file_system_pathname_t pathname,
					 mmux_libc_timeval_t access_timeval, mmux_libc_timeval_t modification_timeval)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lutimes (mmux_libc_file_system_pathname_t pathname,
					  mmux_libc_timeval_t access_timeval, mmux_libc_timeval_t modification_timeval)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_futimes (mmux_libc_file_descriptor_t fd,
					  mmux_libc_timeval_t access_timeval, mmux_libc_timeval_t modification_timeval)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_futimens (mmux_libc_file_descriptor_t fd,
					   mmux_libc_timespec_t access_timespec, mmux_libc_timespec_t modification_timespec)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_utimensat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname,
					    mmux_libc_timespec_t access_timespec, mmux_libc_timespec_t modification_timespec,
					    mmux_sint_t flags)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Sockets.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(in_addr, s_addr,	mmux_uint32_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(if_nameindex, if_index,	mmux_uint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(if_nameindex, if_name,	mmux_asciizcp_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr, sa_family,	mmux_sshort_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_un, sun_family,	mmux_sshort_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_un, sun_path,	mmux_libc_file_system_pathname_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_in, sin_family,	mmux_sshort_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_in, sin_addr,	mmux_libc_in_addr_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_in, sin_port,	mmux_host_byteorder_ushort_t)

mmux_cc_libc_decl bool mmux_libc_sin_addr_p_ref (mmux_libc_in_addr_t ** sin_addr_pp, mmux_libc_sockaddr_in_t * sockaddr_p)
  __attribute__((__nonnull__(1,2)));

DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_family,   mmux_sshort_t,          sinsix_family)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_addr,     mmux_libc_insix_addr_t, sinsix_addr)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_flowinfo, mmux_uint32_t,          sinsix_flowinfo)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_scope_id, mmux_uint32_t,          sinsix_scope_id)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_port,     mmux_host_byteorder_uint16_t, sinsix_port)

mmux_cc_libc_decl bool mmux_libc_sinsix_addr_p_ref (mmux_libc_insix_addr_t ** sinsix_addr_pp, mmux_libc_sockaddr_insix_t * sockaddr_p)
  __attribute__((__nonnull__(1,2)));

DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_flags,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_family,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_socktype,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_protocol,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_addrlen,	mmux_socklen_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_addr,		mmux_libc_sockaddr_t *)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_canonname,	mmux_asciizcp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_next,		mmux_libc_addrinfo_t *)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(hostent, h_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(hostent, h_aliases,		mmux_asciizpp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(hostent, h_addrtype,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(hostent, h_length,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(hostent, h_addr_list,	mmux_asciizpp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(hostent, h_addr,		mmux_asciizp_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(servent, s_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(servent, s_aliases,		mmux_asciizp_t *)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(servent, s_port,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(servent, s_proto,		mmux_asciizp_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(protoent, p_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(protoent, p_aliases,		mmux_asciizp_t *)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(protoent, p_proto,		mmux_sint_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(netent, n_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(netent, n_aliases,		mmux_asciizp_t *)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(netent, n_addrtype,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(netent, n_net,		mmux_ulong_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(linger, l_onoff,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(linger, l_linger,		mmux_sint_t)

mmux_cc_libc_decl mmux_usize_t mmux_libc_SUN_LEN (mmux_libc_sockaddr_un_t const * sockaddr_un_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_in_addr_dump (mmux_libc_file_descriptor_t fd, mmux_libc_in_addr_t const * in_addr_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_insix_addr_dump (mmux_libc_file_descriptor_t fd, mmux_libc_insix_addr_t const * insix_addr_p,
						  mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_if_nameindex_dump (mmux_libc_file_descriptor_t fd, mmux_libc_if_nameindex_t const * nameindex_p,
						    mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_dump (mmux_libc_file_descriptor_t fd, mmux_libc_sockaddr_t const * sockaddr_p,
						mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_un_dump (mmux_libc_file_descriptor_t fd, mmux_libc_sockaddr_un_t const * sockaddr_un_p,
						   mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_in_dump (mmux_libc_file_descriptor_t fd, mmux_libc_sockaddr_in_t const * sockaddr_in_p,
						   mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_insix_dump (mmux_libc_file_descriptor_t fd, mmux_libc_sockaddr_insix_t const * sockaddr_insix_p,
						      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_addrinfo_dump (mmux_libc_file_descriptor_t fd, mmux_libc_addrinfo_t const * addrinfo_p,
						mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_hostent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_hostent_t const * hostent_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_servent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_servent_t const * servent_p,
					       mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_protoent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_protoent_t const * protoent_p,
						mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_netent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_netent_t const * netent_p,
					      mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_linger_dump (mmux_libc_file_descriptor_t fd, mmux_libc_linger_t const * linger_p,
					      mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_in_addr (mmux_libc_in_addr_t * in_addr_p, mmux_uint32_t network_byteorder_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_in_addr_none (mmux_libc_in_addr_t * in_addr_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_in_addr_any (mmux_libc_in_addr_t * in_addr_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_in_addr_broadcast (mmux_libc_in_addr_t * in_addr_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_in_addr_loopback (mmux_libc_in_addr_t * in_addr_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_insix_addr_loopback (mmux_libc_insix_addr_t * insix_addr_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_insix_addr_any (mmux_libc_insix_addr_t * insix_addr_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_htons (mmux_uint16_t * netw_byteorder_value_p, mmux_uint16_t host_byteorder_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ntohs (mmux_uint16_t * host_byteorder_value_p, mmux_uint16_t netw_byteorder_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_htonl (mmux_uint32_t * netw_byteorder_value_p, mmux_uint32_t host_byteorder_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ntohl (mmux_uint32_t * host_byteorder_value_p, mmux_uint32_t netw_byteorder_value)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_inet_aton (mmux_libc_in_addr_ptr_t ouput_addr_p, mmux_asciizcp_t input_presentation_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_inet_ntoa (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
					    mmux_libc_in_addr_ptr_t input_addr_p)
  __attribute__((__nonnull__(1,3)));

mmux_cc_libc_decl bool mmux_libc_inet_pton (mmux_pointer_t ouput_addr_p,
					    mmux_sint_t input_af_family, mmux_asciizcp_t input_presentation_p)
  __attribute__((__nonnull__(1,3)));

mmux_cc_libc_decl bool mmux_libc_inet_ntop (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
					    mmux_sint_t input_af_family, mmux_pointer_t input_addr_p)
  __attribute__((__nonnull__(1,4)));

mmux_cc_libc_decl bool mmux_libc_inet_addr (mmux_libc_in_addr_ptr_t result_in_addr_p, mmux_asciizcp_t presentation_in_addr_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_inet_network (mmux_libc_in_addr_ptr_t result_in_addr_p, mmux_asciizcp_t presentation_in_addr_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_inet_makeaddr (mmux_libc_in_addr_ptr_t result_in_addr,
						mmux_libc_in_addr_ptr_t net_in_addr, mmux_libc_in_addr_ptr_t local_in_addr)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_inet_lnaof (mmux_libc_in_addr_ptr_t local_in_addr_p, mmux_libc_in_addr_ptr_t in_addr_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_inet_netof (mmux_libc_in_addr_ptr_t net_in_addr_p, mmux_libc_in_addr_ptr_t in_addr_p)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getaddrinfo (mmux_libc_addrinfo_ptr_t * result_addrinfo_linked_list_pp,
					      mmux_sint_t * result_error_code_p,
					      mmux_asciizcp_t node, mmux_asciizcp_t service, mmux_libc_addrinfo_ptr_t hints_pointer)
  __attribute__((__nonnull__(1,2,3,4,5),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_freeaddrinfo (mmux_libc_addrinfo_ptr_t addrinfo_linked_list_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gai_strerror (mmux_asciizcp_t * result_error_message_p, mmux_sint_t errnum)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getnameinfo (mmux_asciizcp_t result_hostname_p, mmux_socklen_t provided_hostname_len,
					      mmux_asciizcp_t result_servname_p, mmux_socklen_t provided_servname_len,
					      mmux_sint_t * result_error_code_p,
					      mmux_libc_sockaddr_ptr_t input_sockaddr_p, mmux_socklen_t input_sockaddr_size,
					      mmux_sint_t flags)
  __attribute__((__nonnull__(1,3,5,6),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sethostent (mmux_sint_t stayopen);

mmux_cc_libc_decl bool mmux_libc_endhostent (void);

mmux_cc_libc_decl bool mmux_libc_gethostent (mmux_libc_hostent_t const * * result_hostent_pp)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_setservent (mmux_sint_t stayopen);

mmux_cc_libc_decl bool mmux_libc_endservent (void);

mmux_cc_libc_decl bool mmux_libc_getservent (mmux_libc_servent_t const * * result_servent_pp)
  __attribute__((__nonnull__(1)));

/* The argument "protocol_name_p" can be NULL, see the manpage. */
mmux_cc_libc_decl bool mmux_libc_getservbyname(mmux_libc_servent_t const * * result_servent_pp,
					       mmux_asciizcp_t service_name_p, mmux_asciizcp_t protocol_name_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

/* The argument "protocol_name_p" can be NULL, see the manpage. */
mmux_cc_libc_decl bool mmux_libc_getservbyport (mmux_libc_servent_t const * * result_servent_pp,
						mmux_sint_t port, mmux_asciizcp_t protocol_name_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_setprotoent (mmux_sint_t stayopen);

mmux_cc_libc_decl bool mmux_libc_endprotoent (void);

mmux_cc_libc_decl bool mmux_libc_getprotoent (mmux_libc_protoent_t const * * result_protoent_pp)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getprotobyname (mmux_libc_protoent_t const * * result_protoent_pp, mmux_asciizcp_t protocol_name_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getprotobynumber (mmux_libc_protoent_t const * * result_protoent_pp, mmux_sint_t proto)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_setnetent (mmux_sint_t stayopen);

mmux_cc_libc_decl bool mmux_libc_endnetent (void);

mmux_cc_libc_decl bool mmux_libc_getnetent (mmux_libc_netent_t const * * result_netent_pp)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getnetbyname (mmux_libc_netent_t const * * result_netent_pp, mmux_asciizcp_t network_name_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getnetbyaddr (mmux_libc_netent_t const * * result_netent_pp, mmux_uint32_t n_net, mmux_sint_t af_type)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_if_nametoindex (mmux_uint_t * index_p, mmux_asciizcp_t network_interface_name)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_if_indextoname (mmux_asciizp_t buffer, mmux_uint_t network_interface_index)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_if_nameindex (mmux_libc_if_nameindex_t const * * result_nameindex_array_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_if_freenameindex (mmux_libc_if_nameindex_t const * nameindex_array)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_network_socket (mmux_libc_network_socket_t * result_p, mmux_sint_t sock_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_socket (mmux_libc_network_socket_t * result_sock_p,
					 mmux_sint_t pf_namespace, mmux_sint_t sock_style, mmux_sint_t ipproto)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_shutdown (mmux_libc_network_socket_t sock, mmux_sint_t how)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_socketpair (mmux_libc_network_socket_t * result_sock1_p, mmux_libc_network_socket_t * result_sock2_p,
					     mmux_sint_t pf_namespace, mmux_sint_t sock_style, mmux_sint_t ipproto)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_connect (mmux_libc_network_socket_t sock,
					  mmux_libc_sockaddr_ptr_t sockaddr_pointer, mmux_socklen_t sockaddr_size)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_bind (mmux_libc_network_socket_t sock,
				       mmux_libc_sockaddr_ptr_t sockaddr_pointer, mmux_socklen_t sockaddr_size)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_listen (mmux_libc_network_socket_t sock, mmux_uint_t pending_connections_queue_length)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_accept (mmux_libc_network_socket_t * result_connected_sock_p,
					 mmux_libc_sockaddr_ptr_t result_client_sockaddr_p, mmux_socklen_t * result_client_sockaddr_size_p,
					 mmux_libc_network_socket_t server_sock)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_accept4 (mmux_libc_network_socket_t * result_connected_sock_p,
					  mmux_libc_sockaddr_ptr_t result_client_sockaddr_p, mmux_socklen_t * result_client_sockaddr_size_p,
					  mmux_libc_network_socket_t server_sock, mmux_sint_t flags)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getpeername (mmux_libc_network_socket_t sock, mmux_libc_sockaddr_ptr_t sockaddr_all,
					      mmux_socklen_t * sockaddr_all_size)
  __attribute__((__nonnull__(2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getsockname (mmux_libc_network_socket_t sock, mmux_libc_sockaddr_ptr_t sockaddr_all,
					      mmux_socklen_t * sockaddr_all_size)
  __attribute__((__nonnull__(2,3),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_send (mmux_usize_t * result_number_of_bytes_sent_p,
				       mmux_libc_network_socket_t sock, mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_recv (mmux_usize_t * result_number_of_bytes_received_p,
				       mmux_libc_network_socket_t sock, mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_sendto (mmux_usize_t * result_number_of_bytes_sent_p,
					 mmux_libc_network_socket_t sock, mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags,
					 mmux_libc_sockaddr_ptr_t destination_sockaddr_p, mmux_socklen_t destination_sockaddr_size)
  __attribute__((__nonnull__(1,3,6),__warn_unused_result__));

/* The arguments  "result_sender_sockaddr_p" and  "result_sender_sockaddr_size_p" can
   be NULL if we are not interested in retrieving the sender address. */
mmux_cc_libc_decl bool mmux_libc_recvfrom (mmux_usize_t * result_number_of_bytes_received_p,
					   mmux_libc_sockaddr_ptr_t result_sender_sockaddr_p,
					   mmux_socklen_t *         result_sender_sockaddr_size_p,
					   mmux_libc_network_socket_t sock,
					   mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
  __attribute__((__nonnull__(1,5),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getsockopt (mmux_pointer_t result_optval_p, mmux_socklen_t * result_optlen_p,
					     mmux_libc_network_socket_t sock, mmux_sint_t level, mmux_sint_t optname)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setsockopt (mmux_libc_network_socket_t sock, mmux_sint_t level, mmux_sint_t optname,
					     mmux_pointer_t optval_p, mmux_socklen_t optlen)
  __attribute__((__nonnull__(4),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Done.
 ** ----------------------------------------------------------------- */

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* MMUX_CC_LIBC_FUNCTIONS_H */

/* end of file */
