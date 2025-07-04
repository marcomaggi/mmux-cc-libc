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

#define DPRINTF(FD,...)		if (mmux_libc_dprintf(FD,__VA_ARGS__)) { return true; }

#define DPRINTF_NEWLINE(FD)	if (mmux_libc_dprintf_newline(FD)) { return true; }


/** --------------------------------------------------------------------
 ** Helpers.
 ** ----------------------------------------------------------------- */

m4_define([[[DUMP_OPEN_FLAGS_FLAG]]],[[[
#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  if (MMUX_LIBC_$1 & value) {
    if (not_first_flags) {
      DPRINTF(fd, " | $1");
    } else {
      DPRINTF(fd, " ($1");
      not_first_flags = true;
    }
  }
#endif
]]])

static bool
dump_open_flags (mmux_libc_fd_t fd, mmux_uint64_t value)
{
  bool		not_first_flags = false;

  if (0 != value) {

  DUMP_OPEN_FLAGS_FLAG(O_ACCMODE)
  DUMP_OPEN_FLAGS_FLAG(O_APPEND)
  DUMP_OPEN_FLAGS_FLAG(O_ASYNC)
  DUMP_OPEN_FLAGS_FLAG(O_CLOEXEC)
  DUMP_OPEN_FLAGS_FLAG(O_CREAT)
  DUMP_OPEN_FLAGS_FLAG(O_DIRECT)
  DUMP_OPEN_FLAGS_FLAG(O_DIRECTORY)
  DUMP_OPEN_FLAGS_FLAG(O_DSYNC)
  DUMP_OPEN_FLAGS_FLAG(O_EXCL)
  DUMP_OPEN_FLAGS_FLAG(O_EXEC)
  DUMP_OPEN_FLAGS_FLAG(O_EXLOCK)
  DUMP_OPEN_FLAGS_FLAG(O_FSYNC)
  DUMP_OPEN_FLAGS_FLAG(O_IGNORE_CTTY)
  DUMP_OPEN_FLAGS_FLAG(O_LARGEFILE)
  DUMP_OPEN_FLAGS_FLAG(O_NDELAY)
  DUMP_OPEN_FLAGS_FLAG(O_NOATIME)
  DUMP_OPEN_FLAGS_FLAG(O_NOCTTY)
  DUMP_OPEN_FLAGS_FLAG(O_NOFOLLOW)
  DUMP_OPEN_FLAGS_FLAG(O_NOLINK)
  DUMP_OPEN_FLAGS_FLAG(O_NONBLOCK)
  DUMP_OPEN_FLAGS_FLAG(O_NOTRANS)
  DUMP_OPEN_FLAGS_FLAG(O_PATH)
  DUMP_OPEN_FLAGS_FLAG(O_RDONLY)
  DUMP_OPEN_FLAGS_FLAG(O_RDWR)
  DUMP_OPEN_FLAGS_FLAG(O_READ)
  DUMP_OPEN_FLAGS_FLAG(O_SHLOCK)
  DUMP_OPEN_FLAGS_FLAG(O_SYNC)
  DUMP_OPEN_FLAGS_FLAG(O_TMPFILE)
  DUMP_OPEN_FLAGS_FLAG(O_TRUNC)
  DUMP_OPEN_FLAGS_FLAG(O_WRITE)
  DUMP_OPEN_FLAGS_FLAG(O_WRONLY)

    if (mmux_libc_dprintf(fd, ")")) {
      return true;
    }
  }

  return false;
}

/* ------------------------------------------------------------------ */

m4_define([[[DUMP_OPEN_MODE_FLAG]]],[[[
#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  if (MMUX_LIBC_$1 & value) {
    if (not_first_flags) {
      DPRINTF(fd, " | $1");
    } else {
      DPRINTF(fd, " ($1");
      not_first_flags = true;
    }
  }
#endif
]]])

