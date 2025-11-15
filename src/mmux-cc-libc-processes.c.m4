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
mmux_libc_make_process_completion_status (mmux_libc_process_completion_status_t * result_p,
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
mmux_libc_process_completion_status_equal (bool * result_p,
					   mmux_libc_process_completion_status_t one,
					   mmux_libc_process_completion_status_t two)
{
  return mmux_sint_equal_p(result_p, &one, &two);
}
bool
mmux_libc_process_completion_status_not_equal (bool * result_p,
					       mmux_libc_process_completion_status_t one,
					       mmux_libc_process_completion_status_t two)
{
  return mmux_sint_not_equal_p(result_p, &one, &two);
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
mmux_libc_make_process_exit_status (mmux_libc_process_exit_status_t * status_p,
				    mmux_standard_sint_t exit_status_num)
{
  *status_p = mmux_libc_process_exit_status(exit_status_num);
  return false;
}

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
mmux_p_libc_waitpid (bool * process_completion_status_available_p,
		     mmux_libc_process_completion_status_t * process_completion_status_p,
		     mmux_libc_pid_t * completed_process_pid_p,
		     mmux_libc_pid_t pid,
		     mmux_libc_process_completion_waiting_options_t wait_options)
{
  mmux_standard_sint_t		status_num;
  mmux_standard_libc_pid_t	rv = waitpid(pid.value, &status_num, wait_options.value);

  if (-1 == rv) {
    return true;
  } else if ((0 == rv) && (MMUX_LIBC_WNOHANG & wait_options.value)) {
    /* We requested not to block if no process  has completed.  It is not an error if
       we are here. */
    *process_completion_status_available_p = false;
    return false;
  } else {
    if (mmux_libc_make_pid(completed_process_pid_p, rv)) {
      return true;
    } else {
      *process_completion_status_available_p	= true;
      return mmux_libc_make_process_completion_status(process_completion_status_p, status_num);
    }
  }
}
bool
mmux_libc_wait_process_id (bool * process_completion_status_available_p,
			   mmux_libc_process_completion_status_t * process_completion_status_p,
			   mmux_libc_pid_t * completed_process_pid_p,
			   mmux_libc_pid_t pid,
			   mmux_libc_process_completion_waiting_options_t wait_options)
{
  return mmux_p_libc_waitpid(process_completion_status_available_p,
			     process_completion_status_p,
			     completed_process_pid_p,
			     pid,
			     wait_options);
}
bool
mmux_libc_wait_group_id (bool * process_completion_status_available_p,
			 mmux_libc_process_completion_status_t * process_completion_status_p,
			 mmux_libc_pid_t * completed_process_pid_p,
			 mmux_libc_gid_t gid,
			 mmux_libc_process_completion_waiting_options_t wait_options)
{
  auto	pid = (mmux_libc_pid_t){ .value = (- gid.value) };

  return mmux_p_libc_waitpid(process_completion_status_available_p,
			     process_completion_status_p,
			     completed_process_pid_p,
			     pid, wait_options);
}
bool
mmux_libc_wait_any_process (bool * process_completion_status_available_p,
			    mmux_libc_process_completion_status_t * process_completion_status_p,
			    mmux_libc_pid_t * completed_process_pid_p,
			    mmux_libc_process_completion_waiting_options_t wait_options)
{
  return mmux_p_libc_waitpid(process_completion_status_available_p,
			     process_completion_status_p,
			     completed_process_pid_p,
			     MMUX_LIBC_WAIT_ANY,
			     wait_options);
}
bool
mmux_libc_wait_my_process_group (bool * process_completion_status_available_p,
				 mmux_libc_process_completion_status_t * process_completion_status_p,
				 mmux_libc_pid_t * completed_process_pid_p,
				 mmux_libc_process_completion_waiting_options_t wait_options)
{
  return mmux_p_libc_waitpid(process_completion_status_available_p,
			     process_completion_status_p,
			     completed_process_pid_p,
			     MMUX_LIBC_WAIT_MYPGRP,
			     wait_options);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_wait (bool * process_completion_status_available_p,
		mmux_libc_process_completion_status_t * process_completion_status_p,
		mmux_libc_pid_t * completed_process_pid_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_WAIT]]],[[[
  mmux_standard_sint_t		status_num;
  mmux_standard_libc_pid_t	rv = wait(&status_num);

  if (-1 == rv) {
    return true;
  } else if (0 == rv) {
    /* We requested not to block if no process  has completed.  It is not an error if
       we are here. */
    *process_completion_status_available_p = false;
    return false;
  } else {
    if (mmux_libc_make_pid(completed_process_pid_p, rv)) {
      return true;
    } else {
      *process_completion_status_available_p	= true;
      return mmux_libc_make_process_completion_status(process_completion_status_p, status_num);
    }
  }
]]])
}

