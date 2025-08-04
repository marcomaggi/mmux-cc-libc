/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 23, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc.h>
#include <test-common.h>


/** --------------------------------------------------------------------
 ** Constructors.
 ** ----------------------------------------------------------------- */

static void
making_an_extension_from_raw_arguments (void)
{
  printf_message("running test: %s", __func__);
  mmux_libc_ptn_t		ptn;
  mmux_asciizcp_t		ptn_asciiz;
  mmux_libc_ptn_extension_t	ext;
  mmux_libc_fd_t		er;

  //                                             012345678901234567
  //                                                          ^
  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, "/path/to/file.ext")) {
    handle_error();
  }

  if (mmux_libc_file_system_pathname_ptr_ref(&ptn_asciiz, ptn)) {
    handle_error();
  }

  if (mmux_libc_make_file_system_pathname_extension_raw(&ext, ptn_asciiz + 13, 4)) {
    handle_error();
  }

  mmux_libc_stder(&er);

  if (mmux_libc_dprintfer("*** the pathname is: ")) {
    handle_error();
  }
  if (mmux_libc_dprintf_libc_ptn(er, ptn)) {
    handle_error();
  }
  if (mmux_libc_dprintfer_newline()) { handle_error(); }

  if (mmux_libc_dprintfer("*** the pathname extension is: ")) {
    handle_error();
  }
  if (mmux_libc_dprintf_libc_ptn_extension(er, ext)) {
    handle_error();
  }
  if (mmux_libc_dprintfer_newline()) { handle_error(); }
}

/* ------------------------------------------------------------------ */

static void
making_an_extension_from_pathname (void)
{
  printf_message("running test: %s", __func__);
  mmux_libc_ptn_t		ptn;
  mmux_libc_ptn_extension_t	ext;
  mmux_libc_fd_t		er;

  //                                             012345678901234567
  //                                                          ^
  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, "/path/to/file.ext")) {
    handle_error();
  }

  if (mmux_libc_make_file_system_pathname_extension(&ext, ptn)) {
    handle_error();
  }

  mmux_libc_stder(&er);

  if (mmux_libc_dprintfer("*** the pathname is: ")) {
    handle_error();
  }
  if (mmux_libc_dprintf_libc_ptn(er, ptn)) {
    handle_error();
  }
  if (mmux_libc_dprintfer_newline()) { handle_error(); }

  if (mmux_libc_dprintfer("*** the pathname extension is: ")) {
    handle_error();
  }
  if (mmux_libc_dprintf_libc_ptn_extension(er, ext)) {
    handle_error();
  }
  if (mmux_libc_dprintfer_newline()) { handle_error(); }
}


/** --------------------------------------------------------------------
 ** Accessors.
 ** ----------------------------------------------------------------- */

static void
extension_accessors (void)
{
  printf_message("running test: %s", __func__);

  mmux_libc_ptn_t		ptn;
  mmux_asciizcp_t		ptn_asciiz;
  mmux_libc_ptn_extension_t	ext;
  mmux_asciizcp_t		ptr_field;
  mmux_usize_t			len_field;

  //                                             012345678901234567
  //                                                          ^
  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, "/path/to/file.ext")) {
    handle_error();
  }

  if (mmux_libc_file_system_pathname_ptr_ref(&ptn_asciiz, ptn)) {
    handle_error();
  }

  if (mmux_libc_make_file_system_pathname_extension_raw(&ext, ptn_asciiz + 13, 4)) {
    handle_error();
  }

  mmux_libc_file_system_pathname_extension_ptr_ref(&ptr_field, ext);
  mmux_libc_file_system_pathname_extension_len_ref(&len_field, ext);


  if ((ptn_asciiz + 13) != ptr_field) {
    printf_error("wrong ptr field, expedted \"%p\", got \"%p\"", (mmux_pointer_t)(ptn_asciiz + 13), (mmux_pointer_t)ptr_field);
    handle_error();
  }
  if (4 != len_field) {
    printf_error("wrong len field, expedted \"%lu\", got \"%lu\"", (mmux_usize_t)4, len_field);
    handle_error();
  }
}


