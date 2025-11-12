/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 12, 2025

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
 ** Helpers.
 ** ----------------------------------------------------------------- */

static void
compare_mfd_string_to_expected_string (mmux_libc_memfd_t mfd, mmux_asciizcp_t expected_string_asciiz)
{
  auto			buflen = mmux_usize_literal(1024);
  mmux_standard_char_t	bufptr[buflen.value];

  mmux_libc_memzero(bufptr, buflen);
  if (mmux_libc_memfd_read_buffer(mfd, bufptr, buflen)) {
    handle_error();
  }
  {
    mmux_ternary_comparison_result_t	cmpnum;

    if (mmux_libc_strcmp(&cmpnum, expected_string_asciiz, bufptr)) {
      handle_error();
    } else if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
      printf_message("correct formatted string: '%s'", bufptr);
    } else {
      printf_message("bad formatted string, expected '%s', got '%s'", expected_string_asciiz, bufptr);
      handle_error();
    }
  }
}


static void
test_mmux_libc_dprintf (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciizcp_t	str_asciiz = "the colour of water and quicksilver";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }

    {
      if (mmux_libc_dprintf(mfd, "%s", str_asciiz)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, str_asciiz);
      }
    }

    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static bool
doit_with_mmux_libc_vdprintf (mmux_libc_memfd_arg_t mfd, mmux_asciizcp_t template, ...)
{
  bool		rv;
  va_list	ap;

  va_start(ap, template);
  {
    rv = mmux_libc_vdprintf(mfd, template, ap);
  }
  va_end(ap);
  return rv;
}
static void
test_mmux_libc_vdprintf (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciizcp_t	str_asciiz = "the colour of water and quicksilver";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }

    {
      if (doit_with_mmux_libc_vdprintf(mfd, "%s", str_asciiz)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, str_asciiz);
      }
    }

    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_newline (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciizcp_t	str_asciiz = "\n";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }

    {
      if (mmux_libc_dprintf_newline(mfd)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, str_asciiz);
      }
    }

    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_strerror (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciizcp_t	str_asciiz;
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_strerror(&str_asciiz, MMUX_LIBC_EINVAL)) {
      handle_error();
    }
    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }

    {
      if (mmux_libc_dprintf_strerror(mfd, MMUX_LIBC_EINVAL)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, str_asciiz);
      }
    }

    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
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
    PROGNAME = "test-file-descriptors-printing";
  }

  if (true) {	test_mmux_libc_dprintf();		}
  if (true) {	test_mmux_libc_vdprintf();		}
  if (true) {	test_mmux_libc_dprintf_newline();	}
  if (true) {	test_mmux_libc_dprintf_strerror();	}

  mmux_libc_exit_success();
}

/* end of file */
