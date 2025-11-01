/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 14, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Some tests.
 ** ----------------------------------------------------------------- */

static void
print_file_system_pathname (void)
{
  printf_message("running test: %s", __func__);

  mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
  mmux_usize_t			ptn_len;
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_factory_t	fs_ptn_factory;
  mmux_libc_memfd_t		mfd;

  mmux_libc_strlen(&ptn_len, ptn_asciiz);

  mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
  if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
    handle_error();
  } else if (mmux_libc_make_memfd(mfd)) {
    handle_error();
  } else if (mmux_libc_dprintf_fs_ptn(mfd, fs_ptn)) {
    handle_error();
  } else {
    mmux_usize_t	buflen;

    if (mmux_libc_memfd_length(&buflen, mfd)) {
      handle_error();
    } if (mmux_ctype_not_equal(ptn_len, buflen)) {
      printf_error("wrong dprinting length of file system pathname: expected %lu, got %lu",
		   ptn_len.value, buflen.value);
      mmux_libc_exit_failure();
    } else {
      char	bufptr[1+buflen.value];

      bufptr[buflen.value] = '\0';
      if (mmux_libc_memfd_read_buffer(mfd, bufptr, buflen)) {
	handle_error();
      } else {
	mmux_ternary_comparison_result_t	result;

	mmux_libc_strcmp(&result, bufptr, ptn_asciiz);
	if (mmux_ternary_comparison_result_is_equal(result)) {
	  printf_message("successfully printed pathname to memfd: '%s'", bufptr);
	} else {
	  printf_error("wrong dprinting of file system pathname: '%s'", bufptr);
	  mmux_libc_exit_failure();
	}
      }
    }
  }
}
static void
test_file_system_pathname_length (void)
/* Determine the length of a file system pathname. */
{
  //                                  012345678901234567
  mmux_asciizcp_t	ptn_asciiz = "/path/to/file.ext";
  mmux_libc_fs_ptn_t	fs_ptn;
  mmux_usize_t		len_no_nul;

  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }
  if (mmux_libc_file_system_pathname_len_ref(&len_no_nul, fs_ptn)) {
    handle_error();
  } else if (17 != len_no_nul.value) {
    handle_error();
  } else {
    printf_message("the pathname length is: %lu", len_no_nul.value);
  }

  mmux_libc_unmake_file_system_pathname(fs_ptn);
}


/** --------------------------------------------------------------------
 ** Memory tests.
 ** ----------------------------------------------------------------- */

static void
test_file_system_pathname_factory_swallow (void)
/* Allocate an ASCIIZ pathname  in dynamic memory then swallow it  into a file system
   pathname using the swallow factory. */
{
  printf_message("running test: %s", __func__);

  //                                  012345678901234567
  mmux_asciizcp_t	ptn_asciiz = "/path/to/file.ext";
  mmux_usize_t		buflen_with_nil;
  mmux_asciizp_t	bufptr;
  mmux_libc_fs_ptn_t	fs_ptn;

  if (mmux_libc_strlen_plus_nil(&buflen_with_nil, ptn_asciiz)) {
    handle_error();
  } else if (mmux_libc_malloc(&bufptr, buflen_with_nil)) {
    handle_error();
  } else {
    if (mmux_libc_strncpy(bufptr, ptn_asciiz, buflen_with_nil)) {
      handle_error();
    }
    {
      mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

      mmux_libc_file_system_pathname_factory_swallow(fs_ptn_factory);
      if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, bufptr)) {
	handle_error();
      }
    }

    {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_dprintfer("%s: resulting malloced pathname: '", __func__)) {
	handle_error();
      } else if (mmux_libc_dprintf_fs_ptn(er, fs_ptn)) {
	handle_error();
      } else if (mmux_libc_dprintfer("'\n")) {
	handle_error();
      }
    }
    if (mmux_libc_unmake_file_system_pathname(fs_ptn)) {
      handle_error();
    }
  }
}
static void
test_file_system_pathname_factory_dynamic (void)
/* Build a file system pathname using the dynamic factory from an ASCIIZ string. */
{
  printf_message("running test: %s", __func__);

  mmux_asciizcp_t	ptn_asciiz = "/path/to/file.ext";
  mmux_libc_fs_ptn_t	fs_ptn;

  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      printf_error("error making file system pathname");
      handle_error();
    }
  }
  {
    mmux_libc_fd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintfer("%s: resulting malloced pathname: '", __func__)) {
      handle_error();
    } else if (mmux_libc_dprintf_fs_ptn(er, fs_ptn)) {
      handle_error();
    } else if (mmux_libc_dprintfer("'\n")) {
      handle_error();
    }
  }
  if (mmux_libc_unmake_file_system_pathname(fs_ptn)) {
    handle_error();
  }
}

