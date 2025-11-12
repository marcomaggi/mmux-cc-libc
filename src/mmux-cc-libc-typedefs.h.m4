/*
  Part of: MMUX CC Libcn
  Contents: public header file
  Date: Oct 12, 2025

  Abstract

	This header file is for type definitions that are common between the internal
	and  external API.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

  This program is free  software: you can redistribute it and/or  modify it under the
  terms  of  the  GNU General  Public  License  as  published  by the  Free  Software
  Foundation, either version 3 of the License, or (at your option) any later version.

  This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
  WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
  PARTICULAR PURPOSE.  See the GNU General Public License for more details.

  You should have received  a copy of the GNU General Public  License along with this
  program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef MMUX_CC_LIBC_TYPEDEFS_H
#define MMUX_CC_LIBC_TYPEDEFS_H 1


/** --------------------------------------------------------------------
 ** Interface specification.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_interface_specification_t {
  mmux_asciizcp_t	is_name;
  mmux_standard_uint_t	is_current;
  mmux_standard_uint_t	is_revision;
  mmux_standard_uint_t	is_age;
} mmux_libc_interface_specification_t;


/** --------------------------------------------------------------------
 ** Memory allocators.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_memory_allocator_t	mmux_libc_memory_allocator_t;
typedef mmux_libc_memory_allocator_t const *	mmux_libc_mall_t;

typedef struct mmux_libc_memory_allocator_value_t {
  mmux_pointer_t	data;
} mmux_libc_memory_allocator_value_t;

typedef bool mmux_libc_memory_allocator_malloc_fun_t
    (mmux_libc_memory_allocator_t const * self,
     mmux_pointer_t * result_p, mmux_usize_t len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

typedef bool mmux_libc_memory_allocator_calloc_fun_t
    (mmux_libc_memory_allocator_t const * self,
     mmux_pointer_t * result_p, mmux_usize_t item_num, mmux_usize_t item_len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

typedef bool mmux_libc_memory_allocator_realloc_fun_t
    (mmux_libc_memory_allocator_t const * self,
     mmux_pointer_t * result_p, mmux_usize_t newlen)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

typedef bool mmux_libc_memory_allocator_reallocarray_fun_t
    (mmux_libc_memory_allocator_t const * self,
     mmux_pointer_t * result_p, mmux_usize_t item_num, mmux_usize_t item_len)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

typedef bool mmux_libc_memory_allocator_free_fun_t
    (mmux_libc_memory_allocator_t const * self,
     mmux_pointer_t p)
  __attribute__((__nonnull__(1,2),__warn_unused_result__));

typedef bool mmux_libc_default_memory_allocator_malloc_and_copy_fun_t
    (mmux_libc_memory_allocator_t const * self,
     mmux_pointer_t * dstptr_p, mmux_pointer_t srcptr, mmux_usize_t srclen)
  __attribute__((__nonnull__(1,2,3),__warn_unused_result__));

typedef struct mmux_libc_memory_allocator_class_t {
  mmux_libc_memory_allocator_malloc_fun_t			* const	malloc;
  mmux_libc_memory_allocator_calloc_fun_t			* const	calloc;
  mmux_libc_memory_allocator_realloc_fun_t			* const	realloc;
  mmux_libc_memory_allocator_reallocarray_fun_t			* const	reallocarray;
  mmux_libc_memory_allocator_free_fun_t				* const	free;
  mmux_libc_default_memory_allocator_malloc_and_copy_fun_t	* const malloc_and_copy;
} mmux_libc_memory_allocator_class_t;

struct mmux_libc_memory_allocator_t {
  mmux_libc_memory_allocator_value_t		* const	value;
  mmux_libc_memory_allocator_class_t const	* const	class;
};


/** --------------------------------------------------------------------
 ** System.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_errno_t			{ mmux_sint_t;  } mmux_libc_errno_t;
typedef struct mmux_libc_process_exit_status_t		{ mmux_sint_t;  } mmux_libc_process_exit_status_t;
typedef struct mmux_libc_process_completion_status_t	{ mmux_sint_t;	} mmux_libc_process_completion_status_t;
typedef struct mmux_libc_process_completion_waiting_options_t {
  mmux_sint_t;
} mmux_libc_process_completion_waiting_options_t;
typedef struct mmux_libc_interprocess_signal_t		{ mmux_sint_t;	} mmux_libc_interprocess_signal_t;


/** --------------------------------------------------------------------
 ** Times and dates.
 ** ----------------------------------------------------------------- */

