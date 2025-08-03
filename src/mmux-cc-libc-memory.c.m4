/*
  Part of: MMUX CC Libc
  Contents: memory management
  Date: Dec 13, 2024

  Abstract

	This module implements the memory management API.

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


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc-internals.h>


/** --------------------------------------------------------------------
 ** Common allocation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_malloc_ (mmux_pointer_t * P_p, mmux_usize_t len)
{
  mmux_pointer_t	P = malloc(len);

  if (P) {
    *P_p = P;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_calloc_ (mmux_pointer_t * P_p, mmux_usize_t item_num, mmux_usize_t item_len)
{
  mmux_pointer_t	P = calloc(item_num, item_len);

  if (P) {
    *P_p = P;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_realloc_ (mmux_pointer_t * P_p, mmux_usize_t newlen)
{
  mmux_pointer_t	P = realloc(*P_p, newlen);

  if (P) {
    *P_p = P;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_reallocarray_ (mmux_pointer_t * P_p, mmux_usize_t item_num, mmux_usize_t item_len)
{
  mmux_pointer_t	P = reallocarray(*P_p, item_num, item_len);

  if (P) {
    *P_p = P;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_free (mmux_pointer_t P)
{
  free(P);
  return false;
}


/** --------------------------------------------------------------------
 ** Common operations.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_memset (mmux_pointer_t ptr, mmux_uint8_t octet, mmux_usize_t len)
{
  memset(ptr, octet, len);
  return false;
}
bool
mmux_libc_memzero (mmux_pointer_t ptr, mmux_usize_t len)
{
  memset(ptr, '\0', len);
  return false;
}
bool
mmux_libc_memcpy (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
{
  memcpy(dst_ptr, src_ptr, nbytes);
  return false;
}
bool
mmux_libc_mempcpy (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMPCPY]]],[[[
  *result_p = mempcpy(dst_ptr, src_ptr, nbytes);
  return false;
]]])
}
bool
mmux_libc_memccpy (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_uint8_t octet, mmux_usize_t nbytes)
{
  *result_p = memccpy(dst_ptr, src_ptr, octet, nbytes);
  return false;
}
bool
mmux_libc_memmove (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
{
  memmove(dst_ptr, src_ptr, nbytes);
  return false;
}
bool
mmux_libc_memcmp (mmux_sint_t * result_p, mmux_pointerc_t ptr1, mmux_pointerc_t ptr2, mmux_usize_t nbytes)
{
  *result_p = memcmp(ptr1, ptr2, nbytes);
  return false;
}
bool
mmux_libc_memchr (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
{
  *result_p = memchr(ptr, octet, nbytes);
  return false;
}
bool
mmux_libc_rawmemchr (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_RAWMEMCHR]]],[[[
  *result_p = rawmemchr(ptr, octet);
  return false;
]]])
}
bool
mmux_libc_memrchr (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMRCHR]]],[[[
  *result_p = memrchr(ptr, octet, nbytes);
  return false;
]]])
}
bool
mmux_libc_memmem (mmux_pointer_t * result_p,
		  mmux_pointer_t haystack_ptr, mmux_usize_t haystack_len,
		  mmux_pointer_t needle_ptr,   mmux_usize_t needle_len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMMEM]]],[[[
  *result_p = memmem(haystack_ptr, haystack_len, needle_ptr, needle_len);
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Memory allocator.
 ** ----------------------------------------------------------------- */

static bool
mmux_libc_default_memory_allocator_malloc (mmux_libc_memory_allocator_context_t * context MMUX_CC_LIBC_UNUSED,
					   mmux_pointer_t * result_p, mmux_usize_t len)
{
  return mmux_libc_malloc_(result_p, len);
}
static bool
mmux_libc_default_memory_allocator_calloc (mmux_libc_memory_allocator_context_t * context MMUX_CC_LIBC_UNUSED,
					   mmux_pointer_t * result_p,
					   mmux_usize_t item_num, mmux_usize_t item_len)
{
  return mmux_libc_calloc_(result_p, item_num, item_len);
}
static bool
mmux_libc_default_memory_allocator_realloc (mmux_libc_memory_allocator_context_t * context MMUX_CC_LIBC_UNUSED,
					    mmux_pointer_t * result_p, mmux_usize_t newlen)
{
  return mmux_libc_realloc_(result_p, newlen);
}
static bool
mmux_libc_default_memory_allocator_reallocarray (mmux_libc_memory_allocator_context_t * context MMUX_CC_LIBC_UNUSED,
						 mmux_pointer_t * result_p, mmux_usize_t item_num,
						 mmux_usize_t item_len)
{
  return mmux_libc_reallocarray_(result_p, item_num, item_len);
}
static bool
mmux_libc_default_memory_allocator_free (mmux_libc_memory_allocator_context_t * context MMUX_CC_LIBC_UNUSED,
					 mmux_pointer_t p)
{
  return mmux_libc_free(p);
}

/* ------------------------------------------------------------------ */

static mmux_libc_memory_allocator_context_t const mmux_libc_default_memory_allocator_context = {
  .name			= "MMUX CC Libc Default Memory Allocator",
  .version_major	= 1,
  .version_minor	= 0,
  .version_patchlevel	= 0,
};

static mmux_libc_memory_allocator_methods_t const mmux_libc_default_memory_allocator_methods = {
  .malloc		= mmux_libc_default_memory_allocator_malloc,
  .realloc		= mmux_libc_default_memory_allocator_realloc,
  .calloc		= mmux_libc_default_memory_allocator_calloc,
  .reallocarray		= mmux_libc_default_memory_allocator_reallocarray,
  .free			= mmux_libc_default_memory_allocator_free,
};

static mmux_libc_memory_allocator_t const mmux_libc_default_memory_allocator = {
  .context	= (mmux_libc_memory_allocator_context_t *) &mmux_libc_default_memory_allocator_context,
  .methods	= &mmux_libc_default_memory_allocator_methods,
};

/* ------------------------------------------------------------------ */

bool
mmux_libc_default_memory_allocator_ref (mmux_libc_memory_allocator_t const ** result_p)
{
  *result_p = &mmux_libc_default_memory_allocator;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_memory_allocator_malloc_ (mmux_libc_memory_allocator_t const * allocator,
				    mmux_pointer_t * result_p, mmux_usize_t len)
{
  return allocator->methods->malloc(allocator->context, result_p, len);
}
bool
mmux_libc_memory_allocator_calloc_ (mmux_libc_memory_allocator_t const * allocator,
				    mmux_pointer_t * result_p,
				    mmux_usize_t item_num, mmux_usize_t item_len)
{
  return allocator->methods->calloc(allocator->context, result_p, item_num, item_len);
}
bool
mmux_libc_memory_allocator_realloc_ (mmux_libc_memory_allocator_t const * allocator,
				     mmux_pointer_t * result_p, mmux_usize_t newlen)
{
  return allocator->methods->realloc(allocator->context, result_p, newlen);
}
bool
mmux_libc_memory_allocator_reallocarray_ (mmux_libc_memory_allocator_t const * allocator,
					  mmux_pointer_t * result_p, mmux_usize_t item_num,
					  mmux_usize_t item_len)
{
  return allocator->methods->reallocarray(allocator->context, result_p, item_num, item_len);
}
bool
mmux_libc_memory_allocator_free (mmux_libc_memory_allocator_t const * allocator,
				 mmux_pointer_t p)
{
  return allocator->methods->free(allocator->context, p);
}

/* end of file */
