/*
  Part of: MMUX CC Libc
  Contents: network sockets
  Date: Dec 23, 2024

  Abstract

	This module implements the networking API.

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

#define DPRINTF(FD,...)		if (mmux_libc_dprintf(FD,__VA_ARGS__)) { return true; }


/** --------------------------------------------------------------------
 ** Struct dumpers helpers.
 ** ----------------------------------------------------------------- */

static void
sa_family_to_asciiz_name(mmux_asciizcp_t * name_p, mmux_libc_socket_address_family_t sa_family)
{
  switch (sa_family.value) {
#if (defined MMUX_HAVE_LIBC_AF_ALG)
  case MMUX_LIBC_VALUEOF_AF_ALG:
    *name_p = "AF_ALG";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_APPLETALK)
  case MMUX_LIBC_VALUEOF_AF_APPLETALK:
    *name_p = "AF_APPLETALK";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_AX25)
  case MMUX_LIBC_VALUEOF_AF_AX25:
    *name_p = "AF_AX25";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_BLUETOOTH)
  case MMUX_LIBC_VALUEOF_AF_BLUETOOTH:
    *name_p = "AF_BLUETOOTH";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_CAN)
  case MMUX_LIBC_VALUEOF_AF_CAN:
    *name_p = "AF_CAN";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_DECnet)
  case MMUX_LIBC_VALUEOF_AF_DECnet:
    *name_p = "AF_DECnet";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_IB)
  case MMUX_LIBC_VALUEOF_AF_IB:
    *name_p = "AF_IB";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_INET6)
  case MMUX_LIBC_VALUEOF_AF_INET6:
    *name_p = "AF_INET6";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_INET)
  case MMUX_LIBC_VALUEOF_AF_INET:
    *name_p = "AF_INET";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_IPX)
  case MMUX_LIBC_VALUEOF_AF_IPX:
    *name_p = "AF_IPX";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_KCM)
  case MMUX_LIBC_VALUEOF_AF_KCM:
    *name_p = "AF_KCM";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_KEY)
  case MMUX_LIBC_VALUEOF_AF_KEY:
    *name_p = "AF_KEY";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_LLC)
  case MMUX_LIBC_VALUEOF_AF_LLC:
    *name_p = "AF_LLC";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_LOCAL)
  case MMUX_LIBC_VALUEOF_AF_LOCAL:
    *name_p = "AF_LOCAL";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_MPLS)
  case MMUX_LIBC_VALUEOF_AF_MPLS:
    *name_p = "AF_MPLS";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_NETLINK)
  case MMUX_LIBC_VALUEOF_AF_NETLINK:
    *name_p = "AF_NETLINK";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_PACKET)
  case MMUX_LIBC_VALUEOF_AF_PACKET:
    *name_p = "AF_PACKET";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_PPPOX)
  case MMUX_LIBC_VALUEOF_AF_PPPOX:
    *name_p = "AF_PPPOX";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_RDS)
  case MMUX_LIBC_VALUEOF_AF_RDS:
    *name_p = "AF_RDS";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_TIPC)
  case MMUX_LIBC_VALUEOF_AF_TIPC:
    *name_p = "AF_TIPC";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_UNSPEC)
  case MMUX_LIBC_VALUEOF_AF_UNSPEC:
    *name_p = "AF_UNSPEC";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_VSOCK)
  case MMUX_LIBC_VALUEOF_AF_VSOCK:
    *name_p = "AF_VSOCK";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_X25)
  case MMUX_LIBC_VALUEOF_AF_X25:
    *name_p = "AF_X25";
    break;
#endif
#if (defined MMUX_HAVE_LIBC_AF_XDP)
  case MMUX_LIBC_VALUEOF_AF_XDP:
    *name_p = "AF_XDP";
    break;
#endif
  default:
    break;
  }
}

/* ------------------------------------------------------------------ */

static void
sa_socktype_to_asciiz_name(mmux_asciizcp_t* name_p, int sa_socktype)
{
  switch (sa_socktype) {
#if (defined MMUX_HAVE_LIBC_SOCK_STREAM)
  case MMUX_LIBC_SOCK_STREAM:
    *name_p = "SOCK_STREAM";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_DGRAM)
  case MMUX_LIBC_SOCK_DGRAM:
    *name_p = "SOCK_DGRAM";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_DCCP)
  case MMUX_LIBC_SOCK_DCCP:
    *name_p = "SOCK_DCCP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_PACKET)
  case MMUX_LIBC_SOCK_PACKET:
    *name_p = "SOCK_PACKET";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_RAW)
  case MMUX_LIBC_SOCK_RAW:
    *name_p = "SOCK_RAW";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_RDM)
  case MMUX_LIBC_SOCK_RDM:
    *name_p = "SOCK_RDM";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_SEQPACKET)
  case MMUX_LIBC_SOCK_SEQPACKET:
    *name_p = "SOCK_SEQPACKET";
    break;
#endif

  default:
    break;
  }
}

/* ------------------------------------------------------------------ */

