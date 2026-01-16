/*
  Part of: MMUX CC Libc
  Contents: string operations
  Date: Dec 31, 2024

  Abstract

	This module implements the strings API.

  Copyright (C) 2024, 2025, 2026 Marco Maggi <mrc.mgg@gmail.com>

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

/* If possible we  do not want to include "libgen.h":  according to the documentation
   of GLIBC, including it replaces the GNU version of "basename" with another version
   I do not want.  (Marco Maggi; Dec 31, 2024) */
#if 0
#  if ((defined HAVE_LIBGEN_H) && (1 == HAVE_LIBGEN_H))
#    include <libgen.h>
#  endif
#else
extern char const * dirname (char const * path);
#endif


/** --------------------------------------------------------------------
 ** Inspection.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strlen (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr)
{
  *result_len_p = mmux_usize(strlen(ptr));
  return false;
}
bool
mmux_libc_strlen_plus_nil (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr)
{
  *result_len_p = mmux_usize(1 + strlen(ptr));
  return false;
}
bool
mmux_libc_strnlen (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr, mmux_usize_t maxlen)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRNLEN]]],[[[
  *result_len_p = mmux_usize(strnlen(ptr, maxlen.value));
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Copying.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strcpy (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr)
{
  strcpy(dst_ptr, src_ptr);
  return false;
}
bool
mmux_libc_strncpy (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
{
  strncpy(dst_ptr, src_ptr, len.value);
  return false;
}
bool
mmux_libc_stpcpy (mmux_asciizp_t * result_after_ptr_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr)
{
  *result_after_ptr_p = stpcpy(dst_ptr, src_ptr);
  return false;
}
bool
mmux_libc_stpncpy (mmux_asciizp_t * result_after_ptr_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STPNCPY]]],[[[
  *result_after_ptr_p = stpncpy(dst_ptr, src_ptr, len.value);
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Duplicating.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strdup (mmux_asciizcp_t * result_oustr_p, mmux_asciizcp_t instr)
{
  mmux_asciizcp_t	oustr_p = strdup(instr);

  if (NULL != oustr_p) {
    *result_oustr_p = oustr_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_strndup (mmux_asciizcp_t * result_oustr_p, mmux_asciizcp_t instr, mmux_usize_t len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRNDUP]]],[[[
  mmux_asciizcp_t	oustr_p = strndup(instr, len.value);

  if (NULL != oustr_p) {
    *result_oustr_p = oustr_p;
    return false;
  } else {
    return true;
  }
]]])
}


/** --------------------------------------------------------------------
 ** Concatenating.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strcat (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr)
{
  strcat(dst_ptr, src_ptr);
  return false;
}
bool
mmux_libc_strncat (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
{
  strncat(dst_ptr, src_ptr, len.value);
  return false;
}


/** --------------------------------------------------------------------
 ** Comparing.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strequ (bool * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
  *result_p = (0 == strcmp(ptr2, ptr1))? true : false;
  return false;
}
bool
mmux_libc_strnequ (bool * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
{
  *result_p = (0 == strncmp(ptr2, ptr1, len.value))? true : false;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_strcmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
  *result_p = mmux_ternary_comparison_result(strcmp(ptr2, ptr1));
  return false;
}
bool
mmux_libc_strncmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
{
  *result_p = mmux_ternary_comparison_result(strncmp(ptr2, ptr1, len.value));
  return false;
}
bool
mmux_libc_strcasecmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRCASECMP]]],[[[
  *result_p = mmux_ternary_comparison_result(strcasecmp(ptr2, ptr1));
  return false;
]]])
}
bool
mmux_libc_strncasecmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRNCASECMP]]],[[[
  *result_p = mmux_ternary_comparison_result(strncasecmp(ptr2, ptr1, len.value));
  return false;
]]])
}
bool
mmux_libc_strverscmp (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRVERSCMP]]],[[[
  *result_p = mmux_ternary_comparison_result(strverscmp(ptr2, ptr1));
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Collation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strcoll (mmux_ternary_comparison_result_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
  *result_p = mmux_ternary_comparison_result(strcoll(ptr2, ptr1));
  return false;
}
bool
mmux_libc_strxfrm (mmux_usize_t * result_size_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
{
  *result_size_p = mmux_usize(strxfrm(dst_ptr, src_ptr, len.value));
  return false;
}


/** --------------------------------------------------------------------
 ** Searching.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strchr (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_char_t schar)
{
  *result_p = strchr(ptr, schar.value);
  return false;
}
bool
mmux_libc_strchrnul (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_char_t schar)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRCHRNUL]]],[[[
  *result_p = strchrnul(ptr, schar.value);
  return false;
]]])
}
bool
mmux_libc_strrchr (mmux_asciizcp_t * result_p, mmux_asciizcp_t ptr, mmux_char_t schar)
{
  *result_p = strrchr(ptr, schar.value);
  return false;
}
bool
mmux_libc_strstr (mmux_asciizcp_t * result_p, mmux_asciizcp_t haystack, mmux_asciizcp_t needle)
{
  *result_p = strstr(haystack, needle);
  return false;
}
bool
mmux_libc_strcasestr (mmux_asciizcp_t * result_p, mmux_asciizcp_t haystack, mmux_asciizcp_t needle)
{
  *result_p = strcasestr(haystack, needle);
  return false;
}
bool
mmux_libc_strspn (mmux_usize_t * result_len_p, mmux_asciizcp_t str, mmux_asciizcp_t skipset)
{
  *result_len_p = mmux_usize(strspn(str, skipset));
  return false;
}
bool
mmux_libc_strcspn (mmux_usize_t * result_len_p, mmux_asciizcp_t str, mmux_asciizcp_t stopset)
{
  *result_len_p = mmux_usize(strcspn(str, stopset));
  return false;
}
bool
mmux_libc_strpbrk (mmux_asciizcp_t * result_p, mmux_asciizcp_t str, mmux_asciizcp_t stopset)
{
  *result_p = strpbrk(str, stopset);
  return false;
}


/** --------------------------------------------------------------------
 ** Tokens.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strtok (mmux_asciizp_t * result_p, mmux_asciizp_t newstring, mmux_asciizcp_t delimiters)
{
  *result_p = strtok(newstring, delimiters);
  return false;
}
bool
mmux_libc_strtok_r (mmux_asciizp_t * result_p, mmux_asciizp_t newstring, mmux_asciizcp_t delimiters,
		    mmux_asciizp_t * save_ptr)
{
  *result_p = strtok_r(newstring, delimiters, save_ptr);
  return false;
}
bool
mmux_libc_strsep (mmux_asciizp_t * result_p, mmux_asciizp_t * newstring_p, mmux_asciizcp_t delimiters)
{
  *result_p = strsep(newstring_p, delimiters);
  return false;
}
bool
mmux_libc_basename (mmux_asciizcp_t * result_p, mmux_asciizcp_t pathname)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_BASENAME]]],[[[
  *result_p = basename(pathname);
  return false;
]]])
}
bool
mmux_libc_dirname (mmux_asciizcp_t * result_p, mmux_asciizcp_t pathname)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_DIRNAME]]],[[[
  *result_p = dirname(pathname);
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Custom strings: global variables.
 ** ----------------------------------------------------------------- */

