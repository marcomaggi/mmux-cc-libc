m4_divert(-1)m4_dnl
m4_dnl
m4_dnl Part of: MMUX CC Libc Macros
m4_dnl Contents: macros for code generation
m4_dnl Date: Dec  8, 2024
m4_dnl
m4_dnl Abstract
m4_dnl
m4_dnl		This library  defines macros to  generate C language code.
m4_dnl
m4_dnl Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>
m4_dnl
m4_dnl This program is free  software: you can redistribute it and/or  modify it under the
m4_dnl terms  of  the  GNU General  Public  License  as  published  by the  Free  Software
m4_dnl Foundation, either version 3 of the License, or (at your option) any later version.
m4_dnl
m4_dnl This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
m4_dnl WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
m4_dnl PARTICULAR PURPOSE.  See the GNU General Public License for more details.
m4_dnl
m4_dnl You should have received  a copy of the GNU General Public  License along with this
m4_dnl program.  If not, see <http://www.gnu.org/licenses/>.
m4_dnl


m4_dnl preamble

m4_changequote(`[[[', `]]]')
m4_changecom([[[/*]]],[[[*/]]])


m4_dnl helpers

m4_define([[[MMUX_M4_TOUPPER]]],[[[m4_translit([[[$1]]],[[[abcdefghijklmnopqrstuvwxyz]]],[[[ABCDEFGHIJKLMNOPQRSTUVWXYZ]]])]]])
m4_define([[[MMUX_M4_TOLOWER]]],[[[m4_translit([[[$1]]],[[[ABCDEFGHIJKLMNOPQRSTUVWXYZ]]],[[[abcdefghijklmnopqrstuvwxyz]]])]]])


m4_dnl common functions generation

m4_dnl $1 - data structure name
m4_dnl $2 - field name
m4_dnl $3 - field type
m4_dnl
m4_dnl Usage example:
m4_dnl
m4_dnl   DEFINE_STRUCT_SETTER_GETTER(flock, l_type, mmux_sshort_t)
m4_dnl
m4_define([[[DEFINE_STRUCT_SETTER_GETTER]]],[[[bool
mmux_libc_$2_set (mmux_libc_$1_t * const P, $3 value)
{
  P->$2 = value;
  return false;
}
bool
mmux_libc_$2_ref ($3 * result_p, mmux_libc_$1_t const * const P)
{
  *result_p = P->$2;
  return false;
}]]])

m4_dnl $1 - data structure name
m4_dnl $2 - field name
m4_dnl $3 - field type
m4_dnl $4 - functionstem
m4_dnl
m4_dnl Usage example:
m4_dnl
m4_dnl   DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_family, mmux_sshort_t, sinsix_family)
m4_dnl
m4_define([[[DEFINE_STRUCT_SETTER_GETTER_SPLIT]]],[[[bool
mmux_libc_$4_set (mmux_libc_$1_t * const P, $3 value)
{
  P->$2 = value;
  return false;
}
bool
mmux_libc_$4_ref ($3 * result_p, mmux_libc_$1_t const * const P)
{
  *result_p = P->$2;
  return false;
}]]])

m4_dnl $1 - data structure name
m4_dnl $2 - field name
m4_dnl $3 - field type
m4_dnl
m4_dnl Usage example:
m4_dnl
m4_dnl   DEFINE_STRUCT_SETTER_GETTER_PROTOS(flock, l_type, mmux_sshort_t)
m4_dnl
m4_define([[[DEFINE_STRUCT_SETTER_GETTER_PROTOS]]],
[[[mmux_cc_libc_decl bool mmux_libc_$2_set (mmux_libc_$1_t * P, $3 value);
mmux_cc_libc_decl bool mmux_libc_$2_ref ($3 * result_p, mmux_libc_$1_t const * P);
]]])

m4_dnl $1 - data structure name
m4_dnl $2 - field name
m4_dnl $3 - field type
m4_dnl $4 - functionstem
m4_dnl
m4_dnl Usage example:
m4_dnl
m4_dnl   DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS(sockaddr_insix, sin6_family, mmux_sshort_t, sinsix_family)
m4_dnl
m4_define([[[DEFINE_STRUCT_SETTER_GETTER_SPLIT_PROTOS]]],
[[[mmux_cc_libc_decl bool mmux_libc_$4_set (mmux_libc_$1_t * P, $3 value);
mmux_cc_libc_decl bool mmux_libc_$4_ref ($3 * result_p, mmux_libc_$1_t const * P);
]]])


m4_dnl helpers

m4_dnl $1 - Preprocessor symbol: if defined to 1, include the body of code; otherwise include the alternative body.
m4_dnl $2 - The body of code.
m4_dnl $3 - The alternative of code.
m4_define([[[MMUX_CONDITIONAL_CODE]]],[[[m4_ifelse([[[$1]]],,[[[$2]]],[[[m4_dnl
#if ((defined $1) && (1 == $1))
$2
m4_ifelse([[[$3]]],,,[[[m4_dnl
#else
$3
]]])
#endif
]]])]]])

m4_dnl $1 - Preprocessor symbol: if defined to 1, include the body of code; otherwise include the alternative body.
m4_dnl $2 - The body of code.
m4_dnl $3 - The alternative of code.
m4_define([[[MMUX_CONDITIONAL_FUNCTION_BODY]]],[[[MMUX_CONDITIONAL_CODE([[[$1]]],[[[$2]]],[[[errno = MMUX_LIBC_ENOSYS;
return true;
]]])]]])


m4_dnl let's go

m4_dnl end of file
m4_dnl Local Variables:
m4_dnl mode: m4
m4_dnl End:
m4_divert(0)m4_dnl
