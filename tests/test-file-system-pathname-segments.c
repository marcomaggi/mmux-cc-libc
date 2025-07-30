/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 27, 2025

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
making_a_segment_from_raw_arguments (void)
{
  printf_message("running test: %s", __func__);
  mmux_libc_ptn_t		ptn;
  mmux_asciizcp_t		ptn_asciiz;
  mmux_libc_ptn_segment_t	ext;
  mmux_libc_fd_t		er;

  //                                             012345678901234567
  //                                                      ^
  if (mmux_libc_make_file_system_pathname(&ptn, "/path/to/file.ext")) {
    handle_error();
  }

  if (mmux_libc_file_system_pathname_ptr_ref(&ptn_asciiz, ptn)) {
    handle_error();
  }

  if (mmux_libc_make_file_system_pathname_segment_raw(&ext, ptn_asciiz + 9, 9)) {
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

  if (mmux_libc_dprintfer("*** the pathname last segment is: ")) {
    handle_error();
  }
  if (mmux_libc_dprintf_libc_ptn_segment(er, ext)) {
    handle_error();
  }
  if (mmux_libc_dprintfer_newline()) { handle_error(); }
}

/* ------------------------------------------------------------------ */

static void
making_the_last_segment_from_pathname (void)
{
  printf_message("running test: %s", __func__);
  mmux_libc_ptn_t		ptn;
  mmux_libc_ptn_segment_t	ext;
  mmux_libc_fd_t		er;

  //                                             012345678901234567
  //                                                      ^
  if (mmux_libc_make_file_system_pathname(&ptn, "/path/to/file.ext")) {
    handle_error();
  }

  if (mmux_libc_file_system_pathname_segment_find_last(&ext, ptn)) {
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

  if (mmux_libc_dprintfer("*** the pathname last segment is: ")) {
    handle_error();
  }
  if (mmux_libc_dprintf_libc_ptn_segment(er, ext)) {
    handle_error();
  }
  if (mmux_libc_dprintfer_newline()) { handle_error(); }
}


/** --------------------------------------------------------------------
 ** Accessors.
 ** ----------------------------------------------------------------- */

static void
segment_accessors (void)
{
  printf_message("running test: %s", __func__);

  mmux_libc_ptn_t		ptn;
  mmux_asciizcp_t		ptn_asciiz;
  mmux_libc_ptn_segment_t	ext;
  mmux_asciizcp_t		ptr_field;
  mmux_usize_t			len_field;

  //                                             012345678901234567
  //                                                      ^
  if (mmux_libc_make_file_system_pathname(&ptn, "/path/to/file.ext")) {
    handle_error();
  }

  if (mmux_libc_file_system_pathname_ptr_ref(&ptn_asciiz, ptn)) {
    handle_error();
  }

  if (mmux_libc_file_system_pathname_segment_find_last(&ext, ptn)) {
    handle_error();
  }

  mmux_libc_file_system_pathname_segment_ptr_ref(&ptr_field, ext);
  mmux_libc_file_system_pathname_segment_len_ref(&len_field, ext);


  if ((ptn_asciiz + 9) != ptr_field) {
    printf_error("wrong ptr field, expedted \"%p\", got \"%p\"",
		 (mmux_pointer_t)(ptn_asciiz + 9),
		 (mmux_pointer_t)ptr_field);
    handle_error();
  }
  if (8 != len_field) {
    printf_error("wrong len field, expedted \"%lu\", got \"%lu\"", (mmux_usize_t)8, len_field);
    handle_error();
  }
}


/** --------------------------------------------------------------------
 ** Predicates.
 ** ----------------------------------------------------------------- */

void
one_segment_predicate (bool is_dot_expected_result, bool is_double_dot_expected_result,
		       bool is_slash_expected_result,
		       mmux_asciizcp_t seg_asciiz)
{
  mmux_libc_ptn_segment_t	seg;
  bool				result;

  if (mmux_libc_make_file_system_pathname_segment_raw_asciiz(&seg, seg_asciiz)) {
    handle_error();
  }

  if (1) {
    if (mmux_libc_file_system_pathname_segment_is_dot(&result, seg)) {
      handle_error();
    }
    if (is_dot_expected_result != result) {
      printf_error("is dot predicate failure, segment %s, expected %s, got %s", seg_asciiz,
		   BOOL_STRING(is_dot_expected_result), BOOL_STRING(result));
      handle_error();
    }
  }

  if (1) {
    if (mmux_libc_file_system_pathname_segment_is_double_dot(&result, seg)) {
      handle_error();
    }
    if (is_double_dot_expected_result != result) {
      printf_error("is double dot predicate failure, segment %s, expected %s, got %s", seg_asciiz,
		   BOOL_STRING(is_double_dot_expected_result), BOOL_STRING(result));
      handle_error();
    }
  }

  if (1) {
    if (mmux_libc_file_system_pathname_segment_is_slash(&result, seg)) {
      handle_error();
    }
    if (is_slash_expected_result != result) {
      printf_error("is slash predicate failure, segment %s, expected %s, got %s", seg_asciiz,
		   BOOL_STRING(is_slash_expected_result), BOOL_STRING(result));
      handle_error();
    }
  }
}

void
segment_predicates (void)
{
  printf_message("running test: %s", __func__);

  one_segment_predicate(false, false, false,	"file.ext");
  one_segment_predicate(true,  false, false,	".");
  one_segment_predicate(false, true,  false,	"..");
  one_segment_predicate(false, false, true,	"/");
}


/** --------------------------------------------------------------------
 ** Common cases.
 ** ----------------------------------------------------------------- */

static void
one_last_segment_case (mmux_asciizcp_t ptn_asciiz, mmux_asciizcp_t expected_seg_asciiz)
{
  mmux_libc_ptn_t		ptn;
  mmux_libc_ptn_segment_t	seg, expected_seg;
  bool				correct;

  if (mmux_libc_make_file_system_pathname_segment_raw_asciiz(&expected_seg, expected_seg_asciiz)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname(&ptn, ptn_asciiz)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_segment_find_last(&seg, ptn)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_segment_equal(&correct, expected_seg, seg)) {
    handle_error();
  } else if (correct) {
    mmux_libc_fd_t	er;

    mmux_libc_stder(&er);
    if (mmux_libc_dprintfer("pathname \"%s\", last segment \"", ptn_asciiz)) {
      handle_error();
    }
    if (mmux_libc_dprintf_libc_ptn_segment(er, seg)) {
      handle_error();
    }
    if (mmux_libc_dprintfer("\"\n")) {
      handle_error();
    }
  } else {
    mmux_libc_fd_t	er;

    mmux_libc_stder(&er);
    if (mmux_libc_dprintfer("invalid result, pathname \"%s\", last segment \"", ptn_asciiz)) {
      handle_error();
    }
    if (mmux_libc_dprintf_libc_ptn_segment(er, seg)) {
      handle_error();
    }
    if (mmux_libc_dprintfer("\"\n")) {
      handle_error();
    }
    mmux_libc_exit_failure();
  }
}

static void
last_segment_cases (void)
{
  printf_message("running test: %s", __func__);

  one_last_segment_case("/path/to/file.ext",		"file.ext");
  one_last_segment_case("file.ext",			"file.ext");

  one_last_segment_case("/path/to/.dotfile",		".dotfile");
  one_last_segment_case(".dotfile",			".dotfile");

  one_last_segment_case("/path/to/directory.d/",	"directory.d");
  one_last_segment_case("directory.d/",			"directory.d");

  one_last_segment_case("/path/to/.",			".");
  one_last_segment_case(".",				".");

  one_last_segment_case("/path/to/..",			"..");
  one_last_segment_case("..",				"..");

  one_last_segment_case("/",				"/");
}


/** --------------------------------------------------------------------
 ** Comparison function.
 ** ----------------------------------------------------------------- */

static void
one_comparison (mmux_sint_t expected_cmpnum, mmux_asciizcp_t ptn_asciiz_1, mmux_asciizcp_t ptn_asciiz_2)
{
  mmux_libc_ptn_t		ptn1, ptn2;
  mmux_libc_ptn_segment_t	ext1, ext2;
  mmux_sint_t			cmpnum;

  if (mmux_libc_make_file_system_pathname(&ptn1, ptn_asciiz_1)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname(&ptn2, ptn_asciiz_2)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_segment_find_last(&ext1, ptn1)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_segment_find_last(&ext2, ptn2)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, ext1, ext2)) {
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
  mmux_libc_ptn_segment_t	ext1, ext2;

  if (mmux_libc_make_file_system_pathname(&ptn1, ptn_asciiz_1)) {
    handle_error();
  } else if (mmux_libc_make_file_system_pathname(&ptn2, ptn_asciiz_2)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_segment_find_last(&ext1, ptn1)) {
    handle_error();
  } else if (mmux_libc_file_system_pathname_segment_find_last(&ext2, ptn2)) {
    handle_error();
  } else {
    bool	result;

    if (mmux_libc_file_system_pathname_segment_equal(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_equal == result) {
      printf_message("ext1=%s, ext2=%s equal result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid equal predicate, expected_equal %d, result %s", ext1.ptr, ext2.ptr, expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_not_equal(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_equal != result) {
      printf_message("ext1=%s, ext2=%s not_equal result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid not_equal predicate, expected_not_equal %d, result %s", ext1.ptr, ext2.ptr, !expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_less(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_less == result) {
      printf_message("ext1=%s, ext2=%s less result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid less predicate, expected_less %d, result %s", ext1.ptr, ext2.ptr, expected_less, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_greater(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_greater == result) {
      printf_message("ext1=%s, ext2=%s greater result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid greater predicate, expected_greater %d, result %s", ext1.ptr, ext2.ptr, expected_greater, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_less_equal(&result, ext1, ext2)) {
      handle_error();
    } else if (expected_less_equal == result) {
      printf_message("ext1=%s, ext2=%s less_equal result: %s", ext1.ptr, ext2.ptr, BOOL_STRING(result));
    } else {
      printf_error("ext1=%s, ext2=%s, invalid less_equal predicate, expected_less_equal %d, result %s", ext1.ptr, ext2.ptr, expected_less_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_greater_equal(&result, ext1, ext2)) {
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
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME			= "test-file-system-pathname-segments";
  }

  if (1) {	making_a_segment_from_raw_arguments();		}
  if (1) {	making_the_last_segment_from_pathname();	}
  if (1) {	segment_accessors();				}
  if (1) {	segment_predicates();				}
  if (1) {	last_segment_cases();				}
  if (1) {	comparison_functions();				}
  if (1) {	comparison_predicate_functions();		}

  mmux_libc_exit_success();
}

/* end of file */
