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

#define DPRINTF(TEMPLATE,...)	if (mmux_libc_dprintf(TEMPLATE,__VA_ARGS__)) { return true; }


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

static inline bool
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

bool
mmux_libc_make_file_system_pathname (mmux_libc_file_system_pathname_t * result_p, mmux_asciizcp_t ptn_asciiz)
{
_Pragma("GCC diagnostic push")
_Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"")
  if ((NULL != ptn_asciiz) && ('\0' != ptn_asciiz[0])) {
_Pragma("GCC diagnostic pop")
    result_p->value = ptn_asciiz;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_make_file_system_pathname_malloc (mmux_libc_file_system_pathname_t * pathname_p,
					    mmux_asciizcp_t ptn_asciiz)
{
  mmux_usize_t		buflen;
  mmux_asciizp_t	bufptr;

  if (mmux_libc_strlen_plus_nil(&buflen, ptn_asciiz)) {
    return true;
  } else if (mmux_libc_malloc(&bufptr, buflen)) {
    return true;
  } else if (mmux_libc_strncpy(bufptr, ptn_asciiz, buflen)) {
    return true;
  } else if (mmux_libc_make_file_system_pathname(pathname_p, bufptr)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_make_file_system_pathname_malloc_from_buffer (mmux_libc_file_system_pathname_t * pathname_p,
							mmux_asciicp_t bufptr, mmux_usize_t buflen)
{
  mmux_asciizp_t	result_bufptr;

  if (mmux_libc_malloc(&result_bufptr, 1 + buflen)) {
    return true;
  } else {
    result_bufptr[buflen] = '\0';
    if (mmux_libc_strncpy(result_bufptr, bufptr, buflen)) {
      return true;
    } else if (mmux_libc_make_file_system_pathname(pathname_p, result_bufptr)) {
      return true;
    } else {
      return false;
    }
  }
}
bool
mmux_libc_file_system_pathname_free (mmux_libc_file_system_pathname_t pathname)
{
  return mmux_libc_free((mmux_pointer_t)pathname.value);
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
mmux_libc_make_file_system_pathname_rootname (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
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

	if (mmux_libc_make_file_system_pathname_malloc_from_buffer(result_p, ptn.value, buflen)) {
	  return true;
	}
	return false;
      } else {
	/* The extension is not empty. */
	mmux_usize_t	buflen;

	mmux_libc_file_system_pathname_len_ref(&buflen, ptn);
	buflen -= ext.len;

	if (mmux_libc_make_file_system_pathname_malloc_from_buffer(result_p, ptn.value, buflen)) {
	  return true;
	}
	return false;
      }
    }
  }
}
bool
mmux_libc_make_file_system_pathname_tailname (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
{
  if (pathname_is_standalone_slash(ptn)) {
    return mmux_libc_make_file_system_pathname_malloc(result_p, "/");
  } else {
    mmux_libc_file_system_pathname_segment_t	seg;

    if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
      return true;
    } else {
      return mmux_libc_make_file_system_pathname_malloc_from_buffer(result_p, seg.ptr, seg.len);
    }
  }
}
bool
mmux_libc_make_file_system_pathname_filename (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
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
	return mmux_libc_make_file_system_pathname_malloc_from_buffer(result_p, seg.ptr, seg.len);
      }
    }
  }

 invalid_pathname:
  mmux_libc_errno_set(MMUX_LIBC_EINVAL);
  return true;
}
bool
mmux_libc_make_file_system_pathname_dirname (mmux_libc_ptn_t * result_p, mmux_libc_ptn_t ptn)
{
  if (pathname_is_standalone_slash(ptn)) {
    /* If the pathname is "/" just copy it as dirname. */
    return mmux_libc_make_file_system_pathname_malloc(result_p, ptn.value);
  } else {
    mmux_usize_t	len = strlen(ptn.value);

    if ('/' == ptn.value[len-1]) {
      /* If  the  pathname ends  with  "/"  just copy  it  as  dirname.  For  example
	 "/path/to/directory/" is itself its dirname. */
      return mmux_libc_make_file_system_pathname_malloc(result_p, ptn.value);
    } else {
      mmux_libc_file_system_pathname_segment_t	seg;

      if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
	return true;
      } else if (segment_is_dot(seg)) {
	if (len == seg.len) {
	  /* If the full pathname is "." just copy it as dirname. */
	  return mmux_libc_make_file_system_pathname_malloc(result_p, ptn.value);
	} else {
	  /* If the  pathname ends with  "." just copy  it as dirname,  stripping the
	     ending dot. */
	  return mmux_libc_make_file_system_pathname_malloc_from_buffer(result_p, ptn.value, (len - seg.len));
	}
      } else if (segment_is_double_dot(seg)) {
	/* If the pathname ends with ".." just copy it as dirname. */
	return mmux_libc_make_file_system_pathname_malloc(result_p, ptn.value);
      } else {
	if (len == seg.len) {
	  /* If we are  here: the pathname has  a single segment and  such segment is
	     not a special  directory; we establish the convention  that: its dirname
	     is ".". */
	  return mmux_libc_make_file_system_pathname_malloc(result_p, ".");
	} else {
	  /* If  we are  here: the  dirname  is the  pathname with  the last  segment
	     removed. */
	  return mmux_libc_make_file_system_pathname_malloc_from_buffer(result_p, ptn.value, (len - seg.len));
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

/* end of file */