/** --------------------------------------------------------------------
 ** Predicates.
 ** ----------------------------------------------------------------- */

void
extension_predicates (void)
{
  printf_message("running test: %s", __func__);

  mmux_libc_ptn_t		ptn;
  mmux_libc_ptn_extension_t	ext;

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, "/path/to/file.ext")) {
    handle_error();
  }

  if (mmux_libc_make_file_system_pathname_extension(&ext, ptn)) {
    handle_error();
  }

  /* is_empty */
  {
    bool	is_empty;

    mmux_libc_file_system_pathname_extension_is_empty(&is_empty, ext);

    if (is_empty) {
      printf_error("is empty predicate failure");
      handle_error();
    }
  }
}


/** --------------------------------------------------------------------
 ** Common cases.
 ** ----------------------------------------------------------------- */

static void
one_common_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_asciiz)
{
  mmux_libc_ptn_t		ptn;
  mmux_libc_ptn_extension_t	ext, expected;
  mmux_usize_t			expected_asciiz_len;
  bool				correct;

  mmux_libc_strlen(&expected_asciiz_len, expected_asciiz);

  if (mmux_libc_make_file_system_pathname_extension_raw(&expected, expected_asciiz, expected_asciiz_len)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, ptn_asciiz)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname_extension(&ext, ptn)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_extension_equal(&correct, expected, ext)) {
    handle_error();
  } else if (correct) {
    printf_message("pathname \"%s\", extension \"%s\"", ptn_asciiz, ext.ptr);
  } else {
    printf_error("invalid result, expected \"%s\", got \"%s\"", expected.ptr, ext.ptr);
    mmux_libc_exit_failure();
  }
}
static void
one_error_case (mmux_asciizcp_t ptn_asciiz)
{
  mmux_libc_ptn_t		ptn;
  mmux_libc_ptn_extension_t	ext;

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, ptn_asciiz)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname_extension(&ext, ptn)) {
    mmux_sint_t		errnum;

    mmux_libc_errno_consume(&errnum);
    if (MMUX_LIBC_EINVAL == errnum) {
      printf_message("correctly detected invalid pathname for extension \"%s\"", ptn_asciiz);
    } else {
      printf_error("expected EINVAL result, pathname \"%s\"", ptn_asciiz);
      mmux_libc_exit_failure();
    }
  } else {
    printf_error("expected EINVAL result, pathname \"%s\"", ptn_asciiz);
    mmux_libc_exit_failure();
  }
}

static void
common_cases (void)
{
  printf_message("running test: %s", __func__);

  one_common_case("/path/to/file.ext",		".ext");
  one_common_case("/path/to/file-1.2.3.ext",	".ext");
  one_common_case("/path/to/file",		"");
  one_common_case("/path/to/file.",		".");
  one_common_case("/path/to/directory.ext/",	".ext");
  one_common_case("/path/to/directory/",	"");
  one_common_case("/path/to/.dotfile",		"");
  one_common_case("/path/to/.dotfile.ext",	".ext");

  one_common_case("file.ext",			".ext");
  one_common_case("file-1.2.3.ext",		".ext");
  one_common_case("file",			"");
  one_common_case("file.",			".");
  one_common_case("directory.ext/",		".ext");
  one_common_case("directory/",			"");
//  one_common_case("directory.ext//",		".ext");
//  one_common_case("directory.ext////",		".ext");
  one_common_case(".dotfile",			"");
  one_common_case(".dotfile.ext",		".ext");

  one_common_case("./file.ext",			".ext");
  one_common_case("./file-1.2.3.ext",		".ext");
  one_common_case("./file",			"");
  one_common_case("./file.",			".");
  one_common_case("./directory.ext/",		".ext");
  one_common_case("./.dotfile",			"");
  one_common_case("./.dotfile.ext",		".ext");

  one_error_case("/");
  one_error_case(".");
  one_error_case("..");
  one_error_case("/path/to/.");
  one_error_case("/path/to/..");

  one_common_case("/path/to/../file.ext",	".ext");
}


