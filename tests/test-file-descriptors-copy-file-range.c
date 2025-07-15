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

#include <mmux-cc-libc.h>
#include <test-common.h>

static mmux_asciizcp_t		src_pathname_asciiz = "./test-copy-file-range.src-file.ext";
static mmux_asciizcp_t		dst_pathname_asciiz = "./test-copy-file-range.dst-file.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-copy-file-range";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles_register(dst_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  mmux_libc_file_descriptor_t		src_fd,  dst_fd;

  {
    mmux_libc_file_system_pathname_t	src_ptn, dst_ptn;
    mmux_sint_t				flags = MMUX_LIBC_O_RDWR | MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL;
    mmux_mode_t				mode  = MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR;

    /* Open the source file. */
    {
      if (mmux_libc_make_file_system_pathname(&src_ptn, src_pathname_asciiz)) {
	handle_error();
      }

      if (mmux_libc_open(&src_fd, src_ptn, flags, mode)) {
	handle_error();
      }
    }

    /* Open the destination file. */
    {
      if (mmux_libc_make_file_system_pathname(&dst_ptn, dst_pathname_asciiz)) {
	handle_error();
      }

      if (mmux_libc_open(&dst_fd, dst_ptn, flags, mode)) {
	handle_error();
      }
    }
  }

  /* Write data to the source file. */
  {
    mmux_usize_t	nbytes_done;
    //                            01234567890123456789012345678901234567890
    //                            0         1         2         3         4
    mmux_asciizcp_t	bufptr = "0123456789abcdefghilmnopqrstuvz0123456789";
    mmux_usize_t	buflen;

    mmux_libc_strlen(&buflen, bufptr);

    if (mmux_libc_write(&nbytes_done, src_fd, bufptr, buflen)) {
      handle_error();
    }
    if (nbytes_done != buflen) {
      handle_error();
    }
  }

  /* Copy the alpha range of data from the source file to the destination file. */
  {
    mmux_usize_t	nbytes_done;
    mmux_sint64_t	src_position = 10;
    mmux_sint64_t	dst_position = 0;
    mmux_usize_t	number_of_bytes_to_copy = 21;
    mmux_sint_t		flags = 0;

    if (mmux_libc_copy_file_range(&nbytes_done,
				  src_fd, &src_position,
				  dst_fd, &dst_position,
				  number_of_bytes_to_copy, flags)) {
      handle_error();
    }
  }

  /* Read data from the destination file. */
  {
    mmux_usize_t	expected_nbytes_done	= 21;
    mmux_asciizcp_t	expected_bufptr		= "abcdefghilmnopqrstuvz";

    mmux_usize_t	nbytes_done;
    mmux_usize_t	buflen = 4096;
    mmux_uint8_t	bufptr[buflen];
    mmux_off_t		position = 0;

    mmux_libc_memzero(bufptr, buflen);

    if (mmux_libc_pread(&nbytes_done, dst_fd, bufptr, buflen, position)) {
      handle_error();
    }

    if (expected_nbytes_done != nbytes_done) {
      printf_error("wrong expected nbytes done: expected %lu got %lu\n", expected_nbytes_done, nbytes_done);
      handle_error();
    }

    if (1) {
      printf_message("read data: \"%s\"\n", bufptr);
    }

    /* Compare the data read with the expected data. */
    {
      mmux_sint_t	result;

      mmux_libc_memcmp(&result, expected_bufptr, bufptr, buflen);
      if (0 == result) {
	print_error("wrong bufptr");
	handle_error();
      }
    }
  }

  /* Clean the  files from the file  system before closing the  file descriptors: the
     files should get cleaned even if closing the fds fails. */
  cleanfiles();

  if (mmux_libc_close(src_fd)) {
    handle_error();
  }
  if (mmux_libc_close(dst_fd)) {
    handle_error();
  }

  mmux_libc_exit_success();
}

/* end of file */
