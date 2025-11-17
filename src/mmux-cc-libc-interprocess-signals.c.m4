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

bool
mmux_libc_interprocess_signal_dump (mmux_libc_fd_arg_t fd, mmux_libc_interprocess_signal_t ipxsig)
{
  mmux_asciizcp_t	signame;

m4_define([[[DEFINE_SIGNAL_CASE]]],[[[m4_dnl
#ifdef MMUX_HAVE_LIBC_$1
  case MMUX_LIBC_VALUEOF_$1:
    signame = "$1";
    break;
#endif
]]])

  switch (ipxsig.value) {
    DEFINE_SIGNAL_CASE(SIGFPE)
    DEFINE_SIGNAL_CASE(SIGILL)
    DEFINE_SIGNAL_CASE(SIGSEGV)
    DEFINE_SIGNAL_CASE(SIGBUS)
    DEFINE_SIGNAL_CASE(SIGABRT)
m4_dnl DEFINE_SIGNAL_CASE(SIGIOT) /* duplicate of SIGABRT */
    DEFINE_SIGNAL_CASE(SIGTRAP)
    DEFINE_SIGNAL_CASE(SIGEMT)
    DEFINE_SIGNAL_CASE(SIGSYS)
    DEFINE_SIGNAL_CASE(SIGTERM)
    DEFINE_SIGNAL_CASE(SIGINT)
    DEFINE_SIGNAL_CASE(SIGQUIT)
    DEFINE_SIGNAL_CASE(SIGKILL)
    DEFINE_SIGNAL_CASE(SIGHUP)
    DEFINE_SIGNAL_CASE(SIGALRM)
    DEFINE_SIGNAL_CASE(SIGVRALRM)
    DEFINE_SIGNAL_CASE(SIGPROF)
    DEFINE_SIGNAL_CASE(SIGIO)
    DEFINE_SIGNAL_CASE(SIGURG)
m4_dnl DEFINE_SIGNAL_CASE(SIGPOLL) /* duplicate of SIGIO */
    DEFINE_SIGNAL_CASE(SIGCHLD)
m4_dnl DEFINE_SIGNAL_CASE(SIGCLD) /* duplicate of SIGCHLD */
    DEFINE_SIGNAL_CASE(SIGCONT)
    DEFINE_SIGNAL_CASE(SIGSTOP)
    DEFINE_SIGNAL_CASE(SIGTSTP)
    DEFINE_SIGNAL_CASE(SIGTTIN)
    DEFINE_SIGNAL_CASE(SIGTTOU)
    DEFINE_SIGNAL_CASE(SIGPIPE)
    DEFINE_SIGNAL_CASE(SIGLOST)
    DEFINE_SIGNAL_CASE(SIGXCPU)
    DEFINE_SIGNAL_CASE(SIGXSFZ)
    DEFINE_SIGNAL_CASE(SIGUSR1)
    DEFINE_SIGNAL_CASE(SIGUSR2)
    DEFINE_SIGNAL_CASE(SIGWINCH)
    DEFINE_SIGNAL_CASE(SIGINFO)
    default:
      return true;
  }

  return mmux_libc_dprintf(fd, "%s", signame);
}

