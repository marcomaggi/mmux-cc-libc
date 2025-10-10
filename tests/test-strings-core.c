/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct  9, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


static void
test_strings_strlen (void)
{
  printf_string("%s: ", __func__);

  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	bufptr = "the colour of water";
    mmux_usize_t	buflen;

    assert(false == mmux_libc_strlen(&buflen, bufptr));
    assert(19 == buflen.value);
  }

  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	bufptr = "the colour of water";
    mmux_usize_t	buflen;

    assert(false == mmux_libc_strlen_plus_nil(&buflen, bufptr));
    assert(20 == buflen.value);
  }

  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	bufptr = "the colour of water";
    auto		maxlen = mmux_usize_literal(10);
    typeof(maxlen)	buflen;

    assert(false == mmux_libc_strnlen(&buflen, bufptr, maxlen));
    assert(10 == buflen.value);
  }

  printf_string(" DONE\n");
}


static void
test_strings_copying (void)
{
  printf_string("%s: ", __func__);

  /* strcpy() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    char		dstptr[20];
    mmux_usize_t	buflen;

    assert(false == mmux_libc_strlen(&buflen, srcptr));

    assert(false == mmux_libc_strcpy(dstptr, srcptr));
    assert('\0' == dstptr[19]);
    assert(false == mmux_libc_dprintfer("strcpy: %s\n", dstptr));
  }

  /* strncpy() copy the full strings */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    auto		dstlen = mmux_usize_literal(64);
    char		dstptr[dstlen.value];

    assert(false == mmux_libc_strncpy(dstptr, srcptr, dstlen));
    assert('\0' == dstptr[19]);
    assert(false == mmux_libc_dprintfer("strncpy: %s\n", dstptr));
  }

  /* stpcpy() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    char		dstptr[20];
    mmux_asciizp_t	next_dstptr;

    assert(false == mmux_libc_stpcpy(&next_dstptr, dstptr, srcptr));
    assert('\0' == *next_dstptr);
    assert(false == mmux_libc_dprintfer("stpcpy: %s\n", dstptr));
  }

  /* stpncpy() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    auto		dstlen = mmux_usize_literal(64);
    char		dstptr[dstlen.value];
    mmux_asciizp_t	next_dstptr;

    assert(false == mmux_libc_stpncpy(&next_dstptr, dstptr, srcptr, dstlen));
    assert('\0' == *next_dstptr);
    assert(false == mmux_libc_dprintfer("stpncpy: %s\n", dstptr));
  }

  /* strdup() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    mmux_asciizcp_t	dstptr;

    if (mmux_libc_strdup(&dstptr, srcptr)) {
      handle_error();
    } else {
      assert(false == mmux_libc_dprintfer("strdup: %s\n", dstptr));
      mmux_libc_free((mmux_pointer_t)dstptr);
    }
  }

  /* strndup() */
  {
    //                            012345678901234567890
    //                                      1         2
    mmux_asciizcp_t	srcptr = "the colour of water";
    auto		dstlen = mmux_usize_literal(11);
    mmux_asciizp_t	dstptr;

    if (mmux_libc_strndup((mmux_asciizcp_t *)&dstptr, srcptr, dstlen)) {
      handle_error();
    } else {
      dstptr[10] = '\0';
      assert(false == mmux_libc_dprintfer("strndup: %s\n", dstptr));
      mmux_libc_free((mmux_pointer_t)dstptr);
    }
  }

  printf_string(" DONE\n");
}


static void
test_strings_concatenating (void)
{
  printf_string("%s: ", __func__);

  /* strcat() */
  {
    //                             01234567890123456789012345678901234567890
    //                                       1         2         3         4
    mmux_asciizcp_t	srcptr1 = "the colour of water";
    mmux_asciizcp_t	srcptr2 =                    " and quicksilver";
    auto		dstlen  = mmux_usize_literal(36);
    char		dstptr[dstlen.value];

    mmux_libc_memzero(dstptr, dstlen);

    assert(false == mmux_libc_strcat(dstptr, srcptr1));
    assert('\0' == dstptr[19]);
    assert(false == mmux_libc_dprintfer("strcat: dstptr1=%s\n", dstptr));

    assert(false == mmux_libc_strcat(dstptr, srcptr2));
    assert('\0' == dstptr[35]);
    assert(false == mmux_libc_dprintfer("strcat: dstptr2=%s\n", dstptr));
  }

  /* strncat() */
  {
    //                             01234567890123456789012345678901234567890
    //                                       1         2         3         4
    mmux_asciizcp_t	srcptr1 = "the colour of water ha! ha! ha!";
    mmux_asciizcp_t	srcptr2 =                    " and quicksilver ha!";
    //                                                012345678901234567890
    auto		dstlen  = mmux_usize_literal(36);
    char		dstptr[dstlen.value];

    auto		len1    = mmux_usize_literal(19);
    auto		len2    = mmux_usize_literal(16);

    mmux_libc_memzero(dstptr, dstlen);

    assert(false == mmux_libc_strncat(dstptr, srcptr1, len1));
    assert('\0' == dstptr[19]);
    assert(false == mmux_libc_dprintfer("strncat: dstptr1=%s\n", dstptr));

    assert(false == mmux_libc_strncat(dstptr, srcptr2, len2));
    assert('\0' == dstptr[35]);
    assert(false == mmux_libc_dprintfer("strncat: dstptr2=%s\n", dstptr));
  }

  printf_string(" DONE\n");
}