static bool
dump_open_mode (mmux_libc_fd_t fd, mmux_uint64_t value)
{
  bool		not_first_flags = false;

  if (0 != value) {

    DUMP_OPEN_MODE_FLAG(S_IRGRP)
    DUMP_OPEN_MODE_FLAG(S_IROTH)
    DUMP_OPEN_MODE_FLAG(S_IRUSR)
    DUMP_OPEN_MODE_FLAG(S_IRWXG)
    DUMP_OPEN_MODE_FLAG(S_IRWXO)
    DUMP_OPEN_MODE_FLAG(S_IRWXU)
    DUMP_OPEN_MODE_FLAG(S_ISGID)
    DUMP_OPEN_MODE_FLAG(S_ISUID)
    DUMP_OPEN_MODE_FLAG(S_ISVTX)
    DUMP_OPEN_MODE_FLAG(S_IWGRP)
    DUMP_OPEN_MODE_FLAG(S_IWOTH)
    DUMP_OPEN_MODE_FLAG(S_IWUSR)
    DUMP_OPEN_MODE_FLAG(S_IXGRP)
    DUMP_OPEN_MODE_FLAG(S_IXOTH)
    DUMP_OPEN_MODE_FLAG(S_IXUSR)

    if (mmux_libc_dprintf(fd, ")")) {
      return true;
    }
  }

  return false;
}

/* ------------------------------------------------------------------ */

m4_define([[[DUMP_OPEN_RESOLVE_FLAG]]],[[[
#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  if (MMUX_LIBC_$1 & value) {
    if (not_first_flags) {
      DPRINTF(fd, " | $1");
    } else {
      DPRINTF(fd, " ($1");
      not_first_flags = true;
    }
  }
#endif
]]])

