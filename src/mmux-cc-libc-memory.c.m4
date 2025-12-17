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
  mmux_pointer_t	P = malloc(len.value);

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
  mmux_pointer_t	P = calloc(item_num.value, item_len.value);

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
  mmux_pointer_t	P = realloc(*P_p, newlen.value);

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
  mmux_pointer_t	P = reallocarray(*P_p, item_num.value, item_len.value);

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
bool
mmux_libc_malloc_and_copy_ (mmux_pointer_t * dstptr_p, mmux_pointer_t srcptr, mmux_usize_t srclen)
{
  mmux_pointer_t	dstptr;

  if (mmux_libc_malloc(&dstptr, srclen)) {
    return true;
  } else {
    memcpy(dstptr, srcptr, srclen.value);
    *dstptr_p = dstptr;
    return false;
  }
}


/** --------------------------------------------------------------------
 ** Common operations.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_memset (mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t len)
{
  memset(ptr, octet.value, len.value);
  return false;
}
bool
mmux_libc_memzero (mmux_pointer_t ptr, mmux_usize_t len)
{
  memset(ptr, '\0', len.value);
  return false;
}
bool
mmux_libc_memzero_socklen (mmux_pointer_t ptr, mmux_libc_socklen_t len)
{
  memset(ptr, '\0', (mmux_standard_usize_t)len.value);
  return false;
}
bool
mmux_libc_memcpy (mmux_pointer_t dst_ptr, mmux_pointerc_t src_ptr, mmux_usize_t nbytes)
{
  memcpy(dst_ptr, src_ptr, nbytes.value);
  return false;
}
bool
mmux_libc_mempcpy_ (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMPCPY]]],[[[
  *result_p = mempcpy(dst_ptr, src_ptr, nbytes.value);
  return false;
]]])
}
bool
mmux_libc_memccpy_ (mmux_pointer_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr,
		    mmux_octet_t octet, mmux_usize_t nbytes)
{
  *result_p = memccpy(dst_ptr, src_ptr, octet.value, nbytes.value);
  return false;
}
bool
mmux_libc_memmove (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
{
  memmove(dst_ptr, src_ptr, nbytes.value);
  return false;
}
bool
mmux_libc_memcmp (mmux_ternary_comparison_result_t * result_p,
		  mmux_pointerc_t ptr1, mmux_pointerc_t ptr2, mmux_usize_t nbytes)
{
  *result_p = mmux_ternary_comparison_result(memcmp(ptr1, ptr2, nbytes.value));
  return false;
}
bool
mmux_libc_memchr_ (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
{
  *result_p = memchr(ptr, octet.value, nbytes.value);
  return false;
}
bool
mmux_libc_rawmemchr_ (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_RAWMEMCHR]]],[[[
  *result_p = rawmemchr(ptr, octet.value);
  return false;
]]])
}
bool
mmux_libc_memrchr_ (mmux_pointer_t * result_p, mmux_pointer_t ptr, mmux_octet_t octet, mmux_usize_t nbytes)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMRCHR]]],[[[
  *result_p = memrchr(ptr, octet.value, nbytes.value);
  return false;
]]])
}
bool
mmux_libc_memmem_ (mmux_pointer_t * result_p,
		   mmux_pointer_t haystack_ptr, mmux_usize_t haystack_len,
		   mmux_pointer_t needle_ptr,   mmux_usize_t needle_len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMMEM]]],[[[
  *result_p = memmem(haystack_ptr, haystack_len.value, needle_ptr, needle_len.value);
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Memory allocators: default memory allocator implementation.
 ** ----------------------------------------------------------------- */

static bool
mmux_libc_default_memory_allocator_malloc (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					   mmux_pointer_t * result_p, mmux_usize_t len)
{
  return mmux_libc_malloc_(result_p, len);
}
static bool
mmux_libc_default_memory_allocator_calloc (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					   mmux_pointer_t * result_p,
					   mmux_usize_t item_num, mmux_usize_t item_len)
{
  return mmux_libc_calloc_(result_p, item_num, item_len);
}
static bool
mmux_libc_default_memory_allocator_realloc (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					    mmux_pointer_t * result_p, mmux_usize_t newlen)
{
  return mmux_libc_realloc_(result_p, newlen);
}
static bool
mmux_libc_default_memory_allocator_reallocarray (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
						 mmux_pointer_t * result_p,
						 mmux_usize_t item_num, mmux_usize_t item_len)
{
  return mmux_libc_reallocarray_(result_p, item_num, item_len);
}
static bool
mmux_libc_default_memory_allocator_free (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					 mmux_pointer_t p)
{
  return mmux_libc_free(p);
}
bool
mmux_libc_default_memory_allocator_malloc_and_copy (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
						    mmux_pointer_t * dstptr_p,
						    mmux_pointer_t srcptr, mmux_usize_t srclen)
{
  return mmux_libc_malloc_and_copy_(dstptr_p, srcptr, srclen);
}

/* ------------------------------------------------------------------ */

static mmux_libc_memory_allocator_value_t const mmux_libc_default_memory_allocator_value = {
  .data = NULL,
};

static mmux_libc_memory_allocator_class_t const mmux_libc_default_memory_allocator_class = {
  .malloc		= mmux_libc_default_memory_allocator_malloc,
  .realloc		= mmux_libc_default_memory_allocator_realloc,
  .calloc		= mmux_libc_default_memory_allocator_calloc,
  .reallocarray		= mmux_libc_default_memory_allocator_reallocarray,
  .free			= mmux_libc_default_memory_allocator_free,
  .malloc_and_copy	= mmux_libc_default_memory_allocator_malloc_and_copy,
};