static mmux_libc_string_class_t const	mmux_libc_string_class_static = {
  .memory_allocator	= &mmux_libc_fake_memory_allocator,
};

static mmux_libc_string_class_t const	mmux_libc_string_class_dynamic = {
  .memory_allocator	= &mmux_libc_default_memory_allocator,
};


/** --------------------------------------------------------------------
 ** Custom strings: strings factory, statically-allocated strings.
 ** ----------------------------------------------------------------- */

/* To construct a new string using the static factory we do:
 *
 *   mmux_asciizcp_t          str_asciiz = "/path/to/file.ext";
 *   mmux_libc_str_factory_t  str_factory;
 *   mmux_libc_str_t          str;
 *
 *   mmux_libc_string_factory_static(str_factory);
 *   if (mmux_libc_make_string(str, str_factory, str_asciiz)) {
 *     // error
 *   } else {
 *     ...
 *     mmux_libc_unmake_string(str);
 *   }
 */

static bool
mmux_libc_string_factory_static_make_from_asciiz
    (mmux_libc_str_t str_result,
     mmux_libc_str_factory_arg_t str_factory MMUX_CC_LIBC_UNUSED,
     mmux_asciizcp_t str_asciiz_source)
/* This  function is  the implementation  of  the method  "make_from_asciiz" for  the
   string factory "mmux_libc_string_factory_static".

   This function constructs a new string data structure and stores it in the variable
   referenced by "str_result".

   The new string  references an already allocated and immutable  ASCIIZ string, with
   ethernal life; for example a statically-allocated hard-coded string.
*/
{
  /* Validate the arguments. */
  {
    {
      _Pragma("GCC diagnostic push");
      _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
      if (NULL == str_asciiz_source) {
	mmux_libc_errno_set(MMUX_LIBC_EINVAL);
	return true;
      }
      _Pragma("GCC diagnostic pop");
    }
  }

  /* Construct the resulting data structure. */
  {
    str_result->value = str_asciiz_source;
    str_result->class = &mmux_libc_string_class_static;
    return false;
  }
}
static bool
mmux_libc_string_factory_static_make_from_ascii_len
    (mmux_libc_str_t			str_result		MMUX_CC_LIBC_UNUSED,
     mmux_libc_str_factory_arg_t	str_factory		MMUX_CC_LIBC_UNUSED,
     mmux_asciicp_t			src_str_ascii		MMUX_CC_LIBC_UNUSED,
     mmux_usize_t			src_str_len_no_nul	MMUX_CC_LIBC_UNUSED)
