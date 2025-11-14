/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul 10, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	src_pathname_asciiz = "./test-copy-file-range.src-file.ext";
static mmux_asciizcp_t	dst_pathname_asciiz = "./test-copy-file-range.dst-file.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-file-descriptors-copy-file-range";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles_register(dst_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  {
    mmux_libc_fd_t	fd_src, fd_dst;

    /* Obtain the file descriptors. */
    {
      mmux_libc_fs_ptn_t	fs_ptn_src, fs_ptn_dst;

      /* Build the file system pathnames. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn_src, fs_ptn_factory, src_pathname_asciiz)) {
	  handle_error();
	}
	if (mmux_libc_make_file_system_pathname(fs_ptn_dst, fs_ptn_factory, dst_pathname_asciiz)) {
	  handle_error();
	}
      }

      /* Crete and open the source file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL | MMUX_LIBC_O_RDWR);
	auto	mode  = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR);

	if (mmux_libc_open(fd_src, fs_ptn_src, flags, mode)) {
	  handle_error();
	}
      }

      /* Create and open the destination file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL | MMUX_LIBC_O_RDWR);
	auto	mode  = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR);

	if (mmux_libc_open(fd_dst, fs_ptn_dst, flags, mode)) {
	  handle_error();
	}
      }

      /* Local cleanup. */
      {
	if (mmux_libc_unmake_file_system_pathname(fs_ptn_dst)) {
	  handle_error();
	}
	if (mmux_libc_unmake_file_system_pathname(fs_ptn_src)) {
	  handle_error();
	}
      }
    }

    /* Write data to the source file. */
    {
      mmux_usize_t	nbytes_done;
      //                          01234567890123456789012345678901234567890
      //                          0         1         2         3         4
      mmux_asciizcp_t	bufptr = "0123456789abcdefghilmnopqrstuvz0123456789";
      mmux_usize_t	buflen;

      mmux_libc_strlen(&buflen, bufptr);

      if (mmux_libc_write(&nbytes_done, fd_src, bufptr, buflen)) {
	handle_error();
      }
      if (mmux_ctype_not_equal(nbytes_done, buflen)) {
	handle_error();
      }
    }

    /* Copy  the  alpha  range of  data  "abc...uvz"  from  the  source file  to  the
       destination file. */
    {
      auto	src_position		= mmux_sint64_literal(10);
      auto	dst_position		= mmux_sint64_constant_zero();
      auto	number_of_bytes_to_copy = mmux_usize_literal(21);
      auto	flags			= mmux_sint_literal(0);
      mmux_usize_t	nbytes_done;

      if (mmux_libc_copy_file_range(&nbytes_done,
				    fd_src, &src_position,
				    fd_dst, &dst_position,
				    number_of_bytes_to_copy, flags)) {
	handle_error();
      }
    }

    /* Read data from the destination file, check that it is the expected data. */
    {
      auto		expected_nbytes_done	= mmux_usize_literal(21);
      mmux_asciizcp_t	expected_bufptr		= "abcdefghilmnopqrstuvz";

      mmux_usize_t		nbytes_done;
      auto			buflen = mmux_usize_literal(4096);
      mmux_standard_char_t	bufptr[buflen.value];
      auto			position = mmux_off_literal(0);

      mmux_libc_memzero(bufptr, buflen);

      if (mmux_libc_pread(&nbytes_done, fd_dst, bufptr, buflen, position)) {
	handle_error();
      }

      if (mmux_ctype_not_equal(expected_nbytes_done, nbytes_done)) {
	printf_error("wrong expected nbytes done: expected %lu got %lu\n",
		     expected_nbytes_done.value, nbytes_done.value);
	handle_error();
      }

      if (true) {
	printf_message("read data: \"%s\"\n", bufptr);
      }

      /* Compare the data read with the expected data. */
      {
	mmux_ternary_comparison_result_t	cmpnum;

	mmux_libc_memcmp(&cmpnum, expected_bufptr, bufptr, buflen);
	if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	  print_error("wrong bufptr");
	  handle_error();
	}
      }
    }

    /* Clean the files from the file  system before closing the file descriptors: the
       files should get cleaned even if closing the fds fails. */
    cleanfiles();

    if (mmux_libc_close(fd_src)) {
      handle_error();
    }
    if (mmux_libc_close(fd_dst)) {
      handle_error();
    }

  }
  mmux_libc_exit_success();
}

/* end of file */
