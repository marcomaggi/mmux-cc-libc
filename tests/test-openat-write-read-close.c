/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Jul  1, 2025

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

static mmux_asciizcp_t	pathname_asciiz = "./test-openat-write-read-close.file.ext";


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (int argc MMUX_CC_LIBC_UNUSED, char const *const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-openat-write-read-close";
    cleanfiles_register(pathname_asciiz);
    cleanfiles();
  }

  mmux_libc_file_system_pathname_t	ptn;
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_descriptor_t		fd;

  mmux_sint_t     flags    = MMUX_LIBC_O_RDWR | MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL;
  mmux_mode_t     mode     = MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR;

  cleanfiles();

  if (mmux_libc_make_file_system_pathname(&ptn, pathname_asciiz)) {
    handle_error();
  };

  mmux_libc_at_fdcwd(&dirfd);

  if (mmux_libc_openat(&fd, dirfd, ptn, flags, mode)) {
    handle_error();
  }

  /* writing */
  {
    mmux_usize_t	nbytes_done;
    mmux_asciizcp_t	bufptr = "ciao";
    mmux_usize_t	buflen;

    mmux_libc_strlen(&buflen, bufptr);

    if (mmux_libc_write(&nbytes_done, fd, bufptr, buflen)) {
      handle_error();
    }
  }

  /* seeking */
  {
    mmux_off_t		offset = 0;
    mmux_sint_t		whence = MMUX_LIBC_SEEK_SET;

    if (mmux_libc_lseek(fd, &offset, whence)) {
      handle_error();
    }
  }

  /* reading */
  {
    mmux_usize_t	expected_nbytes_done	= 4;
    mmux_asciizcp_t	expected_bufptr		= "ciao";

    mmux_usize_t	nbytes_done;
    mmux_usize_t	buflen = 4096;
    mmux_uint8_t	bufptr[buflen];

    if (mmux_libc_read(&nbytes_done, fd, bufptr, buflen)) {
      handle_error();
    }

    if (expected_nbytes_done != nbytes_done) {
      mmux_libc_dprintfer("wrong expected nbytes done: expected %lu got %lu\n", expected_nbytes_done, nbytes_done);
      handle_error();
    }

    {
      mmux_sint_t	result;

      mmux_libc_memcmp(&result, expected_bufptr, bufptr, buflen);
      if (0 == result) {
	print_error("wrong bufptr");
	handle_error();
      }
    }
  }

  if (mmux_libc_close(fd)) {
    handle_error();
  }

  cleanfiles();
  mmux_libc_exit_success();
}

/* end of file */
