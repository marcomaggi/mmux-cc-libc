/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 11, 2025

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
test_characters_classes (void)
{
  printf_string("%s: ", __func__);

  /* islower() */
  {
    {
      auto	it = mmux_char_literal('a');
      bool	result;

      assert(false == mmux_libc_islower(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('A');
      bool	result;

      assert(false == mmux_libc_islower(&result, it));
      assert(false == result);
    }
    printf_string(" islower");
  }

/* ------------------------------------------------------------------ */

  /* isupper() */
  {
    {
      auto	it = mmux_char_literal('a');
      bool	result;

      assert(false == mmux_libc_isupper(&result, it));
      assert(false == result);
    }
    {
      auto	it = mmux_char_literal('A');
      bool	result;

      assert(false == mmux_libc_isupper(&result, it));
      assert(true  == result);
    }
    printf_string(" isupper");
  }

/* ------------------------------------------------------------------ */

  /* isalpha() */
  {
    {
      auto	it = mmux_char_literal('A');
      bool	result;

      assert(false == mmux_libc_isalpha(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('7');
      bool	result;

      assert(false == mmux_libc_isalpha(&result, it));
      assert(false == result);
    }
    printf_string(" isalpha");
  }

/* ------------------------------------------------------------------ */

  /* isdigit() */
  {
    {
      auto	it = mmux_char_literal('7');
      bool	result;

      assert(false == mmux_libc_isdigit(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('B');
      bool	result;

      assert(false == mmux_libc_isdigit(&result, it));
      assert(false == result);
    }
    printf_string(" isdigit");
  }

/* ------------------------------------------------------------------ */

  /* isalnum() */
  {
    {
      auto	it = mmux_char_literal('7');
      bool	result;

      assert(false == mmux_libc_isalnum(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('B');
      bool	result;

      assert(false == mmux_libc_isalnum(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('{');
      bool	result;

      assert(false == mmux_libc_isalnum(&result, it));
      assert(false == result);
    }
    printf_string(" isalnum");
  }

/* ------------------------------------------------------------------ */

  /* isxdigit() */
  {
    {
      auto	it = mmux_char_literal('7');
      bool	result;

      assert(false == mmux_libc_isxdigit(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('B');
      bool	result;

      assert(false == mmux_libc_isxdigit(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('{');
      bool	result;

      assert(false == mmux_libc_isxdigit(&result, it));
      assert(false == result);
    }
    printf_string(" isxdigit");
  }

/* ------------------------------------------------------------------ */

  /* ispunct() */
  {
    {
      auto	it = mmux_char_literal(',');
      bool	result;

      assert(false == mmux_libc_ispunct(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('.');
      bool	result;

      assert(false == mmux_libc_ispunct(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('B');
      bool	result;

      assert(false == mmux_libc_ispunct(&result, it));
      assert(false == result);
    }
    printf_string(" ispunct");
  }

/* ------------------------------------------------------------------ */

  /* isspace() */
  {
    {
      auto	it = mmux_char_literal(' ');
      bool	result;

      assert(false == mmux_libc_isspace(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('\n');
      bool	result;

      assert(false == mmux_libc_isspace(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('X');
      bool	result;

      assert(false == mmux_libc_isspace(&result, it));
      assert(false == result);
    }
    printf_string(" isspace");
  }

/* ------------------------------------------------------------------ */

  /* isblank() */
  {
    {
      auto	it = mmux_char_literal(' ');
      bool	result;

      assert(false == mmux_libc_isblank(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('\t');
      bool	result;

      assert(false == mmux_libc_isblank(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('\n');
      bool	result;

      assert(false == mmux_libc_isblank(&result, it));
      assert(false == result);
    }
    printf_string(" isblank");
  }

/* ------------------------------------------------------------------ */

  /* isgraph() */
  {
    {
      auto	it = mmux_char_literal('A');
      bool	result;

      assert(false == mmux_libc_isgraph(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('d');
      bool	result;

      assert(false == mmux_libc_isgraph(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal(' ');
      bool	result;

      assert(false == mmux_libc_isgraph(&result, it));
      assert(false == result);
    }
    printf_string(" isgraph");
  }

/* ------------------------------------------------------------------ */

  /* isprint() */
  {
    {
      auto	it = mmux_char_literal('0');
      bool	result;

      assert(false == mmux_libc_isprint(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('B');
      bool	result;

      assert(false == mmux_libc_isprint(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('\0');
      bool	result;

      assert(false == mmux_libc_isprint(&result, it));
      assert(false == result);
    }
    printf_string(" isprint");
  }

/* ------------------------------------------------------------------ */

  /* iscntrl() */
  {
    {
      auto	it = mmux_char_literal('\0');
      bool	result;

      assert(false == mmux_libc_iscntrl(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('\1');
      bool	result;

      assert(false == mmux_libc_iscntrl(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('A');
      bool	result;

      assert(false == mmux_libc_iscntrl(&result, it));
      assert(false == result);
    }
    printf_string(" iscntrl");
  }

/* ------------------------------------------------------------------ */

  /* isascii() */
  {
    {
      auto	it = mmux_char_literal('7');
      bool	result;

      assert(false == mmux_libc_isascii(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('B');
      bool	result;

      assert(false == mmux_libc_isascii(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal('{');
      bool	result;

      assert(false == mmux_libc_isascii(&result, it));
      assert(true  == result);
    }
    {
      auto	it = mmux_char_literal(255);
      bool	result;

      assert(false == mmux_libc_isascii(&result, it));
      assert(false == result);
    }

    printf_string(" isascii");
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
    PROGNAME = "test-characters-core";
  }

  if (1) {	test_characters_classes();		}

  mmux_libc_exit_success();
}

/* end of file */
