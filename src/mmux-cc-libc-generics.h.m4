/*
  Part of: MMUX CC Libc
  Contents: public header file
  Date: Sep 27, 2025

  Abstract

	This header file declares generic preprocessor macros.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  This program is free  software: you can redistribute it and/or  modify it under the
  terms  of  the  GNU General  Public  License  as  published  by the  Free  Software
  Foundation, either version 3 of the License, or (at your option) any later version.

  This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
  WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
  PARTICULAR PURPOSE.  See the GNU General Public License for more details.

  You should have received  a copy of the GNU General Public  License along with this
  program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef MMUX_CC_LIBC_GENERICS_H
#define MMUX_CC_LIBC_GENERICS_H 1


/** --------------------------------------------------------------------
 ** Comparison.
 ** ----------------------------------------------------------------- */

m4_divert(-1)
m4_define([[[DEFINE_COMPARISON]]],[[[m4_dnl
#define mmux_libc_$1(VALUE1,VALUE2)					\
  (_Generic((VALUE1),							\
     mmux_libc_errno_t:		mmux_libc_errno_$1)((VALUE1),(VALUE2)))
]]])m4_dnl
m4_divert(0)m4_dnl
DEFINE_COMPARISON([[[equal]]])

#define mmux_libc_ctype_value(VALUE)							\
  (_Generic((VALUE),									\
	    mmux_libc_socket_address_family_t:		((VALUE).value),		\
	    mmux_libc_socket_protocol_family_t:		((VALUE).value),		\
            mmux_libc_insix_addr_t:			((VALUE).value),		\
            mmux_libc_in_addr_t:			((VALUE).value),		\
            mmux_host_byteorder_uint16_t:		((VALUE).value),		\
            mmux_network_byteorder_uint16_t:		((VALUE).value),		\
            mmux_host_byteorder_uint32_t:		((VALUE).value),		\
            mmux_network_byteorder_uint32_t:		((VALUE).value),		\
	    default:					mmux_ctype_value(VALUE)))


/** --------------------------------------------------------------------
 ** Done.
 ** ----------------------------------------------------------------- */

#endif /* MMUX_CC_LIBC_GENERICS_H */

/* end of file */
