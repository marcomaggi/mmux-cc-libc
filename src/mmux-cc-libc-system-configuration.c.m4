/*
  Part of: MMUX CC Libc
  Contents: system configuration
  Date: Dec 12, 2024

  Abstract

	This module implements the system configuration API.

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
 ** System configuration parameters.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sysconf (mmux_slong_t * value_p, mmux_libc_sysconf_parameter_t parameter)
{
  mmux_slong_t	value;

  errno = 0;
  value.value = sysconf(parameter.value);
  if (-1 == value.value) {
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
mmux_libc_confstr_size (mmux_usize_t * required_nbytes_p, mmux_libc_sysconf_string_parameter_t parameter)
{
  auto	required_nbytes = mmux_usize(confstr(parameter.value, NULL, 0));

  if (0 == required_nbytes.value) {
    return true;
  } else {
    *required_nbytes_p = required_nbytes;
    return false;
  }
}
bool
mmux_libc_confstr (mmux_asciizp_t result_bufptr, mmux_usize_t provided_nbytes, mmux_libc_sysconf_string_parameter_t parameter)
{
  auto	required_nbytes = mmux_usize(confstr(parameter.value, result_bufptr, provided_nbytes.value));

  return ((0 == required_nbytes.value)? true : false);
}
bool
mmux_libc_pathconf (mmux_slong_t * result_p, mmux_libc_file_system_pathname_t pathname,
		    mmux_libc_sysconf_pathname_parameter_t parameter)
{
  mmux_slong_t	result;

  errno = 0;
  result = mmux_slong(pathconf(pathname.value, parameter.value));
  if (-1 == result.value) {
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
mmux_libc_fpathconf (mmux_slong_t * result_p, mmux_libc_fd_arg_t fd,
		     mmux_libc_sysconf_pathname_parameter_t parameter)
{
  mmux_slong_t	result;

  errno = 0;
  result.value = fpathconf(fd->value, parameter.value);
  if (-1 == result.value) {
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

DEFINE_STRUCT_SETTER_GETTER(rlimit,	rlim_cur,	libc_rlim)
DEFINE_STRUCT_SETTER_GETTER(rlimit,	rlim_max,	libc_rlim)

bool
mmux_libc_rlimit_dump (mmux_libc_fd_arg_t fd, mmux_libc_rlimit_t * rlimit_pointer, char const * struct_name)
{
  int	rv;

  if (NULL == struct_name) {
    struct_name = "struct rlimit";
  }

  {
    rv = dprintf(fd->value, "%s = %p\n", struct_name, (mmux_pointer_t)rlimit_pointer);
    if (0 > rv) { return true; }
  }

  {
    mmux_libc_rlim_t	field_value;
    mmux_usize_t	required_nbytes;

    mmux_libc_rlim_cur_ref(&field_value, rlimit_pointer);
    if (mmux_libc_rlim_sprint_size(&required_nbytes, field_value)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_libc_rlim_sprint(str, required_nbytes, field_value)) {
	return true;
      } else {
	rv = dprintf(fd->value, "%s->rlim_cur = %s\n", struct_name, str);
	if (0 > rv) { return true; }
      }
    }
  }

  {
    mmux_libc_rlim_t	field_value;
    mmux_usize_t	required_nbytes;

    mmux_libc_rlim_max_ref(&field_value, rlimit_pointer);
    if (mmux_libc_rlim_sprint_size(&required_nbytes, field_value)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_libc_rlim_sprint(str, required_nbytes, field_value)) {
	return true;
      } else {
	rv = dprintf(fd->value, "%s->rlim_max = %s\n", struct_name, str);
	if (0 > rv) { return true; }
      }
    }
  }
  return false;
}
bool
mmux_libc_getrlimit (mmux_sint_t resource, mmux_libc_rlimit_t * rlimit_p)
{
  int	rv = getrlimit(resource.value, rlimit_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_setrlimit (mmux_sint_t resource, mmux_libc_rlimit_t * rlimit_p)
{
  int	rv = setrlimit(resource.value, rlimit_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_prlimit (mmux_libc_pid_t pid, mmux_sint_t resource, mmux_libc_rlimit_t * new_rlimit_p, mmux_libc_rlimit_t * old_rlimit_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_PRLIMIT]]],[[[
  int	rv = prlimit(pid.value, resource.value, new_rlimit_p, old_rlimit_p);

  return ((0 == rv)? false : true);
]]])
}

/* end of file */