/* This function  is the implementation  of the method "make_from_ascii_len"  for the
   string factory "mmux_libc_string_factory_static". */
{
  mmux_libc_errno_set(MMUX_LIBC_ENOTSUP);
  return true;
}
static bool
mmux_libc_string_factory_static_make_from_prefix_and_suffix
    (mmux_libc_str_t str_result				MMUX_CC_LIBC_UNUSED,
     mmux_libc_string_factory_t const * str_factory	MMUX_CC_LIBC_UNUSED,
     mmux_libc_str_arg_t str_prefix			MMUX_CC_LIBC_UNUSED,
     mmux_libc_str_arg_t str_suffix			MMUX_CC_LIBC_UNUSED)
/* This function  is the  implementation of the  method "make_from_prefix_and_suffix"
   for the string factory "mmux_libc_string_factory_static". */
{
  mmux_libc_errno_set(MMUX_LIBC_ENOTSUP);
  return true;
}
static mmux_libc_string_factory_class_t		const mmux_libc_string_factory_static__class = {
  .make_from_asciiz		= mmux_libc_string_factory_static_make_from_asciiz,
  .make_from_ascii_len		= mmux_libc_string_factory_static_make_from_ascii_len,
  .make_from_prefix_and_suffix	= mmux_libc_string_factory_static_make_from_prefix_and_suffix,
};
static mmux_libc_string_factory_t		const mmux_libc_string_factory_static__object = {
  .class = &mmux_libc_string_factory_static__class,
};
bool
mmux_libc_string_factory_static (mmux_libc_str_factory_t str_factory)
{
  str_factory[0] = mmux_libc_string_factory_static__object;
  return false;
}


/** --------------------------------------------------------------------
 ** Custom strings: strings factory, dynamically-allocated strings, default allocator.
 ** ----------------------------------------------------------------- */

