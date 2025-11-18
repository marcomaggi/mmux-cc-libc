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

#define MMUX_LIBC_IGNORE_RETVAL(STATEMENT)	{ if (STATEMENT) { ; } }
#define MMUX_LIBC_CALL(EXPR)			{ if (EXPR) { return true; } }

#define mmux_usize_strlen(STRPTR)		(mmux_usize(strlen(STRPTR)))
#define mmux_libc_char_array(BUFPTR,BUFLEN)	char BUFPTR[(BUFLEN).value]


/** --------------------------------------------------------------------
 ** Initialisation functions.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_cc_libc_init (void)
  __attribute__((__constructor__));

mmux_cc_libc_decl bool mmux_cc_libc_final (void)
  __attribute__((__destructor__));


/** --------------------------------------------------------------------
 ** Version functions.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl mmux_asciizcp_t	mmux_cc_libc_version_string		(void);
mmux_cc_libc_decl mmux_sint_t		mmux_cc_libc_version_interface_current	(void);
mmux_cc_libc_decl mmux_sint_t		mmux_cc_libc_version_interface_revision	(void);
mmux_cc_libc_decl mmux_sint_t		mmux_cc_libc_version_interface_age	(void);


/** --------------------------------------------------------------------
 ** Errors.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_errno_t
mmux_libc_errno (mmux_standard_sint_t errnum)
{
  return (mmux_libc_errno_t){ .value = errnum };
}
mmux_cc_libc_inline_decl bool
mmux_libc_errno_equal (mmux_libc_errno_t errnum1, mmux_libc_errno_t errnum2)
{
  return (errnum1.value == errnum2.value)? true : false;
}

/* ------------------------------------------------------------------ */

/* This is a duplicate of "mmux_libc_strerrorname_np()". */
mmux_cc_libc_decl mmux_asciizcp_t mmux_libc_errno_to_name (mmux_libc_errno_t N);