static void
sa_ipproto_to_asciiz_name(mmux_asciizcp_t* name_p, int sa_ipproto)
{
  switch (sa_ipproto) {
#if (defined MMUX_HAVE_LIBC_IPPROTO_AH)
  case MMUX_LIBC_VALUEOF_IPPROTO_AH:
    *name_p = "IPPROTO_AH";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_BEETPH)
  case MMUX_LIBC_VALUEOF_IPPROTO_BEETPH:
    *name_p = "IPPROTO_BEETPH";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_COMP)
  case MMUX_LIBC_VALUEOF_IPPROTO_COMP:
    *name_p = "IPPROTO_COMP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_DCCP)
  case MMUX_LIBC_VALUEOF_IPPROTO_DCCP:
    *name_p = "IPPROTO_DCCP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_EGP)
  case MMUX_LIBC_VALUEOF_IPPROTO_EGP:
    *name_p = "IPPROTO_EGP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_ENCAP)
  case MMUX_LIBC_VALUEOF_IPPROTO_ENCAP:
    *name_p = "IPPROTO_ENCAP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_ESP)
  case MMUX_LIBC_VALUEOF_IPPROTO_ESP:
    *name_p = "IPPROTO_ESP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_ETHERNET)
  case MMUX_LIBC_VALUEOF_IPPROTO_ETHERNET:
    *name_p = "IPPROTO_ETHERNET";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_GRE)
  case MMUX_LIBC_VALUEOF_IPPROTO_GRE:
    *name_p = "IPPROTO_GRE";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_ICMP)
  case MMUX_LIBC_VALUEOF_IPPROTO_ICMP:
    *name_p = "IPPROTO_ICMP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_IDP)
  case MMUX_LIBC_VALUEOF_IPPROTO_IDP:
    *name_p = "IPPROTO_IDP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_IGMP)
  case MMUX_LIBC_VALUEOF_IPPROTO_IGMP:
    *name_p = "IPPROTO_IGMP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_IP)
  case MMUX_LIBC_VALUEOF_IPPROTO_IP:
    *name_p = "IPPROTO_IP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_IPIP)
  case MMUX_LIBC_VALUEOF_IPPROTO_IPIP:
    *name_p = "IPPROTO_IPIP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_IPV6)
  case MMUX_LIBC_VALUEOF_IPPROTO_IPV6:
    *name_p = "IPPROTO_IPV6";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_MPLS)
  case MMUX_LIBC_VALUEOF_IPPROTO_MPLS:
    *name_p = "IPPROTO_MPLS";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_MPTCP)
  case MMUX_LIBC_VALUEOF_IPPROTO_MPTCP:
    *name_p = "IPPROTO_MPTCP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_MTP)
  case MMUX_LIBC_VALUEOF_IPPROTO_MTP:
    *name_p = "IPPROTO_MTP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_PIM)
  case MMUX_LIBC_VALUEOF_IPPROTO_PIM:
    *name_p = "IPPROTO_PIM";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_PUP)
  case MMUX_LIBC_VALUEOF_IPPROTO_PUP:
    *name_p = "IPPROTO_PUP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_RAW)
  case MMUX_LIBC_VALUEOF_IPPROTO_RAW:
    *name_p = "IPPROTO_RAW";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_RSVP)
  case MMUX_LIBC_VALUEOF_IPPROTO_RSVP:
    *name_p = "IPPROTO_RSVP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_SCTP)
  case MMUX_LIBC_VALUEOF_IPPROTO_SCTP:
    *name_p = "IPPROTO_SCTP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_TCP)
  case MMUX_LIBC_VALUEOF_IPPROTO_TCP:
    *name_p = "IPPROTO_TCP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_TP)
  case MMUX_LIBC_VALUEOF_IPPROTO_TP:
    *name_p = "IPPROTO_TP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_UDP)
  case MMUX_LIBC_VALUEOF_IPPROTO_UDP:
    *name_p = "IPPROTO_UDP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_IPPROTO_UDPLITE)
  case MMUX_LIBC_VALUEOF_IPPROTO_UDPLITE:
    *name_p = "IPPROTO_UDPLITE";
    break;
#endif

  default:
    break;
  }
}


/** --------------------------------------------------------------------
 ** Struct in_addr.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_s_addr_set (mmux_libc_in_addr_t * const P, mmux_uint32_t value)
{
  P->value.s_addr = mmux_libc_ctype_value(value);
  return false;
}
bool
mmux_libc_s_addr_ref (mmux_uint32_t * result_p, mmux_libc_in_addr_t const * const P)
{
  *result_p = mmux_uint32(P->value.s_addr);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_make_in_addr (mmux_libc_in_addr_t * in_addr_p, mmux_uint32_t network_byteorder_value)
{
  /* Stored in network byte order. */
  in_addr_p->value.s_addr = network_byteorder_value.value;
  return false;
}
bool
mmux_libc_make_in_addr_none (mmux_libc_in_addr_t * in_addr_p)
{
  /* Stored in network byte order. */
  in_addr_p->value.s_addr = INADDR_NONE;
  return false;
}
bool
mmux_libc_make_in_addr_any (mmux_libc_in_addr_t * in_addr_p)
{
  /* Stored in network byte order. */
  in_addr_p->value.s_addr = INADDR_ANY;
  return false;
}
bool
mmux_libc_make_in_addr_broadcast (mmux_libc_in_addr_t * in_addr_p)
{
  /* Stored in network byte order. */
  in_addr_p->value.s_addr = INADDR_BROADCAST;
  return false;
}
bool
mmux_libc_make_in_addr_loopback (mmux_libc_in_addr_t * in_addr_p)
{
  /* Stored in network byte order. */
  in_addr_p->value.s_addr = INADDR_LOOPBACK;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_in_addr_dump (mmux_libc_file_descriptor_t fd, mmux_libc_in_addr_t const * in_addr_p,
			mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct in_addr";
  }

  DPRINTF(fd, "%s * = %p\n", struct_name, (mmux_pointerc_t)in_addr_p);

  {
    mmux_uint32_t	raw_number;

    mmux_libc_s_addr_ref(&raw_number, in_addr_p);
    DPRINTF(fd, "%s.s_addr = ", struct_name);
    if (mmux_libc_dprintf_uint32(fd, raw_number)) {
      return true;
    } else {
      auto const	provided_nchars = mmux_usize_literal(512);
      char		str[provided_nchars.value];

      if (mmux_libc_inet_ntop(str, provided_nchars, MMUX_LIBC_AF_INET, (mmux_pointer_t)in_addr_p)) {
	return true;
      }
      DPRINTF(fd, " (%s)\n", str);
    }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Struct insix_addr.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_insix_addr_loopback (mmux_libc_insix_addr_t * insix_addr_p)
{
  insix_addr_p->value = in6addr_loopback;
  return false;
}
bool
mmux_libc_make_insix_addr_any (mmux_libc_insix_addr_t * insix_addr_p)
{
  insix_addr_p->value = in6addr_any;
  return false;
}

bool
mmux_libc_insix_addr_dump (mmux_libc_file_descriptor_t fd, mmux_libc_insix_addr_t const * insix_addr_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct in6_addr";
  }

  DPRINTF(fd, "%s * = %p\n", struct_name, (mmux_pointerc_t)insix_addr_p);

  {
    auto const	provided_nchars = mmux_usize_literal(512);
    char	str[provided_nchars.value];

    if (mmux_libc_inet_ntop(str, provided_nchars, MMUX_LIBC_AF_INET6, (mmux_pointer_t)insix_addr_p)) {
      return true;
    }
    DPRINTF(fd, "%s = (%s)\n", struct_name, str);
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Struct sockaddr.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(sockaddr, sa_family,	libc_socket_address_family)

bool
mmux_libc_sockaddr_dump (mmux_libc_file_descriptor_t fd,
			 mmux_libc_sockaddr_t const * sockaddr_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr";
  }

  {
    mmux_libc_socket_address_family_t	sa_family;
    mmux_asciizcp_t			family_name = "unknown";

    mmux_libc_sa_family_ref(&sa_family, sockaddr_p);
    sa_family_to_asciiz_name(&family_name, sa_family);
    DPRINTF(fd, "%s.sa_family = \"%d\" (%s)\n", struct_name, (sockaddr_p->sa_family), family_name);
  }

  switch (sockaddr_p->sa_family) {
  case MMUX_LIBC_VALUEOF_AF_INET:
    return mmux_libc_sockaddr_in_dump   (fd, (mmux_libc_sockaddr_in_t    const *) sockaddr_p, struct_name);
  case MMUX_LIBC_VALUEOF_AF_INET6:
    return mmux_libc_sockaddr_insix_dump(fd, (mmux_libc_sockaddr_insix_t const *) sockaddr_p, struct_name);
  case MMUX_LIBC_VALUEOF_AF_LOCAL:
    return mmux_libc_sockaddr_un_dump   (fd, (mmux_libc_sockaddr_un_t    const *) sockaddr_p, struct_name);
  default:
    return false;
  }
}


/** --------------------------------------------------------------------
 ** Struct sockaddr_un.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(sockaddr_un, sun_family,	libc_socket_address_family)

bool
mmux_libc_sun_path_set (mmux_libc_sockaddr_un_t * const P, mmux_libc_file_system_pathname_t pathname)
{
  /* Check if the input pathname is too long  to fit in the data structure along with
     its terminating nul;  we do not want  to truncate it.  Notice  that the pathname
     stored in  the struct MUST be  terminated by a nul:  if it is not,  the standard
     functions will fail. */
  if ((sizeof(P->sun_path) - 1) < strlen(pathname.value)) {
    return true;
  } else {
    /* This chunk comes from the documentation of GLIBC. */
    strncpy(P->sun_path, pathname.value, sizeof(P->sun_path));
    P->sun_path[sizeof(P->sun_path) - 1] = '\0';
    return false;
  }
}
bool
mmux_libc_sun_path_ref (mmux_libc_file_system_pathname_t * result_p, mmux_libc_sockaddr_un_t const * const P)
{
  return mmux_libc_make_file_system_pathname(&mmux_libc_file_system_pathname_dynami_class,
					     result_p, P->sun_path);
}

mmux_usize_t
mmux_libc_SUN_LEN (mmux_libc_sockaddr_un_t const * P)
{
  /* NOTE: "SUN_LEN()"  does not  include the  terminating nul  of "sun_path"  in its
     computation; at least this is what I observe.  Notice that the length we pass to
     functions like "bind()" must be the  one returned by "SUN_LEN()".  (Marco Maggi;
     Dec 23, 2024) */
  return mmux_usize(SUN_LEN(P));
}

bool
mmux_libc_sockaddr_un_dump (mmux_libc_file_descriptor_t fd, mmux_libc_sockaddr_un_t const * sockaddr_un_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr_un";
  }

  {
    mmux_asciizcp_t			sun_name = "unknown";
    mmux_libc_socket_address_family_t	family;

    mmux_libc_sun_family_ref(&family, sockaddr_un_p);
    sa_family_to_asciiz_name(&sun_name, family);
    DPRINTF(fd, "%s.sun_family = \"%d\" (%s)\n", struct_name, (int)family.value, sun_name);
  }

  DPRINTF(fd, "%s.sun_path = \"%s\"\n", struct_name, sockaddr_un_p->sun_path);
  return false;
}


