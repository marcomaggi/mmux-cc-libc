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

#define DPRINTF(FD,...)		MMUX_LIBC_CALL(mmux_libc_dprintf(FD,__VA_ARGS__))
#define DPRINTF_NEWLINE(FD)	MMUX_LIBC_CALL(mmux_libc_dprintf_newline(FD))


/** --------------------------------------------------------------------
 ** Helpers.
 ** ----------------------------------------------------------------- */

static bool
dump_open_flags (mmux_libc_fd_arg_t fd, mmux_uint64_t value)
{
  bool		not_first_flags = false;

m4_define([[[DUMP_OPEN_FLAGS_FLAG]]],[[[{
#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  if (MMUX_LIBC_$1 & value.value) {
    if (not_first_flags) {
      DPRINTF(fd, " | $1");
    } else {
      DPRINTF(fd, " ($1");
      not_first_flags = true;
    }
  }
#endif
}]]])

  if (0 != value.value) {
    DUMP_OPEN_FLAGS_FLAG(O_ACCMODE);
    DUMP_OPEN_FLAGS_FLAG(O_APPEND);
    DUMP_OPEN_FLAGS_FLAG(O_ASYNC);
    DUMP_OPEN_FLAGS_FLAG(O_CLOEXEC);
    DUMP_OPEN_FLAGS_FLAG(O_CREAT);
    DUMP_OPEN_FLAGS_FLAG(O_DIRECT);
    DUMP_OPEN_FLAGS_FLAG(O_DIRECTORY);
    DUMP_OPEN_FLAGS_FLAG(O_DSYNC);
    DUMP_OPEN_FLAGS_FLAG(O_EXCL);
    DUMP_OPEN_FLAGS_FLAG(O_EXEC);
    DUMP_OPEN_FLAGS_FLAG(O_EXLOCK);
    DUMP_OPEN_FLAGS_FLAG(O_FSYNC);
    DUMP_OPEN_FLAGS_FLAG(O_IGNORE_CTTY);
    DUMP_OPEN_FLAGS_FLAG(O_LARGEFILE);
    DUMP_OPEN_FLAGS_FLAG(O_NDELAY);
    DUMP_OPEN_FLAGS_FLAG(O_NOATIME);
    DUMP_OPEN_FLAGS_FLAG(O_NOCTTY);
    DUMP_OPEN_FLAGS_FLAG(O_NOFOLLOW);
    DUMP_OPEN_FLAGS_FLAG(O_NOLINK);
    DUMP_OPEN_FLAGS_FLAG(O_NONBLOCK);
    DUMP_OPEN_FLAGS_FLAG(O_NOTRANS);
    DUMP_OPEN_FLAGS_FLAG(O_PATH);
    DUMP_OPEN_FLAGS_FLAG(O_RDONLY);
    DUMP_OPEN_FLAGS_FLAG(O_RDWR);
    DUMP_OPEN_FLAGS_FLAG(O_READ);
    DUMP_OPEN_FLAGS_FLAG(O_SHLOCK);
    DUMP_OPEN_FLAGS_FLAG(O_SYNC);
    DUMP_OPEN_FLAGS_FLAG(O_TMPFILE);
    DUMP_OPEN_FLAGS_FLAG(O_TRUNC);
    DUMP_OPEN_FLAGS_FLAG(O_WRITE);
    DUMP_OPEN_FLAGS_FLAG(O_WRONLY);
    DPRINTF(fd, ")");
  }

  return false;
}
static bool
dump_open_mode (mmux_libc_fd_arg_t fd, mmux_uint64_t value)
{
  bool		not_first_flags = false;

m4_define([[[DUMP_OPEN_MODE_FLAG]]],[[[{
#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  if (MMUX_LIBC_$1 & value.value) {
    if (not_first_flags) {
      DPRINTF(fd, " | $1");
    } else {
      DPRINTF(fd, " ($1");
      not_first_flags = true;
    }
  }
#endif
}]]])

  if (0 != value.value) {
    DUMP_OPEN_MODE_FLAG(S_IRGRP);
    DUMP_OPEN_MODE_FLAG(S_IROTH);
    DUMP_OPEN_MODE_FLAG(S_IRUSR);
    DUMP_OPEN_MODE_FLAG(S_IRWXG);
    DUMP_OPEN_MODE_FLAG(S_IRWXO);
    DUMP_OPEN_MODE_FLAG(S_IRWXU);
    DUMP_OPEN_MODE_FLAG(S_ISGID);
    DUMP_OPEN_MODE_FLAG(S_ISUID);
    DUMP_OPEN_MODE_FLAG(S_ISVTX);
    DUMP_OPEN_MODE_FLAG(S_IWGRP);
    DUMP_OPEN_MODE_FLAG(S_IWOTH);
    DUMP_OPEN_MODE_FLAG(S_IWUSR);
    DUMP_OPEN_MODE_FLAG(S_IXGRP);
    DUMP_OPEN_MODE_FLAG(S_IXOTH);
    DUMP_OPEN_MODE_FLAG(S_IXUSR);
    DPRINTF(fd, ")");
  }

  return false;
}
static bool
dump_open_resolve (mmux_libc_fd_arg_t fd, mmux_uint64_t value)
/* Dump the field "resolve" of "struct open_how", see "openat2(2)" for details. */
{
  bool		not_first_flags = false;

m4_define([[[DUMP_OPEN_RESOLVE_FLAG]]],[[[{
#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  if (MMUX_LIBC_$1 & value.value) {
    if (not_first_flags) {
      DPRINTF(fd, " | $1");
    } else {
      DPRINTF(fd, " ($1");
      not_first_flags = true;
    }
  }
#endif
}]]])

  if (0 != value.value) {
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_BENEATH);
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_IN_ROOT);
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_NO_MAGICLINKS);
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_NO_SYMLINKS);
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_NO_XDEV);
    DUMP_OPEN_RESOLVE_FLAG(RESOLVE_CACHED);
    DPRINTF(fd, ")");
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Input/output: file descriptor core API.
 ** ----------------------------------------------------------------- */

