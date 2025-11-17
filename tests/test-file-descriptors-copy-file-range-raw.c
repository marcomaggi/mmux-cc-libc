/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Nov 14, 2025

  Abstract

	Test file for functions.

  Copyright (C) 2025 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <test-common.h>

static mmux_asciizcp_t	src_pathname_asciiz = "./test-copy-file-range-raw.src-file.ext";
static mmux_asciizcp_t	dst_pathname_asciiz = "./test-copy-file-range-raw.dst-file.ext";


static void
obtain_the_file_descriptors (mmux_libc_fd_t fd_src, mmux_libc_fd_t fd_dst)
{
  printf_message("opening the file descriptors");

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


static void
fill_source_file_with_data (mmux_libc_fd_t fd)
/* Fill the source file with 3 buffers of  4096 octets each, then write a last buffer
   of 1024 octets. */
{
  printf_message("writing data to the source file");

  auto const	buflen = mmux_usize_literal(4096);
  mmux_octet_t	bufptr[buflen.value];

  /* Fill the buffer with data. */
  {
    for (mmux_standard_usize_t i=0; i<buflen.value; ++i) {
      bufptr[i] = mmux_octet(i % 255);
    }
  }

  /* Write the buffer to the file multiple times. */
  {
    for (mmux_standard_uint_t i=0; i<3; ++i) {
      mmux_usize_t	nbytes_done;

      if (mmux_libc_write(&nbytes_done, fd, bufptr, buflen)) {
	printf_error("filling buffer with data");
	handle_error();
      }
      if (mmux_ctype_not_equal(nbytes_done, buflen)) {
	printf_error("not all the buffer data was written while filling buffer with data");
	handle_error();
      }
    }
  }

  /* Write a piece of the buffer to the file. */
  {
    auto		some_buflen = mmux_usize_literal(1024);
    mmux_usize_t	nbytes_done;

    if (mmux_libc_write(&nbytes_done, fd, bufptr, some_buflen)) {
      printf_error("filling buffer with data");
      handle_error();
    }
    if (mmux_ctype_not_equal(nbytes_done, some_buflen)) {
      printf_error("not all the buffer data was written while filling buffer with data");
      handle_error();
    }
  }
}


static void
read_and_validate_data_from_the_destination_file (mmux_libc_fd_t fd)
{
  printf_message("reading data from the destination file");

  /* Read buffers of data. */
  {
    for (mmux_standard_uint_t i=0; i<3; ++i) {
      printf_message("reading buffer %u", i);

      auto const	buflen = mmux_usize_literal(4096);
      mmux_octet_t	bufptr[buflen.value];
      mmux_usize_t	nbytes_done;

      if (mmux_libc_read(&nbytes_done, fd, bufptr, buflen)) {
	printf_error("reading data to the buffer");
	handle_error();
      }
      if (mmux_ctype_not_equal(nbytes_done, buflen)) {
	printf_error("not all the buffer data was read while reading data, expected %lu, got %lu",
		     buflen.value, nbytes_done.value);
	handle_error();
      }

      /* Validate the data in the buffer. */
      {
	for (mmux_standard_usize_t j=0; j<buflen.value; ++j) {
	  auto	expected_octet = mmux_octet(j % 255);
	  if (mmux_ctype_not_equal(bufptr[j], expected_octet)) {
	    printf_error("wrong octet read from file, expected %u, got %u", bufptr[j].value, expected_octet.value);
	    handle_error();
	  }
	}
	printf_message("correct validation of buffer %u", i);
      }
    }
  }

  /* Read the last piece of buffer. */
  {
    printf_message("reading trailing");

    auto const		buflen = mmux_usize_literal(1024);
    mmux_octet_t	bufptr[buflen.value];
    mmux_usize_t	nbytes_done;

    if (mmux_libc_read(&nbytes_done, fd, bufptr, buflen)) {
      printf_error("reading data to the buffer");
      handle_error();
    }
    if (mmux_ctype_not_equal(nbytes_done, buflen)) {
      printf_error("not all the buffer data was read while reading data");
      handle_error();
    }

    /* Validate the data in the buffer. */
    {
      for (mmux_standard_usize_t j=0; j<buflen.value; ++j) {
	auto	expected_octet = mmux_octet(j % 255);
	if (mmux_ctype_not_equal(bufptr[j], expected_octet)) {
	  printf_error("wrong octet read from file, expected %u, got %u", bufptr[j].value, expected_octet.value);
	  handle_error();
	}
      }
      printf_message("correct validation of trailing buffer");
    }
  }
}


static void
seek_file_to_beginning (mmux_libc_fd_t fd)
{
  auto	offset = mmux_off_constant_zero();

  printf_message("seeking to the beginning");
  if (mmux_libc_lseek(fd, &offset, MMUX_LIBC_SEEK_SET)) {
    printf_error("seeking to the beginning");
    handle_error();
  }
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
    PROGNAME = "test-file-descriptors-copy-file-range-raw";
    cleanfiles_register(src_pathname_asciiz);
    cleanfiles_register(dst_pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  {
    mmux_libc_fd_t	fd_src, fd_dst;

    obtain_the_file_descriptors(fd_src, fd_dst);
    fill_source_file_with_data(fd_src);
    seek_file_to_beginning(fd_src);

    /* Copy  the  alpha  range of  data  "abc...uvz"  from  the  source file  to  the
       destination file. */
    {
      auto const	read_buflen = mmux_usize_literal(4096);
      mmux_octet_t	read_bufptr[read_buflen.value];
      mmux_usize_t	nbytes_read;

      /* Loop reading while the number of bytes read is positive. */
      do {
	if (mmux_libc_read(&nbytes_read, fd_src, read_bufptr, read_buflen)) {
	  handle_error();
	}

	if (mmux_ctype_is_positive(nbytes_read)) {
	  mmux_octet_t *	write_bufptr    = read_bufptr;
	  auto			write_buflen    = nbytes_read;
	  mmux_usize_t		nbytes_written;

	  /* Loop writing until we have written all the bytes from the buffer. */
	  do {
	    if (mmux_libc_write(&nbytes_written, fd_dst, write_bufptr, write_buflen)) {
	      handle_error();
	    }

	    if (mmux_ctype_less(nbytes_written, write_buflen)) {
	      write_bufptr += nbytes_written.value;
	      mmux_ctype_sub_from_variable(write_buflen, nbytes_written);
	    }
	  } while (mmux_ctype_less(nbytes_written, write_buflen));
	}
      } while (mmux_ctype_is_positive(nbytes_read));
    }

    seek_file_to_beginning(fd_dst);
    read_and_validate_data_from_the_destination_file(fd_dst);

    /* Final cleanup. */
    {
      if (mmux_libc_close(fd_src)) {
	handle_error();
      }
      if (mmux_libc_close(fd_dst)) {
	handle_error();
      }
    }
  }
  mmux_libc_exit_success();
}

/* end of file */
