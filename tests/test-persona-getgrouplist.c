/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Jul 19, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-persona-getgrouplist";
  }

  /* Do it. */
  {
    mmux_libc_uid_t		uid;
    mmux_libc_passwd_t *	PW;

    mmux_libc_getuid(&uid);
    if (mmux_libc_getpwuid(&PW, uid)) {
      handle_error();
    } else {
      mmux_asciizcp_t	name;
      mmux_libc_gid_t	gid;
      mmux_usize_t	ngroups;

      mmux_libc_pw_name_ref (&name, PW);
      mmux_libc_pw_gid_ref  (&gid,  PW);

      if (mmux_libc_getgrouplist_size(&ngroups, name, gid)) {
	handle_error();
      } else {
	mmux_libc_gid_t       gids[ngroups.value];

	if (mmux_libc_getgrouplist(gids, &ngroups, name, gid)) {
	  handle_error();
	} else {
	  mmux_libc_oufd_t	er;

	  mmux_libc_stder(er);
	  for (mmux_standard_usize_t i=0; i<ngroups.value; ++i) {
	    if (mmux_libc_dprintfer("gid[%lu]=", i)) {
	      handle_error();
	    }
	    if (mmux_libc_dprintf_libc_gid(er, gids[i])) {
	      handle_error();
	    }
	    if (mmux_libc_dprintfer_newline()) {
	      handle_error();
	    }
	  }
	}
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
