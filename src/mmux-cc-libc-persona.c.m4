/*
  Part of: MMUX CC Libc
  Contents: operative system persona management
  Date: Dec 17, 2024

  Abstract

	This module implements the operative system persona management API.

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

m4_define([[[DEFINE_ASCIIZP_SETTER_GETTER]]],[[[bool
mmux_libc_$2_set (mmux_libc_$1_t * const P, mmux_asciizcp_t value)
{
  P->$2 = (mmux_asciizp_t)value;
  return false;
}
bool
mmux_libc_$2_ref (mmux_asciizcp_t * result_p, mmux_libc_$1_t const * const P)
{
  *result_p = P->$2;
  return false;
}]]])


/** --------------------------------------------------------------------
 ** Identifier functions: UID.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_uid (mmux_libc_uid_t * result_p, mmux_uid_t uid_num)
{
  result_p->value = uid_num;
  return false;
}
bool
mmux_libc_uid_parse (mmux_libc_uid_t * p_value, char const * s_value, char const * who)
{
  mmux_libc_uid_t	the_uid;

  if (mmux_uid_parse(&the_uid.value, s_value, who)) {
    return true;
  }
  *p_value = the_uid;
  return false;
}
bool
mmux_libc_uid_sprint (char * ptr, mmux_usize_t len, mmux_libc_uid_t uid)
{
  if (MMUX_LIBC_UID_MAXIMUM_STRING_REPRESENTATION_LENGTH < len) {
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
  return mmux_uid_sprint(ptr, len, uid.value);
}
bool
mmux_libc_uid_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_uid_t uid)
{
  mmux_sint_t	required_nchars = mmux_uid_sprint_size(uid.value);

  if (0 <= required_nchars) {
    *required_nchars_p = required_nchars;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_passwd_dump (mmux_libc_file_descriptor_t fd, mmux_libc_passwd_t const * passwd_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct passwd";
  }
  DPRINTF(fd, "%s *         = %p\n", struct_name, (mmux_pointer_t)passwd_p);
  DPRINTF(fd, "%s.pw_name   = %s\n",   struct_name, passwd_p->pw_name);
  DPRINTF(fd, "%s.pw_passwd = %s\n", struct_name, passwd_p->pw_passwd);
  {
    mmux_usize_t	required_nchars;
    mmux_libc_uid_t	uid;

    mmux_libc_pw_uid_ref(&uid, passwd_p);
    if (mmux_libc_uid_sprint_size(&required_nchars, uid)) {
      return true;
    } else {
      char	str[required_nchars];

      if (mmux_libc_uid_sprint(str, required_nchars, uid)) {
	return true;
      } else {
	DPRINTF(fd, "%s.pw_uid = %s\n", struct_name, str);
      }
    }
  }
  {
    mmux_usize_t	required_nchars;
    mmux_libc_gid_t	gid;

    mmux_libc_pw_gid_ref(&gid, passwd_p);
    if (mmux_libc_gid_sprint_size(&required_nchars, gid)) {
      return true;
    } else {
      char	str[required_nchars];

      if (mmux_libc_gid_sprint(str, required_nchars, gid)) {
	return true;
      } else {
	DPRINTF(fd, "%s.pw_gid = %s\n", struct_name, str);
      }
    }
  }
  DPRINTF(fd, "%s.pw_gecos  = %s\n", struct_name, passwd_p->pw_gecos);
  DPRINTF(fd, "%s.pw_dir    = %s\n", struct_name, passwd_p->pw_dir);
  DPRINTF(fd, "%s.pw_shell  = %s\n", struct_name, passwd_p->pw_shell);

  return false;
}


/** --------------------------------------------------------------------
 ** Identifier functions: GID.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_gid (mmux_libc_gid_t * result_p, mmux_gid_t gid_num)
{
  result_p->value = gid_num;
  return false;
}
bool
mmux_libc_gid_parse (mmux_libc_gid_t * p_value, char const * s_value, char const * who)
{
  mmux_libc_gid_t	the_gid;

  if (mmux_gid_parse(&the_gid.value, s_value, who)) {
    return true;
  }
  *p_value = the_gid;
  return false;
}
bool
mmux_libc_gid_sprint (char * ptr, mmux_usize_t len, mmux_libc_gid_t gid)
{
  if (MMUX_LIBC_GID_MAXIMUM_STRING_REPRESENTATION_LENGTH < len) {
    errno = MMUX_LIBC_EINVAL;
    return true;
  }
  return mmux_gid_sprint(ptr, len, gid.value);
}
bool
mmux_libc_gid_sprint_size (mmux_usize_t * required_nchars_p, mmux_libc_gid_t gid)
{
  mmux_sint_t	required_nchars = mmux_gid_sprint_size(gid.value);

  if (0 <= required_nchars) {
    *required_nchars_p = required_nchars;
    return false;
  } else {
    return true;
  }
}

bool
mmux_libc_group_dump (mmux_libc_file_descriptor_t fd, mmux_libc_group_t const * group_p, char const * struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct group";
  }
  DPRINTF(fd, "%s = %p\n", struct_name, (mmux_pointer_t)group_p);
  {
    mmux_usize_t	required_nchars;
    mmux_libc_gid_t	gid;

    mmux_libc_gr_gid_ref(&gid, group_p);
    if (mmux_libc_gid_sprint_size(&required_nchars, gid)) {
      return true;
    } else {
      char	str[required_nchars];

      if (mmux_libc_gid_sprint(str, required_nchars, gid)) {
	return true;
      } else {
	DPRINTF(fd, "%s.gr_gid = %s\n", struct_name, str);
      }
    }
  }
  {
    char const **	mem;
    mmux_sint_t		i = 0;

    mmux_libc_gr_mem_ref(&mem, group_p);
    for (; *mem; ++mem, ++i) {
      DPRINTF(fd, "%s.gr_mem[%d] = %s\n", struct_name, i, *mem);
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Getting UIDs and GIDs.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_getuid (mmux_libc_uid_t * result_p)
{
  return mmux_libc_make_uid(result_p, getuid());
}
bool
mmux_libc_getgid (mmux_libc_gid_t * result_p)
{
  return mmux_libc_make_gid(result_p, getgid());
}
bool
mmux_libc_geteuid (mmux_libc_uid_t * result_p)
{
  return mmux_libc_make_uid(result_p, geteuid());
}
bool
mmux_libc_getegid (mmux_libc_gid_t * result_p)
{
  return mmux_libc_make_gid(result_p, getegid());
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_getgroups_size (mmux_usize_t * ngroups_p)
{
  mmux_sint_t	ngroups = getgroups(0, NULL);

  if (0 <= ngroups) {
    *ngroups_p = ngroups;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getgroups (mmux_usize_t * ngroups_p, mmux_libc_gid_t * groups_p)
{
  mmux_sint_t	ngroups1 = *ngroups_p;
  mmux_gid_t	gids[ngroups1];
  mmux_sint_t	ngroups2 = getgroups(ngroups1, gids);

  if (0 <= ngroups2) {
    for (mmux_sint_t i=0; i<ngroups1; ++i) {
      mmux_libc_make_gid(&(groups_p[i]), gids[i]);
    }
    *ngroups_p = ngroups2;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_getgrouplist_size (mmux_usize_t * result_ngroups_p, char const * username, mmux_libc_gid_t gid)
{
  mmux_sint_t		ngroups = 0;

  getgrouplist(username, gid.value, NULL, &ngroups);
  if ((0 <= ngroups) && (ngroups <= MMUX_LIBC_GETGROUPLIST_MAXIMUM_GROUPS_NUMBER)) {
    *result_ngroups_p = ngroups;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getgrouplist (char const * username, mmux_libc_gid_t gid, mmux_usize_t * ngroups_p, mmux_libc_gid_t * groups_p)
{
  if (MMUX_LIBC_GETGROUPLIST_MAXIMUM_GROUPS_NUMBER < *ngroups_p) {
    return true;
  } else {
    mmux_sint_t		ngroups1 = *ngroups_p;
    mmux_gid_t		gids[ngroups1];
    mmux_sint_t		ngroups2;

    ngroups2 = getgrouplist(username, gid.value, gids, &ngroups1);
    if (0 <= ngroups2) {
      for (mmux_sint_t i=0; i<ngroups1; ++i) {
	mmux_libc_make_gid(&(groups_p[i]), gids[i]);
      }
      *ngroups_p = ngroups2;
      return false;
    } else {
      return true;
    }
  }
}


/** --------------------------------------------------------------------
 ** Setting UIDs.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_setuid (mmux_libc_uid_t uid)
{
  int	rv = setuid(uid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_seteuid (mmux_libc_uid_t uid)
{
  int	rv = seteuid(uid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_setreuid (mmux_libc_uid_t uid, mmux_libc_uid_t euid)
{
  int	rv = setreuid(uid.value, euid.value);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** Setting GIDs.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_setgid (mmux_libc_gid_t gid)
{
  int	rv = setgid(gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_setegid (mmux_libc_gid_t gid)
{
  int	rv = setegid(gid.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_setregid (mmux_libc_gid_t gid, mmux_libc_gid_t egid)
{
  int	rv = setregid(gid.value, egid.value);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** Users database.
 ** ----------------------------------------------------------------- */