/* To construct a new string using the dynamic factory we do:
 *
 *   mmux_asciizcp_t          str_asciiz = "/path/to/file.ext";
 *   mmux_libc_str_factory_t  str_factory;
 *   mmux_libc_str_t          str;
 *
 *   mmux_libc_string_factory_dynamic(str_factory);
 *   if (mmux_libc_make_string(str, str_factory, str_asciiz)) {
 *     // error
 *   } else {
 *     ...
 *     mmux_libc_unmake_string(str);
 *   }
 */

static bool
mmux_libc_string_factory_dynamic_make_from_asciiz
    (mmux_libc_str_t str_result,
     mmux_libc_str_factory_arg_t str_factory MMUX_CC_LIBC_UNUSED,
     mmux_asciizcp_t str_asciiz_source)
/* This  function is  the implementation  of  the method  "make_from_asciiz" for  the
   string factory "mmux_libc_string_factory_dynamic".

   This function Constructs a new string data structure and stores it in the variable
   referenced by "str_result".

   The new string references an ASCIIZ string allocated by this constructor using the
   factory's memory allocator.
*/
{
  /* Validate the arguments. */
  {
    {
      _Pragma("GCC diagnostic push");
      _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
      if (NULL == str_asciiz_source) {
	mmux_libc_errno_set(MMUX_LIBC_EINVAL);
	return true;
      }
      _Pragma("GCC diagnostic pop");
    }
  }

  /* Construct the resulting data structure. */
  {
    mmux_libc_string_class_t const *	class = &mmux_libc_string_class_dynamic;
    mmux_usize_t			src_str_len_plus_nil;
    mmux_asciizcp_t			dst_str_asciiz;

    mmux_libc_strlen_plus_nil(&src_str_len_plus_nil, str_asciiz_source);
    if (mmux_libc_memory_allocator_malloc_and_copy(class->memory_allocator,
						   &dst_str_asciiz, str_asciiz_source,
						   src_str_len_plus_nil)) {
      return true;
    } else {
      str_result->value = dst_str_asciiz;
      str_result->class = class;
      return false;
    }
  }
}
static bool
mmux_libc_string_factory_dynamic_make_from_ascii_len
    (mmux_libc_str_t str_result,
     mmux_libc_str_factory_arg_t str_factory MMUX_CC_LIBC_UNUSED,
     mmux_asciicp_t str_source_ascii, mmux_usize_t str_source_length_no_nul)
/* This function  is the implementation  of the method "make_from_ascii_len"  for the
   string factory "mmux_libc_string_factory_dynamic".

   This funcion constructs a new string data  structure and stores it in the variable
   referenced by "str_result".

   The new  string object references an  ASCIIZ string allocated by  this constructor
   using the factory's memory allocator.
*/
{
  /* Validate the arguments. */
  {
    {
      _Pragma("GCC diagnostic push");
      _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
      if (NULL == str_source_ascii) {
	mmux_libc_errno_set(MMUX_LIBC_EINVAL);
	return true;
      }
      _Pragma("GCC diagnostic pop");
    }
  }

  /* Construct the resulting data structure. */
  {
    mmux_libc_string_class_t const *	class = &mmux_libc_string_class_dynamic;
    auto		str_result_length_with_nul = mmux_ctype_incr(str_source_length_no_nul);
    mmux_asciizp_t	str_result_asciiz;

    if (mmux_libc_memory_allocator_malloc(class->memory_allocator, &str_result_asciiz, str_result_length_with_nul)) {
      return true;
    } else {
      mmux_libc_memcpy(str_result_asciiz, str_source_ascii, str_source_length_no_nul);
      str_result_asciiz[str_source_length_no_nul.value] = '\0';
      str_result->value = str_result_asciiz;
      str_result->class = class;
      return false;
    }
  }
}
static bool
mmux_libc_string_factory_dynamic_make_from_prefix_and_suffix
    (mmux_libc_str_t str_result,
     mmux_libc_string_factory_t const * str_factory MMUX_CC_LIBC_UNUSED,
     mmux_libc_str_arg_t str_prefix,
     mmux_libc_str_arg_t str_suffix)
