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

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Constructors.
 ** ----------------------------------------------------------------- */

static void
making_an_extension_from_raw_arguments (void)
{
  printf_message("running test: %s", __func__);
  //                                          012345678901234567
  mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_factory_t	fs_ptn_factory;
  mmux_libc_fs_ptn_extension_t	ext;
  mmux_libc_fd_t		er;

  /* Build the file system pathname. */
  {
    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build the file system pathname extension. */
  {
    mmux_asciizcp_t	ext_ptr = ptn_asciiz + 13;
    auto		ext_len = mmux_usize_literal(4);

    if (mmux_libc_make_file_system_pathname_extension_raw(ext, ext_ptr, ext_len)) {
      handle_error();
    }
  }

  /* Check the extension. */
  {
    mmux_libc_stder(er);

    if (mmux_libc_dprintfer("*** the pathname is: ")) {
      handle_error();
    }
    if (mmux_libc_dprintf_fs_ptn(er, fs_ptn)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }

    if (mmux_libc_dprintfer("*** the pathname extension is: ")) {
      handle_error();
    }
    if (mmux_libc_dprintf_fs_ptn_extension(er, ext)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn);
  }
}

/* ------------------------------------------------------------------ */

static void
making_an_extension_from_pathname (void)
{
  printf_message("running test: %s", __func__);
  //                                          012345678901234567
  //                                                       ^
  mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext;
  mmux_libc_fd_t		er;

  /* Build the file system pathname. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build the extension. */
  if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext, fs_ptn)) {
    handle_error();
  }

  /* Check the extension. */
  {
    mmux_libc_stder(er);

    if (mmux_libc_dprintfer("*** the pathname is: ")) {
      handle_error();
    }
    if (mmux_libc_dprintf_fs_ptn(er, fs_ptn)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }

    if (mmux_libc_dprintfer("*** the pathname extension is: ")) {
      handle_error();
    }
    if (mmux_libc_dprintf_fs_ptn_extension(er, fs_ptn_ext)) {
      handle_error();
    }
    if (mmux_libc_dprintfer_newline()) { handle_error(); }
  }

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn);
  }
}


/** --------------------------------------------------------------------
 ** Accessors.
 ** ----------------------------------------------------------------- */

static void
extension_accessors (void)
{
  printf_message("running test: %s", __func__);

  //                                          012345678901234567
  mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext;
  mmux_asciizcp_t		ptr_field;
  mmux_usize_t			len_field;

  /* Build the file system pathname. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  if (mmux_libc_file_system_pathname_ptr_ref(&ptn_asciiz, fs_ptn)) {
    handle_error();
  }

  {
    auto		ext_len = mmux_usize_literal(4);
    mmux_asciizcp_t	ext_ptr = ptn_asciiz + 13;

    if (mmux_libc_make_file_system_pathname_extension_raw(fs_ptn_ext, ext_ptr, ext_len)) {
      handle_error();
    }
  }

  mmux_libc_file_system_pathname_extension_ptr_ref(&ptr_field, fs_ptn_ext);
  mmux_libc_file_system_pathname_extension_len_ref(&len_field, fs_ptn_ext);

  if ((ptn_asciiz + 13) != ptr_field) {
    printf_error("wrong ptr field, expedted \"%p\", got \"%p\"",
		 (mmux_pointer_t)(ptn_asciiz + 13),
		 (mmux_pointer_t)ptr_field);
    handle_error();
  }
  if (4 != len_field.value) {
    printf_error("wrong len field, expedted \"%lu\", got \"%lu\"",
		 (mmux_standard_usize_t)4, len_field.value);
    handle_error();
  }

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn);
  }
}


/** --------------------------------------------------------------------
 ** Predicates.
 ** ----------------------------------------------------------------- */

void
extension_predicates (void)
{
  printf_message("running test: %s", __func__);

  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext;

  /* Build the file system pathname. */
  {
    mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext, fs_ptn)) {
    handle_error();
  }

  /* is_empty */
  {
    bool	is_empty;

    mmux_libc_file_system_pathname_extension_is_empty(&is_empty, fs_ptn_ext);

    if (is_empty) {
      printf_error("is empty predicate failure");
      handle_error();
    }
  }
}


/** --------------------------------------------------------------------
 ** Building extension objects: common cases.
 ** ----------------------------------------------------------------- */

