/*
  Part of: MMUX CC Libc
  Contents: memory management
  Date: Dec 13, 2024

  Abstract

	This module implements the memory management API.

  Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>

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
mmux_libc_memcmp (mmux_sint_t * result_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t nbytes)
{
  *result_p = memcmp(dst_ptr, src_ptr, nbytes);
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


/* end of file */
