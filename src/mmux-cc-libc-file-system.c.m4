/*
  Part of: MMUX CC Libc
  Contents: file system API
  Date: Dec 19, 2024

  Abstract

	This module implements the file system API.

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

typedef bool mmux_libc_stat_mode_pred_t (bool * result_p, mmux_libc_mode_t mode);

#define DPRINTF(TEMPLATE,...)	if (mmux_libc_dprintf(TEMPLATE,__VA_ARGS__)) { return true; }


/** --------------------------------------------------------------------
 ** Current working directory.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_getcwd (mmux_asciizp_t bufptr, mmux_usize_t buflen)
{
  mmux_asciizp_t	rv = getcwd(bufptr, buflen.value);

  return (rv)? false : true;
}
bool
mmux_libc_getcwd_malloc (mmux_asciizcpp_t result_p)
{
  mmux_asciizp_t	rv = getcwd(NULL, 0);

  if (rv) {
    *result_p = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getcwd_pathname (mmux_libc_fs_ptn_t fs_ptn_result_p, mmux_libc_fs_ptn_factory_arg_t fs_ptn_factory)
{
  mmux_asciizcp_t	bufptr;

  if (mmux_libc_getcwd_malloc(&bufptr)) {
    return true;
  } else if (mmux_libc_make_file_system_pathname(fs_ptn_result_p, fs_ptn_factory, bufptr)) {
    mmux_libc_free((mmux_pointer_t)bufptr);
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_chdir (mmux_libc_fs_ptn_arg_t dirptn)
{
  int	rv = chdir(dirptn->value);

  return (rv)? true : false;
}
bool
mmux_libc_fchdir (mmux_libc_dirfd_arg_t fd)
{
  int	rv = fchdir(fd->value);

  return (rv)? true : false;
}


/** --------------------------------------------------------------------
 ** Root directory.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_chroot (mmux_libc_fs_ptn_arg_t ptn)
{
  int	rv = chroot(ptn->value);

  return (rv)? true : false;
}
bool
mmux_libc_pivot_root (mmux_libc_fs_ptn_arg_t new_root_ptn, mmux_libc_fs_ptn_arg_t put_old_ptn)
{
  int	rv = syscall(SYS_pivot_root, new_root_ptn, put_old_ptn->value);

  return (rv)? true : false;
}


/** --------------------------------------------------------------------
 ** Diretories.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_d_name_ref (mmux_asciizcpp_t result_p, mmux_libc_dirent_t const * DE)
{
  *result_p = DE->d_name;
  return false;
}
bool
mmux_libc_d_fileno_ref (mmux_uintmax_t * result_p, mmux_libc_dirent_t const * DE)
{
  *result_p = mmux_uintmax(DE->d_fileno);
  return false;
}
bool
mmux_libc_dirent_dump (mmux_libc_fd_arg_t fd, mmux_libc_dirent_t const * dirent_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct dirent";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)dirent_p);

  {
    mmux_asciizcp_t		name;
    mmux_uintmax_t		fileno;

    mmux_libc_d_name_ref   (&name,   dirent_p);
    mmux_libc_d_fileno_ref (&fileno, dirent_p);

    DPRINTF(fd, "%s->d_name   = %s\n",  struct_name, name);
    DPRINTF(fd, "%s->d_fileno = ", struct_name);
    if (mmux_ctype_dprintf(2, fileno)) {
      return true;
    }
    DPRINTF(fd, "\n")
  }
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_opendir (mmux_libc_dirstream_t * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  DIR *		rv = opendir(ptn->value);

  if (rv) {
    result_p->value = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_fdopendir (mmux_libc_dirstream_t * result_p, mmux_libc_dirfd_arg_t dirfd)
{
  DIR *		rv = fdopendir(dirfd->value);

  if (rv) {
    result_p->value = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_closedir (mmux_libc_dirstream_t DS)
{
  int	rv = closedir(DS.value);

  return (0 == rv)? false : true;
}
bool
mmux_libc_readdir (mmux_libc_dirent_t ** result_p, mmux_libc_dirstream_t DS)
{
  mmux_libc_dirent_t *	rv;

  /* Setting errno to zero  here is the only way to distinguish an  error from an end
     of stream condition. */
  errno = 0;
  rv    = readdir(DS.value);

  if (NULL == rv) {
    if (errno) {
      /* An error occurred. */
      return true;
    } else {
      /* No more entries from the stream. */
      *result_p = NULL;
      return false;
    }
  } else {
    *result_p = rv;
    return false;
  }
}
bool
mmux_libc_dirfd (mmux_libc_dirfd_t result_p, mmux_libc_dirstream_t dirstream)
{
  int	rv = dirfd(dirstream.value);

  if (-1 == rv) {
    return true;
  } else {
    return mmux_libc_make_dirfd(result_p, rv);
  }
}
bool
mmux_libc_rewinddir (mmux_libc_dirstream_t dirstream)
{
  rewinddir(dirstream.value);
  return false;
}
bool
mmux_libc_telldir (mmux_libc_dirstream_position_t * result_p, mmux_libc_dirstream_t dirstream)
{
  mmux_standard_slong_t	rv = telldir(dirstream.value);

  result_p->value = rv;
  return false;
}
bool
mmux_libc_seekdir (mmux_libc_dirstream_t dirstream, mmux_libc_dirstream_position_t dirpos)
{
  seekdir(dirstream.value, dirpos.value);
  return false;
}


