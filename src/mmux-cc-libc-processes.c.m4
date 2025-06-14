/*
  Part of: MMUX CC Libc
  Contents: operative system processes management
  Date: Dec 17, 2024

  Abstract

	This module implements the operative system processes management API.

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
 ** Identifier functions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_pid (mmux_libc_pid_t * result_p, mmux_pid_t pid_num)
{
  if (0 <= pid_num) {
    result_p->value = pid_num;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_pid_parse (mmux_libc_pid_t * p_value, char const * s_value, char const * who)
{
  mmux_libc_pid_t	the_pid;

  if (mmux_pid_parse(&the_pid.value, s_value, who)) {
    return true;
  }
  *p_value = the_pid;
  return false;
}
bool
mmux_libc_pid_sprint (char * ptr, mmux_usize_t len, mmux_libc_pid_t pid)
{
  if (MMUX_LIBC_PID_MAXIMUM_STRING_REPRESENTATION_LENGTH < len) {
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
  return mmux_pid_sprint(ptr, len, pid.value);
}
bool
mmux_libc_pid_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_pid_t pid)
{
  mmux_sint_t	required_nchars = mmux_pid_sprint_size(pid.value);

  if (0 <= required_nchars) {
    *required_nchars_p = required_nchars;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_getpid (mmux_libc_pid_t * result_p)
{
  mmux_pid_t	rv = getpid();
  return mmux_libc_make_pid(result_p, rv);
}
bool
mmux_libc_getppid (mmux_libc_pid_t * result_p)
{
  mmux_pid_t	rv = getppid();
  return mmux_libc_make_pid(result_p, rv);
}
bool
mmux_libc_gettid (mmux_libc_pid_t * result_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_GETTID]]],[[[
  mmux_pid_t	rv = gettid();
  return mmux_libc_make_pid(result_p, rv);
]]])
}


/** --------------------------------------------------------------------
 ** Identifier functions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_exit (mmux_sint_t status)
{
  exit(status);
  return false;
}
bool
mmux_libc__exit (mmux_sint_t status)
{
  _exit(status);
  return false;
}
bool
mmux_libc_atexit (void (*function_pointer) (void))
{
  atexit(function_pointer);
  return false;
}


/* end of file */
