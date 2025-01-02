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

#define DPRINTF(TEMPLATE,...)	if (mmux_libc_dprintf(TEMPLATE,__VA_ARGS__)) { return true; }


/** --------------------------------------------------------------------
 ** File system: types.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_file_system_pathname (mmux_libc_file_system_pathname_t * pathname_p, mmux_asciizcp_t asciiz_pathname)
{
  if (NULL != asciiz_pathname) {
    mmux_libc_file_system_pathname_t	pathname = { .value = asciiz_pathname };

    *pathname_p = pathname;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_file_system_pathname_asciizp_ref (mmux_asciizcpp_t asciiz_pathname_p, mmux_libc_file_system_pathname_t pathname)
{
  *asciiz_pathname_p = pathname.value;
  return false;
}
bool
mmux_libc_file_system_pathname_free (mmux_libc_file_system_pathname_t pathname)
{
  return mmux_libc_free((mmux_pointer_t)pathname.value);
}


/** --------------------------------------------------------------------
 ** File system: links.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_link (mmux_libc_file_system_pathname_t oldname, mmux_libc_file_system_pathname_t newname)
{
  int	rv = link(oldname.value, newname.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_linkat (mmux_libc_file_descriptor_t oldfd, mmux_libc_file_system_pathname_t oldname,
		  mmux_libc_file_descriptor_t newfd, mmux_libc_file_system_pathname_t newname,
		  mmux_sint_t flags)
{
  int	rv = linkat(oldfd.value, oldname.value, newfd.value, newname.value, flags);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_symlink (mmux_libc_file_system_pathname_t oldname, mmux_libc_file_system_pathname_t newname)
{
  int	rv = symlink(oldname.value, newname.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_readlink (mmux_usize_t * required_nbytes_p, mmux_libc_file_system_pathname_t linkname,
		    mmux_asciizp_t buffer, mmux_usize_t provided_nbytes)
{
  mmux_ssize_t	required_nbytes = readlink(linkname.value, buffer, provided_nbytes);

  if (required_nbytes < 0) {
    return true;
  } else {
    mmux_usize_t	required_nbytes1 = required_nbytes;

    if (required_nbytes1 == provided_nbytes) {
      *required_nbytes_p = required_nbytes1;
      return false;
    } else {
      return false;
    }
  }
}
bool
mmux_libc_readlink_malloc (mmux_libc_file_system_pathname_t * result_pathname_p, mmux_libc_file_system_pathname_t linkname)
{
  mmux_usize_t	provided_nbytes_with_nul = 0;

  while (true) {
    provided_nbytes_with_nul += 1024;
    {
      char		buffer[provided_nbytes_with_nul];
      mmux_usize_t	required_nbytes_no_nul;

      memset(buffer, '\0', provided_nbytes_with_nul);
      if (mmux_libc_readlink(&required_nbytes_no_nul, linkname, buffer, provided_nbytes_with_nul-1)) {
	return true;
      } else if (required_nbytes_no_nul == provided_nbytes_with_nul) {
	continue;
      } else {
	mmux_asciizp_t	asciiz_pathname;

	if (mmux_libc_malloc(&asciiz_pathname, provided_nbytes_with_nul)) {
	  return true;
	};
	memcpy(asciiz_pathname, buffer, provided_nbytes_with_nul);
	if (mmux_libc_make_file_system_pathname(result_pathname_p, asciiz_pathname)) {
	  mmux_libc_free(asciiz_pathname);
	  return true;
	} else {
	  return false;
	}
      }
    }
  }
}
bool
mmux_libc_readlinkat (mmux_usize_t * required_nbytes_p, mmux_libc_file_descriptor_t dirfd,
		      mmux_libc_file_system_pathname_t linkname,
		      mmux_asciizp_t buffer, mmux_usize_t provided_nbytes)
{
  mmux_ssize_t	required_nbytes = readlinkat(dirfd.value, linkname.value, buffer, provided_nbytes);

  if (required_nbytes < 0) {
    return true;
  } else {
    mmux_usize_t	required_nbytes1 = required_nbytes;

    if (required_nbytes1 == provided_nbytes) {
      *required_nbytes_p = required_nbytes1;
      return false;
    } else {
      return false;
    }
  }
}
bool
mmux_libc_readlinkat_malloc (mmux_libc_file_system_pathname_t * result_pathname_p, mmux_libc_file_descriptor_t dirfd,
			     mmux_libc_file_system_pathname_t linkname)
{
  mmux_usize_t	provided_nbytes_with_nul = 0;

  while (true) {
    provided_nbytes_with_nul += 1024;
    {
      char		buffer[provided_nbytes_with_nul];
      mmux_usize_t	required_nbytes_no_nul;

      memset(buffer, '\0', provided_nbytes_with_nul);
      if (mmux_libc_readlinkat(&required_nbytes_no_nul, dirfd, linkname, buffer, provided_nbytes_with_nul-1)) {
	return true;
      } else if (required_nbytes_no_nul == provided_nbytes_with_nul) {
	continue;
      } else {
	mmux_asciizp_t	asciiz_pathname;

	if (mmux_libc_malloc(&asciiz_pathname, provided_nbytes_with_nul)) {
	  return true;
	};
	memcpy(asciiz_pathname, buffer, provided_nbytes_with_nul);
	if (mmux_libc_make_file_system_pathname(result_pathname_p, asciiz_pathname)) {
	  mmux_libc_free(asciiz_pathname);
	  return true;
	} else {
	  return false;
	}
      }
    }
  }
}

bool
mmux_libc_canonicalize_file_name (mmux_libc_file_system_pathname_t * result_pathname_p, mmux_libc_file_system_pathname_t input_pathname)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_CANONICALIZE_FILE_NAME]]],[[[
  mmux_asciizp_t	asciiz_output_pathname = canonicalize_file_name(input_pathname.value);

  if (asciiz_output_pathname) {
    if (mmux_libc_make_file_system_pathname(result_pathname_p, asciiz_output_pathname)) {
      mmux_libc_free(asciiz_output_pathname);
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
]]])
}
bool
mmux_libc_realpath (mmux_libc_file_system_pathname_t * result_pathname_p, mmux_libc_file_system_pathname_t input_pathname)
{
  mmux_asciizp_t	asciiz_output_pathname = realpath(input_pathname.value, NULL);

  if (asciiz_output_pathname) {
    if (mmux_libc_make_file_system_pathname(result_pathname_p, asciiz_output_pathname)) {
      mmux_libc_free(asciiz_output_pathname);
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

bool
mmux_libc_unlink (mmux_libc_file_system_pathname_t pathname)
{
  int	rv = unlink(pathname.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_unlinkat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname, mmux_sint_t flags)
{
  int	rv = unlinkat(dirfd.value, pathname.value, flags);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_rmdir (mmux_libc_file_system_pathname_t pathname)
{
  int	rv = rmdir(pathname.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_remove (mmux_libc_file_system_pathname_t pathname)
{
  int	rv = remove(pathname.value);

  return ((0 == rv)? false : true);
}

bool
mmux_libc_rename (mmux_libc_file_system_pathname_t oldname, mmux_libc_file_system_pathname_t newname)
{
  int	rv = rename(oldname.value, newname.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_renameat (mmux_libc_file_descriptor_t olddirfd, mmux_libc_file_system_pathname_t oldname,
		    mmux_libc_file_descriptor_t newdirfd, mmux_libc_file_system_pathname_t newname)
{
  int	rv = renameat(olddirfd.value, oldname.value, newdirfd.value, newname.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_renameat2 (mmux_libc_file_descriptor_t olddirfd, mmux_libc_file_system_pathname_t oldname,
		     mmux_libc_file_descriptor_t newdirfd, mmux_libc_file_system_pathname_t newname,
		     mmux_uint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_RENAMEAT2]]],[[[
  int	rv = renameat2(olddirfd.value, oldname.value, newdirfd.value, newname.value, flags);

  return ((0 == rv)? false : true);
]]])
}


/** --------------------------------------------------------------------
 ** Directories.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_mkdir (mmux_libc_file_system_pathname_t pathname, mmux_mode_t mode)
{
  int	rv = mkdir(pathname.value, mode);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_mkdirat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname, mmux_mode_t mode)
{
  int	rv = mkdirat(dirfd.value, pathname.value, mode);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** File ownership.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_chown (mmux_libc_file_system_pathname_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
{
  int	rv = chown(pathname.value, uid.value, gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchown (mmux_libc_file_descriptor_t fd, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
{
  int	rv = fchown(fd.value, uid.value, gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_lchown (mmux_libc_file_system_pathname_t pathname, mmux_libc_uid_t uid, mmux_libc_gid_t gid)
{
  int	rv = lchown(pathname.value, uid.value, gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchownat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname,
		    mmux_libc_uid_t uid, mmux_libc_gid_t gid, mmux_sint_t flags)
{
  int	rv = fchownat(dirfd.value, pathname.value, uid.value, gid.value, flags);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** File access permissions.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_umask (mmux_mode_t * old_mask_p, mmux_mode_t new_mask)
{
  *old_mask_p = umask(new_mask);
  return false;
}
bool
mmux_libc_getumask (mmux_mode_t * current_mask_p)
{
  mmux_mode_t		current_mask = umask(0);

  umask(current_mask);
  *current_mask_p = current_mask;
  return false;
}
bool
mmux_libc_chmod (mmux_libc_file_system_pathname_t pathname, mmux_mode_t mode)
{
  int	rv = chmod(pathname.value, mode);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchmod (mmux_libc_file_descriptor_t fd, mmux_mode_t mode)
{
  int	rv = fchmod(fd.value, mode);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fchmodat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname, mmux_mode_t mode, mmux_sint_t flags)
{
  int	rv = fchmodat(dirfd.value, pathname.value, mode, flags);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_access (mmux_libc_file_system_pathname_t pathname, mmux_sint_t how)
{
  int	rv = access(pathname.value, how);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_faccessat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname,
		     mmux_sint_t how, mmux_sint_t flags)
{
  int	rv = faccessat(dirfd.value, pathname.value, how, flags);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** Truncating file size.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_truncate (mmux_libc_file_system_pathname_t pathname, mmux_off_t len)
{
  int	rv = truncate(pathname.value, len);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_ftruncate (mmux_libc_file_descriptor_t fd, mmux_off_t len)
{
  int	rv = ftruncate(fd.value, len);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** File attributes.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_st_mode_set (mmux_libc_stat_t * stat_p, mmux_mode_t value)
{
  stat_p->st_mode = value;
  return false;
}
bool
mmux_libc_st_ino_set (mmux_libc_stat_t * stat_p, mmux_uintmax_t value)
{
  stat_p->st_ino = (ino_t)value;
  return false;
}
bool
mmux_libc_st_dev_set (mmux_libc_stat_t * stat_p, mmux_uintmax_t value)
{
  stat_p->st_dev = (dev_t)value;
  return false;
}
bool
mmux_libc_st_nlink_set (mmux_libc_stat_t * stat_p, mmux_uintmax_t value)
{
  stat_p->st_nlink = (nlink_t)value;
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
  stat_p->st_size = value;
  return false;
}
bool
mmux_libc_st_atime_sec_set (mmux_libc_stat_t * stat_p, mmux_time_t value)
{
  stat_p->st_atim.tv_sec = value;
  return false;
}
bool
mmux_libc_st_atime_nsec_set (mmux_libc_stat_t * stat_p, mmux_slong_t value)
{
  stat_p->st_atim.tv_nsec = value;
  return false;
}
bool
mmux_libc_st_mtime_sec_set (mmux_libc_stat_t * stat_p, mmux_time_t value)
{
  stat_p->st_atim.tv_sec = value;
  return false;
}
bool
mmux_libc_st_mtime_nsec_set (mmux_libc_stat_t * stat_p, mmux_slong_t value)
{
  stat_p->st_atim.tv_nsec = value;
  return false;
}
bool
mmux_libc_st_ctime_sec_set (mmux_libc_stat_t * stat_p, mmux_time_t value)
{
  stat_p->st_atim.tv_sec = value;
  return false;
}
bool
mmux_libc_st_ctime_nsec_set (mmux_libc_stat_t * stat_p, mmux_slong_t value)
{
  stat_p->st_atim.tv_nsec = value;
  return false;
}
bool
mmux_libc_st_blocks_set (mmux_libc_stat_t * stat_p, mmux_uintmax_t value)
{
  stat_p->st_blocks = (blkcnt_t)value;
  return false;
}
bool
mmux_libc_st_blksize_set (mmux_libc_stat_t * stat_p, mmux_uint_t value)
{
  stat_p->st_blksize = value;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_st_mode_ref (mmux_mode_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_mode;
  return false;
}
bool
mmux_libc_st_ino_ref (mmux_uintmax_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = (mmux_uintmax_t)(stat_p->st_ino);
  return false;
}
bool
mmux_libc_st_dev_ref (mmux_uintmax_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = (mmux_uintmax_t)(stat_p->st_dev);
  return false;
}
bool
mmux_libc_st_nlink_ref (mmux_uintmax_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = (mmux_uintmax_t)(stat_p->st_nlink);
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
  *value_p = stat_p->st_size;
  return false;
}
bool
mmux_libc_st_atime_sec_ref (mmux_time_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_atim.tv_sec;
  return false;
}
bool
mmux_libc_st_atime_nsec_ref (mmux_slong_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_atim.tv_nsec;
  return false;
}
bool
mmux_libc_st_mtime_sec_ref (mmux_time_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_atim.tv_sec;
  return false;
}
bool
mmux_libc_st_mtime_nsec_ref (mmux_slong_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_atim.tv_nsec;
  return false;
}
bool
mmux_libc_st_ctime_sec_ref (mmux_time_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_atim.tv_sec;
  return false;
}
bool
mmux_libc_st_ctime_nsec_ref (mmux_slong_t * value_p,  mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_atim.tv_nsec;
  return false;
}
bool
mmux_libc_st_blocks_ref (mmux_uintmax_t * value_p, mmux_libc_stat_t const * stat_p)
{
  *value_p = (mmux_uintmax_t)(stat_p->st_blocks);
  return false;
}
bool
mmux_libc_st_blksize_ref (mmux_uint_t * value_p, mmux_libc_stat_t const * stat_p)
{
  *value_p = stat_p->st_blksize;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_stat_dump (mmux_libc_file_descriptor_t fd, mmux_libc_stat_t const * const stat_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct stat";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)stat_p);

  {
    int		len = mmux_mode_sprint_size(stat_p->st_mode);
    char	str[len];

    mmux_mode_sprint(str, len, stat_p->st_mode);
    DPRINTF(fd, "%s->st_mode = %s\n", struct_name, str);
  }

  {
    int		len = mmux_uintmax_sprint_size((mmux_uintmax_t)(stat_p->st_ino));
    char	str[len];

    mmux_uintmax_sprint(str, len, (mmux_uintmax_t)(stat_p->st_ino));
    DPRINTF(fd, "%s->st_ino = %s\n", struct_name, str);
  }

  {
    int		len = mmux_uintmax_sprint_size((mmux_uintmax_t)(stat_p->st_dev));
    char	str[len];

    mmux_uintmax_sprint(str, len, stat_p->st_dev);
    DPRINTF(fd, "%s->st_dev = %s\n", struct_name, str);
  }

  {
    int		len = mmux_uintmax_sprint_size((mmux_uintmax_t)(stat_p->st_nlink));
    char	str[len];

    mmux_uintmax_sprint(str, len, (mmux_uintmax_t)(stat_p->st_nlink));
    DPRINTF(fd, "%s->st_nlink = %s\n", struct_name, str);
  }

  {
    int		len = mmux_uintmax_sprint_size((mmux_uintmax_t)(stat_p->st_ino));
    char	str[len];

    mmux_uintmax_sprint(str, len, (mmux_uintmax_t)(stat_p->st_ino));
    DPRINTF(fd, "%s->st_ino = %s\n", struct_name, str);
  }

  {
    int		len = mmux_uid_sprint_size(stat_p->st_uid);
    char	str[len];

    mmux_uid_sprint(str, len, stat_p->st_uid);
    DPRINTF(fd, "%s->st_uid = %s\n", struct_name, str);
  }

  {
    int		len = mmux_gid_sprint_size(stat_p->st_gid);
    char	str[len];

    mmux_gid_sprint(str, len, stat_p->st_gid);
    DPRINTF(fd, "%s->st_gid = %s\n", struct_name, str);
  }

  {
    int		len = mmux_off_sprint_size(stat_p->st_size);
    char	str[len];

    mmux_off_sprint(str, len, stat_p->st_size);
    DPRINTF(fd, "%s->st_size = %s\n", struct_name, str);
  }

  {
    int		len = mmux_time_sprint_size(stat_p->st_atim.tv_sec);
    char	str[len];

    mmux_time_sprint(str, len, stat_p->st_atim.tv_sec);
    DPRINTF(fd, "%s->st_atime_sec = %s\n", struct_name, str);
  }

  {
    int		len = mmux_slong_sprint_size(stat_p->st_atim.tv_nsec);
    char	str[len];

    mmux_slong_sprint(str, len, stat_p->st_atim.tv_nsec);
    DPRINTF(fd, "%s->st_atime_nsec = %s\n", struct_name, str);
  }

  {
    int		len = mmux_time_sprint_size(stat_p->st_mtim.tv_sec);
    char	str[len];

    mmux_time_sprint(str, len, stat_p->st_mtim.tv_sec);
    DPRINTF(fd, "%s->st_mtime_sec = %s\n", struct_name, str);
  }

  {
    int		len = mmux_slong_sprint_size(stat_p->st_mtim.tv_nsec);
    char	str[len];

    mmux_slong_sprint(str, len, stat_p->st_mtim.tv_nsec);
    DPRINTF(fd, "%s->st_mtime_nsec = %s\n", struct_name, str);
  }

  {
    int		len = mmux_time_sprint_size(stat_p->st_ctim.tv_sec);
    char	str[len];

    mmux_time_sprint(str, len, stat_p->st_ctim.tv_sec);
    DPRINTF(fd, "%s->st_ctime_sec = %s\n", struct_name, str);
  }

  {
    int		len = mmux_slong_sprint_size(stat_p->st_ctim.tv_nsec);
    char	str[len];

    mmux_slong_sprint(str, len, stat_p->st_ctim.tv_nsec);
    DPRINTF(fd, "%s->st_ctime_nsec = %s\n", struct_name, str);
  }

  {
    int		len = mmux_uintmax_sprint_size((mmux_uintmax_t)(stat_p->st_blocks));
    char	str[len];

    mmux_uintmax_sprint(str, len, (mmux_uintmax_t)(stat_p->st_blocks));
    DPRINTF(fd, "%s->st_blocks = %s\n", struct_name, str);
  }

  {
    int		len = mmux_uint_sprint_size(stat_p->st_blksize);
    char	str[len];

    mmux_uint_sprint(str, len, stat_p->st_blksize);
    DPRINTF(fd, "%s->st_blksize = %s\n", struct_name, str);
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_stat (mmux_libc_file_system_pathname_t pathname, mmux_libc_stat_t * stat_p)
{
  int	rv = stat(pathname.value, stat_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fstat (mmux_libc_file_descriptor_t fd, mmux_libc_stat_t * stat_p)
{
  int	rv = fstat(fd.value, stat_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_lstat (mmux_libc_file_system_pathname_t pathname, mmux_libc_stat_t * stat_p)
{
  int	rv = lstat(pathname.value, stat_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_fstatat (mmux_libc_file_descriptor_t dirfd, mmux_libc_file_system_pathname_t pathname,
		   mmux_libc_stat_t * stat_p, mmux_sint_t flags)
{
  int	rv = fstatat(dirfd.value, pathname.value, stat_p, flags);

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
mmux_libc_$1 (bool * result_p, mmux_mode_t mode)
{
  *result_p = ($1(mode))? true : false;
  return false;
}]]])

DEFINE_STAT_MODE_PREDICATE([[[S_ISDIR]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISCHR]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISBLK]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISREG]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISFIFO]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISLNK]]])
DEFINE_STAT_MODE_PREDICATE([[[S_ISSOCK]]])


/** --------------------------------------------------------------------
 ** File times.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(utimbuf, actime,  mmux_time_t)
DEFINE_STRUCT_SETTER_GETTER(utimbuf, modtime, mmux_time_t)

/* ------------------------------------------------------------------ */

