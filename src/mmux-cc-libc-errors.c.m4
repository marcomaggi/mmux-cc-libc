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
  *result_errnum_p = errno;
  return (errno)? false : true;
}
bool
mmux_libc_errno_set (mmux_sint_t errnum)
{
  errno = errnum;
  return false;
}
bool
mmux_libc_errno_consume (mmux_sint_t * result_errnum_p)
{
  *result_errnum_p = errno;
  errno            = 0;
  return (*result_errnum_p)? false : true;
}
bool
mmux_libc_strerror (mmux_asciizcp_t * result_error_message_p, mmux_sint_t errnum)
{
  *result_error_message_p = strerror(errnum);
  return false;
}

/* end of file */
