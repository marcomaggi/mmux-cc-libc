### mmux.m4 --
#
# Part of: MMUX Packages Infrastructure
# Contents: common GNU Autoconf macros
# Date: a long time ago
#
# Abstract
#
#       This  is a  collection of  GNU Autoconf  macros used,  by the  author, in  most of  the MMUX
#       packages.  To use it put the following in the "acinclude.m4" file:
#
#               m4_include(path/to/mmux.m4)
#
# Copyright (c) 2018, 2019, 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public  License as  published by  the Free Software  Foundation, either  version 3  of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# General Public License for more details.
#
# You should  have received a copy  of the GNU General  Public License along with  this program.  If
# not, see <http://www.gnu.org/licenses/>.
#


#### helpers

m4_define([mmux_is_yes],        ["x$[]$1" = "xyes"])
m4_define([mmux_is_no],         ["x$[]$1" = "xno"])
m4_define([mmux_is_one],        ["x$[]$1" = "x1"])
m4_define([mmux_is_zero],       ["x$[]$1" = "x0"])
m4_define([mmux_is_empty],      ["x$[]$1" = "x"])
m4_define([mmux_is_not_empty],  ["x$[]$1" != "x"])

m4_define([mmux_test_variable_is_yes],       [test mmux_is_yes([$1])])
m4_define([mmux_test_variable_is_no],        [test mmux_is_no([$1])])
m4_define([mmux_test_variable_is_one],       [test mmux_is_one([$1])])
m4_define([mmux_test_variable_is_zero],      [test mmux_is_zero([$1])])
m4_define([mmux_test_variable_is_empty],     [test mmux_is_empty([$1])])
m4_define([mmux_test_variable_is_not_empty], [test mmux_is_not_empty([$1])])

m4_define([mmux_test_variables_are_yes],        [test m4_map_sep([mmux_is_yes],[ -a ],$@)])
m4_define([mmux_test_variables_are_no],         [test m4_map_sep([mmux_is_no],[ -a ],$@)])
m4_define([mmux_test_variables_are_one],        [test m4_map_sep([mmux_is_one],[ -a ],$@)])
m4_define([mmux_test_variables_are_zero],       [test m4_map_sep([mmux_is_zero],[ -a ],$@)])
m4_define([mmux_test_variables_are_empty],      [test m4_map_sep([mmux_is_empty],[ -a ],$@)])
m4_define([mmux_test_variables_are_not_empty],  [test m4_map_sep([mmux_is_not_empty],[ -a ],$@)])

# Synopsis:
#
#       MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([VARNAME],[BODY])
#
# Parameters:
#
#       $1 - The name of the variable to save.
#       $2 - The body to evaluate while the variable has been saved.
#
# Description:
#
#       Save the value of a shell variable while evaluating  a body of code.  Uses of this macro can
#       be nested, but not for the same variable.
#
#             MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([LIBS],
#               [AS_VAR_APPEND([LIBS],[" -lmylib"])
#                ...])
#
AC_DEFUN([MMUX_AUTOCONF_SAVE_SHELL_VARIABLE],[AS_VAR_SET([mmux_OLD_$1],[$[]$1])
$2
AS_VAR_SET([$1],[$[]mmux_OLD_$1])])

# Synopsis:
#
#       MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([VARNAME],[WHAT_TO_APPEND],[BODY])
#
# Parameters:
#
#       $1 - The name of the variable to save.
#       $2 - a double-quoted string that has to be appended to the variable while evaluating the body
#       $3 - The body to evaluate while the variable has been saved.
#
# Description:
#
#       Save the value of a shell variable while evaluating  a body of code.  Uses of this macro can
#       be nested, but not for the same variable.  While the body is evaluated: a string is appended
#       to the previous value of the variable; this is a common situation with "LIBS" and "CFLAGS".
#
# Usage examples:
#
#       MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([LIBS],[" -lmylib"],[...])
#       MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([CFLAGS],[" -I/include/mylib"],[...])
#
AC_DEFUN([MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING],
  [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([$1],
     [AS_VAR_APPEND([$1],[$2])
      $3])])

# Synopsis:
#
#       MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([VARNAME],[DOCUMENTATION],[BODY])
#
# Parameters:
#
#       $1 - The name of the configuration variable.
#       $2 - The documentation of the variable.
#       $3 - The body to evaluate.
#
# Description:
#
#       Always define a configuration variable, by default  setting it to '0'.  Then evaluate a body
#       of code,  which is  supposed to set  the variable to  '1' if  some condition is  true.  Then
#       always define:
#
#       1. a C language preprocessor macro with the same name of the variable;
#
#       2. a GNU Autoconf substitution symbol with the same name of the variable.
#
# Usage example:
#
#       MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_SLLONG],
#         [Always defined, set to 1 if MMUX support for type 'signed long long int' is enabled.],
#         [...])
#
#       the name of the configuration variable is "MMUX_CC_TYPES_HAS_SLLONG".
#
AC_DEFUN([MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE],
  [AS_VAR_SET([$1],[0])
   $3
   AC_DEFINE_UNQUOTED([$1],[$$1],[$2])
   AC_SUBST([$1])])

# Synopsis:
#
#       MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([TYPESTEM],[TYPEDEF])
#
# Parameters:
#
#       $1 - The stem of the C language type
#       $2 - The C language type specification
#
# Description:
#
#       Print a message reporting if MMUX support for a  type is enabled.  This macro is meant to be
#       used along with the macros:
#
#               MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE
#               MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY
#
#       If the variable  "MMUX_CC_TYPES_HAS_TYPESTEM": is set to 1, the  message will state "support
#       enabled";  is set  to 0,  the  message will  state  "support disabled".   "TYPESTEM" is  the
#       uppercase translation of $1.
#
# Usage example:
#
#       MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_SLLONG],
#         [Always defined, set to 1 if MMUX support for type 'signed long long int' is enabled.],
#         [...])
#
#       the name of the configuration variable is "MMUX_CC_TYPES_HAS_SLLONG".
#
AC_DEFUN([MMUX_CC_TYPE_SUPPORT_MSG_CHECKING],
  [AC_MSG_CHECKING([for MMUX supporting '$2'])
   AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_[]m4_toupper($1)])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])])])


