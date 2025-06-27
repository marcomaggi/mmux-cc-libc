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
 ** Process identifier stucture.
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
bool
mmux_libc_pid_equal (mmux_libc_pid_t one, mmux_libc_pid_t two)
{
  if (one.value == two.value) {
    return true;
  } else {
    return false;
  }
}
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


/** --------------------------------------------------------------------
 ** Process completion--status stucture.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_completed_process_status (mmux_libc_completed_process_status_t * result_p, mmux_sint_t status_num)
{
  if (0 <= status_num) {
    result_p->value = status_num;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_completed_process_status_equal (mmux_libc_completed_process_status_t one, mmux_libc_completed_process_status_t two)
{
  if (one.value == two.value) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_completed_process_status_parse (mmux_libc_completed_process_status_t * p_value, char const * s_value, char const * who)
{
  mmux_libc_completed_process_status_t	the_status;

  if (mmux_sint_parse(&the_status.value, s_value, who)) {
    return true;
  }
  *p_value = the_status;
  return false;
}
bool
mmux_libc_completed_process_status_sprint (char * ptr, mmux_usize_t len, mmux_libc_completed_process_status_t status)
{
  if (MMUX_LIBC_COMPLETED_PROCESS_STATUS_MAXIMUM_STRING_REPRESENTATION_LENGTH < len) {
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
  return mmux_sint_sprint(ptr, len, status.value);
}
bool
mmux_libc_completed_process_status_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_completed_process_status_t status)
{
  mmux_sint_t	required_nchars = mmux_sint_sprint_size(status.value);

  if (0 <= required_nchars) {
    *required_nchars_p = required_nchars;
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Identifier functions.
 ** ----------------------------------------------------------------- */

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
}
bool
mmux_libc_exit_success (void)
{
  mmux_libc_exit(MMUX_LIBC_EXIT_SUCCESS);
}
bool
mmux_libc_exit_failure (void)
{
  mmux_libc_exit(MMUX_LIBC_EXIT_FAILURE);
}
bool
mmux_libc__exit (mmux_sint_t status)
{
  _exit(status);
}
bool
mmux_libc_atexit (void (*function_pointer) (void))
{
  atexit(function_pointer);
  return false;
}
bool
mmux_libc_abort (void)
{
  abort();
}


/** --------------------------------------------------------------------
 ** Forking processes.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_fork (bool * this_is_the_parent_process_p, mmux_libc_pid_t * child_process_pid_p)
{
  mmux_pid_t	rv;

  rv = fork();
  if (-1 == rv) {
    return true;
  } else {
    if (rv) {
      if (mmux_libc_make_pid(child_process_pid_p, rv)) {
	return true;
      } else {
	*this_is_the_parent_process_p = true;
      }
    } else {
      *this_is_the_parent_process_p = false;
    }
    return false;
  }
}


/** --------------------------------------------------------------------
 ** Waiting for process completion.
 ** ----------------------------------------------------------------- */

static bool
mmux_p_libc_waitpid (bool * completed_process_status_available_p,
		     mmux_libc_pid_t * completed_process_pid_p,
		     mmux_libc_completed_process_status_t * completed_process_status_p,
		     mmux_pid_t pidnum, mmux_sint_t options)
{
  mmux_sint_t	status_num;
  mmux_pid_t	rv = waitpid(pidnum, &status_num, options);

  if (-1 == rv) {
    return true;
  } else if ((0 == rv) && (MMUX_LIBC_WNOHANG & options)) {
    /* We requested not to block if no process  has completed.  It is not an error if
       we are here. */
    *completed_process_status_available_p = false;
    return false;
  } else {
    if (mmux_libc_make_pid(completed_process_pid_p, rv)) {
      return true;
    } else {
      *completed_process_status_available_p	= true;
      return mmux_libc_make_completed_process_status(completed_process_status_p, status_num);
    }
  }
}
bool
mmux_libc_wait_process_id (bool * completed_process_status_available_p,
			   mmux_libc_pid_t * completed_process_pid_p,
			   mmux_libc_completed_process_status_t * completed_process_status_p,
			   mmux_libc_pid_t pid, mmux_sint_t options)
{
  mmux_pid_t	pidnum		= pid.value;

  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     pidnum,
			     options);
}
bool
mmux_libc_wait_group_id (bool * completed_process_status_available_p,
			 mmux_libc_pid_t * completed_process_pid_p,
			 mmux_libc_completed_process_status_t * completed_process_status_p,
			 mmux_libc_gid_t gid, mmux_sint_t options)
{
  mmux_pid_t	pidnum		= (mmux_pid_t)(- gid.value);

  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     pidnum,
			     options);
}
bool
mmux_libc_wait_any_process (bool * completed_process_status_available_p,
			    mmux_libc_pid_t * completed_process_pid_p,
			    mmux_libc_completed_process_status_t * completed_process_status_p,
			    mmux_sint_t options)
{
  mmux_pid_t	pidnum		= MMUX_LIBC_WAIT_ANY;

  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     pidnum,
			     options);
}
bool
mmux_libc_wait_my_process_group (bool * completed_process_status_available_p,
				 mmux_libc_pid_t * completed_process_pid_p,
				 mmux_libc_completed_process_status_t * completed_process_status_p,
				 mmux_sint_t options)
{
  mmux_pid_t	pidnum		= MMUX_LIBC_WAIT_MYPGRP;

  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     pidnum,
			     options);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_wait (bool * completed_process_status_available_p,
		mmux_libc_pid_t * completed_process_pid_p,
		mmux_libc_completed_process_status_t * completed_process_status_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_WAIT]]],[[[
  mmux_sint_t	status_num;
  mmux_pid_t	rv = wait(&status_num);

  if (-1 == rv) {
    return true;
  } else if (0 == rv) {
    /* We requested not to block if no process  has completed.  It is not an error if
       we are here. */
    *completed_process_status_available_p = false;
    return false;
  } else {
    if (mmux_libc_make_pid(completed_process_pid_p, rv)) {
      return true;
    } else {
      *completed_process_status_available_p	= true;
      return mmux_libc_make_completed_process_status(completed_process_status_p, status_num);
    }
  }
]]])
}