DEFINE_ASCIIZP_SETTER_GETTER(passwd, pw_name)
DEFINE_ASCIIZP_SETTER_GETTER(passwd, pw_passwd)
DEFINE_ASCIIZP_SETTER_GETTER(passwd, pw_gecos)
DEFINE_ASCIIZP_SETTER_GETTER(passwd, pw_dir)
DEFINE_ASCIIZP_SETTER_GETTER(passwd, pw_shell)

bool
mmux_libc_pw_uid_set (mmux_libc_passwd_t * const P, mmux_libc_uid_t value)
{
  P->pw_uid = value.value;
  return false;
}
bool
mmux_libc_pw_uid_ref (mmux_libc_uid_t * result_p, mmux_libc_passwd_t const * const P)
{
  return mmux_libc_make_uid(result_p, P->pw_uid);
}

bool
mmux_libc_pw_gid_set (mmux_libc_passwd_t * const P, mmux_libc_gid_t value)
{
  P->pw_gid = value.value;
  return false;
}
bool
mmux_libc_pw_gid_ref (mmux_libc_gid_t * result_p, mmux_libc_passwd_t const * const P)
{
  return mmux_libc_make_gid(result_p, P->pw_gid);
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_getpwuid (mmux_libc_passwd_t * * result_passwd_pp, mmux_libc_uid_t uid)
{
  mmux_libc_passwd_t *	passwd_p = getpwuid(uid.value);

  if (passwd_p) {
    *result_passwd_pp = passwd_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getpwnam (mmux_libc_passwd_t * * result_passwd_pp, char const * username)
{
  mmux_libc_passwd_t *	passwd_p = getpwnam(username);

  if (passwd_p) {
    *result_passwd_pp = passwd_p;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_setpwent (void)
{
  setpwent();
  return false;
}
bool
mmux_libc_endpwent (void)
{
  endpwent();
  return false;
}
bool
mmux_libc_getpwent (mmux_libc_passwd_t * * passwd_pp)
{
  *passwd_pp = getpwent();
  return false;
}


/** --------------------------------------------------------------------
 ** Groups database.
 ** ----------------------------------------------------------------- */

DEFINE_ASCIIZP_SETTER_GETTER(group,	gr_name)

bool
mmux_libc_gr_gid_set (mmux_libc_group_t * const P, mmux_libc_gid_t value)
{
  P->gr_gid = value.value;
  return false;
}
bool
mmux_libc_gr_gid_ref (mmux_libc_gid_t * result_p, mmux_libc_group_t const * const P)
{
  return mmux_libc_make_gid(result_p, P->gr_gid);
}

bool
mmux_libc_gr_mem_set (mmux_libc_group_t * const P, mmux_asciizcp_t * value)
{
  P->gr_mem = (mmux_asciizp_t *)value;
  return false;
}
bool
mmux_libc_gr_mem_ref (mmux_asciizcp_t * * result_p, mmux_libc_group_t const * const P)
{
  *result_p = (mmux_asciizcp_t *) (P->gr_mem);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_getgrgid (mmux_libc_group_t * * result_group_pp, mmux_libc_gid_t gid)
{
  mmux_libc_group_t *	group_p = getgrgid(gid.value);

  if (group_p) {
    *result_group_pp = group_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getgrnam (mmux_libc_group_t * * result_group_pp, char const * username)
{
  mmux_libc_group_t *	group_p = getgrnam(username);

  if (group_p) {
    *result_group_pp = group_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_group_member (bool * is_member_p, mmux_libc_gid_t gid)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_GROUP_MEMBER]]],[[[
  mmux_sint_t	is_member = group_member(gid.value);

  *is_member_p = ((0 != is_member)? true : false);
  return false;
]]])
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_setgrent (void)
{
  setgrent();
  return false;
}
bool
mmux_libc_endgrent (void)
{
  endgrent();
  return false;
}
bool
mmux_libc_getgrent (mmux_libc_group_t * * result_group_pp)
{
  *result_group_pp = getgrent();
  return false;
}


/** --------------------------------------------------------------------
 ** Miscellaneous.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_getlogin (char const * * username_p)
{
  *username_p = getlogin();
  return false;
}

/* end of file */