/* This function  is the  implementation of the  method "make_from_prefix_and_suffix"
   for the string factory "mmux_libc_string_factory_dynamic". */
{
  mmux_usize_t	result_length_including_nul;
  mmux_usize_t	prefix_length;
  mmux_usize_t	suffix_length, suffix_length_including_nul;

  mmux_libc_string_len_ref(&prefix_length, str_prefix);
  mmux_libc_string_len_ref(&suffix_length, str_suffix);
  suffix_length_including_nul = mmux_ctype_incr(suffix_length);

  /* Validate the arguments. */
  {
    /* Avoid overflowing the usize meant to hold the length of the new string. */
    if (mmux_ctype_greater(suffix_length_including_nul,
			   mmux_ctype_sub(mmux_usize_constant_maximum(), prefix_length))) {
      mmux_libc_errno_set(MMUX_LIBC_EINVAL);
      return true;
    }
  }

  /* Construct the resulting data structure. */
  {
    mmux_libc_string_class_t const *	class = &mmux_libc_string_class_dynamic;
    mmux_asciizp_t			str_result_asciiz;

    result_length_including_nul = mmux_ctype_add(prefix_length, suffix_length_including_nul);
    if (false) {
      mmux_libc_dprintfer_no_error("str_prefix=%s\n", str_prefix->value);
      mmux_libc_dprintfer_no_error("str_suffix=%s\n", str_suffix->value);
      mmux_libc_dprintfer_no_error("result_length_including_nul=%lu, prefix_length=%lu, suffix_length_including_nul=%lu\n",
				   result_length_including_nul.value,
				   prefix_length.value,
				   suffix_length_including_nul.value);
    }
    if (mmux_libc_memory_allocator_malloc(class->memory_allocator, &str_result_asciiz, result_length_including_nul)) {
      return true;
    } else {
      strncpy(str_result_asciiz,                       str_prefix->value, prefix_length.value);
      strncpy(str_result_asciiz + prefix_length.value, str_suffix->value, suffix_length_including_nul.value);
      str_result->value = str_result_asciiz;
      str_result->class = class;
      return false;
    }
  }
}
static mmux_libc_string_factory_class_t		const mmux_libc_string_factory_dynamic__class = {
  .make_from_asciiz		= mmux_libc_string_factory_dynamic_make_from_asciiz,
  .make_from_ascii_len		= mmux_libc_string_factory_dynamic_make_from_ascii_len,
  .make_from_prefix_and_suffix	= mmux_libc_string_factory_dynamic_make_from_prefix_and_suffix,
};
static mmux_libc_string_factory_copying_t	const mmux_libc_string_factory_dynamic__object = {
  .class		= &mmux_libc_string_factory_dynamic__class,
};
bool
mmux_libc_string_factory_dynamic (mmux_libc_str_factory_copying_t str_factory)
{
  str_factory[0] = mmux_libc_string_factory_dynamic__object;
  return false;
}


/** --------------------------------------------------------------------
 ** Custom strings: strings factory, swallowed strings, default allocator.
 ** ----------------------------------------------------------------- */

/* To construct a new string using the swallow factory we do:
 *
 *   mmux_asciizp_t	bufptr;
 *   mmux_libc_str_t	str;
 *
 *   // Allocate a string using the standard malloc.
 *   {
 *     mmux_asciizcp_t	str_asciiz = "/path/to/file.ext";
 *     mmux_usize_t	buflen_with_nil;
 *
 *     mmux_libc_strlen_plus_nil(&buflen_with_nil, str_asciiz);
 *     if (mmux_libc_malloc_and_copy(&bufptr, str_asciiz, buflen_with_nil)) {
 *       // error
 *     }
 *   }
 *
 *   // Build the string object, swallowing the already allocated string.  The string
 *   // object acquires the ownership of string's memory.
 *   {
 *     mmux_libc_str_factory_t  str_factory;
 *
 *     mmux_libc_string_factory_swallow(str_factory);
 *     if (mmux_libc_make_string(str, str_factory, str_asciiz)) {
 *       // error
 *     }
 *   }
 *
 *   ...
 *
 *   // Final cleanup.
 *   {
 *     mmux_libc_unmake_string(str);
 *   }
 */

