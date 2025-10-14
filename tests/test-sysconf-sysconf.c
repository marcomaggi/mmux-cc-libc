/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Oct 14, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"

static mmux_asciizcp_t	pathname_asciiz = "./test-sysconf-pathconf.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-sysconf-sysconf";
    cleanfiles_register(pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  /* mmux_libc_sysconf() */
  {
    mmux_slong_t	result;

    if (mmux_libc_sysconf(&result, MMUX_LIBC__SC_PAGESIZE)) {
      handle_error();
    }
    {
      mmux_libc_fd_t	fd;

      assert(false == mmux_libc_stder(fd));
      assert(false == mmux_libc_dprintf(fd, "%s: page size is: '", __func__));
      assert(false == mmux_libc_dprintf_slong(fd, result));
      assert(false == mmux_libc_dprintf(fd, "'\n"));
    }
  }

  /* mmux_libc_confstr() */
  {
    auto          parameter = MMUX_LIBC__CS_PATH;
    mmux_usize_t  required_nbytes;

    if (mmux_libc_confstr_size(&required_nbytes, parameter)) {
      handle_error();
    } else {
      char	value[required_nbytes.value];

      if (mmux_libc_confstr(value, required_nbytes, parameter)) {
	handle_error();
      } else {
	assert(false == mmux_libc_dprintfer("%s: CS_PATH is: '%s'\n", __func__, value));
      }
    }
  }

  /* Create the data file. */
  {
    printf_message("create the data file");
    if (test_create_data_file(pathname_asciiz)) {
      handle_error();
    }
  }

  /* mmux_libc_pathconf() */
  {
    mmux_libc_ptn_t	ptn;
    mmux_slong_t	result;

    if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, pathname_asciiz)) {
      handle_error();
    } else if (mmux_libc_pathconf(&result, ptn, MMUX_LIBC__PC_LINK_MAX)) {
      handle_error();
    } else {
      mmux_libc_fd_t	fd;

      assert(false == mmux_libc_stder(fd));
      assert(false == mmux_libc_dprintf(fd, "%s: pc_link_max is: '", __func__));
      assert(false == mmux_libc_dprintf_slong(fd, result));
      assert(false == mmux_libc_dprintf(fd, "'\n"));
    }
  }

  /* mmux_libc_fpathconf() */
  if (true) {
    mmux_libc_ptn_t	ptn;
    mmux_libc_fd_t	fd;
    mmux_slong_t	result;

    if (mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_static_class, &ptn, pathname_asciiz)) {
      handle_error();
    }

    /* Open the file. */
    {
      auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR);
      auto	mode  = mmux_libc_mode_constant_zero();

      if (mmux_libc_open(fd, ptn, flags, mode)) {
	handle_error();
      }
    }

    if (mmux_libc_fpathconf(&result, fd, MMUX_LIBC__PC_LINK_MAX)) {
      handle_error();
    }

    {
      mmux_libc_fd_t	er;

      assert(false == mmux_libc_stder(er));
      assert(false == mmux_libc_dprintf(er, "%s: pc_link_max is: '", __func__));
      assert(false == mmux_libc_dprintf_slong(er, result));
      assert(false == mmux_libc_dprintf(er, "'\n"));
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