# Synopsis
#
#       MMUX_PKG_VERSIONS([MAJOR_VERSION], [MINOR_VERSION], [PATCH_LEVEL], [PRERELEASE_TAG], [BUILD_METADATA])
#
# Description
#
#       Define the  appropriate m4 macros used  to set various package  semantic version components.
#       For the definition of semantic versioning see:
#
#                         <http://semver.org/>
#
#       This macro is meant to be used right before AC_INIT as:
#
#               MMUX_PKG_VERSIONS([MAJOR_VERSION],[MINOR_VERSION],[PATCH_LEVEL],[PRERELEASE_TAG],[BUILD_METADATA])
#               AC_INIT(..., MMUX_PACKAGE_VERSION, ...)
#
#        the arguments PRERELEASE_TAG and BUILD_METADATA are optional.  For example:
#
#               MMUX_PKG_VERSIONS([0],[1],[0],[devel.0],[x86_64])
#
#       The value of  PRERELEASE_TAG must be a  string like "devel.0", without a  leading dash.  The
#       value of BUILD_METADATA_TAG must be a string like "x86_64", without a leading plus.
#
#       This macro defines the following m4 macros:
#
#       MMUX_PACKAGE_MAJOR_VERSION: the major version number.
#
#       MMUX_PACKAGE_MINOR_VERSION: the minor version number.
#
#       MMUX_PACKAGE_PATCH_LEVEL: the patch level number.
#
#       MMUX_PACKAGE_PRERELEASE_TAG: the prerelease tag string as specified by semantic versioning.
#
#       MMUX_PACKAGE_BUILD_METADATA: the build metadata string as specified by semantic versioning.
#
#       MMUX_PACKAGE_VERSION: the package version string as required by AC_INIT; it includes neither
#       the prerelease tag nor the build metadata.
#
#       MMUX_PACKAGE_SEMANTIC_VERSION: the full semantic version string, with a leading "v".
#
#       MMUX_PACKAGE_PKG_CONFIG_VERSION:  the  version  number  to   use  in  the  module  file  for
#       "pkg-config".
#
m4_define([MMUX_PKG_VERSIONS],[
  m4_define([MMUX_PACKAGE_MAJOR_VERSION],  [$1])
  m4_define([MMUX_PACKAGE_MINOR_VERSION],  [$2])
  m4_define([MMUX_PACKAGE_PATCH_LEVEL],    [$3])
  m4_define([MMUX_PACKAGE_PRERELEASE_TAG], [$4])
  m4_define([MMUX_PACKAGE_BUILD_METADATA], [$5])

  # If a prerelease tag argument is present: define the associated component for the PACKAGE_VERSION
  # variable; otherwise define the component to the empty string.
  #
  # Note:  "m4_ifval" is  an Autoconf  macro,  see the  documentation  in the  node "Programming  in
  # M4sugar".
  m4_define([MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG],
    m4_ifval(MMUX_PACKAGE_PRERELEASE_TAG,[-]MMUX_PACKAGE_PRERELEASE_TAG))

  # If a build metadata argument is present: define the associated component for the PACKAGE_VERSION
  # variable; otherwise define the component to the empty string.
  #
  # Note:  "m4_ifval" is  an Autoconf  macro,  see the  documentation  in the  node "Programming  in
  # M4sugar".
  m4_define([MMUX_PACKAGE_VERSION__COMPONENT_BUILD_METADATA],
    m4_ifval(MMUX_PACKAGE_BUILD_METADATA,[+]MMUX_PACKAGE_BUILD_METADATA))

  # Result variables.
  m4_define([MMUX_PACKAGE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG)
  m4_define([MMUX_PACKAGE_SEMANTIC_VERSION],[v]MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG[]MMUX_PACKAGE_VERSION__COMPONENT_BUILD_METADATA)
  m4_define([MMUX_PACKAGE_PKG_CONFIG_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL)
])


# Synopsis
#
#       MMUX_INIT
#
# Description
#
#       Initialisation code for MMUX macros.
#
AC_DEFUN([MMUX_INIT],[
  AC_MSG_NOTICE([package major version:]  MMUX_PACKAGE_MAJOR_VERSION)
  AC_MSG_NOTICE([package minor version:]  MMUX_PACKAGE_MINOR_VERSION)
  AC_MSG_NOTICE([package patch level:]    MMUX_PACKAGE_PATCH_LEVEL)
  AC_MSG_NOTICE([package prerelease tag:] MMUX_PACKAGE_PRERELEASE_TAG)
  AC_MSG_NOTICE([package build metadata:] MMUX_PACKAGE_BUILD_METADATA)
  AC_MSG_NOTICE([package version:] MMUX_PACKAGE_VERSION)
  AC_MSG_NOTICE([package semantic version:] MMUX_PACKAGE_SEMANTIC_VERSION)
  AC_MSG_NOTICE([package pkg-config module version:] MMUX_PACKAGE_PKG_CONFIG_VERSION)

  # This is used to generate TAGS files for the C language.
  AS_VAR_SET([MMUX_DEPENDENCIES_INCLUDES])
])


# Synopsis
#
#       MMUX_OUTPUT
#
# Description
#
#       Define what is needed to end the MMUX  package preparations.  This macro is meant to be used
#       right before AC_output, as follows:
#
#               MMUX_OUTPUT
#               AC_OUTPUT
#
#       This macro defines the following substitutions:
#
#       MMUX_PKG_CONFIG_VERSION: the version string to be used in the module for pkg-config.
#
#       SLACKWARE_PACKAGE_VERSION: the version  string to be used when building  a Slackware package
#       file.
#
AC_DEFUN([MMUX_OUTPUT],[
  AC_SUBST([MMUX_PKG_MAJOR_VERSION],MMUX_PACKAGE_MAJOR_VERSION)
  AC_SUBST([MMUX_PKG_MINOR_VERSION],MMUX_PACKAGE_MINOR_VERSION)
  AC_SUBST([MMUX_PKG_PATCH_LEVEL],MMUX_PACKAGE_PATCH_LEVEL)
  AC_SUBST([MMUX_PKG_PRERELEASE_TAG],MMUX_PACKAGE_PRERELEASE_TAG)
  AC_SUBST([MMUX_PKG_BUILD_METADATA],MMUX_PACKAGE_BUILD_METADATA)
  AC_SUBST([MMUX_PKG_VERSION],MMUX_PACKAGE_VERSION)
  AC_SUBST([MMUX_PKG_SEMANTIC_VERSION],MMUX_PACKAGE_SEMANTIC_VERSION)

  # This is the version stored in the pkg-config data file.
  AC_SUBST([MMUX_PKG_CONFIG_VERSION],MMUX_PACKAGE_PKG_CONFIG_VERSION)

  # This  is the  version number  to be  used when  generating Slackware
  # packages.
  AC_SUBST([SLACKWARE_PACKAGE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_PRERELEASE_TAG)

  # This  is  the build  metadata  string  to  be used  when  generating
  # Slackware  packages.   It  should  be  something  like  "noarch"  or
  # "x84_64".
  AC_SUBST([SLACKWARE_BUILD_METADATA],MMUX_PACKAGE_BUILD_METADATA)

  # This is used to generate TAGS files for the C language.
  AC_SUBST([MMUX_DEPENDENCIES_INCLUDES])
])


# Synopsis:
#
#       MMUX_CHECK_TARGET_OS
#
# Description:
#
#       Inspect  the value  of the  variable "target_os"  and defines  variables, substitutions  and
#       Automake conditionals according to it.
#
#       The following variables, substitutions and preprocessor macros are defined:
#
#       MMUX_ON_LINUX - set to 1 on a GNU+Linux system, otherwise set to 0.
#
#       MMUX_ON_BSD: set to 1 on a BSD system, otherwise set to 0.
#
#       MMUX_ON_CYGWIN: set to 1 on a CYGWIN system, otherwise set to 0.
#
#       MMUX_ON_DARWIN: set to 1 on a Darwin system, otherwise set to 0.
#
#       The following GNU Automake conditionals are defined:
#
#       ON_LINUX: set to 1 on a GNU+Linux system, otherwise set to 0.
#
#       ON_BSD: set to 1 on a BSD system, otherwise set to 0.
#
#       ON_CYGWIN: set to 1 on a CYGWIN system, otherwise set to 0.
#
#       ON_DARWIN: set to 1 on a Darwin system, otherwise set to 0.
#
AC_DEFUN([MMUX_CHECK_TARGET_OS],
  [AS_VAR_SET([MMUX_ON_LINUX], [0])
   AS_VAR_SET([MMUX_ON_BSD],   [0])
   AS_VAR_SET([MMUX_ON_CYGWIN],[0])
   AS_VAR_SET([MMUX_ON_DARWIN],[0])

   AS_CASE("$target_os",
     [*linux*],
     [AS_VAR_SET([MMUX_ON_LINUX],[1])
      AC_MSG_NOTICE([detected OS: linux])],
     [*bsd*],
     [AS_VAR_SET([MMUX_ON_BSD],[1])
      AC_MSG_NOTICE([detected OS: BSD])],
     [*cygwin*],
     [AS_VAR_SET([MMUX_ON_CYGWIN],[1])
      AC_MSG_NOTICE([detected OS: CYGWIN])],
     [*darwin*],
     [AS_VAR_SET([MMUX_ON_DARWIN],[1])
      AC_MSG_NOTICE([detected OS: DARWIN])])

   AM_CONDITIONAL([ON_LINUX], [mmux_test_variable_is_one([MMUX_ON_LINUX])])
   AM_CONDITIONAL([ON_BSD],   [mmux_test_variable_is_one([MMUX_ON_BSD])])
   AM_CONDITIONAL([ON_CYGWIN],[mmux_test_variable_is_one([MMUX_ON_CYGWIN])])
   AM_CONDITIONAL([ON_DARWIN],[mmux_test_variable_is_one([MMUX_ON_DARWIN])])

   AC_SUBST([MMUX_ON_LINUX])
   AC_SUBST([MMUX_ON_BSD])
   AC_SUBST([MMUX_ON_CYGWIN])
   AC_SUBST([MMUX_ON_DARWIN])

   AC_DEFINE_UNQUOTED([MMUX_ON_LINUX], [$MMUX_ON_LINUX],  [True if the underlying platform is GNU+Linux])
   AC_DEFINE_UNQUOTED([MMUX_ON_BSD],   [$MMUX_ON_BSD],    [True if the underlying platform is BSD])
   AC_DEFINE_UNQUOTED([MMUX_ON_CYGWIN],[$MMUX_ON_CYGWIN], [True if the underlying platform is Cygwin])
   AC_DEFINE_UNQUOTED([MMUX_ON_DARWIN],[$MMUX_ON_DARWIN], [True if the underlying platform is Darwin])
   ])


# Synopsis:
#
#       MMUX_LIBTOOL_LIBRARY_VERSIONS(stem,current,revision,age)
#
# Parameters:
#
#       $1 - The library stem; if the library is "libspiffy.so", its stem is "spiffy"
#       $2 - The current version number.
#       $3 - The revision version number.
#       $4 - The age version number.
#
# Description:
#
#       Set version numbers for libraries built with GNU Libtool.  For details see the node "Libtool
#       versioning" in the GNU Libtool Info documentation.
#
AC_DEFUN([MMUX_LIBTOOL_LIBRARY_VERSIONS],
  [AS_VAR_SET([$1_VERSION_INTERFACE_CURRENT],[$2])
   AS_VAR_SET([$1_VERSION_INTERFACE_REVISION],[$3])
   AS_VAR_SET([$1_VERSION_INTERFACE_AGE],[$4])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_CURRENT],
     [$$1_VERSION_INTERFACE_CURRENT],
     [current interface number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_REVISION],
     [$$1_VERSION_INTERFACE_REVISION],
     [current interface implementation number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_AGE],
     [$$1_VERSION_INTERFACE_AGE],
     [current interface age number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_STRING],
     ["$$1_VERSION_INTERFACE_CURRENT.$$1_VERSION_INTERFACE_REVISION"],
     [library interface version])
   AC_SUBST([$1_VERSION_INTERFACE_CURRENT])
   AC_SUBST([$1_VERSION_INTERFACE_REVISION])
   AC_SUBST([$1_VERSION_INTERFACE_AGE])])


# Synopsis:
#
#       MMUX_AUTOCONF_ENABLE_OPTION(UPCASE_OPNAME, COMMAND_LINE_OPTION, DEFAULT, CHECKING_OPTION_MESSAGE, ENABLE_OPTION_MESSAGE)
#
# Parameters:
#
#       $1 - upper case option name
#       $2 - command line option name "--enable-$2"
#       $3 - default (yes, no)
#       $4 - text for the "checking option... " message
#       $5 - text for the "enable option... " message
#
# Description:
#
#       Wrapper  for  AC_ARG_ENABLE  which  adds  verbose messages  and  defines  a  shell  variable
#       "mmux_enable_$1" set to "yes" or "no".
#
# Usage example:
#
#               MMUX_AUTOCONF_ENABLE_OPTION([CC_TYPE_SLLONG], [mmux-cc-type-sllong], [yes],
#                 [whether to enable MMUX support for the C language type 'sllong'],
#                 [enables MMUX support for the C language type 'sllong'])
#
#       sets the variable "mmux_enable_CC_TYPE_SLLONG" to "yes" or "no".
#
AC_DEFUN([MMUX_AUTOCONF_ENABLE_OPTION],
  [AS_VAR_SET(mmux_enable_$1,$3)
   AC_MSG_CHECKING([$4])
   AC_ARG_ENABLE([$2],
     [AS_HELP_STRING([--enable-$2],
        [$5 (default is '$3')])],
     [AS_CASE([$enableval],
        [yes],[AS_VAR_SET([mmux_enable_$1],[yes])],
        [no], [AS_VAR_SET([mmux_enable_$1],[no])],
        [AC_MSG_ERROR([bad value $enableval for --enable-$2])])],
     [AS_VAR_SET(mmux_enable_$1,$3)])
   AC_MSG_RESULT([$mmux_enable_$1])])


# Synopsis:
#
#       MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION(TYPESTEM)
#
# Parameters:
#
#       $1 - type stem
#
# Description:
#
#       Wrapper for  MMUX_AUTOCONF_ENABLE_OPTION which adds  an enable  option for a  MMUX supported
#       type.   The  type itself  is  selected  with its  stem:  sllong,  ullong, float32,  float64,
#       float128,  float32x,  float64x,  float128x,   decimal32,  decimal64,  decimal128,  complexf,
#       complexd,  complexld, complexlf32,  complexlf64,  complexlf128, complexlf32x,  complexlf64x,
#       complexlf128x, complexd32, complexd64, complexd128.
#
# Usage example:
#
#               MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION([sllong])
#
AC_DEFUN([MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION],
  [MMUX_AUTOCONF_ENABLE_OPTION([CC_TYPE_[]m4_toupper($1)], [mmux-cc-type-[]m4_tolower($1)], [yes],
     [whether to enable MMUX support for the C language type] 'm4_tolower($1)',
     [enables MMUX support for the C language type] 'm4_tolower($1)')])


# Synopsis:
#
#       MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY(TYPESTEM, BODY)
#
# Parameters:
#
#       $1 - type stem
#       $2 - body of code to evaluate if the type support is requested
#
# Description:
#
#       Wrapper for  MMUX_AUTOCONF_ENABLE_OPTION which adds  an enable  option for a  MMUX supported
#       type.   The  type itself  is  selected  with its  stem:  sllong,  ullong, float32,  float64,
#       float128,  float32x,  float64x,  float128x,   decimal32,  decimal64,  decimal128,  complexf,
#       complexd,  complexld, complexlf32,  complexlf64,  complexlf128, complexlf32x,  complexlf64x,
#       complexlf128x, complexd32, complexd64, complexd128.
#
# Usage example:
#
#               MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([sllong], [...])
#
AC_DEFUN([MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY],
  [MMUX_AUTOCONF_ENABLE_OPTION([CC_TYPE_[]m4_toupper($1)], [mmux-cc-type-[]m4_tolower($1)], [yes],
     [whether to enable MMUX support for the C language type] 'm4_tolower($1)',
     [enables MMUX support for the C language type] 'm4_tolower($1)')
   AS_IF([mmux_test_variable_is_yes([mmux_enable_CC_TYPE_[]m4_toupper($1)])],
         [$2])])


# Synopsis:
#
#       MMUX_CHECK_PKG_CONFIG_MACROS
#
# Description:
#
#       Test if  the macro PKG_CHECK_MODULES  is defined at  macro-expansion time.  This  test works
#       only if the file "configure.ac" also contains an actual expansion of PKG_CHECK_MODULES.
#
AC_DEFUN([MMUX_CHECK_PKG_CONFIG_MACROS],
  [AC_MSG_CHECKING([availability of pkg-config m4 macros])
   AS_IF([test m4_ifdef([PKG_CHECK_MODULES],[yes],[no]) = yes],
     [AC_MSG_RESULT([yes])],
     [AC_MSG_RESULT([no])
      AC_MSG_ERROR([pkg-config is required.  See pkg-config.freedesktop.org])])])


# Synopsis:
#
#       MMUX_LANG_C11
#
# Description:
#
#       Define the appropriate flags  to use the C11 standard language.  Such  flags are appended to
#       the current definition of the variable "CC".
#
#       This macro is meant to be used as:
#
#               AC_LANG([C])
#               MMUX_LANG_C11
#
#       If the variable "GCC" is set to "yes": select additional warning flags to be handed to the C
#       compiler.  Such flags are appended to the  variable MMUX_CFLAGS, which is also configured as
#       substitution  (and so  it becomes  a Makefile  variable).  We  should use  such variable  to
#       compile commands as follows, in "Makefile.am":
#
#               AM_CFLAGS = $(MMUX_CFLAGS)
#
AC_DEFUN([MMUX_LANG_C11],[
  AX_REQUIRE_DEFINED([AX_CHECK_COMPILE_FLAG])
  AX_REQUIRE_DEFINED([AX_APPEND_COMPILE_FLAGS])
  AX_REQUIRE_DEFINED([AX_GCC_VERSION])
  AC_REQUIRE([AX_IS_RELEASE])

  AC_PROG_CC
  AX_CHECK_COMPILE_FLAG([-std=c11],
    [AX_APPEND_FLAG([-std=c11], [CC])],
    [AC_MSG_ERROR([*** Compiler does not support -std=c11])],
    [-pedantic])

  AS_VAR_IF(GCC,'yes',
    [AX_GCC_VERSION])

  AC_SUBST([MMUX_CFLAGS])
  AC_DEFINE([_ISOC11_SOURCE],[1],[Enable the ISO C11 features.])

  # These flags are for every compiler.
  AS_VAR_IF(ax_is_release,'no',
    [AX_APPEND_COMPILE_FLAGS([-Wall -Wextra -pedantic], [MMUX_CFLAGS], [-Werror])])

  # These flags are for GCC only.
  AS_VAR_IF(ax_is_release,'no',
    [AS_VAR_IF(GCC,'yes',
      [AX_APPEND_COMPILE_FLAGS([-Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wrestrict], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wnull-dereference -Wjump-misses-init -Wdouble-promotion -Wshadow], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wformat=2 -Wmisleading-indentation -Wattributes -Wuninitialized], [MMUX_CFLAGS], [-Werror])])])

  MMUX_CC_CHECK_COMMON_HEADERS])


