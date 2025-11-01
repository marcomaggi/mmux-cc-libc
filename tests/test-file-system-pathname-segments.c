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

#include <test-common.h>


/** --------------------------------------------------------------------
 ** Constructors.
 ** ----------------------------------------------------------------- */

static void
making_a_segment_from_raw_arguments (void)
{
  printf_message("running test: %s", __func__);
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_segment_t	fs_ptn_seg;
  mmux_libc_fd_t		er;

  /* Build the file system pathname. */
  {
    //                                        012345678901234567
    //                                                 ^
    //                                                 12345678
    mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build the file system pathname segment representing the tailname. */
  {
    mmux_asciizcp_t	ptn_asciiz;

    if (mmux_libc_file_system_pathname_ptr_ref(&ptn_asciiz, fs_ptn)) {
      handle_error();
    } else {
      mmux_asciizcp_t	seg_ptr = ptn_asciiz + 9;
      auto		seg_len = mmux_usize_literal(8);

      if (mmux_libc_make_file_system_pathname_segment_raw(fs_ptn_seg, seg_ptr, seg_len)) {
	handle_error();
      }
    }
  }

  /* Validate the result. */
  {
    bool	the_strings_are_equal;

    if (mmux_libc_strequ(&the_strings_are_equal, fs_ptn_seg->ptr, "file.ext")) {
      handle_error();
    } else if (the_strings_are_equal) {
      printf_message("the extracted segment is correct");
    } else {
      printf_error("the extracted segment has wrong contents");
      handle_error();
    }

    {
      mmux_libc_stder(er);

      if (mmux_libc_dprintfer("*** the pathname is: ")) {
	handle_error();
      }
      if (mmux_libc_dprintf_fs_ptn(er, fs_ptn)) {
	handle_error();
      }
      if (mmux_libc_dprintfer_newline()) { handle_error(); }

      if (mmux_libc_dprintfer("*** the pathname last segment is: ")) {
	handle_error();
      }
      if (mmux_libc_dprintf_fs_ptn_segment(er, fs_ptn_seg)) {
	handle_error();
      }
      if (mmux_libc_dprintfer_newline()) { handle_error(); }
    }
  }

  /* Final cleanup. */
  {
    mmux_libc_unmake_file_system_pathname(fs_ptn);
  }
}

/* ------------------------------------------------------------------ */

static void
making_the_last_segment_from_pathname (void)
{
  printf_message("running test: %s", __func__);
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_segment_t	fs_ptn_seg;

  /* Build file system pathname. */
  {
    //                                        012345678901234567
    //                                                 ^
    //                                                 12345678
    mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build file system pathname segment. */
  {
    if (mmux_libc_file_system_pathname_segment_find_last(fs_ptn_seg, fs_ptn)) {
      handle_error();
    }
  }

  /* Validte the segment. */
  {
    bool	the_strings_are_equal;

    if (mmux_libc_strequ(&the_strings_are_equal, fs_ptn_seg->ptr, "file.ext")) {
      handle_error();
    } else if (the_strings_are_equal) {
      printf_message("the extracted segment is correct");
    } else {
      printf_error("the extracted segment has wrong contents");
      handle_error();
    }

    {
      mmux_libc_fd_t		er;

      mmux_libc_stder(er);

      if (mmux_libc_dprintfer("*** the pathname is: ")) {
	handle_error();
      }
      if (mmux_libc_dprintf_fs_ptn(er, fs_ptn)) {
	handle_error();
      }
      if (mmux_libc_dprintfer_newline()) { handle_error(); }

      if (mmux_libc_dprintfer("*** the pathname last segment is: ")) {
	handle_error();
      }
      if (mmux_libc_dprintf_fs_ptn_segment(er, fs_ptn_seg)) {
	handle_error();
      }
      if (mmux_libc_dprintfer_newline()) { handle_error(); }
    }
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
segment_accessors (void)
{
  printf_message("running test: %s", __func__);

  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_segment_t	fs_ptn_seg;

  /* Build the file system pathname. */
  {
    //                                        012345678901234567
    //                                                 ^
    mmux_asciizcp_t		ptn_asciiz = "/path/to/file.ext";
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Buld the file system pathname last segment. */
  {
    if (mmux_libc_file_system_pathname_segment_find_last(fs_ptn_seg, fs_ptn)) {
      handle_error();
    }
  }

  /* Use the accessors. */
  {
    mmux_asciizcp_t	seg_ptr_field;
    mmux_usize_t	seg_len_field;

    if (mmux_libc_file_system_pathname_segment_ptr_ref(&seg_ptr_field, fs_ptn_seg)) {
      handle_error();
    }
    if (mmux_libc_file_system_pathname_segment_len_ref(&seg_len_field, fs_ptn_seg)) {
      handle_error();
    }

    /* Access segment pointer. */
    {
      mmux_asciizcp_t	ptn_asciiz;

      if (mmux_libc_file_system_pathname_ptr_ref(&ptn_asciiz, fs_ptn)) {
	handle_error();
      } else {
	mmux_asciizcp_t	expected_seg_ptr_field = ptn_asciiz + 9;

	if ((ptn_asciiz + 9) == seg_ptr_field) {
	  printf_message("*** correct segment pointer");
	} else {
	  printf_error("wrong ptr field, expedted \"%p\", got \"%p\"",
		       (mmux_pointer_t)expected_seg_ptr_field,
		       (mmux_pointer_t)seg_ptr_field);
	  handle_error();
	}
      }
    }

    /* Access segment length. */
    {
      auto	expected_seg_len_field = mmux_usize_literal(8);

      if (mmux_ctype_equal(expected_seg_len_field, seg_len_field)) {
	printf_message("*** correct segment length");
      } else {
	printf_error("wrong len field, expedted \"%lu\", got \"%lu\"",
		     expected_seg_len_field.value, seg_len_field.value);
	handle_error();
      }
    }
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
one_segment_predicate (bool is_dot_expected_result, bool is_double_dot_expected_result,
		       bool is_slash_expected_result,
		       mmux_asciizcp_t seg_asciiz)
{
  mmux_libc_fs_ptn_segment_t	fs_ptn_seg;

  /* Build file system pathname segment. */
  {
    if (mmux_libc_make_file_system_pathname_segment_raw_asciiz(fs_ptn_seg, seg_asciiz)) {
      handle_error();
    }
  }

  if (true) {
    bool	result;

    if (mmux_libc_file_system_pathname_segment_is_dot(&result, fs_ptn_seg)) {
      handle_error();
    }
    if (is_dot_expected_result == result) {
      printf_message("correct segment_is_dot predicate result");
    } else {
      printf_error("is dot predicate failure, segment %s, expected %s, got %s", seg_asciiz,
		   BOOL_STRING(is_dot_expected_result), BOOL_STRING(result));
      handle_error();
    }
  }

  if (true) {
    bool	result;

    if (mmux_libc_file_system_pathname_segment_is_double_dot(&result, fs_ptn_seg)) {
      handle_error();
    }
    if (is_double_dot_expected_result == result) {
      printf_message("correct segment_is_double_dot predicate result");
    } else {
      printf_error("is double dot predicate failure, segment %s, expected %s, got %s", seg_asciiz,
		   BOOL_STRING(is_double_dot_expected_result), BOOL_STRING(result));
      handle_error();
    }
  }

  if (true) {
    bool	result;

    if (mmux_libc_file_system_pathname_segment_is_slash(&result, fs_ptn_seg)) {
      handle_error();
    }
    if (is_slash_expected_result == result) {
      printf_message("correct segment_is_slash predicate result");
    } else {
      printf_error("is slash predicate failure, segment %s, expected %s, got %s", seg_asciiz,
		   BOOL_STRING(is_slash_expected_result), BOOL_STRING(result));
      handle_error();
    }
  }
}
static void
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
  mmux_libc_fs_ptn_t		fs_ptn;
  mmux_libc_fs_ptn_segment_t	fs_ptn_seg, fs_ptn_seg_expected;

  /* Build file system pathname. */
  {
    mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

    mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
    if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
      handle_error();
    }
  }

  /* Build the expected file system pathname segment. */
  {
    if (mmux_libc_make_file_system_pathname_segment_raw_asciiz(fs_ptn_seg_expected, expected_seg_asciiz)) {
    handle_error();
    }
  }

  /* Build the file system pathname last segment. */
  {
    if (mmux_libc_file_system_pathname_segment_find_last(fs_ptn_seg, fs_ptn)) {
      handle_error();
    }
  }

  {
    bool	correct;

    if (mmux_libc_file_system_pathname_segment_equal(&correct, fs_ptn_seg_expected, fs_ptn_seg)) {
      handle_error();
    } else if (correct) {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_dprintfer("*** pathname \"%s\", last segment \"", ptn_asciiz)) {
	handle_error();
      }
      if (mmux_libc_dprintf_fs_ptn_segment(er, fs_ptn_seg)) {
	handle_error();
      }
      if (mmux_libc_dprintfer("\"\n")) {
	handle_error();
      }
    } else {
      mmux_libc_fd_t	er;

      mmux_libc_stder(er);
      if (mmux_libc_dprintfer("invalid result, pathname \"%s\", last segment \"", ptn_asciiz)) {
	handle_error();
      }
      if (mmux_libc_dprintf_fs_ptn_segment(er, fs_ptn_seg)) {
	handle_error();
      }
      if (mmux_libc_dprintfer("\"\n")) {
	handle_error();
      }
      mmux_libc_exit_failure();
    }

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
one_comparison (mmux_standard_sint_t expected_cmpnum, mmux_asciizcp_t ptn_asciiz_1, mmux_asciizcp_t ptn_asciiz_2)
{
  mmux_libc_fs_ptn_t		fs_ptn1, fs_ptn2;
  mmux_libc_fs_ptn_segment_t	fs_ptn_ext1, fs_ptn_ext2;

  /* Build file system pathname. */
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

  /* Build file system pathname last segments. */
  {
    if (mmux_libc_file_system_pathname_segment_find_last(fs_ptn_ext1, fs_ptn1)) {
      handle_error();
    }
    if (mmux_libc_file_system_pathname_segment_find_last(fs_ptn_ext2, fs_ptn2)) {
      handle_error();
    }
  }

  {
    auto	ecmpnum = mmux_ternary_comparison_result(expected_cmpnum);
    mmux_ternary_comparison_result_t	cmpnum;

    if (mmux_libc_file_system_pathname_segment_compare(&cmpnum, fs_ptn_ext1, fs_ptn_ext2)) {
      handle_error();
    } else if (mmux_ctype_not_equal(ecmpnum, cmpnum)) {
      printf_error("invalid comparison, expected_cmpnum %d, cmpnum %d",
		   ecmpnum.value, cmpnum.value);
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
  mmux_libc_fs_ptn_segment_t	fs_ptn_seg1, fs_ptn_seg2;

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

  /* Build the file system pathname last segments. */
  {
    if (mmux_libc_file_system_pathname_segment_find_last(fs_ptn_seg1, fs_ptn1)) {
      handle_error();
    }
    if (mmux_libc_file_system_pathname_segment_find_last(fs_ptn_seg2, fs_ptn2)) {
      handle_error();
    }
  }

  /* Do it. */
  {
    bool	result;

    if (mmux_libc_file_system_pathname_segment_equal(&result, fs_ptn_seg1, fs_ptn_seg2)) {
      handle_error();
    } else if (expected_equal == result) {
      printf_message("seg1=%s, seg2=%s equal result: %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, BOOL_STRING(result));
    } else {
      printf_error("seg1=%s, seg2=%s, invalid equal predicate, expected_equal %d, result %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_not_equal(&result, fs_ptn_seg1, fs_ptn_seg2)) {
      handle_error();
    } else if (expected_equal != result) {
      printf_message("seg1=%s, fs_ptn_seg2=%s not_equal result: %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, BOOL_STRING(result));
    } else {
      printf_error("seg1=%s, fs_ptn_seg2=%s, invalid not_equal predicate, expected_not_equal %d, result %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, !expected_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_less(&result, fs_ptn_seg1, fs_ptn_seg2)) {
      handle_error();
    } else if (expected_less == result) {
      printf_message("seg1=%s, fs_ptn_seg2=%s less result: %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, BOOL_STRING(result));
    } else {
      printf_error("seg1=%s, fs_ptn_seg2=%s, invalid less predicate, expected_less %d, result %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, expected_less, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_greater(&result, fs_ptn_seg1, fs_ptn_seg2)) {
      handle_error();
    } else if (expected_greater == result) {
      printf_message("seg1=%s, fs_ptn_seg2=%s greater result: %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, BOOL_STRING(result));
    } else {
      printf_error("seg1=%s, fs_ptn_seg2=%s, invalid greater predicate, expected_greater %d, result %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, expected_greater, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_less_equal(&result, fs_ptn_seg1, fs_ptn_seg2)) {
      handle_error();
    } else if (expected_less_equal == result) {
      printf_message("seg1=%s, fs_ptn_seg2=%s less_equal result: %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, BOOL_STRING(result));
    } else {
      printf_error("seg1=%s, fs_ptn_seg2=%s, invalid less_equal predicate, expected_less_equal %d, result %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, expected_less_equal, BOOL_STRING(result));
      mmux_libc_exit_failure();
    }

    if (mmux_libc_file_system_pathname_segment_greater_equal(&result, fs_ptn_seg1, fs_ptn_seg2)) {
      handle_error();
    } else if (expected_greater_equal == result) {
      printf_message("seg1=%s, fs_ptn_seg2=%s greater_equal result: %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, BOOL_STRING(result));
    } else {
      printf_error("seg1=%s, fs_ptn_seg2=%s, invalid greater_equal predicate, expected_greater_equal %d, result %s", fs_ptn_seg1->ptr, fs_ptn_seg2->ptr, expected_greater_equal, BOOL_STRING(result));
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
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME	= "test-file-system-pathname-segments";
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
