/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Dec  8, 2024

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/

#include <mmux-cc-libc.h>

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  mmux_cc_libc_init();

  mmux_libc_dprintfou("version number string: %s\n", mmux_cc_libc_version_string());
  mmux_libc_dprintfou("libtool version number: %d:%d:%d\n",
		      mmux_cc_libc_version_interface_current(),
		      mmux_cc_libc_version_interface_revision(),
		      mmux_cc_libc_version_interface_age());
  mmux_libc_exit_success();
}

/* end of file */
