/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jan 12, 2026

  Abstract

	Test file for functions.

  Copyright (C) 2026 Marco Maggi <mrc.mgg@gmail.com>

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
print_string (void)
{
  printf_message("running test: %s", __func__);

  mmux_asciizcp_t		str_asciiz = "/path/to/file.ext";
  mmux_usize_t			str_len;
  mmux_libc_str_t		str;
  mmux_libc_str_factory_t	str_factory;
  mmux_libc_memfd_t		mfd;

  mmux_libc_strlen(&str_len, str_asciiz);

  mmux_libc_string_factory_static(str_factory);
  if (mmux_libc_make_string(str, str_factory, str_asciiz)) {
    handle_error();
  } else if (mmux_libc_make_memfd(mfd)) {
    handle_error();
  } else if (mmux_libc_dprintf_str(mfd, str)) {
    handle_error();
  } else {
    mmux_usize_t	buflen;

    if (mmux_libc_memfd_length(&buflen, mfd)) {
      handle_error();
    } if (mmux_ctype_not_equal(str_len, buflen)) {
      printf_error("wrong dprinting length of custom string: expected %lu, got %lu",
		   str_len.value, buflen.value);
      mmux_libc_exit_failure();
    } else {
      char	bufptr[1+buflen.value];

      bufptr[buflen.value] = '\0';
      if (mmux_libc_memfd_read_buffer(mfd, bufptr, buflen)) {
	handle_error();
      } else {
	mmux_ternary_comparison_result_t	result;

	mmux_libc_strcmp(&result, bufptr, str_asciiz);
	if (mmux_ternary_comparison_result_is_equal(result)) {
	  printf_message("successfully printed string to memfd: '%s'", bufptr);
	} else {
	  printf_error("wrong dprinting of custom string: '%s'", bufptr);
	  mmux_libc_exit_failure();
	}
      }
    }
  }

  printf_message("DONE: %s\n", __func__);
}
static void
test_string_length (void)
/* Determine the length of a custom string. */
{
  //                                  012345678901234567
  mmux_asciizcp_t	str_asciiz = "/path/to/file.ext";
  mmux_libc_str_t	str;
  mmux_usize_t		len_no_nul;

  {
    mmux_libc_str_factory_t	str_factory;

    mmux_libc_string_factory_static(str_factory);
    if (mmux_libc_make_string(str, str_factory, str_asciiz)) {
      handle_error();
    }
  }
  if (mmux_libc_string_len_ref(&len_no_nul, str)) {
    handle_error();
  } else if (17 != len_no_nul.value) {
    handle_error();
  } else {
    printf_message("the string length is: %lu", len_no_nul.value);
  }

  mmux_libc_unmake_string(str);

  printf_message("DONE: %s\n", __func__);
}


/** --------------------------------------------------------------------
 ** Memory tests.
 ** ----------------------------------------------------------------- */

static void
test_string_factory_swallow (void)
/* Allocate an ASCIIZ string  in dynamic memory then swallow it  into a file system
   string using the swallow factory. */
{
  printf_message("running test: %s", __func__);

  //                                  012345678901234567
  mmux_asciizcp_t	str_asciiz = "/path/to/file.ext";
  mmux_usize_t		buflen_with_nil;
  mmux_asciizp_t	bufptr;
  mmux_libc_str_t	str;

  if (mmux_libc_strlen_plus_nil(&buflen_with_nil, str_asciiz)) {
    handle_error();
  } else if (mmux_libc_malloc_and_copy(&bufptr, str_asciiz, buflen_with_nil)) {
    handle_error();
  } else {
    {
      mmux_libc_str_factory_t	str_factory;

      mmux_libc_string_factory_swallow(str_factory);
      if (mmux_libc_make_string(str, str_factory, bufptr)) {
	handle_error();
      }
    }

    {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_dprintfer("%s: resulting malloced string: '", __func__)) {
	handle_error();
      } else if (mmux_libc_dprintf_str(er, str)) {
	handle_error();
      } else if (mmux_libc_dprintfer("'\n")) {
	handle_error();
      }
    }
    if (mmux_libc_unmake_string(str)) {
      handle_error();
    }
  }
}
static void
test_string_factory_dynamic (void)
/* Build a custom string using the dynamic factory from an ASCIIZ string. */
{
  printf_message("running test: %s", __func__);

  mmux_asciizcp_t	str_asciiz = "/path/to/file.ext";
  mmux_libc_str_t	str;

  {
    mmux_libc_str_factory_copying_t	str_factory;

    mmux_libc_string_factory_dynamic(str_factory);
    if (mmux_libc_make_string(str, str_factory, str_asciiz)) {
      printf_error("error making custom string");
      handle_error();
    }
  }
  {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintfer("%s: resulting malloced string: '", __func__)) {
      handle_error();
    } else if (mmux_libc_dprintf_str(er, str)) {
      handle_error();
    } else if (mmux_libc_dprintfer("'\n")) {
      handle_error();
    }
  }
  if (mmux_libc_unmake_string(str)) {
    handle_error();
  }
}

