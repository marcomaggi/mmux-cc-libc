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
void
test_set_output_formats (bool verbose)
{
  if (verbose) { printf_message("%s: setting output format for flonumfl\n", __func__); }
  assert(false == mmux_flonumfl_set_output_format("%.6f", __func__));
  if (verbose) { printf_message("%s: setting output format for flonumdb\n", __func__); }
  assert(false == mmux_flonumdb_set_output_format("%.6f", __func__));
#ifdef MMUX_CC_TYPES_HAS_FLONUMLDB
  if (verbose) { printf_message("%s: setting output format for flonumldb\n", __func__); }
  assert(false == mmux_flonumldb_set_output_format("%.6f", __func__));
#endif

#ifdef MMUX_CC_TYPES_HAS_FLONUMF32
  if (verbose) { printf_message("%s: setting output format for flonumf32\n", __func__); }
  assert(false == mmux_flonumf32_set_output_format("%.6f", __func__));
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF64
  if (verbose) { printf_message("%s: setting output format for flonumf64\n", __func__); }
  assert(false == mmux_flonumf64_set_output_format("%.6f", __func__));
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF128
  if (verbose) { printf_message("%s: setting output format for flonumf128\n", __func__); }
  assert(false == mmux_flonumf128_set_output_format("%.6f", __func__));
#endif

#ifdef MMUX_CC_TYPES_HAS_FLONUMF32X
  if (verbose) { printf_message("%s: setting output format for flonumf32x\n", __func__); }
  assert(false == mmux_flonumf32x_set_output_format("%.6f", __func__));
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF64X
  if (verbose) { printf_message("%s: setting output format for flonumf64x\n", __func__); }
  assert(false == mmux_flonumf64x_set_output_format("%.6f", __func__));
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF128X
  if (verbose) { printf_message("%s: setting output format for flonumf128x\n", __func__); }
  assert(false == mmux_flonumf128x_set_output_format("%.6f", __func__));
#endif

#ifdef MMUX_CC_TYPES_HAS_FLONUMD32
  if (verbose) { printf_message("%s: setting output format for flonumd32\n", __func__); }
  assert(false == mmux_flonumd32_set_output_format("%.6f", __func__));
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMD64
  if (verbose) { printf_message("%s: setting output format for flonumd64\n", __func__); }
  assert(false == mmux_flonumd64_set_output_format("%.6f", __func__));
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMD128
  if (verbose) { printf_message("%s: setting output format for flonumd128\n", __func__); }
  assert(false == mmux_flonumd128_set_output_format("%.6f", __func__));
#endif
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


static void
test_mmux_libc_dprintf_strftime (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "2025";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      mmux_libc_tm_t 	broken_down_time;

      mmux_libc_tm_reset(broken_down_time);
      mmux_libc_tm_year_set(broken_down_time, mmux_sint(2025 - 1900));

      if (mmux_libc_dprintf_strftime(mfd, "%Y", broken_down_time)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_pointer (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "0xab78";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_pointer_literal(0xAB78);

      if (mmux_libc_dprintf_pointer(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_schar (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_schar_literal(-123);

      if (mmux_libc_dprintf_schar(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}

static void
test_mmux_libc_dprintf_uchar (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uchar_literal(123);

      if (mmux_libc_dprintf_uchar(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_char (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "{";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_char_literal('{');

      if (mmux_libc_dprintf_char(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_sshort (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sshort_literal(-123);

      if (mmux_libc_dprintf_sshort(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_ushort (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_ushort_literal(123);

      if (mmux_libc_dprintf_ushort(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_sint (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sint_literal(-123);

      if (mmux_libc_dprintf_sint(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_uint (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uint_literal(123);

      if (mmux_libc_dprintf_uint(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_slong (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_slong_literal(-123);

      if (mmux_libc_dprintf_slong(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_ulong (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_ulong_literal(123);

      if (mmux_libc_dprintf_ulong(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


#ifdef MMUX_CC_TYPES_HAS_SLLONG
static void
test_mmux_libc_dprintf_sllong (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sllong_literal(-123);

      if (mmux_libc_dprintf_sllong(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_ULLONG
static void
test_mmux_libc_dprintf_ullong (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_ullong_literal(123);

      if (mmux_libc_dprintf_ullong(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


static void
test_mmux_libc_dprintf_sint8 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sint8_literal(-123);

      if (mmux_libc_dprintf_sint8(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_uint8 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uint8_literal(123);

      if (mmux_libc_dprintf_uint8(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_sint16 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sint16_literal(-123);

      if (mmux_libc_dprintf_sint16(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_uint16 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uint16_literal(123);

      if (mmux_libc_dprintf_uint16(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_sint32 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sint32_literal(-123);

      if (mmux_libc_dprintf_sint32(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_uint32 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uint32_literal(123);

      if (mmux_libc_dprintf_uint32(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_sint64 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sint64_literal(-123);

      if (mmux_libc_dprintf_sint64(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_uint64 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uint64_literal(123);

      if (mmux_libc_dprintf_uint64(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_flonumfl (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumfl_literal(1.23000);

      if (mmux_libc_dprintf_flonumfl(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_flonumdb (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumdb_literal(1.23000);

      if (mmux_libc_dprintf_flonumdb(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


#ifdef MMUX_CC_TYPES_HAS_FLONUMLDB
static void
test_mmux_libc_dprintf_flonumldb (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumldb_literal(1.23000);

      if (mmux_libc_dprintf_flonumldb(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMF32
static void
test_mmux_libc_dprintf_flonumf32 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumf32_literal(1.23000);

      if (mmux_libc_dprintf_flonumf32(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMF64
static void
test_mmux_libc_dprintf_flonumf64 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumf64_literal(1.23000);

      if (mmux_libc_dprintf_flonumf64(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMF128
static void
test_mmux_libc_dprintf_flonumf128 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumf128_literal(1.23000);

      if (mmux_libc_dprintf_flonumf128(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMF32X
static void
test_mmux_libc_dprintf_flonumf32x (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumf32x_literal(1.23000);

      if (mmux_libc_dprintf_flonumf32x(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMF64X
static void
test_mmux_libc_dprintf_flonumf64x (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumf64x_literal(1.23000);

      if (mmux_libc_dprintf_flonumf64x(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMF128X
static void
test_mmux_libc_dprintf_flonumf128x (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumf128x_literal(1.23000);

      if (mmux_libc_dprintf_flonumf128x(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMD32
static void
test_mmux_libc_dprintf_flonumd32 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumd32_literal(1.23000);

      if (mmux_libc_dprintf_flonumd32(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMD64
static void
test_mmux_libc_dprintf_flonumd64 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumd64_literal(1.23000);

      if (mmux_libc_dprintf_flonumd64(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMD128
static void
test_mmux_libc_dprintf_flonumd128 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "1.230000";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumd128_literal(1.23000);

      if (mmux_libc_dprintf_flonumd128(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


static void
test_mmux_libc_dprintf_flonumcfl (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcfl_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcfl(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_flonumcdb (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcdb_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcdb(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


#ifdef MMUX_CC_TYPES_HAS_FLONUMCLDB
static void
test_mmux_libc_dprintf_flonumcldb (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcldb_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcldb(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCF32
static void
test_mmux_libc_dprintf_flonumcf32 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcf32_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcf32(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCF64
static void
test_mmux_libc_dprintf_flonumcf64 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcf64_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcf64(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCF128
static void
test_mmux_libc_dprintf_flonumcf128 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcf128_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcf128(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCF32X
static void
test_mmux_libc_dprintf_flonumcf32x (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcf32x_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcf32x(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCF64X
static void
test_mmux_libc_dprintf_flonumcf64x (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcf64x_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcf64x(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCF128X
static void
test_mmux_libc_dprintf_flonumcf128x (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcf128x_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcf128x(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCD32
static void
test_mmux_libc_dprintf_flonumcd32 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcd32_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcd32(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCD64
static void
test_mmux_libc_dprintf_flonumcd64 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcd64_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcd64(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


#ifdef MMUX_CC_TYPES_HAS_FLONUMCD128
static void
test_mmux_libc_dprintf_flonumcd128 (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "(1.230000)+i*(4.560000)";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_flonumcd128_rectangular_literal(1.23,4.56);

      if (mmux_libc_dprintf_flonumcd128(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}
#endif


static void
test_mmux_libc_dprintf_byte (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_byte_literal(-123);

      if (mmux_libc_dprintf_byte(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_octet (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_octet_literal(123);

      if (mmux_libc_dprintf_octet(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_ssize (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_ssize_literal(-123);

      if (mmux_libc_dprintf_ssize(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_usize (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_usize_literal(123);

      if (mmux_libc_dprintf_usize(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_sintmax (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sintmax_literal(-123);

      if (mmux_libc_dprintf_sintmax(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_uintmax (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uintmax_literal(123);

      if (mmux_libc_dprintf_uintmax(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_sintptr (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_sintptr_literal(-123);

      if (mmux_libc_dprintf_sintptr(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_uintptr (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_uintptr_literal(123);

      if (mmux_libc_dprintf_uintptr(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_ptrdiff (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_ptrdiff_literal(-123);

      if (mmux_libc_dprintf_ptrdiff(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_off (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_off_literal(-123);

      if (mmux_libc_dprintf_off(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_wchar (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_wchar_literal(-123);

      if (mmux_libc_dprintf_wchar(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_wint (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_wint_literal(123);

      if (mmux_libc_dprintf_wint(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_time (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_time_literal(-123);

      if (mmux_libc_dprintf_time(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_clock (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "-123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_clock_literal(-123);

      if (mmux_libc_dprintf_clock(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_mode (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_mode_literal(123);

      if (mmux_libc_dprintf_libc_mode(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_pid (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_pid_literal(123);

      if (mmux_libc_dprintf_libc_pid(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_uid (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_uid_literal(123);

      if (mmux_libc_dprintf_libc_uid(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_gid (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_gid_literal(123);

      if (mmux_libc_dprintf_libc_gid(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_socklen (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_socklen_literal(123);

      if (mmux_libc_dprintf_libc_socklen(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_rlim (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_rlim_literal(123);

      if (mmux_libc_dprintf_libc_rlim(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_ino (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_ino_literal(123);

      if (mmux_libc_dprintf_libc_ino(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_dev (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_dev_literal(123);

      if (mmux_libc_dprintf_libc_dev(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_nlink (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_nlink_literal(123);

      if (mmux_libc_dprintf_libc_nlink(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_libc_blkcnt (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      auto	value = mmux_libc_blkcnt_literal(123);

      if (mmux_libc_dprintf_libc_blkcnt(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_fd (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      mmux_libc_fd_t	value;

      mmux_libc_make_fd(value, 123);
      if (mmux_libc_dprintf_fd(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_fs_ptn (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "/path/to/file.ext";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      mmux_libc_fs_ptn_t	value;

      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(value, fs_ptn_factory, expected_str_asciiz)) {
	  handle_error();
	}
      }
      if (mmux_libc_dprintf_fs_ptn(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
      mmux_libc_unmake_file_system_pathname(value);
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_fs_ptn_extension (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = ".ext";
    mmux_asciicp_t	ptn_asciiz = "/path/to/file.ext";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      mmux_libc_fs_ptn_t		fs_ptn;
      mmux_libc_fs_ptn_extension_t	value;

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
	if (mmux_libc_make_file_system_pathname_extension(value, fs_ptn)) {
	  handle_error();
	}
      }

      if (mmux_libc_dprintf_fs_ptn_extension(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_fs_ptn_segment (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "file.ext";
    mmux_asciicp_t	ptn_asciiz = "/path/to/file.ext";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      mmux_libc_fs_ptn_t		fs_ptn;
      mmux_libc_fs_ptn_segment_t	value;

      /* Build the file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      /* Build the file system pathname segment. */
      {
	if (mmux_libc_file_system_pathname_segment_find_last(value, fs_ptn)) {
	  handle_error();
	}
      }

      if (mmux_libc_dprintf_fs_ptn_segment(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }

      /* Local cleanup. */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_process_completion_status (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "123";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      mmux_libc_process_completion_status_t	value;

      mmux_libc_make_process_completion_status(&value, 123);
      if (mmux_libc_dprintf_process_completion_status(mfd, value)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
      }
    }
    if (mmux_libc_close(mfd)) {
      handle_error();
    }
  }
  printf_message("%s: DONE", __func__);
}


static void
test_mmux_libc_dprintf_interprocess_signal (void)
{
  printf_message("%s: running test", __func__);
  {
    mmux_asciicp_t	expected_str_asciiz = "SIGUSR1";
    mmux_libc_memfd_t	mfd;

    if (mmux_libc_make_memfd(mfd)) {
      handle_error();
    }
    {
      if (mmux_libc_dprintf_interprocess_signal(mfd, MMUX_LIBC_SIGUSR1)) {
	handle_error();
      } else {
	compare_mfd_string_to_expected_string(mfd, expected_str_asciiz);
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
    test_set_output_formats(false);
  }

  if (true) {	test_mmux_libc_dprintf();			}
  if (true) {	test_mmux_libc_vdprintf();			}
  if (true) {	test_mmux_libc_dprintf_newline();		}
  if (true) {	test_mmux_libc_dprintf_strerror();		}
  if (true) {	test_mmux_libc_dprintf_strftime();		}
  if (true) {	test_mmux_libc_dprintf_pointer();		}
  if (true) {	test_mmux_libc_dprintf_schar();			}
  if (true) {	test_mmux_libc_dprintf_uchar();			}
  if (true) {	test_mmux_libc_dprintf_char();			}
  if (true) {	test_mmux_libc_dprintf_sshort();		}
  if (true) {	test_mmux_libc_dprintf_ushort();		}
  if (true) {	test_mmux_libc_dprintf_sint();			}
  if (true) {	test_mmux_libc_dprintf_uint();			}
  if (true) {	test_mmux_libc_dprintf_slong();			}
  if (true) {	test_mmux_libc_dprintf_ulong();			}
#ifdef MMUX_CC_TYPES_HAS_SLLONG
  if (true) {	test_mmux_libc_dprintf_sllong();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_ULLONG
  if (true) {	test_mmux_libc_dprintf_ullong();		}
#endif
  if (true) {	test_mmux_libc_dprintf_sint8();			}
  if (true) {	test_mmux_libc_dprintf_uint8();			}
  if (true) {	test_mmux_libc_dprintf_sint16();		}
  if (true) {	test_mmux_libc_dprintf_uint16();		}
  if (true) {	test_mmux_libc_dprintf_sint32();		}
  if (true) {	test_mmux_libc_dprintf_uint32();		}
  if (true) {	test_mmux_libc_dprintf_sint64();		}
  if (true) {	test_mmux_libc_dprintf_uint64();		}
  if (true) {	test_mmux_libc_dprintf_flonumfl();		}
  if (true) {	test_mmux_libc_dprintf_flonumdb();		}
#ifdef MMUX_CC_TYPES_HAS_FLONUMLDB
  if (true) {	test_mmux_libc_dprintf_flonumldb();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF32
  if (true) {	test_mmux_libc_dprintf_flonumf32();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF64
  if (true) {	test_mmux_libc_dprintf_flonumf64();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF128
  if (true) {	test_mmux_libc_dprintf_flonumf128();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF32X
  if (true) {	test_mmux_libc_dprintf_flonumf32x();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF64X
  if (true) {	test_mmux_libc_dprintf_flonumf64x();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMF128X
  if (true) {	test_mmux_libc_dprintf_flonumf128x();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMD32
  if (true) {	test_mmux_libc_dprintf_flonumd32();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMD64
  if (true) {	test_mmux_libc_dprintf_flonumd64();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMD128
  if (true) {	test_mmux_libc_dprintf_flonumd128();		}
#endif
  if (true) {	test_mmux_libc_dprintf_flonumcfl();		}
  if (true) {	test_mmux_libc_dprintf_flonumcdb();		}
#ifdef MMUX_CC_TYPES_HAS_FLONUMCLDB
  if (true) {	test_mmux_libc_dprintf_flonumcldb();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCF32
  if (true) {	test_mmux_libc_dprintf_flonumcf32();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCF64
  if (true) {	test_mmux_libc_dprintf_flonumcf64();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCF128
  if (true) {	test_mmux_libc_dprintf_flonumcf128();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCF32X
  if (true) {	test_mmux_libc_dprintf_flonumcf32x();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCF64X
  if (true) {	test_mmux_libc_dprintf_flonumcf64x();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCF128X
  if (true) {	test_mmux_libc_dprintf_flonumcf128x();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCD32
  if (true) {	test_mmux_libc_dprintf_flonumcd32();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCD64
  if (true) {	test_mmux_libc_dprintf_flonumcd64();		}
#endif
#ifdef MMUX_CC_TYPES_HAS_FLONUMCD128
  if (true) {	test_mmux_libc_dprintf_flonumcd128();		}
#endif
  if (true) {	test_mmux_libc_dprintf_byte();			}
  if (true) {	test_mmux_libc_dprintf_octet();			}
  if (true) {	test_mmux_libc_dprintf_usize();			}
  if (true) {	test_mmux_libc_dprintf_ssize();			}
  if (true) {	test_mmux_libc_dprintf_sintmax();		}
  if (true) {	test_mmux_libc_dprintf_uintmax();		}
  if (true) {	test_mmux_libc_dprintf_sintptr();		}
  if (true) {	test_mmux_libc_dprintf_uintptr();		}
  if (true) {	test_mmux_libc_dprintf_ptrdiff();		}
  if (true) {	test_mmux_libc_dprintf_off();			}
  if (true) {	test_mmux_libc_dprintf_wchar();			}
  if (true) {	test_mmux_libc_dprintf_wint();			}
  if (true) {	test_mmux_libc_dprintf_time();			}
  if (true) {	test_mmux_libc_dprintf_clock();			}
  if (true) {	test_mmux_libc_dprintf_libc_mode();		}
  if (true) {	test_mmux_libc_dprintf_libc_pid();		}
  if (true) {	test_mmux_libc_dprintf_libc_uid();		}
  if (true) {	test_mmux_libc_dprintf_libc_gid();		}
  if (true) {	test_mmux_libc_dprintf_libc_socklen();		}
  if (true) {	test_mmux_libc_dprintf_libc_rlim();		}
  if (true) {	test_mmux_libc_dprintf_libc_ino();		}
  if (true) {	test_mmux_libc_dprintf_libc_dev();		}
  if (true) {	test_mmux_libc_dprintf_libc_nlink();		}
  if (true) {	test_mmux_libc_dprintf_libc_blkcnt();		}
  if (true) {	test_mmux_libc_dprintf_fd();			}
  if (true) {	test_mmux_libc_dprintf_fs_ptn();		}
  if (true) {	test_mmux_libc_dprintf_fs_ptn_extension();	}
  if (true) {	test_mmux_libc_dprintf_fs_ptn_segment();	}
  if (true) {	test_mmux_libc_dprintf_process_completion_status();	}
  if (true) {	test_mmux_libc_dprintf_interprocess_signal();		}

  mmux_libc_exit_success();
}

/* end of file */
