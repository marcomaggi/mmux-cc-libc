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
mmux_libc_make_pid (mmux_libc_pid_t * result_p, mmux_standard_libc_pid_t pid_num)
{
  if (0 <= pid_num) {
    result_p->value = pid_num;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_make_pid_zero (mmux_libc_pid_t * result_p)
{
  result_p->value = 0;
  return false;
}
bool
mmux_libc_make_pid_minus_one (mmux_libc_pid_t * result_p)
{
  result_p->value = -1;
  return false;
}


/** --------------------------------------------------------------------
 ** Process completion--status stucture.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_completed_process_status (mmux_libc_completed_process_status_t * result_p,
					 mmux_standard_sint_t status_num)
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
mmux_libc_completed_process_status_parse (mmux_libc_completed_process_status_t * p_value,
					  mmux_asciizcp_t s_value, mmux_asciizcp_t who)
{
  mmux_libc_completed_process_status_t	the_status;

  if (mmux_sint_parse(&the_status, s_value, who)) {
    return true;
  }
  *p_value = the_status;
  return false;
}
bool
mmux_libc_completed_process_status_sprint (char * ptr, mmux_usize_t len, mmux_libc_completed_process_status_t status)
{
  if (MMUX_LIBC_COMPLETED_PROCESS_STATUS_MAXIMUM_STRING_REPRESENTATION_LENGTH < len.value) {
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  } else {
    return mmux_sint_sprint(ptr, len, mmux_sint(status.value));
  }
}
bool
mmux_libc_completed_process_status_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_completed_process_status_t status)
{
  mmux_usize_t	required_nchars;

  if (mmux_sint_sprint_size(&required_nchars, mmux_sint(status.value))) {
    return true;
  } else {
    *required_nchars_p = required_nchars;
    return false;
  }
}


/** --------------------------------------------------------------------
 ** Identifier functions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_getpid (mmux_libc_pid_t * result_p)
{
  mmux_standard_libc_pid_t	rv = getpid();
  return mmux_libc_make_pid(result_p, rv);
}
bool
mmux_libc_getppid (mmux_libc_pid_t * result_p)
{
  mmux_standard_libc_pid_t	rv = getppid();
  return mmux_libc_make_pid(result_p, rv);
}
bool
mmux_libc_gettid (mmux_libc_pid_t * result_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_GETTID]]],[[[
  mmux_standard_libc_pid_t	rv = gettid();
  return mmux_libc_make_pid(result_p, rv);
]]])
}


/** --------------------------------------------------------------------
 ** Identifier functions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_exit (mmux_libc_process_exit_status_t status)
{
  exit(status.value);
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
mmux_libc__exit (mmux_libc_process_exit_status_t status)
{
  _exit(status.value);
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
  mmux_standard_libc_pid_t	rv = fork();

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
		     mmux_libc_pid_t pid, mmux_sint_t options)
{
  mmux_standard_sint_t		status_num;
  mmux_standard_libc_pid_t	rv = waitpid(pid.value, &status_num, options.value);

  if (-1 == rv) {
    return true;
  } else if ((0 == rv) && (MMUX_LIBC_WNOHANG & options.value)) {
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
  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     pid,
			     options);
}
bool
mmux_libc_wait_group_id (bool * completed_process_status_available_p,
			 mmux_libc_pid_t * completed_process_pid_p,
			 mmux_libc_completed_process_status_t * completed_process_status_p,
			 mmux_libc_gid_t gid, mmux_sint_t options)
{
  auto	pid = (mmux_libc_pid_t){ .value = (- gid.value) };

  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     pid, options);
}
bool
mmux_libc_wait_any_process (bool * completed_process_status_available_p,
			    mmux_libc_pid_t * completed_process_pid_p,
			    mmux_libc_completed_process_status_t * completed_process_status_p,
			    mmux_sint_t options)
{
  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     MMUX_LIBC_WAIT_ANY,
			     options);
}
bool
mmux_libc_wait_my_process_group (bool * completed_process_status_available_p,
				 mmux_libc_pid_t * completed_process_pid_p,
				 mmux_libc_completed_process_status_t * completed_process_status_p,
				 mmux_sint_t options)
{
  return mmux_p_libc_waitpid(completed_process_status_available_p,
			     completed_process_pid_p,
			     completed_process_status_p,
			     MMUX_LIBC_WAIT_MYPGRP,
			     options);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_wait (bool * completed_process_status_available_p,
		mmux_libc_pid_t * completed_process_pid_p,
		mmux_libc_completed_process_status_t * completed_process_status_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_WAIT]]],[[[
  mmux_standard_sint_t		status_num;
  mmux_standard_libc_pid_t	rv = wait(&status_num);

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
  mmux_standard_libc_pid_t	rv = waitid((idtype_t) idtype, pidnum.value, info_p, options);

  if (-1 == rv) {
    return true;
  } else if ((0 == rv) && (MMUX_LIBC_WNOHANG & options.value)) {
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
mmux_libc_WIFEXITED (bool * result_p MMUX_CC_LIBC_UNUSED,
		     mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFEXITED]]],[[[
  *result_p = (WIFEXITED(completed_process_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WEXITSTATUS (mmux_sint_t * result_p MMUX_CC_LIBC_UNUSED,
		       mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WEXITSTATUS]]],[[[
  *result_p = mmux_sint(WEXITSTATUS(completed_process_status.value));
  return false;
]]])
}
bool
mmux_libc_WIFSIGNALED (bool * result_p MMUX_CC_LIBC_UNUSED,
		       mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFSIGNALED]]],[[[
  *result_p = (WIFSIGNALED(completed_process_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WTERMSIG (mmux_libc_interprocess_signal_t * result_p MMUX_CC_LIBC_UNUSED,
		    mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WTERMSIG]]],[[[
  mmux_libc_interprocess_signal_t	ipxsig;

  /* We do  not check this return  value because the  argument is a value  that comes
     from the libc; we assume it is correct. */
  mmux_libc_make_interprocess_signal(&ipxsig, WTERMSIG(completed_process_status.value));
  *result_p = ipxsig;
  return false;
]]])
}
bool
mmux_libc_WCOREDUMP (bool * result_p MMUX_CC_LIBC_UNUSED,
		     mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WCOREDUMP]]],[[[
  *result_p = (WCOREDUMP(completed_process_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WIFSTOPPED (bool * result_p MMUX_CC_LIBC_UNUSED,
		      mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFSTOPPED]]],[[[
  *result_p = (WIFSTOPPED(completed_process_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WSTOPSIG (mmux_libc_interprocess_signal_t * result_p MMUX_CC_LIBC_UNUSED,
		    mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WSTOPSIG]]],[[[
  mmux_libc_interprocess_signal_t	ipxsig;

  /* We do  not check this return  value because the  argument is a value  that comes
     from the libc; we assume it is correct. */
  mmux_libc_make_interprocess_signal(&ipxsig, WSTOPSIG(completed_process_status.value));
  *result_p = ipxsig;
  return false;
]]])
}
bool
mmux_libc_WIFCONTINUED (bool * result_p MMUX_CC_LIBC_UNUSED,
			mmux_libc_completed_process_status_t completed_process_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFCONTINUED]]],[[[
  *result_p = (WIFCONTINUED(completed_process_status.value))? true : false;
  return false;
]]])
}

/* end of file */