/** --------------------------------------------------------------------
 ** Struct sockaddr_in.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(sockaddr_in, sin_family,	libc_socket_address_family)
DEFINE_STRUCT_SETTER_GETTER(sockaddr_in, sin_addr,	libc_in_addr)

bool
mmux_libc_sin_port_set (mmux_libc_sockaddr_in_t * const P, mmux_host_byteorder_ushort_t host_byteorder_value)
{
  mmux_network_byteorder_ushort_t	network_byteorder_value;

  mmux_libc_htons(&network_byteorder_value, host_byteorder_value);
  P->sin_port = network_byteorder_value;
  return false;
}
bool
mmux_libc_sin_port_ref (mmux_host_byteorder_ushort_t * result_host_byteorder_p, mmux_libc_sockaddr_in_t const * const P)
{
  mmux_network_byteorder_ushort_t	network_byteorder_value = P->sin_port;
  mmux_host_byteorder_ushort_t		host_byteorder_value;

  mmux_libc_ntohs(&host_byteorder_value, network_byteorder_value);
  *result_host_byteorder_p = host_byteorder_value;
  return false;
}

bool
mmux_libc_sin_addr_p_ref (mmux_libc_in_addr_t ** sin_addr_pp, mmux_libc_sockaddr_in_t * sockaddr_p)
{
  *sin_addr_pp = &(sockaddr_p->sin_addr);
  return false;
}

bool
mmux_libc_sockaddr_in_dump (mmux_libc_file_descriptor_t fd, mmux_libc_sockaddr_in_t const * sockaddr_in_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr_in";
  }

  {
    mmux_asciizcp_t	sin_name = "unknown";

    sa_family_to_asciiz_name(&sin_name, sockaddr_in_p->sin_family);
    DPRINTF(fd, "%s.sin_family = \"%d\" (%s)\n", struct_name, sockaddr_in_p->sin_family, sin_name);
  }

  {
    auto const	provided_nchars = mmux_usize_literal(512);
    char	presentation_buf[provided_nchars.value];

    inet_ntop(sockaddr_in_p->sin_family, &(sockaddr_in_p->sin_addr), presentation_buf, provided_nchars.value);
    presentation_buf[provided_nchars.value - 1] = '\0';
    DPRINTF(fd, "%s.sin_addr = \"%s\"\n", struct_name, presentation_buf);
  }

  DPRINTF(fd, "%s.sin_port = \"%d\"\n", struct_name, ntohs(sockaddr_in_p->sin_port));
  return false;
}


/** --------------------------------------------------------------------
 ** Struct sockaddr_in6.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_family,   libc_socket_address_family, sinsix_family)
DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_addr,     mmux_libc_insix_addr_t, sinsix_addr)
DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_flowinfo, mmux_uint32_t,          sinsix_flowinfo)
DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_scope_id, mmux_uint32_t,          sinsix_scope_id)

/* ------------------------------------------------------------------ */