static void
test_string_factory_dynamic2 (void)
/* Build a custom string using the  dynamic factory from an ASCII string and a
   lenth. */
{
  printf_message("running test: %s", __func__);

  //                                  012345678
  mmux_asciizcp_t	str_asciiz = "/path/to/file.ext";
  auto			str_len_no_nul = mmux_usize_literal(8);
  mmux_libc_str_t	str;

  {
    mmux_libc_str_factory_copying_t	str_factory;

    mmux_libc_string_factory_dynamic(str_factory);
    if (mmux_libc_make_string2(str, str_factory, str_asciiz, str_len_no_nul)) {
      printf_error("error making custom string");
      handle_error();
    }
  }

  {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintfer("%s: resulting malloced string: '", __func__)) {
      handle_error();
    } else if (mmux_libc_dprintf_str(er, str)) {
      handle_error();
    } else if (mmux_libc_dprintfer("'\n")) {
      handle_error();
    }
  }
  if (mmux_libc_unmake_string(str)) {
    handle_error();
  }

  printf_message("DONE: %s\n", __func__);
}


/** --------------------------------------------------------------------
 ** Comparison tests.
 ** ----------------------------------------------------------------- */

static void
test_compare_equal_strings (void)
/* Compare two equal strings. */
{
  mmux_asciizcp_t	str_asciiz = "/path/to/file.ext";
  mmux_libc_str_t	str1, str2;
  bool			cmpbool;

  {
    mmux_libc_str_factory_t	str_factory;

    mmux_libc_string_factory_static(str_factory);
    if (mmux_libc_make_string(str1, str_factory, str_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_string(str2, str_factory, str_asciiz)) {
      handle_error();
    }
  }

  if (false) {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintf_str(er, str1)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
    if (mmux_libc_dprintf_str(er, str2)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* mmux_libc_string_equal() */
  {
    if (mmux_libc_string_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("equal: equal strings compared as expected");
    } else {
      print_error("equal: equal strings not compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_not_equal() */
  {
    if (mmux_libc_string_not_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("not_equal: equal strings compared as expected");
    } else {
      print_error("not_equal: equal strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_less() */
  {
    if (mmux_libc_string_less(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("less: equal strings compared as expected");
    } else {
      print_error("less: equal strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_greater() */
  {
    if (mmux_libc_string_greater(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("greater: equal strings compared as expected");
    } else {
      print_error("greater: equal strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_less_equal() */
  {
    if (mmux_libc_string_less_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("less_equal: equal strings compared as expected");
    } else {
      print_error("less_equal: equal strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_greater_equal() */
  {
    if (mmux_libc_string_greater_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("greater_equal: equal strings compared as expected");
    } else {
      print_error("greater_equal: equal strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_unmake_string(str1);
  mmux_libc_unmake_string(str2);
}

/* ------------------------------------------------------------------ */

static void
test_compare_different_strings_less (void)
/* Compare two different strings: str1 < str2. */
{
  mmux_asciizcp_t	str_asciiz1 = "/path/to/file.ext";
  mmux_asciizcp_t	str_asciiz2 = "/path/to/other-file.ext";
  mmux_libc_str_t	str1, str2;
  bool			cmpbool;

  {
    mmux_libc_str_factory_t	str_factory;

    mmux_libc_string_factory_static(str_factory);
    if (mmux_libc_make_string(str1, str_factory, str_asciiz1)) {
      handle_error();
    }
    if (mmux_libc_make_string(str2, str_factory, str_asciiz2)) {
      handle_error();
    }
  }

  if (false) {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintf_str(er, str1)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
    if (mmux_libc_dprintf_str(er, str2)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* mmux_libc_string_equal() */
  {
    if (mmux_libc_string_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("equal: less strings compared as expected");
    } else {
      print_error("equal: less strings not compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_not_equal() */
  {
    if (mmux_libc_string_not_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("not_equal: less strings compared as expected");
    } else {
      print_error("not_equal: less strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_less() */
  {
    if (mmux_libc_string_less(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("less: less strings compared as expected");
    } else {
      print_error("less: less strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_greater() */
  {
    if (mmux_libc_string_greater(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("greater: less strings compared as expected");
    } else {
      print_error("greater: less strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_less_equal() */
  {
    if (mmux_libc_string_less_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("less_equal: less strings compared as expected");
    } else {
      print_error("less_equal: less strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_greater_equal() */
  {
    if (mmux_libc_string_greater_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("greater_equal: less strings compared as expected");
    } else {
      print_error("greater_equal: less strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_unmake_string(str1);
  mmux_libc_unmake_string(str2);
}

/* ------------------------------------------------------------------ */

static void
test_compare_different_strings_greater (void)
/* Compare two different strings: str1 > str2. */
{
  mmux_asciizcp_t	str_asciiz1 = "/path/to/other-file.ext";
  mmux_asciizcp_t	str_asciiz2 = "/path/to/file.ext";
  mmux_libc_str_t	str1, str2;
  bool			cmpbool;

  {
    mmux_libc_str_factory_t	str_factory;

    mmux_libc_string_factory_static(str_factory);
    if (mmux_libc_make_string(str1, str_factory, str_asciiz1)) {
      handle_error();
    }
    if (mmux_libc_make_string(str2, str_factory, str_asciiz2)) {
      handle_error();
    }
  }

  if (false) {
    mmux_libc_oufd_t	er;

    mmux_libc_stder(er);
    if (mmux_libc_dprintf_str(er, str1)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
    if (mmux_libc_dprintf_str(er, str2)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* mmux_libc_string_equal() */
  {
    if (mmux_libc_string_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("equal: greater strings compared as expected");
    } else {
      print_error("equal: greater strings not compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_not_equal() */
  {
    if (mmux_libc_string_not_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("not_equal: greater strings compared as expected");
    } else {
      print_error("not_equal: greater strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_less() */
  {
    if (mmux_libc_string_less(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("less: greater strings compared as expected");
    } else {
      print_error("less: greater strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_greater() */
  {
    if (mmux_libc_string_greater(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("greater: greater strings compared as expected");
    } else {
      print_error("greater: greater strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_less_equal() */
  {
    if (mmux_libc_string_less_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (! cmpbool) {
      printf_message("less_equal: greater strings compared as expected");
    } else {
      print_error("less_equal: greater strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  /* mmux_libc_string_greater_equal() */
  {
    if (mmux_libc_string_greater_equal(&cmpbool, str1, str2)) {
      handle_error();
    }
    if (cmpbool) {
      printf_message("greater_equal: greater strings compared as expected");
    } else {
      print_error("greater_equal: greater strings NOT compared as expected");
      mmux_libc_exit_failure();
    }
  }

  mmux_libc_unmake_string(str1);
  mmux_libc_unmake_string(str2);

  printf_message("DONE: %s\n", __func__);
}


/** --------------------------------------------------------------------
 ** Concatenation.
 ** ----------------------------------------------------------------- */

static void
one_concatenation_case (mmux_asciizcp_t prefix_str_asciiz, mmux_asciizcp_t suffix_str_asciiz,
			mmux_asciizcp_t expected_result_str_asciiz)
{
  mmux_libc_str_t	prefix_str, suffix_str, result_str;

  printf_message("testing concatenation '%s' + '%s' = '%s'",
		 prefix_str_asciiz, suffix_str_asciiz, expected_result_str_asciiz);

  /* Build custom strings. */
  {
    mmux_libc_str_factory_copying_t	str_factory;

    mmux_libc_string_factory_dynamic(str_factory);
    if (mmux_libc_make_string(prefix_str, str_factory, prefix_str_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_string(suffix_str, str_factory, suffix_str_asciiz)) {
      handle_error();
    }
    if (mmux_libc_make_string_concat(result_str, str_factory, prefix_str, suffix_str)) {
      printf_error("concatenating strings");
      handle_error();
    }
  }

  {
    mmux_asciizcp_t	result_str_asciiz;

    printf_message("comparing strings result='%s' expected='%s'", result_str->value, expected_result_str_asciiz);

    if (mmux_libc_string_ptr_ref(&result_str_asciiz, result_str)) {
      handle_error();
    } else {
      mmux_ternary_comparison_result_t	cmpnum;

      if (mmux_libc_strcmp(&cmpnum, expected_result_str_asciiz, result_str_asciiz)) {
	handle_error();
      } else if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	printf_message("the concatenation of '%s' and '%s' is '%s'",
		       prefix_str_asciiz, suffix_str_asciiz, result_str_asciiz);
      } else {
	printf_error("invalid concatenation of '%s' and '%s' is '%s'",
		     prefix_str_asciiz, suffix_str_asciiz, result_str_asciiz);
	mmux_libc_exit_failure();
      }
    }
  }

  /* Final clenaup. */
  {
    if (mmux_libc_unmake_string(prefix_str)) {
      handle_error();
    }
    if (mmux_libc_unmake_string(suffix_str)) {
      handle_error();
    }
    if (mmux_libc_unmake_string(result_str)) {
      handle_error();
    }
  }
}
static void
string_concatenation (void)
{
  printf_message("running test: %s", __func__);

  one_concatenation_case("Alpha",	"Beta",		"AlphaBeta");
  one_concatenation_case("Alpha",	"",		"Alpha");
  one_concatenation_case("",		"Beta",		"Beta");
  one_concatenation_case("A",		"B",		"AB");

  printf_message("DONE: %s\n", __func__);
}


/** --------------------------------------------------------------------
 ** Strings from memfds.
 ** ----------------------------------------------------------------- */

static void
string_from_memfd (void)
{
  printf_message("running test: %s", __func__);

  {
    mmux_libc_str_t  str;

    /* Build the object. */
    {
      mmux_libc_memfd_t  mfd;

      if (mmux_libc_make_memfd(mfd)) {
	handle_error();
      }

      {
	if (mmux_libc_dprintf(mfd, "%s", "The colour of water and quicksilver.")) {
	  handle_error();
	}

	/* Actually build the string. */
	{
	  mmux_libc_str_factory_copying_t  str_factory;

	  mmux_libc_string_factory_dynamic(str_factory);
	  if (mmux_libc_make_string_from_memfd(str, str_factory, mfd)) {
	    handle_error();
	  }
	}
      }

      if (mmux_libc_close(mfd)) {
	handle_error();
      }
    }

    if (true) {
      mmux_libc_oufd_t	er;

      mmux_libc_stder(er);
      mmux_libc_dprintfer_no_error("%s: the built string is: '", __func__);
      if (mmux_libc_dprintf_str(er, str)) {
	handle_error();
      }
      mmux_libc_dprintfer_no_error("'\n");
    }

    /* Compare the built string with the expected string. */
    {
      bool	cmpbool;

      if (mmux_libc_strequ(&cmpbool, str->value, "The colour of water and quicksilver.")) {
	handle_error();
      }
      if (cmpbool) {
	printf_message("equal: strings compared as expected");
      } else {
	print_error("equal: strings not compared as expected");
	mmux_libc_exit_failure();
      }
    }

    /* Final cleanup. */
    {
      mmux_libc_unmake_string(str);
    }
  }

  printf_message("DONE: %s\n", __func__);
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
    PROGNAME = "test-strings-custom";
  }

  if (1) {	print_string();					}
  if (1) {	test_string_length();				}

  if (1) {	test_string_factory_swallow();			}
  if (1) {	test_string_factory_dynamic();			}
  if (1) {	test_string_factory_dynamic2();			}

  if (1) {	test_compare_equal_strings();			}
  if (1) {	test_compare_different_strings_less();		}
  if (1) {	test_compare_different_strings_greater();	}

  if (1) {	string_concatenation();				}

  if (1) {	string_from_memfd();				}

  mmux_libc_exit_success();
}

/* end of file */