# Synopsis:
#
#       MMUX_LANG_C23
#
# Description:
#
#       Define the appropriate flags  to use the C23 standard language.  Such  flags are appended to
#       the current definition of the variable "CC".
#
#       This macro is meant to be used as:
#
#               AC_LANG([C])
#               MMUX_LANG_C23
#
#       If the variable "GCC" is set to "yes": select additional warning flags to be handed to the C
#       compiler.  Such flags are appended to the  variable MMUX_CFLAGS, which is also configured as
#       substitution  (and so  it becomes  a Makefile  variable).  We  should use  such variable  to
#       compile commands as follows, in "Makefile.am":
#
#               AM_CFLAGS = $(MMUX_CFLAGS)
#
AC_DEFUN([MMUX_LANG_C23],[
  AX_REQUIRE_DEFINED([AX_CHECK_COMPILE_FLAG])
  AX_REQUIRE_DEFINED([AX_APPEND_COMPILE_FLAGS])
  AX_REQUIRE_DEFINED([AX_GCC_VERSION])
  AC_REQUIRE([AX_IS_RELEASE])

  AC_PROG_CC
  AX_CHECK_COMPILE_FLAG([-std=c23],
    [AX_APPEND_FLAG([-std=c23], [CC])],
    [AC_MSG_ERROR([*** Compiler does not support -std=c23])],
    [-pedantic])

  AS_VAR_IF(GCC,'yes',
    [AX_GCC_VERSION])

  AC_SUBST([MMUX_CFLAGS])
  AC_DEFINE([_ISOC11_SOURCE],[1],[Enable the ISO C11 features.])

  # These flags are for every compiler.
  AS_VAR_IF(ax_is_release,'no',
    [AX_APPEND_COMPILE_FLAGS([-Wall -Wextra -pedantic], [MMUX_CFLAGS], [-Werror])])

  # These flags are for GCC only.
  AS_VAR_IF(ax_is_release,'no',
    [AS_VAR_IF(GCC,'yes',
      [AX_APPEND_COMPILE_FLAGS([-Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wrestrict], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wnull-dereference -Wjump-misses-init -Wdouble-promotion -Wshadow], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wformat=2 -Wmisleading-indentation -Wattributes -Wuninitialized], [MMUX_CFLAGS], [-Werror])])])

  MMUX_CC_CHECK_COMMON_HEADERS])


# Synopsis:
#
#       MMUX_LANG_GCC23
#
# Description:
#
#       Define the appropriate flags to use the C23 standard language with GCC "-fplan9-extensions".
#       Such flags are appended to the current definition of the variable "CC".
#
#       This macro is meant to be used as:
#
#               AC_LANG([C])
#               MMUX_LANG_GCC23
#
#       If the variable "GCC" is set to "yes": select additional warning flags to be handed to the C
#       compiler.  Such flags are appended to the  variable MMUX_CFLAGS, which is also configured as
#       substitution  (and so  it becomes  a Makefile  variable).  We  should use  such variable  to
#       compile commands as follows, in "Makefile.am":
#
#               AM_CFLAGS = $(MMUX_CFLAGS)
#
AC_DEFUN([MMUX_LANG_GCC23],[
  AX_REQUIRE_DEFINED([AX_CHECK_COMPILE_FLAG])
  AX_REQUIRE_DEFINED([AX_APPEND_COMPILE_FLAGS])
  AX_REQUIRE_DEFINED([AX_GCC_VERSION])
  AC_REQUIRE([AX_IS_RELEASE])

  AC_PROG_CC
  AX_CHECK_COMPILE_FLAG([-std=c23],
    [AX_APPEND_FLAG([-std=c23], [CC])],
    [AC_MSG_ERROR([*** Compiler does not support -std=c23])],
    [-pedantic])

  AX_CHECK_COMPILE_FLAG([-fplan9-extensions],
    [AX_APPEND_FLAG([-fplan9-extensions], [CC])],
    [AC_MSG_ERROR([*** Compiler does not support -fplan9-extensions])])

  AS_VAR_IF(GCC,'yes',
    [AX_GCC_VERSION])

  AC_SUBST([MMUX_CFLAGS])
  AC_DEFINE([_ISOC11_SOURCE],[1],[Enable the ISO C11 features.])

  # These flags are for every compiler.
  AS_VAR_IF(ax_is_release,'no',
    [AX_APPEND_COMPILE_FLAGS([-Wall -Wextra -pedantic], [MMUX_CFLAGS], [-Werror])])

  # These flags are for GCC only.
  AS_VAR_IF(ax_is_release,'no',
    [AS_VAR_IF(GCC,'yes',
      [AX_APPEND_COMPILE_FLAGS([-Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wrestrict], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wnull-dereference -Wjump-misses-init -Wdouble-promotion -Wshadow], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wformat=2 -Wmisleading-indentation -Wattributes -Wuninitialized], [MMUX_CFLAGS], [-Werror])])])

  MMUX_CC_CHECK_COMMON_HEADERS])