typedef mmux_libc_broken_down_time_t		mmux_libc_tm_t[1];
typedef mmux_libc_broken_down_time_t const *	mmux_libc_tm_arg_t;


/** --------------------------------------------------------------------
 ** Input/output.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_file_descriptor_identity_t {
  bool	is_for_input:		1;
  bool	is_for_ouput:		1;
  bool	is_directory:		1;
  bool	is_networking_socket:	1;
  bool	is_path_only:		1;
  bool	is_closed_for_reading:	1;
  bool	is_closed_for_writing:	1;
} mmux_libc_file_descriptor_identity_t;

typedef struct mmux_libc_file_descriptor_t {
  mmux_sint_t;
  mmux_libc_file_descriptor_identity_t	identity;
} mmux_libc_file_descriptor_t;
typedef mmux_libc_file_descriptor_t		mmux_libc_fd_t[1];
typedef mmux_libc_file_descriptor_t const *	mmux_libc_fd_arg_t;

typedef struct mmux_libc_file_descriptor_input_t {
  mmux_libc_file_descriptor_t;
} mmux_libc_file_descriptor_input_t;
typedef mmux_libc_file_descriptor_input_t		mmux_libc_infd_t[1];
typedef mmux_libc_file_descriptor_input_t const *	mmux_libc_infd_arg_t;

typedef struct mmux_libc_file_descriptor_output_t {
  mmux_libc_file_descriptor_t;
} mmux_libc_file_descriptor_output_t;
typedef mmux_libc_file_descriptor_output_t		mmux_libc_oufd_t[1];
typedef mmux_libc_file_descriptor_output_t const *	mmux_libc_oufd_arg_t;

typedef struct mmux_libc_memory_file_descriptor_t {
  mmux_libc_file_descriptor_t;
} mmux_libc_memory_file_descriptor_t;
typedef mmux_libc_memory_file_descriptor_t		mmux_libc_memfd_t[1];
typedef mmux_libc_memory_file_descriptor_t const *	mmux_libc_memfd_arg_t;

typedef struct mmux_libc_file_descriptor_directory_t {
  mmux_libc_file_descriptor_t;
} mmux_libc_file_descriptor_directory_t;

typedef mmux_libc_file_descriptor_directory_t		mmux_libc_dirfd_t[1];
typedef mmux_libc_file_descriptor_directory_t const *	mmux_libc_dirfd_arg_t;

typedef mmux_libc_file_descriptor_open_how_t		mmux_libc_open_how_t[1];
typedef mmux_libc_file_descriptor_open_how_t const *	mmux_libc_open_how_arg_t;

typedef struct mmux_libc_open_flags_t		{ mmux_sint_t;	 } mmux_libc_open_flags_t;
typedef struct mmux_libc_file_lock_type_t	{ mmux_sshort_t; } mmux_libc_file_lock_type_t;
typedef struct mmux_libc_seek_whence_t		{ mmux_sshort_t; } mmux_libc_seek_whence_t;
typedef struct mmux_libc_fcntl_command_t	{ mmux_sint_t;   } mmux_libc_fcntl_command_t;
typedef struct mmux_libc_scatter_gather_flags_t	{ mmux_sint_t;   } mmux_libc_scatter_gather_flags_t;


/** --------------------------------------------------------------------
 ** Networking.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_network_socket_t { mmux_libc_file_descriptor_t; } mmux_libc_network_socket_t;
typedef mmux_libc_network_socket_t	 		mmux_libc_sock_t[1];
typedef mmux_libc_network_socket_t const *		mmux_libc_sock_arg_t;

typedef struct mmux_host_byteorder_uint16_t    { mmux_uint16_t; } mmux_host_byteorder_uint16_t;
typedef struct mmux_network_byteorder_uint16_t { mmux_uint16_t; } mmux_network_byteorder_uint16_t;

typedef struct mmux_host_byteorder_uint32_t    { mmux_uint32_t; } mmux_host_byteorder_uint32_t;
typedef struct mmux_network_byteorder_uint32_t { mmux_uint32_t; } mmux_network_byteorder_uint32_t;

typedef struct mmux_libc_socket_address_family_t	{ mmux_sshort_t;  } mmux_libc_socket_address_family_t;
typedef struct mmux_libc_socket_protocol_family_t	{ mmux_sint_t;  } mmux_libc_socket_protocol_family_t;
typedef struct mmux_libc_socket_internet_protocol_t	{ mmux_sint_t;  } mmux_libc_socket_internet_protocol_t;
typedef struct mmux_libc_socket_communication_style_t	{ mmux_sint_t;  } mmux_libc_socket_communication_style_t;
typedef struct mmux_libc_socket_shutdown_mode_t		{ mmux_sint_t;  } mmux_libc_socket_shutdown_mode_t;
typedef struct mmux_libc_network_interface_index_t	{ mmux_uint_t;  } mmux_libc_network_interface_index_t;


/** --------------------------------------------------------------------
 ** File system.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_linkat_flags_t		{ mmux_sint_t;	} mmux_libc_linkat_flags_t;
typedef struct mmux_libc_unlinkat_flags_t	{ mmux_sint_t;	} mmux_libc_unlinkat_flags_t;
typedef struct mmux_libc_renameat2_flags_t	{ mmux_sint_t;	} mmux_libc_renameat2_flags_t;
typedef struct mmux_libc_fchownat_flags_t	{ mmux_sint_t;	} mmux_libc_fchownat_flags_t;
typedef struct mmux_libc_chownfd_flags_t	{ mmux_sint_t;	} mmux_libc_chownfd_flags_t;
typedef struct mmux_libc_fchmodat_flags_t	{ mmux_sint_t;	} mmux_libc_fchmodat_flags_t;
typedef struct mmux_libc_access_how_t		{ mmux_sint_t;	} mmux_libc_access_how_t;
typedef struct mmux_libc_faccessat_flags_t	{ mmux_sint_t;	} mmux_libc_faccessat_flags_t;
typedef struct mmux_libc_fstatat_flags_t	{ mmux_sint_t;	} mmux_libc_fstatat_flags_t;
typedef struct mmux_libc_statfd_flags_t		{ mmux_sint_t;	} mmux_libc_statfd_flags_t;
typedef struct mmux_libc_utimensat_flags_t	{ mmux_sint_t;	} mmux_libc_utimensat_flags_t;

typedef mmux_libc_file_system_stat_t		mmux_libc_stat_t[1];
typedef mmux_libc_file_system_stat_t const *	mmux_libc_stat_arg_t;

typedef mmux_libc_file_system_utimbuf_t		mmux_libc_utimbuf_t[1];
typedef mmux_libc_file_system_utimbuf_t const *	mmux_libc_utimbuf_arg_t;

typedef mmux_libc_file_system_dirstream_ptr_t		mmux_libc_dirstream_t[1];
typedef mmux_libc_file_system_dirstream_ptr_t const *	mmux_libc_dirstream_arg_t;

typedef struct mmux_libc_file_system_dirent_ptr_t {
  mmux_libc_file_system_dirent_t const *	value;
} mmux_libc_file_system_dirent_ptr_t;

typedef mmux_libc_file_system_dirent_ptr_t		mmux_libc_dirent_t[1];
typedef mmux_libc_file_system_dirent_ptr_t const *	mmux_libc_dirent_arg_t;

/* ------------------------------------------------------------------ */

