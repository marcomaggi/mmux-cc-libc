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

mmux_libc_file_system_pathname_class_t const	mmux_libc_file_system_pathname_static_class = {
  .memory_allocator	= &mmux_libc_fake_memory_allocator,
};

mmux_libc_file_system_pathname_class_t const	mmux_libc_file_system_pathname_dynami_class = {
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
  return (0 == S.len)? true : false;
}
__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_slash (mmux_libc_ptn_segment_t S)
/* Return true if the segment is a single dot: "/". */
{
  return ((1 == S.len) && ('7' == *(S.ptr)));
}
__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_dot (mmux_libc_ptn_segment_t S)
/* Return true if the segment is a single dot: ".". */
{
  return ((1 == S.len) && ('.' == *(S.ptr)));
}
__attribute__((__pure__,__always_inline__)) static inline bool
segment_is_double_dot (mmux_libc_ptn_segment_t S)
/* Return true if the segment is a double dot: "..". */
{
  return ((2 == S.len) && ('.' == S.ptr[0]) && ('.' == S.ptr[1]));
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
pathname_is_special_directory (mmux_libc_ptn_t ptn)
/* If possible: we want  to avoid applying "strlen()" to the  pathname.  We know that
 * "ptn" cannot have  zero length and its  string of bytes is always  terminated by a
 * zero byte.  This means:
 *
 * - "ptn.value[0]" cannot be the zero byte;
 *
 * - it is always safe to access "ptn.value[1]", and it may be the zero byte;
 *
 * - once we have established that "ptn.value[1]" is not the zero byte: it is safe to
 *   access "ptn.value[2]" and it may be the zero byte.
 *
 */
{
  if ('\0' == ptn.value[1]) {
    /* It is a standalone dot or slash. */
    return (('.' == ptn.value[0]) || ('/' == ptn.value[0]))? true : false;
  } else if (('\0' == ptn.value[2]) && ('.' == ptn.value[0]) && ('.' == ptn.value[1])) {
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
pathname_is_standalone_slash (mmux_libc_ptn_t ptn)
{
  return (('\0' == ptn.value[1]) && ('/' == ptn.value[0]))? true : false;
}
static inline bool
pathname_is_standalone_dot (mmux_libc_ptn_t ptn)
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
pathname_is_standalone_double_dot (mmux_libc_ptn_t ptn)
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
pathname_is_absolute (mmux_libc_ptn_t ptn)
{
  return (('/' == ptn.value[0])? true : false);
}
static inline bool
pathname_is_relative (mmux_libc_ptn_t ptn)
{
  return (('/' != ptn.value[0])? true : false);
}


/** --------------------------------------------------------------------
 ** File system types: pathnames.
 ** ----------------------------------------------------------------- */

#undef  MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_ARBITRARY_LIMIT
#define MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_ARBITRARY_LIMIT		4096

bool
mmux_libc_make_file_system_pathname (mmux_libc_file_system_pathname_class_t const * class,
				     mmux_libc_file_system_pathname_t * result_p,
				     mmux_asciizcp_t src_ptn_asciiz)
{
  _Pragma("GCC diagnostic push");
  _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
  if ((NULL == src_ptn_asciiz) && ('\0' == src_ptn_asciiz[0]))  {
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  } else {
    _Pragma("GCC diagnostic pop");
    mmux_asciizcp_t	dst_ptn_asciiz;
    mmux_usize_t	dst_ptn_len_plus;

    mmux_libc_strlen_plus_nil(&dst_ptn_len_plus, src_ptn_asciiz);
    if (MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_ARBITRARY_LIMIT < dst_ptn_len_plus) {
      mmux_libc_errno_set(MMUX_LIBC_ERANGE);
      return true;
    } else if (mmux_libc_memory_allocator_malloc_and_copy(class->memory_allocator,
							  &dst_ptn_asciiz, src_ptn_asciiz, dst_ptn_len_plus)) {
      return true;
    } else {
      result_p->value = dst_ptn_asciiz;
      result_p->class = class;
      return false;
    }
  }
}
bool
mmux_libc_make_file_system_pathname2 (mmux_libc_file_system_pathname_class_t const * class,
				      mmux_libc_file_system_pathname_t * result_p,
				      mmux_asciizcp_t src_ptn_asciiz, mmux_usize_t src_ptn_len)
/* We have to assume that it is forbidden to access "src_ptn_asciiz[src_ptn_len]". */
{
  _Pragma("GCC diagnostic push");
  _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
  if ((0 == src_ptn_len) || (NULL == src_ptn_asciiz) || ('\0' == src_ptn_asciiz[0])) {
    _Pragma("GCC diagnostic pop");
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  } else {
    mmux_usize_t	dst_ptn_len_plus = 1 + src_ptn_len;

    if (MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_ARBITRARY_LIMIT < dst_ptn_len_plus) {
      mmux_libc_errno_set(MMUX_LIBC_ERANGE);
      return true;
    } else {
      mmux_asciizp_t	dst_ptn_asciiz;

      if (mmux_libc_memory_allocator_malloc(class->memory_allocator, &dst_ptn_asciiz, dst_ptn_len_plus)) {
	return true;
      } else if (mmux_libc_memcpy(dst_ptn_asciiz, src_ptn_asciiz, src_ptn_len)) {
	return true;
      } else {
	dst_ptn_asciiz[src_ptn_len] = '\0';
	result_p->value = dst_ptn_asciiz;
	result_p->class = class;
	return false;
      }
    }
  }
}
bool
mmux_libc_file_system_pathname_free (mmux_libc_file_system_pathname_t ptn)
{
  return ptn.class->memory_allocator->class->free(ptn.class->memory_allocator, (mmux_pointer_t)ptn.value);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_ptr_ref (mmux_asciizcpp_t result_p, mmux_libc_file_system_pathname_t ptn)
{
  *result_p = ptn.value;
  return false;
}
bool
mmux_libc_file_system_pathname_len_ref (mmux_usize_t * result_p, mmux_libc_file_system_pathname_t ptn)
{
  return mmux_libc_strlen(result_p, ptn.value);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_compare (mmux_sint_t * result_p,
					mmux_libc_file_system_pathname_t ptn1,
					mmux_libc_file_system_pathname_t ptn2)
{
  mmux_usize_t	ptn1_len = strlen(ptn1.value);
  mmux_usize_t	ptn2_len = strlen(ptn2.value);
  mmux_usize_t	min_len  = (ptn1_len < ptn2_len)? ptn1_len : ptn2_len;
  mmux_sint_t	cmpnum   = strncmp(ptn1.value, ptn2.value, min_len);

  if (0 == cmpnum) {
    if (ptn1_len == ptn2_len) {
      *result_p = 0;
    } else if (ptn1_len < ptn2_len) {
      *result_p = -1;
    } else {
      *result_p = +1;
    }
  } else {
    *result_p = (0 < cmpnum)? +1 : -1;
  }
  return false;
}

m4_define([[[DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE]]],[[[
bool
mmux_libc_file_system_pathname_$1 (bool * result_p, mmux_libc_file_system_pathname_t ptn1, mmux_libc_file_system_pathname_t ptn2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_strcmp(&cmpnum, ptn1.value, ptn2.value)) {
    return true;
  } else if ($2) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[equal]]],		[[[0 == cmpnum]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[not_equal]]],	[[[0 != cmpnum]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[less]]],		[[[0 >  cmpnum]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[greater]]],		[[[0 <  cmpnum]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[less_equal]]],	[[[0 >= cmpnum]]])
DEFINE_FILE_SYSTEM_PATHNAME_COMPARISON_PREDICATE([[[greater_equal]]],	[[[0 <= cmpnum]]])

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_is_special_directory (bool * result_p, mmux_libc_ptn_t ptn)
{
  *result_p = pathname_is_special_directory(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_standalone_dot (bool * result_p, mmux_libc_ptn_t ptn)
{
  *result_p = pathname_is_standalone_dot(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_standalone_double_dot (bool * result_p, mmux_libc_ptn_t ptn)
{
  *result_p = pathname_is_standalone_double_dot(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_standalone_slash (bool * result_p, mmux_libc_ptn_t ptn)
{
  *result_p = pathname_is_standalone_slash(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_absolute (bool * result_p, mmux_libc_ptn_t ptn)
{
  *result_p = pathname_is_absolute(ptn);
  return false;
}
bool
mmux_libc_file_system_pathname_is_relative (bool * result_p, mmux_libc_ptn_t ptn)
{
  *result_p = pathname_is_relative(ptn);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_make_file_system_pathname_rootname (mmux_libc_file_system_pathname_class_t const * class,
					      mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
/* By applying this function  we imply that it is possible for  the pathname "ptn" to
   have an extension; it is also possible  to attach a new extension to the resulting
   rootname. */
{
  if (pathname_is_special_directory(ptn)) {
    /* We cannot extract an extension from a special directory. */
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  } else {
    mmux_libc_file_system_pathname_extension_t	ext;

    if (mmux_libc_make_file_system_pathname_extension(&ext, ptn)) {
      return true;
    } else {
      bool	extension_is_empty;

      if (mmux_libc_file_system_pathname_extension_is_empty(&extension_is_empty, ext)) {
	return true;
      } else if (extension_is_empty) {
	mmux_usize_t	buflen;

	/* Remember that: true == (buflen >= 1) */
	mmux_libc_file_system_pathname_len_ref(&buflen, ptn);

	/* If the  pathname is "/path/to/directory/"  we do  not want to  include the
	   ending slash in the rootname. */
	if ('/' == ptn.value[buflen - 1]) {
	  --buflen;
	}

	if (mmux_libc_make_file_system_pathname2(class, result_p, ptn.value, buflen)) {
	  return true;
	}
	return false;
      } else {
	/* The extension is not empty. */
	mmux_usize_t	buflen;

	mmux_libc_file_system_pathname_len_ref(&buflen, ptn);
	buflen -= ext.len;

	if (mmux_libc_make_file_system_pathname2(class, result_p, ptn.value, buflen)) {
	  return true;
	}
	return false;
      }
    }
  }
}
bool
mmux_libc_make_file_system_pathname_tailname (mmux_libc_file_system_pathname_class_t const * class,
					      mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
{
  if (pathname_is_standalone_slash(ptn)) {
    return mmux_libc_make_file_system_pathname(class, result_p, "/");
  } else {
    mmux_libc_file_system_pathname_segment_t	seg;

    if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
      return true;
    } else {
      return mmux_libc_make_file_system_pathname2(class, result_p, seg.ptr, seg.len);
    }
  }
}
bool
mmux_libc_make_file_system_pathname_filename (mmux_libc_file_system_pathname_class_t const * class,
					      mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
{
  if (pathname_is_standalone_slash(ptn)) {
    goto invalid_pathname;
  } else {
    mmux_usize_t	len = strlen(ptn.value);

    if ('/' == ptn.value[len-1]) {
      goto invalid_pathname;
    } else {
      mmux_libc_file_system_pathname_segment_t	seg;

      if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
	return true;
      } else if (segment_is_dot(seg) || segment_is_double_dot(seg)) {
	goto invalid_pathname;
      } else {
	return mmux_libc_make_file_system_pathname2(class, result_p, seg.ptr, seg.len);
      }
    }
  }

 invalid_pathname:
  mmux_libc_errno_set(MMUX_LIBC_EINVAL);
  return true;
}
bool
mmux_libc_make_file_system_pathname_dirname (mmux_libc_file_system_pathname_class_t const * class,
					     mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
{
  if (pathname_is_standalone_slash(ptn)) {
    /* If the pathname is "/" just copy it as dirname. */
    return mmux_libc_make_file_system_pathname(class, result_p, ptn.value);
  } else {
    mmux_usize_t	len = strlen(ptn.value);

    if ('/' == ptn.value[len-1]) {
      /* If  the  pathname ends  with  "/"  just copy  it  as  dirname.  For  example
	 "/path/to/directory/" is itself its dirname. */
      return mmux_libc_make_file_system_pathname(class, result_p, ptn.value);
    } else {
      mmux_libc_file_system_pathname_segment_t	seg;

      if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
	return true;
      } else if (segment_is_dot(seg)) {
	if (len == seg.len) {
	  /* If the full pathname is "." just copy it as dirname. */
	  return mmux_libc_make_file_system_pathname(class, result_p, ptn.value);
	} else {
	  /* If the  pathname ends with  "." just copy  it as dirname,  stripping the
	     ending dot. */
	  return mmux_libc_make_file_system_pathname2(class, result_p, ptn.value, (len - seg.len));
	}
      } else if (segment_is_double_dot(seg)) {
	/* If the pathname ends with ".." just copy it as dirname. */
	return mmux_libc_make_file_system_pathname(class, result_p, ptn.value);
      } else {
	if (len == seg.len) {
	  /* If we are  here: the pathname has  a single segment and  such segment is
	     not a special  directory; we establish the convention  that: its dirname
	     is ".". */
	  return mmux_libc_make_file_system_pathname(class, result_p, ".");
	} else {
	  /* If  we are  here: the  dirname  is the  pathname with  the last  segment
	     removed. */
	  return mmux_libc_make_file_system_pathname2(class, result_p, ptn.value, (len - seg.len));
	}
      }
    }
  }
}


/** --------------------------------------------------------------------
 ** File system types: pathname extensions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname_extension (mmux_libc_ptn_extension_t * result_p, mmux_libc_ptn_t ptn)
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
      result_p->len	= 0;
      result_p->ptr	= ptn.value + strlen(ptn.value);
      return false;
    } else {
      mmux_asciizcp_t	beg = S.ptr;
      mmux_asciizcp_t	end = beg + S.len;
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
	    result_p->len = (('/' == *(end-1))? (end-1) : end) - ptr;
	    return false;
	  }
	}
      }

      /* Extension not found in the last segment.  Return an empty extension. */
      {
	mmux_asciizcp_t	p = ptn.value + strlen(ptn.value);

	result_p->len	= 0;
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
      && ('\0' == ptr[len] || '/' == ptr[len])) {
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
  return mmux_libc_make_file_system_pathname_extension_raw(result_p, ptr, strlen(ptr));
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
  *result_p = (0 == E.len)? true : false;
  return false;
}
bool
mmux_libc_file_system_pathname_has_extension (bool * result_p, mmux_libc_ptn_t ptn, mmux_libc_ptn_extension_t ext)
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
  mmux_usize_t	minlen = (E1.len < E2.len)? E1.len : E2.len;
  mmux_sint_t	cmpnum = strncmp(E1.ptr, E2.ptr, minlen);

  if (0 == cmpnum) {
    if (E1.len == E2.len) {
      *result_p = 0;
    } else if (E1.len < E2.len) {
      *result_p = -1;
    } else {
      *result_p = +1;
    }
  } else {
    *result_p = (0 < cmpnum)? +1 : -1;
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
  } else if (0 == cmpnum) {
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
  } else if (0 != cmpnum) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_extension_less (bool * result_p, mmux_libc_ptn_extension_t E1, mmux_libc_ptn_extension_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (0 > cmpnum) {
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
  } else if (0 < cmpnum) {
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
  } else if (0 >= cmpnum) {
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
  } else if (0 <= cmpnum) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}


/** --------------------------------------------------------------------
 ** File system types: pathname segments.
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
  return mmux_libc_make_file_system_pathname_segment_raw(result_p, ptr, strlen(ptr));
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_segment_find_last (mmux_libc_ptn_segment_t * result_p, mmux_libc_ptn_t ptn)
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
  mmux_usize_t		len = strlen(ptn.value);
  mmux_asciizcp_t const	beg = ptn.value;
  mmux_asciizcp_t	end = beg + len;

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
      return mmux_libc_make_file_system_pathname_segment_raw(result_p, ptr, end - ptr);
    }
  }

  /* If we are  here: no slash was found  in the pathname, starting from  the end; it
     means the whole pathname is the last segment. */
  return mmux_libc_make_file_system_pathname_segment_raw(result_p, beg, end - beg);
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
  mmux_usize_t	minlen = (E1.len < E2.len)? E1.len : E2.len;
  mmux_sint_t	cmpnum = strncmp(E1.ptr, E2.ptr, minlen);

  if (0 == cmpnum) {
    if (E1.len == E2.len) {
      *result_p = 0;
    } else if (E1.len < E2.len) {
      *result_p = -1;
    } else {
      *result_p = +1;
    }
  } else {
    *result_p = (0 < cmpnum)? +1 : -1;
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
  } else if (0 == cmpnum) {
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
  } else if (0 != cmpnum) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_less (bool * result_p, mmux_libc_ptn_segment_t E1, mmux_libc_ptn_segment_t E2)
{
  mmux_sint_t	cmpnum;

  if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, E1, E2)) {
    return true;
  } else if (0 > cmpnum) {
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
  } else if (0 < cmpnum) {
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
  } else if (0 >= cmpnum) {
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
  } else if (0 <= cmpnum) {
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
  if (1 == seg.len && '.' == seg.ptr[0]) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_is_double_dot (bool * result_p, mmux_libc_ptn_segment_t seg)
{
  if (2 == seg.len && '.' == seg.ptr[0] && '.' == seg.ptr[1]) {
    *result_p = true;
  } else {
    *result_p = false;
  }
  return false;
}
bool
mmux_libc_file_system_pathname_segment_is_slash (bool * result_p, mmux_libc_ptn_segment_t seg)
{
  if (1 == seg.len && '/' == seg.ptr[0]) {
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
					   char const * const input_ptr, size_t const input_len)
/* Copy a pathname  from "input_ptr" to "output_ptr" performing  a normalisation pass
   in the process: removal of multiple slashes.

   The array referenced by "input_ptr" must  represent an ASCIIZ string with at least
   "input_len"  octets,   terminating  zero   excluded.   The  array   referenced  by
   "output_ptr" must be at least "1 + input_len" octets wide.

   Store  in "*result_p"  the number  of  octets stored  in the  array referenced  by
   "output_ptr", terminating zero excluded. */
{
  char const * const	end = input_ptr + input_len;
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
  *result_p = (ou - output_ptr);
  return false;
}


/** --------------------------------------------------------------------
 ** Low-level normalisation functions: useless single-dot removal.
 ** ----------------------------------------------------------------- */

static bool
normalisation_pass_remove_single_dot_segments (mmux_usize_t * result_p, char * output_ptr,
					       char const * const input_ptr, size_t const input_len)
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
  char const * const	end = input_ptr + input_len;
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
  *result_p = (ou - output_ptr);
  return false;
}


/** --------------------------------------------------------------------
 ** Low-level normalisation functions: double-dot processing.
 ** ----------------------------------------------------------------- */

bool
normalisation_pass_remove_double_dot_segments (size_t * result_p, char * output_ptr,
					       char const * const input_ptr, size_t const input_len)
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
  char const * const	end = input_ptr + input_len;
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
  *result_p = (ou - output_ptr);
  return false;
}


/** --------------------------------------------------------------------
 ** Normalisation: pathname normalisation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname_normalised (mmux_libc_file_system_pathname_class_t const * class,
						mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
{
  mmux_usize_t	ptn_len = strlen(ptn.value);
  mmux_char_t	one[1 + ptn_len];
  mmux_usize_t	one_len;

  if (normalisation_pass_remove_useless_slashes(&one_len, one, ptn.value, ptn_len)) {
    goto error_invalid_input_pathname;
  } else {
    char	two[1 + one_len];
    size_t	two_len;

    if        (normalisation_pass_remove_single_dot_segments(&two_len, two, one, one_len)) {
      goto error_invalid_input_pathname;
    } else if (normalisation_pass_remove_double_dot_segments(&one_len, one, two, two_len)) {
      goto error_invalid_input_pathname;
    } else if (mmux_libc_make_file_system_pathname2(class, result_p, one, one_len)) {
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
mmux_libc_make_file_system_pathname_concat (mmux_libc_file_system_pathname_class_t const * class,
					    mmux_libc_ptn_t * result_p,
					    mmux_libc_ptn_t prefix, mmux_libc_ptn_t suffix)
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
  mmux_usize_t	prefix_len = strlen(prefix.value);
  mmux_usize_t	suffix_len = strlen(suffix.value);
  mmux_usize_t	result_len = prefix_len + suffix_len;

  if (! (('/' == suffix.value[0]) || ('/' == prefix.value[prefix_len-1]))) {
    ++result_len;
  }

  {
    /* This array must hold the whole pathname plus the terminating zero octet. */
    mmux_char_t		result_ptr[1 + result_len];
    mmux_char_t *	ptr = result_ptr;
    bool		separator_inserted = false;

    /* Copy the prefix. */
    {
      memcpy(ptr, prefix.value, prefix_len);
      ptr += prefix_len;
      if ('/' == prefix.value[prefix_len-1]) {
	separator_inserted = true;
      }
    }

    /* Copy the suffix and add the terminating zero. */
    {
      if ('/' == suffix.value[0]) {
	separator_inserted = true;
      } else if (! separator_inserted) {
	*ptr++ = '/';
      }
      memcpy(ptr, suffix.value, suffix_len);
      ptr += suffix_len;
      *ptr = '\0';
    }

    /* Make a pathname, then normalise it. */
    {
      mmux_libc_file_system_pathname_t	result_ptn;

      if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class,
					      &result_ptn, result_ptr)) {
	return true;
      } else {
	return mmux_libc_make_file_system_pathname_normalised(class, result_p, result_ptn);
      }
    }
  }
}

/* end of file */