# Synopsis:
#
#       MMUX_CC_CHAR_IS_UNSIGNED
#
# Description:
#
#       Check if "char" is defined as unsigned on the underlying platform.
#
#       If it is unsigned define "__CHAR_UNSIGNED__".
#
#       If it is unsigned define to 1 the subst symbol: MMUX_CC_TYPES_CHAR_IS_UNSIGNED.
#
AC_DEFUN([MMUX_CC_CHAR_IS_UNSIGNED],[
  AC_C_CHAR_UNSIGNED
  AC_MSG_CHECKING([MMUX char is unsigned])
  AS_VAR_SET([MMUX_CC_TYPES_CHAR_IS_UNSIGNED],[0])
  AS_IF(mmux_test_variable_is_yes([ac_cv_c_char_unsigned]),
    [AS_VAR_SET([MMUX_CC_TYPES_CHAR_IS_UNSIGNED],[1])
     AC_MSG_RESULT([yes])],
    [AS_VAR_SET([MMUX_CC_TYPES_CHAR_IS_UNSIGNED],[0])
     AC_MSG_RESULT([no])])
  AC_SUBST([MMUX_CC_TYPES_CHAR_IS_UNSIGNED],[$MMUX_CC_TYPES_CHAR_IS_UNSIGNED])
])


# Synopsis:
#
#     MMUX_CC_CHECK_COMMON_HEADERS
#
# Description:
#
#     Check  for all  the  common C  language  headers needed  when writing  a  GNU Bash  builtins
#     extension; and probably something more.  We should just use this macro somewhere like this:
#
#             AC_LANG([C])
#             ...
#             MMUX_CC_CHECK_COMMON_HEADERS
#
AC_DEFUN([MMUX_CC_CHECK_COMMON_HEADERS],
  [AC_HEADER_ASSERT
   AC_HEADER_STDBOOL
   AC_HEADER_SYS_WAIT
   AC_CHECK_HEADERS([complex.h ctype.h errno.h fcntl.h float.h limits.h math.h regex.h stddef.h stdarg.h
                     time.h wchar.h sys/ioctl.h sys/time.h sys/resource.h sys/wait.h])
   AC_CACHE_SAVE])