/* Forward type declarations. */
typedef struct mmux_libc_file_system_pathname_class_t	mmux_libc_file_system_pathname_class_t;
typedef struct mmux_libc_file_system_pathname_t		mmux_libc_file_system_pathname_t;

typedef bool mmux_libc_file_system_pathname_unmake_fun_t (mmux_libc_file_system_pathname_t * fs_ptn);

struct mmux_libc_file_system_pathname_class_t {
  mmux_libc_interface_specification_t		const	* const	interface_specification;
  mmux_libc_file_system_pathname_unmake_fun_t		* const	unmake;
  mmux_libc_memory_allocator_t			const	* const memory_allocator;
};

/* NOTE Whatever changes we  make in the future: this data structure  must be at most
   two machine words, because we will always want  to be able to pass it by value, if
   there is the need.  So keep it small!  (Marco Maggi; Oct 20, 2025) */
struct mmux_libc_file_system_pathname_t {
  mmux_asciizcp_t					value;
  mmux_libc_file_system_pathname_class_t const *	class;
};

typedef mmux_libc_file_system_pathname_t		mmux_libc_fs_ptn_t[1];
typedef mmux_libc_file_system_pathname_t const *	mmux_libc_fs_ptn_arg_t;

/* ------------------------------------------------------------------ */

