/*
  Part of: MMUX CC Libc
  Contents: system configuration
  Date: Dec 12, 2024

  Abstract

	This module implements the system configuration API.

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
 ** System configuration parameters.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sysconf (mmux_slong_t * value_p, mmux_sint_t parameter)
{
  mmux_slong_t	value;

  errno = 0;
  value = sysconf(parameter);
  if (-1 == value) {
    if (0 == errno) {
      /* No error: the system does not impose a limit. */
      goto no_error;
    } else {
      /* Error. */
      return true;
    }
  }
 no_error:
  *value_p = value;
  return false;
}
bool
mmux_libc_confstr_size (mmux_usize_t * required_nbytes_p, mmux_sint_t parameter)
{
  mmux_usize_t	required_nbytes = confstr(parameter, NULL, 0);

  if (0 == required_nbytes) {
    return true;
  } else {
    *required_nbytes_p = required_nbytes;
    return false;
  }
}
bool
mmux_libc_confstr (mmux_sint_t parameter, char * bufptr, mmux_usize_t buflen)
{
  mmux_usize_t	required_nbytes = confstr(parameter, bufptr, buflen);

  return ((0 == required_nbytes)? true : false);
}
bool
mmux_libc_pathconf (mmux_slong_t * result_p, mmux_libc_file_system_pathname_t pathname, mmux_sint_t parameter)
{
  mmux_slong_t	result;

  errno = 0;
  result = pathconf(pathname.value, parameter);
  if (-1 == result) {
    if (0 == errno) {
      /* No error: the system does not impose a limit. */
      goto no_error;
    } else {
      /* Error. */
      return true;
    }
  }
 no_error:
  *result_p = result;
  return false;
}
bool
mmux_libc_fpathconf (mmux_slong_t * result_p, mmux_libc_file_descriptor_t fd, mmux_sint_t parameter)
{
  mmux_slong_t	result;

  errno = 0;
  result = fpathconf(fd.value, parameter);
  if (-1 == result) {
    if (0 == errno) {
      /* No error: the system does not impose a limit. */
      goto no_error;
    } else {
      /* Error. */
      return true;
    }
  }
 no_error:
  *result_p = result;
  return false;
}


/** --------------------------------------------------------------------
 ** System configuration limits.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(rlimit,	rlim_cur,	mmux_rlim_t)
DEFINE_STRUCT_SETTER_GETTER(rlimit,	rlim_max,	mmux_rlim_t)

bool
mmux_libc_rlimit_dump (mmux_libc_file_descriptor_t fd, mmux_libc_rlimit_t * rlimit_pointer, char const * struct_name)
{
  int	rv;

  if (NULL == struct_name) {
    struct_name = "struct rlimit";
  }

  {
    rv = dprintf(fd.value, "%s = %p\n", struct_name, (mmux_pointer_t)rlimit_pointer);
    if (0 > rv) { return true; }
  }

  {
    int		len = mmux_rlim_sprint_size(rlimit_pointer->rlim_cur);
    char	str[len];

    mmux_rlim_sprint(str, len, rlimit_pointer->rlim_cur);
    rv = dprintf(fd.value, "%s->rlim_cur = %s\n", struct_name, str);
    if (0 > rv) { return true; }
  }

  {
    int		len = mmux_rlim_sprint_size(rlimit_pointer->rlim_max);
    char	str[len];

    mmux_rlim_sprint(str, len, rlimit_pointer->rlim_max);
    rv = dprintf(fd.value, "%s->rlim_max = %s\n", struct_name, str);
    if (0 > rv) { return true; }
  }

  return false;
}
bool
mmux_libc_getrlimit (mmux_sint_t resource, mmux_libc_rlimit_t * rlimit_p)
{
  mmux_sint_t	rv = getrlimit(resource, rlimit_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_setrlimit (mmux_sint_t resource, mmux_libc_rlimit_t * rlimit_p)
{
  mmux_sint_t	rv = setrlimit(resource, rlimit_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_prlimit (mmux_libc_pid_t pid, mmux_sint_t resource, mmux_libc_rlimit_t * new_rlimit_p, mmux_libc_rlimit_t * old_rlimit_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_PRLIMIT]]],[[[
  int		rv = prlimit(pid.value, resource, new_rlimit_p, old_rlimit_p);

  return ((0 == rv)? false : true);
]]])
}

/* end of file */