static void
one_common_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_asciiz)
{
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext, fs_ptn_ext_expected;
  bool				correct;

  /* Build the expected file system pathname extension. */
  {
    mmux_usize_t	expected_asciiz_len;

    mmux_libc_strlen(&expected_asciiz_len, expected_asciiz);
    if (mmux_libc_make_file_system_pathname_extension_raw(fs_ptn_ext_expected, expected_asciiz, expected_asciiz_len)) {
      handle_error();
    }
  }

  /* Build file system pathname. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build extract the file system pathname extension. */
  {
    if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext, fs_ptn)) {
      handle_error();
    }
  }

  /* Validate the extension. */
  {
    if (mmux_libc_file_system_pathname_extension_equal(&correct, fs_ptn_ext_expected, fs_ptn_ext)) {
      handle_error();
    } else if (correct) {
      printf_message("pathname \"%s\", extension \"%s\"", ptn_asciiz, fs_ptn_ext->ptr);
    } else {
      printf_error("invalid result, expected \"%s\", got \"%s\"", fs_ptn_ext_expected->ptr, fs_ptn_ext->ptr);
      mmux_libc_exit_failure();
    }
  }

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn);
  }
}
static void
one_error_case (mmux_asciizcp_t ptn_asciiz)
{
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext;

  /* Build the file system pathname. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build the file system pathname extension. */
  {
    if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext, fs_ptn)) {
      mmux_libc_errno_t		errnum;

      mmux_libc_errno_consume(&errnum);
      if (MMUX_LIBC_VALUEOF_EINVAL == errnum.value) {
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

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn);
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
one_comparison (mmux_standard_sint_t expected_standard_cmpnum, mmux_asciizcp_t ptn_asciiz_1, mmux_asciizcp_t ptn_asciiz_2)
{
  mmux_libc_fs_ptn_t		fs_ptn1, fs_ptn2;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext1, fs_ptn_ext2;

  /* Build the file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn1, fs_ptn_factory, ptn_asciiz_1)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(fs_ptn2, fs_ptn_factory, ptn_asciiz_2)) {
      handle_error();
    }
  }

  /* Build the file system pathname extensions. */
  {
    if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext1, fs_ptn1)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext2, fs_ptn2)) {
      handle_error();
    }
  }

  /* Validate the result. */
  {
    auto	expected_cmpnum = mmux_ternary_comparison_result(expected_standard_cmpnum);
    mmux_ternary_comparison_result_t	cmpnum;

    if (mmux_libc_file_system_pathname_extension_compare(&cmpnum, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (mmux_ctype_not_equal(expected_cmpnum, cmpnum)) {
      printf_error("invalid comparison, expected_cmpnum %d, cmpnum %d",
		   expected_cmpnum.value, cmpnum.value);
      mmux_libc_exit_failure();
    }
  }

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn1);
    mmux_libc_unmake_file_system_pathname(fs_ptn2);
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
  mmux_libc_fs_ptn_t		fs_ptn1, fs_ptn2;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext1, fs_ptn_ext2;

  /* Build the file system pathnames. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn1, fs_ptn_factory, ptn_asciiz_1)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname(fs_ptn2, fs_ptn_factory, ptn_asciiz_2)) {
      handle_error();
    }
  }

  /* Build the file system pathname extensions. */
  {
    if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext1, fs_ptn1)) {
      handle_error();
    }
    if (mmux_libc_make_file_system_pathname_extension(fs_ptn_ext2, fs_ptn2)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    bool	result;

    if (mmux_libc_file_system_pathname_extension_equal(&result, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (expected_equal == result) {
      printf_message("fs_ptn_ext1=%s, fs_ptn_ext2=%s equal result: %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, BOOL_STRING(result));
    } else {
      printf_error("fs_ptn_ext1=%s, fs_ptn_ext2=%s, invalid equal predicate, expected_equal %d, result %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_not_equal(&result, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (expected_equal != result) {
      printf_message("fs_ptn_ext1=%s, fs_ptn_ext2=%s not_equal result: %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, BOOL_STRING(result));
    } else {
      printf_error("fs_ptn_ext1=%s, fs_ptn_ext2=%s, invalid not_equal predicate, expected_not_equal %d, result %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, !expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_less(&result, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (expected_less == result) {
      printf_message("fs_ptn_ext1=%s, fs_ptn_ext2=%s less result: %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, BOOL_STRING(result));
    } else {
      printf_error("fs_ptn_ext1=%s, fs_ptn_ext2=%s, invalid less predicate, expected_less %d, result %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, expected_less, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_greater(&result, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (expected_greater == result) {
      printf_message("fs_ptn_ext1=%s, fs_ptn_ext2=%s greater result: %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, BOOL_STRING(result));
    } else {
      printf_error("fs_ptn_ext1=%s, fs_ptn_ext2=%s, invalid greater predicate, expected_greater %d, result %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, expected_greater, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_less_equal(&result, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (expected_less_equal == result) {
      printf_message("fs_ptn_ext1=%s, fs_ptn_ext2=%s less_equal result: %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, BOOL_STRING(result));
    } else {
      printf_error("fs_ptn_ext1=%s, fs_ptn_ext2=%s, invalid less_equal predicate, expected_less_equal %d, result %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, expected_less_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_extension_greater_equal(&result, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (expected_greater_equal == result) {
      printf_message("fs_ptn_ext1=%s, fs_ptn_ext2=%s greater_equal result: %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, BOOL_STRING(result));
    } else {
      printf_error("fs_ptn_ext1=%s, fs_ptn_ext2=%s, invalid greater_equal predicate, expected_greater_equal %d, result %s", fs_ptn_ext1->ptr, fs_ptn_ext2->ptr, expected_greater_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }
  }

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn1);
    mmux_libc_unmake_file_system_pathname(fs_ptn2);
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
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_extension_t	fs_ptn_ext;
  bool				result;

  /* Build the file system pathname. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build the file system pathname extension. */
  {
    mmux_usize_t	ext_len;

    mmux_libc_strlen(&ext_len, ext_asciiz);
    if (mmux_libc_make_file_system_pathname_extension_raw(fs_ptn_ext, ext_asciiz, ext_len)) {
      handle_error();
    }
  }

  /* Check if the file system pathname has the given extension. */
  {
    if (mmux_libc_file_system_pathname_has_extension(&result, fs_ptn, fs_ptn_ext)) {
      handle_error();
    } else if (expected_result == result) {
      printf_message("pathname \"%s\" has extension \"%s\"? %s", ptn_asciiz, ext_asciiz, BOOL_STRING(result));
    } else {
      printf_message("pathname \"%s\" has extension \"%s\"? wrong result %s", ptn_asciiz, ext_asciiz, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }
  }

  /* Final clenaup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn);
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