static const mmux_libc_file_descriptor_t stdin_fd = { { .value = 0 } };
static const mmux_libc_file_descriptor_t stdou_fd = { { .value = 1 } };
static const mmux_libc_file_descriptor_t stder_fd = { { .value = 2 } };
static const mmux_libc_directory_file_descriptor_t at_fdcwd_fd = { { { .value = MMUX_LIBC_AT_FDCWD } } };

bool
mmux_libc_stdin (mmux_libc_fd_t result_p)
{
  *result_p = stdin_fd;
  return false;
}
bool
mmux_libc_stdou (mmux_libc_fd_t result_p)
{
  *result_p = stdou_fd;
  return false;
}
bool
mmux_libc_stder (mmux_libc_fd_t result_p)
{
  *result_p = stder_fd;
  return false;
}
bool
mmux_libc_at_fdcwd (mmux_libc_dirfd_t result_p)
{
  *result_p = at_fdcwd_fd;
  return false;
}
bool
mmux_libc_make_fd (mmux_libc_fd_t result_p, mmux_standard_sint_t fd_num)
{
  if (0 <= fd_num) {
    result_p->value = fd_num;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_make_dirfd (mmux_libc_dirfd_t dirfd, mmux_standard_sint_t fd_num)
{
  return mmux_libc_make_fd(dirfd, fd_num);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_dprintf (mmux_libc_fd_arg_t fd, mmux_asciizcp_t template, ...)
{
  va_list	ap;
  int		rv;

  va_start(ap, template);
  {
    rv = vdprintf(fd->value, template, ap);
  }
  va_end(ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_dprintfou (mmux_asciizcp_t template, ...)
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
mmux_libc_dprintfer (mmux_asciizcp_t template, ...)
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

bool
mmux_libc_dprintf_strerror (mmux_libc_fd_arg_t fd, mmux_libc_errno_t errnum)
{
  mmux_asciizcp_t	errmsg;

  if (mmux_libc_strerror(&errmsg, errnum)) {
    return true;
  } else if (mmux_libc_dprintf(fd, "%s", errmsg)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_dprintf_strftime (mmux_libc_fd_arg_t fd, mmux_asciizcp_t template, mmux_libc_tm_t * BT)
{
  mmux_usize_t		required_nbytes_including_nil;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-nonliteral"
  if (mmux_libc_strftime_required_nbytes_including_nil(&required_nbytes_including_nil, template, BT)) {
#pragma GCC diagnostic pop
    return true;
  } else {
    char		bufptr[required_nbytes_including_nil.value];
    mmux_usize_t	required_nbytes_without_zero;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-nonliteral"
    if (mmux_libc_strftime(&required_nbytes_without_zero, bufptr, required_nbytes_including_nil, template, BT)) {
#pragma GCC diagnostic pop
      return true;
    } else {
      return mmux_libc_dprintf(fd, "%s", bufptr);
    }
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_vdprintf (mmux_libc_fd_arg_t fd, mmux_asciizcp_t template, va_list ap)
{
  int	rv = vdprintf(fd->value, template, ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_vdprintfou (mmux_asciizcp_t template, va_list ap)
{
  int	rv = vdprintf(stdou_fd.value, template, ap);
  return ((0 <= rv)? false : true);
}
bool
mmux_libc_vdprintfer (mmux_asciizcp_t template, va_list ap)
{
  int	rv = vdprintf(stder_fd.value, template, ap);
  return ((0 <= rv)? false : true);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_dprintf_newline (mmux_libc_fd_arg_t fd)
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
mmux_libc_open (mmux_libc_fd_t fd, mmux_libc_fs_ptn_arg_t pathname,
		mmux_libc_open_flags_t flags, mmux_libc_mode_t mode)
{
  int	fd_num = open(pathname->value, flags.value, mode.value);

  if (-1 != fd_num) {
    return mmux_libc_make_fd(fd, fd_num);
  } else {
    return true;
  }
}
bool
mmux_libc_close (mmux_libc_fd_arg_t fd)
{
  int	rv = close(fd->value);

  return ((-1 != rv)? false : true);
}
bool
mmux_libc_openat (mmux_libc_fd_t fd, mmux_libc_dirfd_arg_t dirfd,
		  mmux_libc_fs_ptn_arg_t pathname,
		  mmux_libc_open_flags_t flags, mmux_libc_mode_t mode)
{
  int	fd_num = openat(dirfd->value, pathname->value, flags.value, mode.value);

  if (-1 != fd_num) {
    return mmux_libc_make_fd(fd, fd_num);
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER]]],[[[bool
mmux_libc_open_how_$1_set (mmux_libc_open_how_t * const P, mmux_$2_t value)
{
  P->$1 = value.value;
  return false;
}
bool
mmux_libc_open_how_$1_ref (mmux_$2_t * result_p, mmux_libc_open_how_t const * const P)
{
  *result_p = mmux_$2(P->$1);
  return false;
}]]])

DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER(flags,	uint64)
DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER(mode,	uint64)
DEFINE_STRUCT_OPEN_HOW_SETTER_GETTER(resolve,	uint64)

bool
mmux_libc_open_how_dump (mmux_libc_fd_arg_t fd, mmux_libc_open_how_t const * const open_how_p,
			 mmux_asciizcp_t struct_name)
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
    if (mmux_libc_dprintf_uint64(fd, value)) {
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
    if (mmux_libc_dprintf_uint64(fd, value)) {
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
    if (mmux_libc_dprintf_uint64(fd, value)) {
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
mmux_libc_openat2 (mmux_libc_fd_t fd, mmux_libc_dirfd_arg_t dirfd,
		   mmux_libc_fs_ptn_arg_t pathname, mmux_libc_open_how_t const * const how_p)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_LINUX_OPENAT2_H]]],[[[
  mmux_standard_slong_t	fdval = syscall(SYS_openat2, dirfd->value, pathname->value, how_p, sizeof(mmux_libc_open_how_t));

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
mmux_libc_read (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd, mmux_pointer_t bufptr, mmux_usize_t buflen)
{
  mmux_standard_ssize_t	nbytes_done = read(fd->value, bufptr, buflen.value);

  if (0 <= nbytes_done) {
    *nbytes_done_p = mmux_usize(nbytes_done);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_write (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  mmux_standard_ssize_t	nbytes_done = write(fd->value, bufptr, buflen.value);

  if (0 <= nbytes_done) {
    *nbytes_done_p = mmux_usize(nbytes_done);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_write_buffer (mmux_libc_fd_arg_t fd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  mmux_usize_t	nbytes_done;
  bool		rv;

  rv = mmux_libc_write(&nbytes_done, fd, bufptr, buflen);
  if (rv || (mmux_ctype_not_equal(buflen, nbytes_done))) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_write_buffer_to_stdou (mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  return mmux_libc_write_buffer(&stdou_fd, bufptr, buflen);
}
bool
mmux_libc_write_buffer_to_stder (mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  return mmux_libc_write_buffer(&stder_fd, bufptr, buflen);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_pread (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd,
		 mmux_pointer_t bufptr, mmux_usize_t buflen,
		 mmux_off_t offset)
{
  mmux_standard_ssize_t	nbytes_done = pread(fd->value, bufptr, buflen.value, offset.value);

  if (0 <= nbytes_done) {
    *nbytes_done_p = mmux_usize(nbytes_done);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_pwrite (mmux_usize_t * nbytes_done_p, mmux_libc_fd_arg_t fd,
		  mmux_pointerc_t bufptr, mmux_usize_t buflen,
		  mmux_off_t offset)
{
  mmux_standard_ssize_t	nbytes_done = pwrite(fd->value, bufptr, buflen.value, offset.value);

  if (0 <= nbytes_done) {
    *nbytes_done_p = mmux_usize(nbytes_done);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_lseek (mmux_libc_fd_arg_t fd, mmux_off_t * offset_p, mmux_sint_t whence)
{
  mmux_standard_off_t	offset = lseek(fd->value, offset_p->value, whence.value);

  if (-1 != offset) {
    *offset_p = mmux_off(offset);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_dup (mmux_libc_fd_t new_fd_p, mmux_libc_fd_arg_t old_fd)
{
  int	fd_num = dup(old_fd->value);

  if (-1 != fd_num) {
    return mmux_libc_make_fd(new_fd_p, fd_num);
  } else {
    return true;
  }
}
bool
mmux_libc_dup2 (mmux_libc_fd_arg_t new_fd, mmux_libc_fd_arg_t old_fd)
{
  int	rv = dup2(old_fd->value, new_fd->value);

  return ((-1 != rv)? false : true);
}
bool
mmux_libc_dup3 (mmux_libc_fd_arg_t new_fd, mmux_libc_fd_arg_t old_fd, mmux_libc_open_flags_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_DUP3]]],[[[
  int	rv = dup3(old_fd->value, new_fd->value, flags.value);

  return ((-1 != rv)? false : true);
]]])
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_pipe (mmux_libc_file_descriptor_t fds[2])
{
  int	fdvals[2];
  int	rv = pipe(fdvals);

  if (-1 != rv) {
    fds[0].value = fdvals[0];
    fds[1].value = fdvals[1];
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_close_pipe (mmux_libc_file_descriptor_t const fds[2])
{
  bool	rv1 = mmux_libc_close(&(fds[0]));
  bool	rv2 = mmux_libc_close(&(fds[1]));

  return ((rv1 || rv2)? true : false);
}


/** --------------------------------------------------------------------
 ** Input/output: file descriptor scatter-gather API.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_POINTER_SETTER_GETTER(iovec,	iov_base)
DEFINE_STRUCT_SETTER_GETTER(iovec,		iov_len,	usize)

/* ------------------------------------------------------------------ */

bool
mmux_libc_iova_base_set (mmux_libc_iovec_array_t * const P, mmux_libc_iovec_t * value)
{
  P->iova_base = value;
  return false;
}
bool
mmux_libc_iova_base_ref (mmux_libc_iovec_t ** result_p, mmux_libc_iovec_array_t const * const P)
{
  *result_p = P->iova_base;
  return false;
}

DEFINE_STRUCT_SETTER_GETTER(iovec_array,	iova_len,	usize)

/* ------------------------------------------------------------------ */

bool
mmux_libc_iovec_dump (mmux_libc_fd_arg_t fd, mmux_libc_iovec_t const * const iovec_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct iovec";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)iovec_p);
  DPRINTF(fd, "%s->iov_base = %p\n", struct_name, iovec_p->iov_base);
  {
    mmux_usize_t	required_nbytes;
    auto		val = mmux_usize(iovec_p->iov_len);

    if (mmux_usize_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_usize_sprint(str, required_nbytes, val)) {
	return true;
      } else {
	DPRINTF(fd, "%s->iov_len = %s\n", struct_name, str);
	return false;
      }
    }
  }
}

bool
mmux_libc_iovec_array_dump (mmux_libc_fd_arg_t fd, mmux_libc_iovec_array_t const * iova_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "mmux_libc_iovec_array_t";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)iova_p);
  DPRINTF(fd, "%s->iova_base = %p\n", struct_name, (mmux_pointer_t)iova_p->iova_base);
  {
    mmux_usize_t	required_nbytes;
    auto		val = mmux_usize(iova_p->iova_len);

    if (mmux_usize_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_usize_sprint(str, required_nbytes, val)) {
	return true;
      } else {
	DPRINTF(fd, "%s->iova_len = %s\n", struct_name, str);
      }
    }
  }

  for (mmux_standard_usize_t i=0; i<iova_p->iova_len; ++i) {
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      return true;
    } else {
      if (mmux_libc_dprintf(mfd, "%s->iova_base[%lu]", struct_name, i)) {
	return true;
      } else {
	mmux_usize_t	buflen;

	if (mmux_libc_memfd_length(&buflen, mfd)) {
	  return true;
	} else {
	  char	bufptr[1+buflen.value];

	  bufptr[buflen.value] = '\0';
	  if (mmux_libc_memfd_read_buffer(mfd, bufptr, buflen)) {
	    return true;
	  } else if (mmux_libc_iovec_dump(fd, &(iova_p->iova_base[i]), bufptr)) {
	    return true;
	  }
	}
      }
    }
    if (mmux_libc_close(mfd)) {
      return true;
    }
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_readv (mmux_usize_t * number_of_bytes_read_p, mmux_libc_fd_arg_t fd, mmux_libc_iovec_array_t * iova_p)
{
  mmux_standard_ssize_t	rv = readv(fd->value, iova_p->iova_base, iova_p->iova_len);

  if (-1 < rv) {
    *number_of_bytes_read_p = mmux_usize(rv);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_writev (mmux_usize_t * number_of_bytes_read_p, mmux_libc_fd_arg_t fd, mmux_libc_iovec_array_t * iova_p)
{
  mmux_standard_ssize_t	rv = writev(fd->value, iova_p->iova_base, iova_p->iova_len);

  if (-1 < rv) {
    *number_of_bytes_read_p = mmux_usize(rv);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_preadv (mmux_usize_t * number_of_bytes_read_p, mmux_libc_fd_arg_t fd,
		  mmux_libc_iovec_array_t * iova_p, mmux_off_t offset)
{
  mmux_standard_ssize_t	rv = preadv(fd->value, iova_p->iova_base, iova_p->iova_len, offset.value);

  if (-1 < rv) {
    *number_of_bytes_read_p = mmux_usize(rv);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_pwritev (mmux_usize_t * number_of_bytes_read_p, mmux_libc_fd_arg_t fd,
		   mmux_libc_iovec_array_t * iova_p, mmux_off_t offset)
{
  mmux_standard_ssize_t	rv = pwritev(fd->value, iova_p->iova_base, iova_p->iova_len, offset.value);

  if (-1 < rv) {
    *number_of_bytes_read_p = mmux_usize(rv);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_preadv2 (mmux_usize_t * number_of_bytes_read_p, mmux_libc_fd_arg_t fd,
		   mmux_libc_iovec_array_t * iova_p,
		   mmux_off_t offset, mmux_sint_t flags)
{
  mmux_standard_ssize_t	rv = preadv2(fd->value, iova_p->iova_base, iova_p->iova_len, offset.value, flags.value);

  if (-1 < rv) {
    *number_of_bytes_read_p = mmux_usize(rv);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_pwritev2 (mmux_usize_t * number_of_bytes_read_p, mmux_libc_fd_arg_t fd,
		    mmux_libc_iovec_array_t * iova_p,
		    mmux_off_t offset, mmux_sint_t flags)
{
  mmux_standard_ssize_t	rv = pwritev2(fd->value, iova_p->iova_base, iova_p->iova_len, offset.value, flags.value);

  if (-1 < rv) {
    *number_of_bytes_read_p = mmux_usize(rv);
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Input/output: file locking.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(flock,	l_type,		sshort)
DEFINE_STRUCT_SETTER_GETTER(flock,	l_whence,	sshort)
DEFINE_STRUCT_SETTER_GETTER(flock,	l_start,	off)
DEFINE_STRUCT_SETTER_GETTER(flock,	l_len,		off)

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
mmux_libc_flag_to_symbol_struct_flock_l_type (mmux_asciizcp_t * const str_p, mmux_sshort_t flag)
{
  /* We use the if statement, rather than  the switch statement, because there may be
     duplicates in the symbols. */
  if (F_RDLCK == flag.value) {
    *str_p = "F_RDLCK";
    return false;
  } else if (F_WRLCK == flag.value) {
    *str_p = "F_WRLCK";
    return false;
  } else if (F_UNLCK == flag.value) {
    *str_p = "F_UNLCK";
    return false;
  } else {
    *str_p = "unknown";
    return true;
  }
}
bool
mmux_libc_flock_dump (mmux_libc_fd_arg_t fd, mmux_libc_flock_t const * const flock_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct flock";
  }

  DPRINTF(fd, "%s = \"%p\"\n", struct_name, (mmux_pointer_t)flock_p);

  /* Print l_type. */
  {
    mmux_usize_t	required_nbytes;
    auto		val = mmux_sshort(flock_p->l_type);

    if (mmux_sshort_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_sshort_sprint(str, required_nbytes, val)) {
	if (mmux_libc_dprintfer("%s: error converting \"l_type\" to string\n", __func__)) {;}
	return true;
      } else {
	mmux_asciizcp_t		symstr;

	if (mmux_libc_flag_to_symbol_struct_flock_l_type(&symstr, val)) {
	  return true;
	}
	DPRINTF(fd, "%s.l_type = \"%s\" (%s)\n", struct_name, str, symstr);
      }
    }
  }

  /* Print l_whence. */
  {
    mmux_usize_t	required_nbytes;
    auto		val = mmux_sshort(flock_p->l_whence);

    if (mmux_sshort_sprint_size(&required_nbytes, val)) {
      if (mmux_libc_dprintfer("%s: error converting \"l_whence\" to string\n", __func__)) {;};
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_sshort_sprint(str, required_nbytes, val)) {
	if (mmux_libc_dprintfer("%s: error converting \"l_whence\" to string\n", __func__)) {;};
	return true;
      } else {
	mmux_asciizcp_t		symstr;

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
    mmux_usize_t	required_nbytes;
    auto		val = mmux_off(flock_p->l_start);

    if (mmux_off_sprint_size(&required_nbytes, val)) {
      if (mmux_libc_dprintfer("%s: error converting \"l_start\" to string\n", __func__)) {;};
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_off_sprint(str, required_nbytes, val)) {
	if (mmux_libc_dprintfer("%s: error converting \"l_start\" to string\n", __func__)) {;};
	return true;
      } else {
	DPRINTF(fd, "%s.l_start = \"%s\"\n", struct_name, str);
      }
    }
  }

  /* Print l_len. */
  {
    mmux_usize_t	required_nbytes;
    auto		val = mmux_off(flock_p->l_len);

    if (mmux_off_sprint_size(&required_nbytes, val)) {
      if (mmux_libc_dprintfer("%s: error converting \"l_len\" to string\n", __func__)) {;};
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_off_sprint(str, required_nbytes, val)) {
	if (mmux_libc_dprintfer("%s: error converting \"l_len\" to string\n", __func__)) {;};
	return true;
      } else {
	DPRINTF(fd, "%s.l_len = \"%s\"\n", struct_name, str);
      }
    }
  }

  /* Print l_pid. */
  {
    mmux_usize_t	required_nbytes;
    auto		val = mmux_libc_pid(flock_p->l_pid);

    if (mmux_libc_pid_sprint_size(&required_nbytes, val)) {
      if (mmux_libc_dprintfer("%s: error converting \"l_pid\" to string\n", __func__)) {;};
      return true;
    } else {
      char	str[required_nbytes.value];

      if (mmux_libc_pid_sprint(str, required_nbytes, val)) {
	if (mmux_libc_dprintfer("%s: error converting \"l_pid\" to string\n", __func__)) {;};
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
mmux_libc_fcntl (mmux_libc_fd_arg_t fd, mmux_sint_t command, mmux_pointer_t parameter_p)
{
  switch (command.value) {

#ifdef MMUX_HAVE_LIBC_F_DUPFD
  case MMUX_LIBC_F_DUPFD: {
    mmux_libc_file_descriptor_t *	new_fd_p = parameter_p;
    mmux_standard_sint_t		rv = fcntl(fd->value, command.value, new_fd_p->value);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETFD
  case MMUX_LIBC_F_GETFD: {
    /* Acquire the flags associated to the file descriptor. */
    mmux_standard_sint_t	rv = fcntl(fd->value, command.value);

    if (-1 != rv) {
      mmux_sint_t *	flags_parameter_p = parameter_p;

      *flags_parameter_p = mmux_sint(rv);
      return false;
    } else {
      return true;
    }
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETFD
  case MMUX_LIBC_F_SETFD: {
    mmux_sint_t *	flags_p = parameter_p;
    int			rv = fcntl(fd->value, command.value, flags_p->value);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETFL
  case MMUX_LIBC_F_GETFL: {
    /* Acquire the flags associated to the open file. */
    mmux_standard_sint_t	rv = fcntl(fd->value, command.value);

    if (-1 != rv) {
      mmux_sint_t *	flags_p = parameter_p;

      *flags_p = mmux_sint(rv);
      return false;
    } else {
      return true;
    }
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETFL
  case MMUX_LIBC_F_SETFL: {
    mmux_sint_t *	flags_p = parameter_p;
    int			rv = fcntl(fd->value, command.value, flags_p->value);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETLK
  case MMUX_LIBC_F_GETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    int				rv = fcntl(fd->value, command.value, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETLK
  case MMUX_LIBC_F_SETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    int				rv = fcntl(fd->value, command.value, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETLKW
  case MMUX_LIBC_F_SETLKW: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    int				rv = fcntl(fd->value, command.value, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_OFD_GETLK
  case MMUX_LIBC_F_OFD_GETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    int				rv = fcntl(fd->value, command.value, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_OFD_SETLK
  case MMUX_LIBC_F_OFD_SETLK: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    int				rv = fcntl(fd->value, command.value, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_OFD_SETLKW
  case MMUX_LIBC_F_OFD_SETLKW: {
    mmux_libc_flock_t *		flock_pointer = parameter_p;
    int				rv = fcntl(fd->value, command.value, flock_pointer);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

#ifdef MMUX_HAVE_LIBC_F_GETOWN
  case MMUX_LIBC_F_GETOWN: {
    mmux_standard_libc_pid_t	rv = fcntl(fd->value, command.value);

    if (-1 != rv) {
      mmux_libc_pid_t *	pid_p = parameter_p;

      return mmux_libc_make_pid(pid_p, rv);
    } else {
      return true;
    }
  }
#endif

#ifdef MMUX_HAVE_LIBC_F_SETOWN
  case MMUX_LIBC_F_SETOWN: {
    mmux_libc_pid_t *	pid_p = parameter_p;
    int			rv = fcntl(fd->value, command.value, pid_p->value);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

  default:
    mmux_libc_errno_set_to_einval();
    return true;
  }
}

bool
mmux_libc_fcntl_command_flag_to_symbol (mmux_asciizcp_t* str_p, mmux_sint_t flag)
{
  /* We use the if statement, rather than  the switch statement, because there may be
     duplicates in the symbols. */
  if (F_DUPFD == flag.value) {
    *str_p = "F_DUPFD";
    return false;
  } else if (F_GETFD == flag.value) {
    *str_p = "F_GETFD";
    return false;
  } else if (F_GETFL == flag.value) {
    *str_p = "F_GETFL";
    return false;
  } else if (F_GETLK == flag.value) {
    *str_p = "F_GETLK";
    return false;
  } else if (F_GETOWN == flag.value) {
    *str_p = "F_GETOWN";
    return false;
  } else if (F_SETFD == flag.value) {
    *str_p = "F_SETFD";
    return false;
  } else if (F_SETFL == flag.value) {
    *str_p = "F_SETFL";
    return false;
  } else if (F_SETLKW == flag.value) {
    *str_p = "F_SETLKW";
    return false;
  } else if (F_SETLK == flag.value) {
    *str_p = "F_SETLK";
    return false;
  } else if (F_SETOWN == flag.value) {
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
mmux_libc_ioctl (mmux_libc_fd_arg_t fd, mmux_sint_t command, mmux_pointer_t parameter_p)
{
  switch (command.value) {

#ifdef MMUX_HAVE_LIBC_SIOCATMARK
  case MMUX_LIBC_SIOCATMARK: { /* synopsis: mmux_libc_ioctl FD SIOCATMARK ATMARK_POINTER */
    mmux_sint_t *	atmark_p = parameter_p;
    int			rv = ioctl(fd->value, command.value, atmark_p->value);

    return ((-1 != rv)? false : true);
  }
#endif

    /* ------------------------------------------------------------------ */

  default:
    mmux_libc_errno_set_to_einval();
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
mmux_libc_FD_SET (mmux_libc_fd_arg_t fd, mmux_libc_fd_set_t * fd_set_p)
{
  FD_SET(fd->value, fd_set_p);
  return false;
}
bool
mmux_libc_FD_CLR (mmux_libc_fd_arg_t fd, mmux_libc_fd_set_t * fd_set_p)
{
  FD_CLR(fd->value, fd_set_p);
  return false;
}
bool
mmux_libc_FD_ISSET (bool * result_p, mmux_libc_fd_arg_t fd, mmux_libc_fd_set_t const * fd_set_p)
{
  *result_p = (FD_ISSET(fd->value, fd_set_p))? true : false;
  return false;
}
bool
mmux_libc_select (mmux_uint_t * nfds_ready, mmux_uint_t maximum_nfds_to_check,
		  mmux_libc_fd_set_t * read_fd_set_p, mmux_libc_fd_set_t * write_fd_set_p, mmux_libc_fd_set_t * except_fd_set_p,
		  mmux_libc_timeval_t * timeout_p)
{
  mmux_standard_sint_t	rv = select(maximum_nfds_to_check.value,
				    read_fd_set_p, write_fd_set_p, except_fd_set_p,
				    timeout_p);

  if (-1 < rv) {
    *nfds_ready = mmux_uint(rv);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_select_fd_for_reading (bool * result_p, mmux_libc_fd_arg_t fd, mmux_libc_timeval_t * timeout_p)
{
  auto			nfds_ready		= mmux_uint_constant_zero();
  auto			maximum_nfds_to_check	= mmux_uint(1 + fd->value);
  mmux_libc_fd_set_t	the_fd_set[1];

  mmux_libc_FD_ZERO(the_fd_set);
  mmux_libc_FD_SET(fd, the_fd_set);

  if (mmux_libc_select(&nfds_ready, maximum_nfds_to_check, the_fd_set, NULL, NULL, timeout_p)) {
    return true;
  } else if (mmux_ctype_is_zero(nfds_ready)) {
    *result_p = false;
    return false;
  } else {
    mmux_libc_FD_ISSET(result_p, fd, the_fd_set);
    return false;
  }
}
bool
mmux_libc_select_fd_for_writing (bool * result_p, mmux_libc_fd_arg_t fd, mmux_libc_timeval_t * timeout_p)
{
  auto			nfds_ready		= mmux_uint_constant_zero();
  auto			maximum_nfds_to_check	= mmux_uint(1 + fd->value);
  mmux_libc_fd_set_t	the_fd_set[1];

  mmux_libc_FD_ZERO(the_fd_set);
  mmux_libc_FD_SET(fd, the_fd_set);

  if (mmux_libc_select(&nfds_ready, maximum_nfds_to_check, NULL, the_fd_set, NULL, timeout_p)) {
    return true;
  } else {
    if ((1 == nfds_ready.value) && (FD_ISSET(fd->value, the_fd_set))) {
      *result_p = true;
    } else {
      *result_p = false;
    }
    return false;
  }
}
bool
mmux_libc_select_fd_for_exception (bool * result_p, mmux_libc_fd_arg_t fd, mmux_libc_timeval_t * timeout_p)
{
  auto			nfds_ready		= mmux_uint_constant_zero();
  auto			maximum_nfds_to_check	= mmux_uint(1 + fd->value);
  mmux_libc_fd_set_t	the_fd_set[1];

  mmux_libc_FD_ZERO(the_fd_set);
  mmux_libc_FD_SET(fd, the_fd_set);

  if (mmux_libc_select(&nfds_ready, maximum_nfds_to_check, NULL, NULL, the_fd_set, timeout_p)) {
    return true;
  } else {
    if ((1 == nfds_ready.value) && (FD_ISSET(fd->value, the_fd_set))) {
      *result_p = true;
    } else {
      *result_p = false;
    }
    return false;
  }
}


/** --------------------------------------------------------------------
 ** Copying file ranges.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_copy_file_range (mmux_usize_t * number_of_bytes_copied_p,
			   mmux_libc_fd_arg_t input_fd, mmux_sint64_t * input_position_p,
			   mmux_libc_fd_arg_t ouput_fd, mmux_sint64_t * ouput_position_p,
			   mmux_usize_t number_of_bytes_to_copy, mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_COPY_FILE_RANGE]]],[[[
  mmux_standard_ssize_t	number_of_bytes_copied = copy_file_range(input_fd->value, &(input_position_p->value),
								 ouput_fd->value, &(ouput_position_p->value),
								 number_of_bytes_to_copy.value,
								 flags.value);

  if (0 <= number_of_bytes_copied) {
    *number_of_bytes_copied_p = mmux_usize(number_of_bytes_copied);
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
mmux_libc_memfd_create (mmux_libc_memfd_t mfd, mmux_asciizcp_t name, mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_MEMFD_CREATE]]],[[[
  mmux_standard_sint_t	rv = memfd_create(name, flags.value);

  if (-1 == rv) {
    return true;
  } else {
    return mmux_libc_make_fd(mfd, rv);
  }
]]])
}
bool
mmux_libc_make_memfd (mmux_libc_memfd_t mfd)
{
  return mmux_libc_memfd_create(mfd, "mmux-cc-libs-memfd-buffer", mmux_sint_constant_zero());
}
bool
mmux_libc_memfd_length (mmux_usize_t * len_p, mmux_libc_memfd_arg_t mfd)
{
  auto	current_offset	= mmux_off_constant_zero();
  auto	size_offset	= mmux_off_constant_zero();

  /* Retrieve the current position. */
  if (mmux_libc_lseek(mfd, &current_offset, MMUX_LIBC_SEEK_CUR)) {
    return true;
  } else if (mmux_libc_lseek(mfd, &size_offset, MMUX_LIBC_SEEK_END)) { /* Retrieve the file size. */
    return true;
  } else if (mmux_libc_lseek(mfd, &current_offset, MMUX_LIBC_SEEK_SET)) { /* Reset the original position. */
    return true;
  } else if (mmux_ctype_is_non_negative(size_offset)) {
    *len_p = mmux_usize(size_offset.value);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_memfd_copy (mmux_libc_fd_arg_t ou, mmux_libc_memfd_arg_t mfd)
{
  bool		rv			= false;
  auto		original_position	= mmux_off_constant_zero();

  /* Acquire the original position. */
  if (mmux_libc_lseek(mfd, &original_position, MMUX_LIBC_SEEK_SET)) {
    return true;
  }

  /* Seek to the beginning. */
  {
    auto	position = mmux_off_constant_zero();

    if (mmux_libc_lseek(mfd, &position, MMUX_LIBC_SEEK_SET)) {
      rv = true;
      goto end_of_function;
    }
  }

  /* Read from input, write to output. */
  {
    auto const			read_buflen = mmux_usize_literal(1024);
    mmux_standard_octet_t	read_bufptr[read_buflen.value];
    mmux_usize_t		nbytes_read;

    /* Loop reading while the number of bytes read is positive. */
    do {
      if (mmux_libc_read(&nbytes_read, mfd, read_bufptr, read_buflen)) {
	rv = true;
	goto end_of_function;
      }

      if (mmux_ctype_is_positive(nbytes_read)) {
	mmux_standard_octet_t *	write_bufptr	= read_bufptr;
	auto			write_buflen	= nbytes_read;
	auto			nbytes_written	= mmux_usize_constant_zero();

	/* Loop writing until we have written all the bytes from the buffer. */
	do {
	  if (mmux_libc_write(&nbytes_written, ou, write_bufptr, write_buflen)) {
	    rv = true;
	    goto end_of_function;
	  }

	  if (mmux_ctype_less(nbytes_written, write_buflen)) {
	    write_bufptr += nbytes_written.value;
	    write_buflen  = mmux_ctype_add(write_buflen, nbytes_written);
	  }
	} while (mmux_ctype_less(nbytes_written, write_buflen));
      }
    } while (mmux_ctype_is_positive(nbytes_read));
  }

 end_of_function:
  /* Restore the original position. */
  if (mmux_libc_lseek(mfd, &original_position, MMUX_LIBC_SEEK_SET)) {
    return true;
  }

  return rv;
}
bool
mmux_libc_memfd_copyou (mmux_libc_memfd_arg_t mfd)
{
  return mmux_libc_memfd_copy(&stdou_fd, mfd);
}
bool
mmux_libc_memfd_copyer (mmux_libc_memfd_arg_t mfd)
{
  return mmux_libc_memfd_copy(&stder_fd, mfd);
}
bool
mmux_libc_memfd_write_buffer (mmux_libc_memfd_arg_t mfd, mmux_pointerc_t bufptr, mmux_usize_t buflen)
{
  mmux_usize_t	nbytes_done;

  if (mmux_libc_write(&nbytes_done, mfd, bufptr, buflen)) {
    return true;
  } else if (mmux_ctype_not_equal(buflen, nbytes_done)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_memfd_write_asciiz (mmux_libc_memfd_arg_t mfd, mmux_asciizcp_t bufptr)
{
  mmux_usize_t	buflen;

  if (mmux_libc_strlen(&buflen, bufptr)) {
    return true;
  } else if (mmux_libc_memfd_write_buffer(mfd, bufptr, buflen)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_memfd_strerror (mmux_libc_memfd_arg_t mfd, mmux_libc_errno_t errnum)
{
  mmux_asciizcp_t	errmsg;

  if (mmux_libc_strerror(&errmsg, errnum)) {
    return true;
  } else if (mmux_libc_memfd_write_asciiz(mfd, errmsg)) {
    return true;
  } else {
    return false;
  }
}

bool
mmux_libc_memfd_read_buffer (mmux_libc_memfd_arg_t mfd, mmux_pointer_t bufptr, mmux_usize_t maximum_buflen)
{
  if (1) {
    auto		offset = mmux_off_constant_zero();
    mmux_usize_t	nbytes_done;

    return mmux_libc_pread(&nbytes_done, mfd, bufptr, maximum_buflen, offset);
  } else {
    auto		position = mmux_off_constant_zero();
    mmux_usize_t	nbytes_done;

    /* Seek to the beginning. */
    if (mmux_libc_lseek(mfd, &position, MMUX_LIBC_SEEK_SET)) {
      return true;
    }
    if (mmux_libc_read(&nbytes_done, mfd, bufptr, maximum_buflen)) {
      return true;
    }
    /* Restore the original position. */
    if (mmux_libc_lseek(mfd, &position, MMUX_LIBC_SEEK_SET)) {
      return true;
    }
    return false;
  }
}


/** --------------------------------------------------------------------
 ** Printing types.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_PRINTER]]],[[[MMUX_CONDITIONAL_CODE([[[$2]]],[[[bool
mmux_libc_dprintf_$1 (mmux_libc_fd_arg_t fd, mmux_$1_t value)
{
  mmux_usize_t	required_nbytes;

  if (mmux_$1_sprint_size(&required_nbytes, value)) {
    return true;
  } else {
    char	s_value[required_nbytes.value];

    if (mmux_$1_sprint(s_value, required_nbytes, value)) {
      return true;
    } else {
      return mmux_libc_dprintf(fd, "%s", s_value);
    }
  }
}]]])]]])

DEFINE_PRINTER([[[pointer]]])

DEFINE_PRINTER([[[schar]]])
DEFINE_PRINTER([[[uchar]]])
DEFINE_PRINTER([[[sshort]]])
DEFINE_PRINTER([[[ushort]]])
DEFINE_PRINTER([[[sint]]])
DEFINE_PRINTER([[[uint]]])
DEFINE_PRINTER([[[slong]]])
DEFINE_PRINTER([[[ulong]]])
DEFINE_PRINTER([[[sllong]]],		[[[MMUX_CC_TYPES_HAS_SLLONG]]])
DEFINE_PRINTER([[[ullong]]],		[[[MMUX_CC_TYPES_HAS_ULLONG]]])

DEFINE_PRINTER([[[sint8]]])
DEFINE_PRINTER([[[uint8]]])
DEFINE_PRINTER([[[sint16]]])
DEFINE_PRINTER([[[uint16]]])
DEFINE_PRINTER([[[sint32]]])
DEFINE_PRINTER([[[uint32]]])
DEFINE_PRINTER([[[sint64]]])
DEFINE_PRINTER([[[uint64]]])

DEFINE_PRINTER([[[flonumfl]]])
DEFINE_PRINTER([[[flonumdb]]])
DEFINE_PRINTER([[[flonumldb]]],		[[[MMUX_CC_TYPES_HAS_FLONUMLDB]]])

DEFINE_PRINTER([[[flonumf32]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF32]]])
DEFINE_PRINTER([[[flonumf64]]],		[[[MMUX_CC_TYPES_HAS_FLONUMF64]]])
DEFINE_PRINTER([[[flonumf128]]],	[[[MMUX_CC_TYPES_HAS_FLONUMF128]]])

DEFINE_PRINTER([[[flonumf32x]]],	[[[MMUX_CC_TYPES_HAS_FLONUMF32X]]])
DEFINE_PRINTER([[[flonumf64x]]],	[[[MMUX_CC_TYPES_HAS_FLONUMF64X]]])
DEFINE_PRINTER([[[flonumf128x]]],	[[[MMUX_CC_TYPES_HAS_FLONUMF128X]]])

DEFINE_PRINTER([[[flonumd32]]],		[[[MMUX_CC_TYPES_HAS_FLONUMD32]]])
DEFINE_PRINTER([[[flonumd64]]],		[[[MMUX_CC_TYPES_HAS_FLONUMD64]]])
DEFINE_PRINTER([[[flonumd128]]],	[[[MMUX_CC_TYPES_HAS_FLONUMD128]]])

DEFINE_PRINTER([[[flonumcfl]]])
DEFINE_PRINTER([[[flonumcdb]]])
DEFINE_PRINTER([[[flonumcldb]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCLDB]]])

DEFINE_PRINTER([[[flonumcf32]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCF32]]])
DEFINE_PRINTER([[[flonumcf64]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCF64]]])
DEFINE_PRINTER([[[flonumcf128]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCF128]]])

DEFINE_PRINTER([[[flonumcf32x]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCF32X]]])
DEFINE_PRINTER([[[flonumcf64x]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCF64X]]])
DEFINE_PRINTER([[[flonumcf128x]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCF128X]]])

DEFINE_PRINTER([[[flonumcd32]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCD32]]])
DEFINE_PRINTER([[[flonumcd64]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCD64]]])
DEFINE_PRINTER([[[flonumcd128]]],	[[[MMUX_CC_TYPES_HAS_FLONUMCD128]]])

DEFINE_PRINTER([[[byte]]])
DEFINE_PRINTER([[[octet]]])

DEFINE_PRINTER([[[usize]]])
DEFINE_PRINTER([[[ssize]]])

DEFINE_PRINTER([[[sintmax]]])
DEFINE_PRINTER([[[uintmax]]])
DEFINE_PRINTER([[[sintptr]]])
DEFINE_PRINTER([[[uintptr]]])
DEFINE_PRINTER([[[ptrdiff]]])
DEFINE_PRINTER([[[off]]])
DEFINE_PRINTER([[[wchar]]])
DEFINE_PRINTER([[[wint]]])
DEFINE_PRINTER([[[time]]])
DEFINE_PRINTER([[[libc_mode]]])
DEFINE_PRINTER([[[libc_pid]]])
DEFINE_PRINTER([[[libc_uid]]])
DEFINE_PRINTER([[[libc_gid]]])
DEFINE_PRINTER([[[libc_socklen]]])
DEFINE_PRINTER([[[libc_rlim]]])
DEFINE_PRINTER([[[libc_ino]]])
DEFINE_PRINTER([[[libc_dev]]])
DEFINE_PRINTER([[[libc_nlink]]])
DEFINE_PRINTER([[[libc_blkcnt]]])

bool
mmux_libc_dprintf_libc_fd (mmux_libc_fd_arg_t fd, mmux_libc_fd_arg_t value)
{
  return mmux_sint_dprintf_p(fd->value, value);
}
bool
mmux_libc_dprintf_fs_ptn (mmux_libc_fd_arg_t fd, mmux_libc_fs_ptn_arg_t pathname)
{
  return mmux_libc_dprintf(fd, "%s", pathname->value);
}
bool
mmux_libc_dprintf_libc_process_completion_status (mmux_libc_fd_arg_t fd, mmux_libc_process_completion_status_t value)
{
  return mmux_sint_dprintf_p(fd->value, &value);
}
bool
mmux_libc_dprintf_libc_interprocess_signal (mmux_libc_fd_arg_t fd, mmux_libc_interprocess_signal_t value)
{
  return mmux_sint_dprintf_p(fd->value, &value);
}
bool
mmux_libc_dprintf_fs_ptn_extension (mmux_libc_fd_arg_t fd, mmux_libc_fs_ptn_extension_arg_t E)
{
  mmux_usize_t	nbytes_done;

  if (mmux_libc_write(&nbytes_done, fd, E->ptr, E->len)) {
    return true;
  } else if (mmux_ctype_not_equal(nbytes_done, E->len)) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_dprintf_fs_ptn_segment (mmux_libc_fd_arg_t fd, mmux_libc_fs_ptn_segment_arg_t E)
{
  mmux_usize_t	nbytes_done;

  if (mmux_libc_write(&nbytes_done, fd, E->ptr, E->len)) {
    return true;
  } else if (mmux_ctype_not_equal(nbytes_done, E->len)) {
    return true;
  } else {
    return false;
  }
}

/* end of file */
