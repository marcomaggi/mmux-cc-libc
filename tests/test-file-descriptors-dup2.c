/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 10, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	ptn_asciiz = "./test-file-descriptors-dup2.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-descriptors-dup2";
    cleanfiles_register(ptn_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  {
    mmux_libc_fd_t	fd1, fd2;

    /* Obtain the file descriptor. */
    {
      mmux_libc_fs_ptn_t	fs_ptn;

      /* Build the file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, ptn_asciiz)) {
	  handle_error();
	}
      }

      /* Open the file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_RDWR | MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL);
	auto	mode  = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR);

	printf_message("opening the file");
	if (mmux_libc_open(fd1, fs_ptn, flags, mode)) {
	  printf_error("opening the file");
	  handle_error();
	}
      }

      /* Duplicate the file descriptor. */
      {
	mmux_libc_make_fd(fd2, 11);

	printf_message("dup2-ing");
	if (mmux_libc_dup2(fd2, fd1)) {
	  printf_error("dup2-ing");
	  handle_error();
	}
      }

      /* Local cleanup */
      {
	mmux_libc_unmake_file_system_pathname(fs_ptn);
      }
    }

    /* Writing. */
    {
      mmux_asciizcp_t	bufptr = "the colour of water and quicksilver";
      mmux_usize_t	buflen;
      mmux_usize_t	nbytes_done;

      mmux_libc_strlen(&buflen, bufptr);

      printf_message("write-ing");
      if (mmux_libc_write(&nbytes_done, fd1, bufptr, buflen)) {
	printf_error("write-ing");
	handle_error();
      }
    }

    /* Closing the first file descriptor. */
    {
      if (mmux_libc_close(fd1)) {
	handle_error();
      }
    }

    /* Seeking to the beginning of the file, using the second file descriptor. */
    {
      auto	offset = mmux_off_constant_zero();
      auto	whence = MMUX_LIBC_SEEK_SET;

      printf_message("lseek-ing to the beginning of the file");
      if (mmux_libc_lseek(fd2, &offset, whence)) {
	printf_error("lseek-ing to the beginning of the file");
	handle_error();
      }
    }

    /* Reading. */
    {
      mmux_usize_t		nbytes_done;
      auto			buflen = mmux_usize_literal(4096);
      mmux_standard_uint8_t	bufptr[buflen.value];

      printf_message("read-ing");
      if (mmux_libc_read(&nbytes_done, fd2, bufptr, buflen)) {
	printf_error("read-ing");
	handle_error();
      }

      bufptr[nbytes_done.value] = '\0';

      /* Checking the read buffer. */
      {
	mmux_usize_t	expected_nbytes_done;
	mmux_asciizcp_t	expected_bufptr = "the colour of water and quicksilver";

	mmux_libc_strlen(&expected_nbytes_done, expected_bufptr);

	if (mmux_ctype_not_equal(expected_nbytes_done, nbytes_done)) {
	  MMUX_LIBC_IGNORE_RETVAL(mmux_libc_dprintfer("wrong expected nbytes done: expected %lu got %lu\n",
						      expected_nbytes_done.value, nbytes_done.value));
	  handle_error();
	} else {
	  mmux_ternary_comparison_result_t	cmpnum;

	  mmux_libc_memcmp(&cmpnum, expected_bufptr, bufptr, nbytes_done);
	  if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	    printf_message("correct bufptr '%s'", bufptr);
	  } else {
	    printf_error("wrong bufptr '%s'", bufptr);
	    handle_error();
	  }
	}
      }
    }

    /* Close the second file descriptor. */
    {
      if (mmux_libc_close(fd2)) {
	handle_error();
      }
    }
  }

  mmux_libc_exit_success();
}

/* end of file */