static void
test_file_system_pathname_factory_dynamic2 (void)
/* Build a file system pathname using the  dynamic factory from an ASCII string and a
   lenth. */
{
  printf_message("running test: %s", __func__);

  //                                  012345678
  mmux_asciizcp_t	ptn_asciiz = "/path/to/file.ext";
  auto			ptn_len_no_nul = mmux_usize_literal(8);
  mmux_libc_fs_ptn_t	fs_ptn;

  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname2(fs_ptn, fs_ptn_factory, ptn_asciiz, ptn_len_no_nul)) {
      printf_error("error making file system pathname");
      handle_error();
    }
  }

  {
    mmux_libc_fd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintfer("%s: resulting malloced pathname: '", __func__)) {
      handle_error();
    } else if (mmux_libc_dprintf_fs_ptn(er, fs_ptn)) {
      handle_error();
    } else if (mmux_libc_dprintfer("'\n")) {
      handle_error();
    }
  }
  if (mmux_libc_unmake_file_system_pathname(fs_ptn)) {
    handle_error();
  }
}


/** --------------------------------------------------------------------
 ** Comparison tests.
 ** ----------------------------------------------------------------- */

static void
test_compare_equal_pathnames (void)
/* Compare two equal pathnames. */
{
  mmux_asciizcp_t	ptn_asciiz = "/path/to/file.ext";
  mmux_libc_fs_ptn_t	ptn1, ptn2;
  bool			cmpbool;

  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn1, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(ptn2, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  if (false) {
    mmux_libc_fd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintf_fs_ptn(er, ptn1)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
    if (mmux_libc_dprintf_fs_ptn(er, ptn2)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* mmux_libc_file_system_pathname_equal() */
  {
    if (mmux_libc_file_system_pathname_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("equal: equal pathnames compared as expected");
    } else {
      print_error("equal: equal pathnames not compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_not_equal() */
  {
    if (mmux_libc_file_system_pathname_not_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("not_equal: equal pathnames compared as expected");
    } else {
      print_error("not_equal: equal pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_less() */
  {
    if (mmux_libc_file_system_pathname_less(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("less: equal pathnames compared as expected");
    } else {
      print_error("less: equal pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_greater() */
  {
    if (mmux_libc_file_system_pathname_greater(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("greater: equal pathnames compared as expected");
    } else {
      print_error("greater: equal pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_less_equal() */
  {
    if (mmux_libc_file_system_pathname_less_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("less_equal: equal pathnames compared as expected");
    } else {
      print_error("less_equal: equal pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_greater_equal() */
  {
    if (mmux_libc_file_system_pathname_greater_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("greater_equal: equal pathnames compared as expected");
    } else {
      print_error("greater_equal: equal pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_unmake_file_system_pathname(ptn1);
  mmux_libc_unmake_file_system_pathname(ptn2);
}

/* ------------------------------------------------------------------ */

static void
test_compare_different_pathnames_less (void)
/* Compare two different pathnames: ptn1 < ptn2. */
{
  mmux_asciizcp_t	ptn_asciiz1 = "/path/to/file.ext";
  mmux_asciizcp_t	ptn_asciiz2 = "/path/to/other-file.ext";
  mmux_libc_fs_ptn_t	ptn1, ptn2;
  bool			cmpbool;

  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn1, fs_ptn_factory, ptn_asciiz1)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(ptn2, fs_ptn_factory, ptn_asciiz2)) {
      handle_error();
    }
  }

  if (false) {
    mmux_libc_fd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintf_fs_ptn(er, ptn1)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
    if (mmux_libc_dprintf_fs_ptn(er, ptn2)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* mmux_libc_file_system_pathname_equal() */
  {
    if (mmux_libc_file_system_pathname_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("equal: less pathnames compared as expected");
    } else {
      print_error("equal: less pathnames not compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_not_equal() */
  {
    if (mmux_libc_file_system_pathname_not_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("not_equal: less pathnames compared as expected");
    } else {
      print_error("not_equal: less pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_less() */
  {
    if (mmux_libc_file_system_pathname_less(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("less: less pathnames compared as expected");
    } else {
      print_error("less: less pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_greater() */
  {
    if (mmux_libc_file_system_pathname_greater(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("greater: less pathnames compared as expected");
    } else {
      print_error("greater: less pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_less_equal() */
  {
    if (mmux_libc_file_system_pathname_less_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("less_equal: less pathnames compared as expected");
    } else {
      print_error("less_equal: less pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_greater_equal() */
  {
    if (mmux_libc_file_system_pathname_greater_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("greater_equal: less pathnames compared as expected");
    } else {
      print_error("greater_equal: less pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_unmake_file_system_pathname(ptn1);
  mmux_libc_unmake_file_system_pathname(ptn2);
}

/* ------------------------------------------------------------------ */

static void
test_compare_different_pathnames_greater (void)
/* Compare two different pathnames: ptn1 > ptn2. */
{
  mmux_asciizcp_t	ptn_asciiz1 = "/path/to/other-file.ext";
  mmux_asciizcp_t	ptn_asciiz2 = "/path/to/file.ext";
  mmux_libc_fs_ptn_t	ptn1, ptn2;
  bool			cmpbool;

  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn1, fs_ptn_factory, ptn_asciiz1)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(ptn2, fs_ptn_factory, ptn_asciiz2)) {
      handle_error();
    }
  }

  if (false) {
    mmux_libc_fd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintf_fs_ptn(er, ptn1)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
    if (mmux_libc_dprintf_fs_ptn(er, ptn2)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* mmux_libc_file_system_pathname_equal() */
  {
    if (mmux_libc_file_system_pathname_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("equal: greater pathnames compared as expected");
    } else {
      print_error("equal: greater pathnames not compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_not_equal() */
  {
    if (mmux_libc_file_system_pathname_not_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("not_equal: greater pathnames compared as expected");
    } else {
      print_error("not_equal: greater pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_less() */
  {
    if (mmux_libc_file_system_pathname_less(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("less: greater pathnames compared as expected");
    } else {
      print_error("less: greater pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_greater() */
  {
    if (mmux_libc_file_system_pathname_greater(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("greater: greater pathnames compared as expected");
    } else {
      print_error("greater: greater pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_less_equal() */
  {
    if (mmux_libc_file_system_pathname_less_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("less_equal: greater pathnames compared as expected");
    } else {
      print_error("less_equal: greater pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_file_system_pathname_greater_equal() */
  {
    if (mmux_libc_file_system_pathname_greater_equal(&cmpbool, ptn1, ptn2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("greater_equal: greater pathnames compared as expected");
    } else {
      print_error("greater_equal: greater pathnames NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_unmake_file_system_pathname(ptn1);
  mmux_libc_unmake_file_system_pathname(ptn2);
}


/** --------------------------------------------------------------------
 ** Predicate tests.
 ** ----------------------------------------------------------------- */

typedef struct test_pathname_predicate_t {
  bool			expected_result_is_absolute;
  bool			expected_result_is_relative;
  bool			expected_result_is_standalone_dot;
  bool			expected_result_is_standalone_double_dot;
  bool			expected_result_is_standalone_slash;
  bool			expected_result_is_special_directory;
  mmux_asciizcp_t	ptn_asciiz;
} test_pathname_predicate_t;

static void
one_predicate (test_pathname_predicate_t * P)
{
  mmux_libc_fs_ptn_t	fs_ptn;
  bool			result;

  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, P->ptn_asciiz)) {
      handle_error();
    }
  }

  if (mmux_libc_file_system_pathname_is_absolute(&result, fs_ptn)) {
    handle_error();
  } if (P->expected_result_is_absolute == result) {
    printf_message("pathname '%s' is absolute? %s", P->ptn_asciiz, BOOL_STRING(result));
  } else {
    printf_error("unexpected result, pathname '%s' is absolute? %s", P->ptn_asciiz, BOOL_STRING(result));
    mmux_libc_exit_failure();
  }

  if (mmux_libc_file_system_pathname_is_relative(&result, fs_ptn)) {
    handle_error();
  } if (P->expected_result_is_relative == result) {
    printf_message("pathname '%s' is relative? %s", P->ptn_asciiz, BOOL_STRING(result));
  } else {
    printf_error("unexpected result, pathname '%s' is relative? %s", P->ptn_asciiz, BOOL_STRING(result));
    mmux_libc_exit_failure();
  }

  if (mmux_libc_file_system_pathname_is_standalone_dot(&result, fs_ptn)) {
    handle_error();
  } if (P->expected_result_is_standalone_dot == result) {
    printf_message("pathname '%s' is standalone_dot? %s", P->ptn_asciiz, BOOL_STRING(result));
  } else {
    printf_error("unexpected result, pathname '%s' is standalone_dot? %s", P->ptn_asciiz, BOOL_STRING(result));
    mmux_libc_exit_failure();
  }

  if (mmux_libc_file_system_pathname_is_standalone_double_dot(&result, fs_ptn)) {
    handle_error();
  } if (P->expected_result_is_standalone_double_dot == result) {
    printf_message("pathname '%s' is standalone_double_dot? %s", P->ptn_asciiz, BOOL_STRING(result));
  } else {
    printf_error("unexpected result, pathname '%s' is standalone_double_dot? %s", P->ptn_asciiz, BOOL_STRING(result));
    mmux_libc_exit_failure();
  }

  if (mmux_libc_file_system_pathname_is_standalone_slash(&result, fs_ptn)) {
    handle_error();
  } if (P->expected_result_is_standalone_slash == result) {
    printf_message("pathname '%s' is standalone_slash? %s", P->ptn_asciiz, BOOL_STRING(result));
  } else {
    printf_error("unexpected result, pathname '%s' is standalone_slash? %s", P->ptn_asciiz, BOOL_STRING(result));
    mmux_libc_exit_failure();
  }

  if (mmux_libc_file_system_pathname_is_special_directory(&result, fs_ptn)) {
    handle_error();
  } if (P->expected_result_is_special_directory == result) {
    printf_message("pathname '%s' is special_directory? %s", P->ptn_asciiz, BOOL_STRING(result));
  } else {
    printf_error("unexpected result, pathname '%s' is special_directory? %s", P->ptn_asciiz, BOOL_STRING(result));
    mmux_libc_exit_failure();
  }

  mmux_libc_unmake_file_system_pathname(fs_ptn);
}
static void
file_system_pathname_predicates (void)
{
  printf_message("running test: %s", __func__);

  test_pathname_predicate_t	S[8] = {
    {
      .ptn_asciiz					= "/path/to/file.ext",
      .expected_result_is_absolute			= true,
      .expected_result_is_relative			= false,
      .expected_result_is_standalone_dot		= false,
      .expected_result_is_standalone_double_dot		= false,
      .expected_result_is_standalone_slash		= false,
      .expected_result_is_special_directory		= false,
    },
    {
      .ptn_asciiz					= "./path/to/file.ext",
      .expected_result_is_absolute			= false,
      .expected_result_is_relative			= true,
      .expected_result_is_standalone_dot		= false,
      .expected_result_is_standalone_double_dot		= false,
      .expected_result_is_standalone_slash		= false,
      .expected_result_is_special_directory		= false,
    },
    {
      .ptn_asciiz					= ".",
      .expected_result_is_absolute			= false,
      .expected_result_is_relative			= true,
      .expected_result_is_standalone_dot		= true,
      .expected_result_is_standalone_double_dot		= false,
      .expected_result_is_standalone_slash		= false,
      .expected_result_is_special_directory		= true,
    },
    {
      .ptn_asciiz					= "..",
      .expected_result_is_absolute			= false,
      .expected_result_is_relative			= true,
      .expected_result_is_standalone_dot		= false,
      .expected_result_is_standalone_double_dot		= true,
      .expected_result_is_standalone_slash		= false,
      .expected_result_is_special_directory		= true,
    },
    {
      .ptn_asciiz					= "/",
      .expected_result_is_absolute			= true,
      .expected_result_is_relative			= false,
      .expected_result_is_standalone_dot		= false,
      .expected_result_is_standalone_double_dot		= false,
      .expected_result_is_standalone_slash		= true,
      .expected_result_is_special_directory		= true,
    },
    {
      .ptn_asciiz					= ".dotfile",
      .expected_result_is_absolute			= false,
      .expected_result_is_relative			= true,
      .expected_result_is_standalone_dot		= false,
      .expected_result_is_standalone_double_dot		= false,
      .expected_result_is_standalone_slash		= false,
      .expected_result_is_special_directory		= false,
    },
    {
      .ptn_asciiz					= "/path/to/.",
      .expected_result_is_absolute			= true,
      .expected_result_is_relative			= false,
      .expected_result_is_standalone_dot		= true,
      .expected_result_is_standalone_double_dot		= false,
      .expected_result_is_standalone_slash		= false,
      .expected_result_is_special_directory		= true,
    },
    {
      .ptn_asciiz					= "/path/to/..",
      .expected_result_is_absolute			= true,
      .expected_result_is_relative			= false,
      .expected_result_is_standalone_dot		= false,
      .expected_result_is_standalone_double_dot		= true,
      .expected_result_is_standalone_slash		= false,
      .expected_result_is_special_directory		= true,
    },
  };

  for (int i=0; i<8; ++i) {
    one_predicate(&(S[i]));
  }
}


/** --------------------------------------------------------------------
 ** Rootname component.
 ** ----------------------------------------------------------------- */

static void
one_rootname_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_root_ptn_asciiz)
{
  mmux_libc_fs_ptn_t	ptn, root_ptn;

  /* Build file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
      printf_error("making file system pathname");
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_rootname(root_ptn, fs_ptn_factory, ptn)) {
      printf_error("making rootname file system pathname");
      handle_error();
    }
  }

  {
    mmux_asciizcp_t	root_ptn_asciiz;

    if (mmux_libc_file_system_pathname_ptr_ref(&root_ptn_asciiz, root_ptn)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	result;

      if (mmux_libc_strcmp(&result, expected_root_ptn_asciiz, root_ptn_asciiz)) {
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(result)) {
	printf_message("the rootname of '%s' is '%s'", ptn_asciiz, root_ptn_asciiz);
	mmux_libc_unmake_file_system_pathname(root_ptn);
      } else {
	printf_error("invalid rootname of '%s' got '%s'", ptn_asciiz, root_ptn_asciiz);
	mmux_libc_exit_failure();
      }
    }
  }

  /* Final clenaup. */
  {
    if (mmux_libc_unmake_file_system_pathname(ptn)) {
      handle_error();
    }
    if (mmux_libc_unmake_file_system_pathname(root_ptn)) {
      handle_error();
    }
  }
}
static void
one_rootname_error_case (mmux_asciizcp_t ptn_asciiz)
{
  mmux_libc_fs_ptn_t		ptn, root_ptn;
  mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

  mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
  if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname_rootname(root_ptn, fs_ptn_factory, ptn)) {
    mmux_libc_errno_t	errnum;

    mmux_libc_errno_consume(&errnum);
    if (MMUX_LIBC_VALUEOF_EINVAL == errnum.value) {
      printf_message("correctly got EINVAL error extracting rootname of '%s'", ptn_asciiz);
    } else {
      printf_error("expected EINVAL error extracting rootname of '%s'", ptn_asciiz);
      mmux_libc_exit_failure();
    }
  } else {
    printf_error("expected error extracting rootname of '%s'", ptn_asciiz);
    mmux_libc_exit_failure();
  }
}
static void
file_system_pathname_rootname (void)
{
  printf_message("running test: %s", __func__);

  one_rootname_case("/path/to/file.ext",	"/path/to/file");
  one_rootname_case("/path/to/.dotfile.ext",	"/path/to/.dotfile");
  one_rootname_case("/path/to/directory/",	"/path/to/directory");

  one_rootname_case("path/to/file.ext",		"path/to/file");
  one_rootname_case("path/to/.dotfile.ext",	"path/to/.dotfile");

  one_rootname_case("file.ext",			"file");
  one_rootname_case(".dotfile.ext",		".dotfile");

  one_rootname_case("file",			"file");
  one_rootname_case(".dotfile",			".dotfile");

  one_rootname_case("file.",			"file");
  one_rootname_case(".dotfile.",		".dotfile");

  one_rootname_error_case("/");
  one_rootname_error_case(".");
  one_rootname_error_case("..");
  one_rootname_error_case("/path/to/.");
  one_rootname_error_case("/path/to/..");
}


/** --------------------------------------------------------------------
 ** Tailname component.
 ** ----------------------------------------------------------------- */

static void
one_tailname_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_tail_ptn_asciiz)
{
  mmux_libc_fs_ptn_t	ptn, tail_ptn;

  /* Build file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
      printf_error("making file system pathname");
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_tailname(tail_ptn, fs_ptn_factory, ptn)) {
      printf_error("making tailname file system pathname");
      handle_error();
    }
  }

  {
    mmux_asciizcp_t	tail_ptn_asciiz;

    if (mmux_libc_file_system_pathname_ptr_ref(&tail_ptn_asciiz, tail_ptn)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	result;

      if (mmux_libc_strcmp(&result, expected_tail_ptn_asciiz, tail_ptn_asciiz)) {
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(result)) {
	printf_message("the tailname of '%s' is '%s'", ptn_asciiz, tail_ptn_asciiz);
	mmux_libc_unmake_file_system_pathname(tail_ptn);
      } else {
	printf_error("invalid tailname of '%s' got '%s'", ptn_asciiz, tail_ptn_asciiz);
	mmux_libc_exit_failure();
      }
    }
  }

  /* Final clenaup. */
  {
    if (mmux_libc_unmake_file_system_pathname(ptn)) {
      handle_error();
    }
    if (mmux_libc_unmake_file_system_pathname(tail_ptn)) {
      handle_error();
    }
  }
}
static void
file_system_pathname_tailname (void)
{
  printf_message("running test: %s", __func__);

  one_tailname_case("/path/to/file.ext",	"file.ext");
  one_tailname_case("/path/to/.dotfile.ext",	".dotfile.ext");
  one_tailname_case("/path/to/directory/",	"directory");

  one_tailname_case("path/to/file.ext",		"file.ext");
  one_tailname_case("path/to/.dotfile.ext",	".dotfile.ext");

  one_tailname_case("file.ext",			"file.ext");
  one_tailname_case(".dotfile.ext",		".dotfile.ext");

  one_tailname_case("file",			"file");
  one_tailname_case(".dotfile",			".dotfile");

  one_tailname_case("/",			"/");
  one_tailname_case(".",			".");
  one_tailname_case("..",			"..");
  one_tailname_case("/path/to/.",		".");
  one_tailname_case("/path/to/..",		"..");
}


/** --------------------------------------------------------------------
 ** Filename component.
 ** ----------------------------------------------------------------- */

static void
one_filename_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_file_ptn_asciiz)
{
  mmux_libc_fs_ptn_t	ptn, file_ptn;

  /* Build file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
      printf_error("making file system pathname");
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_filename(file_ptn, fs_ptn_factory, ptn)) {
      printf_error("making filename file system pathname");
      handle_error();
    }
  }

  {
    mmux_asciizcp_t	file_ptn_asciiz;

    if (mmux_libc_file_system_pathname_ptr_ref(&file_ptn_asciiz, file_ptn)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	result;

      if (mmux_libc_strcmp(&result, expected_file_ptn_asciiz, file_ptn_asciiz)) {
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(result)) {
	printf_message("the filename of '%s' is '%s'", ptn_asciiz, file_ptn_asciiz);
	mmux_libc_unmake_file_system_pathname(file_ptn);
      } else {
	printf_error("invalid filename of '%s' got '%s'", ptn_asciiz, file_ptn_asciiz);
	mmux_libc_exit_failure();
      }
    }
  }

  /* Final clenaup. */
  {
    if (mmux_libc_unmake_file_system_pathname(ptn)) {
      handle_error();
    }
    if (mmux_libc_unmake_file_system_pathname(file_ptn)) {
      handle_error();
    }
  }
}
static void
one_filename_error_case (mmux_asciizcp_t ptn_asciiz)
{
  mmux_libc_fs_ptn_t		ptn, file_ptn;
  mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

  mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
  if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
    printf_error("making file system pathname");
    handle_error();
  }
  if (mmux_libc_make_file_system_pathname_filename(file_ptn, fs_ptn_factory, ptn)) {
    mmux_libc_errno_t	errnum;

    mmux_libc_errno_consume(&errnum);
    if (MMUX_LIBC_VALUEOF_EINVAL == errnum.value) {
      printf_message("correctly got EINVAL error extracting filename of '%s'", ptn_asciiz);
    } else {
      printf_error("expected EINVAL error extracting filename of '%s'", ptn_asciiz);
      mmux_libc_exit_failure();
    }
  } else {
    printf_error("expected error extracting filename of '%s'", ptn_asciiz);
    mmux_libc_exit_failure();
  }
}
static void
file_system_pathname_filename (void)
{
  printf_message("running test: %s", __func__);

  one_filename_case("/path/to/file.ext",	"file.ext");
  one_filename_case("/path/to/.dotfile.ext",	".dotfile.ext");

  one_filename_case("path/to/file.ext",		"file.ext");
  one_filename_case("path/to/.dotfile.ext",	".dotfile.ext");

  one_filename_case("file.ext",			"file.ext");
  one_filename_case(".dotfile.ext",		".dotfile.ext");

  one_filename_case("file",			"file");
  one_filename_case(".dotfile",			".dotfile");

  one_filename_error_case("/path/to/directory/");
  one_filename_error_case("/");
  one_filename_error_case(".");
  one_filename_error_case("..");
  one_filename_error_case("/path/to/.");
  one_filename_error_case("/path/to/..");
}


/** --------------------------------------------------------------------
 ** Dirname component.
 ** ----------------------------------------------------------------- */

static void
one_dirname_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_dirname_ptn_asciiz)
{
  mmux_libc_fs_ptn_t	ptn, dirname_ptn;

  /* Build file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
      printf_error("making file system pathname");
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_dirname(dirname_ptn, fs_ptn_factory, ptn)) {
      printf_error("making dirname dir system pathname");
      handle_error();
    }
  }

  {
    mmux_asciizcp_t	dirname_ptn_asciiz;

    if (mmux_libc_file_system_pathname_ptr_ref(&dirname_ptn_asciiz, dirname_ptn)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	result;

      if (mmux_libc_strcmp(&result, expected_dirname_ptn_asciiz, dirname_ptn_asciiz)) {
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(result)) {
	printf_message("the dirname of '%s' is '%s'", ptn_asciiz, dirname_ptn_asciiz);
	mmux_libc_unmake_file_system_pathname(dirname_ptn);
      } else {
	printf_error("invalid dirname of '%s' got '%s'", ptn_asciiz, dirname_ptn_asciiz);
	mmux_libc_exit_failure();
      }
    }
  }

  /* Final clenaup. */
  {
    if (mmux_libc_unmake_file_system_pathname(ptn)) {
      handle_error();
    }
    if (mmux_libc_unmake_file_system_pathname(dirname_ptn)) {
      handle_error();
    }
  }
}
static void
file_system_pathname_dirname (void)
{
  printf_message("running test: %s", __func__);

  one_dirname_case("/path/to/file.ext",		"/path/to/");
  one_dirname_case("/path/to/.dotfile.ext",	"/path/to/");
  one_dirname_case("/path/to/directory/",	"/path/to/directory/");

  one_dirname_case("path/to/file.ext",		"path/to/");
  one_dirname_case("path/to/.dotfile.ext",	"path/to/");

  one_dirname_case("file.ext",			".");
  one_dirname_case(".dotfile.ext",		".");

  one_dirname_case("file",			".");
  one_dirname_case(".dotfile",			".");

  one_dirname_case("/",				"/");
  one_dirname_case(".",				".");
  one_dirname_case("..",			"..");
  one_dirname_case("/path/to/.",		"/path/to/");
  one_dirname_case("/path/to/..",		"/path/to/..");
}


/** --------------------------------------------------------------------
 ** Normalisation.
 ** ----------------------------------------------------------------- */

static void
one_normalisation_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_normal_ptn_asciiz)
{
  mmux_libc_fs_ptn_t	ptn, normal_ptn;

  /* Build file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
      printf_error("making file system pathname");
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_normalised(normal_ptn, fs_ptn_factory, ptn)) {
      printf_error("normalising pathname '%s'", ptn_asciiz);
      handle_error();
    }
  }

  {
    mmux_asciizcp_t	normal_ptn_asciiz;

    if (mmux_libc_file_system_pathname_ptr_ref(&normal_ptn_asciiz, normal_ptn)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	result;

      if (mmux_libc_strcmp(&result, expected_normal_ptn_asciiz, normal_ptn_asciiz)) {
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(result)) {
	printf_message("the normalisation of '%s' is '%s'", ptn_asciiz, normal_ptn_asciiz);
	mmux_libc_unmake_file_system_pathname(normal_ptn);
      } else {
	printf_error("invalid normalisation of '%s' got '%s'", ptn_asciiz, normal_ptn_asciiz);
	mmux_libc_exit_failure();
      }
    }
  }

  /* Final clenaup. */
  {
    if (mmux_libc_unmake_file_system_pathname(ptn)) {
      handle_error();
    }
    if (mmux_libc_unmake_file_system_pathname(normal_ptn)) {
      handle_error();
    }
  }
}
static void
one_normalisation_error_case (mmux_asciizcp_t ptn_asciiz)
{
  mmux_libc_fs_ptn_t		ptn, normal_ptn;
  mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

  mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
  if (mmux_libc_make_file_system_pathname(ptn, fs_ptn_factory, ptn_asciiz)) {
    printf_error("making file system pathname");
    handle_error();
  }
  if (mmux_libc_make_file_system_pathname_normalised(normal_ptn, fs_ptn_factory, ptn)) {
    mmux_libc_errno_t	errnum;

    mmux_libc_errno_consume(&errnum);
    if (MMUX_LIBC_VALUEOF_EINVAL == errnum.value) {
      printf_message("correctly got EINVAL error normalising pathname '%s'", ptn_asciiz);
    } else {
      printf_error("expected EINVAL error normalising pathname '%s'", ptn_asciiz);
      mmux_libc_exit_failure();
    }
  } else {
    printf_error("expected error normalising pathname of '%s'", ptn_asciiz);
    mmux_libc_exit_failure();
  }
}
static void
file_system_pathname_normalisation (void)
{
  printf_message("running test: %s", __func__);

  /* Absolute pathnames: already normalised pathnames. */
  one_normalisation_case("/",				"/");
  one_normalisation_case("/file.ext",			"/file.ext");
  one_normalisation_case("/path/to/file.ext",		"/path/to/file.ext");

  /* Relative pathnames: already normalised pathnames. */
  one_normalisation_case(".",				".");
  one_normalisation_case("file.ext",			"file.ext");
  one_normalisation_case("path/to/file.ext",		"path/to/file.ext");

  /* ------------------------------------------------------------------ */

  /* Absolute pathnames: useless slashes removal. */
  one_normalisation_case("/path///to////file.ext",	"/path/to/file.ext");
  one_normalisation_case("/path/to/dir///",		"/path/to/dir/");

  /* Relative pathnames: useless slashes removal. */
  one_normalisation_case("path///to////file.ext",	"path/to/file.ext");
  one_normalisation_case("path/to/dir///",		"path/to/dir/");

  /* ------------------------------------------------------------------ */

  /* Absolute pathnames: single-dot removal. */
  one_normalisation_case("/path/./to/././file.ext",	"/path/to/file.ext");
  one_normalisation_case("/path/to/dir/.",		"/path/to/dir/");
  one_normalisation_case("/.",				"/");
  one_normalisation_case("/./././.",			"/");

  /* Relative pathnames: single-dot removal. */
  one_normalisation_case("./",				".");
  one_normalisation_case("./.",				".");
  one_normalisation_case("./././.",			".");
  one_normalisation_case("path/",			"path/");
  one_normalisation_case("path/.",			"path/");
  one_normalisation_case("./path",			"./path");
  one_normalisation_case("./path/file.ext",		"path/file.ext");
  one_normalisation_case("./file.ext",			"./file.ext");
  one_normalisation_case("./path/to/file.ext",		"path/to/file.ext");
  one_normalisation_case("./path///to////file.ext",	"path/to/file.ext");
  one_normalisation_case("./path/to/dir///",		"path/to/dir/");
  one_normalisation_case("~/.fvwmrc",			"~/.fvwmrc");
  one_normalisation_case(".fvwmrc",			".fvwmrc");
  one_normalisation_case("/path/to/.fvwmrc",		"/path/to/.fvwmrc");

  /* ------------------------------------------------------------------ */

  /* Absolute pathnames: double-dot removal. */
  one_normalisation_case("/path/..",			"/");
  one_normalisation_case("/path/to/../..",		"/");
  one_normalisation_case("/path/to/../file.ext",	"/path/file.ext");
  one_normalisation_case("/path/to/../../this/file.ext","/this/file.ext");

  /* Relative pathnames: double-dot removal. */
  one_normalisation_case("..",				"..");
  one_normalisation_case("../",				"..");
  one_normalisation_case("../path",			"../path");
  one_normalisation_case("path/..",			".");
  one_normalisation_case("./path/..",			".");
  one_normalisation_case("path/to/../..",		".");
  one_normalisation_case("./path/to/../..",		".");
  one_normalisation_case("path/../file.ext",		"./file.ext");
  one_normalisation_case("./path/../file.ext",		"./file.ext");
  one_normalisation_case("path/to/../file.ext",		"path/file.ext");
  one_normalisation_case("./path/to/../file.ext",	"path/file.ext");
  one_normalisation_case("path/to/../../../file.ext",	"../file.ext");
  one_normalisation_case("./path/to/../../../file.ext",	"../file.ext");
  one_normalisation_case("path/../../../file.ext",	"../../file.ext");
  one_normalisation_case("./path/../../../file.ext",	"../../file.ext");

  /* ------------------------------------------------------------------ */

  /* Invalid pathnames. */
  one_normalisation_error_case("/..");
  one_normalisation_error_case("/path/to/../../..");
}


/** --------------------------------------------------------------------
 ** Concatenation.
 ** ----------------------------------------------------------------- */

static void
one_concatenation_case (mmux_asciizcp_t prefix_ptn_asciiz, mmux_asciizcp_t suffix_ptn_asciiz,
			mmux_asciizcp_t expected_result_ptn_asciiz)
{
  mmux_libc_fs_ptn_t	prefix_ptn, suffix_ptn, result_ptn;

  /* Build file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(prefix_ptn, fs_ptn_factory, prefix_ptn_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(suffix_ptn, fs_ptn_factory, suffix_ptn_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_concat(result_ptn, fs_ptn_factory, prefix_ptn, suffix_ptn)) {
      printf_error("concatenating pathnames");
      handle_error();
    }
  }

  {
    mmux_asciizcp_t	result_ptn_asciiz;

    if (mmux_libc_file_system_pathname_ptr_ref(&result_ptn_asciiz, result_ptn)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	cmpnum;

      if (mmux_libc_strcmp(&cmpnum, expected_result_ptn_asciiz, result_ptn_asciiz)) {
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	printf_message("the concatenation of '%s' and '%s' is '%s'",
		       prefix_ptn_asciiz, suffix_ptn_asciiz, result_ptn_asciiz);
      } else {
	printf_error("invalid concatenation of '%s' and '%s' is '%s'",
		     prefix_ptn_asciiz, suffix_ptn_asciiz, result_ptn_asciiz);
	mmux_libc_exit_failure();
      }
    }
  }

  /* Final clenaup. */
  {
    if (mmux_libc_unmake_file_system_pathname(prefix_ptn)) {
      handle_error();
    }
    if (mmux_libc_unmake_file_system_pathname(suffix_ptn)) {
      handle_error();
    }
    if (mmux_libc_unmake_file_system_pathname(result_ptn)) {
      handle_error();
    }
  }
}
static void
file_system_pathname_concatenation (void)
{
  printf_message("running test: %s", __func__);

  one_concatenation_case("/path/to",	"file.ext",	"/path/to/file.ext");
  one_concatenation_case("/path/to/",	"file.ext",	"/path/to/file.ext");
  one_concatenation_case("/path/to",	"/file.ext",	"/path/to/file.ext");

  one_concatenation_case("/path/to/.",	"./file.ext",	"/path/to/file.ext");
}


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME			= "test-file-system-pathname";
  }

  if (1) {	print_file_system_pathname();				}
  if (1) {	test_file_system_pathname_length();			}

  if (1) {	test_file_system_pathname_factory_swallow();		}
  if (1) {	test_file_system_pathname_factory_dynamic();		}
  if (1) {	test_file_system_pathname_factory_dynamic2();		}

  if (1) {	test_compare_equal_pathnames();				}
  if (1) {	test_compare_different_pathnames_less();		}
  if (1) {	test_compare_different_pathnames_greater();		}

  if (1) {	file_system_pathname_predicates();	}
  if (1) {	file_system_pathname_rootname();	}
  if (1) {	file_system_pathname_tailname();	}
  if (1) {	file_system_pathname_filename();	}
  if (1) {	file_system_pathname_dirname();		}

  if (1) {	file_system_pathname_normalisation();	}
  if (1) {	file_system_pathname_concatenation();	}

  mmux_libc_exit_success();
}

/* end of file */
