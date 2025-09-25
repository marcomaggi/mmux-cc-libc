/*
  Part of: MMUX CC Libc
  Contents: characters operations
  Date: Dec 31, 2024

  Abstract

	This module implements the characters API.

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


/** --------------------------------------------------------------------
 ** Classes.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_CHARACTER_PREDICATE]]],[[[bool
mmux_libc_$1 (bool * result_p, mmux_char_t ch)
{
  int	rv = $1(ch.value);

  *result_p = ((rv)? true : false);
  return false;
}
]]])

DEFINE_CHARACTER_PREDICATE([[[islower]]])
DEFINE_CHARACTER_PREDICATE([[[isupper]]])
DEFINE_CHARACTER_PREDICATE([[[isalpha]]])
DEFINE_CHARACTER_PREDICATE([[[isdigit]]])
DEFINE_CHARACTER_PREDICATE([[[isalnum]]])
DEFINE_CHARACTER_PREDICATE([[[isxdigit]]])
DEFINE_CHARACTER_PREDICATE([[[ispunct]]])
DEFINE_CHARACTER_PREDICATE([[[isspace]]])
DEFINE_CHARACTER_PREDICATE([[[isblank]]])
DEFINE_CHARACTER_PREDICATE([[[isgraph]]])
DEFINE_CHARACTER_PREDICATE([[[isprint]]])
DEFINE_CHARACTER_PREDICATE([[[iscntrl]]])
DEFINE_CHARACTER_PREDICATE([[[isascii]]])


/** --------------------------------------------------------------------
 ** Capitalisation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_tolower (mmux_char_t * result_p, mmux_char_t ch)
{
  *result_p = mmux_char(tolower(ch.value));
  return false;
}
bool
mmux_libc_toupper (mmux_char_t * result_p, mmux_char_t ch)
{
  *result_p = mmux_char(toupper(ch.value));
  return false;
}

/* end of file */