/** --------------------------------------------------------------------
 ** File system: links.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_link (mmux_libc_fs_ptn_arg_t oldname, mmux_libc_fs_ptn_arg_t newname)
{
  int	rv = link(oldname->value, newname->value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_linkat (mmux_libc_dirfd_arg_t dirfd_old, mmux_libc_fs_ptn_arg_t oldname,
		  mmux_libc_dirfd_arg_t dirfd_new, mmux_libc_fs_ptn_arg_t newname,
		  mmux_libc_linkat_flags_t flags)
{
  if (MMUX_LIBC_AT_EMPTY_PATH & flags.value) {
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  } else {
    int	rv = linkat(dirfd_old->value, oldname->value,
		    dirfd_new->value, newname->value,
		    flags.value);

    return ((0 == rv)? false : true);
  }
}
bool
mmux_libc_linkfd (mmux_libc_fd_arg_t fd_old,
		  mmux_libc_dirfd_arg_t dirfd_new, mmux_libc_fs_ptn_arg_t newname,
		  mmux_libc_linkat_flags_t flags)
{
#ifdef MMUX_HAVE_LIBC_AT_EMPTY_PATH
  int	rv = linkat(fd_old->value, "",
		    dirfd_new->value, newname->value,
		    (flags.value | MMUX_LIBC_AT_EMPTY_PATH));

  return ((0 == rv)? false : true);
#else
  mmux_libc_errno_set(MMUX_LIBC_ENOSYS);
  return true;
#endif
}
bool
mmux_libc_symlink (mmux_libc_fs_ptn_arg_t oldname, mmux_libc_fs_ptn_arg_t newname)
{
  int	rv = symlink(oldname->value, newname->value);

  return ((0 == rv)? false : true);
}

bool
mmux_libc_symlinkat (mmux_libc_fs_ptn_arg_t oldname,
		     mmux_libc_dirfd_arg_t dirfd_new,
		     mmux_libc_fs_ptn_arg_t newname)
{
  int	rv = symlinkat(oldname->value, dirfd_new->value, newname->value);

  return ((0 == rv)? false : true);
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_readlink_from_asciiz_buffer_to_ascii_buffer (mmux_usize_t *	nbytes_written_to_output_buffer_no_nul_p,
						       mmux_asciip_t	output_buffer_ascii,
						       mmux_usize_t	output_buffer_provided_nbytes_no_nul,
						       mmux_asciizcp_t	input_linkname_asciiz)
{
  mmux_standard_ssize_t	nbytes_written_to_output_buffer_no_nul =
    readlink(input_linkname_asciiz, output_buffer_ascii, output_buffer_provided_nbytes_no_nul.value);

  if (nbytes_written_to_output_buffer_no_nul < 0) {
    return true;
  } else {
    *nbytes_written_to_output_buffer_no_nul_p = mmux_usize(nbytes_written_to_output_buffer_no_nul);
    return false;
  }
}
static bool
mmux_libc_readlink_from_asciiz_buffer_to_fs_ptn (mmux_libc_fs_ptn_t		fs_ptn_result,
						 mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
						 mmux_asciizcp_t		input_linkname_asciiz)
{
  auto	output_buffer_provided_nbytes_no_nul = mmux_usize_literal(64);

  for (;;) {
    char		output_buffer_ascii[output_buffer_provided_nbytes_no_nul.value];
    mmux_usize_t	nbytes_written_to_output_buffer_no_nul;

    if (mmux_libc_readlink_from_asciiz_buffer_to_ascii_buffer(&nbytes_written_to_output_buffer_no_nul,
							      output_buffer_ascii,
							      output_buffer_provided_nbytes_no_nul,
							      input_linkname_asciiz)) {
      return true;
    } else if (mmux_ctype_equal(output_buffer_provided_nbytes_no_nul, nbytes_written_to_output_buffer_no_nul)) {
      /* There was not enough room in the output buffer. */
      mmux_ctype_add_to_variable(output_buffer_provided_nbytes_no_nul, mmux_usize_literal(64));
      if (mmux_ctype_less(MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_NO_NUL_ARBITRARY_LIMIT,
			  output_buffer_provided_nbytes_no_nul)) {
	mmux_libc_errno_set(MMUX_LIBC_ENAMETOOLONG);
	return true;
      }
    } else {
      return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory,
						  output_buffer_ascii,
						  nbytes_written_to_output_buffer_no_nul);
    }
  }
}
bool
mmux_libc_readlink_to_buffer (mmux_usize_t *		nbytes_written_to_output_buffer_no_nul_p,
			      mmux_asciip_t		output_buffer_ascii,
			      mmux_usize_t		output_buffer_provided_nbytes_no_nul,
			      mmux_libc_fs_ptn_arg_t	fs_ptn_input_linkname)
{
  return mmux_libc_readlink_from_asciiz_buffer_to_ascii_buffer(nbytes_written_to_output_buffer_no_nul_p,
							       output_buffer_ascii,
							       output_buffer_provided_nbytes_no_nul,
							       fs_ptn_input_linkname->value);
}
bool
mmux_libc_readlink (mmux_libc_fs_ptn_t			fs_ptn_result,
		    mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
		    mmux_libc_fs_ptn_arg_t		fs_ptn_input_linkname)
{
  return mmux_libc_readlink_from_asciiz_buffer_to_fs_ptn(fs_ptn_result, fs_ptn_factory, fs_ptn_input_linkname->value);
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_readlinkat_from_asciiz_buffer_to_ascii_buffer (mmux_usize_t *		nbytes_written_to_output_buffer_no_nul_p,
							 mmux_asciip_t		output_buffer_ascii,
							 mmux_usize_t		output_buffer_provided_nbytes_no_nul,
							 mmux_standard_sint_t	fd_num,
							 mmux_asciizcp_t	input_linkname_asciiz)
/* If the  argument "input_linkname_asciiz" is not  empty: read the file  system link
 * pathname in "input_linkname_asciiz", relative to "fd_num".
 *
 * If the argument "input_linkname_asciiz" is the  empty string: read the file system
 * link pathname associated to "fd_num".
 *
 * Store   the  resulting   pathname  in   "output_buffer_ascii",  whose   length  is
 * "output_buffer_provided_nbytes_no_nul".
 *
 * If no error occurs when calling  "readlinkat()" the returned value is "false", but
 * the caller needs to check if the output buffer is wide enough to contain the whole
 * output pathname not nul-terminated.
 *
 * See "mmux_libc_readlinkat_from_asciiz_buffer_to_fs_ptn()" below  for an example of
 * how to use this function.
 */
{
  mmux_standard_ssize_t	nbytes_written_to_output_buffer_no_nul =
    readlinkat(fd_num,
	       input_linkname_asciiz,
	       output_buffer_ascii,
	       output_buffer_provided_nbytes_no_nul.value);

  if (nbytes_written_to_output_buffer_no_nul < 0) {
    /* The global variable "errno" is set to the error code. */
    return true;
  } else {
    *nbytes_written_to_output_buffer_no_nul_p = mmux_usize(nbytes_written_to_output_buffer_no_nul);
    return false;
  }
}
static bool
mmux_libc_readlinkat_from_asciiz_buffer_to_fs_ptn (mmux_libc_fs_ptn_t			fs_ptn_result,
						   mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
						   mmux_standard_sint_t			fd_num,
						   mmux_asciizcp_t			input_linkname_asciiz)
{
  auto	output_buffer_provided_nbytes_no_nul = mmux_usize_literal(64);

  for (;;) {
    char		output_buffer_ascii[output_buffer_provided_nbytes_no_nul.value];
    mmux_usize_t	nbytes_written_to_output_buffer_no_nul;

    if (mmux_libc_readlinkat_from_asciiz_buffer_to_ascii_buffer(&nbytes_written_to_output_buffer_no_nul,
								output_buffer_ascii,
								output_buffer_provided_nbytes_no_nul,
								fd_num,
								input_linkname_asciiz)) {
      return true;
    } else if (mmux_ctype_equal(output_buffer_provided_nbytes_no_nul, nbytes_written_to_output_buffer_no_nul)) {
      /* There was not enough room in the output buffer. */
      mmux_ctype_add_to_variable(output_buffer_provided_nbytes_no_nul, mmux_usize_literal(64));
      if (mmux_ctype_less(MMUX_LIBC_FILE_SYSTEM_PATHNAME_LENGTH_NO_NUL_ARBITRARY_LIMIT,
			  output_buffer_provided_nbytes_no_nul)) {
	mmux_libc_errno_set(MMUX_LIBC_ENAMETOOLONG);
	return true;
      }
    } else {
      return mmux_libc_make_file_system_pathname2(fs_ptn_result, fs_ptn_factory,
						  output_buffer_ascii,
						  nbytes_written_to_output_buffer_no_nul);
    }
  }
}
bool
mmux_libc_readlinkat_to_buffer (mmux_usize_t *		nbytes_written_to_output_buffer_no_nul_p,
				mmux_asciip_t		output_buffer_ascii,
				mmux_usize_t		output_buffer_provided_nbytes_no_nul,
				mmux_libc_dirfd_arg_t	dirfd,
				mmux_libc_fs_ptn_arg_t	fs_ptn_input_linkname)
{
  return mmux_libc_readlinkat_from_asciiz_buffer_to_ascii_buffer(nbytes_written_to_output_buffer_no_nul_p,
								 output_buffer_ascii,
								 output_buffer_provided_nbytes_no_nul,
								 dirfd->value,
								 fs_ptn_input_linkname->value);
}
bool
mmux_libc_readlinkfd_to_buffer (mmux_usize_t *		nbytes_written_to_output_buffer_no_nul_p,
				mmux_asciip_t		output_buffer_ascii,
				mmux_usize_t		output_buffer_provided_nbytes_no_nul,
				mmux_libc_fd_arg_t	fd)
{
  return mmux_libc_readlinkat_from_asciiz_buffer_to_ascii_buffer(nbytes_written_to_output_buffer_no_nul_p,
								 output_buffer_ascii,
								 output_buffer_provided_nbytes_no_nul,
								 fd->value,
								 "");
}
bool
mmux_libc_readlinkat (mmux_libc_fs_ptn_t		fs_ptn_result,
		      mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
		      mmux_libc_dirfd_arg_t		dirfd,
		      mmux_libc_fs_ptn_arg_t		fs_ptn_input_linkname)
{
  return mmux_libc_readlinkat_from_asciiz_buffer_to_fs_ptn(fs_ptn_result,
							   fs_ptn_factory,
							   dirfd->value,
							   fs_ptn_input_linkname->value);
}
bool
mmux_libc_readlinkfd (mmux_libc_fs_ptn_t		fs_ptn_result,
		      mmux_libc_fs_ptn_factory_arg_t	fs_ptn_factory,
		      mmux_libc_fd_arg_t		fd)
{
  return mmux_libc_readlinkat_from_asciiz_buffer_to_fs_ptn(fs_ptn_result,
							   fs_ptn_factory,
							   fd->value,
							   "");
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_canonicalize_file_name (mmux_libc_fs_ptn_t		fs_ptn_result,
				  mmux_libc_fs_ptn_factory_t	fs_ptn_factory,
				  mmux_libc_fs_ptn_arg_t	fs_ptn_input)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_CANONICALIZE_FILE_NAME]]],[[[
  mmux_asciizp_t	asciiz_output_pathname = canonicalize_file_name(fs_ptn_input->value);

  if (NULL == asciiz_output_pathname) {
    return true;
  } else {
    bool	rv = mmux_libc_make_file_system_pathname(fs_ptn_result, fs_ptn_factory, asciiz_output_pathname);
    mmux_libc_free(asciiz_output_pathname);
    return rv;
  }
]]])
}
bool
mmux_libc_realpath (mmux_libc_fs_ptn_t		fs_ptn_result,
		    mmux_libc_fs_ptn_factory_t	fs_ptn_factory,
		    mmux_libc_fs_ptn_arg_t	fs_ptn_input)
{
  mmux_asciizp_t	asciiz_output_pathname = realpath(fs_ptn_input->value, NULL);

  if (NULL == asciiz_output_pathname) {
    return true;
  } else {
    bool	rv = mmux_libc_make_file_system_pathname(fs_ptn_result, fs_ptn_factory, asciiz_output_pathname);
    mmux_libc_free(asciiz_output_pathname);
    return rv;
  }
}