/** --------------------------------------------------------------------
 ** Comparison function.
 ** ----------------------------------------------------------------- */

static void
one_comparison (mmux_sint_t expected_cmpnum, mmux_asciizcp_t ptn_asciiz_1, mmux_asciizcp_t ptn_asciiz_2)
{
  mmux_libc_ptn_t		ptn1, ptn2;
  mmux_libc_ptn_extension_t	ext1, ext2;
  mmux_sint_t			cmpnum;

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn1, ptn_asciiz_1)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn2, ptn_asciiz_2)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname_extension(&ext1, ptn1)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname_extension(&ext2, ptn2)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, ext1, ext2)) {
    handle_error();
  } else if (expected_cmpnum != cmpnum) {
    printf_error("invalid comparison, expected_cmpnum %d, cmpnum %d",
		 expected_cmpnum, cmpnum);
    mmux_libc_exit_failure();
  }
}

static void
comparison_functions (void)
{
  printf_message("running test: %s", __func__);

  one_comparison( 0, "/path/to/file.ext",		"/path/to/file.ext");
  one_comparison(-1, "/path/to/file.AAA",		"/path/to/file.BBB");
  one_comparison(+1, "/path/to/file.BBB",		"/path/to/file.AAA");
}


/** --------------------------------------------------------------------
 ** Comparison predicates.
 ** ----------------------------------------------------------------- */

