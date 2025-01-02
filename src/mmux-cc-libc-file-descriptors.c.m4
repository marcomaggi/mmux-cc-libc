/*
  Part of: MMUX CC Libc
  Contents: file descriptor functions
  Date: Dec  8, 2024

  Abstract

	This module implements file descriptor functions.

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

#define DPRINTF(TEMPLATE,...)	if (mmux_libc_dprintf(TEMPLATE,__VA_ARGS__)) { return true; }


/** --------------------------------------------------------------------
 ** Input/output: file descriptor core API.
 ** ----------------------------------------------------------------- */

static const mmux_libc_file_descriptor_t stdin_fd = { .value = 0 };
static const mmux_libc_file_descriptor_t stdou_fd = { .value = 1 };
static const mmux_libc_file_descriptor_t stder_fd = { .value = 2 };
static const mmux_libc_file_descriptor_t at_fdcwd_fd = { .value = mmux_libc_VALUEOF_AT_FDCWD };

bool
mmux_libc_stdin (mmux_libc_file_descriptor_t * result_p)
{
  *result_p = stdin_fd;
  return false;
}
bool
mmux_libc_stdou (mmux_libc_file_descriptor_t * result_p)
{
  *result_p = stdou_fd;
  return false;
}
bool
mmux_libc_stder (mmux_libc_file_descriptor_t * result_p)
{
  *result_p = stder_fd;
  return false;
}
bool
mmux_libc_at_fdcwd (mmux_libc_file_descriptor_t * result_p)
{
  *result_p = at_fdcwd_fd;
  return false;
}
bool
mmux_libc_make_fd (mmux_libc_file_descriptor_t * result_p, mmux_sint_t fd_num)
{
  result_p->value = fd_num;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_fd_parse (mmux_libc_fd_t * p_value, char const * s_value, char const * who)
{
  mmux_libc_fd_t	the_fd;

  if (mmux_sint_parse(&the_fd.value, s_value, who)) {
    return true;
  }
  *p_value = the_fd;
  return false;
}
bool
mmux_libc_fd_sprint (char * ptr, mmux_usize_t len, mmux_libc_fd_t fd)
{
  if (MMUX_LIBC_FD_MAXIMUM_STRING_REPRESENTATION_LENGTH < len) {
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
  return mmux_sint_sprint(ptr, len, fd.value);
}
bool
mmux_libc_fd_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_fd_t fd)
{
  mmux_sint_t	required_nchars = mmux_sint_sprint_size(fd.value);

  if (0 <= required_nchars) {
    *required_nchars_p = required_nchars;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_dprintf (mmux_libc_file_descriptor_t fd, char const * template, ...)
{
  va_list	ap;
  int		rv;

  va_start(ap, template);
  {
    rv = vdprintf(fd.value, template, ap);
  }
  va_end(ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_dprintfou (char const * template, ...)
{
  va_list	ap;
  int		rv;

  va_start(ap, template);
  {
    rv = vdprintf(stdou_fd.value, template, ap);
  }
  va_end(ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_dprintfer (char const * template, ...)
{
  va_list	ap;
  int		rv;

  va_start(ap, template);
  {
    rv = vdprintf(stder_fd.value, template, ap);
  }
  va_end(ap);
  return ((0 <= rv)? false : true);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_open (mmux_libc_file_descriptor_t * fd, mmux_libc_file_system_pathname_t pathname, mmux_sint_t flags, mmux_mode_t mode)
{
  int	fdval = open(pathname.value, flags, mode);

  if (-1 != fdval) {
    fd->value = fdval;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_close (mmux_libc_file_descriptor_t fd)
{
  int	rv = close(fd.value);

  return ((-1 != rv)? false : true);
}
bool
mmux_libc_openat (mmux_libc_file_descriptor_t * fd, mmux_libc_file_descriptor_t dirfd,
		  mmux_libc_file_system_pathname_t pathname, mmux_sint_t flags, mmux_mode_t mode)
{
  int	fdval = openat(dirfd.value, pathname.value, flags, mode);

  if (-1 != fdval) {
    fd->value = fdval;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_read (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointer_t bufptr, mmux_usize_t buflen)
{
  ssize_t	nbytes_done = read(fd.value, bufptr, buflen);

  if (0 <= nbytes_done) {
    *nbytes_done_p = nbytes_done;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_write (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointer_t bufptr, mmux_usize_t buflen)
{
  ssize_t	nbytes_done = write(fd.value, bufptr, buflen);

  if (0 <= nbytes_done) {
    *nbytes_done_p = nbytes_done;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_pread (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointer_t bufptr, mmux_usize_t buflen,
		 mmux_off_t offset)
{
  ssize_t	nbytes_done = pread(fd.value, bufptr, buflen, offset);

  if (0 <= nbytes_done) {
    *nbytes_done_p = nbytes_done;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_pwrite (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointer_t bufptr, mmux_usize_t buflen,
		  mmux_off_t offset)
{
  ssize_t	nbytes_done = pwrite(fd.value, bufptr, buflen, offset);

  if (0 <= nbytes_done) {
    *nbytes_done_p = nbytes_done;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_lseek (mmux_libc_file_descriptor_t fd, mmux_off_t * offset_p, mmux_sint_t whence)
{
  mmux_off_t	offset = lseek(fd.value, *offset_p, whence);

  if (-1 != offset) {
    *offset_p = offset;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_dup (mmux_libc_file_descriptor_t * new_fd_p, mmux_libc_file_descriptor_t old_fd)
{
  mmux_libc_file_descriptor_t	new_fd = { .value = dup(old_fd.value) };

  if (-1 != new_fd.value) {
    *new_fd_p = new_fd;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_dup2 (mmux_libc_file_descriptor_t old_fd, mmux_libc_file_descriptor_t new_fd)
{
  int	rv = dup2(old_fd.value, new_fd.value);

  return ((-1 != rv)? false : true);
}
bool
mmux_libc_dup3 (mmux_libc_file_descriptor_t old_fd, mmux_libc_file_descriptor_t new_fd, mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_DUP3]]],[[[
  int	rv = dup3(old_fd.value, new_fd.value, flags);

  return ((-1 != rv)? false : true);
]]])
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_pipe (mmux_libc_file_descriptor_t fds[2])
{
  int		fdvals[2];
  int		rv = pipe(fdvals);

  if (-1 != rv) {
    fds[0].value = fdvals[0];
    fds[1].value = fdvals[1];
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_close_pipe (mmux_libc_file_descriptor_t fds[2])
{
  bool	rv1 = mmux_libc_close(fds[0]);
  bool	rv2 = mmux_libc_close(fds[1]);

  return ((rv1 || rv2)? true : false);
}


/** --------------------------------------------------------------------
 ** Input/output: file descriptor scatter-gather API.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(iovec,		iov_base,	mmux_pointer_t)
DEFINE_STRUCT_SETTER_GETTER(iovec,		iov_len,	mmux_usize_t)
DEFINE_STRUCT_SETTER_GETTER(iovec_array,	iova_pointer,	mmux_pointer_t)
DEFINE_STRUCT_SETTER_GETTER(iovec_array,	iova_length,	mmux_usize_t)

bool
mmux_libc_iovec_dump (mmux_libc_file_descriptor_t fd, mmux_libc_iovec_t const * const iovec_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct iovec";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)iovec_p);
  DPRINTF(fd, "%s->iov_base = %p\n", struct_name, iovec_p->iov_base);
  {
    int		len = mmux_usize_sprint_size(iovec_p->iov_len);
    char	str[len];

    mmux_usize_sprint(str, len, iovec_p->iov_len);
    DPRINTF(fd, "%s->iov_len = %s\n", struct_name, str);
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_readv (mmux_usize_t * number_of_bytes_read_p, mmux_libc_file_descriptor_t fd, mmux_libc_iovec_array_t iovec_array)
{
  mmux_ssize_t	rv = readv(fd.value, iovec_array.iova_pointer, iovec_array.iova_length);

  if (-1 != rv) {
    *number_of_bytes_read_p = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_writev (mmux_usize_t * number_of_bytes_read_p, mmux_libc_file_descriptor_t fd, mmux_libc_iovec_array_t iovec_array)
{
  mmux_ssize_t	rv = writev(fd.value, iovec_array.iova_pointer, iovec_array.iova_length);

  if (-1 != rv) {
    *number_of_bytes_read_p = rv;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_preadv (mmux_usize_t * number_of_bytes_read_p, mmux_libc_file_descriptor_t fd, mmux_libc_iovec_array_t iovec_array,
		  mmux_off_t offset)
{
  mmux_ssize_t	rv = preadv(fd.value, iovec_array.iova_pointer, iovec_array.iova_length, offset);

  if (-1 != rv) {
    *number_of_bytes_read_p = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_pwritev (mmux_usize_t * number_of_bytes_read_p, mmux_libc_file_descriptor_t fd, mmux_libc_iovec_array_t iovec_array,
		   mmux_off_t offset)
{
  mmux_ssize_t	rv = pwritev(fd.value, iovec_array.iova_pointer, iovec_array.iova_length, offset);

  if (-1 != rv) {
    *number_of_bytes_read_p = rv;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_preadv2 (mmux_usize_t * number_of_bytes_read_p, mmux_libc_file_descriptor_t fd, mmux_libc_iovec_array_t iovec_array,
		   mmux_off_t offset, mmux_sint_t flags)
{
  mmux_ssize_t	rv = preadv2(fd.value, iovec_array.iova_pointer, iovec_array.iova_length, offset, flags);

  if (-1 != rv) {
    *number_of_bytes_read_p = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_pwritev2 (mmux_usize_t * number_of_bytes_read_p, mmux_libc_file_descriptor_t fd, mmux_libc_iovec_array_t iovec_array,
		    mmux_off_t offset, mmux_sint_t flags)
{
  mmux_ssize_t	rv = pwritev2(fd.value, iovec_array.iova_pointer, iovec_array.iova_length, offset, flags);

  if (-1 != rv) {
    *number_of_bytes_read_p = rv;
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Input/output: file locking.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(flock,	l_type,		mmux_sshort_t)
DEFINE_STRUCT_SETTER_GETTER(flock,	l_whence,	mmux_sshort_t)
DEFINE_STRUCT_SETTER_GETTER(flock,	l_start,	mmux_off_t)
DEFINE_STRUCT_SETTER_GETTER(flock,	l_len,		mmux_off_t)

bool
mmux_libc_l_pid_set (mmux_libc_flock_t * const P, mmux_libc_pid_t value)
{
  P->l_pid = value.value;
  return false;
}
bool
mmux_libc_l_pid_ref (mmux_libc_pid_t * result_p, mmux_libc_flock_t const * const P)
{
  return mmux_libc_make_pid(result_p, P->l_pid);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_flag_to_symbol_struct_flock_l_type (char const * * const str_p, mmux_sint_t flag)
{
  /* We use the if statement, rather than  the switch statement, because there may be
     duplicates in the symbols. */
  if (F_RDLCK == flag) {
    *str_p = "F_RDLCK";
    return false;
  } else if (F_WRLCK == flag) {
    *str_p = "F_WRLCK";
    return false;
  } else if (F_UNLCK == flag) {
    *str_p = "F_UNLCK";
    return false;
  } else {
    *str_p = "unknown";
    return true;
  }
}
bool
mmux_libc_flock_dump (mmux_libc_file_descriptor_t fd, mmux_libc_flock_t const * const flock_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct flock";
  }

  DPRINTF(fd, "%s = \"%p\"\n", struct_name, (mmux_pointer_t)flock_p);

  /* Print l_type. */
  {
    mmux_sint_t	required_nbytes = mmux_sshort_sprint_size(flock_p->l_type);

    if (0 > required_nbytes) {
      return true;
    } else {
      char	str[required_nbytes];
      bool	error_when_true = mmux_sshort_sprint(str, required_nbytes, flock_p->l_type);

      if (error_when_true) {
	mmux_libc_dprintfer("%s: error converting \"l_type\" to string\n", __func__);
	return true;
      } else {
	char const *	symstr;

	mmux_libc_flag_to_symbol_struct_flock_l_type(&symstr, flock_p->l_type);
	DPRINTF(fd, "%s.l_type = \"%s\" (%s)\n", struct_name, str, symstr);
      }
    }
  }

  /* Print l_whence. */
  {
    mmux_sint_t	required_nbytes = mmux_sshort_sprint_size(flock_p->l_whence);

    if (0 > required_nbytes) {
      mmux_libc_dprintfer("%s: error converting \"l_whence\" to string\n", __func__);
      return true;
    } else {
      char	str[required_nbytes];
      bool	error_when_true = mmux_sshort_sprint(str, required_nbytes, flock_p->l_whence);

      if (error_when_true) {
	mmux_libc_dprintfer("%s: error converting \"l_whence\" to string\n", __func__);
	return true;
      } else {
	char const *	symstr;

	switch (flock_p->l_whence) {
	case MMUX_VALUEOF_SEEK_SET:
	  symstr = "SEEK_SET";
	  break;
	case MMUX_VALUEOF_SEEK_END:
	  symstr = "SEEK_END";
	  break;
	case MMUX_VALUEOF_SEEK_CUR:
	  symstr = "SEEK_CUR";
	  break;
	default:
	  symstr = "unknown";
	  break;
	}

	DPRINTF(fd, "%s.l_whence = \"%s\" (%s)\n", struct_name, str, symstr);
      }
    }
  }

  /* Print l_start. */
  {
    mmux_sint_t	required_nbytes = mmux_off_sprint_size(flock_p->l_start);

    if (0 > required_nbytes) {
      mmux_libc_dprintfer("%s: error converting \"l_start\" to string\n", __func__);
      return true;
    } else {
      char	str[required_nbytes];
      bool	error_when_true = mmux_off_sprint(str, required_nbytes, flock_p->l_start);

      if (error_when_true) {
	mmux_libc_dprintfer("%s: error converting \"l_start\" to string\n", __func__);
	return true;
      } else {
	DPRINTF(fd, "%s.l_start = \"%s\"\n", struct_name, str);
      }
    }
  }

  /* Print l_len. */
  {
    mmux_sint_t	required_nbytes = mmux_off_sprint_size(flock_p->l_len);

    if (0 > required_nbytes) {
      mmux_libc_dprintfer("%s: error converting \"l_len\" to string\n", __func__);
      return true;
    } else {
      char	str[required_nbytes];
      bool	error_when_true = mmux_off_sprint(str, required_nbytes, flock_p->l_len);

      if (error_when_true) {
	mmux_libc_dprintfer("%s: error converting \"l_len\" to string\n", __func__);
	return true;
      } else {
	DPRINTF(fd, "%s.l_len = \"%s\"\n", struct_name, str);
      }
    }
  }

  /* Print l_pid. */
  {
    mmux_sint_t	required_nbytes = mmux_pid_sprint_size(flock_p->l_pid);

    if (0 > required_nbytes) {
      mmux_libc_dprintfer("%s: error converting \"l_pid\" to string\n", __func__);
      return true;
    } else {
      char	str[required_nbytes];
      bool	error_when_true = mmux_pid_sprint(str, required_nbytes, flock_p->l_pid);

      if (error_when_true) {
	mmux_libc_dprintfer("%s: error converting \"l_pid\" to string\n", __func__);
	return true;
      } else {
	DPRINTF(fd, "%s.l_pid = \"%s\"\n", struct_name, str);
      }
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Fcntl.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_fcntl (mmux_libc_file_descriptor_t fd, mmux_sint_t command, mmux_pointer_t parameter_p)
{
  switch (command) {

#ifdef MMUX_HAVE_LIBC_F_DUPFD
  case MMUX_LIBC_F_DUPFD: {
    mmux_libc_file_descriptor_t *	new_fd_p = parameter_p;
    mmux_sint_t				rv = fcntl(fd.value, command, new_fd_p->value);

    return ((-1 != rv)? false : true);
  }
#endif

/* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETFD
  case MMUX_LIBC_F_GETFD: {
    mmux_sint_t	rv = fcntl(fd.value, command);

    if (-1 != rv) {
      mmux_sint_t *	flags_p = parameter_p;

      *flags_p = rv;
      return false;
    } else {
      return true;
    }
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETFD
  case MMUX_LIBC_F_SETFD: {
    mmux_sint_t *	flags_p = parameter_p;
    mmux_sint_t		rv = fcntl(fd.value, command, *flags_p);

    return ((-1 != rv)? false : true);
  }
#endif

/* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETFL
  case MMUX_LIBC_F_GETFL: {
    mmux_sint_t	rv = fcntl(fd.value, command);

    if (-1 != rv) {
      mmux_sint_t *	flags_p = parameter_p;

      *flags_p = rv;
      return false;
    } else {
      return true;
    }
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETFL
  case MMUX_LIBC_F_SETFL: {
    mmux_sint_t *	flags_p = parameter_p;
    mmux_sint_t		rv = fcntl(fd.value, command, *flags_p);

    return ((-1 != rv)? false : true);
  }
#endif

/* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETLK
  case MMUX_LIBC_F_GETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    mmux_sint_t			rv = fcntl(fd.value, command, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETLK
  case MMUX_LIBC_F_SETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    mmux_sint_t			rv = fcntl(fd.value, command, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETLKW
  case MMUX_LIBC_F_SETLKW: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    mmux_sint_t			rv = fcntl(fd.value, command, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

/* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_OFD_GETLK
  case MMUX_LIBC_F_OFD_GETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    mmux_sint_t			rv = fcntl(fd.value, command, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_OFD_SETLK
  case MMUX_LIBC_F_OFD_SETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    mmux_sint_t			rv = fcntl(fd.value, command, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_OFD_SETLKW
  case MMUX_LIBC_F_OFD_SETLKW: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    mmux_sint_t			rv = fcntl(fd.value, command, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

/* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETOWN
  case MMUX_LIBC_F_GETOWN: {
    mmux_pid_t	rv = fcntl(fd.value, command);

    if (-1 != rv) {
      mmux_libc_pid_t *	pid_p = parameter_p;

      pid_p->value = rv;
      return false;
    } else {
      return true;
    }
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETOWN
  case MMUX_LIBC_F_SETOWN: {
    mmux_libc_pid_t *	pid_p = parameter_p;
    mmux_sint_t		rv = fcntl(fd.value, command, pid_p->value);

    return ((-1 != rv)? false : true);
  }
#endif

/* ------------------------------------------------------------------ */

  default:
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
}

bool
mmux_libc_fcntl_command_flag_to_symbol (char const ** str_p, mmux_sint_t flag)
{
  /* We use the if statement, rather than  the switch statement, because there may be
     duplicates in the symbols. */
  if (F_DUPFD == flag) {
    *str_p = "F_DUPFD";
    return false;
  } else if (F_GETFD == flag) {
    *str_p = "F_GETFD";
    return false;
  } else if (F_GETFL == flag) {
    *str_p = "F_GETFL";
    return false;
  } else if (F_GETLK == flag) {
    *str_p = "F_GETLK";
    return false;
  } else if (F_GETOWN == flag) {
    *str_p = "F_GETOWN";
    return false;
  } else if (F_SETFD == flag) {
    *str_p = "F_SETFD";
    return false;
  } else if (F_SETFL == flag) {
    *str_p = "F_SETFL";
    return false;
  } else if (F_SETLKW == flag) {
    *str_p = "F_SETLKW";
    return false;
  } else if (F_SETLK == flag) {
    *str_p = "F_SETLK";
    return false;
  } else if (F_SETOWN == flag) {
    *str_p = "F_SETOWN";
    return false;
  } else {
    *str_p = "unknown";
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Ioctl.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_ioctl (mmux_libc_file_descriptor_t fd, mmux_sint_t command, mmux_pointer_t parameter_p)
{
  switch (command) {

#ifdef MMUX_HAVE_LIBC_SIOCATMARK
  case MMUX_LIBC_SIOCATMARK: { /* synopsis: mmux_libc_ioctl FD SIOCATMARK ATMARK_POINTER */
    mmux_sint_t *	atmark_p = parameter_p;
    mmux_sint_t		rv = ioctl(fd.value, command, atmark_p);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

  default:
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Selecting file descriptors.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_FD_ZERO (mmux_libc_fd_set_t * fd_set_p)
{
  FD_ZERO(fd_set_p);
  return false;
}
bool
mmux_libc_FD_SET (mmux_libc_file_descriptor_t fd, mmux_libc_fd_set_t * fd_set_p)
{
  FD_SET(fd.value, fd_set_p);
  return false;
}
bool
mmux_libc_FD_CLR (mmux_libc_file_descriptor_t fd, mmux_libc_fd_set_t * fd_set_p)
{
  FD_CLR(fd.value, fd_set_p);
  return false;
}
bool
mmux_libc_FD_ISSET (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_fd_set_t const * fd_set_p)
{
  *result_p = FD_ISSET(fd.value, fd_set_p);
  return false;
}
bool
mmux_libc_select (mmux_uint_t * nfds_ready, mmux_uint_t maximum_nfds_to_check,
		  mmux_libc_fd_set_t * read_fd_set_p, mmux_libc_fd_set_t * write_fd_set_p, mmux_libc_fd_set_t * except_fd_set_p,
		  mmux_libc_timeval_t * timeout_p)
{
  mmux_libc_fd_set_t	default_read_fd_set;
  mmux_libc_fd_set_t	default_write_fd_set;
  mmux_libc_fd_set_t	default_except_fd_set;

  if (NULL == read_fd_set_p) {
    FD_ZERO(&default_read_fd_set);
    read_fd_set_p = &default_read_fd_set;
  }
  if (NULL == write_fd_set_p) {
    FD_ZERO(&default_write_fd_set);
    write_fd_set_p = &default_write_fd_set;
  }
  if (NULL == except_fd_set_p) {
    FD_ZERO(&default_except_fd_set);
    except_fd_set_p = &default_except_fd_set;
  }
  {
    mmux_sint_t		rv = select(maximum_nfds_to_check, read_fd_set_p, write_fd_set_p, except_fd_set_p, timeout_p);

    if (-1 < rv) {
      *nfds_ready = rv;
      return false;
    } else {
      return true;
    }
  }
}


/** --------------------------------------------------------------------
 ** Copying file ranges.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_copy_file_range (mmux_usize_t * number_of_bytes_copied_p,
			   mmux_libc_file_descriptor_t input_fd, mmux_sint64_t * input_position_p,
			   mmux_libc_file_descriptor_t ouput_fd, mmux_sint64_t * ouput_position_p,
			   mmux_usize_t number_of_bytes_to_copy, mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_COPY_FILE_RANGE]]],[[[
  mmux_ssize_t	number_of_bytes_copied = copy_file_range(input_fd.value, input_position_p,
							 ouput_fd.value, ouput_position_p,
							 number_of_bytes_to_copy, flags);

  if (0 <= number_of_bytes_copied) {
    *number_of_bytes_copied_p = number_of_bytes_copied;
    return false;
  } else {
    return true;
  }
]]])
}


/** --------------------------------------------------------------------
 ** Printing types.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_PRINTER]]],[[[MMUX_CONDITIONAL_CODE([[[$2]]],[[[
bool
mmux_$1_dprintf (mmux_libc_file_descriptor_t fd, mmux_$1_t value)
{
  int		rv, required_nbytes;

  required_nbytes = mmux_$1_sprint_size(value);
  if (0 > required_nbytes) {
    return true;
  } else {
    char	s_value[required_nbytes];

    rv = mmux_$1_sprint(s_value, required_nbytes, value);
    if (false == rv) {
      return mmux_libc_dprintf(fd, "%s", s_value);
    } else {
      return true;
    }
  }
}
]]])]]])

DEFINE_PRINTER([[[pointer]]])

DEFINE_PRINTER([[[schar]]])
DEFINE_PRINTER([[[uchar]]])
DEFINE_PRINTER([[[sshort]]])
DEFINE_PRINTER([[[ushort]]])
DEFINE_PRINTER([[[sint]]])
DEFINE_PRINTER([[[uint]]])
DEFINE_PRINTER([[[slong]]])
DEFINE_PRINTER([[[ulong]]])
DEFINE_PRINTER([[[sllong]]],		[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
DEFINE_PRINTER([[[ullong]]],		[[[MMUX_HAVE_CC_TYPE_ULLONG]]])

DEFINE_PRINTER([[[sint8]]])
DEFINE_PRINTER([[[uint8]]])
DEFINE_PRINTER([[[sint16]]])
DEFINE_PRINTER([[[uint16]]])
DEFINE_PRINTER([[[sint32]]])
DEFINE_PRINTER([[[uint32]]])
DEFINE_PRINTER([[[sint64]]])
DEFINE_PRINTER([[[uint64]]])

DEFINE_PRINTER([[[float]]])
DEFINE_PRINTER([[[double]]])
DEFINE_PRINTER([[[ldouble]]],		[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_PRINTER([[[float32]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
DEFINE_PRINTER([[[float64]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
DEFINE_PRINTER([[[float128]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

DEFINE_PRINTER([[[float32x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
DEFINE_PRINTER([[[float64x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
DEFINE_PRINTER([[[float128x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

DEFINE_PRINTER([[[decimal32]]],		[[[MMUX_HAVE_CC_TYPE_DECIMAL32]]])
DEFINE_PRINTER([[[decimal64]]],		[[[MMUX_HAVE_CC_TYPE_DECIMAL64]]])
DEFINE_PRINTER([[[decimal128]]],	[[[MMUX_HAVE_CC_TYPE_DECIMAL128]]])

DEFINE_PRINTER([[[complexf]]])
DEFINE_PRINTER([[[complexd]]])
DEFINE_PRINTER([[[complexld]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXLD]]])

DEFINE_PRINTER([[[complexf32]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])
DEFINE_PRINTER([[[complexf64]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])
DEFINE_PRINTER([[[complexf128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

DEFINE_PRINTER([[[complexf32x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])
DEFINE_PRINTER([[[complexf64x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])
DEFINE_PRINTER([[[complexf128x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])

DEFINE_PRINTER([[[complexd32]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD32]]])
DEFINE_PRINTER([[[complexd64]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD64]]])
DEFINE_PRINTER([[[complexd128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD128]]])

DEFINE_PRINTER([[[usize]]])
DEFINE_PRINTER([[[ssize]]])

DEFINE_PRINTER([[[sintmax]]])
DEFINE_PRINTER([[[uintmax]]])
DEFINE_PRINTER([[[sintptr]]])
DEFINE_PRINTER([[[uintptr]]])
DEFINE_PRINTER([[[ptrdiff]]])
DEFINE_PRINTER([[[mode]]])
DEFINE_PRINTER([[[off]]])
DEFINE_PRINTER([[[pid]]])
DEFINE_PRINTER([[[uid]]])
DEFINE_PRINTER([[[gid]]])
DEFINE_PRINTER([[[wchar]]])
DEFINE_PRINTER([[[wint]]])
DEFINE_PRINTER([[[time]]])
DEFINE_PRINTER([[[socklen]]])
DEFINE_PRINTER([[[rlim]]])

bool
mmux_libc_fd_dprintf (mmux_libc_file_descriptor_t fd, mmux_libc_file_descriptor_t value)
{
  return mmux_sint_dprintf(fd, value.value);
}
bool
mmux_libc_pid_dprintf (mmux_libc_file_descriptor_t fd, mmux_libc_pid_t value)
{
  return mmux_sint_dprintf(fd, value.value);
}
bool
mmux_libc_uid_dprintf (mmux_libc_file_descriptor_t fd, mmux_libc_uid_t value)
{
  return mmux_sint_dprintf(fd, value.value);
}
bool
mmux_libc_gid_dprintf (mmux_libc_file_descriptor_t fd, mmux_libc_gid_t value)
{
  return mmux_sint_dprintf(fd, value.value);
}
bool
mmux_libc_ptn_dprintf (mmux_libc_file_descriptor_t fd, mmux_libc_file_system_pathname_t value)
{
  return mmux_libc_dprintf(fd, "%s", value.value);
}

/* end of file */
