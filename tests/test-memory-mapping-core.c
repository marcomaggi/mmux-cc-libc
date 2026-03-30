/*
  Part of: MMUX CC Libc
  Contents: test for functions
  Date: Feb  3, 2026

  Abstract

	Test file for functions.

  Copyright (C) 2026 Marco Maggi <mrc.mgg@gmail.com>

  See the COPYING file.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "test-common.h"

static mmux_usize_t	page_size;
static mmux_asciizcp_t	pathname_asciiz = "./test-memory-mapping-core.ext";


static void
test_heap_map_unmap_pages (void)
{
  printf_string("%s: running test\n", __func__);
  {
    mmux_libc_mmap_upon_heap_factory_t	mapping_factory;
    mmux_libc_mmap_upon_heap_request_t	mapping_request;
    mmux_libc_mmap_heap_t		mapped_buffer;

    mmux_libc_mmap_upon_heap_factory_init(mapping_factory,
					  mmux_libc_memory_map_protection(MMUX_LIBC_PROT_READ | MMUX_LIBC_PROT_WRITE),
					  mmux_libc_memory_map_flags(MMUX_LIBC_MAP_PRIVATE));

    mmux_libc_mmap_upon_heap_request_init(mapping_request, NULL, page_size);

    /* Mapping. */
    {
      printf_message("mmap-ing");
      if (mmux_libc_mmap_upon_heap(mapped_buffer, mapping_request, mapping_factory)) {
	printf_error("mmap");
	handle_error();
      }
    }

    /* Write bytes in the heap. */
    {
      mmux_byte_t *	address = mapped_buffer->bufptr;

      for (mmux_standard_usize_t i=0; i<mapped_buffer->buflen.value; ++i) {
	address[i].value = 123;
      }
    }

    /* Read bytes from the heap. */
    {
      mmux_byte_t *	address = mapped_buffer->bufptr;

      for (mmux_standard_usize_t i=0; i<mapped_buffer->buflen.value; ++i) {
	if (123 != address[i].value) {
	  handle_error();
	}
      }
    }

    /* Unmapping. */
    {
      printf_message("munmap-ing");
      if (mmux_libc_munmap(mapped_buffer)) {
	printf_error("munmap");
	handle_error();
      }
    }
  }
  printf_string("%s: DONE.\n", __func__);
}

#if 0


static void
test_heap_map_remap_unmap_pages (void)
{
  printf_string("%s: running test\n", __func__);
  {
    auto  mapping_length_in_bytes1	= page_size;
    auto  mapping_length_in_bytes2	= mmux_ctype_mul(mmux_usize_constant_two(), page_size);
    auto  requested_protection	= mmux_libc_memory_map_protection(MMUX_LIBC_PROT_READ | MMUX_LIBC_PROT_WRITE);
    auto  configuration_flags	= mmux_libc_memory_map_flags(MMUX_LIBC_MAP_PRIVATE);

    /* When we  just want  to reallocate  a heap: in  general, we  have to  allow the
       kernel to move around both the upperlying memory allocation and the underlying
       memory allocation.

       When enlarging the allocation: if we do not allow the upperlying allocation to
       be moved: we may get an error  because there is not enough memory available at
       the current mapping_address.

       When shrkinging the allocation: there should be  no problem if we do not allow
       moving.

       When  moving  the  upperlying   allocation:  the  absolute  upperlying  memory
       mapping_addresses referening data on the heap will be invalidated. */
    auto  remapping_flags	= mmux_libc_memory_remap_flags(MMUX_LIBC_MREMAP_MAYMOVE);

    mmux_byte_t		*mapping_address1, *mapping_address2;

    /* Mapping. */
    {
      printf_message("mmap-ing");
      if (mmux_libc_mmap_heap(&mapping_address1, mapping_length_in_bytes1, requested_protection, configuration_flags)) {
	printf_error("mmap");
	handle_error();
      }
    }

    /* Write bytes in the heap. */
    {
      for (mmux_standard_usize_t i=0; i<mapping_length_in_bytes1.value; ++i) {
	mapping_address1->value = 123;
      }
    }

    /* Remapping. */
    {
      printf_message("mremap-ing");
      if (mmux_libc_mremap(&mapping_address2, mapping_length_in_bytes2,
			   mapping_address1,  mapping_length_in_bytes1,
			   remapping_flags)) {
	printf_error("mremap");
	handle_error();
      }
    }

    /* Read bytes from the heap. */
    {
      for (mmux_standard_usize_t i=0; i<mapping_length_in_bytes1.value; ++i) {
	if (123 != mapping_address2->value) {
	  handle_error();
	}
      }
    }

    /* Unmapping. */
    {
      printf_message("munmap-ing");
      if (mmux_libc_munmap(mapping_address2, mapping_length_in_bytes2)) {
	printf_error("munmap");
	handle_error();
      }
    }
  }
  printf_string("%s: DONE.\n", __func__);
}


