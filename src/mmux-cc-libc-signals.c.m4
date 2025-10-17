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
 ** Interprocess signal stucture.
 ** ----------------------------------------------------------------- */


/** --------------------------------------------------------------------
 ** Delivering signals.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_raise (mmux_libc_interprocess_signal_t ipxsignal)
{
  mmux_standard_sint_t	rv = raise(ipxsignal.value);

  if (rv) {
    return true;
  } else {
    return false;
  }
}

/* ------------------------------------------------------------------ */

static bool
mmux_p_libc_kill (mmux_standard_sint_t pidnum, mmux_libc_interprocess_signal_t ipxsignal)
{
  mmux_standard_sint_t	rv = kill(pidnum, ipxsignal.value);

  if (-1 == rv) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_kill (mmux_libc_pid_t pid, mmux_libc_interprocess_signal_t ipxsignal)
{
  return mmux_p_libc_kill(pid.value, ipxsignal);
}
bool
mmux_libc_kill_all_processes_in_same_group (mmux_libc_interprocess_signal_t ipxsignal)
{
  return mmux_p_libc_kill(0, ipxsignal);
}
bool
mmux_libc_kill_group (mmux_libc_gid_t gid, mmux_libc_interprocess_signal_t ipxsignal)
{
  return mmux_p_libc_kill(- gid.value, ipxsignal);
}
bool
mmux_libc_kill_all_processes (mmux_libc_interprocess_signal_t ipxsignal)
{
  return mmux_p_libc_kill(-1, ipxsignal);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_tgkill (mmux_libc_pid_t pid, mmux_libc_pid_t tid, mmux_libc_interprocess_signal_t ipxsignal)
/* This is Linux-specific. */
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_TGKILL]]],[[[
  mmux_standard_sint_t	rv = tgkill(pid.value, tid.value, ipxsignal.value);

  if (-1 == rv) {
    return true;
  } else {
    return false;
  }
]]])
}


/** --------------------------------------------------------------------
 ** Block/unblock interprocess signals.
 ** ----------------------------------------------------------------- */

#if ((defined HAVE_SIGFILLSET) && (defined HAVE_SIGPROCMASK) && (defined HAVE_SIGACTION))
static int	mmux_libc_arrived_signals[NSIG];
static sigset_t	mmux_libc_all_signals_set;
static void
mmux_libc_signal_bub_handler (int signum)
{
  ++(mmux_libc_arrived_signals[signum]);
}
#endif

bool
mmux_libc_interprocess_signals_bub_init (void)
/* Block all the signals and register our handler for each. */
{
#if ((defined HAVE_SIGFILLSET) && (defined HAVE_SIGPROCMASK) && (defined HAVE_SIGACTION))
  struct sigaction	ac = {
    .sa_handler	= mmux_libc_signal_bub_handler,
    .sa_flags	= SA_RESTART | SA_NOCLDSTOP
  };
  int	signum;
  sigfillset(&mmux_libc_all_signals_set);
  sigprocmask(SIG_BLOCK, &mmux_libc_all_signals_set, NULL);
  for (signum=0; signum<NSIG; ++signum) {
    mmux_libc_arrived_signals[signum] = 0;
    sigaction(signum, &ac, NULL);
  }
  return false;
#else
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
#endif
}
bool
mmux_libc_interprocess_signals_bub_final (void)
/* Set all the handlers to SIG_IGN, then unblock the signals. */
{
#if ((defined HAVE_SIGFILLSET) && (defined HAVE_SIGPROCMASK) && (defined HAVE_SIGACTION))
  struct sigaction	ac = {
    .sa_handler	= SIG_IGN,
    .sa_flags	= SA_RESTART
  };
  int	signum;
  for (signum=0; signum<NSIG; ++signum) {
    mmux_libc_arrived_signals[signum] = 0;
    sigaction(signum, &ac, NULL);
  }
  sigprocmask(SIG_UNBLOCK, &mmux_libc_all_signals_set, NULL);
  return false;
#else
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
#endif
}
bool
mmux_libc_interprocess_signals_bub_acquire (void)
/* Unblock  then  block  all  the  signals.    This  causes  blocked  signals  to  be
   delivered. */
{
#if ((defined HAVE_SIGFILLSET) && (defined HAVE_SIGPROCMASK) && (defined HAVE_SIGACTION))
  sigprocmask(SIG_UNBLOCK, &mmux_libc_all_signals_set, NULL);
  sigprocmask(SIG_BLOCK,   &mmux_libc_all_signals_set, NULL);
  return false;
#else
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
#endif
}
bool
mmux_libc_interprocess_signals_bub_delivered (bool * result_p, mmux_libc_interprocess_signal_t ipxsignal)
/* Set result to true if the signal  IPXSIGNAL has been delivered at least once since
   the last call to "mmux_libc_interprocess_signals_bub_acquire()".  Clear the signal
   flag. */
{
#if ((defined HAVE_SIGFILLSET) && (defined HAVE_SIGPROCMASK) && (defined HAVE_SIGACTION))
  int	signum = ipxsignal.value;
  int	is_set = mmux_libc_arrived_signals[signum];
  mmux_libc_arrived_signals[signum] = 0;
  *result_p = (is_set)? true : false;
  return false;
#else
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
#endif
}


/** --------------------------------------------------------------------
 ** Other interprocess signals handling methods.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_retrieve_signal_handler_SIG_DFL (mmux_libc_sighandler_t ** result_p)
{
  *result_p = SIG_DFL;
  return false;
}
bool
mmux_libc_retrieve_signal_handler_SIG_IGN (mmux_libc_sighandler_t ** result_p)
{
  *result_p = SIG_IGN;
  return false;
}
bool
mmux_libc_retrieve_signal_handler_SIG_ERR (mmux_libc_sighandler_t ** result_p)
{
  *result_p = SIG_ERR;
  return false;
}
bool
mmux_libc_signal (mmux_libc_sighandler_t ** result_p, mmux_libc_interprocess_signal_t ipxsignal, mmux_libc_sighandler_t action)
{
  mmux_libc_sighandler_t *	rv = signal(ipxsignal.value, action);

  if (SIG_ERR == rv) {
    return true;
  } else {
    *result_p = rv;
    return false;
  }
}
bool
mmux_libc_pause (void)
{
  mmux_standard_sint_t	rv = pause();

  if (-1 == rv) {
    return true;
  } else {
    return false;
  }
}

/* end of file */
