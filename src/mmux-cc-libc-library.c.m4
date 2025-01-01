/*
  Part of: MMUX CC Libc
  Contents: core functions
  Date: Dec  8, 2024

  Abstract

	This module implements core functions.

  Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>

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
 ** Version functions.
 ** ----------------------------------------------------------------- */

char const *
mmux_cc_libc_version_string (void)
{
  return mmux_cc_libc_VERSION_INTERFACE_STRING;
}
int
mmux_cc_libc_version_interface_current (void)
{
  return mmux_cc_libc_VERSION_INTERFACE_CURRENT;
}
int
mmux_cc_libc_version_interface_revision (void)
{
  return mmux_cc_libc_VERSION_INTERFACE_REVISION;
}
int
mmux_cc_libc_version_interface_age (void)
{
  return mmux_cc_libc_VERSION_INTERFACE_AGE;
}


/** --------------------------------------------------------------------
 ** Library initialisation.
 ** ----------------------------------------------------------------- */

bool
mmux_cc_libc_init (void)
{
  return false;
}

/* end of file */