bool
mmux_libc_sinsix_port_set (mmux_libc_sockaddr_insix_t * const P, mmux_host_byteorder_uint16_t host_byteorder_value)
{
  mmux_network_byteorder_ushort_t	network_byteorder_value;

  mmux_libc_htons(&network_byteorder_value, host_byteorder_value);
  P->sin6_port = network_byteorder_value;
  return false;
}
bool
mmux_libc_sinsix_port_ref (mmux_host_byteorder_uint16_t * result_host_byteorder_p, mmux_libc_sockaddr_insix_t const * const P)
{
  mmux_network_byteorder_ushort_t	network_byteorder_value = P->sin6_port;
  mmux_host_byteorder_ushort_t		host_byteorder_value;

  mmux_libc_ntohs(&host_byteorder_value, network_byteorder_value);
  *result_host_byteorder_p = host_byteorder_value;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_sinsix_addr_p_ref (mmux_libc_insix_addr_t ** sinsix_addr_pp, mmux_libc_sockaddr_insix_t * sockaddr_p)
{
  *sinsix_addr_pp = &(sockaddr_p->sin6_addr);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_sockaddr_insix_dump (mmux_libc_file_descriptor_t fd, mmux_libc_sockaddr_insix_t const * sockaddr_in6_p,
			       mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr_in6";
  }

  {
    mmux_asciizcp_t	sin6_name = "unknown";

    sa_family_to_asciiz_name(&sin6_name, sockaddr_in6_p->sin6_family);
    DPRINTF(fd, "%s.sin6_family = \"%d\" (%s)\n", struct_name, (mmux_sint_t)(sockaddr_in6_p->sin6_family), sin6_name);
  }

  {
    auto const	provided_nchars = mmux_usize_literal(512);
    char	presentation_buf[provided_nchars.value];

    inet_ntop(sockaddr_in6_p->sin6_family, &(sockaddr_in6_p->sin6_addr), presentation_buf, provided_nchars);
    presentation_buf[provided_nchars.value - 1] = '\0';
    DPRINTF(fd, "%s.sin6_addr = \"%s\"\n", struct_name, presentation_buf);
  }

  DPRINTF(fd, "%s.sin6_flowinfo = \"%lu\"\n", struct_name, (mmux_ulong_t)(sockaddr_in6_p->sin6_flowinfo));
  DPRINTF(fd, "%s.sin6_scope_id = \"%lu\"\n", struct_name, (mmux_ulong_t)(sockaddr_in6_p->sin6_scope_id));
  DPRINTF(fd, "%s.sin6_port = \"%d\"\n", struct_name, ntohs(sockaddr_in6_p->sin6_port));
  return false;
}


/** --------------------------------------------------------------------
 ** Struct addrinfo.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_flags,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_family,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_socktype,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_protocol,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_addrlen,	mmux_socklen_t)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_addr,		mmux_libc_sockaddr_t *)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_next,		mmux_libc_addrinfo_t *)

/* ------------------------------------------------------------------ */

/* We define these setter and getter separately because we want the argument to be of
   type "mmux_asciizcp_t" rather than of type "mmux_asciizp_t ".*/
bool
mmux_libc_ai_canonname_set (mmux_libc_addrinfo_t * const P, mmux_asciizcp_t value)
{
  P->ai_canonname = (mmux_asciizp_t)value;
  return false;
}
bool
mmux_libc_ai_canonname_ref (mmux_asciizcp_t * result_p, mmux_libc_addrinfo_t const * const P)
{
  *result_p = P->ai_canonname;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_addrinfo_dump (mmux_libc_file_descriptor_t fd, mmux_libc_addrinfo_t const * addrinfo_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct addrinfo";
  }

  /* Inspect the field: ai_flags */
  {
    bool	not_first_flags = false;

    DPRINTF(fd, "%s.ai_flags = \"%d\"", struct_name, addrinfo_p->ai_flags);

    if (AI_ADDRCONFIG & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_ADDRCONFIG");
      } else {
	DPRINTF(fd, " (AI_ADDRCONFIG");
	not_first_flags = true;
      }
    }

    if (AI_ALL & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_ALL");
      } else {
	DPRINTF(fd, " (AI_ALL");
	not_first_flags = true;
      }
    }

    if (AI_CANONIDN & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_CANONIDN");
      } else {
	DPRINTF(fd, " (AI_CANONIDN");
	not_first_flags = true;
      }
    }

    if (AI_CANONNAME & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_CANONNAME");
      } else {
	DPRINTF(fd, " (AI_CANONNAME");
	not_first_flags = true;
      }
    }

    if (AI_IDN & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_IDN");
      } else {
	DPRINTF(fd, " (AI_IDN");
	not_first_flags = true;
      }
    }

    if (AI_NUMERICSERV & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_NUMERICSERV");
      } else {
	DPRINTF(fd, " (AI_NUMERICSERV");
	not_first_flags = true;
      }
    }

    if (AI_PASSIVE & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_PASSIVE");
      } else {
	DPRINTF(fd, " (AI_PASSIVE");
	not_first_flags = true;
      }
    }

    if (AI_V4MAPPED & addrinfo_p->ai_flags ) {
      if (not_first_flags) {
	DPRINTF(fd, " | AI_V4MAPPED");
      } else {
	DPRINTF(fd, " (AI_V4MAPPED");
	not_first_flags = true;
      }
    }

    if (not_first_flags) {
      DPRINTF(fd, ")\n");
    } else {
      DPRINTF(fd, "\n");
    }
  }

  /* Inspect the field: ai_family */
  {
    mmux_asciizcp_t	ai_name = "unknown";

    sa_family_to_asciiz_name(&ai_name, addrinfo_p->ai_family);
    DPRINTF(fd, "%s.ai_family = \"%d\" (%s)\n", struct_name, addrinfo_p->ai_family, ai_name);
  }

  /* Inspect the field: ai_socktype */
  {
    mmux_asciizcp_t	ai_name = "unknown";

    sa_socktype_to_asciiz_name(&ai_name, addrinfo_p->ai_socktype);
    DPRINTF(fd, "%s.ai_socktype = \"%d\" (%s)\n", struct_name, addrinfo_p->ai_socktype, ai_name);
  }

  /* Inspect the field: ai_protocol */
  {
    mmux_asciizcp_t	ai_name = "unknown";

    sa_ipproto_to_asciiz_name(&ai_name, addrinfo_p->ai_protocol);
    DPRINTF(fd, "%s.ai_protocol = \"%d\" (%s)\n", struct_name, addrinfo_p->ai_protocol, ai_name);
  }

  /* Inspect the field: ai_addrlen */
  {
    mmux_asciizcp_t	known_struct_name = "unknown struct type";

    switch (addrinfo_p->ai_addrlen) {
    case sizeof(mmux_libc_sockaddr_in_t):
      known_struct_name ="struct sockaddr_in";
      break;

    case sizeof(mmux_libc_sockaddr_insix_t):
      known_struct_name ="struct sockaddr_in6";
      break;

    case sizeof(mmux_libc_sockaddr_un_t):
      known_struct_name ="struct sockaddr_un";
      break;
    }

    DPRINTF(fd, "%s.ai_addrlen = \"%d\" (%s)\n", struct_name, addrinfo_p->ai_addrlen, known_struct_name);
  }

  /* Inspect the field: ai_addr, it is a pointer to "struct sockaddr" */
  {
    auto const	provided_nchars = mmux_usize_literal(512);
    char	bufstr[provided_nchars];

    mmux_libc_memzero(bufstr, provided_nchars);
    inet_ntop(addrinfo_p->ai_family, &(addrinfo_p->ai_addr), bufstr, provided_nchars);

    DPRINTF(fd, "%s.ai_addr = \"%p\" (%s)\n", struct_name, (mmux_pointer_t)(addrinfo_p->ai_addr), bufstr);
  }

  /* Inspect the field: ai_canonname */
  {
    if (addrinfo_p->ai_canonname) {
      DPRINTF(fd, "%s.ai_canonname = \"%p\" (%s)\n", struct_name, (mmux_pointer_t)(addrinfo_p->ai_canonname), addrinfo_p->ai_canonname);
    } else {
      DPRINTF(fd, "%s.ai_canonname = \"%p\"\n",      struct_name, (mmux_pointer_t)(addrinfo_p->ai_canonname));
    }
  }

  /* Inspect the field: ai_next */
  {
    DPRINTF(fd, "%s.ai_next = \"%p\"\n", struct_name, (mmux_pointer_t)(addrinfo_p->ai_next));
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Struct hostent.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(hostent, h_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER(hostent, h_aliases,		mmux_asciizpp_t)
DEFINE_STRUCT_SETTER_GETTER(hostent, h_addrtype,	mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(hostent, h_length,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(hostent, h_addr_list,	mmux_asciizpp_t)
DEFINE_STRUCT_SETTER_GETTER(hostent, h_addr,		mmux_asciizp_t)

/* ------------------------------------------------------------------ */

bool
mmux_libc_hostent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_hostent_t const * hostent_p, mmux_asciizcp_t struct_name)
{
  int	aliases_idx   = 0;
  int	addr_list_idx = 0;

  if (NULL == struct_name) {
    struct_name = "struct hostent";
  }

  DPRINTF(fd, "%s.h_name = \"%s\"\n", struct_name, hostent_p->h_name);

  if (NULL != hostent_p->h_aliases) {
    for (; hostent_p->h_aliases[aliases_idx]; ++aliases_idx) {
      DPRINTF(fd, "%s.h_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, hostent_p->h_aliases[aliases_idx]);
    }
  }
  if (0 == aliases_idx) {
    DPRINTF(fd, "%s.h_aliases = \"0x0\"\n", struct_name);
  }

  DPRINTF(fd, "%s.h_addrtype = \"%d\"", struct_name, hostent_p->h_addrtype);

  switch (hostent_p->h_addrtype) {
  case MMUX_LIBC_AF_INET:
    DPRINTF(fd, " (AF_INET)\n");
    break;
  case MMUX_LIBC_AF_INET6:
    DPRINTF(fd, " (AF_INET6)\n");
    break;
  default:
    DPRINTF(fd, "\n");
    break;
  }

  DPRINTF(fd, "%s.h_length = \"%d\"\n", struct_name, hostent_p->h_length);

  if (NULL != hostent_p->h_addr_list) {
    auto const	provided_nchars = mmux_usize_literal(512);

    for (; hostent_p->h_addr_list[addr_list_idx]; ++addr_list_idx) {
      char	presentation_buf[provided_nchars.value];

      inet_ntop(hostent_p->h_addrtype, hostent_p->h_addr_list[addr_list_idx], presentation_buf, provided_nchars);
      presentation_buf[provided_nchars.value - 1] = '\0';
      DPRINTF(fd, "%s.h_addr_list[%d] = \"%s\"\n", struct_name, addr_list_idx, presentation_buf);
    }
  }
  if (0 == addr_list_idx) {
    DPRINTF(fd, "%s.h_addr_list = \"0x0\"\n", struct_name);
  }

  if (NULL != hostent_p->h_addr) {
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK	512
    char	presentation_buf[IS_THIS_ENOUGH_QUESTION_MARK];

    inet_ntop(hostent_p->h_addrtype, hostent_p->h_addr, presentation_buf, IS_THIS_ENOUGH_QUESTION_MARK);
    presentation_buf[IS_THIS_ENOUGH_QUESTION_MARK-1] = '\0';
    DPRINTF(fd, "%s.h_addr = \"%s\"\n", struct_name, presentation_buf);
  } else {
    DPRINTF(fd, "%s.h_addr = \"0x0\"\n", struct_name);
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Struct servent.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(servent, s_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER(servent, s_aliases,		mmux_asciizp_t *)
DEFINE_STRUCT_SETTER_GETTER(servent, s_port,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(servent, s_proto,		mmux_asciizp_t)

bool
mmux_libc_servent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_servent_t const * servent_p, mmux_asciizcp_t struct_name)
{
  int	aliases_idx = 0;

  if (NULL == struct_name) {
    struct_name = "struct servent";
  }

  DPRINTF(fd, "%s.s_name = \"%s\"\n", struct_name, servent_p->s_name);

  if (NULL != servent_p->s_aliases) {
    for (; servent_p->s_aliases[aliases_idx]; ++aliases_idx) {
      DPRINTF(fd, "%s.s_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, servent_p->s_aliases[aliases_idx]);
    }
  }
  if (0 == aliases_idx) {
    DPRINTF(fd, "%s.s_aliases = \"0x0\"\n", struct_name);
  }

  DPRINTF(fd, "%s.s_port = \"%d\"\n", struct_name, ntohs(servent_p->s_port));
  DPRINTF(fd, "%s.s_proto = \"%s\"\n", struct_name, servent_p->s_proto);

  return false;
}


/** --------------------------------------------------------------------
 ** Struct protoent.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(protoent, p_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER(protoent, p_aliases,	mmux_asciizp_t *)
DEFINE_STRUCT_SETTER_GETTER(protoent, p_proto,		mmux_sint_t)

bool
mmux_libc_protoent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_protoent_t const * protoent_p, mmux_asciizcp_t struct_name)
{
  int	aliases_idx = 0;

  if (NULL == struct_name) {
    struct_name = "struct protoent";
  }

  DPRINTF(fd, "%s.s_name = \"%s\"\n", struct_name, protoent_p->p_name);

  if (NULL != protoent_p->p_aliases) {
    for (; protoent_p->p_aliases[aliases_idx]; ++aliases_idx) {
      DPRINTF(fd, "%s.s_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, protoent_p->p_aliases[aliases_idx]);
    }
  }
  if (0 == aliases_idx) {
    DPRINTF(fd, "%s.s_aliases = \"0x0\"\n", struct_name);
  }

  DPRINTF(fd, "%s.s_proto = \"%d\"\n", struct_name, protoent_p->p_proto);

  return false;
}


/** --------------------------------------------------------------------
 ** Struct netent.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(netent, n_name,		mmux_asciizp_t)
DEFINE_STRUCT_SETTER_GETTER(netent, n_aliases,		mmux_asciizp_t *)
DEFINE_STRUCT_SETTER_GETTER(netent, n_addrtype,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(netent, n_net,		mmux_ulong_t)

bool
mmux_libc_netent_dump (mmux_libc_file_descriptor_t fd, mmux_libc_netent_t const * netent_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct netent";
  }

  DPRINTF(fd, "%s.n_name = \"%s\"\n", struct_name, netent_p->n_name);

  {
    int		aliases_idx = 0;

    if (NULL != netent_p->n_aliases) {
      for (; netent_p->n_aliases[aliases_idx]; ++aliases_idx) {
	DPRINTF(fd, "%s.n_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, netent_p->n_aliases[aliases_idx]);
      }
    }
    if (0 == aliases_idx) {
      DPRINTF(fd, "%s.n_aliases = \"0x0\"\n", struct_name);
    }
  }

  {
    mmux_asciizcp_t	name;

    sa_family_to_asciiz_name(&name, netent_p->n_addrtype);
    DPRINTF(fd, "%s.n_addrtype = \"%d\" (%s)\n", struct_name, netent_p->n_addrtype, name);
  }

  /* The value "netent_p->n_net" is in host byte order. */
  {
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK	512
    char		net_str[IS_THIS_ENOUGH_QUESTION_MARK];
    mmux_uint32_t	network_byteorder_net = htonl(netent_p->n_net);

    inet_ntop(netent_p->n_addrtype, &(network_byteorder_net), net_str, (mmux_socklen_t)IS_THIS_ENOUGH_QUESTION_MARK);

    DPRINTF(fd, "%s.n_net = \"%lu\" (%s)\n", struct_name, (mmux_ulong_t)(netent_p->n_net), net_str);
  }
  return false;
}


/** --------------------------------------------------------------------
 ** Byte order.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_htons (mmux_uint16_t * network_byteorder_value_p, mmux_uint16_t host_byteorder_value)
{
  *network_byteorder_value_p = htons(host_byteorder_value);
  return false;
}
bool
mmux_libc_ntohs (mmux_uint16_t * host_byteorder_value_p, mmux_uint16_t network_byteorder_value)
{
  *host_byteorder_value_p = ntohs(network_byteorder_value);
  return false;
}
bool
mmux_libc_htonl (mmux_uint32_t * network_byteorder_value_p, mmux_uint32_t host_byteorder_value)
{
  *network_byteorder_value_p = htonl(host_byteorder_value);
  return false;
}
bool
mmux_libc_ntohl (mmux_uint32_t * host_byteorder_value_p, mmux_uint32_t network_byteorder_value)
{
  *host_byteorder_value_p = ntohl(network_byteorder_value);
  return false;
}


/** --------------------------------------------------------------------
 ** Address convertion to/from ASCII presentation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_inet_aton (mmux_libc_in_addr_ptr_t ouput_addr_p, mmux_asciizcp_t input_presentation_p)
{
  int	rv = inet_aton(input_presentation_p, ouput_addr_p);

  return ((0 != rv)? false : true);
}
bool
mmux_libc_inet_ntoa (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
		     mmux_libc_in_addr_ptr_t input_addr_p)
{
  /* This is the dotted-quad string. */
  mmux_asciizcp_t	presentation_ptr = inet_ntoa(*input_addr_p);
  mmux_usize_t		presentation_len = strlen(presentation_ptr);

  /* The number of bytes "ouput_presentation_provided_nchars" is meant to include the
     trailing nul character.  The number of bytes "presentation_len" does not include
     the trailing nul character. */
  if (ouput_presentation_provided_nchars > presentation_len) {
    strncpy(ouput_presentation_p, presentation_ptr, ouput_presentation_provided_nchars);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_inet_pton (mmux_pointer_t ouput_addr_p,
		     mmux_sint_t input_af_family, mmux_asciizcp_t input_presentation_p)
{
  int	rv = inet_pton(input_af_family, input_presentation_p, ouput_addr_p);

  return ((0 != rv)? false : true);
}
bool
mmux_libc_inet_ntop (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
		     mmux_libc_socket_address_family_t input_af_family, mmux_pointer_t input_addr_p)
{
  auto const		provided_nchars = mmux_usize_literal(512);
  char			presentation[provided_nchars.value];
  mmux_asciizcp_t	rv = inet_ntop(input_af_family.value, input_addr_p, presentation, provided_nchars.value);

  if (NULL != rv) {
    auto	presentation_generated_nchars = mmux_usize_strlen(presentation);

    if (mmux_ctype_greater(ouput_presentation_provided_nchars, presentation_generated_nchars)) {
      mmux_libc_strncpy(ouput_presentation_p, presentation, ouput_presentation_provided_nchars);
      return false;
    }
  }
  return true;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_inet_addr (mmux_libc_in_addr_ptr_t result_in_addr_p, mmux_asciizcp_t presentation_in_addr_p)
{
  mmux_uint32_t		network_byteorder_s_addr = inet_addr(presentation_in_addr_p);

  if (MMUX_LIBC_INADDR_NONE != network_byteorder_s_addr) {
    return mmux_libc_make_in_addr(result_in_addr_p, network_byteorder_s_addr);
  } else {
    return true;
  }
}
bool
mmux_libc_inet_network (mmux_libc_in_addr_ptr_t result_in_addr_p, mmux_asciizcp_t presentation_in_addr_p)
{
  mmux_uint32_t		network_byteorder_s_addr = inet_network(presentation_in_addr_p);

  if (MMUX_LIBC_INADDR_NONE != network_byteorder_s_addr) {
    return mmux_libc_make_in_addr(result_in_addr_p, network_byteorder_s_addr);
  } else {
    return true;
  }
}
bool
mmux_libc_inet_makeaddr (mmux_libc_in_addr_ptr_t result_in_addr_p,
			 mmux_libc_in_addr_ptr_t net_in_addr_p, mmux_libc_in_addr_ptr_t local_in_addr_p)
{
  mmux_libc_in_addr_t	in_addr = inet_makeaddr(net_in_addr_p->s_addr, local_in_addr_p->s_addr);

  *result_in_addr_p = in_addr;
  return false;
}
bool
mmux_libc_inet_lnaof (mmux_libc_in_addr_ptr_t local_in_addr_p, mmux_libc_in_addr_ptr_t in_addr_p)
{
  mmux_uint32_t		uint32_local_in_addr = inet_lnaof(*in_addr_p);

  return mmux_libc_make_in_addr(local_in_addr_p, uint32_local_in_addr);
}
bool
mmux_libc_inet_netof (mmux_libc_in_addr_ptr_t net_in_addr_p, mmux_libc_in_addr_ptr_t in_addr_p)
{
  mmux_uint32_t		uint32_net_in_addr = inet_netof(*in_addr_p);

  return mmux_libc_make_in_addr(net_in_addr_p, uint32_net_in_addr);
}


/** --------------------------------------------------------------------
 ** Address informations.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_getaddrinfo (mmux_libc_addrinfo_ptr_t * result_addrinfo_linked_list_pp,
		       mmux_sint_t * result_error_code_p,
		       mmux_asciizcp_t node, mmux_asciizcp_t service, mmux_libc_addrinfo_ptr_t hints_pointer)
{
  int	rv = getaddrinfo(node, service, hints_pointer, result_addrinfo_linked_list_pp);

  if (0 == rv) {
    return false;
  } else {
    *result_error_code_p = rv;
    return true;
  }
}
bool
mmux_libc_freeaddrinfo (mmux_libc_addrinfo_ptr_t addrinfo_linked_list_p)
{
  freeaddrinfo(addrinfo_linked_list_p);
  return false;
}
bool
mmux_libc_gai_strerror (mmux_asciizcp_t * result_error_message_p, mmux_sint_t errnum)
{
  *result_error_message_p = gai_strerror(errnum);
  return false;
}
bool
mmux_libc_getnameinfo (mmux_asciizcp_t result_hostname_p, mmux_socklen_t provided_hostname_len,
		       mmux_asciizcp_t result_servname_p, mmux_socklen_t provided_servname_len,
		       mmux_sint_t * result_error_code_p,
		       mmux_libc_sockaddr_ptr_t input_sockaddr_p, mmux_socklen_t input_sockaddr_size,
		       mmux_sint_t flags)
{
  int	rv = getnameinfo(input_sockaddr_p, input_sockaddr_size,
			 (mmux_asciizp_t)result_hostname_p, provided_hostname_len,
			 (mmux_asciizp_t)result_servname_p, provided_servname_len,
			 flags);

  if (0 == rv) {
    return false;
  } else {
    *result_error_code_p = rv;
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Host database.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sethostent (mmux_sint_t stayopen)
{
  sethostent(stayopen);
  return false;
}
bool
mmux_libc_endhostent (void)
{
  endhostent();
  return false;
}
bool
mmux_libc_gethostent (mmux_libc_hostent_t const * * result_hostent_pp)
{
  mmux_libc_hostent_ptr_t	hostent_p = gethostent();

  *result_hostent_pp = hostent_p;
  return false;
}


/** --------------------------------------------------------------------
 ** Services database.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_setservent (mmux_sint_t stayopen)
{
  setservent(stayopen);
  return false;
}
bool
mmux_libc_endservent (void)
{
  endservent();
  return false;
}
bool
mmux_libc_getservent (mmux_libc_servent_t const * * result_servent_pp)
{
  mmux_libc_servent_t const *	servent_p = getservent();

  *result_servent_pp = servent_p;
  return false;
}
bool
mmux_libc_getservbyname (mmux_libc_servent_t const * * result_servent_pp,
			 mmux_asciizcp_t service_name_p, mmux_asciizcp_t protocol_name_p)
{
  mmux_libc_servent_t const *	 servent_p = getservbyname(service_name_p, protocol_name_p);

  if (NULL != servent_p) {
    *result_servent_pp = servent_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getservbyport (mmux_libc_servent_t const * * result_servent_pp,
			 mmux_sint_t port, mmux_asciizcp_t protocol_name_p)
{
  mmux_libc_servent_t const *	 servent_p = getservbyport(port, protocol_name_p);

  if (NULL != servent_p) {
    *result_servent_pp = servent_p;
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Protocols database.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_setprotoent (mmux_sint_t stayopen)
{
  setprotoent(stayopen);
  return false;
}
bool
mmux_libc_endprotoent (void)
{
  endprotoent();
  return false;
}
bool
mmux_libc_getprotoent (mmux_libc_protoent_t const * * result_protoent_pp)
{
  mmux_libc_protoent_ptr_t	protoent_p = getprotoent();

  *result_protoent_pp = protoent_p;
  return false;
}
bool
mmux_libc_getprotobyname (mmux_libc_protoent_t const * * result_protoent_pp, mmux_asciizcp_t protocol_name_p)
{
  mmux_libc_protoent_t const *	protoent_p = getprotobyname(protocol_name_p);

  if (NULL != protoent_p) {
    *result_protoent_pp = protoent_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getprotobynumber (mmux_libc_protoent_t const * * result_protoent_pp, mmux_sint_t proto)
{
  mmux_libc_protoent_t const *	protoent_p = getprotobynumber(proto);

  if (NULL != protoent_p) {
    *result_protoent_pp = protoent_p;
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Networks database.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_setnetent (mmux_sint_t stayopen)
{
  setnetent(stayopen);
  return false;
}
bool
mmux_libc_endnetent (void)
{
  endnetent();
  return false;
}
bool
mmux_libc_getnetent (mmux_libc_netent_t const * * result_netent_pp)
{
  mmux_libc_netent_ptr_t	netent_p = getnetent();

  *result_netent_pp = netent_p;
  return false;
}
bool
mmux_libc_getnetbyname (mmux_libc_netent_t const * * result_netent_pp, mmux_asciizcp_t network_name_p)
{
  mmux_libc_netent_t const *	netent_p = getnetbyname(network_name_p);

  if (netent_p) {
    *result_netent_pp = netent_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getnetbyaddr (mmux_libc_netent_t const * * result_netent_pp, mmux_uint32_t n_net, mmux_sint_t af_type)
{
  mmux_libc_netent_t const *	netent_p = getnetbyaddr(n_net, af_type);

  if (netent_p) {
    *result_netent_pp = netent_p;
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Interface naming.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(if_nameindex, if_index,	mmux_uint_t)

bool
mmux_libc_if_name_set (mmux_libc_if_nameindex_t * const P, mmux_asciizcp_t value)
{
  P->if_name = (mmux_asciizp_t)value;
  return false;
}
bool
mmux_libc_if_name_ref (mmux_asciizcp_t * result_p, mmux_libc_if_nameindex_t const * const P)
{
  *result_p = P->if_name;
  return false;
}

bool
mmux_libc_if_nameindex_dump (mmux_libc_file_descriptor_t fd, mmux_libc_if_nameindex_t const * nameindex_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct if_nameindex";
  }

  DPRINTF(fd, "%s.if_index = \"%d\"\n", struct_name, nameindex_p->if_index);
  DPRINTF(fd, "%s.if_name  = \"%s\"\n", struct_name, nameindex_p->if_name);

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_if_nametoindex (mmux_uint_t * index_p, mmux_asciizcp_t network_interface_name)
{
  int	rv = if_nametoindex(network_interface_name);

  if (0 < rv) {
    *index_p = rv;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_if_indextoname (mmux_asciizp_t buffer, mmux_uint_t network_interface_index)
{
  char *	rv = if_indextoname(network_interface_index, buffer);

  return ((NULL != rv)? false : true);
}
bool
mmux_libc_if_nameindex (mmux_libc_if_nameindex_t const * * result_nameindex_p)
{
  mmux_libc_if_nameindex_t const *	nameindex_p = if_nameindex();

  if (NULL != nameindex_p) {
    *result_nameindex_p = nameindex_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_if_freenameindex (mmux_libc_if_nameindex_t const * nameindex_array)
{
  if_freenameindex((mmux_libc_if_nameindex_ptr_t)nameindex_array);
  return false;
}


/** --------------------------------------------------------------------
 ** Sockets: creation, pairs, shutdown.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_network_socket (mmux_libc_network_socket_t * result_p, mmux_sint_t sock_num)
{
  result_p->value = sock_num;
  return false;
}
bool
mmux_libc_socket (mmux_libc_network_socket_t * result_sock_p, mmux_sint_t pf_namespace, mmux_sint_t sock_style, mmux_sint_t ipproto)
{
  int		sock = socket(pf_namespace, sock_style, ipproto);

  if (-1 != sock) {
    return mmux_libc_make_network_socket(result_sock_p, sock);
  } else {
    return true;
  }
}
bool
mmux_libc_shutdown (mmux_libc_network_socket_t sock, mmux_sint_t how)
{
  int	rv = shutdown(sock.value, how);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_socketpair (mmux_libc_network_socket_t * result_sock1_p, mmux_libc_network_socket_t * result_sock2_p,
		      mmux_sint_t pf_namespace, mmux_sint_t sock_style, mmux_sint_t ipproto)
{
  int	socks[2];
  int	rv = socketpair(pf_namespace, sock_style, ipproto, socks);

  if (0 == rv) {
    mmux_libc_make_network_socket(result_sock1_p, socks[0]);
    mmux_libc_make_network_socket(result_sock2_p, socks[1]);
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Stream sockets.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_connect (mmux_libc_network_socket_t sock, mmux_libc_sockaddr_ptr_t sockaddr_pointer, mmux_socklen_t sockaddr_size)
{
  int	rv = connect(sock.value, sockaddr_pointer, sockaddr_size);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_bind (mmux_libc_network_socket_t sock, mmux_libc_sockaddr_ptr_t sockaddr_pointer, mmux_socklen_t sockaddr_size)
{
  int	rv = bind(sock.value, sockaddr_pointer, sockaddr_size);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_listen (mmux_libc_network_socket_t sock, mmux_uint_t pending_connections_queue_length)
{
  int	rv = listen(sock.value, pending_connections_queue_length);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_accept (mmux_libc_network_socket_t * result_connected_sock_p,
		  mmux_libc_sockaddr_ptr_t result_client_sockaddr_p, mmux_socklen_t * result_client_sockaddr_size_p,
		  mmux_libc_network_socket_t server_sock)
/* Upon calling:  the location referenced by  "result_client_sockaddr_size_p" must be
 * set  to   the  number   of  bytes   allocated  for   the  address   referenced  by
 * "result_client_sockaddr_p".
 *
 * Upon      successfully     returning:      the     location      referenced     by
 * "result_client_sockaddr_size_p" is reset to the actual size of the client address.
 */
{
  int	connected_sock = accept(server_sock.value, result_client_sockaddr_p, result_client_sockaddr_size_p);

  if (-1 != connected_sock) {
    return mmux_libc_make_network_socket(result_connected_sock_p, connected_sock);
  } else {
    return true;
  }
}
bool
mmux_libc_accept4 (mmux_libc_network_socket_t * result_connected_sock_p,
		   mmux_libc_sockaddr_ptr_t result_client_sockaddr_p, mmux_socklen_t * result_client_sockaddr_size_p,
		   mmux_libc_network_socket_t server_sock, mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_ACCEPT4]]],[[[
  int	connected_sock = accept4(server_sock.value, result_client_sockaddr_p, result_client_sockaddr_size_p, flags);

  if (-1 != connected_sock) {
    return mmux_libc_make_network_socket(result_connected_sock_p, connected_sock);
  } else {
    return true;
  }
]]])
}
bool
mmux_libc_getpeername (mmux_libc_network_socket_t sock, mmux_libc_sockaddr_ptr_t sockaddr_any, mmux_socklen_t * sockaddr_any_size)
{
  int	rv = getpeername(sock.value, sockaddr_any, sockaddr_any_size);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_getsockname (mmux_libc_network_socket_t sock, mmux_libc_sockaddr_ptr_t sockaddr_any, mmux_socklen_t * sockaddr_any_size)
{
  int	rv = getsockname(sock.value, sockaddr_any, sockaddr_any_size);

  return ((0 == rv)? false : true);
}


/** --------------------------------------------------------------------
 ** Sending and receiving data.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_send (mmux_usize_t * result_number_of_bytes_sent_p,
		mmux_libc_network_socket_t sock, mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
{
  mmux_ssize_t	number_of_bytes_sent = send(sock.value, bufptr, buflen, flags);

  if (-1 != number_of_bytes_sent) {
    *result_number_of_bytes_sent_p = number_of_bytes_sent;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_sendto (mmux_usize_t * result_number_of_bytes_sent_p,
		  mmux_libc_network_socket_t sock, mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags,
		  mmux_libc_sockaddr_ptr_t destination_sockaddr_p, mmux_socklen_t destination_sockaddr_size)
{
  mmux_ssize_t	number_of_bytes_sent = sendto(sock.value, bufptr, buflen, flags,
					      destination_sockaddr_p, destination_sockaddr_size);

  if (-1 != number_of_bytes_sent) {
    *result_number_of_bytes_sent_p = number_of_bytes_sent;
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_recv (mmux_usize_t * result_number_of_bytes_received_p,
		mmux_libc_network_socket_t sock, mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
{
  mmux_ssize_t	number_of_bytes_received = recv(sock.value, bufptr, buflen, flags);

  if (-1 != number_of_bytes_received) {
    *result_number_of_bytes_received_p = number_of_bytes_received;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_recvfrom (mmux_usize_t * result_number_of_bytes_received_p,
		    mmux_libc_sockaddr_ptr_t result_sender_sockaddr_p, mmux_socklen_t * result_sender_sockaddr_size_p,
		    mmux_libc_network_socket_t sock, mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
{
  /* The arguments "result_sender_sockaddr_p" and "result_sender_sockaddr_size_p" can
     be NULL if we are not interested in retrieving the sender address. */
  mmux_ssize_t	number_of_bytes_received  = recvfrom(sock.value, bufptr, buflen, flags,
						     result_sender_sockaddr_p, result_sender_sockaddr_size_p);

  if (-1 != number_of_bytes_received) {
    *result_number_of_bytes_received_p = number_of_bytes_received;
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Options.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(linger, l_onoff,		mmux_sint_t)
DEFINE_STRUCT_SETTER_GETTER(linger, l_linger,		mmux_sint_t)

bool
mmux_libc_linger_dump (mmux_libc_file_descriptor_t fd, mmux_libc_linger_t const * linger_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct linger";
  }
  DPRINTF(fd, "%s.l_onoff  = \"%d\"\n", struct_name, linger_p->l_onoff);
  DPRINTF(fd, "%s.l_linger = \"%d\"\n", struct_name, linger_p->l_linger);
  return false;
}
bool
mmux_libc_getsockopt (mmux_pointer_t result_optval_p, mmux_socklen_t * result_optlen_p,
		      mmux_libc_network_socket_t sock, mmux_sint_t level, mmux_sint_t optname)
{
  int	rv = getsockopt(sock.value, level, optname, result_optval_p, result_optlen_p);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_setsockopt (mmux_libc_network_socket_t sock, mmux_sint_t level, mmux_sint_t optname,
		      mmux_pointer_t optval_p, mmux_socklen_t optlen)
{
  int	rv = setsockopt(sock.value, level, optname, optval_p, optlen);

  return ((0 == rv)? false : true);
}

/* end of file */