mmux_cc_libc_decl bool mmux_libc_errno_ref (mmux_libc_errno_t * result_errnum_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_errno_set (mmux_libc_errno_t errnum);

mmux_cc_libc_decl bool mmux_libc_errno_set_to_einval (void);

mmux_cc_libc_decl bool mmux_libc_errno_clear (void);

mmux_cc_libc_decl bool mmux_libc_errno_consume (mmux_libc_errno_t * result_errnum_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_strerror (mmux_asciizcp_t * result_error_message_p, mmux_libc_errno_t errnum)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_strerror_r (mmux_asciizcpp_t result_p,
					     mmux_asciizp_t bufptr, mmux_usize_t buflen,
					     mmux_libc_errno_t errnum)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strerrorname_np (mmux_asciizcpp_t result_p, mmux_libc_errno_t errnum)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_strerrordesc_np (mmux_asciizcpp_t result_p, mmux_libc_errno_t errnum)
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

mmux_cc_libc_decl bool mmux_libc_strcmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strncmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strcasecmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strncasecmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strverscmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strequ (bool * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strnequ (bool * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strcoll (mmux_ternary_comparison_result_t * result_p,
					  mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strxfrm (mmux_usize_t * result_size_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2,3)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strchr (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_char_t schar)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strchrnul (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_char_t schar)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_strrchr (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_char_t schar)
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

mmux_cc_libc_decl bool mmux_libc_strtok (mmux_asciizp_t * result_p, mmux_asciizp_t newstring, mmux_asciizcp_t delimiters)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_strtok_r (mmux_asciizp_t * result_p, mmux_asciizp_t newstring,
					   mmux_asciizcp_t delimiters, mmux_asciizp_t * save_ptr)
  __attribute__((__nonnull__(1,2,3,4)));

mmux_cc_libc_decl bool mmux_libc_strsep (mmux_asciizp_t * result_p, mmux_asciizp_t * newstring_p,
					 mmux_asciizcp_t delimiters)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_basename (mmux_asciizcp_t * result_p, mmux_asciizcp_t pathname)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_dirname (mmux_asciizcp_t * result_p, mmux_asciizcp_t pathname)
  __attribute__((__nonnull__(1,2)));


/** --------------------------------------------------------------------
 ** Characters.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_islower (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isupper (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isalpha (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isdigit (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isalnum (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isxdigit (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ispunct (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isspace (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isblank (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isgraph (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isprint (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_iscntrl (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_isascii (bool * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_tolower (mmux_char_t * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_toupper (mmux_char_t * result_p, mmux_char_t ch)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Memory.
 ** ----------------------------------------------------------------- */

#define mmux_libc_malloc(POINTERP,LEN)			\
  mmux_libc_malloc_(((mmux_pointer_t *)(POINTERP)),(LEN))

#define mmux_libc_calloc(POINTERP,INUM,ILEN)		\
  mmux_libc_calloc_(((mmux_pointer_t *)(POINTERP)),(INUM),(ILEN))

#define mmux_libc_realloc(POINTERP,LEN)			\
  mmux_libc_realloc_(((mmux_pointer_t *)(POINTERP)),(LEN))

#define mmux_libc_reallocarray(POINTERP,INUM,ILEN)	\
  mmux_libc_reallocarray_(((mmux_pointer_t *)(POINTERP)),(INUM),(ILEN))

#define mmux_libc_malloc_and_copy(DSTPOINTERP,SRCPTR,SRCLEN)	\
  (mmux_libc_malloc_and_copy_(((mmux_pointer_t *)(DSTPOINTERP)),((mmux_pointer_t)(SRCPTR)),(SRCLEN)))

mmux_cc_libc_decl bool mmux_libc_malloc_ (mmux_pointer_t * P_p, mmux_usize_t len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_malloc_and_copy_ (mmux_pointer_t * dstptr_p, mmux_pointer_t srcptr, mmux_usize_t srclen)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_calloc_ (mmux_pointer_t * P_p, mmux_usize_t item_num, mmux_usize_t item_len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_realloc_ (mmux_pointer_t * P_p, mmux_usize_t newlen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_reallocarray_ (mmux_pointer_t * P_p, mmux_usize_t item_num, mmux_usize_t item_len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_free (mmux_pointer_t p)
  __attribute__((__nonnull__));

mmux_cc_libc_decl bool mmux_libc_memset (mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t len)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_memzero (mmux_pointer_t ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_memcpy (mmux_pointer_t dst_ptr, mmux_pointerc_t src_ptr, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_mempcpy_ (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2,3)));

#define mmux_libc_mempcpy(RESULTP,DSTPTR,SRCPTR,NBYTES)	\
  mmux_libc_mempcpy_((mmux_pointer_t *)(RESULTP),(DSTPTR),(SRCPTR),(NBYTES))

mmux_cc_libc_decl bool mmux_libc_memccpy_ (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr,
					   mmux_octet_t octet, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2,3)));

#define mmux_libc_memccpy(RESULTP,DSTPTR,SRCPTR,IT,NBYTES)	\
  mmux_libc_memccpy_((mmux_pointer_t *)(RESULTP),(DSTPTR),(SRCPTR),(IT),(NBYTES))

mmux_cc_libc_decl bool mmux_libc_memmove (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_memcmp (mmux_ternary_comparison_result_t * result_p,
					 mmux_pointerc_t ptr1, mmux_pointerc_t ptr2, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_memchr_ (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

#define mmux_libc_memchr(RESULTP,BUFPTR,OCTET,NBYTES)	\
  mmux_libc_memchr_((mmux_pointer_t *)(RESULTP),(BUFPTR),(OCTET),(NBYTES))

mmux_cc_libc_decl bool mmux_libc_rawmemchr_ (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet)
  __attribute__((__nonnull__(1,2)));

#define mmux_libc_rawmemchr(RESULTP,PTR,OCTET)		\
  mmux_libc_rawmemchr_((mmux_pointer_t *)(RESULTP),(PTR),(OCTET))

mmux_cc_libc_decl bool mmux_libc_memrchr_ (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
  __attribute__((__nonnull__(1,2)));

#define mmux_libc_memrchr(RESULTP,PTR,OCTET,NBYTES)	\
  mmux_libc_memrchr_((mmux_pointer_t *)(RESULTP),(PTR),(OCTET),(NBYTES))

mmux_cc_libc_decl bool mmux_libc_memmem_ (mmux_pointer_t * result_p,
					  mmux_pointer_t haystack_ptr, mmux_usize_t haystack_len,
					  mmux_pointer_t needle_ptr,   mmux_usize_t needle_len)
  __attribute__((__nonnull__(1,2,4)));

#define mmux_libc_memmem(RESULTP,HAYSTACK_PTR,HAYSTACK_LEN,NEEDLE_PTR,NEEDLE_LEN) \
  mmux_libc_memmem_((mmux_pointer_t *)(RESULTP),(HAYSTACK_PTR),(HAYSTACK_LEN),(NEEDLE_PTR),(NEEDLE_LEN))

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_default_memory_allocator_ref (mmux_libc_mall_t* result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_fake_memory_allocator_ref (mmux_libc_mall_t* result_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_memory_allocator_malloc_ (mmux_libc_mall_t allocator,
							   mmux_pointer_t * result_p, mmux_usize_t len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memory_allocator_calloc_ (mmux_libc_mall_t allocator,
							   mmux_pointer_t * result_p,
							   mmux_usize_t item_num, mmux_usize_t item_len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memory_allocator_realloc_ (mmux_libc_mall_t allocator,
							    mmux_pointer_t * result_p, mmux_usize_t newlen)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memory_allocator_reallocarray_ (mmux_libc_mall_t allocator,
								 mmux_pointer_t * result_p, mmux_usize_t item_num,
								 mmux_usize_t item_len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memory_allocator_free (mmux_libc_mall_t allocator,
							mmux_pointer_t p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memory_allocator_malloc_and_copy_ (mmux_libc_mall_t allocator,
								    mmux_pointer_t * dstptr_p,
								    mmux_pointer_t srcptr, mmux_usize_t srclen)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

/* ------------------------------------------------------------------ */

#define mmux_libc_memory_allocator_malloc(ALLOCP,POINTERP,LEN)		\
  (mmux_libc_memory_allocator_malloc_((ALLOCP),((mmux_pointer_t *)(POINTERP)),(LEN)))

#define mmux_libc_memory_allocator_calloc(ALLOCP,POINTERP,INUM,ILEN)	\
  (mmux_libc_memory_allocator_calloc_((ALLOCP),((mmux_pointer_t *)(POINTERP)),(INUM),(ILEN)))

#define mmux_libc_memory_allocator_realloc(ALLOCP,POINTERP,LEN)		\
  (mmux_libc_memory_allocator_realloc_((ALLOCP),((mmux_pointer_t *)(POINTERP)),(LEN)))

#define mmux_libc_memory_allocator_reallocarray(ALLOCP,POINTERP,INUM,ILEN)	\
  (mmux_libc_memory_allocator_reallocarray_((ALLOCP),((mmux_pointer_t *)(POINTERP)),(INUM),(ILEN)))

#define mmux_libc_memory_allocator_malloc_and_copy(ALLOCP,DSTPOINTERP,SRCPTR,SRCLEN)	\
  (mmux_libc_memory_allocator_malloc_and_copy_((ALLOCP),((mmux_pointer_t *)(DSTPOINTERP)), \
					       ((mmux_pointer_t)(SRCPTR)),(SRCLEN)))


/** --------------------------------------------------------------------
 ** Times and dates: mmux_libc_timeval_t.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_tv_sec_set (mmux_libc_timeval_t P, mmux_time_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_tv_sec_ref (mmux_time_t * result_p, mmux_libc_timeval_arg_t P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_tv_usec_set (mmux_libc_timeval_t P, mmux_slong_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_tv_usec_ref (mmux_slong_t * result_p, mmux_libc_timeval_arg_t P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_timeval_set (mmux_libc_timeval_t timeval_p,
					      mmux_time_t seconds, mmux_slong_t microseconds)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_timeval_dump (mmux_libc_fd_arg_t fd, mmux_libc_timeval_arg_t timeval_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));


/** --------------------------------------------------------------------
 ** Times and dates: mmux_libc_timespec_t.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_ts_sec_set (mmux_libc_timespec_t P, mmux_time_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ts_sec_ref (mmux_time_t * result_p, mmux_libc_timespec_arg_t P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_ts_nsec_set (mmux_libc_timespec_t P, mmux_slong_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ts_nsec_ref (mmux_slong_t * result_p, mmux_libc_timespec_arg_t P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_timespec_set (mmux_libc_timespec_t timespec_p,
					       mmux_time_t seconds, mmux_slong_t nanoseconds)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_timespec_dump (mmux_libc_fd_arg_t fd, mmux_libc_timespec_arg_t timespec_p,
						mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));


/** --------------------------------------------------------------------
 ** Times and dates: mmux_libc_tm_t.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS]]],
[[[mmux_cc_libc_decl bool mmux_libc_$1_set (mmux_libc_tm_t broken_down_time, $2 value);
mmux_cc_libc_decl bool mmux_libc_$1_ref ($2 * result_p, mmux_libc_tm_arg_t broken_down_time);]]])
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_sec,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_min,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_hour,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_mday,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_mon,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_year,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_wday,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_yday,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_isdst,		mmux_sint_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_gmtoff,	mmux_slong_t)
DEFINE_STRUCT_TM_SETTER_GETTER_PROTOS(tm_zone,		mmux_asciizcp_t)

mmux_cc_libc_decl bool mmux_libc_tm_dump (mmux_libc_fd_arg_t fd, mmux_libc_tm_arg_t tm_p,
					  mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_tm_reset (mmux_libc_tm_t tm_p)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Times and dates: functions.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_time (mmux_time_t * result_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_localtime   (mmux_libc_tm_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_localtime_r (mmux_libc_tm_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gmtime      (mmux_libc_tm_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gmtime_r    (mmux_libc_tm_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ctime       (mmux_asciizcpp_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ctime_r     (mmux_asciizp_t result_p, mmux_time_t T)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_mktime    (mmux_time_t * result_p, mmux_libc_tm_arg_t tm_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_timegm    (mmux_time_t * result_p, mmux_libc_tm_arg_t tm_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_asctime   (mmux_asciizcp_t * result_p, mmux_libc_tm_arg_t tm_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_asctime_r (mmux_asciizp_t result_p, mmux_libc_tm_arg_t tm_p)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strftime_required_nbytes_including_nil (mmux_usize_t * required_nbytes_including_nil_p,
									 mmux_asciizcp_t template,
									 mmux_libc_tm_arg_t tm_p)
  __attribute__((__nonnull__(1,2),__format__(__strftime__,2,0)));

mmux_cc_libc_decl bool mmux_libc_strftime (mmux_usize_t * required_nbytes_without_zero_p,
					   mmux_asciizp_t bufptr, mmux_usize_t buflen,
					   mmux_asciizcp_t template, mmux_libc_tm_arg_t tm_p)
  __attribute__((__nonnull__(1,2,4,5),__format__(__strftime__,4,0),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_strptime (char ** first_unprocessed_after_timestamp_p,
					   mmux_asciizcp_t input_string, mmux_asciizcp_t template,
					   mmux_libc_tm_arg_t tm_p)
  __attribute__((__nonnull__(2,3,4),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sleep     (mmux_uint_t * result_p, mmux_uint_t seconds)
       __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_nanosleep (mmux_libc_timespec_arg_t requested_time,
					    mmux_libc_timespec_t     remaining_time)
  __attribute__((__nonnull__(1,2)));


/** --------------------------------------------------------------------
 ** Input/output: file descriptor core API.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_open_flags_t
mmux_libc_open_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_open_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_file_descriptor_t
mmux_libc_file_descriptor (mmux_standard_uint_t value)
{
  return (mmux_libc_file_descriptor_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_file_lock_type_t
mmux_libc_file_lock_type (mmux_standard_sshort_t value)
{
  return (mmux_libc_file_lock_type_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_seek_whence_t
mmux_libc_seek_whence (mmux_standard_sshort_t value)
{
  return (mmux_libc_seek_whence_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_scatter_gather_flags_t
mmux_libc_scatter_gather_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_scatter_gather_flags_t) { .value = value };
}

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER]]],[[[mmux_cc_libc_inline_decl bool
mmux_libc_file_descriptor_identity_$1 (bool * result_p, mmux_libc_fd_arg_t fd)
{
  *result_p = fd->identity.$1;
  return false;
}]]])
DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER([[[is_for_input]]])
DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER([[[is_for_ouput]]])
DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER([[[is_directory]]])
DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER([[[is_networking_socket]]])
DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER([[[is_path_only]]])
DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER([[[is_closed_for_reading]]])
DEFINE_FILE_DESCRIPTOR_IDENTITY_GETTER([[[is_closed_for_writing]]])

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_fd (mmux_libc_fd_t result_p, mmux_standard_sint_t fd_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_infd (mmux_libc_infd_t infd_result, mmux_standard_sint_t fd_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_oufd (mmux_libc_oufd_t oufd_result, mmux_standard_sint_t fd_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_dirfd (mmux_libc_dirfd_t dirfd_result, mmux_standard_sint_t fd_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_stdin (mmux_libc_infd_t result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_stdou (mmux_libc_oufd_t result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_stder (mmux_libc_oufd_t result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_at_fdcwd (mmux_libc_dirfd_t result_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_dprintf (mmux_libc_fd_arg_t fd, mmux_asciizcp_t template, ...)
  __attribute__((__nonnull__(1,2),__format__(__printf__,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfou (mmux_asciizcp_t template, ...)
  __attribute__((__nonnull__(1),__format__(__printf__,1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfer (mmux_asciizcp_t template, ...)
  __attribute__((__nonnull__(1),__format__(__printf__,1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_strerror (mmux_libc_fd_arg_t fd, mmux_libc_errno_t errnum)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_strftime (mmux_libc_fd_arg_t fd, mmux_asciizcp_t template, mmux_libc_tm_arg_t BT)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__,__format__(__strftime__,2,0)));

mmux_cc_libc_decl bool mmux_libc_vdprintf (mmux_libc_fd_arg_t fd, mmux_asciizcp_t template, va_list ap)
  __attribute__((__nonnull__(1,2),__format__(__printf__,2,0),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_vdprintfou (mmux_asciizcp_t template, va_list ap)
  __attribute__((__nonnull__(1),__format__(__printf__,1,0),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_vdprintfer (mmux_asciizcp_t template, va_list ap)
  __attribute__((__nonnull__(1),__format__(__printf__,1,0),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_newline (mmux_libc_fd_arg_t fd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfou_newline (void)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintfer_newline (void)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_open (mmux_libc_fd_t fd, mmux_libc_fs_ptn_arg_t pathname,
				       mmux_libc_open_flags_t flags, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_openat (mmux_libc_fd_t fd, mmux_libc_dirfd_arg_t dirfd,
					 mmux_libc_fs_ptn_arg_t pathname,
					 mmux_libc_open_flags_t flags, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_open_how_flags_set (mmux_libc_open_how_t P, mmux_uint64_t value)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_open_how_flags_ref (mmux_uint64_t * result_p, mmux_libc_open_how_arg_t P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_open_how_mode_set (mmux_libc_open_how_t P, mmux_uint64_t value)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_open_how_mode_ref (mmux_uint64_t * result_p, mmux_libc_open_how_arg_t P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_open_how_resolve_set (mmux_libc_open_how_t P, mmux_uint64_t value)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_open_how_resolve_ref (mmux_uint64_t * result_p, mmux_libc_open_how_arg_t P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_open_how_dump (mmux_libc_fd_arg_t fd, mmux_libc_open_how_arg_t open_how_p,
						mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_open_how_memzero (mmux_libc_open_how_t OH)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_openat2 (mmux_libc_fd_t fd, mmux_libc_dirfd_arg_t dirfd,
					  mmux_libc_fs_ptn_arg_t pathname,
					  mmux_libc_open_how_arg_t open_how_p)
  __attribute__((__nonnull__(1,2,3,4),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_close (mmux_libc_fd_t fd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_read (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd,
				       mmux_pointer_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd,
					mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write_buffer (mmux_libc_fd_arg_t fd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write_buffer_to_stdou (mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_write_buffer_to_stder (mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pread (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd,
					mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_off_t offset)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pwrite (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd,
					 mmux_pointerc_t bufptr, mmux_usize_t buflen, mmux_off_t offset)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lseek (mmux_libc_fd_arg_t fd, mmux_off_t * offset_p, mmux_libc_seek_whence_t whence)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dup (mmux_libc_fd_t new_fd_p, mmux_libc_fd_arg_t old_fd)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dup2 (mmux_libc_fd_t new_fd, mmux_libc_fd_arg_t old_fd)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dup3 (mmux_libc_fd_t new_fd, mmux_libc_fd_arg_t old_fd, mmux_libc_open_flags_t flags)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pipe (mmux_libc_infd_t infd, mmux_libc_oufd_t oufd)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: selecting file descriptors.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_FD_ZERO  (mmux_libc_fd_set_t fd_set)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_FD_SET   (mmux_libc_fd_arg_t fd, mmux_libc_fd_set_t fd_set)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_FD_CLR   (mmux_libc_fd_arg_t fd, mmux_libc_fd_set_t fd_set)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_FD_ISSET (bool * result_p, mmux_libc_fd_arg_t fd, mmux_libc_fd_set_arg_t fd_set)
  __attribute__((__nonnull__(1,3)));

mmux_cc_libc_decl bool mmux_libc_select (mmux_uint_t * nfds_ready,
					 mmux_uint_t maximum_nfds_to_check,
					 mmux_libc_fd_set_t read_fd_set_p,
					 mmux_libc_fd_set_t write_fd_set_p,
					 mmux_libc_fd_set_t except_fd_set_p,
					 mmux_libc_timeval_t timeout_p)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pselect (mmux_uint_t * nfds_ready, mmux_uint_t maximum_nfds_to_check,
					  mmux_libc_fd_set_t read_fd_set,
					  mmux_libc_fd_set_t write_fd_set,
					  mmux_libc_fd_set_t except_fd_set,
					  mmux_libc_timespec_arg_t timeout_p,
					  mmux_libc_sigset_arg_t signals_blocking_mask)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_select_fd_for_reading (bool * result_p, mmux_libc_fd_arg_t fd,
							mmux_libc_timeval_t timeout_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_select_fd_for_writing (bool * result_p, mmux_libc_fd_arg_t fd,
							mmux_libc_timeval_t timeout_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_select_fd_for_exception (bool * result_p, mmux_libc_fd_arg_t fd,
							  mmux_libc_timeval_t timeout_p)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Input/output: file descriptor scatter-gather API.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec,	iov_base,	mmux_pointer_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec,	iov_len,	mmux_usize_t)

mmux_cc_libc_decl bool mmux_libc_iovec_dump (mmux_libc_fd_arg_t fd, mmux_libc_iovec_t const * iovec_p,
					     mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec_array,	iova_base,	mmux_libc_iovec_t *)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(iovec_array,	iova_len,	mmux_usize_t)

mmux_cc_libc_decl bool mmux_libc_iovec_array_dump (mmux_libc_fd_arg_t fd, mmux_libc_iovec_array_t const * iova_p,
						   mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_readv (mmux_usize_t * nbytes_read_p, mmux_libc_fd_arg_t fd,
					mmux_libc_iovec_array_t * iova_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_writev (mmux_usize_t * nbytes_written_p, mmux_libc_fd_arg_t fd,
					 mmux_libc_iovec_array_t * iova_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_preadv (mmux_usize_t * nbytes_read_p, mmux_libc_fd_arg_t fd,
					 mmux_libc_iovec_array_t * iova_p, mmux_off_t offset)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pwritev (mmux_usize_t * nbytes_written_p, mmux_libc_fd_arg_t fd,
					  mmux_libc_iovec_array_t * iova_p, mmux_off_t offset)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_preadv2 (mmux_usize_t * nbytes_read_p, mmux_libc_fd_arg_t fd,
					  mmux_libc_iovec_array_t * iova_p, mmux_off_t offset,
					  mmux_libc_scatter_gather_flags_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pwritev2 (mmux_usize_t * nbytes_written_p, mmux_libc_fd_arg_t fd,
					   mmux_libc_iovec_array_t * iova_p, mmux_off_t offset,
					   mmux_libc_scatter_gather_flags_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: file locking API.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_l_type_ref (mmux_libc_file_lock_type_t * result_p, mmux_libc_flock_arg_t flock_p)
     __attribute__((__nonnull__(1,2)));
mmux_cc_libc_decl bool mmux_libc_l_type_set (mmux_libc_flock_t flock_p, mmux_libc_file_lock_type_t value)
     __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_l_whence_ref (mmux_libc_seek_whence_t * result_p, mmux_libc_flock_arg_t flock_p)
     __attribute__((__nonnull__(1,2)));
mmux_cc_libc_decl bool mmux_libc_l_whence_set (mmux_libc_flock_t flock_p, mmux_libc_seek_whence_t value)
     __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_l_start_ref (mmux_off_t * result_p, mmux_libc_flock_arg_t flock_p)
     __attribute__((__nonnull__(1,2)));
mmux_cc_libc_decl bool mmux_libc_l_start_set (mmux_libc_flock_t flock_p, mmux_off_t value)
     __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_l_len_ref (mmux_off_t * result_p, mmux_libc_flock_arg_t flock_p)
     __attribute__((__nonnull__(1,2)));
mmux_cc_libc_decl bool mmux_libc_l_len_set (mmux_libc_flock_t flock_p, mmux_off_t value)
     __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_l_pid_ref (mmux_libc_pid_t * result_p, mmux_libc_flock_arg_t flock_p)
     __attribute__((__nonnull__(1,2)));
mmux_cc_libc_decl bool mmux_libc_l_pid_set (mmux_libc_flock_t flock_p, mmux_libc_pid_t value)
     __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_flock_dump (mmux_libc_fd_arg_t fd, mmux_libc_flock_arg_t flock_p,
					     mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_flag_to_symbol_struct_flock_l_type (mmux_asciizcpp_t str_p,
								     mmux_libc_file_lock_type_t flag)
  __attribute__((__nonnull__(1),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: file locking API.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_copy_file_range (mmux_usize_t * number_of_bytes_copied_p,
						  mmux_libc_fd_arg_t input_fd, mmux_sint64_t * input_position_p,
						  mmux_libc_fd_arg_t ouput_fd, mmux_sint64_t * ouput_position_p,
						  mmux_usize_t number_of_bytes_to_copy, mmux_sint_t flags)
  __attribute__((__nonnull__(1,2,4),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Input/output: control.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_fcntl_command_t
mmux_libc_fcntl_command (mmux_standard_sshort_t value)
{
  return (mmux_libc_fcntl_command_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_ioctl_command_t
mmux_libc_ioctl_command (mmux_standard_sint_t value)
{
  return (mmux_libc_ioctl_command_t) { .value = value };
}

mmux_cc_libc_decl bool mmux_libc_fcntl (mmux_libc_fd_arg_t fd, mmux_libc_fcntl_command_t command,
					mmux_pointer_t parameter_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fcntl_command_flag_to_symbol (mmux_asciizcp_t * str_p,
							       mmux_libc_fcntl_command_t flag)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_ioctl (mmux_libc_fd_arg_t fd, mmux_libc_ioctl_command_t, mmux_pointer_t parameter_p)
  __attribute__((__nonnull__(1),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Memfd buffers.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_memfd_create (mmux_libc_memfd_t mfd, mmux_asciizcp_t name, mmux_sint_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_memfd (mmux_libc_memfd_t mfd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_length (mmux_usize_t * len_p, mmux_libc_memfd_arg_t mfd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_write_buffer (mmux_libc_memfd_arg_t mfd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_write_asciiz (mmux_libc_memfd_arg_t mfd, mmux_asciizcp_t bufptr)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_copy (mmux_libc_fd_arg_t ou, mmux_libc_memfd_arg_t mfd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_copyou (mmux_libc_memfd_arg_t mfd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_copyer (mmux_libc_memfd_arg_t mfd)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_strerror (mmux_libc_memfd_arg_t mfd, mmux_libc_errno_t errnum)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_memfd_read_buffer (mmux_libc_memfd_arg_t mfd, mmux_pointer_t bufptr,
						    mmux_usize_t maximum_buflen)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Printing types.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_PRINTER_PROTO]]],
  [[[MMUX_CONDITIONAL_CODE([[[$2]]],[[[mmux_cc_libc_decl bool mmux_libc_dprintf_$1 (mmux_libc_fd_arg_t fd, mmux_$1_t value)
  __attribute__((__warn_unused_result__));]]])]]])

DEFINE_PRINTER_PROTO([[[pointer]]])

DEFINE_PRINTER_PROTO([[[char]]])
DEFINE_PRINTER_PROTO([[[schar]]])
DEFINE_PRINTER_PROTO([[[uchar]]])
DEFINE_PRINTER_PROTO([[[sshort]]])
DEFINE_PRINTER_PROTO([[[ushort]]])
DEFINE_PRINTER_PROTO([[[sint]]])
DEFINE_PRINTER_PROTO([[[uint]]])
DEFINE_PRINTER_PROTO([[[slong]]])
DEFINE_PRINTER_PROTO([[[ulong]]])
DEFINE_PRINTER_PROTO([[[sllong]]],		[[[MMUX_CC_TYPES_HAS_SLLONG]]])
DEFINE_PRINTER_PROTO([[[ullong]]],		[[[MMUX_CC_TYPES_HAS_ULLONG]]])

DEFINE_PRINTER_PROTO([[[sint8]]])
DEFINE_PRINTER_PROTO([[[uint8]]])
DEFINE_PRINTER_PROTO([[[sint16]]])
DEFINE_PRINTER_PROTO([[[uint16]]])
DEFINE_PRINTER_PROTO([[[sint32]]])
DEFINE_PRINTER_PROTO([[[uint32]]])
DEFINE_PRINTER_PROTO([[[sint64]]])
DEFINE_PRINTER_PROTO([[[uint64]]])

DEFINE_PRINTER_PROTO([[[flonumfl]]])
DEFINE_PRINTER_PROTO([[[flonumdb]]])
DEFINE_PRINTER_PROTO([[[flonumldb]]],		[[[MMUX_CC_TYPES_HAS_FLONUMLDB]]])

DEFINE_PRINTER_PROTO([[[flonumf32]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF32]]])
DEFINE_PRINTER_PROTO([[[flonumf64]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF64]]])
DEFINE_PRINTER_PROTO([[[flonumf128]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF128]]])

DEFINE_PRINTER_PROTO([[[flonumf32x]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF32X]]])
DEFINE_PRINTER_PROTO([[[flonumf64x]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF64X]]])
DEFINE_PRINTER_PROTO([[[flonumf128x]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF128X]]])

DEFINE_PRINTER_PROTO([[[flonumd32]]],		[[[MMUX_CC_TYPES_HAS_FLONUMD32]]])
DEFINE_PRINTER_PROTO([[[flonumd64]]],		[[[MMUX_CC_TYPES_HAS_FLONUMD64]]])
DEFINE_PRINTER_PROTO([[[flonumd128]]],		[[[MMUX_CC_TYPES_HAS_FLONUMD128]]])

DEFINE_PRINTER_PROTO([[[flonumcfl]]])
DEFINE_PRINTER_PROTO([[[flonumcdb]]])
DEFINE_PRINTER_PROTO([[[flonumcldb]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCLDB]]])

DEFINE_PRINTER_PROTO([[[flonumcf32]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCF32]]])
DEFINE_PRINTER_PROTO([[[flonumcf64]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCF64]]])
DEFINE_PRINTER_PROTO([[[flonumcf128]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCF128]]])

DEFINE_PRINTER_PROTO([[[flonumcf32x]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCF32X]]])
DEFINE_PRINTER_PROTO([[[flonumcf64x]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCF64X]]])
DEFINE_PRINTER_PROTO([[[flonumcf128x]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCF128X]]])

DEFINE_PRINTER_PROTO([[[flonumcd32]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCD32]]])
DEFINE_PRINTER_PROTO([[[flonumcd64]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCD64]]])
DEFINE_PRINTER_PROTO([[[flonumcd128]]],		[[[MMUX_CC_TYPES_HAS_FLONUMCD128]]])

DEFINE_PRINTER_PROTO([[[byte]]])
DEFINE_PRINTER_PROTO([[[octet]]])

DEFINE_PRINTER_PROTO([[[usize]]])
DEFINE_PRINTER_PROTO([[[ssize]]])

DEFINE_PRINTER_PROTO([[[sintmax]]])
DEFINE_PRINTER_PROTO([[[uintmax]]])
DEFINE_PRINTER_PROTO([[[sintptr]]])
DEFINE_PRINTER_PROTO([[[uintptr]]])
DEFINE_PRINTER_PROTO([[[ptrdiff]]])
DEFINE_PRINTER_PROTO([[[off]]])
DEFINE_PRINTER_PROTO([[[wchar]]])
DEFINE_PRINTER_PROTO([[[wint]]])
DEFINE_PRINTER_PROTO([[[time]]])
DEFINE_PRINTER_PROTO([[[clock]]])
DEFINE_PRINTER_PROTO([[[libc_mode]]])
DEFINE_PRINTER_PROTO([[[libc_pid]]])
DEFINE_PRINTER_PROTO([[[libc_uid]]])
DEFINE_PRINTER_PROTO([[[libc_gid]]])
DEFINE_PRINTER_PROTO([[[libc_socklen]]])
DEFINE_PRINTER_PROTO([[[libc_rlim]]])
DEFINE_PRINTER_PROTO([[[libc_ino]]])
DEFINE_PRINTER_PROTO([[[libc_dev]]])
DEFINE_PRINTER_PROTO([[[libc_nlink]]])
DEFINE_PRINTER_PROTO([[[libc_blkcnt]]])

mmux_cc_libc_decl bool mmux_libc_dprintf_fd (mmux_libc_fd_arg_t fd, mmux_libc_fd_arg_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_fs_ptn (mmux_libc_fd_arg_t fd, mmux_libc_fs_ptn_arg_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_fs_ptn_extension (mmux_libc_fd_arg_t fd, mmux_libc_fs_ptn_extension_arg_t E)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_fs_ptn_segment (mmux_libc_fd_arg_t fd, mmux_libc_fs_ptn_segment_arg_t E)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_process_completion_status (mmux_libc_fd_arg_t fd,
								    mmux_libc_process_completion_status_t value)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dprintf_interprocess_signal (mmux_libc_fd_arg_t fd,
							      mmux_libc_interprocess_signal_t value)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** System configuration.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_sysconf_parameter_t
mmux_libc_sysconf_parameter (mmux_standard_sint_t parm)
{
  return (mmux_libc_sysconf_parameter_t) { { .value = parm } };
}
mmux_cc_libc_inline_decl mmux_libc_sysconf_string_parameter_t
mmux_libc_sysconf_string_parameter (mmux_standard_sint_t parm)
{
  return (mmux_libc_sysconf_string_parameter_t) { { .value = parm } };
}
mmux_cc_libc_inline_decl mmux_libc_sysconf_pathname_parameter_t
mmux_libc_sysconf_pathname_parameter (mmux_standard_sint_t parm)
{
  return (mmux_libc_sysconf_pathname_parameter_t) { { .value = parm } };
}
mmux_cc_libc_inline_decl mmux_libc_sysconf_resource_limit_t
mmux_libc_sysconf_resource_limit (mmux_standard_sint_t parm)
{
  return (mmux_libc_sysconf_resource_limit_t) { { .value = parm } };
}

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sysconf (mmux_slong_t * result_p, mmux_libc_sysconf_parameter_t parameter)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_confstr_size (mmux_usize_t * required_nbytes_p, mmux_libc_sysconf_string_parameter_t parameter);
mmux_cc_libc_decl bool mmux_libc_confstr (mmux_asciizp_t result_bufptr, mmux_usize_t provided_nbytes,
					  mmux_libc_sysconf_string_parameter_t parameter)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pathconf (mmux_slong_t * result_p, mmux_libc_fs_ptn_arg_t fs_ptn,
					   mmux_libc_sysconf_pathname_parameter_t parameter)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fpathconf (mmux_slong_t * result_p, mmux_libc_fd_arg_t fd,
					    mmux_libc_sysconf_pathname_parameter_t parameter)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(rlimit,	rlim_cur,	mmux_libc_rlim_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(rlimit,	rlim_max,	mmux_libc_rlim_t)

mmux_cc_libc_decl bool mmux_libc_rlimit_set (mmux_libc_rlimit_t * rlimit_p, mmux_libc_rlim_t cur, mmux_libc_rlim_t max)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_rlimit_dump (mmux_libc_fd_arg_t fd, mmux_libc_rlimit_t * rlimit_pointer,
					      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_getrlimit (mmux_libc_rlimit_t * result_rlimit_p, mmux_libc_sysconf_resource_limit_t resource)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setrlimit (mmux_libc_sysconf_resource_limit_t resource, mmux_libc_rlimit_t * new_rlimit_p)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_prlimit (mmux_libc_rlimit_t * old_rlimit_p,
					  mmux_libc_pid_t pid, mmux_libc_sysconf_resource_limit_t resource,
					  mmux_libc_rlimit_t * new_rlimit_p)
  __attribute__((__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Processes.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_process_completion_waiting_options_t
mmux_libc_process_completion_waiting_options (mmux_standard_sint_t bitwise_OR_options)
{
  return (mmux_libc_process_completion_waiting_options_t) { { .value = bitwise_OR_options } };
}
mmux_cc_libc_inline_decl mmux_libc_process_exit_status_t
mmux_libc_process_exit_status (mmux_standard_sint_t exit_status_num)
{
  return (mmux_libc_process_exit_status_t) { { .value = exit_status_num } };
}

mmux_cc_libc_inline_decl bool
mmux_libc_process_exit_status_equal (mmux_libc_process_exit_status_t status1,
				     mmux_libc_process_exit_status_t status2)
{
  return (status1.value == status2.value)? true : false;
}

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_pid (mmux_libc_pid_t * result_p, mmux_standard_libc_pid_t pid_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_pid_zero (mmux_libc_pid_t * result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_pid_minus_one (mmux_libc_pid_t * result_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_process_completion_status (mmux_libc_process_completion_status_t * result_p,
								 mmux_standard_sint_t status)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_process_completion_status_equal (bool * result_p,
								  mmux_libc_process_completion_status_t one,
								  mmux_libc_process_completion_status_t two)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_process_completion_status_not_equal (bool * result_p,
								      mmux_libc_process_completion_status_t one,
								      mmux_libc_process_completion_status_t two)
  __attribute__((__nonnull__(1)));

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

mmux_cc_libc_decl bool mmux_libc_wait_any_process
	(bool * process_completion_status_available_p,
	 mmux_libc_process_completion_status_t * process_completion_status_p,
	 mmux_libc_pid_t * completed_process_pid_p,
	 mmux_libc_process_completion_waiting_options_t wait_options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait_my_process_group
        (bool * process_completion_status_available_p,
	 mmux_libc_process_completion_status_t * process_completion_status_p,
	 mmux_libc_pid_t * completed_process_pid_p,
	 mmux_libc_process_completion_waiting_options_t wait_options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait_process_id
	(bool * process_completion_status_available_p,
	 mmux_libc_process_completion_status_t * process_completion_status_p,
	 mmux_libc_pid_t * completed_process_pid_p,
	 mmux_libc_pid_t pid,
	 mmux_libc_process_completion_waiting_options_t wait_options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait_group_id
	(bool * process_completion_status_available_p,
	 mmux_libc_process_completion_status_t * process_completion_status_p,
	 mmux_libc_pid_t * completed_process_pid_p,
	 mmux_libc_gid_t gid,
	 mmux_libc_process_completion_waiting_options_t wait_options)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_wait (bool * process_completion_status_available_p,
				       mmux_libc_process_completion_status_t * process_completion_status_p,
				       mmux_libc_pid_t * completed_process_pid_p)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_WIFEXITED (bool * result_p, mmux_libc_process_completion_status_t psc)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WEXITSTATUS (mmux_libc_process_exit_status_t * exit_status_result_p,
					      mmux_libc_process_completion_status_t pcs)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WIFSIGNALED (bool * result_p, mmux_libc_process_completion_status_t pcs)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WTERMSIG (mmux_libc_interprocess_signal_t * result_p,
					   mmux_libc_process_completion_status_t pcs)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WCOREDUMP (bool * result_p, mmux_libc_process_completion_status_t pcs)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WIFSTOPPED (bool * result_p, mmux_libc_process_completion_status_t pcs)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WSTOPSIG (mmux_libc_interprocess_signal_t * result_p,
					   mmux_libc_process_completion_status_t pcs)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_WIFCONTINUED (bool * result_p,
					       mmux_libc_process_completion_status_t pcs)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_process_exit_status (mmux_libc_process_exit_status_t * status_p,
							   mmux_standard_sint_t exit_status_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_exit (mmux_libc_process_exit_status_t status)
  __attribute__((__noreturn__));
mmux_cc_libc_decl bool mmux_libc_exit_success (void)
  __attribute__((__noreturn__));
mmux_cc_libc_decl bool mmux_libc_exit_failure (void)
  __attribute__((__noreturn__));

mmux_cc_libc_decl bool mmux_libc__exit (mmux_libc_process_exit_status_t status)
  __attribute__((__noreturn__));

mmux_cc_libc_decl bool mmux_libc_atexit (void (*function_pointer) (void));

mmux_cc_libc_decl bool mmux_libc_abort (void)
  __attribute__((__noreturn__));


/** --------------------------------------------------------------------
 ** Interprocess signals.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_interprocess_signal_t
mmux_libc_interprocess_signal (mmux_standard_sint_t signal_num)
{
  return (mmux_libc_interprocess_signal_t) { { .value = signal_num } };
}
mmux_cc_libc_inline_decl bool
mmux_libc_interprocess_signal_equal (mmux_libc_interprocess_signal_t ipxsig1,
				     mmux_libc_interprocess_signal_t ipxsig2)
{
  return (ipxsig1.value == ipxsig2.value)? true : false;
}

mmux_cc_libc_decl bool mmux_libc_interprocess_signal_dump (mmux_libc_fd_arg_t fd,
							   mmux_libc_interprocess_signal_t ipxsig);

mmux_cc_libc_decl bool mmux_libc_interprocess_signal_parse (mmux_libc_interprocess_signal_t * ipxsig_p,
							    mmux_asciizcp_t str, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_inline_decl mmux_libc_sigaction_flags_t
mmux_libc_sigaction_flags (mmux_standard_sint_t flags_num)
{
  return (mmux_libc_sigaction_flags_t) { { .value = flags_num } };
}

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

mmux_cc_libc_decl bool mmux_libc_retrieve_signal_handler_SIG_DFL (mmux_libc_sighandler_fun_t ** result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_retrieve_signal_handler_SIG_IGN (mmux_libc_sighandler_fun_t ** result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_retrieve_signal_handler_SIG_ERR (mmux_libc_sighandler_fun_t ** result_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_signal (mmux_libc_sighandler_fun_t ** result_p,
					 mmux_libc_interprocess_signal_t ipxsignal,
					 mmux_libc_sighandler_fun_t * action)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pause (void);

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sigemptyset (mmux_libc_sigset_t ipxsigset)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigfillset (mmux_libc_sigset_t ipxsigset)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigaddset (mmux_libc_sigset_t ipxsigset, mmux_libc_interprocess_signal_t ipxsig)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigdelset (mmux_libc_sigset_t ipxsigset, mmux_libc_interprocess_signal_t ipxsig)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigismember (bool * is_member_result_p,
					      mmux_libc_sigset_arg_t ipxsigset, mmux_libc_interprocess_signal_t ipxsig)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sigisemptyset (bool * is_empty_result_p, mmux_libc_sigset_arg_t ipxsigset)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigandset (mmux_libc_sigset_t ipxsigset_result,
					    mmux_libc_sigset_arg_t ipxsigset1, mmux_libc_sigset_arg_t ipxsigset2)
  __attribute__((__nonnull__(1,2,3)));

mmux_cc_libc_decl bool mmux_libc_sigorset (mmux_libc_sigset_t ipxsigset_result,
					   mmux_libc_sigset_arg_t ipxsigset1, mmux_libc_sigset_arg_t ipxsigset2)
  __attribute__((__nonnull__(1,2,3)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_blocking_mask_add_set (mmux_libc_sigset_arg_t ipxsigset,
									     mmux_libc_sigset_t old_blocking_mask)
  __attribute__((__nonnull__(1))); /* old_blocking_mask can be NULL. */

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_blocking_mask_remove_set (mmux_libc_sigset_arg_t ipxsigset,
										mmux_libc_sigset_t old_blocking_mask)
  __attribute__((__nonnull__(1))); /* old_blocking_mask can be NULL. */

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_blocking_mask_ref (mmux_libc_sigset_t current_blocking_mask)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_interprocess_signals_blocking_mask_set (mmux_libc_sigset_arg_t new_blocking_mask,
									 mmux_libc_sigset_t old_blocking_mask)
  __attribute__((__nonnull__(1))); /* old_blocking_mask can be NULL. */

mmux_cc_libc_decl bool mmux_libc_sigpending (mmux_libc_sigset_arg_t ipxsigset)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigsuspend (mmux_libc_sigset_arg_t temporary_blocking_mask)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigwait (mmux_libc_interprocess_signal_t * ipxsig_result_p,
					  mmux_libc_sigset_arg_t set_of_signals_to_wait_for)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sigwaitinfo (mmux_libc_siginfo_t siginfo_result,
					      mmux_libc_sigset_arg_t set_of_signals_to_wait_for)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sigtimedwait (mmux_libc_siginfo_t siginfo_result,
					       mmux_libc_sigset_arg_t set_of_signals_to_wait_for,
					       mmux_libc_timespec_arg_t timeout)
  __attribute__((__nonnull__(1,2,3)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sa_handler_ref (mmux_libc_sighandler_fun_t * * result_p,
						 mmux_libc_sigaction_arg_t action)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sa_handler_set (mmux_libc_sigaction_t action, mmux_libc_sighandler_fun_t * handler)
  __attribute__((__nonnull__(1,2)));


mmux_cc_libc_decl bool mmux_libc_sa_sigaction_ref (mmux_libc_sigaction_fun_t * * result_p,
						   mmux_libc_sigaction_arg_t action)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sa_sigaction_set (mmux_libc_sigaction_t action, mmux_libc_sigaction_fun_t * handler)
  __attribute__((__nonnull__(1,2)));


mmux_cc_libc_decl bool mmux_libc_sa_mask_ref (mmux_libc_sigset_t ipxsigset, mmux_libc_sigaction_arg_t action)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sa_mask_set (mmux_libc_sigaction_t action, mmux_libc_sigset_arg_t ipxsigset)
  __attribute__((__nonnull__(1)));


mmux_cc_libc_decl bool mmux_libc_sa_flags_ref (mmux_libc_sigaction_flags_t * result_p, mmux_libc_sigaction_arg_t action)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sa_flags_set (mmux_libc_sigaction_t action, mmux_libc_sigaction_flags_t flags)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigaction (mmux_libc_interprocess_signal_t ipxsig,
					    mmux_libc_sigaction_arg_t new_action,
					    mmux_libc_sigaction_t old_action);

/* ------------------------------------------------------------------ */

mmux_cc_libc_inline_decl mmux_libc_si_code_t
mmux_libc_si_code (mmux_standard_sint_t code_num)
{
  return (mmux_libc_si_code_t) { { .value = code_num } };
}

mmux_cc_libc_inline_decl bool
mmux_libc_si_code_equal (mmux_libc_si_code_t code1, mmux_libc_si_code_t code2)
{
  return (code1.value == code2.value)? true : false;
}

mmux_cc_libc_decl bool mmux_libc_si_signo_ref (mmux_libc_interprocess_signal_t * field_value_result_p,
					       mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_signo_set (mmux_libc_siginfo_t self,
					       mmux_libc_interprocess_signal_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_errno_ref (mmux_libc_errno_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_errno_set (mmux_libc_siginfo_t self, mmux_libc_errno_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_code_ref (mmux_libc_si_code_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_code_set (mmux_libc_siginfo_t self, mmux_libc_si_code_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_pid_ref (mmux_libc_pid_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_pid_set (mmux_libc_siginfo_t self, mmux_libc_pid_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_uid_ref (mmux_libc_uid_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_uid_set (mmux_libc_siginfo_t self, mmux_libc_uid_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_status_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_status_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_utime_ref (mmux_clock_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_utime_set (mmux_libc_siginfo_t self, mmux_clock_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_stime_ref (mmux_clock_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_stime_set (mmux_libc_siginfo_t self, mmux_clock_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_int_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_int_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_ptr_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_ptr_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_overrun_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_overrun_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_timerid_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_timerid_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_addr_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_addr_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_band_ref (mmux_slong_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_band_set (mmux_libc_siginfo_t self, mmux_slong_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_fd_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_fd_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_addr_lsb_ref (mmux_sshort_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_addr_lsb_set (mmux_libc_siginfo_t self, mmux_sshort_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_lower_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_lower_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_upper_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_upper_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_pkey_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_pkey_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_call_addr_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_call_addr_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_syscall_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_syscall_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_arch_ref (mmux_uint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_arch_set (mmux_libc_siginfo_t self, mmux_uint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_value_sival_int_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_value_sival_int_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_si_value_sival_ptr_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_si_value_sival_ptr_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sival_int_ref (mmux_sint_t * field_value_result_p, mmux_libc_sigval_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sival_int_set (mmux_libc_sigval_t self, mmux_sint_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sival_ptr_ref (mmux_pointer_t * field_value_result_p, mmux_libc_sigval_arg_t self)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_sival_ptr_set (mmux_libc_sigval_t self, mmux_pointer_t new_field_value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_sigqueue (mmux_libc_pid_t pid, mmux_libc_interprocess_signal_t ipxsig,
					   mmux_libc_sigval_arg_t the_val)
  __attribute__((__nonnull__(3)));


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

mmux_cc_libc_decl bool mmux_libc_passwd_dump (mmux_libc_fd_arg_t fd, mmux_libc_passwd_t const * passw_p,
					      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

DEFINE_STRUCT_SETTER_GETTER_PROTOS(group,	gr_name,	mmux_asciizcp_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(group,	gr_gid,		mmux_libc_gid_t)

mmux_cc_libc_decl bool mmux_libc_gr_mem_set (mmux_libc_group_t * const P, mmux_asciizcp_t * value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_gr_mem_ref (mmux_asciizcp_t * * result_p, mmux_libc_group_t const * const P)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_group_dump (mmux_libc_fd_arg_t fd, mmux_libc_group_t const * passw_p,
					     mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_uid (mmux_libc_uid_t * result_p, mmux_standard_libc_uid_t uid_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_uid_parse (mmux_libc_uid_t * p_value, mmux_asciizcp_t s_value, mmux_asciizcp_t who)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_uid_sprint (char * ptr, mmux_usize_t len, mmux_libc_uid_t uid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_uid_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_uid_t uid)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_gid (mmux_libc_gid_t * result_p, mmux_standard_libc_gid_t gid_num)
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

mmux_cc_libc_decl bool mmux_libc_getgrouplist (mmux_libc_gid_t * groups_p, mmux_usize_t * ngroups_p,
					       mmux_asciizcp_t username, mmux_libc_gid_t gid)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

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

mmux_cc_libc_inline_decl mmux_libc_linkat_flags_t
mmux_libc_linkat_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_linkat_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_unlinkat_flags_t
mmux_libc_unlinkat_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_unlinkat_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_renameat2_flags_t
mmux_libc_renameat2_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_renameat2_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_fchownat_flags_t
mmux_libc_fchownat_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_fchownat_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_chownfd_flags_t
mmux_libc_chownfd_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_chownfd_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_fchmodat_flags_t
mmux_libc_fchmodat_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_fchmodat_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_access_how_t
mmux_libc_access_how (mmux_standard_sint_t value)
{
  return (mmux_libc_access_how_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_faccessat_flags_t
mmux_libc_faccessat_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_faccessat_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_fstatat_flags_t
mmux_libc_fstatat_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_fstatat_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_statfd_flags_t
mmux_libc_statfd_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_statfd_flags_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_utimensat_flags_t
mmux_libc_utimensat_flags (mmux_standard_sint_t value)
{
  return (mmux_libc_utimensat_flags_t) { .value = value };
}

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl mmux_libc_file_system_pathname_class_t const mmux_libc_file_system_pathname_statically_allocated;
mmux_cc_libc_decl mmux_libc_file_system_pathname_class_t const mmux_libc_file_system_pathname_dynamically_allocated;

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_d_name_ref (mmux_asciizcpp_t result_p, mmux_libc_dirent_arg_t DE)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_d_fileno_ref (mmux_uintmax_t * result_p, mmux_libc_dirent_arg_t DE)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_dirent_dump (mmux_libc_fd_arg_t fd, mmux_libc_dirent_arg_t dirent_p,
					      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_validate_length_with_nul (mmux_usize_t fs_ptn_len_plus_nil);

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_validate_length_no_nul (mmux_usize_t fs_ptn_len);

#undef  MMUX_LIBC_FILE_SYSTEM_PATHNAME_VALIDATE_LENGTH_WITH_NUL
#define MMUX_LIBC_FILE_SYSTEM_PATHNAME_VALIDATE_LENGTH_WITH_NUL(LEN_WITH_NUL)		\
  {											\
    if (mmux_libc_file_system_pathname_validate_length_with_nul(LEN_WITH_NUL)) {	\
      mmux_libc_errno_set(MMUX_LIBC_ENAMETOOLONG);					\
      return true;									\
    }											\
  }

#undef  MMUX_LIBC_FILE_SYSTEM_PATHNAME_VALIDATE_LENGTH_NO_NUL
#define MMUX_LIBC_FILE_SYSTEM_PATHNAME_VALIDATE_LENGTH_NO_NUL(LEN_NO_NUL)	\
  {										\
    if (mmux_libc_file_system_pathname_validate_length_no_nul(LEN_NO_NUL)) {	\
      mmux_libc_errno_set(MMUX_LIBC_ENAMETOOLONG);				\
      return true;								\
    }										\
  }

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_factory_static (mmux_libc_fs_ptn_factory_t ptn_factory)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_factory_dynamic (mmux_libc_fs_ptn_factory_copying_t ptn_factory)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_factory_swallow (mmux_libc_fs_ptn_factory_t ptn_factory)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname (mmux_libc_fs_ptn_t fs_ptn_result,
							    mmux_libc_fs_ptn_factory_arg_t fs_ptn_factory,
							    mmux_asciizcp_t src_ptn_asciiz)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname2 (mmux_libc_fs_ptn_t fs_ptn_result,
							     mmux_libc_fs_ptn_factory_copying_arg_t fs_ptn_factory,
							     mmux_asciicp_t src_ptn_ascii,
							     mmux_usize_t   src_ptn_len_excluding_nul)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_unmake_file_system_pathname (mmux_libc_fs_ptn_t fs_ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_unmake_file_system_pathname_variable (mmux_libc_fs_ptn_t * fs_ptn_p)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_ptr_ref (mmux_asciizcp_t * result_p,
							       mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_len_ref (mmux_usize_t * result_p,
							       mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_len_including_nul_ref
    (mmux_usize_t * fs_ptn_len_including_nul_result_p, mmux_libc_fs_ptn_arg_t fs_ptn)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_compare (mmux_ternary_comparison_result_t * result_p,
							       mmux_libc_fs_ptn_arg_t ptn1,
							       mmux_libc_fs_ptn_arg_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_equal (bool * result_p,
							     mmux_libc_fs_ptn_arg_t ptn1,
							     mmux_libc_fs_ptn_arg_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_not_equal (bool * result_p,
								 mmux_libc_fs_ptn_arg_t ptn1,
								 mmux_libc_fs_ptn_arg_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_less (bool * result_p,
							    mmux_libc_fs_ptn_arg_t ptn1,
							    mmux_libc_fs_ptn_arg_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_greater (bool * result_p,
							       mmux_libc_fs_ptn_arg_t ptn1,
							       mmux_libc_fs_ptn_arg_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_less_equal (bool * result_p,
								  mmux_libc_fs_ptn_arg_t ptn1,
								  mmux_libc_fs_ptn_arg_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_greater_equal (bool * result_p,
								     mmux_libc_fs_ptn_arg_t ptn1,
								     mmux_libc_fs_ptn_arg_t ptn2)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_special_directory (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_standalone_dot (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_standalone_double_dot (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_standalone_slash (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_absolute (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_relative (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_rootname
    (mmux_libc_fs_ptn_t				fs_ptn_result,
     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
     mmux_libc_fs_ptn_arg_t			fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_dirname
    (mmux_libc_fs_ptn_t				fs_ptn_result,
     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
     mmux_libc_fs_ptn_arg_t			fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_tailname
    (mmux_libc_fs_ptn_t				fs_ptn_result,
     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
     mmux_libc_fs_ptn_arg_t			fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_filename
    (mmux_libc_fs_ptn_t				fs_ptn_result,
     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
     mmux_libc_fs_ptn_arg_t			fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_normalised
    (mmux_libc_fs_ptn_t				fs_ptn_result,
     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
     mmux_libc_fs_ptn_arg_t			fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_concat
    (mmux_libc_fs_ptn_t				fs_ptn_result,
     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
     mmux_libc_fs_ptn_arg_t			fs_ptn_prefix,
     mmux_libc_fs_ptn_arg_t			fs_ptn_suffix)
  __attribute__((__nonnull__(1,2,3,4),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_extension (mmux_libc_fs_ptn_extension_t result_p,
								      mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_extension2 (mmux_libc_fs_ptn_extension_t result_p,
								       mmux_asciicp_t ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_extension1 (mmux_libc_fs_ptn_extension_t result_p,
								       mmux_asciizcp_t ptr)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_ptr_ref (mmux_asciicpp_t result_p,
									 mmux_libc_fs_ptn_extension_arg_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_len_ref (mmux_usize_t * result_p,
									 mmux_libc_fs_ptn_extension_arg_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_is_empty (bool * result_p,
									  mmux_libc_fs_ptn_extension_arg_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_has_extension (bool * result_p,
								     mmux_libc_fs_ptn_arg_t ptn,
								     mmux_libc_fs_ptn_extension_arg_t ext)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_extension_compare (mmux_ternary_comparison_result_t * result_p,
									 mmux_libc_fs_ptn_extension_arg_t E1,
									 mmux_libc_fs_ptn_extension_arg_t E2)
  __attribute__((__nonnull__(1)));

typedef bool mmux_libc_file_system_pathname_extension_comparison_predicate_t (bool * result_p,
									      mmux_libc_fs_ptn_extension_arg_t E1,
									      mmux_libc_fs_ptn_extension_arg_t E2);

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

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_segment_raw (mmux_libc_fs_ptn_segment_t result_p,
									mmux_asciizcp_t ptr, mmux_usize_t len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_make_file_system_pathname_segment_raw_asciiz (mmux_libc_fs_ptn_segment_t result_p,
									       mmux_asciizcp_t ptr)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_find_last (mmux_libc_fs_ptn_segment_t result_p,
									 mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_ptr_ref (mmux_asciizcpp_t result_p,
								       mmux_libc_fs_ptn_segment_arg_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_len_ref (mmux_usize_t * result_p,
								       mmux_libc_fs_ptn_segment_arg_t E)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_compare (mmux_ternary_comparison_result_t * result_p,
								       mmux_libc_fs_ptn_segment_arg_t E1,
								       mmux_libc_fs_ptn_segment_arg_t E2)
  __attribute__((__nonnull__(1)));

typedef bool mmux_libc_file_system_pathname_segment_comparison_predicate_t (bool * result_p,
									    mmux_libc_fs_ptn_segment_arg_t E1,
									    mmux_libc_fs_ptn_segment_arg_t E2);

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

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_is_dot (bool * result_p, mmux_libc_fs_ptn_segment_arg_t seg)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_is_double_dot (bool * result_p, mmux_libc_fs_ptn_segment_arg_t seg)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_segment_is_slash (bool * result_p, mmux_libc_fs_ptn_segment_arg_t seg)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_opendir (mmux_libc_dirstream_t result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fdopendir (mmux_libc_dirstream_t result_p, mmux_libc_dirfd_arg_t dirfd)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_closedir (mmux_libc_dirstream_arg_t DS)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readdir (bool * there_are_more_entries_p, mmux_libc_dirent_t result_p,
					  mmux_libc_dirstream_arg_t dirstream)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_dirfd (mmux_libc_dirfd_t result_p, mmux_libc_dirstream_arg_t dirstream)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_rewinddir (mmux_libc_dirstream_arg_t dirstream)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_telldir (mmux_libc_dirstream_position_t * result_p, mmux_libc_dirstream_arg_t dirstream)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_seekdir (mmux_libc_dirstream_arg_t dirstream, mmux_libc_dirstream_position_t dirpos)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getcwd_to_buffer (mmux_asciizp_t bufptr, mmux_usize_t buflen)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getcwd (mmux_libc_fs_ptn_t fs_ptn, mmux_libc_fs_ptn_factory_copying_arg_t fs_ptn_factory)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_get_current_dir_name (mmux_libc_fs_ptn_t fs_ptn,
						       mmux_libc_fs_ptn_factory_copying_arg_t fs_ptn_factory)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_chdir (mmux_libc_fs_ptn_arg_t dirptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchdir (mmux_libc_dirfd_arg_t fd)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_chroot (mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_pivot_root (mmux_libc_fs_ptn_arg_t new_root_ptn, mmux_libc_fs_ptn_arg_t put_old_ptn)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_link (mmux_libc_fs_ptn_arg_t oldname, mmux_libc_fs_ptn_arg_t newname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_linkat (mmux_libc_dirfd_arg_t oldfd, mmux_libc_fs_ptn_arg_t oldname,
					 mmux_libc_dirfd_arg_t newfd, mmux_libc_fs_ptn_arg_t newname,
					 mmux_libc_linkat_flags_t flags)
  __attribute__((__nonnull__(1,2,3,4),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_linkfd (mmux_libc_fd_arg_t fd_old,
					 mmux_libc_dirfd_arg_t dirfd_new, mmux_libc_fs_ptn_arg_t newname,
					 mmux_libc_linkat_flags_t flags)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_symlink (mmux_libc_fs_ptn_arg_t oldname, mmux_libc_fs_ptn_arg_t newname)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_symlinkat (mmux_libc_fs_ptn_arg_t oldname,
					    mmux_libc_dirfd_arg_t dirfd_new,
					    mmux_libc_fs_ptn_arg_t newname)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlink (mmux_libc_fs_ptn_t				fs_ptn_result,
					   mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
					   mmux_libc_fs_ptn_arg_t			fs_ptn_input_linkname)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlink_to_buffer (mmux_usize_t *		nbytes_written_to_output_buffer_no_nul_p,
						     mmux_asciip_t		output_buffer_ascii,
						     mmux_usize_t		output_buffer_provided_nbytes_no_nul,
						     mmux_libc_fs_ptn_arg_t	fs_ptn_input_linkname)
  __attribute__((__nonnull__(1,2,4),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_readlinkat_to_buffer (mmux_usize_t *		nbytes_written_to_output_buffer_no_nul_p,
						       mmux_asciip_t		output_buffer_ascii,
						       mmux_usize_t		output_buffer_provided_nbytes_no_nul,
						       mmux_libc_dirfd_arg_t	dirfd,
						       mmux_libc_fs_ptn_arg_t	fs_ptn_input_linkname)
  __attribute__((__nonnull__(1,2,4,5),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlinkfd_to_buffer (mmux_usize_t *		nbytes_written_to_output_buffer_no_nul_p,
						       mmux_asciip_t		output_buffer_ascii,
						       mmux_usize_t		output_buffer_provided_nbytes_no_nul,
						       mmux_libc_fd_arg_t	fd)
  __attribute__((__nonnull__(1,2,4),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlinkat (mmux_libc_fs_ptn_t				fs_ptn_result,
					     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
					     mmux_libc_dirfd_arg_t			dirfd,
					     mmux_libc_fs_ptn_arg_t			fs_ptn_input_linkname)
  __attribute__((__nonnull__(1,2,3,4),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_readlinkfd (mmux_libc_fs_ptn_t				fs_ptn_result,
					     mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
					     mmux_libc_fd_arg_t				fd)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_canonicalize_file_name (mmux_libc_fs_ptn_t		      fs_ptn_result,
							 mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
							 mmux_libc_fs_ptn_arg_t		      fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_canonicalise_file_name (mmux_libc_fs_ptn_t		      fs_ptn_result,
							 mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
							 mmux_libc_fs_ptn_arg_t			fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_realpath (mmux_libc_fs_ptn_t			fs_ptn_result,
					   mmux_libc_fs_ptn_factory_copying_arg_t	fs_ptn_factory,
					   mmux_libc_fs_ptn_arg_t		fs_ptn_input)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_unlink (mmux_libc_fs_ptn_arg_t pathname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_unlinkat (mmux_libc_dirfd_arg_t dirfd,
					   mmux_libc_fs_ptn_arg_t pathname,
					   mmux_libc_unlinkat_flags_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_rmdir (mmux_libc_fs_ptn_arg_t pathname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_remove (mmux_libc_fs_ptn_arg_t pathname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_rename (mmux_libc_fs_ptn_arg_t oldname, mmux_libc_fs_ptn_arg_t newname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_renameat (mmux_libc_dirfd_arg_t olddirfd, mmux_libc_fs_ptn_arg_t oldname,
					   mmux_libc_dirfd_arg_t newdirfd, mmux_libc_fs_ptn_arg_t newname)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_renameat2 (mmux_libc_dirfd_arg_t olddirfd, mmux_libc_fs_ptn_arg_t oldname,
					    mmux_libc_dirfd_arg_t newdirfd, mmux_libc_fs_ptn_arg_t newname,
					    mmux_libc_renameat2_flags_t flags)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_mkdir (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_mode_t mode)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_mkdirat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname, mmux_libc_mode_t mode)
  __attribute__((__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_chown (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchown (mmux_libc_fd_arg_t fd, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lchown (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchownat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname,
					   mmux_libc_uid_t uid, mmux_libc_gid_t gid,
					   mmux_libc_fchownat_flags_t flags)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_chownfd (mmux_libc_fd_arg_t fd, mmux_libc_uid_t uid, mmux_libc_gid_t gid,
					  mmux_libc_chownfd_flags_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_umask (mmux_libc_mode_t * old_mask_p, mmux_libc_mode_t new_mask)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getumask (mmux_libc_mode_t * current_mask_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_chmod (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchmod (mmux_libc_fd_arg_t fd, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fchmodat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname,
					   mmux_libc_mode_t mode, mmux_libc_fchmodat_flags_t flags)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_access (bool * access_is_permitted_p, mmux_libc_fs_ptn_arg_t pathname,
					 mmux_libc_access_how_t how)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_faccessat (bool * access_is_permitted_p, mmux_libc_dirfd_arg_t dirfd,
					    mmux_libc_fs_ptn_arg_t pathname,
					    mmux_libc_access_how_t how, mmux_libc_faccessat_flags_t flags)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_faccessat2 (bool * access_is_permitted_p, mmux_libc_dirfd_arg_t dirfd,
					     mmux_libc_fs_ptn_arg_t pathname,
					     mmux_libc_access_how_t how,
					     mmux_libc_faccessat_flags_t flags)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_truncate (mmux_libc_fs_ptn_arg_t pathname, mmux_off_t len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_ftruncate (mmux_libc_fd_arg_t fd, mmux_off_t len)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS]]],[[[m4_dnl
mmux_cc_libc_decl bool mmux_libc_$1_set (mmux_libc_stat_t stat_p, $2 value)
  __attribute__((__nonnull__(1)));
mmux_cc_libc_decl bool mmux_libc_$1_ref ($2 * value_p, mmux_libc_stat_arg_t stat_p)
  __attribute__((__nonnull__(1,2)));
]]])
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_mode,	mmux_libc_mode_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_ino,		mmux_libc_ino_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_dev,		mmux_libc_dev_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_nlink,	mmux_libc_nlink_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_uid,		mmux_libc_uid_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_gid,		mmux_libc_gid_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_size,	mmux_off_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_atime_sec,	mmux_time_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_atime_nsec,	mmux_slong_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_mtime_sec,	mmux_time_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_mtime_nsec,	mmux_slong_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_ctime_sec,	mmux_time_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_ctime_nsec,	mmux_slong_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_blocks,	mmux_libc_blkcnt_t)
DEFINE_STRUCT_STAT_SETTER_GETTER_PROTOS(st_blksize,	mmux_uint_t)

mmux_cc_libc_decl bool mmux_libc_stat_dump (mmux_libc_fd_arg_t fd, mmux_libc_stat_arg_t stat_p,
					    mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_stat (mmux_libc_stat_t stat_result, mmux_libc_fs_ptn_arg_t fs_ptn)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fstat (mmux_libc_stat_t stat_result, mmux_libc_fd_arg_t fd)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lstat (mmux_libc_stat_t stat_result, mmux_libc_fs_ptn_arg_t fs_ptn)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_fstatat (mmux_libc_stat_t stat_result,
					  mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname,
					  mmux_libc_fstatat_flags_t flags)
     __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_statfd (mmux_libc_stat_t stat_result, mmux_libc_fd_arg_t fd,
					 mmux_libc_statfd_flags_t flags)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_S_TYPEISMQ (bool * result_p, mmux_libc_stat_t stat_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_S_TYPEISSEM (bool * result_p, mmux_libc_stat_t stat_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_S_TYPEISSHM (bool * result_p, mmux_libc_stat_t stat_p)
  __attribute__((__nonnull__(1,2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_S_ISDIR (bool * result_p, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISCHR (bool * result_p, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISBLK (bool * result_p, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISREG (bool * result_p, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISFIFO (bool * result_p, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISLNK (bool * result_p, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_S_ISSOCK (bool * result_p, mmux_libc_mode_t mode)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_exists (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_regular (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_symlink (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_directory (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_character_special (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_block_special (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_fifo (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_is_socket (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_regular (bool * result_p, mmux_libc_fd_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_symlink (bool * result_p, mmux_libc_fd_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_directory (bool * result_p, mmux_libc_fd_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_character_special (bool * result_p, mmux_libc_fd_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_block_special (bool * result_p, mmux_libc_fd_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_fifo (bool * result_p, mmux_libc_fd_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_is_socket (bool * result_p, mmux_libc_fd_arg_t ptn)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_file_system_pathname_file_size_ref (mmux_usize_t * result_p,
								     mmux_libc_dirfd_arg_t dirfd,
								     mmux_libc_fs_ptn_arg_t ptn)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_file_descriptor_file_size_ref (mmux_usize_t * result_p, mmux_libc_fd_arg_t fd)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_actime_set (mmux_libc_utimbuf_t utimbuf_p, mmux_time_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_modtime_set (mmux_libc_utimbuf_t utimbuf_p, mmux_time_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_actime_ref (mmux_time_t * value_p, mmux_libc_utimbuf_arg_t utimbuf_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_modtime_ref (mmux_time_t * value_p, mmux_libc_utimbuf_arg_t utimbuf_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_utimbuf_dump (mmux_libc_fd_arg_t fd, mmux_libc_utimbuf_arg_t utimbuf_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_utime (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_utimbuf_arg_t utimbuf_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_utimes (mmux_libc_fs_ptn_arg_t pathname,
					 mmux_libc_timeval_arg_t access_timeval,
					 mmux_libc_timeval_arg_t modification_timeval)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_lutimes (mmux_libc_fs_ptn_arg_t pathname,
					  mmux_libc_timeval_arg_t access_timeval,
					  mmux_libc_timeval_arg_t modification_timeval)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_futimes (mmux_libc_fd_arg_t fd,
					  mmux_libc_timeval_arg_t access_timeval,
					  mmux_libc_timeval_arg_t modification_timeval)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_futimens (mmux_libc_fd_arg_t fd,
					   mmux_libc_timespec_arg_t access_timespec,
					   mmux_libc_timespec_arg_t modification_timespec)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_utimensat (mmux_libc_dirfd_arg_t dirfd,
					    mmux_libc_fs_ptn_arg_t pathname,
					    mmux_libc_timespec_arg_t access_timespec,
					    mmux_libc_timespec_arg_t modification_timespec,
					    mmux_libc_utimensat_flags_t flags)
  __attribute__((__nonnull__(1),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Sockets.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_inline_decl mmux_libc_socket_address_family_t
mmux_libc_socket_address_family (mmux_standard_sshort_t value)
{
  return (mmux_libc_socket_address_family_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_socket_protocol_family_t
mmux_libc_socket_protocol_family (mmux_standard_sshort_t value)
{
  return (mmux_libc_socket_protocol_family_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_socket_internet_protocol_t
mmux_libc_socket_internet_protocol (mmux_standard_sshort_t value)
{
  return (mmux_libc_socket_internet_protocol_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_socket_communication_style_t
mmux_libc_socket_communication_style (mmux_standard_sint_t value)
{
  return (mmux_libc_socket_communication_style_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_libc_network_interface_index_t
mmux_libc_network_interface_index (mmux_standard_uint_t value)
{
  return (mmux_libc_network_interface_index_t) { .value = value };
}

/* ------------------------------------------------------------------ */

mmux_cc_libc_inline_decl mmux_host_byteorder_uint16_t
mmux_host_byteorder_uint16 (mmux_standard_uint16_t value)
{
  return (mmux_host_byteorder_uint16_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_network_byteorder_uint16_t
mmux_network_byteorder_uint16 (mmux_standard_uint16_t value)
{
  return (mmux_network_byteorder_uint16_t) { .value = value };
}

mmux_cc_libc_inline_decl mmux_host_byteorder_uint32_t
mmux_host_byteorder_uint32 (mmux_standard_uint32_t value)
{
  return (mmux_host_byteorder_uint32_t) { .value = value };
}
mmux_cc_libc_inline_decl mmux_network_byteorder_uint32_t
mmux_network_byteorder_uint32 (mmux_standard_uint32_t value)
{
  return (mmux_network_byteorder_uint32_t) { .value = value };
}

/* ------------------------------------------------------------------ */

DEFINE_STRUCT_SETTER_GETTER_PROTOS(in_addr,		s_addr,		mmux_uint32_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(if_nameindex,	if_index,	mmux_libc_network_interface_index_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(if_nameindex,	if_name,	mmux_asciizp_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr,		sa_family,	mmux_libc_socket_address_family_t)

DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_un,		sun_family,	mmux_libc_socket_address_family_t)

mmux_cc_libc_decl bool mmux_libc_sun_path_set (mmux_libc_sockaddr_un_t * const P, mmux_libc_fs_ptn_arg_t pathname)
  __attribute__((__nonnull__(1,2)));
mmux_cc_libc_decl bool mmux_libc_sun_path_ref (mmux_libc_fs_ptn_t fs_ptn_result, mmux_libc_sockaddr_un_t const * const P)
  __attribute__((__nonnull__(1,2)));

DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_in,		sin_family,	mmux_libc_socket_address_family_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_in,		sin_addr,	mmux_libc_in_addr_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(sockaddr_in,		sin_port,	mmux_host_byteorder_uint16_t)

mmux_cc_libc_decl bool mmux_libc_sin_addr_p_ref (mmux_libc_in_addr_t ** sin_addr_pp, mmux_libc_sockaddr_in_t * sockaddr_p)
  __attribute__((__nonnull__(1,2)));

DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_family,   mmux_libc_socket_address_family_t, sinsix_family)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_addr,     mmux_libc_insix_addr_t, sinsix_addr)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_flowinfo, mmux_uint32_t,          sinsix_flowinfo)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_scope_id, mmux_uint32_t,          sinsix_scope_id)
DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_port,     mmux_host_byteorder_uint16_t, sinsix_port)

mmux_cc_libc_decl bool mmux_libc_sinsix_addr_p_ref (mmux_libc_insix_addr_t ** sinsix_addr_pp,
						    mmux_libc_sockaddr_insix_t const * sockaddr_p)
  __attribute__((__nonnull__(1,2)));

DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_flags,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_family,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_socktype,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_protocol,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER_PROTOS(addrinfo, ai_addrlen,	mmux_libc_socklen_t)
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

mmux_cc_libc_decl bool mmux_libc_in_addr_dump (mmux_libc_fd_arg_t fd, mmux_libc_in_addr_t const * in_addr_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_insix_addr_dump (mmux_libc_fd_arg_t fd, mmux_libc_insix_addr_t const * insix_addr_p,
						  mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_if_nameindex_dump (mmux_libc_fd_arg_t fd,
						    mmux_libc_if_nameindex_t const * nameindex_p,
						    mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_dump (mmux_libc_fd_arg_t fd,
						mmux_libc_sockaddr_t const * sockaddr_p,
						mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_un_dump (mmux_libc_fd_arg_t fd, mmux_libc_sockaddr_un_t const * sockaddr_un_p,
						   mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_in_dump (mmux_libc_fd_arg_t fd, mmux_libc_sockaddr_in_t const * sockaddr_in_p,
						   mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_sockaddr_insix_dump (mmux_libc_fd_arg_t fd, mmux_libc_sockaddr_insix_t const * sockaddr_insix_p,
						      mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_addrinfo_dump (mmux_libc_fd_arg_t fd, mmux_libc_addrinfo_t const * addrinfo_p,
						mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_hostent_dump (mmux_libc_fd_arg_t fd, mmux_libc_hostent_t const * hostent_p,
					       mmux_asciizcp_t struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_servent_dump (mmux_libc_fd_arg_t fd, mmux_libc_servent_t const * servent_p,
					       mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_protoent_dump (mmux_libc_fd_arg_t fd, mmux_libc_protoent_t const * protoent_p,
						mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_netent_dump (mmux_libc_fd_arg_t fd, mmux_libc_netent_t const * netent_p,
					      mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

mmux_cc_libc_decl bool mmux_libc_linger_dump (mmux_libc_fd_arg_t fd, mmux_libc_linger_t const * linger_p,
					      mmux_asciizcp_t const struct_name)
  __attribute__((__nonnull__(2)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_in_addr (mmux_libc_in_addr_t * in_addr_p,
					       mmux_standard_uint32_t network_byteorder_value)
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

mmux_cc_libc_decl bool mmux_libc_htons (mmux_network_byteorder_uint16_t * result_p, mmux_host_byteorder_uint16_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ntohs (mmux_host_byteorder_uint16_t * result_p, mmux_network_byteorder_uint16_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_htonl (mmux_network_byteorder_uint32_t * result_p, mmux_host_byteorder_uint32_t value)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_ntohl (mmux_host_byteorder_uint32_t * result_p, mmux_network_byteorder_uint32_t value)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_inet_aton (mmux_libc_in_addr_ptr_t ouput_addr_p, mmux_asciizcp_t input_presentation_p)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_inet_ntoa (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
					    mmux_libc_in_addr_ptr_t input_addr_p)
  __attribute__((__nonnull__(1,3)));

mmux_cc_libc_decl bool mmux_libc_inet_pton (mmux_pointer_t ouput_addr_p,
					    mmux_libc_socket_address_family_t input_af_family, mmux_asciizcp_t input_presentation_p)
  __attribute__((__nonnull__(1,3)));

mmux_cc_libc_decl bool mmux_libc_inet_ntop (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
					    mmux_libc_socket_address_family_t input_af_family,
					    mmux_pointerc_t const input_addr_p)
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

mmux_cc_libc_decl bool mmux_libc_getnameinfo (mmux_asciizcp_t result_hostname_p, mmux_libc_socklen_t provided_hostname_len,
					      mmux_asciizcp_t result_servname_p, mmux_libc_socklen_t provided_servname_len,
					      mmux_sint_t * result_error_code_p,
					      mmux_libc_sockaddr_ptr_t input_sockaddr_p, mmux_libc_socklen_t input_sockaddr_size,
					      mmux_sint_t flags)
  __attribute__((__nonnull__(1,3,5,6),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_sethostent (bool stayopen);

mmux_cc_libc_decl bool mmux_libc_endhostent (void);

mmux_cc_libc_decl bool mmux_libc_gethostent (mmux_libc_hostent_t const * * result_hostent_pp)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_setservent (bool stayopen);

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

mmux_cc_libc_decl bool mmux_libc_setprotoent (bool stayopen);

mmux_cc_libc_decl bool mmux_libc_endprotoent (void);

mmux_cc_libc_decl bool mmux_libc_getprotoent (mmux_libc_protoent_t const * * result_protoent_pp)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getprotobyname (mmux_libc_protoent_t const * * result_protoent_pp, mmux_asciizcp_t protocol_name_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getprotobynumber (mmux_libc_protoent_t const * * result_protoent_pp,
						   mmux_libc_socket_internet_protocol_t protocol)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_setnetent (bool stayopen);

mmux_cc_libc_decl bool mmux_libc_endnetent (void);

mmux_cc_libc_decl bool mmux_libc_getnetent (mmux_libc_netent_t const * * result_netent_pp)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_getnetbyname (mmux_libc_netent_t const * * result_netent_pp,
					       mmux_asciizcp_t network_name_p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getnetbyaddr (mmux_libc_netent_t const * * result_netent_pp,
					       mmux_host_byteorder_uint32_t network_number,
					       mmux_libc_socket_address_family_t family)
  __attribute__((__nonnull__(1),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_if_nametoindex (mmux_libc_network_interface_index_t * index_p,
						 mmux_asciizcp_t network_interface_name)
  __attribute__((__nonnull__(1,2)));

mmux_cc_libc_decl bool mmux_libc_if_indextoname (mmux_asciizp_t buffer, mmux_libc_network_interface_index_t index)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_if_nameindex (mmux_libc_if_nameindex_t const * * result_nameindex_array_p)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_if_freenameindex (mmux_libc_if_nameindex_t const * nameindex_array)
  __attribute__((__nonnull__(1)));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_make_network_socket (mmux_libc_network_socket_t * result_p,
						      mmux_standard_sint_t sock_num)
  __attribute__((__nonnull__(1)));

mmux_cc_libc_decl bool mmux_libc_socket (mmux_libc_network_socket_t * result_sock_p,
					 mmux_libc_socket_protocol_family_t     namespace,
					 mmux_libc_socket_communication_style_t style,
					 mmux_libc_socket_internet_protocol_t   ipproto)
  __attribute__((__nonnull__(1),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_shutdown (mmux_libc_network_socket_t * sockp, mmux_libc_socket_shutdown_mode_t how)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_socketpair (mmux_libc_network_socket_t * result_sock1_p,
					     mmux_libc_network_socket_t * result_sock2_p,
					     mmux_libc_socket_protocol_family_t namespace,
					     mmux_libc_socket_communication_style_t style,
					     mmux_libc_socket_internet_protocol_t ipproto)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_connect (mmux_libc_network_socket_t * sockp,
					  mmux_libc_sockaddr_ptr_t sockaddr_pointer,
					  mmux_libc_socklen_t sockaddr_size)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_bind (mmux_libc_network_socket_t * sockp,
				       mmux_libc_sockaddr_ptr_t sockaddr_pointer,
				       mmux_libc_socklen_t sockaddr_size)
  __attribute__((__nonnull__(2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_listen (mmux_libc_network_socket_t * sockp,
					 mmux_uint_t pending_connections_queue_length)
  __attribute__((__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_accept (mmux_libc_network_socket_t * result_connected_sock_p,
					 mmux_libc_sockaddr_ptr_t result_client_sockaddr_p,
					 mmux_libc_socklen_t * result_client_sockaddr_size_p,
					 mmux_libc_network_socket_t * server_sockp)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_accept4 (mmux_libc_network_socket_t * result_connected_sock_p,
					  mmux_libc_sockaddr_ptr_t result_client_sockaddr_p,
					  mmux_libc_socklen_t * result_client_sockaddr_size_p,
					  mmux_libc_network_socket_t * server_sockp,
					  mmux_sint_t flags)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getpeername (mmux_libc_network_socket_t * sockp,
					      mmux_libc_sockaddr_ptr_t sockaddr_all,
					      mmux_libc_socklen_t * sockaddr_all_size_p)
  __attribute__((__nonnull__(2,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_getsockname (mmux_libc_network_socket_t * sockp,
					      mmux_libc_sockaddr_ptr_t sockaddr_all,
					      mmux_libc_socklen_t * sockaddr_all_size_p)
  __attribute__((__nonnull__(2,3),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_send (mmux_usize_t * result_number_of_bytes_sent_p,
				       mmux_libc_network_socket_t * sockp,
				       mmux_pointer_t bufptr, mmux_usize_t buflen,
				       mmux_sint_t flags)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_recv (mmux_usize_t * result_number_of_bytes_received_p,
				       mmux_libc_network_socket_t * sockp,
				       mmux_pointer_t bufptr, mmux_usize_t buflen,
				       mmux_sint_t flags)
  __attribute__((__nonnull__(1,3),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_sendto (mmux_usize_t * result_number_of_bytes_sent_p,
					 mmux_libc_network_socket_t * sockp,
					 mmux_pointer_t bufptr, mmux_usize_t buflen,
					 mmux_sint_t flags,
					 mmux_libc_sockaddr_ptr_t destination_sockaddr_p,
					 mmux_libc_socklen_t destination_sockaddr_size)
  __attribute__((__nonnull__(1,3,6),__warn_unused_result__));

/* The arguments  "result_sender_sockaddr_p" and  "result_sender_sockaddr_size_p" can
   be NULL if we are not interested in retrieving the sender address. */
mmux_cc_libc_decl bool mmux_libc_recvfrom (mmux_usize_t * result_number_of_bytes_received_p,
					   mmux_libc_sockaddr_ptr_t result_sender_sockaddr_p,
					   mmux_libc_socklen_t * result_sender_sockaddr_size_p,
					   mmux_libc_network_socket_t * sockp,
					   mmux_pointer_t bufptr, mmux_usize_t buflen,
					   mmux_sint_t flags)
  __attribute__((__nonnull__(1,5),__warn_unused_result__));

/* ------------------------------------------------------------------ */

mmux_cc_libc_decl bool mmux_libc_getsockopt (mmux_pointer_t result_optval_p, mmux_libc_socklen_t * result_optlen_p,
					     mmux_libc_network_socket_t * sockp, mmux_sint_t level, mmux_sint_t optname)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

mmux_cc_libc_decl bool mmux_libc_setsockopt (mmux_libc_network_socket_t * sockp, mmux_sint_t level, mmux_sint_t optname,
					     mmux_pointer_t optval_p, mmux_libc_socklen_t optlen)
  __attribute__((__nonnull__(4),__warn_unused_result__));


/** --------------------------------------------------------------------
 ** Interface specification.
 ** ----------------------------------------------------------------- */

mmux_cc_libc_decl bool mmux_libc_interface_specification_is_compatible (bool * result_p,
									mmux_libc_interface_specification_t const * IS,
									mmux_uint_t requested_version)
  __attribute__((__nonnull__(1)));


/** --------------------------------------------------------------------
 ** Done.
 ** ----------------------------------------------------------------- */

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* MMUX_CC_LIBC_FUNCTIONS_H */

/* end of file */
