/*
  Part of: MMUX CC Libc
  Contents: test for version functions
  Date: Oct  8, 2025

  Abstract

	Test file for version functions.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"


/** --------------------------------------------------------------------
 ** Global data.
 ** ----------------------------------------------------------------- */

static mmux_libc_interface_specification_t const it = {
  .is_name	= "My Spiffy Project",
  .is_current	= 11,
  .is_revision	= 23,
  .is_age	= 7,
};

typedef struct subit_t {
  mmux_libc_interface_specification_t;
  double	val;
} subit_t;

static subit_t const subit = {
  .is_name	= "My Spiffy Project",
  .is_current	= 11,
  .is_revision	= 23,
  .is_age	= 7,
  .val		= 0.123,
};


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-strerror";
  }


  {
    bool	result;
    mmux_libc_interface_specification_is_compatible(&result, &it, mmux_uint(11));
    assert(true == result);
  }

  {
    bool	result;
    mmux_libc_interface_specification_is_compatible(&result, &it, mmux_uint(8));
    assert(true == result);
  }

  {
    bool	result;
    mmux_libc_interface_specification_is_compatible(&result, &it, mmux_uint(2));
    assert(false == result);
  }

/* ------------------------------------------------------------------ */

  {
    bool	result;
    mmux_libc_interface_specification_is_compatible(&result, &subit, mmux_uint(11));
    assert(true == result);
  }
  {
    bool	result;
    mmux_libc_interface_specification_is_compatible(&result, &subit, mmux_uint(2));
    assert(false == result);
  }

  mmux_libc_exit_success();
}

/* end of file */