/* Someday I will implement this.  But not today.  (Marco Maggi; Jun 25, 2025) */
#if 0
bool
mmux_libc_waitid (bool * completed_process_status_available_p,
		  mmux_libc_pid_t * completed_process_pid_p,
		  mmux_libc_completed_process_status_t * completed_process_status_p,
		  mmux_sint_t idtype, mmux_libc_pid_t pid, mmux_libc_siginfo_t * info_p, mmux_sint_t options)
{
  mmux_pid_t	rv = waitid((idtype_t) idtype, pidnum.value, info_p, options);

  if (-1 == rv) {
    return true;
  } else if ((0 == rv) && (MMUX_LIBC_WNOHANG & options)) {
    /* We requested not to block if no process  has completed.  It is not an error if
       we are here. */
    *completed_process_status_available_p = false;
    return false;
  } else {
    if (mmux_libc_make_pid(completed_process_pid_p, rv)) {
      return true;
    } else {
      *completed_process_status_available_p	= true;
      return mmux_libc_make_completed_process_status(completed_process_status_p, status_num);
    }
  }
}
#endif


/** --------------------------------------------------------------------
 ** Querying the completed process status.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_WIFEXITED (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFEXITED]]],[[[
  return (WIFEXITED(completed_process_status.value))? true : false;
]]])
}
mmux_sint_t
mmux_libc_WEXITSTATUS (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WEXITSTATUS]]],[[[
  return WEXITSTATUS(completed_process_status.value);
]]])
}
bool
mmux_libc_WIFSIGNALED (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFSIGNALED]]],[[[
  return (WIFSIGNALED(completed_process_status.value))? true : false;
]]])
}
mmux_libc_interprocess_signal_t
mmux_libc_WTERMSIG (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WTERMSIG]]],[[[
  mmux_libc_interprocess_signal_t	ipxsig;

  /* We do  not check this return  value because the  argument is a value  that comes
     from the libc; we assume it is correct. */
  mmux_libc_make_interprocess_signal(&ipxsig, WTERMSIG(completed_process_status.value));
  return ipxsig;
]]])
}
bool
mmux_libc_WCOREDUMP (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WCOREDUMP]]],[[[
  return (WCOREDUMP(completed_process_status.value))? true : false;
]]])
}
bool
mmux_libc_WIFSTOPPED (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFSTOPPED]]],[[[
  return (WIFSTOPPED(completed_process_status.value))? true : false;
]]])
}
mmux_libc_interprocess_signal_t
mmux_libc_WSTOPSIG (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WSTOPSIG]]],[[[
  mmux_libc_interprocess_signal_t	ipxsig;

  /* We do  not check this return  value because the  argument is a value  that comes
     from the libc; we assume it is correct. */
  mmux_libc_make_interprocess_signal(&ipxsig, WSTOPSIG(completed_process_status.value));
  return ipxsig;
]]])
}
bool
mmux_libc_WIFCONTINUED (mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFCONTINUED]]],[[[
  return (WIFCONTINUED(completed_process_status.value))? true : false;
]]])
}

/* end of file */