static bool
dump_open_resolve (mmux_libc_fd_t fd, mmux_uint64_t value)
/* Dump the field "resolve" of "struct open_how", see "openat2(2)" for details. */
{
  bool		not_first_flags = false;

  if (0 != value) {

    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_BENEATH)
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_IN_ROOT)
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_NO_MAGICLINKS)
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_NO_SYMLINKS)
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_NO_XDEV)
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_CACHED)

    if (mmux_libc_dprintf(fd, ")")) {
      return true;
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Input/output: file descriptor core API.
 ** ----------------------------------------------------------------- */

static const mmux_libc_file_descriptor_t stdin_fd = { .value = 0 };
static const mmux_libc_file_descriptor_t stdou_fd = { .value = 1 };
static const mmux_libc_file_descriptor_t stder_fd = { .value = 2 };
static const mmux_libc_file_descriptor_t at_fdcwd_fd = { .value = MMUX_LIBC_AT_FDCWD };

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

bool
mmux_libc_fd_equal (mmux_libc_fd_t one, mmux_libc_fd_t two)
{
  return (one.value == two.value)? true : false;
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
mmux_libc_dprintf (mmux_libc_file_descriptor_t fd, mmux_asciizcp_t template, ...)
{
  va_list	ap;
  mmux_sint_t	rv;

  va_start(ap, template);
  {
    rv = vdprintf(fd.value, template, ap);
  }
  va_end(ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_dprintfou (mmux_asciizcp_t template, ...)
{
  va_list	ap;
  mmux_sint_t	rv;

  va_start(ap, template);
  {
    rv = vdprintf(stdou_fd.value, template, ap);
  }
  va_end(ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_dprintfer (mmux_asciizcp_t template, ...)
{
  va_list	ap;
  mmux_sint_t	rv;

  va_start(ap, template);
  {
    rv = vdprintf(stder_fd.value, template, ap);
  }
  va_end(ap);
  return ((0 <= rv)? false : true);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_vdprintf (mmux_libc_file_descriptor_t fd, mmux_asciizcp_t template, va_list ap)
{
  mmux_sint_t	rv = vdprintf(fd.value, template, ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_vdprintfou (mmux_asciizcp_t template, va_list ap)
{
  mmux_sint_t	rv = vdprintf(stdou_fd.value, template, ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_vdprintfer (mmux_asciizcp_t template, va_list ap)
{
  mmux_sint_t	rv = vdprintf(stder_fd.value, template, ap);
  return ((0 <= rv)? false : true);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_dprintf_newline (mmux_libc_file_descriptor_t fd)
{
  return mmux_libc_dprintf(fd, "\n");
}
bool
mmux_libc_dprintfou_newline (void)
{
  return mmux_libc_dprintfou("\n");
}
bool
mmux_libc_dprintfer_newline (void)
{
  return mmux_libc_dprintfer("\n");
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_open (mmux_libc_file_descriptor_t * fd, mmux_libc_file_system_pathname_t pathname, mmux_sint_t flags, mmux_mode_t mode)
{
  mmux_sint_t	fdval = open(pathname.value, flags, mode);

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
  mmux_sint_t	rv = close(fd.value);

  return ((-1 != rv)? false : true);
}
bool
mmux_libc_openat (mmux_libc_file_descriptor_t * fd, mmux_libc_file_descriptor_t dirfd,
		  mmux_libc_file_system_pathname_t pathname, mmux_sint_t flags, mmux_mode_t mode)
{
  mmux_sint_t	fdval = openat(dirfd.value, pathname.value, flags, mode);

  if (-1 != fdval) {
    fd->value = fdval;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER]]],[[[bool
mmux_libc_open_how_$1_set (mmux_libc_open_how_t * const P, $2 value)
{
  P->$1 = value;
  return false;
}
bool
mmux_libc_open_how_$1_ref ($2 * result_p, mmux_libc_open_how_t const * const P)
{
  *result_p = P->$1;
  return false;
}]]])

DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER(flags,	mmux_uint64_t)
DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER(mode,	mmux_uint64_t)
DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER(resolve,	mmux_uint64_t)

bool
mmux_libc_open_how_dump (mmux_libc_file_descriptor_t fd, mmux_libc_open_how_t const * const open_how_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct open_how";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)open_how_p);

  /* Dump the field "flags". */
  {
    mmux_uint64_t	value;

    mmux_libc_open_how_flags_ref(&value, open_how_p);

    DPRINTF(fd, "%s->flags = ", struct_name);
    if (mmux_uint64_dprintf(fd, value)) {
      return true;
    }
    if (dump_open_flags(fd, value)) {
      return true;
    }
    DPRINTF_NEWLINE(fd);
  }

  /* Dump the field "mode". */
  {
    mmux_uint64_t	value;

    mmux_libc_open_how_mode_ref(&value, open_how_p);

    DPRINTF(fd, "%s->mode = ", struct_name);
    if (mmux_uint64_dprintf(fd, value)) {
      return true;
    }
    if (dump_open_mode(fd, value)) {
      return true;
    }
    DPRINTF_NEWLINE(fd);
  }

  /* Dump the field "resolve". */
  {
    mmux_uint64_t	value;

    mmux_libc_open_how_resolve_ref(&value, open_how_p);

    DPRINTF(fd, "%s->resolve = ", struct_name);
    if (mmux_uint64_dprintf(fd, value)) {
      return true;
    }
    if (dump_open_resolve(fd, value)) {
      return true;
    }
    DPRINTF_NEWLINE(fd);
  }

  return false;
}

bool
mmux_libc_openat2 (mmux_libc_file_descriptor_t * fd, mmux_libc_file_descriptor_t dirfd,
		   mmux_libc_file_system_pathname_t pathname, mmux_libc_open_how_t const * const how_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_LINUX_OPENAT2_H]]],[[[
  mmux_slong_t	fdval = syscall(SYS_openat2, dirfd.value, pathname.value, how_p, sizeof(mmux_libc_open_how_t));

  if (-1 != fdval) {
    fd->value = fdval;
    return false;
  } else {
    return true;
  }
]]])
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_read (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointer_t bufptr, mmux_usize_t buflen)
{
  mmux_ssize_t	nbytes_done = read(fd.value, bufptr, buflen);

  if (0 <= nbytes_done) {
    *nbytes_done_p = nbytes_done;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_write (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  mmux_ssize_t	nbytes_done = write(fd.value, bufptr, buflen);

  if (0 <= nbytes_done) {
    *nbytes_done_p = nbytes_done;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_write_buffer (mmux_libc_fd_t fd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  mmux_usize_t	nbytes_done;
  bool		rv;

  rv = mmux_libc_write(&nbytes_done, fd, bufptr, buflen);
  if (rv || (buflen != nbytes_done)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_write_buffer_to_stdou (mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  return mmux_libc_write_buffer(stdou_fd, bufptr, buflen);
}
bool
mmux_libc_write_buffer_to_stder (mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  return mmux_libc_write_buffer(stder_fd, bufptr, buflen);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_pread (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointer_t bufptr, mmux_usize_t buflen,
		 mmux_off_t offset)
{
  mmux_ssize_t	nbytes_done = pread(fd.value, bufptr, buflen, offset);

  if (0 <= nbytes_done) {
    *nbytes_done_p = nbytes_done;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_pwrite (mmux_usize_t * nbytes_done_p, mmux_libc_file_descriptor_t fd, mmux_pointerc_t bufptr, mmux_usize_t buflen,
		  mmux_off_t offset)
{
  mmux_ssize_t	nbytes_done = pwrite(fd.value, bufptr, buflen, offset);

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
  mmux_sint_t	rv = dup2(old_fd.value, new_fd.value);

  return ((-1 != rv)? false : true);
}
bool
mmux_libc_dup3 (mmux_libc_file_descriptor_t old_fd, mmux_libc_file_descriptor_t new_fd, mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_DUP3]]],[[[
  mmux_sint_t	rv = dup3(old_fd.value, new_fd.value, flags);

  return ((-1 != rv)? false : true);
]]])
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_pipe (mmux_libc_file_descriptor_t fds[2])
{
  mmux_sint_t		fdvals[2];
  mmux_sint_t		rv = pipe(fdvals);

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
  mmux_sint_t		rv = select(maximum_nfds_to_check, read_fd_set_p, write_fd_set_p, except_fd_set_p, timeout_p);

  if (-1 < rv) {
    *nfds_ready = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_select_fd_for_reading (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_timeval_t * timeout_p)
{
  mmux_libc_fd_set_t	the_fd_set[1];
  mmux_uint_t		nfds_ready;

  mmux_libc_FD_ZERO(the_fd_set);
  mmux_libc_FD_SET(fd, the_fd_set);

  if (mmux_libc_select(&nfds_ready, fd.value, the_fd_set, NULL, NULL, timeout_p)) {
    return true;
  } else if ((1 == nfds_ready)  && (FD_ISSET(fd.value, the_fd_set))) {
    *result_p = true;
    return false;
  } else {
    *result_p = false;
    return false;
  }
}
bool
mmux_libc_select_fd_for_writing (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_timeval_t * timeout_p)
{
  mmux_libc_fd_set_t	the_fd_set[1];
  mmux_uint_t		nfds_ready;

  mmux_libc_FD_ZERO(the_fd_set);
  mmux_libc_FD_SET(fd, the_fd_set);

  if (mmux_libc_select(&nfds_ready, fd.value, NULL, the_fd_set, NULL, timeout_p)) {
    return true;
  } else if ((1 == nfds_ready)  && (FD_ISSET(fd.value, the_fd_set))) {
    *result_p = true;
    return false;
  } else {
    *result_p = false;
    return false;
  }
}
bool
mmux_libc_select_fd_for_exception (bool * result_p, mmux_libc_file_descriptor_t fd, mmux_libc_timeval_t * timeout_p)
{
  mmux_libc_fd_set_t	the_fd_set[1];
  mmux_uint_t		nfds_ready;

  mmux_libc_FD_ZERO(the_fd_set);
  mmux_libc_FD_SET(fd, the_fd_set);

  if (mmux_libc_select(&nfds_ready, fd.value, NULL, NULL, the_fd_set, timeout_p)) {
    return true;
  } else if ((1 == nfds_ready)  && (FD_ISSET(fd.value, the_fd_set))) {
    *result_p = true;
    return false;
  } else {
    *result_p = false;
    return false;
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
 ** Memfd buffers.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_memfd_create (mmux_libc_file_descriptor_t * fd_p, mmux_asciizcp_t name, mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMFD_CREATE]]],[[[
  mmux_sint_t	rv = memfd_create(name, flags);

  if (-1 == rv) {
    return true;
  } else {
    fd_p->value = rv;
    return false;
  }
]]])
}
bool
mmux_libc_make_mfd (mmux_libc_file_descriptor_t * fd_p)
{
  return mmux_libc_memfd_create(fd_p, "mmux-cc-libs-memfd-buffer", 0);
}
bool
mmux_libc_mfd_length (mmux_usize_t * len_p, mmux_libc_file_descriptor_t fd)
{
  mmux_off_t	current_offset = 0, size_offset = 0;

  /* Retrieve the current position. */
  if (mmux_libc_lseek(fd, &current_offset, MMUX_LIBC_SEEK_CUR)) {
    return true;
  } else /* Retrieve the file size. */
    if (mmux_libc_lseek(fd, &size_offset, MMUX_LIBC_SEEK_END)) {
      return true;
    } else
      /* Reset the original position. */
      if (mmux_libc_lseek(fd, &current_offset, MMUX_LIBC_SEEK_SET)) {
	return true;
      } else if (size_offset >= 0) {
	*len_p = (mmux_usize_t)size_offset;
	return false;
      } else {
	return true;
      }
}
bool
mmux_libc_mfd_copy (mmux_libc_file_descriptor_t ou, mmux_libc_file_descriptor_t mfd)
{
  bool		rv			= false;
  mmux_off_t	original_position	= 0;

  /* Acquire the original position. */
  if (mmux_libc_lseek(mfd, &original_position, MMUX_LIBC_SEEK_SET)) {
    return true;
  }

  /* Seek to the beginning. */
  {
    mmux_off_t	position = 0;

    if (mmux_libc_lseek(mfd, &position, MMUX_LIBC_SEEK_SET)) {
      rv = true;
      goto end_of_function;
    }
  }

  /* Read from input, write to output. */
  {
    static mmux_usize_t const	read_buflen = 1024;
    mmux_octet_t		read_bufptr[read_buflen];
    mmux_usize_t		nbytes_read;

    /* Loop reading while the number of bytes read is positive. */
    do {
      if (mmux_libc_read(&nbytes_read, mfd, read_bufptr, read_buflen)) {
	rv = true;
	goto end_of_function;
      }

      if (nbytes_read > 0) {
	mmux_octet_t *	write_bufptr	= read_bufptr;
	mmux_usize_t	write_buflen	= nbytes_read;
	mmux_usize_t	nbytes_written	= 0;

	/* Loop writing until we have written all the bytes from the buffer. */
	do {
	  if (mmux_libc_write(&nbytes_written, ou, write_bufptr, write_buflen)) {
	    rv = true;
	    goto end_of_function;
	  }

	  if (nbytes_written < write_buflen) {
	    write_bufptr += nbytes_written;
	    write_buflen -= nbytes_written;
	  }
	} while (nbytes_written < write_buflen);
      }
    } while (nbytes_read > 0);
  }

 end_of_function:
  /* Restore the original position. */
  if (mmux_libc_lseek(mfd, &original_position, MMUX_LIBC_SEEK_SET)) {
    return true;
  }

  return rv;
}
bool
mmux_libc_mfd_copyou (mmux_libc_file_descriptor_t mfd)
{
  return mmux_libc_mfd_copy(stdou_fd, mfd);
}
bool
mmux_libc_mfd_copyer (mmux_libc_file_descriptor_t mfd)
{
  return mmux_libc_mfd_copy(stder_fd, mfd);
}
bool
mmux_libc_mfd_write_buffer (mmux_libc_file_descriptor_t mfd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  mmux_usize_t	nbytes_done;

  if (mmux_libc_write(&nbytes_done, mfd, bufptr, buflen)) {
    return true;
  } else if (buflen != nbytes_done) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_mfd_write_asciiz (mmux_libc_file_descriptor_t mfd, mmux_asciizcp_t bufptr)
{
  mmux_usize_t	buflen;

  if (mmux_libc_strlen(&buflen, bufptr)) {
    return true;
  } else if (mmux_libc_mfd_write_buffer(mfd, bufptr, buflen)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_mfd_strerror (mmux_libc_fd_t mfd, mmux_sint_t errnum)
{
  mmux_asciizcp_t	errmsg;

  if (mmux_libc_strerror(&errmsg, errnum)) {
    return true;
  } else if (mmux_libc_mfd_write_asciiz(mfd, errmsg)) {
    return true;
  } else {
    return false;
  }
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
bool
mmux_libc_completed_process_status_dprintf (mmux_libc_file_descriptor_t fd, mmux_libc_completed_process_status_t value)
{
  return mmux_sint_dprintf(fd, value.value);
}
bool
mmux_libc_interprocess_signal_dprintf (mmux_libc_file_descriptor_t fd, mmux_libc_interprocess_signal_t value)
{
  return mmux_sint_dprintf(fd, value.value);
}

/* end of file */