static void
test_heap_map_unmap_seventeen (void)
{
  printf_string("%s: running test\n", __func__);
  {
    /* The mapping length  has no constraints: it  does not need to be  a multiple of
       page size. */
    auto  mapping_length_in_bytes = mmux_usize_literal(17);
    auto  requested_protection	= mmux_libc_memory_map_protection(MMUX_LIBC_PROT_READ | MMUX_LIBC_PROT_WRITE);
    auto  configuration_flags	= mmux_libc_memory_map_flags(MMUX_LIBC_MAP_PRIVATE);
    mmux_byte_t *	mapping_address;

    /* Mapping. */
    {
      printf_message("mmap-ing");
      if (mmux_libc_mmap_heap(&mapping_address, mapping_length_in_bytes, requested_protection, configuration_flags)) {
	printf_error("mmap");
	handle_error();
      }
    }

    /* Write bytes in the heap. */
    {
      for (mmux_standard_usize_t i=0; i<mapping_length_in_bytes.value; ++i) {
	mapping_address->value = 123;
      }
    }

    /* Read bytes from the heap. */
    {
      for (mmux_standard_usize_t i=0; i<mapping_length_in_bytes.value; ++i) {
	if (123 != mapping_address->value) {
	  handle_error();
	}
      }
    }

    /* Unmapping. */
    {
      printf_message("munmap-ing");
      if (mmux_libc_munmap(mapping_address, mapping_length_in_bytes)) {
	printf_error("munmap");
	handle_error();
      }
    }
  }
  printf_string("%s: DONE.\n", __func__);
}