static void
one_comparison_predicate (bool expected_equal,
		bool expected_less, bool expected_greater,
		bool expected_less_equal, bool expected_greater_equal,
		mmux_asciizcp_t ptn_asciiz_1, mmux_asciizcp_t ptn_asciiz_2)
{
  mmux_libc_ptn_t		ptn1, ptn2;
  mmux_libc_ptn_extension_t	ext1, ext2;

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn1, ptn_asciiz_1)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn2, ptn_asciiz_2)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname_extension(&ext1, ptn1)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname_extension(&ext2, ptn2)) {
    handle_error();
  } else {
    bool	result;

    if (mmux_libc_file_system_pathname_extension_equal(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_equal == result) {
      printf_message("ext1=%s, ext2=%s equal result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid equal predicate, expected_equal %d, result %s", ext1.ptr, ext2.ptr, expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_not_equal(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_equal != result) {
      printf_message("ext1=%s, ext2=%s not_equal result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid not_equal predicate, expected_not_equal %d, result %s", ext1.ptr, ext2.ptr, !expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_less(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_less == result) {
      printf_message("ext1=%s, ext2=%s less result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid less predicate, expected_less %d, result %s", ext1.ptr, ext2.ptr, expected_less, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_greater(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_greater == result) {
      printf_message("ext1=%s, ext2=%s greater result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid greater predicate, expected_greater %d, result %s", ext1.ptr, ext2.ptr, expected_greater, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_less_equal(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_less_equal == result) {
      printf_message("ext1=%s, ext2=%s less_equal result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid less_equal predicate, expected_less_equal %d, result %s", ext1.ptr, ext2.ptr, expected_less_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_greater_equal(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_greater_equal == result) {
      printf_message("ext1=%s, ext2=%s greater_equal result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid greater_equal predicate, expected_greater_equal %d, result %s", ext1.ptr, ext2.ptr, expected_greater_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }
  }
}
static void
comparison_predicate_functions (void)
{
  printf_message("running test: %s", __func__);

  //                       =      <      >       <=     >=
  one_comparison_predicate(true,  false, false,  true,  true,	"/path/to/file.ext",		"/path/to/file.ext");
  one_comparison_predicate(false, true,  false,  true,  false,	"/path/to/file.AAA",		"/path/to/file.BBB");
  one_comparison_predicate(false, false, true,   false, true,	"/path/to/file.BBB",		"/path/to/file.AAA");

  //                       =      <      >       <=     >=
  one_comparison_predicate(false, true,  false,  true,  false,	"/path/to/file.AAAA",		"/path/to/file.BBB");
  one_comparison_predicate(false, false, true,   false, true,	"/path/to/file.BBB",		"/path/to/file.AAAA");

  //                       =      <      >       <=     >=
  one_comparison_predicate(false, true,  false,  true,  false,	"/path/to/file.AAA",		"/path/to/file.BBBB");
  one_comparison_predicate(false, false, true,   false, true,	"/path/to/file.BBBB",		"/path/to/file.AAA");

  //                       =      <      >       <=     >=
  one_comparison_predicate(false, true,  false,  true,  false,	"/path/to/file.AAA",		"/path/to/file.AAAB");
  one_comparison_predicate(false, false, true,   false, true,	"/path/to/file.AAAB",		"/path/to/file.AAA");

  //                       =      <      >       <=     >=
  one_comparison_predicate(true,  false, false,  true,  true,	"/path/to/file.",		"/path/to/file.");
  one_comparison_predicate(false, true,  false,  true,  false,	"/path/to/file.",		"/path/to/file.A");
  one_comparison_predicate(false, false, true,   false, true,	"/path/to/file.A",		"/path/to/file.");

  //                       =      <      >       <=     >=
  one_comparison_predicate(true,  false, false,  true,  true,	"/path/to/file",		"/path/to/file");
  one_comparison_predicate(false, true,  false,  true,  false,	"/path/to/file",		"/path/to/file.A");
  one_comparison_predicate(false, false, true,   false, true,	"/path/to/file.A",		"/path/to/file");
}


/** --------------------------------------------------------------------
 ** Pathname has extension.
 ** ----------------------------------------------------------------- */

static void
one_pathname_has_extension (bool expected_result, mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t ext_asciiz)
{
  mmux_libc_file_system_pathname_t		ptn;
  mmux_libc_file_system_pathname_extension_t	ext;
  mmux_usize_t					ext_len;
  bool						result;

  mmux_libc_strlen(&ext_len, ext_asciiz);

  if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, ptn_asciiz)) {
    handle_error();
  }
  if (mmux_libc_make_file_system_pathname_extension_raw(&ext, ext_asciiz, ext_len)) {
    handle_error();
  }
  if (mmux_libc_file_system_pathname_has_extension(&result, ptn, ext)) {
    handle_error();
  } else if (expected_result == result) {
    printf_message("pathname \"%s\" has extension \"%s\"? %s", ptn_asciiz, ext_asciiz, BOOL_STRING(result));
  } else {
    printf_message("pathname \"%s\" has extension \"%s\"? wrong result %s", ptn_asciiz, ext_asciiz, BOOL_STRING(result));
    mmux_libc_exit_failure();
  }
}

static void
pathname_has_extension (void)
{
  printf_message("running test: %s", __func__);

  one_pathname_has_extension(true,	"/path/to/file.ext",	".ext");
  one_pathname_has_extension(false,	"/path/to/file.ext",	".bak");

  one_pathname_has_extension(true,	"/path/to/file",	"");
  one_pathname_has_extension(false,	"/path/to/file.ext",	"");

  one_pathname_has_extension(true,	"/path/to/file.",	".");
  one_pathname_has_extension(false,	"/path/to/file.ext",	".");
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
    PROGNAME			= "test-file-system-pathname-extensions";
  }

  if (1) {	making_an_extension_from_raw_arguments();	}
  if (1) {	making_an_extension_from_pathname();		}
  if (1) {	extension_accessors();				}
  if (1) {	extension_predicates();				}
  if (1) {	common_cases();					}
  if (1) {	comparison_functions();				}
  if (1) {	comparison_predicate_functions();		}
  if (1) {	pathname_has_extension();			}

  mmux_libc_exit_success();
}

/* end of file */
