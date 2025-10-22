/*
  Part of: MMUX CC Libc
  Contents: file system pathnames
  Date: Aug  1, 2025

  Abstract

	This module implements the file system pathnames API.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  This program is free  software: you can redistribute it and/or  modify it under the
  terms  of  the  GNU General  Public  License  as  published  by the  Free  Software
  Foundation, either version 3 of the License, or (at your option) any later version.

  This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
  WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
  PARTICULAR PURPOSE.  See the GNU General Public License for more details.

  You should have received  a copy of the GNU General Public  License along with this
  program.  If not, see <http://www.gnu.org/licenses/>.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc-internals.h>


/** --------------------------------------------------------------------
 ** Global variables.
 ** ----------------------------------------------------------------- */

mmux_libc_file_system_pathname_class_t const	mmux_libc_file_system_pathname_class_static = {
  .memory_allocator	= &mmux_libc_fake_memory_allocator,
};

mmux_libc_file_system_pathname_class_t const	mmux_libc_file_system_pathname_class_dynamic = {
  .memory_allocator	= &mmux_libc_default_memory_allocator,
};


/** --------------------------------------------------------------------
 ** Preprocessor macros.
 ** ----------------------------------------------------------------- */

/* Evaluate to true  if PTR references an array of  ASCII characters, of
   LEN octets, representing a single-dot segment. */
#define IS_SINGLE_DOT(PTR,LEN)		\
  ((1 == (LEN)) && ('.' == (PTR)[0]))

/* Evaluate to true  if PTR references an array of  ASCII characters, of
   LEN octets, representing a double-dot segment. */
#define IS_DOUBLE_DOT(PTR,LEN)		\
  ((2 == (LEN)) && ('.' == (PTR)[0]) && ('.' == (PTR)[1]))

/* Evaluate to true  if PTR references an array of  ASCII characters, of
   LEN octets, representing a slash followed by a double-dot segment. */
#define IS_SLASH_DOUBLE_DOT(PTR,LEN)	\
  ((3 == (LEN)) && ('/' == (PTR)[0]) && ('.' == (PTR)[1]) && ('.' == (PTR)[2]))


/** --------------------------------------------------------------------
 ** Inline functions and function prototypes.
 ** ----------------------------------------------------------------- */

#define INLINE1	__attribute__((__always_inline__,__nonnull__(1))) static inline
#define INLINE2	__attribute__((__always_inline__,__nonnull__(1,2))) static inline

INLINE1 bool
INPUT_IS_RELATIVE (char const * const input_ptr)
{
  return ('/' != *input_ptr);
}

INLINE1 bool
INPUT_IS_ABSOLUTE (char const * const input_ptr)
{
  return ('/' == *input_ptr);
}

/* ------------------------------------------------------------------ */