static void
test_strings_comparison (void)
{
  printf_string("%s: ", __func__);

  /* strcmp() */
  {
    {
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strcmp(&result, bufptr_one, bufptr_two));
      assert(mmux_ctype_is_positive(result));
    }
    {
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strcmp(&result, bufptr_two, bufptr_one));
      assert(mmux_ctype_is_negative(result));
    }
    {
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of water";
      mmux_sint_t	result;

      assert(false == mmux_libc_strcmp(&result, bufptr_two, bufptr_one));
      assert(mmux_ctype_is_zero(result));
    }
    printf_string(" strcmp");
  }

  /* strncmp() */
  {
    {
      //                              01234567890123456789
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      auto		buflen     = mmux_usize_literal(15);
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strncmp(&result, bufptr_one, bufptr_two, buflen));
      assert(mmux_ctype_is_positive(result));
    }
    {
      //                              01234567890123456789
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      auto		buflen     = mmux_usize_literal(15);
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strncmp(&result, bufptr_two, bufptr_one, buflen));
      assert(mmux_ctype_is_negative(result));
    }
    {
      //                              01234567890123456789
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      auto		buflen     = mmux_usize_literal(10);
      mmux_sint_t	result;

      assert(false == mmux_libc_strncmp(&result, bufptr_two, bufptr_one, buflen));
      assert(mmux_ctype_is_zero(result));
    }
    printf_string(" strncmp");
  }

  /* strncasecmp() */
  {
    {
      //                              01234567890123456789
      mmux_asciizcp_t	bufptr_one = "the COLOUR OF WAter";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      auto		buflen     = mmux_usize_literal(15);
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strncasecmp(&result, bufptr_one, bufptr_two, buflen));
      assert(mmux_ctype_is_positive(result));
    }
    {
      //                              01234567890123456789
      mmux_asciizcp_t	bufptr_one = "the COLOUR OF water";
      mmux_asciizcp_t	bufptr_two = "the colour of QUICKSILVER";
      auto		buflen     = mmux_usize_literal(15);
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strncasecmp(&result, bufptr_two, bufptr_one, buflen));
      assert(mmux_ctype_is_negative(result));
    }
    {
      //                              01234567890123456789
      mmux_asciizcp_t	bufptr_one = "the COLOUR OF WATER";
      mmux_asciizcp_t	bufptr_two = "the colour OF quicksilver";
      auto		buflen     = mmux_usize_literal(10);
      mmux_sint_t	result;

      assert(false == mmux_libc_strncasecmp(&result, bufptr_two, bufptr_one, buflen));
      assert(mmux_ctype_is_zero(result));
    }
    printf_string(" strncasecmp");
  }

  /* strverscmp() */
  {
    {
      mmux_asciizcp_t	bufptr_one = "1.2.3";
      mmux_asciizcp_t	bufptr_two = "1.2.8";
      mmux_sint_t	result;

      // '8' > '3' so bufptr_one < bufptr_two */
      assert(false == mmux_libc_strverscmp(&result, bufptr_one, bufptr_two));
      assert(mmux_ctype_is_negative(result));
    }
    {
      mmux_asciizcp_t	bufptr_one = "1.2.3";
      mmux_asciizcp_t	bufptr_two = "1.2.8";
      mmux_sint_t	result;

      // '8' > '3' so bufptr_one < bufptr_two */
      assert(false == mmux_libc_strverscmp(&result, bufptr_two, bufptr_one));
      assert(mmux_ctype_is_positive(result));
    }
    {
      mmux_asciizcp_t	bufptr_one = "1.2.3";
      mmux_asciizcp_t	bufptr_two = "1.2.3";
      mmux_sint_t	result;

      assert(false == mmux_libc_strverscmp(&result, bufptr_two, bufptr_one));
      assert(mmux_ctype_is_zero(result));
    }
    printf_string(" strverscmp");
  }

  printf_string(" DONE\n");
}


static void
test_strings_collation (void)
{
  printf_string("%s: ", __func__);

  /* strcoll() */
  {
    {
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strcoll(&result, bufptr_one, bufptr_two));
      assert(mmux_ctype_is_positive(result));
    }
    {
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of quicksilver";
      mmux_sint_t	result;

      // 'w' > 'q' so bufptr_one > bufptr_two */
      assert(false == mmux_libc_strcoll(&result, bufptr_two, bufptr_one));
      assert(mmux_ctype_is_negative(result));
    }
    {
      mmux_asciizcp_t	bufptr_one = "the colour of water";
      mmux_asciizcp_t	bufptr_two = "the colour of water";
      mmux_sint_t	result;

      assert(false == mmux_libc_strcoll(&result, bufptr_two, bufptr_one));
      assert(mmux_ctype_is_zero(result));
    }
    printf_string(" strcoll");
  }

  printf_string(" DONE\n");
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
    PROGNAME = "test-strings-core";
  }

  if (1) {	test_strings_strlen();		}
  if (1) {	test_strings_copying();		}
  if (1) {	test_strings_concatenating();	}
  if (1) {	test_strings_comparison();	}
  if (1) {	test_strings_collation();	}

  mmux_libc_exit_success();
}

/* end of file */