mmux_libc_memory_allocator_t const mmux_libc_default_memory_allocator = {
  .value	= (mmux_libc_memory_allocator_value_t *) &mmux_libc_default_memory_allocator_value,
  .class	= &mmux_libc_default_memory_allocator_class,
};

/* ------------------------------------------------------------------ */

bool
mmux_libc_default_memory_allocator_ref (mmux_libc_mall_t* result_p)
{
  *result_p = &mmux_libc_default_memory_allocator;
  return false;
}


/** --------------------------------------------------------------------
 ** Memory allocators: statically allocated memory fake memory allocator implementation.
 ** ----------------------------------------------------------------- */

static bool
mmux_libc_fake_memory_allocator_malloc (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					mmux_pointer_t * result_p MMUX_CC_LIBC_UNUSED,
					mmux_usize_t len MMUX_CC_LIBC_UNUSED)
{
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
}
static bool
mmux_libc_fake_memory_allocator_calloc (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					mmux_pointer_t * result_p MMUX_CC_LIBC_UNUSED,
					mmux_usize_t item_num MMUX_CC_LIBC_UNUSED,
					mmux_usize_t item_len MMUX_CC_LIBC_UNUSED)
{
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
}
static bool
mmux_libc_fake_memory_allocator_realloc (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					 mmux_pointer_t * result_p MMUX_CC_LIBC_UNUSED,
					 mmux_usize_t newlen MMUX_CC_LIBC_UNUSED)
{
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
}
static bool
mmux_libc_fake_memory_allocator_reallocarray (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
					      mmux_pointer_t * result_p MMUX_CC_LIBC_UNUSED,
					      mmux_usize_t item_num MMUX_CC_LIBC_UNUSED,
					      mmux_usize_t item_len MMUX_CC_LIBC_UNUSED)
{
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
}
static bool
mmux_libc_fake_memory_allocator_free (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
				      mmux_pointer_t p MMUX_CC_LIBC_UNUSED)
{
  return false;
}
bool
mmux_libc_fake_memory_allocator_malloc_and_copy (mmux_libc_mall_t self MMUX_CC_LIBC_UNUSED,
						 mmux_pointer_t * dstptr_p MMUX_CC_LIBC_UNUSED,
						 mmux_pointer_t srcptr MMUX_CC_LIBC_UNUSED,
						 mmux_usize_t srclen MMUX_CC_LIBC_UNUSED)
{
  *dstptr_p = srcptr;
  return false;
}

/* ------------------------------------------------------------------ */

static mmux_libc_memory_allocator_value_t const mmux_libc_fake_memory_allocator_value = {
  .data = NULL,
};

static mmux_libc_memory_allocator_class_t const mmux_libc_fake_memory_allocator_class = {
  .malloc		= mmux_libc_fake_memory_allocator_malloc,
  .realloc		= mmux_libc_fake_memory_allocator_realloc,
  .calloc		= mmux_libc_fake_memory_allocator_calloc,
  .reallocarray		= mmux_libc_fake_memory_allocator_reallocarray,
  .free			= mmux_libc_fake_memory_allocator_free,
  .malloc_and_copy	= mmux_libc_fake_memory_allocator_malloc_and_copy,
};

mmux_libc_memory_allocator_t const mmux_libc_fake_memory_allocator = {
  .value	= (mmux_libc_memory_allocator_value_t *) &mmux_libc_fake_memory_allocator_value,
  .class	= &mmux_libc_fake_memory_allocator_class,
};

/* ------------------------------------------------------------------ */

bool
mmux_libc_fake_memory_allocator_ref (mmux_libc_mall_t* result_p)
{
  *result_p = &mmux_libc_fake_memory_allocator;
  return false;
}


/** --------------------------------------------------------------------
 ** Memory allocators: API.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_memory_allocator_malloc_ (mmux_libc_mall_t allocator,
				    mmux_pointer_t * result_p, mmux_usize_t len)
{
  return allocator->class->malloc(allocator, result_p, len);
}
bool
mmux_libc_memory_allocator_calloc_ (mmux_libc_mall_t allocator,
				    mmux_pointer_t * result_p,
				    mmux_usize_t item_num, mmux_usize_t item_len)
{
  return allocator->class->calloc(allocator, result_p, item_num, item_len);
}
bool
mmux_libc_memory_allocator_realloc_ (mmux_libc_mall_t allocator,
				     mmux_pointer_t * result_p, mmux_usize_t newlen)
{
  return allocator->class->realloc(allocator, result_p, newlen);
}
bool
mmux_libc_memory_allocator_reallocarray_ (mmux_libc_mall_t allocator,
					  mmux_pointer_t * result_p, mmux_usize_t item_num,
					  mmux_usize_t item_len)
{
  return allocator->class->reallocarray(allocator, result_p, item_num, item_len);
}
bool
mmux_libc_memory_allocator_free (mmux_libc_mall_t allocator,
				 mmux_pointer_t p)
{
  return allocator->class->free(allocator, p);
}
bool
mmux_libc_memory_allocator_malloc_and_copy_ (mmux_libc_mall_t allocator,
					     mmux_pointer_t * dstptr_p, mmux_pointer_t srcptr, mmux_usize_t srclen)
{
  return allocator->class->malloc_and_copy(allocator, dstptr_p, srcptr, srclen);
}

/* end of file */