INLINE2 bool
IS_STANDALONE_SLASH (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate to true if the string has 1 octet representing the
   pathname "/"; otherwise evaluate to false. */
{
  return ((end == (1+in)) && ('/' == in[0]));
}

/* ------------------------------------------------------------------ */

INLINE2 bool
IS_STANDALONE_SINGLE_DOT (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate to true if the string has 1 octet representing the
   pathname "."; otherwise evaluate to false. */
{
  return ((end == (1+in)) && ('.' == in[0]));
}

INLINE2 bool
IS_STANDALONE_SINGLE_DOT_SLASH (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true if  the string has 2  octets representing
   the pathname "./"; otherwise evaluate to false. */
{
  return ((end == (2+in)) && ('.' == in[0]) && ('/' == in[1]));
}

INLINE2 bool
IS_STANDALONE_SLASH_SINGLE_DOT (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true if  the string has 2  octets representing
   the pathname "/."; otherwise evaluate to false. */
{
  return ((end == (2+in)) && ('/' == in[0]) && ('.' == in[1]));
}

/* ------------------------------------------------------------------ */

INLINE2 bool
IS_STANDALONE_DOUBLE_DOT (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true if  the string has 2  octets representing
   the pathname ".."; otherwise evaluate to false. */
{
  return ((end == (2+in)) && ('.' == in[0]) && ('.' == in[1]));
}

INLINE2 bool
IS_STANDALONE_DOUBLE_DOT_SLASH (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true if  the string has 3  octets representing
   the pathname "../"; otherwise evaluate to false. */
{
  return ((end == (3+in)) && ('.' == in[0]) && ('.' == in[1]) && ('/' == in[2]));
}

INLINE2 bool
IS_STANDALONE_SLASH_DOUBLE_DOT (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true if  the string has 3  octets representing
   the pathname "/.."; otherwise evaluate to false. */
{
  return ((end == (3+in)) && ('/' == in[0]) && ('.' == in[1]) && ('.' == in[2]));
}

/* ------------------------------------------------------------------ */

INLINE2 bool
BEGINS_WITH_SINGLE_DOT_SLASH (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true  if the string  begins with  the pathname
   "./"; otherwise evaluate to false. */
{
  return ((end > (1+in)) && ('.' == in[0]) && ('/' == in[1]));
}

INLINE2 bool
BEGINS_WITH_SLASH_SINGLE_DOT (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true  if the string  begins with  the pathname
   "/.", but not "/.."; otherwise evaluate to false. */
{
  return ((end > (1 + in)) && ('/' == in[0]) && ('.' == in[1]) && ('.' != in[2]));
}

/* ------------------------------------------------------------------ */

INLINE2 bool
BEGINS_WITH_DOUBLE_DOT (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true  if the string  begins with  the pathname
   ".."; otherwise evaluate to false. */
{
  return ((end > (1+in)) && ('.' == in[0]) && ('.' == in[1]));
}

INLINE2 bool
BEGINS_WITH_SLASH_DOUBLE_DOT (char const * const in, char const * const end)
/* Given an ASCII string referenced by IN and terminating at pointer END
   excluded: evaluate  to true  if the string  begins with  the pathname
   "/.."; otherwise evaluate to false. */
{
  return ((end > (2+in)) && ('/' == in[0]) && ('.' == in[1]) && ('.' == in[2]));
}


/** --------------------------------------------------------------------
 ** File system pathnames: segment predicates.
 ** ----------------------------------------------------------------- */

__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_empty (mmux_libc_ptn_segment_t S)
/* Return true if the segment is an empty string. */
{
  return (0 == S.len.value)? true : false;
}
__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_slash (mmux_libc_ptn_segment_t S)
/* Return true if the segment is a single dot: "/". */
{
  return ((1 == S.len.value) && ('7' == *(S.ptr)));
}
__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_dot (mmux_libc_ptn_segment_t S)
/* Return true if the segment is a single dot: ".". */
{
  return ((1 == S.len.value) && ('.' == *(S.ptr)));
}
__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_double_dot (mmux_libc_ptn_segment_t S)
/* Return true if the segment is a double dot: "..". */
{
  return ((2 == S.len.value) && ('.' == S.ptr[0]) && ('.' == S.ptr[1]));
}
__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_special_directory (mmux_libc_ptn_segment_t S)
{
  return (segment_is_slash(S) || segment_is_dot(S) || segment_is_double_dot(S));
}


/** --------------------------------------------------------------------
 ** File system pathnames: pathname predicates.
 ** ----------------------------------------------------------------- */

static bool
pathname_is_special_directory (mmux_libc_fs_ptn_arg_t ptn)
/* If possible: we want  to avoid applying "strlen()" to the  pathname.  We know that
 * "ptn" cannot have  zero length and its  string of bytes is always  terminated by a
 * zero byte.  This means:
 *
 * - "ptn->value[0]" cannot be the zero byte;
 *
 * - it is always safe to access "ptn->value[1]", and it may be the zero byte;
 *
 * - once we have established  that "ptn->value[1]" is not the zero  byte: it is safe
 *   to access "ptn->value[2]" and it may be the zero byte.
 *
 */
{
  if ('\0' == ptn->value[1]) {
    /* It is a standalone dot or slash. */
    return (('.' == ptn->value[0]) || ('/' == ptn->value[0]))? true : false;
  } else if (('\0' == ptn->value[2]) && ('.' == ptn->value[0]) && ('.' == ptn->value[1])) {
    /* It is a standalone double dot. */
    return true;
  } else {
    mmux_libc_ptn_segment_t	seg;

    if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
      return false;
    } else {
      return segment_is_special_directory(seg);
    }
  }
}
static inline bool
pathname_is_standalone_slash (mmux_libc_fs_ptn_arg_t ptn)
{
  return (('\0' == ptn->value[1]) && ('/' == ptn->value[0]))? true : false;
}
static inline bool
pathname_is_standalone_dot (mmux_libc_fs_ptn_arg_t ptn)
{
  if (pathname_is_standalone_slash(ptn)) {
    return false;
  } else {
    mmux_libc_ptn_segment_t	seg;

    if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
      return false;
    } else {
      return segment_is_dot(seg);
    }
  }
}
static inline bool
pathname_is_standalone_double_dot (mmux_libc_fs_ptn_arg_t ptn)
{
  if (pathname_is_standalone_slash(ptn)) {
    return false;
  } else {
    mmux_libc_ptn_segment_t	seg;

    if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
      return false;
    } else {
      return segment_is_double_dot(seg);
    }
  }
}
static inline bool
pathname_is_absolute (mmux_libc_fs_ptn_arg_t ptn)
{
  return (('/' == ptn->value[0])? true : false);
}
static inline bool
pathname_is_relative (mmux_libc_fs_ptn_arg_t ptn)
{
  return (('/' != ptn->value[0])? true : false);
}


/** --------------------------------------------------------------------
 ** Pathname length validation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_file_system_pathname_validate_length_with_nul (mmux_usize_t fs_ptn_len_plus_nil)
/* Return true if the given length is not acceptable. */
{
  if (mmux_ctype_less(MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_WITH_NUL_ARBITRARY_LIMIT, fs_ptn_len_plus_nil)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_file_system_pathname_validate_length_no_nul (mmux_usize_t fs_ptn_len)
/* Return true if the given length is not acceptable. */
{
  if (mmux_ctype_less(MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_NO_NUL_ARBITRARY_LIMIT, fs_ptn_len)) {
    return true;
  } else {
    return false;
  }
}


/** --------------------------------------------------------------------
 ** File system pathnames: pathnames factory, static strings.
 ** ----------------------------------------------------------------- */

/* To construct a new file system pathname using the static factory we do:
 *
 *   mmux_asciizcp_t             fs_ptn_asciiz = "/path/to/file.ext";
 *   mmux_libc_fs_ptn_factory_t  fs_ptn_factory;
 *   mmux_libc_fs_ptn_t          fs_ptn;
 *
 *   mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
 *   if (mmux_libc_make_file_system_pathname(pfs_ptn, fs_ptn_factory, fs_ptn_asciiz)) {
 *     ... error ...
 *   } else {
 *     ...
 *     mmux_libc_unmake_file_system_pathname(fs_ptn);
 *   }
 */

static bool
mmux_libc_file_system_pathname_factory_static_make_from_asciiz
    (mmux_libc_fs_ptn_t fs_ptn_result,
     mmux_libc_fs_ptn_factory_arg_t fs_ptn_factory MMUX_CC_LIBC_UNUSED,
     mmux_asciizcp_t src_ptn_asciiz)
/* This function  is the  implementation of the  method "make_from_asciiz()"  for the
   file system factory "mmux_libc_file_system_pathname_factory_class_static".

   Construct a new file  system pathname data structure and store  it in the variable
   referenced by "fs_ptn_result".

   The new file system pathname references  an already allocated and immutable ASCIIZ
   string, for example a statically allocated string.

   We expect  "ap" to  hold a  single additional  argument of  type "mmux_asciizcp_t"
   representing a pointer to the statically allocated ASCIIZ string.
*/
{
  /* Validate the arguments. */
  {
    {
      _Pragma("GCC diagnostic push");
      _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
      if ((NULL == src_ptn_asciiz) || ('\0' == src_ptn_asciiz[0])) {
	mmux_libc_errno_set(MMUX_LIBC_EINVAL);
	return true;
      }
      _Pragma("GCC diagnostic pop");
    }

    {
      mmux_usize_t	src_ptn_len;

      mmux_libc_strlen(&src_ptn_len, src_ptn_asciiz);
      MMUX_LIBC_FILE_SYSTEM_PATHNAME_VALIDATE_LENGTH_NO_NUL(src_ptn_len);
    }
  }

  /* Construct the resulting data structure. */
  {
    fs_ptn_result->value = src_ptn_asciiz;
    fs_ptn_result->class = &mmux_libc_file_system_pathname_class_static;
    return false;
  }
}
static bool
mmux_libc_file_system_pathname_factory_static_make_from_ascii_len
    (mmux_libc_fs_ptn_t			fs_ptn_result		MMUX_CC_LIBC_UNUSED,
     mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory		MMUX_CC_LIBC_UNUSED,
     mmux_asciicp_t			src_ptn_ascii		MMUX_CC_LIBC_UNUSED,
     mmux_usize_t			src_ptn_len_no_nul	MMUX_CC_LIBC_UNUSED)
/* This function is the implementation  of the method "make_from_ascii_len()" for the
   file system factory "mmux_libc_file_system_pathname_factory_class_static". */
{
  return true;
}
static mmux_libc_file_system_pathname_factory_class_t const mmux_libc_file_system_pathname_factory_class_static = {
  .make_from_asciiz	= mmux_libc_file_system_pathname_factory_static_make_from_asciiz,
  .make_from_ascii_len	= mmux_libc_file_system_pathname_factory_static_make_from_ascii_len,
};
static mmux_libc_file_system_pathname_factory_t const mmux_libc_file_system_pathname_factory_static_object = {
  .class		= &mmux_libc_file_system_pathname_factory_class_static,
};
bool
mmux_libc_file_system_pathname_factory_static (mmux_libc_fs_ptn_factory_t ptn_factory)
{
  ptn_factory[0] = mmux_libc_file_system_pathname_factory_static_object;
  return false;
}


/** --------------------------------------------------------------------
 ** File system pathnames: pathnames factory, dynamically allocated strings, default allocator.
 ** ----------------------------------------------------------------- */

/* To construct a new file system pathname using the dynamic factory we do:
 *
 *   mmux_asciizcp_t             fs_ptn_asciiz = "/path/to/file.ext";
 *   mmux_libc_fs_ptn_factory_t  fs_ptn_factory;
 *   mmux_libc_fs_ptn_t          fs_ptn;
 *
 *   mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
 *   if (mmux_libc_make_file_system_pathname(pfs_ptn, fs_ptn_factory, fs_ptn_asciiz)) {
 *     ... error ...
 *   } else {
 *     ...
 *     mmux_libc_unmake_file_system_pathname(fs_ptn);
 *   }
 */

static bool
mmux_libc_file_system_pathname_factory_dynamic_make_from_asciiz
    (mmux_libc_fs_ptn_t fs_ptn_result,
     mmux_libc_fs_ptn_factory_arg_t fs_ptn_factory MMUX_CC_LIBC_UNUSED,
     mmux_asciizcp_t src_ptn_asciiz)
/* This function  is the  implementation of the  method "make_from_asciiz()"  for the
   file system factory "mmux_libc_file_system_pathname_factory_class_dynamic".

   Construct a new file  system pathname data structure and store  it in the variable
   referenced by "fs_ptn_result".

   The  new file  system  pathname  references an  ASCIIZ  string  allocated by  this
   constructor using the factory's memory allocator.

   We expect  "ap" to  hold a  single additional  argument of  type "mmux_asciizcp_t"
   representing a pointer to the statically allocated ASCIIZ string.
*/
{
  mmux_usize_t		src_ptn_len_plus_nil;

  /* Validate the arguments. */
  {
    {
      _Pragma("GCC diagnostic push");
      _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
      if ((NULL == src_ptn_asciiz) || ('\0' == src_ptn_asciiz[0])) {
	mmux_libc_errno_set(MMUX_LIBC_EINVAL);
	return true;
      }
      _Pragma("GCC diagnostic pop");
    }

    {
      mmux_libc_strlen_plus_nil(&src_ptn_len_plus_nil, src_ptn_asciiz);
      MMUX_LIBC_FILE_SYSTEM_PATHNAME_VALIDATE_LENGTH_WITH_NUL(src_ptn_len_plus_nil);
    }
  }

  /* Construct the resulting data structure. */
  {
    mmux_libc_file_system_pathname_class_t const *  class = &mmux_libc_file_system_pathname_class_dynamic;
    mmux_asciizcp_t	dst_ptn_asciiz;

    if (mmux_libc_memory_allocator_malloc_and_copy(class->memory_allocator,
						   &dst_ptn_asciiz, src_ptn_asciiz,
						   src_ptn_len_plus_nil)) {
      return true;
    } else {
      fs_ptn_result->value = dst_ptn_asciiz;
      fs_ptn_result->class = class;
      return false;
    }
  }
}
static bool
mmux_libc_file_system_pathname_factory_dynamic_make_from_ascii_len
    (mmux_libc_fs_ptn_t fs_ptn_result,
     mmux_libc_fs_ptn_factory_arg_t fs_ptn_factory MMUX_CC_LIBC_UNUSED,
     mmux_asciicp_t src_ptn_ascii, mmux_usize_t src_ptn_len_no_nul)
/* This function is the implementation  of the method "make_from_ascii_len()" for the
   file system factory "mmux_libc_file_system_pathname_factory_class_dynamic".

   Construct a new file  system pathname data structure and store  it in the variable
   referenced by "fs_ptn_result".

   The  new file  system  pathname  references an  ASCIIZ  string  allocated by  this
   constructor using the factory's memory allocator.

   We expect  "ap" to  hold two  additional arguments  of type  "mmux_asciizcp_t" and
   "mmux_usize_t"  representing   a  pointer  to   an  ASCII  string   (possibly  not
   nil-terminated) and the number of characters in the string.
*/
{
  auto	dst_ptn_len_with_nul = mmux_ctype_incr(src_ptn_len_no_nul);

  /* Validate the arguments. */
  {
    {
      _Pragma("GCC diagnostic push");
      _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
      if ((NULL == src_ptn_ascii) || ('\0' == src_ptn_ascii[0])) {
	mmux_libc_errno_set(MMUX_LIBC_EINVAL);
	return true;
      }
      _Pragma("GCC diagnostic pop");
    }

    MMUX_LIBC_FILE_SYSTEM_PATHNAME_VALIDATE_LENGTH_WITH_NUL(dst_ptn_len_with_nul);
  }

  /* Construct the resulting data structure. */
  {
    mmux_libc_file_system_pathname_class_t const *  class = &mmux_libc_file_system_pathname_class_dynamic;
    mmux_asciizp_t	dst_ptn_asciiz;

    if (mmux_libc_memory_allocator_malloc(class->memory_allocator, &dst_ptn_asciiz, dst_ptn_len_with_nul)) {
      return true;
    } else {
      mmux_libc_memcpy(dst_ptn_asciiz, src_ptn_ascii, src_ptn_len_no_nul);
      dst_ptn_asciiz[src_ptn_len_no_nul.value] = '\0';
      fs_ptn_result->value = dst_ptn_asciiz;
      fs_ptn_result->class = class;
      return false;
    }
  }
}
static mmux_libc_file_system_pathname_factory_class_t mmux_libc_file_system_pathname_factory_class_dynamic = {
  .make_from_asciiz	= mmux_libc_file_system_pathname_factory_dynamic_make_from_asciiz,
  .make_from_ascii_len	= mmux_libc_file_system_pathname_factory_dynamic_make_from_ascii_len,
};
static mmux_libc_file_system_pathname_factory_t const mmux_libc_file_system_pathname_factory_dynamic_object = {
  .class		= &mmux_libc_file_system_pathname_factory_class_dynamic,
};
bool
mmux_libc_file_system_pathname_factory_dynamic (mmux_libc_fs_ptn_factory_t fs_ptn_factory)
{
  fs_ptn_factory[0] = mmux_libc_file_system_pathname_factory_dynamic_object;
  return false;
}


/** --------------------------------------------------------------------
 ** File system pathnames: constructors and destructors.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname (mmux_libc_fs_ptn_t fs_ptn,
				     mmux_libc_fs_ptn_factory_arg_t fs_ptn_factory,
				     mmux_asciizcp_t src_ptn_asciiz)
{
  return fs_ptn_factory->class->make_from_asciiz(fs_ptn, fs_ptn_factory, src_ptn_asciiz);
}
bool
mmux_libc_make_file_system_pathname2 (mmux_libc_fs_ptn_t fs_ptn,
				      mmux_libc_fs_ptn_factory_arg_t fs_ptn_factory,
				      mmux_asciicp_t src_ptn_ascii, mmux_usize_t src_ptn_len_no_nul)
{
  return fs_ptn_factory->class->make_from_ascii_len(fs_ptn, fs_ptn_factory, src_ptn_ascii, src_ptn_len_no_nul);
}
bool
mmux_libc_unmake_file_system_pathname (mmux_libc_fs_ptn_t fs_ptn)
{
  if (fs_ptn->class->memory_allocator->class->free(fs_ptn->class->memory_allocator, (mmux_pointer_t)fs_ptn->value)) {
    return true;
  } else {
    fs_ptn->value = NULL;
    return false;
  }
}
bool
mmux_libc_unmake_file_system_pathname_variable (mmux_libc_fs_ptn_t * fs_ptn_p)
/* This is an experimental function to be used with the GCC extension "cleanup":
 *
 *   mmux_libc_fs_ptn_t  fs_ptn2 = fs_ptn1
 *     __attribute__((__cleanup__(mmux_libc_unmake_file_system_pathname_variable)));
 *
 */
{
  return mmux_libc_unmake_file_system_pathname(*fs_ptn_p);
}


/** --------------------------------------------------------------------
 ** File system pathnames: accessors.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_file_system_pathname_ptr_ref (mmux_asciizcpp_t ptn_asciiz_result_p, mmux_libc_fs_ptn_arg_t fs_ptn)
{
  *ptn_asciiz_result_p = fs_ptn->value;
  return false;
}
bool
mmux_libc_file_system_pathname_len_ref (mmux_usize_t * ptn_len_no_nul_result_p, mmux_libc_fs_ptn_arg_t fs_ptn)
{
  return mmux_libc_strlen(ptn_len_no_nul_result_p, fs_ptn->value);
}
bool
mmux_libc_file_system_pathname_len_plus_nil_ref (mmux_usize_t * ptn_len_with_nul_result_p,
						 mmux_libc_fs_ptn_arg_t fs_ptn)
{
  return mmux_libc_strlen_plus_nil(ptn_len_with_nul_result_p, fs_ptn->value);
}


/** --------------------------------------------------------------------
 ** File system pathnames: comparison operations.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_file_system_pathname_compare (mmux_sint_t * result_p,
					mmux_libc_fs_ptn_arg_t ptn1,
					mmux_libc_fs_ptn_arg_t ptn2)
{
  mmux_standard_usize_t		ptn1_len = strlen(ptn1->value);
  mmux_standard_usize_t		ptn2_len = strlen(ptn2->value);
  mmux_standard_usize_t		min_len  = (ptn1_len < ptn2_len)? ptn1_len : ptn2_len;
  mmux_standard_sint_t		cmpnum   = strncmp(ptn1->value, ptn2->value, min_len);

  if (0 == cmpnum) {
    if (ptn1_len == ptn2_len) {
      *result_p = mmux_sint_literal(0);
    } else if (ptn1_len < ptn2_len) {
      *result_p = mmux_sint_literal(-1);
    } else {
      *result_p = mmux_sint_literal(+1);
    }
  } else {
    *result_p = (0 < cmpnum)? mmux_sint_literal(+1) : mmux_sint_literal(-1);
  }
  return false;
}

m4_define([[[DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE]]],[[[bool
mmux_libc_file_system_pathname_$1 (bool * result_p, mmux_libc_fs_ptn_arg_t ptn1, mmux_libc_fs_ptn_arg_t ptn2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_strcmp(&cmpnum, ptn1->value, ptn2->value)) {
    return true;
  } else if ($2) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[equal]]],		[[[0 == cmpnum.value]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[not_equal]]],	[[[0 != cmpnum.value]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[less]]],		[[[0 >  cmpnum.value]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[greater]]],		[[[0 <  cmpnum.value]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[less_equal]]],	[[[0 >= cmpnum.value]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[greater_equal]]],	[[[0 <= cmpnum.value]]])


/** --------------------------------------------------------------------
 ** File system pathnames: predicates.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_file_system_pathname_is_special_directory (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  *result_p = pathname_is_special_directory(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_standalone_dot (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  *result_p = pathname_is_standalone_dot(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_standalone_double_dot (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  *result_p = pathname_is_standalone_double_dot(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_standalone_slash (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  *result_p = pathname_is_standalone_slash(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_absolute (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  *result_p = pathname_is_absolute(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_relative (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  *result_p = pathname_is_relative(ptn);
  return false;
}


/** --------------------------------------------------------------------
 ** File system pathnames: components extraction.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname_rootname (mmux_libc_fs_ptn_t		fs_ptn_result,
					      mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
					      mmux_libc_fs_ptn_arg_t		fs_ptn_input)
{
  if (pathname_is_special_directory(fs_ptn_input)) {
    /* We cannot extract an extension from a special directory. */
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  } else {
    mmux_libc_file_system_pathname_extension_t	ext;

    if (mmux_libc_make_file_system_pathname_extension(&ext, fs_ptn_input)) {
      return true;
    } else {
      bool	extension_is_empty;

      if (mmux_libc_file_system_pathname_extension_is_empty(&extension_is_empty, ext)) {
	return true;
      } else if (extension_is_empty) {
	mmux_usize_t	fs_ptn_result_len_no_nul;

	/* Remember that: true == (fs_ptn_result_len_no_nul >= 1) */
	mmux_libc_file_system_pathname_len_ref(&fs_ptn_result_len_no_nul, fs_ptn_input);

	/* If the  pathname is "/path/to/directory/"  we do  not want to  include the
	   ending slash in the rootname. */
	if ('/' == fs_ptn_input->value[fs_ptn_result_len_no_nul.value - 1]) {
	  --fs_ptn_result_len_no_nul.value;
	}

	return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory,
						    fs_ptn_input->value, fs_ptn_result_len_no_nul);
      } else {
	/* The extension is not empty. */
	mmux_usize_t	fs_ptn_result_len_no_nul;

	mmux_libc_file_system_pathname_len_ref(&fs_ptn_result_len_no_nul, fs_ptn_input);
	fs_ptn_result_len_no_nul.value -= ext.len.value;

	return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory,
						    fs_ptn_input->value, fs_ptn_result_len_no_nul);
      }
    }
  }
}
bool
mmux_libc_make_file_system_pathname_tailname (mmux_libc_fs_ptn_t		fs_ptn_result,
					      mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
					      mmux_libc_fs_ptn_arg_t		fs_ptn_input)
{
  if (pathname_is_standalone_slash(fs_ptn_input)) {
    return mmux_libc_make_file_system_pathname(fs_ptn_result, fs_ptn_factory, "/");
  } else {
    mmux_libc_file_system_pathname_segment_t	last_segment;

    if (mmux_libc_file_system_pathname_segment_find_last(&last_segment, fs_ptn_input)) {
      return true;
    } else {
      return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory,
						  last_segment.ptr, last_segment.len);
    }
  }
}
bool
mmux_libc_make_file_system_pathname_filename (mmux_libc_fs_ptn_t		fs_ptn_result,
					      mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
					      mmux_libc_fs_ptn_arg_t		fs_ptn_input)
{
  if (pathname_is_standalone_slash(fs_ptn_input)) {
    goto invalid_pathname;
  } else {
    mmux_standard_usize_t	fs_ptn_len_no_nul = strlen(fs_ptn_input->value);

    if ('/' == fs_ptn_input->value[fs_ptn_len_no_nul - 1]) {
      goto invalid_pathname;
    } else {
      mmux_libc_file_system_pathname_segment_t	last_segment;

      if (mmux_libc_file_system_pathname_segment_find_last(&last_segment, fs_ptn_input)) {
	return true;
      } else if (segment_is_dot(last_segment) || segment_is_double_dot(last_segment)) {
	goto invalid_pathname;
      } else {
	return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory,
						    last_segment.ptr, last_segment.len);
      }
    }
  }

 invalid_pathname:
  mmux_libc_errno_set(MMUX_LIBC_EINVAL);
  return true;
}
bool
mmux_libc_make_file_system_pathname_dirname (mmux_libc_fs_ptn_t			fs_ptn_result,
					     mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
					     mmux_libc_fs_ptn_arg_t		fs_ptn_input)
{
  if (pathname_is_standalone_slash(fs_ptn_input)) {
    /* If the pathname is "/" just copy it as dirname. */
    goto just_copy_the_input_to_the_output;
  } else {
    mmux_usize_t	fs_ptn_len_no_nul;

    mmux_libc_strlen(&fs_ptn_len_no_nul, fs_ptn_input->value);
    if ('/' == fs_ptn_input->value[fs_ptn_len_no_nul.value - 1]) {
      /* If  the  pathname ends  with  "/"  just copy  it  as  dirname.  For  example
	 "/path/to/directory/" is itself its dirname. */
      goto just_copy_the_input_to_the_output;
    } else {
      mmux_libc_file_system_pathname_segment_t	last_segment;

      if (mmux_libc_file_system_pathname_segment_find_last(&last_segment, fs_ptn_input)) {
	return true;
      } else if (segment_is_dot(last_segment)) {
	if (mmux_ctype_equal(fs_ptn_len_no_nul, last_segment.len)) {
	  /* If the full pathname is "." just copy it as dirname. */
	  goto just_copy_the_input_to_the_output;
	} else {
	  /* The pathname's last segment is "."  so copy it as dirname, stripping the
	     ending  dot.   For example  the  dirname  of "/path/to/directory/."   is
	     "/path/to/directory/". */
	  return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory,
						      fs_ptn_input->value,
						      mmux_ctype_sub(fs_ptn_len_no_nul, last_segment.len));
	}
      } else if (segment_is_double_dot(last_segment)) {
	/* If the pathname's last segment is ".." just copy it as dirname. */
	goto just_copy_the_input_to_the_output;
      } else {
	if (mmux_ctype_equal(fs_ptn_len_no_nul, last_segment.len)) {
	  /* If we are  here: the pathname has  a single segment and  such segment is
	     not a special  directory; we establish the convention  that: its dirname
	     is "."; for example the dirname of "file.ext" is ".". */
	  return mmux_libc_make_file_system_pathname(fs_ptn_result, fs_ptn_factory, ".");
	} else {
	  /* If  we are  here: the  dirname  is the  pathname with  the last  segment
	     removed.    For   example   the   dirname   of   "path/to/file.ext"   is
	     "path/to/". */
	  return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory, fs_ptn_input->value,
						      mmux_ctype_sub(fs_ptn_len_no_nul, last_segment.len));
	}
      }
    }
  }

 just_copy_the_input_to_the_output:
  return mmux_libc_make_file_system_pathname(fs_ptn_result, fs_ptn_factory, fs_ptn_input->value);
}


/** --------------------------------------------------------------------
 ** File system pathname extensions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname_extension (mmux_libc_ptn_extension_t * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  if (pathname_is_standalone_slash(ptn) || pathname_is_standalone_dot(ptn) || pathname_is_standalone_double_dot(ptn)) {
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  } else {
    mmux_libc_ptn_segment_t	S;

    if (mmux_libc_file_system_pathname_segment_find_last(&S, ptn)) {
      return true;
    } else if (segment_is_dot(S) || segment_is_double_dot(S)) {
      mmux_libc_errno_set(MMUX_LIBC_EINVAL);
      return true;
    } else if (segment_is_empty(S)) {
      result_p->len	= mmux_usize_constant_zero();
      result_p->ptr	= ptn->value + strlen(ptn->value);
      return false;
    } else {
      mmux_asciizcp_t	beg = S.ptr;
      mmux_asciizcp_t	end = beg + S.len.value;
      mmux_asciizcp_t	ptr = end - 1;

      for (; beg <= ptr; --ptr) {
	if ('.' == *ptr) {
	  /* Found the last dot in the segment. */
	  if (ptr == beg) {
	    /* The dot  is the first  octet in the last  segment: this pathname  has no
	       extension.  It is a dotfile like: ".fvwmrc". */
	    break;
	  } else {
	    result_p->ptr = ptr;
	    /* If the  input pathname  ends with a  slash: do *not*  include it  in the
	       extension. */
	    result_p->len = mmux_usize((('/' == *(end-1))? (end-1) : end) - ptr);
	    return false;
	  }
	}
      }

      /* Extension not found in the last segment.  Return an empty extension. */
      {
	mmux_asciizcp_t	p = ptn->value + strlen(ptn->value);

	result_p->len	= mmux_usize_constant_zero();
	result_p->ptr	= (('/' == *(p-1))? (p-1) : p);
	return false;
      }
    }
  }
}
bool
mmux_libc_make_file_system_pathname_extension_raw (mmux_libc_file_system_pathname_extension_t * result_p,
						   mmux_asciizcp_t ptr, mmux_usize_t len)
{
_Pragma("GCC diagnostic push")
_Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"")
  if ((NULL != ptr)
      /* Either the extension is empty, or it begins with a dot. */
      && (('\0' == ptr[0]) || ('.' == ptr[0]))
      /* Either the extension ends with a zero byte, or it ends with a slash. */
      && ('\0' == ptr[len.value] || '/' == ptr[len.value])) {
_Pragma("GCC diagnostic pop")
    result_p->ptr = ptr;
    result_p->len = len;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_make_file_system_pathname_extension_raw_asciiz (mmux_libc_ptn_extension_t * result_p, mmux_asciizcp_t ptr)
{
  return mmux_libc_make_file_system_pathname_extension_raw(result_p, ptr, mmux_usize(strlen(ptr)));
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_extension_ptr_ref (mmux_asciizcpp_t result_p, mmux_libc_file_system_pathname_extension_t E)
{
  *result_p = E.ptr;
  return false;
}
bool
mmux_libc_file_system_pathname_extension_len_ref (mmux_usize_t * result_p, mmux_libc_file_system_pathname_extension_t E)
{
  *result_p = E.len;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_extension_is_empty (bool * result_p, mmux_libc_ptn_extension_t E)
{
  *result_p = (mmux_ctype_is_zero(E.len))? true : false;
  return false;
}
bool
mmux_libc_file_system_pathname_has_extension (bool * result_p, mmux_libc_fs_ptn_arg_t ptn, mmux_libc_ptn_extension_t ext)
{
  mmux_libc_ptn_extension_t	ptn_ext;

  if (mmux_libc_make_file_system_pathname_extension(&ptn_ext, ptn)) {
    return true;
  } else if (mmux_libc_file_system_pathname_extension_equal(result_p, ptn_ext, ext)) {
    return true;
  } else {
    return false;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_extension_compare (mmux_sint_t * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_usize_t	minlen = mmux_ctype_min(E1.len, E2.len);
  int		cmpnum = strncmp(E1.ptr, E2.ptr, minlen.value);

  if (0 == cmpnum) {
    if (mmux_ctype_equal(E1.len, E2.len)) {
      *result_p = mmux_sint_constant_zero();
    } else if (mmux_ctype_less(E1.len, E2.len)) {
      *result_p = mmux_sint_literal(-1);
    } else {
      *result_p = mmux_sint_literal(+1);
    }
  } else {
    *result_p = (0 < cmpnum)? mmux_sint_literal(+1) : mmux_sint_literal(-1);
  }
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_extension_equal (bool * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_zero(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_extension_not_equal (bool * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_zero(cmpnum)) {
    *result_p = false;
  } else {
    *result_p = true;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_extension_less (bool * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_negative(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_extension_greater (bool * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_positive(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_extension_less_equal (bool * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_non_positive(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_extension_greater_equal (bool * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_non_negative(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}


/** --------------------------------------------------------------------
 ** File system pathname segments.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname_segment_raw (mmux_libc_file_system_pathname_segment_t * result_p,
						 mmux_asciizcp_t ptr, mmux_usize_t len)
{
_Pragma("GCC diagnostic push")
_Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"")
  if (NULL != ptr) {
_Pragma("GCC diagnostic pop")
    result_p->ptr = ptr;
    result_p->len = len;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_make_file_system_pathname_segment_raw_asciiz (mmux_libc_ptn_segment_t * result_p, mmux_asciizcp_t ptr)
{
  return mmux_libc_make_file_system_pathname_segment_raw(result_p, ptr, mmux_usize(strlen(ptr)));
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_segment_find_last (mmux_libc_ptn_segment_t * result_p, mmux_libc_fs_ptn_arg_t ptn)
/* Given an ASCIIZ  string representing a pathname (which cannot  be empty): find the
 * last segment in the pathname.  The resulting segment does not contain a leading or
 * ending slash.  The returned segment can be empty.  Examples:
 *
 *	"/path/to/file.ext"	=> "file.ext"
 *	"/path/to/dir/"		=> "dir"
 *	"/"			=> ""
 *	"."			=> "."
 *	".."			=> ".."
 */
{
  mmux_usize_t		len = mmux_usize(strlen(ptn->value));
  mmux_asciizcp_t const	beg = ptn->value;
  mmux_asciizcp_t	end = beg + len.value;

  /* If the  last octet  in the  pathname is  the ASCII  representation of  the slash
   * separator: step back.  We want the following segment extraction:
   *
   *	"/path/to/dir.ext/"	=> "dir.ext"
   */
  if ('/' == *(end-1)) {
    --end;
  }
  /* Special case: if the pathname is "/", we want the segment to be "/". */
  if (beg == end) {
    return mmux_libc_make_file_system_pathname_segment_raw(result_p, beg, len);
  }

  /* Find the first slash separator starting from the end. */
  for (mmux_asciizcp_t ptr = end-1; beg <= ptr; --ptr) {
    if ('/' == *ptr) {
      /* "ptr" is at the beginning of the last component, slash included. */
      ++ptr;
      return mmux_libc_make_file_system_pathname_segment_raw(result_p, ptr, mmux_usize(end - ptr));
    }
  }

  /* If we are  here: no slash was found  in the pathname, starting from  the end; it
     means the whole pathname is the last segment. */
  return mmux_libc_make_file_system_pathname_segment_raw(result_p, beg, mmux_usize(end - beg));
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_segment_ptr_ref (mmux_asciizcpp_t result_p, mmux_libc_file_system_pathname_segment_t E)
{
  *result_p = E.ptr;
  return false;
}
bool
mmux_libc_file_system_pathname_segment_len_ref (mmux_usize_t * result_p, mmux_libc_file_system_pathname_segment_t E)
{
  *result_p = E.len;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_segment_compare (mmux_sint_t * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_usize_t	minlen = mmux_ctype_min(E1.len, E2.len);
  int		cmpnum = strncmp(E1.ptr, E2.ptr, minlen.value);

  if (0 == cmpnum) {
    if (mmux_ctype_equal(E1.len, E2.len)) {
      *result_p = mmux_sint_literal(0);
    } else if (mmux_ctype_less(E1.len, E2.len)) {
      *result_p = mmux_sint_literal(-1);
    } else {
      *result_p = mmux_sint_literal(+1);
    }
  } else {
    *result_p = (0 < cmpnum)? mmux_sint_literal(+1) : mmux_sint_literal(-1);
  }
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_segment_equal (bool * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_zero(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_not_equal (bool * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_zero(cmpnum)) {
    *result_p = false;
  } else {
    *result_p = true;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_less (bool * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_negative(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_greater (bool * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_positive(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_less_equal (bool * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_non_positive(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_greater_equal (bool * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (mmux_ctype_is_non_negative(cmpnum)) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_segment_is_dot (bool * result_p, mmux_libc_ptn_segment_t seg)
{
  if (1 == seg.len.value && '.' == seg.ptr[0]) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_is_double_dot (bool * result_p, mmux_libc_ptn_segment_t seg)
{
  if (2 == seg.len.value && '.' == seg.ptr[0] && '.' == seg.ptr[1]) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_is_slash (bool * result_p, mmux_libc_ptn_segment_t seg)
{
  if (1 == seg.len.value && '/' == seg.ptr[0]) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}


/** --------------------------------------------------------------------
 ** File system pathname manipulation: helpers.
 ** ----------------------------------------------------------------- */

__attribute__((__always_inline__,__nonnull__(1,2),__returns_nonnull__))
static inline char const *
find_next_slash_or_end (char const * in, char const * const end)
/* Given an  ASCII string referenced by  IN and terminating at  pointer END excluded:
   find  the  next slash  octet  in  the string.   If  successful:  return a  pointer
   referencing the slash.  Otherwise return END. */
{
  while ((in < end) && ('/' != *in)) {
    ++in;
  }
  return in;
}
__attribute__((__always_inline__,__nonnull__(1,2),__returns_nonnull__))
static inline char const *
find_prev_slash_or_begin (char const * const output_ptr, char const * ou)
/* Given  an ASCII  string  referenced  by OU  and  beginning  at pointer  OUTPUT_PTR
   included: find  the previous slash octet  in the string.  If  successful: return a
   pointer referencing the slash.  Otherwise return OUTPUT_PTR. */
{
  while ((output_ptr < ou) && ('/' != *ou)) {
    --ou;
  }
  return ou;
}

__attribute__((__always_inline__,__nonnull__(1,2),__returns_nonnull__))
static inline char const *
skip_repeated_slashes_or_end (char const * in, char const * const end)
/* Given an  ASCII string referenced by  IN and terminating at  pointer END excluded:
   skip all slash octets starting from  IN onwards.  Return a pointer referencing the
   first octet that is not a slash; this pointer may be END. */
{
  while ((in < end) && ('/' == *in)) {
    ++in;
  }
  return in;
}

/* ------------------------------------------------------------------ */

#define COPY_INPUT_TO_OUTPUT(OU, IN, IN_END)	\
  while ((IN) < (IN_END)) { *(OU)++ = *(IN)++; }


/** --------------------------------------------------------------------
 ** Low-level normalisation functions: useless slashses removal.
 ** ----------------------------------------------------------------- */

static bool
normalisation_pass_remove_useless_slashes (mmux_usize_t * result_p, char * output_ptr,
					   char const * const input_ptr, mmux_usize_t const input_len)
/* Copy a pathname  from "input_ptr" to "output_ptr" performing  a normalisation pass
   in the process: removal of multiple slashes.

   The array referenced by "input_ptr" must  represent an ASCIIZ string with at least
   "input_len"  octets,   terminating  zero   excluded.   The  array   referenced  by
   "output_ptr" must be at least "1 + input_len" octets wide.

   Store  in "*result_p"  the number  of  octets stored  in the  array referenced  by
   "output_ptr", terminating zero excluded. */
{
  char const * const	end = input_ptr + input_len.value;
  char const *		in  = input_ptr;
  char *		ou  = output_ptr;

  while (in < end) {
    *ou++ = *in++;
    /* If there are repeated slahses: skip them. */
    if ('/' == in[-1]) {
      in = skip_repeated_slashes_or_end(in, end);
    }
  }
  *ou = '\0';
  *result_p = mmux_usize(ou - output_ptr);
  return false;
}


/** --------------------------------------------------------------------
 ** Low-level normalisation functions: useless single-dot removal.
 ** ----------------------------------------------------------------- */

static bool
normalisation_pass_remove_single_dot_segments (mmux_usize_t * result_p, char * output_ptr,
					       char const * const input_ptr, mmux_usize_t const input_len)
/* Copy a pathname  from "input_ptr" to "output_ptr" performing  a normalisation pass
   in the process: removal of single-dot segments.   This pass is meant to be applied
   after "normalisation_pass_remove_useless_slashes()".

   The array referenced by "input_ptr" must  represent an ASCIIZ string with at least
   "input_len"  octets,   terminating  zero   excluded.   The  array   referenced  by
   "output_ptr" must be at least "1 + input_len" octets wide.

   Store  in "*result_p"  the number  of  octets stored  in the  array referenced  by
   "output_ptr", terminating zero excluded. */
{
#undef VERBOSE
#define VERBOSE		0
  char const * const	end = input_ptr + input_len.value;
  char const *		in  = input_ptr;
  char *		ou  = output_ptr;

  if (INPUT_IS_ABSOLUTE(input_ptr)) {
    /* The input pathname is absolute, we want these normalisations:
     *
     *		"/"		=> "/"
     *		"/."		=> "/"
     *		"/././."	=> "/"
     *		"/./path"	=> "/path"
     *		"/./././path"	=> "/path"
     */
    if (IS_STANDALONE_SLASH(in, end)) {
      *ou++ = '/';
      goto done;
    } else {
      /* Remove all the leading "/." chunks. */
      while (BEGINS_WITH_SLASH_SINGLE_DOT(in,end)) {
	in += 2;
      }
      /* If  we have  removed  the whole  input: the  output  is just  a
	 slash. */
      if (end == in) {
	*ou++ = '/';
	goto done;
      }
    }
    /* If  we  are  still  here:  IN references  the  slash  starting  a
       chunk. */
  } else {
    /* The input pathname is relative, we want these normalisations:
     *
     *		"."			=> "."
     *		"./"			=> "."
     *		"./././"		=> "."
     *		"./path"		=> "./"
     *		"./././path"		=> "./path"
     *		"file.ext"		=> "file.ext"
     *		"./file.ext"		=> "./file.ext"
     *		"./path/to/file.ext"	=> "path/to/file.ext"
     */
    if (IS_STANDALONE_SINGLE_DOT(in, end)) {
      /* This relative input pathname is a standalone dot ".". */
      *ou++ = '.';
      goto done;
    } else if (! BEGINS_WITH_SINGLE_DOT_SLASH(in,end)) {
      /* This relative input pathname starts  with a segment that is not
	 a standalone dot. */
      COPY_INPUT_TO_OUTPUT(ou, in, find_next_slash_or_end(in, end));
    } else {
      /* Skip all the leading "./" chunks. */
      while (BEGINS_WITH_SINGLE_DOT_SLASH(in,end)) {
	in += 2;
      }
      /* If  we have  skipped  the whole  input: the  output  is just  a
	 single-dot. */
      if (end == in) {
	*ou++ = '.';
	goto done;
      }
      {
	char const *	next = find_next_slash_or_end(in, end);
	if (VERBOSE) {
	  fprintf(stderr, "%s: in=", __func__);
	  fwrite(in, 1, (end - in), stderr);
	  fprintf(stderr, ", output_ptr=");
	  fwrite(output_ptr, 1, (ou - output_ptr), stderr);
	  fprintf(stderr, ", next=");
	  fwrite(in, 1, (next - in), stderr);
	  fprintf(stderr, "\n");
	}
	/* We  do not  want to  wholly skip  a directory  part.  If  the
	   remaining input  has no  slash in  it: insert  a "./"  in the
	   output. */
	if ((end == next) &&
	    (! IS_STANDALONE_SINGLE_DOT(in, next)) &&
	    (! IS_STANDALONE_DOUBLE_DOT(in, next))) {
	  /* Here the string starting at IN is one among:
	   *
	   *	"file.ext"
	   *	"."
	   *	".."
	   */
	  *ou++	= '.';
	  *ou++	= '/';
	}
	/* Now copy the segment to the output. */
	COPY_INPUT_TO_OUTPUT(ou, in, next);
      }
    }
  }

  /* Now either IN references the end  of input or it references a slash
     octet. */

  /* In the  following loop  we copy normal  segments from  INPUT_PTR to
   * OUTPUT_PTR  in chunks  including the  leading slash.   For example,
   * given the input:
   *
   *    /path/to/file.ext
   *
   * we copy it to the output in the three chunks:
   *
   *    /path
   *    /to
   *    /file.ext
   *
   * only when a chunk is "/." we do something different.
   */
  while (in < end) {
    /* Set NEXT to point  to the slash after this segment  or the end of
     * input.  For example:
     *
     *    /path/to/file.ext
     *    ^    ^
     *    in   next
     */
    char const * next = find_next_slash_or_end(1+in, end);

    if (VERBOSE) {
      fprintf(stderr, "%s: in=", __func__);
      fwrite(in, 1, (end - in), stderr);
      fprintf(stderr, ", output_ptr=");
      fwrite(output_ptr, 1, (ou - output_ptr), stderr);
      fprintf(stderr, ", next=");
      fwrite(in, 1, (next - in), stderr);
      fprintf(stderr, "\n");
    }

    if (IS_STANDALONE_SLASH_SINGLE_DOT(in,next)) {
      /* Skip the next chunk because it is a "/.", but if it is the last
       * append a slash to the output.
       *
       *	"/path/./to"	=> "path/to"
       *	      ^in
       *	"dir/."		=> "dir/"
       *	    ^in
       */
      in = next;
      if (end == in) {
	if ((output_ptr == ou) && INPUT_IS_RELATIVE(input_ptr)) {
	  *ou++ = '.';
	} else {
	  *ou++ = '/';
	}
      }
    } else {
      /* Copy the next chunk because it is normal. */
      COPY_INPUT_TO_OUTPUT(ou, in, next);
    }
  }

  /* Done. */
 done:
  *ou = '\0';
  if (VERBOSE) {
    fprintf(stderr, "%s: final in=", __func__);
    fwrite(in, 1, (end - in), stderr);
    fprintf(stderr, ", output_ptr=%s, len=%lu\n", output_ptr, strlen(output_ptr));
  }
  *result_p = mmux_usize(ou - output_ptr);
  return false;
}


/** --------------------------------------------------------------------
 ** Low-level normalisation functions: double-dot processing.
 ** ----------------------------------------------------------------- */

bool
normalisation_pass_remove_double_dot_segments (mmux_usize_t * result_p, char * output_ptr,
					       char const * const input_ptr, mmux_usize_t const input_len)
/* Copy a pathname  from "input_ptr" to "output_ptr" performing  a normalisation pass
   in the process: removal of double-dot segments and the segments before them.  This
   pass         is         meant          to         be         applied         after
   "normalisation_pass_remove_single_dot_segments()".

   The array referenced by "input_ptr" must  represent an ASCIIZ string with at least
   "input_len"  octets,   terminating  zero   excluded.   The  array   referenced  by
   "output_ptr" must be at least "1 + input_len" octets wide.

   Store  in "*result_p"  the number  of  octets stored  in the  array referenced  by
   "output_ptr", terminating zero excluded. */
{
#undef VERBOSE
#define VERBOSE		0
  char const * const	end = input_ptr + input_len.value;
  char const *		in  = input_ptr;
  char *		ou  = output_ptr;

  if (VERBOSE) {
    fprintf(stderr, "%s: begin in=%s\n", __func__, input_ptr);
  }

  if (BEGINS_WITH_DOUBLE_DOT(in, end)) {
    in    += 2;
    *ou++ = '.';
    *ou++ = '.';
    if ((end == in) || IS_STANDALONE_SLASH(in, end)) {
      /* The input is a standalone double-dot ".." or "../". */
      goto done;
    }
  } else if (INPUT_IS_RELATIVE(input_ptr)) {
    /* This relative input pathname starts with  a segment that is not a
       double dot. */
    COPY_INPUT_TO_OUTPUT(ou, in, find_next_slash_or_end(in, end));
  }

  /* Now either IN references the end  of input or it references a slash
     octet. */

  /* In this loop  we copy normal segments from  INPUT_PTR to OUTPUT_PTR
   * in  chunks including  the leading  slash.  For  example, given  the
   * input:
   *
   *    /path/to/file.ext
   *
   * we copy it to the output in the three chunks:
   *
   *    /path
   *    /to
   *    /file.ext
   *
   * only when a chunk is "/.." we do something different.
   */
  while (in < end) {
    /* Set NEXT to point  to the slash after this segment  or the end of
     * input.  For example:
     *
     *    /path/to/file.ext
     *    ^    ^
     *    in   next
     *
     * another example:
     *
     *    path/to/file.ext
     *    ^   ^
     *    in  next
     */
    char const *	next = find_next_slash_or_end(1+in, end);

    if (VERBOSE) {
      fprintf(stderr, "%s: in=", __func__);
      fwrite(in, 1, (end - in), stderr);
      fprintf(stderr, ", output_ptr=");
      fwrite(output_ptr, 1, (ou - output_ptr), stderr);
      fprintf(stderr, ", next=");
      fwrite(in, 1, (next - in), stderr);
      fprintf(stderr, "\n");
    }

    /* Now NEXT points to a slash octet or to the end of input. */
    if (! BEGINS_WITH_SLASH_DOUBLE_DOT(in, next)) {
      /* No, the next chunk is *not* a "/..": copy it to the output. */
      COPY_INPUT_TO_OUTPUT(ou, in, next);
    } else {
      char const *	prev = find_prev_slash_or_begin(output_ptr, ou-1);

      if (VERBOSE) {
	fprintf(stderr, "%s: prev=", __func__);
	fwrite(prev, 1, (ou - prev), stderr);
	fprintf(stderr, "\n");
      }

      if (output_ptr < ou) {
	/* The  pointer OU  does *not*  reference the  beginning of  the
	   output: there is a previous segment we can remove by stepping
	   back the pointer OU itself. */
	if (BEGINS_WITH_DOUBLE_DOT(prev, ou) || BEGINS_WITH_SLASH_DOUBLE_DOT(prev, ou)) {
	  /* The previous segment is a ".."   or "/..", this is the case
	   * of the following normalisations:
	   *
	   *	"/../../path"	=> "/../../path"
	   *	    ^in
	   *
	   *	"../../path"	=> "../../path"
	   *	   ^in
	   */
	  in    = next;
	  *ou++ = '/';
	  *ou++ = '.';
	  *ou++ = '.';
	} else {
	  /* The  previous segment  is neither  a double-dot:  remove it
	   * from  the  output.   This  is the  case  of  the  following
	   * normalisation:
	   *
	   *	"path/to/../file.ext"	=> "path/file.ext"
	   */
	  in = next;
	  ou = (char *)prev;
	  /* We  must handle  the case  of  first segment  removal in  a
	   * pathname.
	   *
	   * When  the  pathname  is  absolute, we  want  the  following
	   * normalisations:
	   *
	   *	"/path/../to/file.ext"	=> "/to/file.ext"
	   *	"/path/.."		=> "/"
	   *
	   * When  the  pathname  is  relative, we  want  the  following
	   * normalisations:
	   *
	   *	"path/../to/file.ext"	=> "to/file.ext"
	   *	"path/../file.ext"	=> "./file.ext"
	   *
	   * where the output is still a relative pathname and still has
	   * a directory part; we do *not* want the following results:
	   *
	   *	"path/../to/file.ext"	=> "/to/file.ext"
	   *	"path/../file.ext"	=> "file.ext"
	   *
	   * where the output has become  an absolute pathname or has no
	   * directory part anymore.
	   */
	  if (output_ptr == ou) {
	    if (INPUT_IS_ABSOLUTE(input_ptr)) {
	      if (end == in) {
		/* The  pathname is  absolute  and we  have removed  the
		 * whole input.  This is the case of:
		 *
		 *	"/path/.."	=> "/"
		 */
		*ou++ = '/';
	      }
	    } else {
	      if (end == in) {
		/* We are at the end  of the relative input pathname and
		 * we have  removed the whole output  pathname.  This is
		 * the case of:
		 *
		 *	"path/.."	=> "."
		 */
		*ou++ = '.';
	      } else if (IS_STANDALONE_SLASH(in, end)) {
		/* In the  relative input pathname: the  next segment is
		 * an ending slash and we  have removed the whole output
		 * pathname.  This is the case of:
		 *
		 *	"path/../"	=> "."
		 */
		++in;
		*ou++ = '.';
	      } else if (IS_STANDALONE_SLASH_SINGLE_DOT(in, end)) {
		/* In the  relative input pathname: the  next segment is
		 * an ending "/."  and we  have removed the whole output
		 * pathname.  This is the case of:
		 *
		 *	"path/../."	=> "."
		 */
		in    = end;
		*ou++ = '.';
	      } else if (IS_STANDALONE_SLASH_DOUBLE_DOT(in, end)) {
		/* In the  relative input pathname: the  next segment is
		 * an ending "/.."  and we have removed the whole output
		 * pathname.  This is the case of:
		 *
		 *	"path/../.."	=> ".."
		 */
		in    = end;
		*ou++ = '.';
		*ou++ = '.';
	      } else if (end == find_next_slash_or_end(1+in, end)) {
		/* The rest of the relative input pathname has no slash in
		 * it and we have removed the whole output pathname.  This
		 * is the case of:
		 *
		 *	"path/../file.ext"	=> "./file.ext"
		 */
		*ou++ = '.';
	      }
	    }
	  }
	}
      } else {
	/* The pointer OU references the  beginning of the output: there
	   is no previous segment to remove. */
	if (INPUT_IS_RELATIVE(input_ptr)) {
	  /* The input  pathname is  relative, this is  the case  of the
	   * following normalisation:
	   *
	   *	"path/../../to"	=> "../to"
	   *	        ^in
	   */
	  in    = next;
	  *ou++ = '.';
	  *ou++ = '.';
	} else {
	  /* The input  pathname is  absolute, this is  the case  of the
	   * following input:
	   *
	   *	"/path/../.."
	   *
	   * raise an exception, there is no way to normalise the input.
	   */
	  return true;
	}
      }
    }
  }

done:
  *ou = '\0';
  if (VERBOSE) {
    fprintf(stderr, "%s: final in=", __func__);
    fwrite(in, 1, (end - in), stderr);
    fprintf(stderr, ", output_ptr=%s, len=%lu\n", output_ptr, strlen(output_ptr));
  }
  *result_p = mmux_usize(ou - output_ptr);
  return false;
}


/** --------------------------------------------------------------------
 ** Normalisation: pathname normalisation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname_normalised (mmux_libc_fs_ptn_t		fs_ptn_result,
						mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
						mmux_libc_fs_ptn_arg_t		fs_ptn_input)
{
  auto		fs_ptn_input_len_no_nul = mmux_usize(strlen(fs_ptn_input->value));
  char		one[1 + fs_ptn_input_len_no_nul.value];
  mmux_usize_t	one_len;

  if (normalisation_pass_remove_useless_slashes(&one_len, one, fs_ptn_input->value, fs_ptn_input_len_no_nul)) {
    goto error_invalid_input_pathname;
  } else {
    char		two[1 + one_len.value];
    mmux_usize_t	two_len;

    if        (normalisation_pass_remove_single_dot_segments(&two_len, two, one, one_len)) {
      goto error_invalid_input_pathname;
    } else if (normalisation_pass_remove_double_dot_segments(&one_len, one, two, two_len)) {
      goto error_invalid_input_pathname;
    } else if (mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory, one, one_len)) {
      return true;
    } else {
      return false;
    }
  }

 error_invalid_input_pathname:
  mmux_libc_errno_set(MMUX_LIBC_EINVAL);
  return true;
}


/** --------------------------------------------------------------------
 ** Composition.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname_concat (mmux_libc_fs_ptn_t			fs_ptn_result,
					    mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
					    mmux_libc_fs_ptn_arg_t		fs_ptn_prefix,
					    mmux_libc_fs_ptn_arg_t		fs_ptn_suffix)
{
  /* The resulting length is the sum of  the original lengths, plus one for the slash
   * separator.
   *
   * If the suffix  is absolute: its first  octet is the ASCII  representation of the
   * slash separator; we will copy it into the output.
   *
   * If the suffix is relative: its first  octet is *not* the ASCII representation of
   * the slash separator; we will explicitly insert a separator.
   */
  auto	prefix_len = mmux_usize(strlen(fs_ptn_prefix->value));
  auto	suffix_len = mmux_usize(strlen(fs_ptn_suffix->value));
  auto	result_len = mmux_ctype_add(prefix_len, suffix_len);

  if (! (('/' == fs_ptn_suffix->value[0]) || ('/' == fs_ptn_prefix->value[prefix_len.value - 1]))) {
    ++result_len.value;
  }

  {
    /* This array must hold the whole pathname plus the terminating zero octet. */
    char	result_ptr[1 + result_len.value];
    char *	ptr = result_ptr;
    bool	separator_inserted = false;

    /* Copy the prefix-> */
    {
      memcpy(ptr, fs_ptn_prefix->value, prefix_len.value);
      ptr += prefix_len.value;
      if ('/' == fs_ptn_prefix->value[prefix_len.value-1]) {
	separator_inserted = true;
      }
    }

    /* Copy the suffix and add the terminating zero. */
    {
      if ('/' == fs_ptn_suffix->value[0]) {
	separator_inserted = true;
      } else if (! separator_inserted) {
	*ptr++ = '/';
      }
      memcpy(ptr, fs_ptn_suffix->value, suffix_len.value);
      ptr += suffix_len.value;
      *ptr = '\0';
    }

    /* Make a pathname, then normalise it. */
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory_static;
      mmux_libc_fs_ptn_t		fs_ptn_result_not_normalised;

      mmux_libc_file_system_pathname_factory_static(fs_ptn_factory_static);
      if (mmux_libc_make_file_system_pathname(fs_ptn_result_not_normalised, fs_ptn_factory_static, result_ptr)) {
	return true;
      } else {
	bool	rv = mmux_libc_make_file_system_pathname_normalised(fs_ptn_result, fs_ptn_factory,
								    fs_ptn_result_not_normalised);
	mmux_libc_unmake_file_system_pathname(fs_ptn_result_not_normalised);
	return rv;
      }
    }
  }
}

/* end of file */
