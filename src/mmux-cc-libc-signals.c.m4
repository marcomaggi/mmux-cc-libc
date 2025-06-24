/*
  Part of: MMUX CC Libc
  Contents: interprocess signals management
  Date: Jun 24, 2025

  Abstract

	This module implements the interprocess signals management API.

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
 ** Process identifier stucture.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_interprocess_signal (mmux_libc_interprocess_signal_t * result_p, mmux_sint_t signum)
{
  if (0 <= signum) {
    result_p->value = signum;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_interprocess_signal_equal (mmux_libc_interprocess_signal_t one, mmux_libc_interprocess_signal_t two)
{
  if (one.value == two.value) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_interprocess_signal_parse (mmux_libc_interprocess_signal_t * p_value, char const * s_value, char const * who)
{
  mmux_libc_interprocess_signal_t	signum;

  if (mmux_sint_parse(&signum.value, s_value, who)) {
    return true;
  }
  *p_value = signum;
  return false;
}
bool
mmux_libc_interprocess_signal_sprint (char * ptr, mmux_usize_t len, mmux_libc_interprocess_signal_t ipxsignal)
{
  if (MMUX_LIBC_INTERPROCESS_SIGNAL_MAXIMUM_STRING_REPRESENTATION_LENGTH < len) {
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
  return mmux_sint_sprint(ptr, len, ipxsignal.value);
}
bool
mmux_libc_interprocess_signal_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_interprocess_signal_t ipxsig MMUX_CC_LIBC_UNUSED)
{
  mmux_sint_t	required_nchars = mmux_sint_sprint_size(ipxsig.value);

  if (0 <= required_nchars) {
    *required_nchars_p = required_nchars;
    return false;
  } else {
    return true;
  }
}

/* end of file */