static bool
mmux_libc_string_factory_swallow_make_from_asciiz
(mmux_libc_str_t str_result,
 mmux_libc_str_factory_arg_t str_factory MMUX_CC_LIBC_UNUSED,
 mmux_asciizcp_t str_source_asciiz)
/* This  function is  the implementation  of  the method  "make_from_asciiz" for  the
   string factory "mmux_libc_string_factory_swallow".

   This function constructs a new string data structure and stores it in the variable
   referenced by "str_result".

   The new string swallows an ASCIIZ string  allocated by some other module using the
   standard "malloc()", taking exclusive ownership  of the memory itself.  The string
   will be  released with  the standard  function "free()"  using the  default memory
   allocator.
*/
{
  /* Validate the arguments. */
  {
    {
      _Pragma("GCC diagnostic push");
      _Pragma("GCC diagnostic ignored \"-Wnonnull-compare\"");
      if (NULL == str_source_asciiz) {
	mmux_libc_errno_set(MMUX_LIBC_EINVAL);
	return true;
      }
      _Pragma("GCC diagnostic pop");
    }
  }

  /* Construct the resulting data structure. */
  {
    str_result->value = str_source_asciiz;
    str_result->class = &mmux_libc_string_class_dynamic;
    return false;
  }
}
static bool
mmux_libc_string_factory_swallow_make_from_ascii_len
    (mmux_libc_str_t			str_result		MMUX_CC_LIBC_UNUSED,
     mmux_libc_str_factory_arg_t	str_factory		MMUX_CC_LIBC_UNUSED,
     mmux_asciicp_t			src_str_ascii		MMUX_CC_LIBC_UNUSED,
     mmux_usize_t			src_str_len_no_nul	MMUX_CC_LIBC_UNUSED)
/* This function  is the implementation  of the method "make_from_ascii_len"  for the
   string factory "mmux_libc_string_factory_swallow". */
{
  mmux_libc_errno_set(MMUX_LIBC_ENOTSUP);
  return true;
}
static bool
mmux_libc_string_factory_swallow_make_from_prefix_and_suffix
    (mmux_libc_str_t str_result				MMUX_CC_LIBC_UNUSED,
     mmux_libc_string_factory_t const * str_factory	MMUX_CC_LIBC_UNUSED,
     mmux_libc_str_arg_t str_prefix			MMUX_CC_LIBC_UNUSED,
     mmux_libc_str_arg_t str_suffix			MMUX_CC_LIBC_UNUSED)
/* This function  is the  implementation of the  method "make_from_prefix_and_suffix"
   for the string factory "mmux_libc_string_factory_swallow". */
{
  mmux_libc_errno_set(MMUX_LIBC_ENOTSUP);
  return true;
}
static mmux_libc_string_factory_class_t		const mmux_libc_string_factory_swallow__class = {
  .make_from_asciiz		= mmux_libc_string_factory_swallow_make_from_asciiz,
  .make_from_ascii_len		= mmux_libc_string_factory_swallow_make_from_ascii_len,
  .make_from_prefix_and_suffix	= mmux_libc_string_factory_swallow_make_from_prefix_and_suffix,
};
static mmux_libc_string_factory_t		const mmux_libc_string_factory_swallow__object = {
  .class		= &mmux_libc_string_factory_swallow__class,
};
bool
mmux_libc_string_factory_swallow (mmux_libc_str_factory_t str_factory)
{
  str_factory[0] = mmux_libc_string_factory_swallow__object;
  return false;
}