/* Forward type declarations. */
typedef struct mmux_libc_file_system_pathname_factory_class_t	mmux_libc_file_system_pathname_factory_class_t;
typedef struct mmux_libc_file_system_pathname_factory_t		mmux_libc_file_system_pathname_factory_t;
typedef struct mmux_libc_file_system_pathname_factory_copying_t mmux_libc_file_system_pathname_factory_copying_t;

typedef bool mmux_libc_file_system_pathname_factory_make_from_asciiz_fun_t
   (mmux_libc_fs_ptn_t ptn_result, mmux_libc_file_system_pathname_factory_t const * fs_ptn_factory,
    mmux_asciizcp_t src_ptn_asciiz);

typedef bool mmux_libc_file_system_pathname_factory_make_from_ascii_len_fun_t
   (mmux_libc_fs_ptn_t ptn_result, mmux_libc_file_system_pathname_factory_t const * fs_ptn_factory,
    mmux_asciicp_t src_ptn_ascii, mmux_usize_t src_ptn_len);

struct mmux_libc_file_system_pathname_factory_class_t {
  mmux_libc_file_system_pathname_factory_make_from_asciiz_fun_t *	make_from_asciiz;
  mmux_libc_file_system_pathname_factory_make_from_ascii_len_fun_t *	make_from_ascii_len;
};

/* NOTE Whatever changes we  make in the future: this data structure  must be at most
   two machine words, because we will always want  to be able to pass it by value, if
   there is the need.  So keep it small!  (Marco Maggi; Oct 20, 2025) */
struct mmux_libc_file_system_pathname_factory_t {
  mmux_libc_file_system_pathname_factory_class_t const *	class;
};

struct mmux_libc_file_system_pathname_factory_copying_t {
  mmux_libc_file_system_pathname_factory_t;
};

typedef mmux_libc_file_system_pathname_factory_t		mmux_libc_fs_ptn_factory_t[1];
typedef mmux_libc_file_system_pathname_factory_t const *	mmux_libc_fs_ptn_factory_arg_t;

typedef mmux_libc_file_system_pathname_factory_copying_t		mmux_libc_fs_ptn_factory_copying_t[1];
typedef mmux_libc_file_system_pathname_factory_copying_t const *	mmux_libc_fs_ptn_factory_copying_arg_t;

/* ------------------------------------------------------------------ */

typedef struct mmux_libc_file_system_pathname_extension_t {
  mmux_asciicp_t	ptr;
  mmux_usize_t		len;
} mmux_libc_file_system_pathname_extension_t;

typedef mmux_libc_file_system_pathname_extension_t		mmux_libc_fs_ptn_extension_t [1];
typedef mmux_libc_file_system_pathname_extension_t const *	mmux_libc_fs_ptn_extension_arg_t;

typedef struct mmux_libc_file_system_pathname_segment_t {
  mmux_asciicp_t	ptr;
  mmux_usize_t		len;
} mmux_libc_file_system_pathname_segment_t;

typedef mmux_libc_file_system_pathname_segment_t		mmux_libc_fs_ptn_segment_t[1];
typedef mmux_libc_file_system_pathname_segment_t const *	mmux_libc_fs_ptn_segment_arg_t;

/* ------------------------------------------------------------------ */

typedef struct mmux_libc_dirstream_position_t	{ mmux_slong_t;	} mmux_libc_dirstream_position_t;


/** --------------------------------------------------------------------
 ** Function type definitions.
 ** ----------------------------------------------------------------- */

typedef void mmux_libc_sighandler_t (mmux_standard_sint_t signum);


/** --------------------------------------------------------------------
 ** System configuration.
 ** ----------------------------------------------------------------- */

typedef struct mmux_libc_sysconf_parameter_t { mmux_sint_t; } mmux_libc_sysconf_parameter_t;
typedef struct mmux_libc_sysconf_string_parameter_t { mmux_sint_t; } mmux_libc_sysconf_string_parameter_t;
typedef struct mmux_libc_sysconf_pathname_parameter_t { mmux_sint_t; } mmux_libc_sysconf_pathname_parameter_t;
typedef struct mmux_libc_sysconf_resource_limit_t { mmux_sint_t; } mmux_libc_sysconf_resource_limit_t;


/** --------------------------------------------------------------------
 ** Done.
 ** ----------------------------------------------------------------- */

#endif /* MMUX_CC_LIBC_TYPEDEFS_H */

/* end of file */