/* Someday I will implement this.  But not today.  (Marco Maggi; Jun 25, 2025) */
#if 0
bool
mmux_libc_waitid (bool * process_completion_status_available_p,
		  mmux_libc_process_completion_status_t * process_completion_status_p,
		  mmux_libc_pid_t * completed_process_pid_p,
		  mmux_sint_t idtype, mmux_libc_pid_t pid, mmux_libc_siginfo_t * info_p,
		  mmux_libc_process_completion_waiting_options_t wait_options)
{
  mmux_standard_libc_pid_t	rv = waitid((idtype_t) idtype, pidnum.value, info_p, options);

  if (-1 == rv) {
    return true;
  } else if ((0 == rv) && (MMUX_LIBC_WNOHANG & options.value)) {
    /* We requested not to block if no process  has completed.  It is not an error if
       we are here. */
    *process_completion_status_available_p = false;
    return false;
  } else {
    if (mmux_libc_make_pid(completed_process_pid_p, rv)) {
      return true;
    } else {
      *process_completion_status_available_p	= true;
      return mmux_libc_make_process_completion_status(process_completion_status_p, status_num);
    }
  }
}
#endif


/** --------------------------------------------------------------------
 ** Querying the completed process status.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_WIFEXITED (bool * result_p MMUX_CC_LIBC_UNUSED,
		     mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFEXITED]]],[[[
  *result_p = (WIFEXITED(process_completion_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WEXITSTATUS (mmux_libc_process_exit_status_t * exit_status_result_p MMUX_CC_LIBC_UNUSED,
		       mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WEXITSTATUS]]],[[[
  *exit_status_result_p = mmux_libc_process_exit_status(WEXITSTATUS(process_completion_status.value));
  return false;
]]])
}
bool
mmux_libc_WIFSIGNALED (bool * result_p MMUX_CC_LIBC_UNUSED,
		       mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFSIGNALED]]],[[[
  *result_p = (WIFSIGNALED(process_completion_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WTERMSIG (mmux_libc_interprocess_signal_t * result_p MMUX_CC_LIBC_UNUSED,
		    mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WTERMSIG]]],[[[
  *result_p = mmux_libc_interprocess_signal(WTERMSIG(process_completion_status.value));
  return false;
]]])
}
bool
mmux_libc_WCOREDUMP (bool * result_p MMUX_CC_LIBC_UNUSED,
		     mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WCOREDUMP]]],[[[
  *result_p = (WCOREDUMP(process_completion_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WIFSTOPPED (bool * result_p MMUX_CC_LIBC_UNUSED,
		      mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFSTOPPED]]],[[[
  *result_p = (WIFSTOPPED(process_completion_status.value))? true : false;
  return false;
]]])
}
bool
mmux_libc_WSTOPSIG (mmux_libc_interprocess_signal_t * result_p MMUX_CC_LIBC_UNUSED,
		    mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WSTOPSIG]]],[[[
  *result_p = mmux_libc_interprocess_signal(WSTOPSIG(process_completion_status.value));
  return false;
]]])
}
bool
mmux_libc_WIFCONTINUED (bool * result_p MMUX_CC_LIBC_UNUSED,
			mmux_libc_process_completion_status_t process_completion_status MMUX_CC_LIBC_UNUSED)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[MMUX_LIBC_HAVE_WIFCONTINUED]]],[[[
  *result_p = (WIFCONTINUED(process_completion_status.value))? true : false;
  return false;
]]])
}

/* end of file */