/** --------------------------------------------------------------------
 ** Custom strings: constructors and destructors.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_string (mmux_libc_str_t str,
		       mmux_libc_str_factory_arg_t str_factory,
		       mmux_asciizcp_t src_str_asciiz)
{
  return str_factory->class->make_from_asciiz(str, str_factory, src_str_asciiz);
}
bool
mmux_libc_make_string2 (mmux_libc_str_t str,
			mmux_libc_str_factory_copying_arg_t str_factory,
			mmux_asciicp_t src_str_ascii, mmux_usize_t src_str_len_no_nul)
{
  return str_factory->class->make_from_ascii_len(str, str_factory, src_str_ascii, src_str_len_no_nul);
}
bool
mmux_libc_make_string_concat (mmux_libc_str_t				str_result,
			      mmux_libc_str_factory_copying_arg_t	str_factory,
			      mmux_libc_str_arg_t			str_prefix,
			      mmux_libc_str_arg_t			str_suffix)
{
  return str_factory->class->make_from_prefix_and_suffix(str_result, str_factory, str_prefix, str_suffix);
}
bool
mmux_libc_unmake_string (mmux_libc_str_t str)
{
  if (str->class->memory_allocator->class->free(str->class->memory_allocator, (mmux_pointer_t)str->value)) {
    return true;
  } else {
    str->value = NULL;
    return false;
  }
}
bool
mmux_libc_unmake_string_variable (mmux_libc_str_t * str_p)
/* This is an experimental function to be used with the GCC extension "cleanup":
 *
 *   mmux_libc_str_t  str2 = str1
 *     __attribute__((__cleanup__(mmux_libc_unmake_string_variable)));
 *
 */
{
  return mmux_libc_unmake_string(*str_p);
}


/** --------------------------------------------------------------------
 ** Custom strings: accessors.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_string_ptr_ref (mmux_asciizcpp_t str_asciiz_result_p, mmux_libc_str_arg_t str)
{
  *str_asciiz_result_p = str->value;
  return false;
}
bool
mmux_libc_string_len_ref (mmux_usize_t * str_len_no_nul_result_p, mmux_libc_str_arg_t str)
{
  return mmux_libc_strlen(str_len_no_nul_result_p, str->value);
}
bool
mmux_libc_string_len_including_nul_ref (mmux_usize_t * str_len_including_nul_result_p, mmux_libc_str_arg_t str)
{
  return mmux_libc_strlen_plus_nil(str_len_including_nul_result_p, str->value);
}


/** --------------------------------------------------------------------
 ** Custom strings: comparison operations.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_string_compare (mmux_ternary_comparison_result_t * result_p,
			  mmux_libc_str_arg_t ptn1,
			  mmux_libc_str_arg_t ptn2)
{
  return mmux_ternary_comparison_result_p(result_p, strcmp(ptn1->value, ptn2->value));
}

m4_define([[[DEFINE_STRING_COMPARISON_PREDICATE]]],[[[bool
mmux_libc_string_$1 (bool * result_p, mmux_libc_str_arg_t ptn1, mmux_libc_str_arg_t ptn2)
{
  mmux_ternary_comparison_result_t	cmpnum;

  if (mmux_libc_strcmp(&cmpnum, ptn1->value, ptn2->value)) {
    return true;
  } else {
    *result_p = mmux_ternary_comparison_result_is_$1(cmpnum);
    return false;
  }
}]]])
DEFINE_STRING_COMPARISON_PREDICATE([[[equal]]])
DEFINE_STRING_COMPARISON_PREDICATE([[[not_equal]]])
DEFINE_STRING_COMPARISON_PREDICATE([[[less]]])
DEFINE_STRING_COMPARISON_PREDICATE([[[greater]]])
DEFINE_STRING_COMPARISON_PREDICATE([[[less_equal]]])
DEFINE_STRING_COMPARISON_PREDICATE([[[greater_equal]]])

/* end of file */