static void
test_fd_map_read_write_unmap (void)
{
  printf_string("%s: running test\n", __func__);
  {
    mmux_asciizcp_t	data_bufptr = "the colour of water and quicksilver";
    mmux_usize_t	data_buflen;
    mmux_libc_fd_t	fd;

    /* Prepare the data to be written in the newly created file. */
    {
      mmux_libc_strlen_plus_nil(&data_buflen, data_bufptr);
    }

    /* Obtain the file descriptor. */
    {
      mmux_libc_fs_ptn_t	fs_ptn;

      /* Build the file system pathname. */
      {
	mmux_libc_fs_ptn_factory_t	fs_ptn_factory;

	mmux_libc_file_system_pathname_factory_static(fs_ptn_factory);
	if (mmux_libc_make_file_system_pathname(fs_ptn, fs_ptn_factory, pathname_asciiz)) {
	  handle_error();
	}
      }

      /* Open the file. */
      {
	auto	flags = mmux_libc_open_flags(MMUX_LIBC_O_CREAT | MMUX_LIBC_O_EXCL | MMUX_LIBC_O_RDWR);
	auto	mode  = mmux_libc_mode(MMUX_LIBC_S_IRUSR | MMUX_LIBC_S_IWUSR);

	printf_message("opening the file");
	if (mmux_libc_open(fd, fs_ptn, flags, mode)) {
	  printf_error("opening the file");
	  handle_error();
	}
      }

      /* Local cleanup */
      {
	mmux_libc_file_system_pathname_final(fs_ptn);
      }
    }

    /* Force the newly created file to have the size we want to store the data. */
    {
      auto	file_size = mmux_off(data_buflen.value);

      printf_message("ftruncate-ing to the right size");
      if (mmux_libc_ftruncate(fd, file_size)) {
	printf_error("ftruncate-ing to the right size");
	handle_error();
      }
    }

    /* Writing through memory mapping. */
    {
      auto  mapping_length_in_bytes		= page_size;
      auto  requested_protection	= mmux_libc_memory_map_protection(MMUX_LIBC_PROT_WRITE);
      auto  configuration_flags		= mmux_libc_memory_map_flags(MMUX_LIBC_MAP_SHARED);
      auto  file_offset			= mmux_off_constant_zero();
      mmux_pointer_t			mapping_address;

      /* Create the mapping for writing. */
      {
	printf_message("mmap-ing");
	if (mmux_libc_mmap(&mapping_address, NULL, mapping_length_in_bytes, requested_protection, configuration_flags,
			   fd, file_offset)) {
	  printf_error("mmap");
	  handle_error();
	}
      }

      /* Write the data. */
      {
	printf_message("memcpy-ing");
	if (mmux_libc_memcpy(mapping_address, data_bufptr, data_buflen)) {
	  printf_error("memcpy-ing");
	  handle_error();
	}
      }

      /* Unmake the mapping. */
      {
	printf_message("munmap-ing");
	if (mmux_libc_munmap(mapping_address, mapping_length_in_bytes)) {
	  printf_error("munmap");
	  handle_error();
	}
      }
    }

    /* Reading through memory mapping. */
    {
      mmux_usize_t	read_buflen = data_buflen;
      char		read_bufptr[read_buflen.value];

      {
	auto  mapping_length_in_bytes		= read_buflen;
	auto  requested_protection	= mmux_libc_memory_map_protection(MMUX_LIBC_PROT_READ);
	auto  configuration_flags	= mmux_libc_memory_map_flags(MMUX_LIBC_MAP_SHARED);
	auto  file_offset		= mmux_off_constant_zero();
	mmux_pointer_t	mapping_address;

	/* Create the mapping for reading. */
	{
	  printf_message("mmap-ing for reading");
	  if (mmux_libc_mmap(&mapping_address, NULL, mapping_length_in_bytes, requested_protection, configuration_flags,
			     fd, file_offset)) {
	    printf_error("mmap-ing for reading");
	    handle_error();
	  }
	}

	/* Read the data. */
	{
	  printf_message("memcpy-ing for reading %lu bytes", read_buflen.value);
	  if (mmux_libc_memcpy(read_bufptr, mapping_address, read_buflen)) {
	    printf_error("memcpy-ing");
	    handle_error();
	  }
	}

	/* Unmake the mapping. */
	{
	  printf_message("munmap-ing");
	  if (mmux_libc_munmap(mapping_address, mapping_length_in_bytes)) {
	    printf_error("munmap");
	    handle_error();
	  }
	}
      }

      /* Checking the read buffer. */
      {
	mmux_usize_t	expected_buflen;
	mmux_asciizcp_t	expected_bufptr = "the colour of water and quicksilver";

	mmux_libc_strlen_plus_nil(&expected_buflen, expected_bufptr);
	{
	  mmux_ternary_comparison_result_t	cmpnum;

	  mmux_libc_memcmp(&cmpnum, expected_bufptr, read_bufptr, expected_buflen);
	  if (mmux_ternary_comparison_result_is_equal(cmpnum)) {
	    printf_message("correct read_bufptr '%s'", read_bufptr);
	  } else {
	    printf_error("wrong read_bufptr '%s'", read_bufptr);
	    handle_error();
	  }
	}
      }
    }

    /* Final cleanup. */
    {
      if (mmux_libc_close(fd)) {
	handle_error();
      }
    }
  }
  printf_string("%s: DONE.\n", __func__);
}

#endif


/** --------------------------------------------------------------------
 ** Let's go.
 ** ----------------------------------------------------------------- */

int
main (mmux_standard_sint_t argc MMUX_CC_LIBC_UNUSED, char const * const argv[] MMUX_CC_LIBC_UNUSED)
{
  /* Initialisation. */
  {
    mmux_cc_libc_init();
    PROGNAME = "test-memory-mapping-core";
    cleanfiles_register(pathname_asciiz);
    cleanfiles();
    mmux_libc_atexit(cleanfiles);
  }

  if (mmux_libc_sysconf_page_size_ref(&page_size)) {
    printf_error("acquiring page size");
    handle_error();
  } else {
    printf_message("page size = %lu", page_size.value);
  }

  if (true) {	test_heap_map_unmap_pages();		}
#if 0
  if (true) {	test_heap_map_remap_unmap_pages();	}

  if (true) {	test_heap_map_unmap_seventeen();	}

  if (true) {	test_fd_map_read_write_unmap();		}
#endif

  mmux_libc_exit_success();
}

/* end of file */
