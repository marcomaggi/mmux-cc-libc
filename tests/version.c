/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Dec  8, 2024

  Abstract

	Test file for version functions.

  Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/

#include <mmux-cc-libc.h>
#include <stdio.h>
#include <stdlib.h>

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  printf("version number string: %s\n", mmux_cc_libc_version_string());
  printf("libtool version number: %d:%d:%d\n",
	 mmux_cc_libc_version_interface_current(),
	 mmux_cc_libc_version_interface_revision(),
	 mmux_cc_libc_version_interface_age());
  exit(EXIT_SUCCESS);
}

/* end of file */
