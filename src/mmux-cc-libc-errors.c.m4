/*
  Part of: MMUX CC Libc
  Contents: errors management
  Date: Dec 31, 2024

  Abstract

	This module implements the errors API.

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
 ** Common errors management.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_errno_ref (mmux_sint_t * result_errnum_p)
{
  *result_errnum_p = mmux_sint(errno);
  return (errno)? false : true;
}
bool
mmux_libc_errno_set (mmux_sint_t errnum)
{
  errno = errnum.value;
  return false;
}
bool
mmux_libc_errno_consume (mmux_sint_t * result_errnum_p)
{
  *result_errnum_p = mmux_sint(errno);
  errno            = 0;
  return (result_errnum_p->value)? false : true;
}
bool
mmux_libc_strerror (mmux_asciizcpp_t result_error_message_p, mmux_sint_t errnum)
{
  *result_error_message_p = strerror(errnum.value);
  return false;
}

bool
mmux_libc_strerrorname_np (mmux_asciizcpp_t result_p, mmux_sint_t errnum)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRERRORNAME_NP]]],[[[
  *result_p = strerrorname_np(errnum.value);
  return false;
]]])
}
bool
mmux_libc_strerrordesc_np (mmux_asciizcpp_t result_p, mmux_sint_t errnum)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRERRORDESC_NP]]],[[[
  *result_p = strerrordesc_np(errnum.value);
  return false;
]]])
}
bool
mmux_libc_strerror_r (mmux_asciizcpp_t result_p, mmux_asciizp_t bufptr, mmux_usize_t buflen, mmux_sint_t errnum)
/* This is the GNU version of this function. */
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRERROR_R]]],[[[
  mmux_asciizp_t	rv;

  errno = 0;
  rv = strerror_r(errnum.value, bufptr, buflen.value);
  if (errno) {
    return true;
  } else {
    *result_p = rv;
    return false;
  }
]]])
}

#if 0 /* To be implemented in the future, maybe. */
bool
mmux_libc_strerror_l (mmux_asciizp_t result_p, mmux_sint_t errnum, mmux_libc_locale_t loc)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRERROR_L]]],[[[
  mmux_asciizcp_t	rv = strerror_l(errnum.value, loc.value);

  if (rv) {
    *result_p = rv;
    return false;
  } else {
    return true;
  }
]]])
}
#endif

bool
mmux_libc_program_invocation_name (mmux_asciizcpp_t result_p)
{
  *result_p = program_invocation_name;
  return false;
}
bool
mmux_libc_program_invocation_short_name (mmux_asciizcpp_t result_p)
{
  *result_p = program_invocation_short_name;
  return false;
}

/* end of file */