bool
mmux_libc_utimbuf_dump (mmux_libc_file_descriptor_t fd, mmux_libc_utimbuf_t const * const utimbuf_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct utimbuf";
  }

  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)utimbuf_p);

  {
    int		len = mmux_time_sprint_size(utimbuf_p->actime);
    char	str[len];

    mmux_time_sprint(str, len, utimbuf_p->actime);
    DPRINTF(fd, "%s->st_actime = %s\n", struct_name, str);
  }

  {
    int		len = mmux_time_sprint_size(utimbuf_p->modtime);
    char	str[len];

    mmux_time_sprint(str, len, utimbuf_p->modtime);
    DPRINTF(fd, "%s->st_modtime = %s\n", struct_name, str);
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_utime (mmux_libc_file_system_pathname_t pathname, mmux_libc_utimbuf_t * utimbuf_p)
{
  int	rv = utime(pathname.value, utimbuf_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_utimes (mmux_libc_file_system_pathname_t pathname,
		  mmux_libc_timeval_t * access_timeval_pointer, mmux_libc_timeval_t * modification_timeval_pointer)
{
  mmux_libc_timeval_t	T[2] = { *access_timeval_pointer, *modification_timeval_pointer };
  int			rv   = utimes(pathname.value, T);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_lutimes (mmux_libc_file_system_pathname_t pathname,
		   mmux_libc_timeval_t * access_timeval_pointer, mmux_libc_timeval_t * modification_timeval_pointer)
{
  mmux_libc_timeval_t	T[2] = { *access_timeval_pointer, *modification_timeval_pointer };
  int			rv   = lutimes(pathname.value, T);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_futimes (mmux_libc_file_descriptor_t fd,
		   mmux_libc_timeval_t * access_timeval_pointer, mmux_libc_timeval_t * modification_timeval_pointer)
{
  mmux_libc_timeval_t	T[2] = { *access_timeval_pointer, *modification_timeval_pointer };
  int			rv   = futimes(fd.value, T);

  return ((0 == rv)? false : true);
}

/* end of file */