# Synopsis:
#
#       MMUX_CC_COMMON_INCLUDES_FOR_TESTS
#
# Description:
#
#       Expand into include  directives for all the  common C language headers.  We  should use this
#       macro as parameter for  all the GNU Autoconf macros that preprocess a  C language program in
#       tests.
#
#       According  to the  documentation of  GNU Autoconf  2.72: "AC_INCLUDES_DEFAULT"  used without
#       parameters should expand  to the include directives for:  "stdio.h", "stdlib.h", "string.h",
#       "inttypes.h", "stdint.h", "strings.h", "sys/types.h", "sys/stat.h", and "unistd.h".  It also
#       checks all those headers as a side effect of this macro use's expansion.
#
#       When used  with a parameter:  AC_INCLUDES_DEFAULT should expand to  its parameter; I  do not
#       know what value there  is in wrapptng the directives like this, but  let's do it.  Let's try
#       to keep the directives in alphabetical order.
#
# Usage example:
#
#       MMUX_CC_DETERMINE_VALUEOF([SIZEOF_MY_TYPE], [sizeof(my_type_t)],
#                                 [MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
#
m4_define([MMUX_CC_COMMON_INCLUDES_FOR_TESTS],[
AC_INCLUDES_DEFAULT
AC_INCLUDES_DEFAULT([
#ifdef HAVE_ARPA_INET_H
#  include <arpa/inet.h>
#endif

#ifdef HAVE_ASSERT_H
#  include <assert.h>
#endif

#ifdef HAVE_COMPLEX_H
#  include <complex.h>
#endif

#ifdef HAVE_CTYPE_H
#  include <ctype.h>
#endif

#ifdef HAVE_DIRENT_H
#  include <dirent.h>
#endif

#ifdef HAVE_ERRNO_H
#  include <errno.h>
#endif

#ifdef HAVE_ERROR_H
#  include <error.h>
#endif

#ifdef HAVE_FCNTL_H
#  include <fcntl.h>
#endif

#ifdef HAVE_FLOAT_H
#  include <float.h>
#endif

#ifdef HAVE_GRP_H
#  include <grp.h>
#endif

#ifdef HAVE_LIMITS_H
#  include <limits.h>
#endif

#ifdef HAVE_LINUX_FS_H
#  include <linux/fs.h>
#endif

/* Right now, on my Slackware64 15.0, including this header is in
   conflict with sys/wait.h so I do not include it.  The reason for
   including it is to get the definition of P_PIDFD, which is not
   yet in glibc 2.33 (Marco Maggi; Jun 25, 2025) */
#if 0
#  ifdef HAVE_LINUX_WAIT_H
#    include <linux/wait.h>
#  endif
#endif

#ifdef HAVE_LINUX_OPENAT2_H
#  include <linux/openat2.h>
#endif

#ifdef HAVE_MATH_H
#  include <math.h>
#endif

#ifdef HAVE_NET_IF_H
#  include <net/if.h>
#endif

#ifdef HAVE_NETDB_H
#  include <netdb.h>
#endif

#ifdef HAVE_NETINET_IN_H
#  include <netinet/in.h>
#endif

#ifdef HAVE_PWD_H
#  include <pwd.h>
#endif

#ifdef HAVE_UTIME_H
#  include <utime.h>
#endif

#ifdef HAVE_SIGNAL_H
#  include <signal.h>
#endif

#ifdef HAVE_STDARG_H
#  include <stdarg.h>
#endif

#ifdef HAVE_STDBOOL_H
#  include <stdbool.h>
#endif

#ifdef HAVE_STDDEF_H
#  include <stddef.h>
#endif

#ifdef HAVE_SYS_AUXV_H
#  include <sys/auxv.h>
#endif

#ifdef HAVE_SYS_MMAN_H
#  include <sys/mman.h>
#endif

#ifdef HAVE_SYS_RESOURCE_H
#  include <sys/resource.h>
#endif

#ifdef HAVE_SYS_SELECT_H
#  include <sys/select.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#  include <sys/socket.h>
#endif

#ifdef HAVE_SYS_SYSCALL_H
#  include <sys/syscall.h>
#endif

#ifdef HAVE_SYS_TIME_H
#  include <sys/time.h>
#endif

#ifdef HAVE_SYS_UIO_H
#  include <sys/uio.h>
#endif

#ifdef HAVE_SYS_UN_H
#  include <sys/un.h>
#endif

#ifdef HAVE_SYS_WAIT_H
#  include <sys/wait.h>
#endif

#ifdef HAVE_TIME_H
#  include <time.h>
#endif

#ifdef HAVE_WAIT_H
#  include <wait.h>
#endif

#ifdef HAVE_WCHAR_H
#  include <wchar.h>
#endif
])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_VALUEOF(STEM, EXPRESSION, INCLUDES)
#
# Parameters:
#
#       $1 - Mandatory uppercase stem used to generate output variables and C preprocessor symbols.
#       $2 - Mandatory C language expression which, executed in a C program, returns the constant.
#       $3 - Optional  C language  preprocessor  directives to  include header  files; defaults  to
#            MMUX_CC_COMMON_INCLUDES_FOR_TESTS.
#
# Description:
#
#       Determine the value of a C language constant expression returning an exact integer.
#
# Usage example:
#
#       MMUX_CC_DETERMINE_VALUEOF([EINVAL], [EINVAL], [#ifdef HAVE_ERRNO_H
#       #  include <errno.h>
#       #endif])
#
# to determine the existence and value of the "errno" constant "EINVAL"; results:
#
# mmux_cv_valueof_EINVAL
#
#     A shell variable used  to cache the result.  If the symbol "EINVAL"  exists: the shell value
#     is the value of the constant itself.  If the symbol "EINVAL" does not exist: the shell value
#     is the string "MMUX_META_VALUE_UNDEFINED".
#
# MMUX_HAVE_EINVAL
#
#     A C language  preprocessor symbol.  If the symbol "EINVAL"  exists: the preprocessor symbols
#     is defined to  be "1".  If the symbol  "EINVAL" does not exist: the  preprocessor symbols is
#     defined to be "0".
#
# MMUX_VALUEOF_EINVAL
#
#     A C language preprocessor symbol.  Its uses expand to the value of EINVAL itself.
#
# MMUX_VALUEOF_EINVAL
#
#     A GNU Autoconf substitution symbol.  Its uses expand to the value of EINVAL itself.
#
AC_DEFUN([MMUX_CC_DETERMINE_VALUEOF],
  [AC_CACHE_CHECK([the value of '$2'],
     [mmux_cv_valueof_$1],
     [AC_COMPUTE_INT([mmux_cv_valueof_$1],
        [$2],
        [m4_ifblank([$3],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS],[$3])],
        [AS_VAR_SET([mmux_cv_valueof_$1],[MMUX_META_VALUE_UNDEFINED])])])
    AS_IF([test "x$mmux_cv_valueof_$1" = xMMUX_META_VALUE_UNDEFINED],
          [AS_VAR_SET([MMUX_HAVE_$1],[0])],
          [AS_VAR_SET([MMUX_HAVE_$1],[1])])
    AC_DEFINE_UNQUOTED([MMUX_HAVE_$1],   [$MMUX_HAVE_$1],[The constant value $1 is defined.])
    AC_DEFINE_UNQUOTED([MMUX_VALUEOF_$1],[$mmux_cv_valueof_$1],[The constant value $1.])
    AC_SUBST([MMUX_VALUEOF_$1],[$mmux_cv_valueof_$1])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_TYPE_SIZEOF(STEM, TYPEDEF, INCLUDES)
#
# Parameters:
#
#       $1 - The custom type stem, used to define output names.
#       $2 - The custom type name, usually a C language "typedef".
#       $3 - Optional  C language  preprocessor  directives to  include header files; defaults  to
#            MMUX_CC_COMMON_INCLUDES_FOR_TESTS.
#
# Description:
#
#       Determine the size in bytes of the C language type TYEPDEF, which can be either a standard C
#       language type or a custom type definition.
#
#       If an error occurs determining the type size: all the results will report a size of zero.
#
#       The parameter STEM is conerted to upper case or  lower case as needed, so it does not matter
#       if tha parameter itself is upper case or lower case.
#
#       Notice  that GNU  Autoconf already  defines "AC_CHECK_SIZEOF",  but sometimes  someone might
#       prefer this macros.
#
# Usage example:
#
#       MMUX_CC_DETERMINE_TYPE_SIZEOF(SSIZE, ssize_t)
#
#       determine the size  of the standard C  language type "ssize_t"; we  expect it to be  4 or 8.
#       Usage example results:
#
#       mmux_cv_cc_type_sizeof_ssize
#             Cached shell variable representing the result of the test: the size measured in bytes.
#             The stem "ssize" is the result of converting the parameter STEM to lower case.
#
#       MMUX_CC_TYPE_SIZEOF_SSIZE
#             C language preprocessor symbol  which will expand to the size  measured in bytes.  The
#             stem "SSIZE" is the result of converting the parameter STEM to upper case.
#
#       MMUX_CC_TYPE_SIZEOF_SSIZE
#             GNU Autoconf substitution symbol which will expand to the size measured in bytes.  The
#             stem "SSIZE" is the result of converting the parameter STEM to upper case.
#
AC_DEFUN([MMUX_CC_DETERMINE_TYPE_SIZEOF],
  [AC_CACHE_CHECK([the size measured in bytes of the C language type '$2'],
     [mmux_cv_cc_type_sizeof_[]m4_tolower($1)],
     [AC_COMPUTE_INT([mmux_cv_cc_type_sizeof_[]m4_tolower($1)],
        [sizeof($2)],
        [m4_ifblank([$3],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS],[$3])],
        [AS_VAR_SET([mmux_cv_cc_type_sizeof_[]m4_tolower($1)],[0])])])
   AC_DEFINE_UNQUOTED(MMUX_CC_TYPE_SIZEOF_[]m4_toupper($1),
     [$mmux_cv_cc_type_sizeof_[]m4_tolower($1)],
     [The size measured in bytes of '$2'.])
   AC_SUBST(MMUX_CC_TYPE_SIZEOF_[]m4_toupper($1),[$mmux_cv_cc_type_sizeof_[]m4_tolower($1)])])


# Synopsis:
#
#       MMUX_CC_CHECK_STANDARD_TYPES
#
# Description:
#
#       Check the availability of all the supported C language types.
#
AC_DEFUN([MMUX_CC_CHECK_STANDARD_TYPES],
  [MMUX_CC_CHECK_TYPE_SLLONG
   MMUX_CC_CHECK_TYPE_ULLONG
   MMUX_CC_CHECK_TYPE_LDOUBLE

   MMUX_CC_CHECK_TYPE_COMPLEXF
   MMUX_CC_CHECK_TYPE_COMPLEXD
   MMUX_CC_CHECK_TYPE_COMPLEXLD

   AC_SYS_LARGEFILE
   AC_SYS_YEAR2038

   AC_TYPE_INT8_T
   AC_TYPE_INT16_T
   AC_TYPE_INT32_T
   AC_TYPE_INT64_T
   AC_TYPE_UINT8_T
   AC_TYPE_UINT16_T
   AC_TYPE_UINT32_T
   AC_TYPE_UINT64_T

   AC_TYPE_MODE_T
   AC_TYPE_OFF_T
   AC_TYPE_PID_T
   AC_TYPE_SIZE_T
   AC_TYPE_SSIZE_T
   AC_TYPE_INTMAX_T
   AC_TYPE_INTPTR_T

   # This defines both "uid_t" and "gid_t".
   AC_TYPE_UID_T])


# Synopsis:
#
#       MMUX_CC_INSPECT_STANDARD_TYPES
#
# Description:
#
#       Determine the size, measured  in bytes, of all the standard C language  types; only the core
#       types  are checked  (int, long,  int32_t, ...),  none of  the feature-specific  typedefs are
#       checked (size_t, pid_t, ...).
#
AC_DEFUN([MMUX_CC_INSPECT_STANDARD_TYPES],
  [AX_REQUIRE_DEFINED([MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_REQUIRE([MMUX_CC_CHECK_COMMON_HEADERS])
   AC_REQUIRE([AC_TYPE_INT8_T])
   AC_REQUIRE([AC_TYPE_INT16_T])
   AC_REQUIRE([AC_TYPE_INT32_T])
   AC_REQUIRE([AC_TYPE_INT64_T])
   AC_REQUIRE([AC_TYPE_UINT8_T])
   AC_REQUIRE([AC_TYPE_UINT16_T])
   AC_REQUIRE([AC_TYPE_UINT32_T])
   AC_REQUIRE([AC_TYPE_UINT64_T])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([POINTER],    [void *])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([CHAR],       [char])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SCHAR],      [signed char])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UCHAR],      [unsigned char])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SSHORT],     [signed short int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([USHORT],     [unsigned short int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT],       [signed int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT],       [unsigned int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SLONG],      [signed long int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([ULONG],      [unsigned long int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SLLONG],     [signed long long int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([ULLONG],     [unsigned long long int])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([FLOAT],      [float])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([DOUBLE],     [double])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([LDOUBLE],    [long double])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([COMPLEX],    [double complex])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT8],      [int8_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT8],      [uint8_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT16],     [int16_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT16],     [uint16_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT32],     [int32_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT32],     [uint32_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT64],     [int64_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT64],     [uint64_t])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE(STEM, TYPEDEF)
#
# Parameters:
#
#       $1 - The custom type stem, used to define output names.
#       $2 - The custom type name, usually a C language "typedef".
#
# Description:
#
#       Determine the standard C  language type of which the exact signed  integer type "TYPEDEF" is
#       an alias; the standard  type is represented by one of the  stems: "schar", "sshort", "sint",
#       "slong", "sllong", "sint8", "sint16", "sint32", "sint64".
#
#       It is a fatal error if a standard stem alias is not found.
#
#       The parameter STEM is conerted to upper case or  lower case as needed, so it does not matter
#       if tha parameter itself is upper case or lower case.
#
# Prerequisites:
#
#       The expansion of this macro must be executed only after the expansion of the following macro
#       use has been executed:
#
#               MMUX_CC_DETERMINE_TYPE_SIZEOF(STEM, TYPEDEF)
#
#       which will inspect the same type.
#
# Usage example:
#
#               MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SSIZE],[ssize_t])
#
#       determine the standard C  language type of which the exact signed  integer type "ssize_t" is
#       an alias; we expect the alias to be "sint" or "slong".  Usage example results:
#
#       mmux_cv_type_stem_alias_of_ssize
#               Cached shell variable  representing the result of  the test: the variable  is set to
#               the standard stem.  The stem "ssize" is  the result of converting the parameter STEM
#               to lower case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               C  language preprocessor  symbol which  expands into  the standard  stem.  The  stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               GNU Autoconf  substitution symbol which  expands into  the standard stem.   The stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
AC_DEFUN([MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE],
  [AC_REQUIRE([MMUX_CC_INSPECT_STANDARD_TYPES])
   AC_CACHE_CHECK([the standard exact signed integer type alias of the custom exact signed integer '$2' (size=$mmux_cv_cc_type_sizeof_[]m4_tolower($1))],
     [mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [AS_CASE([$mmux_cv_cc_type_sizeof_[]m4_tolower($1)],

        [$mmux_cv_cc_type_sizeof_schar],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[schar])],

        [$mmux_cv_cc_type_sizeof_sshort],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sshort])],

        [$mmux_cv_cc_type_sizeof_sint],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint])],

        [$mmux_cv_cc_type_sizeof_slong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[slong])],

        [$mmux_cv_cc_type_sizeof_sllong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sllong])],

        [$mmux_cv_cc_type_sizeof_sint8],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint8])],

        [$mmux_cv_cc_type_sizeof_sint16],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint16])],

        [$mmux_cv_cc_type_sizeof_sint32],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint32])],

        [$mmux_cv_cc_type_sizeof_sint64],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint64])],

        # There is no stadard alias.  This should not happen.
        [AC_MSG_ERROR([unable to determine exact signed integer standard C language type alias of '$2'])])])
   AC_DEFINE_UNQUOTED(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),
     [$mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [Stem of C language standard type which is an alias of '$2'.])
   AC_SUBST(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),[$mmux_cv_type_stem_alias_of_[]m4_tolower($1)])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE(STEM, TYPEDEF)
#
# Parameters:
#
#       $1 - The custom type stem, used to define output names.
#       $2 - The custom type name, usually a C language "typedef".
#
# Description:
#
#       Determine the standard C language type of which the exact unsigned integer type "TYPEDEF" is
#       an alias; the standard  type is represented by one of the  stems: "uchar", "ushort", "uint",
#       "ulong", "ullong", "uint8", "uint16", "uint32", "uint64".
#
#       It is a fatal error if a standard stem alias is not found.
#
#       The parameter STEM is conerted to upper case or  lower case as needed, so it does not matter
#       if tha parameter itself is upper case or lower case.
#
# Prerequisites:
#
#       The expansion of this macro must be executed only after the expansion of the following macro
#       use has been executed:
#
#               MMUX_CC_DETERMINE_TYPE_SIZEOF(STEM, TYPEDEF)
#
#       which will inspect the same type.
#
# Usage example:
#
#               MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([USIZE],[size_t])
#
#       determine the standard C language type of  which the exact unsigned integer type "size_t" is
#       an alias; we expect the alias to be "uint" or "ulong".  Usage example results:
#
#       mmux_cv_type_stem_alias_of_usize
#               Cached shell variable  representing the result of  the test: the variable  is set to
#               the standard stem.  The stem "usize" is  the result of converting the parameter STEM
#               to lower case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               C  language preprocessor  symbol which  expands into  the standard  stem.  The  stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               GNU Autoconf  substitution symbol which  expands into  the standard stem.   The stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
AC_DEFUN([MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE],
  [AC_REQUIRE([MMUX_CC_INSPECT_STANDARD_TYPES])
   AC_CACHE_CHECK([the standard exact unsigned integer type alias of the custom exact unsigned integer '$2' (size=$mmux_cv_cc_type_sizeof_[]m4_tolower($1))],
     [mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [AS_CASE([$mmux_cv_cc_type_sizeof_[]m4_tolower($1)],

        [$mmux_cv_cc_type_sizeof_uchar],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uchar])],

        [$mmux_cv_cc_type_sizeof_ushort],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[ushort])],

        [$mmux_cv_cc_type_sizeof_uint],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint])],

        [$mmux_cv_cc_type_sizeof_ulong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[ulong])],

        [$mmux_cv_cc_type_sizeof_ullong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[ullong])],

        [$mmux_cv_cc_type_sizeof_uint8],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint8])],

        [$mmux_cv_cc_type_sizeof_uint16],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint16])],

        [$mmux_cv_cc_type_sizeof_uint32],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint32])],

        [$mmux_cv_cc_type_sizeof_uint64],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint64])],

        # There is no stadard alias.  This should not happen.
        [AC_MSG_ERROR([unable to determine exact unsigned integer standard C language type alias of '$2'])])])
   AC_DEFINE_UNQUOTED(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),
     [$mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [Stem of C language standard type which is an alias of '$2'.])
   AC_SUBST(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),[$mmux_cv_type_stem_alias_of_[]m4_tolower($1)])])