bool
mmux_libc_unlink (mmux_libc_fs_ptn_arg_t pathname)
{
  int	rv = unlink(pathname->value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_unlinkat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname, mmux_sint_t flags)
{
  int	rv = unlinkat(dirfd->value, pathname->value, flags.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_rmdir (mmux_libc_fs_ptn_arg_t pathname)
{
  int	rv = rmdir(pathname->value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_remove (mmux_libc_fs_ptn_arg_t pathname)
{
  int	rv = remove(pathname->value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_rename (mmux_libc_fs_ptn_arg_t oldname, mmux_libc_fs_ptn_arg_t newname)
{
  int	rv = rename(oldname->value, newname->value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_renameat (mmux_libc_fd_arg_t olddirfd, mmux_libc_fs_ptn_arg_t oldname,
		    mmux_libc_fd_arg_t newdirfd, mmux_libc_fs_ptn_arg_t newname)
{
  int	rv = renameat(olddirfd->value, oldname->value, newdirfd->value, newname->value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_renameat2 (mmux_libc_fd_arg_t olddirfd, mmux_libc_fs_ptn_arg_t oldname,
		     mmux_libc_fd_arg_t newdirfd, mmux_libc_fs_ptn_arg_t newname,
		     mmux_uint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_RENAMEAT2]]],[[[
  int	rv = renameat2(olddirfd->value, oldname->value, newdirfd->value, newname->value, flags.value);

  return ((0 == rv)? false : true);
]]])
}


/** --------------------------------------------------------------------
 ** Directories.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_mkdir (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_mode_t mode)
{
  int	rv = mkdir(pathname->value, mode.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_mkdirat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname, mmux_libc_mode_t mode)
{
  int	rv = mkdirat(dirfd->value, pathname->value, mode.value);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** File ownership.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_chown (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
{
  int	rv = chown(pathname->value, uid.value, gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchown (mmux_libc_fd_arg_t fd, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
{
  int	rv = fchown(fd->value, uid.value, gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_lchown (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
{
  int	rv = lchown(pathname->value, uid.value, gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchownat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname,
		    mmux_libc_uid_t uid, mmux_libc_gid_t gid, mmux_sint_t flags)
{
  int	rv = fchownat(dirfd->value, pathname->value, uid.value, gid.value, flags.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_chownfd (mmux_libc_fd_arg_t fd, mmux_libc_uid_t uid, mmux_libc_gid_t gid, mmux_sint_t flags)
{
  int	rv;

  flags.value |= MMUX_LIBC_AT_EMPTY_PATH;
  rv = fchownat(fd->value, "", uid.value, gid.value, flags.value);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** File access permissions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_umask (mmux_libc_mode_t * old_mask_p, mmux_libc_mode_t new_mask)
{
  *old_mask_p = mmux_libc_mode(umask(new_mask.value));
  return false;
}
bool
mmux_libc_getumask (mmux_libc_mode_t * current_mask_p)
{
  auto		current_mask = mmux_libc_mode(umask(0));

  umask(current_mask.value);
  *current_mask_p = current_mask;
  return false;
}
bool
mmux_libc_chmod (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_mode_t mode)
{
  int	rv = chmod(pathname->value, mode.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchmod (mmux_libc_fd_arg_t fd, mmux_libc_mode_t mode)
{
  int	rv = fchmod(fd->value, mode.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchmodat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname,
		    mmux_libc_mode_t mode, mmux_sint_t flags)
{
  int	rv = fchmodat(dirfd->value, pathname->value, mode.value, flags.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_access (bool * access_is_permitted_p, mmux_libc_fs_ptn_arg_t pathname, mmux_sint_t how)
{
  int	rv;

  mmux_libc_errno_clear();
  rv = access(pathname->value, how.value);

  if (0 == rv) {
    *access_is_permitted_p = true;
    return false;
  } else {
    mmux_libc_errno_t		errnum;

    mmux_libc_errno_consume(&errnum);
    if (mmux_libc_equal(MMUX_LIBC_EACCES, errnum)) {
      /* The specified access is NOT permitted. */
      *access_is_permitted_p = false;
      return false;
    } else {
      /* An error occurred, the error code is in "errno". */
      return true;
    }
  }
}
bool
mmux_libc_faccessat (bool * access_is_permitted_p, mmux_libc_dirfd_arg_t dirfd,
		     mmux_libc_fs_ptn_arg_t pathname, mmux_sint_t how, mmux_sint_t flags)
{
  int	rv;

  mmux_libc_errno_clear();
  rv = faccessat(dirfd->value, pathname->value, how.value, flags.value);

  if (0 == rv) {
    *access_is_permitted_p = true;
    return false;
  } else {
    mmux_libc_errno_t	errnum;

    mmux_libc_errno_consume(&errnum);
    if (mmux_libc_equal(MMUX_LIBC_EACCES, errnum)) {
      /* The specified access is NOT permitted. */
      *access_is_permitted_p = false;
      return false;
    } else {
      /* An error occurred, the error code is in "errno". */
      return true;
    }
  }
}
bool
mmux_libc_faccessat2 (bool * access_is_permitted_p, mmux_libc_dirfd_arg_t dirfd,
		      mmux_libc_fs_ptn_arg_t pathname, mmux_sint_t how, mmux_sint_t flags)
{
  int	rv;

  mmux_libc_errno_clear();
  rv = syscall(SYS_faccessat2, dirfd->value, pathname->value, how.value, flags.value);

  if (0 == rv) {
    *access_is_permitted_p = true;
    return false;
  } else {
    mmux_libc_errno_t	errnum;

    mmux_libc_errno_consume(&errnum);
    if (mmux_libc_equal(MMUX_LIBC_EACCES, errnum)) {
      /* The specified access is NOT permitted. */
      *access_is_permitted_p = false;
      return false;
    } else {
      /* An error occurred, the error code is in "errno". */
      return true;
    }
  }
}


/** --------------------------------------------------------------------
 ** Truncating file size.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_truncate (mmux_libc_fs_ptn_arg_t pathname, mmux_off_t len)
{
  int	rv = truncate(pathname->value, len.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_ftruncate (mmux_libc_fd_arg_t fd, mmux_off_t len)
{
  int	rv = ftruncate(fd->value, len.value);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** File attributes.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_st_mode_set (mmux_libc_stat_t * stat_p, mmux_libc_mode_t value)
{
  stat_p->st_mode = value.value;
  return false;
}
bool
mmux_libc_st_ino_set (mmux_libc_stat_t * stat_p, mmux_libc_ino_t value)
{
  stat_p->st_ino = value.value;
  return false;
}
bool
mmux_libc_st_dev_set (mmux_libc_stat_t * stat_p, mmux_libc_dev_t value)
{
  stat_p->st_dev = value.value;
  return false;
}
bool
mmux_libc_st_nlink_set (mmux_libc_stat_t * stat_p, mmux_libc_nlink_t value)
{
  stat_p->st_nlink = value.value;
  return false;
}
bool
mmux_libc_st_uid_set (mmux_libc_stat_t * stat_p, mmux_libc_uid_t value)
{
  stat_p->st_uid = value.value;
  return false;
}
bool
mmux_libc_st_gid_set (mmux_libc_stat_t * stat_p, mmux_libc_gid_t value)
{
  stat_p->st_gid = value.value;
  return false;
}
bool
mmux_libc_st_size_set (mmux_libc_stat_t * stat_p, mmux_off_t value)
{
  stat_p->st_size = value.value;
  return false;
}
bool
mmux_libc_st_atime_sec_set (mmux_libc_stat_t * stat_p, mmux_time_t value)
{
  stat_p->st_atim.tv_sec = value.value;
  return false;
}
bool
mmux_libc_st_atime_nsec_set (mmux_libc_stat_t * stat_p, mmux_slong_t value)
{
  stat_p->st_atim.tv_nsec = value.value;
  return false;
}
bool
mmux_libc_st_mtime_sec_set (mmux_libc_stat_t * stat_p, mmux_time_t value)
{
  stat_p->st_atim.tv_sec = value.value;
  return false;
}
bool
mmux_libc_st_mtime_nsec_set (mmux_libc_stat_t * stat_p, mmux_slong_t value)
{
  stat_p->st_atim.tv_nsec = value.value;
  return false;
}
bool
mmux_libc_st_ctime_sec_set (mmux_libc_stat_t * stat_p, mmux_time_t value)
{
  stat_p->st_atim.tv_sec = value.value;
  return false;
}
bool
mmux_libc_st_ctime_nsec_set (mmux_libc_stat_t * stat_p, mmux_slong_t value)
{
  stat_p->st_atim.tv_nsec = value.value;
  return false;
}
bool
mmux_libc_st_blocks_set (mmux_libc_stat_t * stat_p, mmux_libc_blkcnt_t value)
{
  stat_p->st_blocks = value.value;
  return false;
}
bool
mmux_libc_st_blksize_set (mmux_libc_stat_t * stat_p, mmux_uint_t value)
{
  stat_p->st_blksize = value.value;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_st_mode_ref (mmux_libc_mode_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_libc_mode(stat_p->st_mode);
  return false;
}
bool
mmux_libc_st_ino_ref (mmux_libc_ino_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_libc_ino(stat_p->st_ino);
  return false;
}
bool
mmux_libc_st_dev_ref (mmux_libc_dev_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_libc_dev(stat_p->st_dev);
  return false;
}
bool
mmux_libc_st_nlink_ref (mmux_libc_nlink_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_libc_nlink(stat_p->st_nlink);
  return false;
}
bool
mmux_libc_st_uid_ref (mmux_libc_uid_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  return mmux_libc_make_uid(value_p, stat_p->st_uid);
}
bool
mmux_libc_st_gid_ref (mmux_libc_gid_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  return mmux_libc_make_gid(value_p, stat_p->st_gid);
}
bool
mmux_libc_st_size_ref (mmux_off_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_off(stat_p->st_size);
  return false;
}
bool
mmux_libc_st_atime_sec_ref (mmux_time_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_time(stat_p->st_atim.tv_sec);
  return false;
}
bool
mmux_libc_st_atime_nsec_ref (mmux_slong_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_slong(stat_p->st_atim.tv_nsec);
  return false;
}
bool
mmux_libc_st_mtime_sec_ref (mmux_time_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_time(stat_p->st_atim.tv_sec);
  return false;
}
bool
mmux_libc_st_mtime_nsec_ref (mmux_slong_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_slong(stat_p->st_atim.tv_nsec);
  return false;
}
bool
mmux_libc_st_ctime_sec_ref (mmux_time_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_time(stat_p->st_atim.tv_sec);
  return false;
}
bool
mmux_libc_st_ctime_nsec_ref (mmux_slong_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_slong(stat_p->st_atim.tv_nsec);
  return false;
}
bool
mmux_libc_st_blocks_ref (mmux_libc_blkcnt_t * value_p, mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_libc_blkcnt(stat_p->st_blocks);
  return false;
}
bool
mmux_libc_st_blksize_ref (mmux_uint_t * value_p, mmux_libc_stat_t const * stat_p)
{
  *value_p = mmux_uint(stat_p->st_blksize);
  return false;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_stat_dump_time (mmux_libc_fd_arg_t fd, mmux_time_t T)
{
  mmux_asciizcp_t	template = "%Y-%m-%dT%H:%M:%S%z";
  mmux_libc_tm_t *	BT;
  mmux_usize_t		required_nbytes_including_nil;

  mmux_libc_gmtime(&BT, T);
_Pragma("GCC diagnostic push")
_Pragma("GCC diagnostic ignored \"-Wformat-nonliteral\"")
  if (mmux_libc_strftime_required_nbytes_including_nil(&required_nbytes_including_nil, template, BT)) {
_Pragma("GCC diagnostic pop")
    return true;
  } else {
    char		bufptr[required_nbytes_including_nil.value];
    mmux_usize_t	required_nbytes_without_zero;

_Pragma("GCC diagnostic push")
_Pragma("GCC diagnostic ignored \"-Wformat-nonliteral\"")
    if (mmux_libc_strftime(&required_nbytes_without_zero, bufptr, required_nbytes_including_nil, template, BT)) {
_Pragma("GCC diagnostic pop")
      return true;
    } else {
      DPRINTF(fd, " (%s)\n", bufptr);
      return false;
    }
  }
}
bool
mmux_libc_stat_dump (mmux_libc_fd_arg_t fd, mmux_libc_stat_t const * const stat_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct stat";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)stat_p);

  /* Dump the field st_mode. */
  {
    auto		val = mmux_libc_mode(stat_p->st_mode);
    mmux_usize_t	required_nbytes;

    if (mmux_libc_mode_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_libc_mode_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_mode = %s", struct_name, str);
      {
	mmux_asciizcp_t	type;

	if (S_ISDIR(stat_p->st_mode)) {
	  type = "directory";
	} else if (S_ISCHR(stat_p->st_mode)) {
	  type = "character special device";
	} else if (S_ISBLK(stat_p->st_mode)) {
	  type = "block special device";
	} else if (S_ISREG(stat_p->st_mode)) {
	  type = "regular file";
	} else if (S_ISLNK(stat_p->st_mode)) {
	  type = "symbolic link";
	} else if (S_ISSOCK(stat_p->st_mode)) {
	  type = "socket";
	} else if (S_ISFIFO(stat_p->st_mode)) {
	  type = "FIFO";
	} else if (S_TYPEISMQ(stat_p)) {
	  type = "message queue";
	} else if (S_TYPEISSEM(stat_p)) {
	  type = "semaphore object";
	} else if (S_TYPEISSHM(stat_p)) {
	  type = "shared memory object";
	} else {
	  type = "unknown device";
	}
	DPRINTF(fd, " (%s)\n", type);
      }
    }
  }

  /* Dump the field st_ino. */
  {
    auto		val = mmux_libc_ino(stat_p->st_ino);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_ino = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_dev. */
  {
    auto		val = mmux_libc_dev(stat_p->st_dev);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_dev = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_nlink. */
  {
    auto		val = mmux_libc_nlink(stat_p->st_nlink);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_nlink = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_uid. */
  {
    auto		val = mmux_libc_uid(stat_p->st_uid);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_uid = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_gid. */
  {
    auto		val = mmux_libc_gid(stat_p->st_gid);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_gid = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_size. */
  {
    auto		val = mmux_off(stat_p->st_size);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_size = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_atim.tv_sec. */
  {
    auto		val = mmux_time(stat_p->st_atim.tv_sec);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_atim.tv_sec = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_atim.tv_nsec. */
  {
    auto		val = mmux_slong(stat_p->st_atim.tv_nsec);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_atim.tv_nsec = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_mtim.tv_sec. */
  {
    auto		val = mmux_time(stat_p->st_mtim.tv_sec);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_mtim.tv_sec = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_mtim.tv_nsec. */
  {
    auto		val = mmux_slong(stat_p->st_mtim.tv_nsec);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_mtim.tv_nsec = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_ctim.tv_sec. */
  {
    auto		val = mmux_time(stat_p->st_ctim.tv_sec);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_ctim.tv_sec = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_ctim.tv_nsec. */
  {
    auto		val = mmux_slong(stat_p->st_ctim.tv_nsec);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_ctim.tv_nsec = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_blocks. */
  {
    auto		val = mmux_libc_blkcnt(stat_p->st_blocks);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_blocks = %s\n", struct_name, str);
    }
  }

  /* Dump the field st_blksize. */
  {
    auto		val = mmux_uint(stat_p->st_blksize);
    mmux_usize_t	required_nbytes;

    if (mmux_ctype_sprint_size(&required_nbytes, val)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_ctype_sprint(str, required_nbytes, val);
      DPRINTF(fd, "%s->st_blksize = %s\n", struct_name, str);
    }
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_stat (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_stat_t * stat_p)
{
  int	rv = stat(pathname->value, stat_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fstat (mmux_libc_fd_arg_t fd, mmux_libc_stat_t * stat_p)
{
  int	rv = fstat(fd->value, stat_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_lstat (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_stat_t * stat_p)
{
  int	rv = lstat(pathname->value, stat_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fstatat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t pathname,
		   mmux_libc_stat_t * stat_p, mmux_sint_t flags)
{
  int	rv = fstatat(dirfd->value, pathname->value, stat_p, flags.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_statfd (mmux_libc_fd_arg_t fd, mmux_libc_stat_t * stat_p, mmux_sint_t flags)
{
  int	rv;

  flags.value |= MMUX_LIBC_AT_EMPTY_PATH;
  rv = fstatat(fd->value, "", stat_p, flags.value);

  return ((0 == rv)? false : true);
}

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STAT_PTR_PREDICATE]]],[[[bool
mmux_libc_$1 (bool * result_p, mmux_libc_stat_t * stat_p)
{
  *result_p = ($1(stat_p))? true : false;
  return false;
}]]])

DEFINE_STAT_PTR_PREDICATE([[[S_TYPEISMQ]]])
DEFINE_STAT_PTR_PREDICATE([[[S_TYPEISSEM]]])
DEFINE_STAT_PTR_PREDICATE([[[S_TYPEISSHM]]])

m4_define([[[DEFINE_STAT_MODE_PREDICATE]]],[[[bool
mmux_libc_$1 (bool * result_p, mmux_libc_mode_t mode)
{
  *result_p = ($1(mode.value))? true : false;
  return false;
}]]])

DEFINE_STAT_MODE_PREDICATE([[[S_ISDIR]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISCHR]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISBLK]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISREG]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISFIFO]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISLNK]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISSOCK]]])

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_exists (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  mmux_libc_stat_t	stru;

  /* We  use "lstat()",  rather  than "stat()",  because  we do  not  want to  follow
     symlinks. */
  if (mmux_libc_lstat(ptn, &stru)) {
    mmux_libc_errno_t		errnum;

    mmux_libc_errno_consume(&errnum);
    if (mmux_libc_equal(MMUX_LIBC_ENOENT, errnum)) {
      /* The directory entry does not exist.  This function was successful. */
      *result_p = false;
      return false;
    } else {
      /* An error occurred in "lstat()". */
      return true;
    }
  } else {
    if (0) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      mmux_libc_stat_dump(er, &stru, NULL);
    }
    /* The directory entry exists. */
    *result_p = true;
    return false;
  }
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_file_system_pathname_is_predicate (bool * result_p, mmux_libc_fs_ptn_arg_t ptn, mmux_libc_stat_mode_pred_t * pred)
{
  mmux_libc_stat_t	stru;

  /* We  use "lstat()",  rather  than "stat()",  because  we do  not  want to  follow
     symlinks. */
  if (mmux_libc_lstat(ptn, &stru)) {
    mmux_libc_errno_t		errnum;

    mmux_libc_errno_consume(&errnum);
    if (mmux_libc_equal(MMUX_LIBC_ENOENT, errnum)) {
      /* The directory entry does not exist.  This function was successful. */
      *result_p = false;
      return false;
    } else {
      /* An error occurred in "lstat()". */
      return true;
    }
  } else {
    mmux_libc_mode_t		mode;

    if (mmux_libc_st_mode_ref(&mode, &stru)) {
      return true;
    } else /* The directory entry exists. */ if (pred(result_p, mode)) {
	return true;
      } else {
	return false;
      }
  }
}

m4_define([[[DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE]]],[[[bool
mmux_libc_file_system_pathname_is_$1 (bool * result_p, mmux_libc_fs_ptn_arg_t ptn)
{
  return mmux_libc_file_system_pathname_is_predicate(result_p, ptn, mmux_libc_$2);
}]]])

DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE([[[regular]]],		[[[S_ISREG]]])
DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE([[[symlink]]],		[[[S_ISLNK]]])
DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE([[[directory]]],		[[[S_ISDIR]]])
DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE([[[character_special]]],	[[[S_ISCHR]]])
DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE([[[block_special]]],	[[[S_ISBLK]]])
DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE([[[fifo]]],		[[[S_ISFIFO]]])
DEFINE_FILE_SYSTEM_PATHNAME_PREDICATE([[[socket]]],		[[[S_ISSOCK]]])

/* ------------------------------------------------------------------ */

static bool
mmux_libc_file_descriptor_is_predicate (bool * result_p, mmux_libc_fd_arg_t fd, mmux_libc_stat_mode_pred_t * pred)
{
  mmux_libc_stat_t	stru;

  if (mmux_libc_fstat(fd, &stru)) {
    mmux_libc_errno_t		errnum;

    mmux_libc_errno_consume(&errnum);
    if (mmux_libc_equal(MMUX_LIBC_ENOENT, errnum)) {
      /* The directory entry does not exist.  This function was successful. */
      *result_p = false;
      return false;
    } else {
      /* An error occurred in "fstat()". */
      return true;
    }
  } else {
    mmux_libc_mode_t		mode;

    if (mmux_libc_st_mode_ref(&mode, &stru)) {
      return true;
    } else /* The directory entry exists. */ if (pred(result_p, mode)) {
	return true;
      } else {
	return false;
      }
  }
}

m4_define([[[DEFINE_FILE_DESCRIPTOR_PREDICATE]]],[[[bool
mmux_libc_file_descriptor_is_$1 (bool * result_p, mmux_libc_fd_arg_t fd)
{
  return mmux_libc_file_descriptor_is_predicate(result_p, fd, mmux_libc_$2);
}]]])

DEFINE_FILE_DESCRIPTOR_PREDICATE([[[regular]]],			[[[S_ISREG]]])
DEFINE_FILE_DESCRIPTOR_PREDICATE([[[symlink]]],			[[[S_ISLNK]]])
DEFINE_FILE_DESCRIPTOR_PREDICATE([[[directory]]],		[[[S_ISDIR]]])
DEFINE_FILE_DESCRIPTOR_PREDICATE([[[character_special]]],	[[[S_ISCHR]]])
DEFINE_FILE_DESCRIPTOR_PREDICATE([[[block_special]]],		[[[S_ISBLK]]])
DEFINE_FILE_DESCRIPTOR_PREDICATE([[[fifo]]],			[[[S_ISFIFO]]])
DEFINE_FILE_DESCRIPTOR_PREDICATE([[[socket]]],			[[[S_ISSOCK]]])

/* ------------------------------------------------------------------ */

bool
mmux_libc_file_system_pathname_file_size_ref (mmux_usize_t * result_p, mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t ptn)
{
  mmux_libc_stat_t	ST[1];
  auto			flags = mmux_sint_constant_zero();

  if (mmux_libc_fstatat(dirfd, ptn, ST, flags)) {
    return true;
  } else {
    mmux_off_t		result;

    mmux_libc_st_size_ref(&result, ST);
    *result_p = mmux_usize(result.value);
    return false;
  }
}
bool
mmux_libc_file_descriptor_file_size_ref (mmux_usize_t * result_p, mmux_libc_fd_arg_t fd)
{
  mmux_libc_stat_t	ST[1];

  if (mmux_libc_fstat(fd, ST)) {
    return true;
  } else {
    mmux_off_t		result;

    mmux_libc_st_size_ref(&result, ST);
    *result_p = mmux_usize(result.value);
    return false;
  }
}


/** --------------------------------------------------------------------
 ** File times.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(utimbuf, actime,  time)
DEFINE_STRUCT_SETTER_GETTER(utimbuf, modtime, time)

/* ------------------------------------------------------------------ */

bool
mmux_libc_utimbuf_dump (mmux_libc_fd_arg_t fd, mmux_libc_utimbuf_t const * const utimbuf_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct utimbuf";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)utimbuf_p);

  {
    mmux_time_t	actime;

    mmux_libc_actime_ref(&actime, utimbuf_p);
    {
      mmux_usize_t	required_nbytes;

      if (mmux_time_sprint_size(&required_nbytes, actime)) {
	return true;
      } else {
	char	str[required_nbytes.value];

	mmux_time_sprint(str, required_nbytes, actime);
	DPRINTF(fd, "%s->st_actime  = %s", struct_name, str);
	if (mmux_libc_stat_dump_time(fd, actime)) {
	  return true;
	}
      }
    }
  }

  {
    mmux_time_t	modtime;

    mmux_libc_modtime_ref(&modtime, utimbuf_p);
    {
      mmux_usize_t	required_nbytes;

      if (mmux_time_sprint_size(&required_nbytes, modtime)) {
	return true;
      } else {
	char	str[required_nbytes.value];

	mmux_time_sprint(str, required_nbytes, modtime);
	DPRINTF(fd, "%s->st_modtime  = %s", struct_name, str);
	if (mmux_libc_stat_dump_time(fd, modtime)) {
	  return true;
	}
      }
    }
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_utime (mmux_libc_fs_ptn_arg_t pathname, mmux_libc_utimbuf_t utimbuf)
{
  int	rv = utime(pathname->value, &utimbuf);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_utimes (mmux_libc_fs_ptn_arg_t pathname,
		  mmux_libc_timeval_t access_timeval, mmux_libc_timeval_t modification_timeval)
{
  mmux_libc_timeval_t	T[2] = { access_timeval, modification_timeval };
  int			rv   = utimes(pathname->value, T);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_lutimes (mmux_libc_fs_ptn_arg_t pathname,
		   mmux_libc_timeval_t access_timeval, mmux_libc_timeval_t modification_timeval)
{
  mmux_libc_timeval_t	T[2] = { access_timeval, modification_timeval };
  int			rv   = lutimes(pathname->value, T);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_futimes (mmux_libc_fd_arg_t fd,
		   mmux_libc_timeval_t access_timeval, mmux_libc_timeval_t modification_timeval)
{
  mmux_libc_timeval_t	T[2] = { access_timeval, modification_timeval };
  int			rv   = futimes(fd->value, T);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_futimens (mmux_libc_fd_arg_t fd,
		    mmux_libc_timespec_t access_timespec, mmux_libc_timespec_t modification_timespec)
{
  mmux_libc_timespec_t	T[2] = { access_timespec, modification_timespec };
  int			rv   = futimens(fd->value, T);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_utimensat (mmux_libc_dirfd_arg_t dirfd, mmux_libc_fs_ptn_arg_t ptn,
		     mmux_libc_timespec_t access_timespec, mmux_libc_timespec_t modification_timespec,
		     mmux_sint_t flags)
{
  mmux_libc_timespec_t	T[2] = { access_timespec, modification_timespec };
  int			rv   = utimensat(dirfd->value, ptn->value, T, flags.value);

  return ((0 == rv)? false : true);
}

/* end of file */