bool
mmux_libc_interprocess_signal_parse (mmux_libc_interprocess_signal_t * ipxsig_p,
				     mmux_asciizcp_t input_string, mmux_asciizcp_t who)
{
  if ((! (('S' == input_string[0]) && ('I' == input_string[1]) && ('G' == input_string[2]))) ||
      (4 > strlen(input_string))) {
    goto invalid_input;
  } else {

m4_define([[[DEFINE_SIGNAL_CASE]]],[[[m4_dnl
#ifdef MMUX_HAVE_LIBC_SIG$1
  if (0 == strcmp("$1", (input_string + 3))) {
    *ipxsig_p = MMUX_LIBC_SIG$1;
    return false;
  }
#endif
]]])

    DEFINE_SIGNAL_CASE(FPE);
    DEFINE_SIGNAL_CASE(ILL);
    DEFINE_SIGNAL_CASE(SEGV);
    DEFINE_SIGNAL_CASE(BUS);
    DEFINE_SIGNAL_CASE(ABRT);
    m4_dnl DEFINE_SIGNAL_CASE(IOT); /* duplicate of SIGABRT */
    DEFINE_SIGNAL_CASE(TRAP);
    DEFINE_SIGNAL_CASE(EMT);
    DEFINE_SIGNAL_CASE(SYS);
    DEFINE_SIGNAL_CASE(TERM);
    DEFINE_SIGNAL_CASE(INT);
    DEFINE_SIGNAL_CASE(QUIT);
    DEFINE_SIGNAL_CASE(KILL);
    DEFINE_SIGNAL_CASE(HUP);
    DEFINE_SIGNAL_CASE(ALRM);
    DEFINE_SIGNAL_CASE(VRALRM);
    DEFINE_SIGNAL_CASE(PROF);
    DEFINE_SIGNAL_CASE(IO);
    DEFINE_SIGNAL_CASE(URG);
    m4_dnl DEFINE_SIGNAL_CASE(POLL); /* duplicate of SIGIO */
    DEFINE_SIGNAL_CASE(CHLD);
    m4_dnl DEFINE_SIGNAL_CASE(CLD); /* duplicate of SIGCHLD */
    DEFINE_SIGNAL_CASE(CONT);
    DEFINE_SIGNAL_CASE(STOP);
    DEFINE_SIGNAL_CASE(TSTP);
    DEFINE_SIGNAL_CASE(TTIN);
    DEFINE_SIGNAL_CASE(TTOU);
    DEFINE_SIGNAL_CASE(PIPE);
    DEFINE_SIGNAL_CASE(LOST);
    DEFINE_SIGNAL_CASE(XCPU);
    DEFINE_SIGNAL_CASE(XSFZ);
    DEFINE_SIGNAL_CASE(USR1);
    DEFINE_SIGNAL_CASE(USR2);
    DEFINE_SIGNAL_CASE(WINCH);
    DEFINE_SIGNAL_CASE(INFO);
  }

 invalid_input:
  if (who) {
    MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("%s: error: invalid argument, expected interprocess signal string representation: \"%s\"\n",
						who, input_string));
  }
  return true;
}


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
mmux_libc_retrieve_signal_handler_SIG_DFL (mmux_libc_sighandler_fun_t ** result_p)
{
  *result_p = SIG_DFL;
  return false;
}
bool
mmux_libc_retrieve_signal_handler_SIG_IGN (mmux_libc_sighandler_fun_t ** result_p)
{
  *result_p = SIG_IGN;
  return false;
}
bool
mmux_libc_retrieve_signal_handler_SIG_ERR (mmux_libc_sighandler_fun_t ** result_p)
{
  *result_p = SIG_ERR;
  return false;
}
bool
mmux_libc_signal (mmux_libc_sighandler_fun_t ** result_p,
		  mmux_libc_interprocess_signal_t ipxsignal,
		  mmux_libc_sighandler_fun_t * action)
{
  mmux_libc_sighandler_fun_t *	rv = signal(ipxsignal.value, action);

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


/** --------------------------------------------------------------------
 ** Interprocess signals sets.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sigemptyset (mmux_libc_sigset_t ipxsigset)
{
  sigemptyset(ipxsigset);
  return false;
}
bool
mmux_libc_sigfillset (mmux_libc_sigset_t ipxsigset)
{
  sigfillset(ipxsigset);
  return false;
}
bool
mmux_libc_sigaddset (mmux_libc_sigset_t ipxsigset, mmux_libc_interprocess_signal_t ipxsig)
{
  int	rv = sigaddset(ipxsigset, ipxsig.value);

  return (0 == rv)? false : true;
}
bool
mmux_libc_sigdelset (mmux_libc_sigset_t ipxsigset, mmux_libc_interprocess_signal_t ipxsig)
{
  int	rv = sigdelset(ipxsigset, ipxsig.value);

  return (0 == rv)? false : true;
}
bool
mmux_libc_sigismember (bool * is_member_result_p, mmux_libc_sigset_arg_t ipxsigset, mmux_libc_interprocess_signal_t ipxsig)
{
  int	rv = sigismember(ipxsigset, ipxsig.value);

  if (1 == rv) {
    *is_member_result_p = true;
    return false;
  } else if (0 == rv) {
    *is_member_result_p = false;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_sigisemptyset (bool * is_empty_result_p, mmux_libc_sigset_arg_t ipxsigset)
{
  int	rv = sigisemptyset(ipxsigset);

  *is_empty_result_p = (0 == rv)? false : true;
  return false;
}
bool
mmux_libc_sigandset (mmux_libc_sigset_t ipxsigset_result,
		     mmux_libc_sigset_arg_t ipxsigset1, mmux_libc_sigset_arg_t ipxsigset2)
{
  int	rv = sigandset(ipxsigset_result, ipxsigset1, ipxsigset2);

  return (0 == rv)? false : true;
}
bool
mmux_libc_sigorset (mmux_libc_sigset_t ipxsigset_result,
		     mmux_libc_sigset_arg_t ipxsigset1, mmux_libc_sigset_arg_t ipxsigset2)
{
  int	rv = sigorset(ipxsigset_result, ipxsigset1, ipxsigset2);

  return (0 == rv)? false : true;
}


/** --------------------------------------------------------------------
 ** Interprocess signals blocking mask.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_interprocess_signals_blocking_mask_add_set (mmux_libc_sigset_arg_t ipxsigset,
						      mmux_libc_sigset_t old_blocking_mask)
/* old_blocking_mask can be NULL. */
{
  int	rv = sigprocmask(SIG_BLOCK, ipxsigset, old_blocking_mask);

  return (0 == rv)? false : true;
}
bool
mmux_libc_interprocess_signals_blocking_mask_remove_set (mmux_libc_sigset_arg_t ipxsigset,
							 mmux_libc_sigset_t old_blocking_mask)
/* old_blocking_mask can be NULL. */
{
  int	rv = sigprocmask(SIG_UNBLOCK, ipxsigset, old_blocking_mask);

  return (0 == rv)? false : true;
}
bool
mmux_libc_interprocess_signals_blocking_mask_ref (mmux_libc_sigset_t current_blocking_mask)
/* old_blocking_mask can be NULL. */
{
  int	rv = sigprocmask(SIG_BLOCK /* ignored */, NULL, current_blocking_mask);

  return (0 == rv)? false : true;
}
bool
mmux_libc_interprocess_signals_blocking_mask_set(mmux_libc_sigset_arg_t new_blocking_mask,
						 mmux_libc_sigset_t old_blocking_mask)
/* old_blocking_mask can be NULL. */
{
  int	rv = sigprocmask(SIG_SETMASK, new_blocking_mask, old_blocking_mask);

  return (0 == rv)? false : true;
}


/** --------------------------------------------------------------------
 ** Interprocess signals operations.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sigpending (mmux_libc_sigset_arg_t ipxsigset)
{
  int	rv = sigpending(ipxsigset);

  return (0 == rv)? false : true;
}
bool
mmux_libc_sigsuspend (mmux_libc_sigset_arg_t temporary_blocking_mask)
{
  int	rv = sigsuspend(temporary_blocking_mask);

  return (0 == rv)? false : true;
}


/** --------------------------------------------------------------------
 ** Interprocess signals actions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sa_handler_ref (mmux_libc_sighandler_fun_t * * result_p, mmux_libc_sigaction_arg_t action)
{
  *result_p = action->sa_handler;
  return false;
}
bool
mmux_libc_sa_handler_set (mmux_libc_sigaction_t action, mmux_libc_sighandler_fun_t * handler)
{
  action->sa_handler = handler;
  return false;
}

typedef void true_mmux_libc_sigaction_fun_t  (int signum, siginfo_t * info, mmux_pointer_t context);

bool
mmux_libc_sa_sigaction_ref (mmux_libc_sigaction_fun_t * * result_p, mmux_libc_sigaction_arg_t action)
{
  *result_p = (mmux_libc_sigaction_fun_t *)action->sa_sigaction;
  return false;
}
bool
mmux_libc_sa_sigaction_set (mmux_libc_sigaction_t action, mmux_libc_sigaction_fun_t * handler)
{
  action->sa_sigaction = (true_mmux_libc_sigaction_fun_t *)handler;
  return false;
}

bool
mmux_libc_sa_mask_ref (mmux_libc_sigset_t ipxsigset, mmux_libc_sigaction_arg_t action)
{
  sigemptyset(ipxsigset);
  sigorset(ipxsigset, ipxsigset, &(action->sa_mask));
  return false;
}
bool
mmux_libc_sa_mask_set (mmux_libc_sigaction_t action, mmux_libc_sigset_arg_t ipxsigset)
{
  sigemptyset(&(action->sa_mask));
  sigorset(&(action->sa_mask), ipxsigset, ipxsigset);
  return false;
}

bool
mmux_libc_sa_flags_ref (mmux_libc_sigaction_flags_t * result_p, mmux_libc_sigaction_arg_t action)
{
  *result_p = mmux_libc_sigaction_flags(action->sa_flags);
  return false;
}
bool
mmux_libc_sa_flags_set (mmux_libc_sigaction_t action, mmux_libc_sigaction_flags_t flags)
{
  action->sa_flags = flags.value;
  return false;
}

bool
mmux_libc_sigaction (mmux_libc_interprocess_signal_t ipxsig,
		     mmux_libc_sigaction_arg_t new_action,
		     mmux_libc_sigaction_t old_action)
{
  int	rv = sigaction(ipxsig.value, new_action, old_action);

  return (0 == rv)? false : true;
}


/** --------------------------------------------------------------------
 ** Data structure siginfo_t.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_SIGINFO_SETTER_GETTER]]],[[[bool
mmux_libc_$1_ref ($2 * field_value_result_p, mmux_libc_siginfo_arg_t self)
{
  *field_value_result_p = $3(self->$1);
  return false;
}
bool
mmux_libc_$1_set (mmux_libc_siginfo_t self, $2 new_field_value)
{
  self->$1 = mmux_ctype_value(new_field_value);
  return false;
}]]])

m4_define([[[DEFINE_SIGINFO_SETTER_GETTER_PTR]]],[[[bool
mmux_libc_$1_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
{
  *field_value_result_p = mmux_pointer(self->$1);
  return false;
}
bool
mmux_libc_$1_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
{
  self->$1 = new_field_value;
  return false;
}]]])

m4_define([[[DEFINE_SIGINFO_SETTER_GETTER_SINT]]],[[[DEFINE_SIGINFO_SETTER_GETTER($1,mmux_sint_t,mmux_sint)]]])
m4_define([[[DEFINE_SIGINFO_SETTER_GETTER_UINT]]],[[[DEFINE_SIGINFO_SETTER_GETTER($1,mmux_uint_t,mmux_uint)]]])

DEFINE_SIGINFO_SETTER_GETTER_SINT(si_signo)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_errno)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_code)
m4_dnl DEFINE_SIGINFO_SETTER_GETTER_SINT(si_trapno)
DEFINE_SIGINFO_SETTER_GETTER(si_pid,			mmux_libc_pid_t,	mmux_libc_pid)
DEFINE_SIGINFO_SETTER_GETTER(si_uid,			mmux_libc_uid_t,	mmux_libc_uid)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_status)
DEFINE_SIGINFO_SETTER_GETTER(si_utime,			mmux_clock_t,		mmux_clock)
DEFINE_SIGINFO_SETTER_GETTER(si_stime,			mmux_clock_t,		mmux_clock)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_int)
DEFINE_SIGINFO_SETTER_GETTER_PTR(si_ptr)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_overrun)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_timerid)
DEFINE_SIGINFO_SETTER_GETTER_PTR(si_addr)
DEFINE_SIGINFO_SETTER_GETTER(si_band,			mmux_slong_t,		mmux_slong)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_fd)
DEFINE_SIGINFO_SETTER_GETTER(si_addr_lsb,		mmux_sshort_t,		mmux_sshort)
DEFINE_SIGINFO_SETTER_GETTER_PTR(si_lower)
DEFINE_SIGINFO_SETTER_GETTER_PTR(si_upper)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_pkey)
DEFINE_SIGINFO_SETTER_GETTER_PTR(si_call_addr)
DEFINE_SIGINFO_SETTER_GETTER_SINT(si_syscall)
DEFINE_SIGINFO_SETTER_GETTER_UINT(si_arch)

bool
mmux_libc_si_value_sival_int_ref (mmux_sint_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
{
  *field_value_result_p = mmux_sint(self->si_value.sival_int);
  return false;
}
bool
mmux_libc_si_value_sival_int_set (mmux_libc_siginfo_t self, mmux_sint_t new_field_value)
{
  self->si_value.sival_int = mmux_ctype_value(new_field_value);
  return false;
}
bool
mmux_libc_si_value_sival_ptr_ref (mmux_pointer_t * field_value_result_p, mmux_libc_siginfo_arg_t self)
{
  *field_value_result_p = mmux_pointer(self->si_value.sival_ptr);
  return false;
}
bool
mmux_libc_si_value_sival_ptr_set (mmux_libc_siginfo_t self, mmux_pointer_t new_field_value)
{
  self->si_value.sival_ptr = new_field_value;
  return false;
}


/** --------------------------------------------------------------------
 ** Data union sigval.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sival_int_ref (mmux_sint_t * field_value_result_p, mmux_libc_sigval_arg_t self)
{
  *field_value_result_p = mmux_sint(self->sival_int);
  return false;
}
bool
mmux_libc_sival_int_set (mmux_libc_sigval_t self, mmux_sint_t new_field_value)
{
  self->sival_int = mmux_ctype_value(new_field_value);
  return false;
}

bool
mmux_libc_sival_ptr_ref (mmux_pointer_t * field_value_result_p, mmux_libc_sigval_arg_t self)
{
  *field_value_result_p = mmux_pointer(self->sival_ptr);
  return false;
}
bool
mmux_libc_sival_ptr_set (mmux_libc_sigval_t self, mmux_pointer_t new_field_value)
{
  self->sival_ptr = new_field_value;
  return false;
}

bool
mmux_libc_sigqueue (mmux_libc_pid_t pid, mmux_libc_interprocess_signal_t ipxsig, mmux_libc_sigval_arg_t the_val)
{
  int	rv = sigqueue(pid.value, ipxsig.value, *((const union sigval *)the_val));

  return (0 == rv)? false : true;
}

/* end of file */