# Synopsis:
#
#     MMUX_CC_INSPECT_STANDARD_FEATURE_TYPES
#
# Description:
#
#     Determine the  size, measured  in bytes,  of all the  supported standard,  feature-specific, C
#     language  types   (size_t,  pid_t,  ...).   It   also  determines  aliases  that   match  each
#     feature-specific type with  the raw type; for example:  we expect "size_t" to be  an alias for
#     "unsigned long" or something like that.
#
AC_DEFUN([MMUX_CC_INSPECT_STANDARD_FEATURE_TYPES],
  [AX_REQUIRE_DEFINED([MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_REQUIRE([MMUX_CC_CHECK_COMMON_HEADERS])
   AC_REQUIRE([MMUX_CC_INSPECT_STANDARD_TYPES])
   AC_REQUIRE([AC_TYPE_MODE_T])
   AC_REQUIRE([AC_TYPE_OFF_T])
   AC_REQUIRE([AC_TYPE_PID_T])
   AC_REQUIRE([AC_TYPE_SIZE_T])
   AC_REQUIRE([AC_TYPE_SSIZE_T])
   AC_REQUIRE([AC_TYPE_INTMAX_T])
   AC_REQUIRE([AC_TYPE_INTPTR_T])
   AC_REQUIRE([AC_TYPE_UID_T])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([SSIZE],       [ssize_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([USIZE],       [size_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINTMAX],     [intmax_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINTMAX],     [uintmax_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINTPTR],     [intptr_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINTPTR],     [uintptr_t])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([PTRDIFF],     [ptrdiff_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([MODE],        [mode_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([OFF],         [off_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UID],         [uid_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([PID],         [pid_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([GID],         [gid_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([WCHAR],       [wchar_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([WINT],        [wint_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([TIME],        [time_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([CLOCK],       [clock_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SOCKLEN],     [socklen_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([RLIM],        [rlim_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([INO],         [ino_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([DEV],         [dev_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([NLINK],       [nlink_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([BLKCNT],      [blkcnt_t])

   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SSIZE],        [ssize_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SINTMAX],      [intmax_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SINTPTR],      [intptr_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([OFF],          [off_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([PID],          [pid_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([PTRDIFF],      [ptrdiff_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([WCHAR],        [wchar_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([TIME],         [time_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([CLOCK],        [clock_t])

   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([USIZE],      [size_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([UINTMAX],    [uintmax_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([UINTPTR],    [uintptr_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([MODE],       [mode_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([UID],        [uid_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([GID],        [gid_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([WINT],       [wint_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SOCKLEN],    [socklen_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([RLIM],       [rlim_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([INO],        [ino_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([DEV],        [dev_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([NLINK],      [nlink_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([BLKCNT],     [blkcnt_t])])


# Synopsis:
#
#     MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_FLOAT
#
# Description:
#
#     Check  the availability  of all  the supported  C language  types "_FloatN"  and "_FloatNx".
#     These types should not require an external library.
#
AC_DEFUN([MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_FLOAT],
  [MMUX_CC_CHECK_TYPE_FLOAT32
   MMUX_CC_CHECK_TYPE_FLOAT64
   MMUX_CC_CHECK_TYPE_FLOAT128
   MMUX_CC_CHECK_TYPE_FLOAT32X
   MMUX_CC_CHECK_TYPE_FLOAT64X
   MMUX_CC_CHECK_TYPE_FLOAT128X

   MMUX_CC_CHECK_TYPE_COMPLEXF32
   MMUX_CC_CHECK_TYPE_COMPLEXF64
   MMUX_CC_CHECK_TYPE_COMPLEXF128
   MMUX_CC_CHECK_TYPE_COMPLEXF32X
   MMUX_CC_CHECK_TYPE_COMPLEXF64X
   MMUX_CC_CHECK_TYPE_COMPLEXF128X

   AC_CACHE_SAVE])


# Synopsis:
#
#     MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_DECIMAL_FLOAT
#
# Description:
#
#     Check the availability of all the supported C language types "_DecimalN".
#
AC_DEFUN([MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_DECIMAL_FLOAT],
  [MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_FACILITIES

   MMUX_CC_CHECK_TYPE_DECIMAL32
   MMUX_CC_CHECK_TYPE_DECIMAL64
   MMUX_CC_CHECK_TYPE_DECIMAL128

   MMUX_CC_CHECK_TYPE_COMPLEXD32
   MMUX_CC_CHECK_TYPE_COMPLEXD64
   MMUX_CC_CHECK_TYPE_COMPLEXD128

   AC_CACHE_SAVE])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_SLLONG
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "signed long long int".
#     Results:
#
#     MMUX_CC_TYPES_HAS_SLLONG
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_SLLONG
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_SLLONG],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_SLLONG],
     [Always defined, set to 1 if MMUX support for type 'signed long long int' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([sllong],
        [AC_TYPE_LONG_LONG_INT
         AS_IF([mmux_test_variable_is_yes([ac_cv_type_long_long_int])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_SLLONG],[1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([sllong],[signed long long int])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_ULLONG
#
# Description:
#
#     Check if  the underlying platform  supports the standard C  language type "unsigned  long long
#     int".  Results:
#
#     MMUX_CC_TYPES_HAS_ULLONG
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_ULLONG
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_ULLONG],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_ULLONG],
     [Always defined, set to 1 if MMUX support for type 'unsigned long long int' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([ullong],
        [AC_TYPE_UNSIGNED_LONG_LONG_INT
         AS_IF([test mmux_is_yes([ac_cv_type_unsigned_long_long_int])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_ULLONG],[1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([ullong],[unsigned long long int])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_LDOUBLE
#
# Description:
#
#     Check  if  the underlying  platform  supports  the standard  C  language  type "long  double".
#     Results:
#
#     MMUX_CC_TYPES_HAS_LDOUBLE
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_LDOUBLE
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_LDOUBLE],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_LDOUBLE],
     [Always defined, set to 1 if MMUX support for type 'long double' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([ldouble],
        [AC_TYPE_LONG_DOUBLE
         AS_IF([test mmux_is_yes([ac_cv_type_long_double])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_LDOUBLE], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([ldouble],[long double])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT32
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float32".  Results:
#
#     MMUX_CC_TYPES_HAS_FLOAT32
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_FLOAT32
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT32],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_FLOAT32],
     [Always defined, set to 1 if MMUX support for type '_Float32' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([float32],
        [AC_CHECK_TYPE([_Float32])
         AC_CHECK_FUNC([strtof32])
         AC_CHECK_FUNC([strfromf32])
         AC_CHECK_FUNC([fabsf32])
         AC_CHECK_FUNC([fmaxf32])
         AC_CHECK_FUNC([fminf32])
         AS_IF([mmux_test_variables_are_yes([ac_cv_type__Float32,
                                             ac_cv_func_strtof32,
                                             ac_cv_func_strfromf32,
                                             ac_cv_func_fabsf32,
                                             ac_cv_func_fmaxf32,
                                             ac_cv_func_fminf32])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_FLOAT32], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([float32],[_Float32])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT64
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float64".  Results:
#
#     MMUX_CC_TYPES_HAS_FLOAT64
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_FLOAT64
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT64],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_FLOAT64],
     [Always defined, set to 1 if MMUX support for type '_Float64' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([float64],
        [AC_CHECK_TYPE([_Float64])
         AC_CHECK_FUNC([strtof64])
         AC_CHECK_FUNC([strfromf64])
         AC_CHECK_FUNC([fabsf64])
         AC_CHECK_FUNC([fmaxf64])
         AC_CHECK_FUNC([fminf64])
         AS_IF([mmux_test_variables_are_yes([ac_cv_type__Float64,
                                             ac_cv_func_strtof64,
                                             ac_cv_func_strfromf64,
                                             ac_cv_func_fabsf64,
                                             ac_cv_func_fmaxf64,
                                             ac_cv_func_fminf64])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_FLOAT64], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([float64],[_Float64])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT128
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float128".  Results:
#
#     MMUX_CC_TYPES_HAS_FLOAT128
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_FLOAT128
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT128],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_FLOAT128],
     [Always defined, set to 1 if MMUX support for type '_Float128' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([float128],
        [AC_CHECK_TYPE([_Float128])
         AC_CHECK_FUNC([strtof128])
         AC_CHECK_FUNC([strfromf128])
         AC_CHECK_FUNC([fabsf128])
         AC_CHECK_FUNC([fmaxf128])
         AC_CHECK_FUNC([fminf128])
         AS_IF([mmux_test_variables_are_yes([ac_cv_type__Float128,
                                             ac_cv_func_strtof128,
                                             ac_cv_func_strfromf128,
                                             ac_cv_func_fabsf128,
                                             ac_cv_func_fmaxf128,
                                             ac_cv_func_fminf128])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_FLOAT128], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([float128],[_Float128])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT32X
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float32x".  Results:
#
#     MMUX_CC_TYPES_HAS_FLOAT32X
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_FLOAT32X
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT32X],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_FLOAT32X],
     [Always defined, set to 1 if MMUX support for type '_Float32x' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([float32x],
        [AC_CHECK_TYPE([_Float32x])
         AC_CHECK_FUNC([strtof32x])
         AC_CHECK_FUNC([strfromf32x])
         AC_CHECK_FUNC([fabsf32x])
         AC_CHECK_FUNC([fmaxf32x])
         AC_CHECK_FUNC([fminf32x])
         AS_IF([mmux_test_variables_are_yes([ac_cv_type__Float32x,
                                             ac_cv_func_strtof32x,
                                             ac_cv_func_strfromf32x,
                                             ac_cv_func_fabsf32x,
                                             ac_cv_func_fmaxf32x,
                                             ac_cv_func_fminf32x])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_FLOAT32X], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([float32x],[_Float32x])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT64X
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float64x".  Results:
#
#     MMUX_CC_TYPES_HAS_FLOAT64X
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_FLOAT64X
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT64X],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_FLOAT64X],
     [Always defined, set to 1 if MMUX support for type '_Float64x' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([float64x],
        [AC_CHECK_TYPE([_Float64x])
         AC_CHECK_FUNC([strtof64x])
         AC_CHECK_FUNC([strfromf64x])
         AC_CHECK_FUNC([fabsf64x])
         AC_CHECK_FUNC([fmaxf64x])
         AC_CHECK_FUNC([fminf64x])
         AS_IF([mmux_test_variables_are_yes([ac_cv_type__Float64x,
                                             ac_cv_func_strtof64x,
                                             ac_cv_func_strfromf64x,
                                             ac_cv_func_fabsf64x,
                                             ac_cv_func_fmaxf64x,
                                             ac_cv_func_fminf64x])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_FLOAT64X], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([float64x],[_Float64x])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT128X
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float128x".  Results:
#
#     MMUX_CC_TYPES_HAS_FLOAT128X
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_FLOAT128X
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT128X],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_FLOAT128X],
     [Always defined, set to 1 if MMUX support for type '_Float128x' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([float128x],
        [AC_CHECK_TYPE([_Float128x])
         AC_CHECK_FUNC([strtof128x])
         AC_CHECK_FUNC([strfromf128x])
         AC_CHECK_FUNC([fabsf128x])
         AC_CHECK_FUNC([fmaxf128x])
         AC_CHECK_FUNC([fminf128x])
         AS_IF([mmux_test_variables_are_yes([ac_cv_type__Float128x,
                                             ac_cv_func_strtof128x,
                                             ac_cv_func_strfromf128x,
                                             ac_cv_func_fabsf128x,
                                             ac_cv_func_fmaxf128x,
                                             ac_cv_func_fminf128x])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_FLOAT128X], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([float128x],[_Float128x])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_FACILITIES
#
# Description:
#
#     Check the availability of a Decimal  Floating-Point C Library implementing the usual functions
#     for the _DecimalN  floating-point number types: _Decimal32,  _Decimal64, _Decimal128.
#
#     Support for these types could one future day  be available in the Standard C Library, like the
#     GNU C Library.  This macro assumes that the  external package "libdfp" is needed, but it tries
#     to shield the rest of the package from this knowledge.
#
#     Results:
#
#     MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES
#               C language preprocessor symbol; always defined; by default set to 0; set to 1 if the
#               facilities are available.
#
#     MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES
#               GNU Autoconf substitution symbol; by default defined to expand to 0; expands to 1 if
#               the facilities are available.
#
#     WANT_LIBDFP
#               GNU Automake conditional symbol; enabled when the facilities are available.
#
#     MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_LIBS
#               GNU  Autoconf shell  variable; by  default  set to  empty; when  the facilities  are
#               available: set to the linker flags needed to include the library.
#
#     MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_CFLAGS
#               GNU  Autoconf shell  variable; by  default  set to  empty; when  the facilities  are
#               available: set to the compiler flags needed to include the library.
#
AC_DEFUN([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_FACILITIES],
  [AS_VAR_SET([MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_LIBS])
   AS_VAR_SET([MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_CFLAGS])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES],
     [Always defined, set to 1 if MMUX support for '_DecimalN' floating-point numbers is available.],
     [MMUX_AUTOCONF_ENABLE_OPTION([CC_DECIMAL_FLOATING_POINT_FACILITIES], [cc-decimal-floating-point], [yes],
        [whether to enable MMUX support for the C language decimal floating-point library],
        [enables MMUX support for the C language decimal floating-point library])
      AS_IF([mmux_test_variable_is_yes([mmux_enable_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
        [PKG_CHECK_MODULES([LIBDFP],[libdfp],,[AC_MSG_WARN([package libdfp not found])])
         AS_IF([mmux_test_variable_is_not_empty([pkg_cv_LIBDFP_LIBS])],
               [AS_VAR_SET([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES],[1])],
               [])])
      AC_MSG_CHECKING([for MMUX supporting decimal floating-point library])
      AS_IF([mmux_test_variable_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
            [AS_VAR_SET([MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_LIBS],   [$LIBDFP_LIBS])
             AS_VAR_SET([MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_CFLAGS], [$LIBDFP_CFLAGS])
             AC_MSG_RESULT([yes])],
            [AC_MSG_RESULT([no])])])
   AM_CONDITIONAL([WANT_LIBDFP],[mmux_test_variable_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_DECIMAL32
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Decimal32".  Results:
#
#     MMUX_CC_TYPES_HAS_DECIMAL32
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_DECIMAL32
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_DECIMAL32],
  [AC_REQUIRE([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_FACILITIES])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_DECIMAL32],
     [Always defined, set to 1 if MMUX support for type '_Decimal32' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([decimal32],
        [AS_IF([test mmux_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
               [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([CFLAGS],[" $MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_CFLAGS"],
                  [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([LIBS],[" $MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_LIBS"],
                     [AC_CHECK_TYPE([_Decimal32])
                      AC_CHECK_FUNC([strtod32])
                      AC_CHECK_FUNC([strfromd32])
                      AC_CHECK_FUNC([fabsd32])
                      AC_CHECK_FUNC([fmaxd32])
                      AC_CHECK_FUNC([fmind32])])])
                AS_IF([mmux_test_variables_are_yes([ac_cv_type__Decimal32,
                                                    ac_cv_func_strtod32,
                                                    ac_cv_func_strfromd32,
                                                    ac_cv_func_fabsd32,
                                                    ac_cv_func_fmaxd32,
                                                    ac_cv_func_fmind32])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_DECIMAL32], [1])])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([decimal32],[_Decimal32])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_DECIMAL64
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Decimal64".  Results:
#
#     MMUX_CC_TYPES_HAS_DECIMAL64
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_DECIMAL64
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_DECIMAL64],
  [AC_REQUIRE([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_FACILITIES])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_DECIMAL64],
     [Always defined, set to 1 if MMUX support for type '_Decimal64' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([decimal64],
        [AS_IF([test mmux_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
               [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([CFLAGS],[" $MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_CFLAGS"],
                  [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([LIBS],[" $MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_LIBS"],
                     [AC_CHECK_TYPE([_Decimal64])
                      AC_CHECK_FUNC([strtod64])
                      AC_CHECK_FUNC([strfromd64])
                      AC_CHECK_FUNC([fabsd64])
                      AC_CHECK_FUNC([fmaxd64])
                      AC_CHECK_FUNC([fmind64])])])
                AS_IF([mmux_test_variables_are_yes([ac_cv_type__Decimal64,
                                                    ac_cv_func_strtod64,
                                                    ac_cv_func_strfromd64,
                                                    ac_cv_func_fabsd64,
                                                    ac_cv_func_fmaxd64,
                                                    ac_cv_func_fmind64])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_DECIMAL64], [1])])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([decimal64],[_Decimal64])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_DECIMAL128
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Decimal128".  Results:
#
#     MMUX_CC_TYPES_HAS_DECIMAL128
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_DECIMAL128
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_DECIMAL128],
  [AC_REQUIRE([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_FACILITIES])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_DECIMAL128],
     [Always defined, set to 1 if MMUX support for type '_Decimal128' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([decimal128],
        [AS_IF([test mmux_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
               [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([CFLAGS],[" $MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_CFLAGS"],
                  [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([LIBS],[" $MMUX_CC_DECIMAL_FLOATING_POINT_FACILITIES_LIBS"],
                     [AC_CHECK_TYPE([_Decimal128])
                      AC_CHECK_FUNC([strtod128])
                      AC_CHECK_FUNC([strfromd128])
                      AC_CHECK_FUNC([fabsd128])
                      AC_CHECK_FUNC([fmaxd128])
                      AC_CHECK_FUNC([fmind128])])])
                AS_IF([mmux_test_variables_are_yes([ac_cv_type__Decimal128,
                                                    ac_cv_func_strtod128,
                                                    ac_cv_func_strfromd128,
                                                    ac_cv_func_fabsd128,
                                                    ac_cv_func_fmaxd128,
                                                    ac_cv_func_fmind128])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_DECIMAL128], [1])])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([decimal128],[_Decimal128])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF
#
# Description:
#
#     Check  if the  underlying platform  supports  the standard  C language  type "float  complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXF
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXF
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXF],
     [Always defined, set to 1 if MMUX support for type 'float complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexf],
        [AC_CHECK_HEADER([complex.h])
         AC_CHECK_TYPE([float complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
         AC_CHECK_DECL([CMPLXF],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
         AC_CHECK_FUNC([crealf])
         AC_CHECK_FUNC([cimagf])
         AC_CHECK_FUNC([cabsf])
         AC_CHECK_FUNC([cargf])
         AC_CHECK_FUNC([conjf])
         AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                             ac_cv_type_float_complex,
                                             ac_cv_have_decl_CMPLXF,
                                             ac_cv_func_crealf,
                                             ac_cv_func_cimagf,
                                             ac_cv_func_cabsf,
                                             ac_cv_func_cargf,
                                             ac_cv_func_conjf])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXF], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexf],[float complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXD
#
# Description:
#
#     Check if the underlying  platform supports the standard C language  type "double complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXD
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXD
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXD],
  [MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXD],
     [Always defined, set to 1 if MMUX support for type 'double complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexd],
        [AC_CHECK_HEADER([complex.h])
         AC_CHECK_TYPE([double complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
         AC_CHECK_DECL([CMPLX],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
         AC_CHECK_FUNC([creal])
         AC_CHECK_FUNC([cimag])
         AC_CHECK_FUNC([cabs])
         AC_CHECK_FUNC([carg])
         AC_CHECK_FUNC([conj])
         AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                             ac_cv_type_double_complex,
                                             ac_cv_have_decl_CMPLX,
                                             ac_cv_func_creal,
                                             ac_cv_func_cimag,
                                             ac_cv_func_cabs,
                                             ac_cv_func_carg,
                                             ac_cv_func_conj])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXD], [1])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexd],[double complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXLD
#
# Description:
#
#     Check if the underlying platform supports the  standard C language type "long double complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXLD
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXLD
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXLD],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_LDOUBLE])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXLD],
     [Always defined, set to 1 if MMUX support for type 'long double complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexld],
        [AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_LDOUBLE])],
               [AC_CHECK_HEADER([complex.h])
                AC_CHECK_TYPE([long double complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_DECL([CMPLXL],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_FUNC([creall])
                AC_CHECK_FUNC([cimagl])
                AC_CHECK_FUNC([cabsl])
                AC_CHECK_FUNC([cargl])
                AC_CHECK_FUNC([conjl])
                AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                                    ac_cv_type_long_double_complex,
                                                    ac_cv_have_decl_CMPLXL,
                                                    ac_cv_func_creall,
                                                    ac_cv_func_cimagl,
                                                    ac_cv_func_cabsl,
                                                    ac_cv_func_cargl,
                                                    ac_cv_func_conjl])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXLD], [1])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexld],[long double complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF32
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float32 complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXF32
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXF32
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF32],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT32])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXF32],
     [Always defined, set to 1 if MMUX support for type '_Float32 complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexf32],
        [AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_FLOAT32])],
               [AC_CHECK_HEADER([complex.h])
                AC_CHECK_TYPE([_Float32 complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_DECL([CMPLXF32],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_FUNC([crealf32])
                AC_CHECK_FUNC([cimagf32])
                AC_CHECK_FUNC([cabsf32])
                AC_CHECK_FUNC([cargf32])
                AC_CHECK_FUNC([conjf32])
                AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                                    ac_cv_type__Float32_complex,
                                                    ac_cv_have_decl_CMPLXF32,
                                                    ac_cv_func_crealf32,
                                                    ac_cv_func_cimagf32,
                                                    ac_cv_func_cabsf32,
                                                    ac_cv_func_cargf32,
                                                    ac_cv_func_conjf32])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXF32], [1])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexf32],[_Float32 complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF64
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float64 complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXF64
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXF64
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF64],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT64])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXF64],
     [Always defined, set to 1 if MMUX support for type '_Float64 complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexf64],
        [AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_FLOAT64])],
               [AC_CHECK_HEADER([complex.h])
                AC_CHECK_TYPE([_Float64 complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_DECL([CMPLXF64],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_FUNC([crealf64])
                AC_CHECK_FUNC([cimagf64])
                AC_CHECK_FUNC([cabsf64])
                AC_CHECK_FUNC([cargf64])
                AC_CHECK_FUNC([conjf64])
                AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                                    ac_cv_type__Float64_complex,
                                                    ac_cv_have_decl_CMPLXF64,
                                                    ac_cv_func_crealf64,
                                                    ac_cv_func_cimagf64,
                                                    ac_cv_func_cabsf64,
                                                    ac_cv_func_cargf64,
                                                    ac_cv_func_conjf64])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXF64], [1])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexf64],[_Float64 complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF128
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float128 complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXF128
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXF128
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF128],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT128])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXF128],
     [Always defined, set to 1 if MMUX support for type '_Float128 complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexf128],
        [AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_FLOAT128])],
               [AC_CHECK_HEADER([complex.h])
                AC_CHECK_TYPE([_Float128 complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_DECL([CMPLXF128],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_FUNC([crealf128])
                AC_CHECK_FUNC([cimagf128])
                AC_CHECK_FUNC([cabsf128])
                AC_CHECK_FUNC([cargf128])
                AC_CHECK_FUNC([conjf128])
                AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                                    ac_cv_type__Float128_complex,
                                                    ac_cv_have_decl_CMPLXF128,
                                                    ac_cv_func_crealf128,
                                                    ac_cv_func_cimagf128,
                                                    ac_cv_func_cabsf128,
                                                    ac_cv_func_cargf128,
                                                    ac_cv_func_conjf128])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXF128], [1])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexf128],[_Float128 complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF32X
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float32x complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXF32X
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXF32X
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF32X],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT32X])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXF32X],
     [Always defined, set to 1 if MMUX support for type '_Float32x complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexf32x],
        [AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_FLOAT32X])],
               [AC_CHECK_HEADER([complex.h])
                AC_CHECK_TYPE([_Float32x complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_DECL([CMPLXF32X],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_FUNC([crealf32x])
                AC_CHECK_FUNC([cimagf32x])
                AC_CHECK_FUNC([cabsf32x])
                AC_CHECK_FUNC([cargf32x])
                AC_CHECK_FUNC([conjf32x])
                AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                                    ac_cv_type__Float32x_complex,
                                                    ac_cv_have_decl_CMPLXF32X,
                                                    ac_cv_func_crealf32x,
                                                    ac_cv_func_cimagf32x,
                                                    ac_cv_func_cabsf32x,
                                                    ac_cv_func_cargf32x,
                                                    ac_cv_func_conjf32x])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXF32X], [1])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexf32x],[_Float32x complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF64X
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float64x complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXF64X
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXF64X
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF64X],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT64X])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXF64X],
     [Always defined, set to 1 if MMUX support for type '_Float64x complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexf64x],
        [AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_FLOAT64X])],
               [AC_CHECK_HEADER([complex.h])
                AC_CHECK_TYPE([_Float64x complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_DECL([CMPLXF64X],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_FUNC([crealf64x])
                AC_CHECK_FUNC([cimagf64x])
                AC_CHECK_FUNC([cabsf64x])
                AC_CHECK_FUNC([cargf64x])
                AC_CHECK_FUNC([conjf64x])
                AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                                    ac_cv_type__Float64x_complex,
                                                    ac_cv_have_decl_CMPLXF64X,
                                                    ac_cv_func_crealf64x,
                                                    ac_cv_func_cimagf64x,
                                                    ac_cv_func_cabsf64x,
                                                    ac_cv_func_cargf64x,
                                                    ac_cv_func_conjf64x])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXF64X], [1])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexf64x],[_Float64x complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF128X
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float128x complex".
#     Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXF128X
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXF128X
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF128X],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT128X])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXF128X],
     [Always defined, set to 1 if MMUX support for type '_Float128x complex' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexf128x],
        [AS_IF([mmux_test_variable_is_one([MMUX_CC_TYPES_HAS_FLOAT128X])],
               [AC_CHECK_HEADER([complex.h])
                AC_CHECK_TYPE([_Float128x complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_DECL([CMPLXF128X],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
                AC_CHECK_FUNC([crealf128x])
                AC_CHECK_FUNC([cimagf128x])
                AC_CHECK_FUNC([cabsf128x])
                AC_CHECK_FUNC([cargf128x])
                AC_CHECK_FUNC([conjf128x])
                AS_IF([mmux_test_variables_are_yes([ac_cv_header_complex_h,
                                                    ac_cv_type__Float128x_complex,
                                                    ac_cv_have_decl_CMPLXF128X,
                                                    ac_cv_func_crealf128x,
                                                    ac_cv_func_cimagf128x,
                                                    ac_cv_func_cabsf128x,
                                                    ac_cv_func_cargf128x,
                                                    ac_cv_func_conjf128x])],
                      [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXF128X], [1])])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexf128x],[_Float128x complex])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXD32
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "complexd32".  Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXD32"
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXD32"
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXD32],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_DECIMAL32])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXD32],
     [Always defined, set to 1 if MMUX support for type 'complexd32' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexd32],
        [AS_IF([mmux_test_variable_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXD32], [$MMUX_CC_TYPES_HAS_DECIMAL32])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexd32],[complexd32])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXD64
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "complexd64".  Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXD64"
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXD64"
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXD64],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_DECIMAL64])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXD64],
     [Always defined, set to 1 if MMUX support for type 'complexd64' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexd64],
        [AS_IF([mmux_test_variable_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXD64], [$MMUX_CC_TYPES_HAS_DECIMAL64])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexd64],[complexd64])])])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXD128
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "complexd128".  Results:
#
#     MMUX_CC_TYPES_HAS_COMPLEXD128"
#               C  language preprocessor  symbol defined  and set  to 1  if the  type is  supported;
#               otherwise it is set to 0.
#
#     MMUX_CC_TYPES_HAS_COMPLEXD128"
#               GNU Autoconf  substitution symbol  defined and set  to 1 if  the type  is supported;
#               otherwise it is set to 0.
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXD128],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_DECIMAL128])
   MMUX_DEFINE_OMNIBUS_CONFIG_VARIABLE([MMUX_CC_TYPES_HAS_COMPLEXD128],
     [Always defined, set to 1 if MMUX support for type 'complexd128' is enabled.],
     [MMUX_AUTOCONF_DEFINE_CC_TYPE_ENABLE_OPTION_WITH_BODY([complexd128],
        [AS_IF([mmux_test_variable_is_one([MMUX_HAVE_CC_DECIMAL_FLOATING_POINT_FACILITIES])],
               [AS_VAR_SET([MMUX_CC_TYPES_HAS_COMPLEXD128], [$MMUX_CC_TYPES_HAS_DECIMAL128])])
         MMUX_CC_TYPE_SUPPORT_MSG_CHECKING([complexd128],[complexd128])])])])


#### let's go

### end of file
# Local Variables:
# mode: autoconf
# fill-column: 100
# End:
