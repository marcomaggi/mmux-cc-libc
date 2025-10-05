/*
  Part of: MMUX CC Libc
  Contents: time and dates
  Date: Dec 12, 2024

  Abstract

	This module implements the time and dates API.

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


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <mmux-cc-libc-internals.h>


/** --------------------------------------------------------------------
 ** Struct timeval.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(timeval,	tv_sec,		time)
DEFINE_STRUCT_SETTER_GETTER(timeval,	tv_usec,	slong)

bool
mmux_libc_timeval_set (mmux_libc_timeval_t * timeval_p, mmux_time_t seconds, mmux_slong_t microseconds)
{
  timeval_p->tv_sec  = seconds.value;
  timeval_p->tv_usec = microseconds.value;
  return false;
}
bool
mmux_libc_timeval_dump (mmux_libc_fd_arg_t fd, mmux_libc_timeval_t const * const timeval_p, char const * struct_name)
{
  int	rv;

  if (NULL == struct_name) {
    struct_name = "struct timeval";
  }

  {
    rv = dprintf(fd->value, "%s = %p\n", struct_name, (mmux_pointer_t)timeval_p);
    if (0 > rv) { return true; }
  }

  {
    mmux_time_t		field_value;
    mmux_usize_t	required_nbytes;

    mmux_libc_tv_sec_ref(&field_value, timeval_p);
    if (mmux_time_sprint_size(&required_nbytes, field_value)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_time_sprint(str, required_nbytes, field_value);
      rv = dprintf(fd->value, "%s->tv_sec = %s [seconds]\n", struct_name, str);
      if (0 > rv) { return true; }
    }
  }

  {
    mmux_slong_t	field_value;
    mmux_usize_t	required_nbytes;

    mmux_libc_tv_usec_ref(&field_value, timeval_p);
    if (mmux_slong_sprint_size(&required_nbytes, field_value)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_slong_sprint(str, required_nbytes, field_value);
      rv = dprintf(fd->value, "%s->tv_usec = %s [microseconds]\n", struct_name, str);
      if (0 > rv) { return true; }
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Struct timespec.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_ts_sec_set (mmux_libc_timespec_t * const P, mmux_time_t value)
{
  P->tv_sec = value.value;
  return false;
}
bool
mmux_libc_ts_sec_ref (mmux_time_t * result_p, mmux_libc_timespec_t const * const P)
{
  *result_p = mmux_time(P->tv_sec);
  return false;
}
bool
mmux_libc_ts_nsec_set (mmux_libc_timespec_t * const P, mmux_slong_t value)
{
  P->tv_nsec = value.value;
  return false;
}
bool
mmux_libc_ts_nsec_ref (mmux_slong_t * result_p, mmux_libc_timespec_t const * const P)
{
  *result_p = mmux_slong(P->tv_nsec);
  return false;
}
bool
mmux_libc_timespec_set (mmux_libc_timespec_t * timespec_p, mmux_time_t seconds, mmux_slong_t nanoseconds)
{
  timespec_p->tv_sec  = seconds.value;
  timespec_p->tv_nsec = nanoseconds.value;
  return false;
}
bool
mmux_libc_timespec_dump (mmux_libc_fd_arg_t fd, mmux_libc_timespec_t const * const timespec_p, char const * struct_name)
{
  int	rv;

  if (NULL == struct_name) {
    struct_name = "struct timespec";
  }

  {
    rv = dprintf(fd->value, "%s = %p\n", struct_name, (mmux_pointer_t)timespec_p);
    if (0 > rv) { return true; }
  }

  {
    mmux_time_t		field_value;
    mmux_usize_t	required_nbytes;

    mmux_libc_ts_sec_ref(&field_value, timespec_p);
    if (mmux_time_sprint_size(&required_nbytes, field_value)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_time_sprint(str, required_nbytes, field_value);
      rv = dprintf(fd->value, "%s->ts_sec = %s [seconds]\n", struct_name, str);
      if (0 > rv) { return true; }
    }
  }

  {
    mmux_slong_t	field_value;
    mmux_usize_t	required_nbytes;

    mmux_libc_ts_nsec_ref(&field_value, timespec_p);
    if (mmux_slong_sprint_size(&required_nbytes, field_value)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_slong_sprint(str, required_nbytes, field_value);
      rv = dprintf(fd->value, "%s->ts_nsec = %s [nanoseconds]\n", struct_name, str);
      if (0 > rv) { return true; }
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Struct tm.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(tm,	tm_sec,		sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_min,		sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_hour,	sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_mday,	sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_mon,		sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_year,	sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_wday,	sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_yday,	sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_isdst,	sint)
DEFINE_STRUCT_SETTER_GETTER(tm,	tm_gmtoff,	slong)
bool
mmux_libc_tm_zone_set (mmux_libc_tm_t * const P, mmux_asciizcp_t value)
{
  P->tm_zone = value;
  return false;
}
bool
mmux_libc_tm_zone_ref (mmux_asciizcp_t * result_p, mmux_libc_tm_t const * const P)
{
  *result_p = P->tm_zone;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_tm_dump (mmux_libc_fd_arg_t fd, mmux_libc_tm_t const * tm_p, char const * struct_name)
{
  int	rv;

  if (NULL == struct_name) {
    struct_name = "struct tm";
  }

  /* Dump the pointer itself. */
  {
    rv = dprintf(fd->value, "%s = %p\n", struct_name, (mmux_pointer_t)tm_p);
    if (0 > rv) { return true; }
  }

m4_define([[[DEFINE_TM_FIELD_DUMPER]]],[[[
  {
    mmux_$2_t		field_value;
    mmux_usize_t	required_nbytes;

    mmux_libc_$1_ref(&field_value, tm_p);
    if (mmux_$2_sprint_size(&required_nbytes, field_value)) {
      return true;
    } else {
      char	str[required_nbytes.value];

      mmux_$2_sprint(str, required_nbytes, field_value);
      rv = dprintf(fd->value, "%s->$1 = %s\n", struct_name, str);
      if (0 > rv) { return true; }
    }
  }
]]])
DEFINE_TM_FIELD_DUMPER(tm_sec,		sint)
DEFINE_TM_FIELD_DUMPER(tm_min,		sint)
DEFINE_TM_FIELD_DUMPER(tm_hour,		sint)
DEFINE_TM_FIELD_DUMPER(tm_mday,		sint)
DEFINE_TM_FIELD_DUMPER(tm_mon,		sint)
DEFINE_TM_FIELD_DUMPER(tm_year,		sint)
DEFINE_TM_FIELD_DUMPER(tm_wday,		sint)
DEFINE_TM_FIELD_DUMPER(tm_yday,		sint)
DEFINE_TM_FIELD_DUMPER(tm_isdst,	sint)
DEFINE_TM_FIELD_DUMPER(tm_gmtoff,	slong)

  {
    rv = dprintf(fd->value, "%s->tm_zone = %s\n", struct_name, tm_p->tm_zone);
    if (0 > rv) { return true; }
  }

  return false;
}

bool
mmux_libc_tm_reset (mmux_libc_tm_t * tm_p)
{
  tm_p->tm_sec    = 0;
  tm_p->tm_min    = 0;
  tm_p->tm_hour   = 0;
  tm_p->tm_mday   = 1;
  tm_p->tm_mon    = 0;
  tm_p->tm_year   = 0;
  tm_p->tm_wday   = 0;
  tm_p->tm_yday   = 0;
  tm_p->tm_isdst  = 0;
  tm_p->tm_gmtoff = 0;
  tm_p->tm_zone   = NULL;
  return false;
}


/** --------------------------------------------------------------------
 ** Time handling.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_time (mmux_time_t * result_p)
{
  *result_p = mmux_time(time(NULL));
  return false;
}
bool
mmux_libc_localtime (mmux_libc_tm_t * * result_p, mmux_time_t T)
{
  /* A call to "localtime()" returns a  pointer to a "struct tm" statically allocated
     by the C library. */
  *result_p = localtime(&T.value);
  return false;
}
bool
mmux_libc_localtime_r (mmux_libc_tm_t * result_p, mmux_time_t T)
{
  localtime_r(&T.value, result_p);
  return false;
}
bool
mmux_libc_gmtime (mmux_libc_tm_t * * result_p, mmux_time_t T)
{
  *result_p = gmtime(&T.value);
  return false;
}
bool
mmux_libc_gmtime_r (mmux_libc_tm_t * result_p, mmux_time_t T)
{
  gmtime_r(&T.value, result_p);
  return false;
}
bool
mmux_libc_mktime (mmux_time_t * result_p, mmux_libc_tm_t * tm_p)
{
  *result_p = mmux_time(mktime(tm_p));
  return false;
}
bool
mmux_libc_timegm (mmux_time_t * result_p, mmux_libc_tm_t * tm_p)
{
  *result_p = mmux_time(timegm(tm_p));
  return false;
}
bool
mmux_libc_asctime (mmux_asciizcp_t * result_p, mmux_libc_tm_t * tm_p)
{
  *result_p = asctime(tm_p);
  return false;
}
bool
mmux_libc_asctime_r (mmux_asciizp_t result_p, mmux_libc_tm_t * tm_p)
{
  mmux_asciizcp_t	rv = asctime_r(tm_p, result_p);

  if (NULL == rv) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_ctime (mmux_asciizcpp_t result_p, mmux_time_t T)
{
  *result_p = ctime(&T.value);
  return false;
}
bool
mmux_libc_ctime_r (mmux_asciizp_t result_p, mmux_time_t T)
{
  mmux_asciizcp_t	rv = ctime_r(&T.value, result_p);

  if (NULL == rv) {
    return true;
  } else {
    return false;
  }
}
bool
mmux_libc_strftime_required_nbytes_including_nil (mmux_usize_t * required_nbytes_including_nil_p,
						  mmux_asciizcp_t template, mmux_libc_tm_t * tm_p)
{
  for (mmux_standard_usize_t buflen=1024; buflen; buflen+=1024) {
_Pragma("GCC diagnostic push")
_Pragma("GCC diagnostic ignored \"-Wformat-nonliteral\"")
    mmux_usize_t required_nbytes_excluding_nil = mmux_usize(strftime(NULL, buflen, template, tm_p));
_Pragma("GCC diagnostic pop")

    if (mmux_ctype_is_zero(required_nbytes_excluding_nil)) {
      /* The numbe of bytes "buflen" is not big enough. */
      continue;
    } else if (mmux_ctype_equal(required_nbytes_excluding_nil, mmux_usize_constant_maximum())) {
      return true;
    } else {
      required_nbytes_including_nil_p->value = 1 + required_nbytes_excluding_nil.value;
      return false;
    }
  }
  return true;
}
bool
mmux_libc_strftime (mmux_usize_t * required_nbytes_without_zero_p,
		    mmux_asciizp_t bufptr, mmux_usize_t buflen,
		    mmux_asciizcp_t template, mmux_libc_tm_t * tm_p)
{
  if (0 < buflen.value) {
    mmux_usize_t	required_nbytes_without_zero;

    /* See the documentation  of "strftime()" in the GLIBC manual  for an explanation
       of this nonsense. */
    bufptr[0]       = '\1';
_Pragma("GCC diagnostic push")
_Pragma("GCC diagnostic ignored \"-Wformat-nonliteral\"")
    required_nbytes_without_zero.value = strftime(bufptr, buflen.value, template, tm_p);
_Pragma("GCC diagnostic pop")
    if ((0 == required_nbytes_without_zero.value) && ('\0' != bufptr[0])) {
      return true;
    } else {
      *required_nbytes_without_zero_p = required_nbytes_without_zero;
      return false;
    }
  } else {
    return false;
  }
}
bool
mmux_libc_strptime (char ** first_unprocessed_after_timestamp_p,
		    mmux_asciizcp_t input_string, mmux_asciizcp_t template, mmux_libc_tm_t * tm_p)
{
  char *	first_unprocessed_after_timestamp = strptime(input_string, template, tm_p);

  if (first_unprocessed_after_timestamp) {
    if (first_unprocessed_after_timestamp_p) {
      *first_unprocessed_after_timestamp_p = first_unprocessed_after_timestamp;
    }
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Sleeping.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sleep (mmux_uint_t * result_p, mmux_uint_t seconds)
{
  *result_p = mmux_uint(sleep(seconds.value));
  return false;
}
bool
mmux_libc_nanosleep (mmux_libc_timespec_t * requested_time, mmux_libc_timespec_t * remaining_time)
{
  int	rv = nanosleep(requested_time, remaining_time);

  return ((-1 == rv)? true : false);
}

/* end of file */
