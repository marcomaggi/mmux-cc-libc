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

#undef  MMUX_LIBC_IPFOUR_ADDR_RESET
#define MMUX_LIBC_IPFOUR_ADDR_RESET(ADDRESS)	\
  (memset((ADDRESS), '\0', sizeof(mmux_libc_internet_protocol_address_four_t)))

#undef  MMUX_LIBC_IPSIX_ADDR_RESET
#define MMUX_LIBC_IPSIX_ADDR_RESET(ADDRESS)	\
  (memset((ADDRESS), '\0', sizeof(mmux_libc_internet_protocol_address_six_t)))


/** --------------------------------------------------------------------
 ** Struct dumpers helpers.
 ** ----------------------------------------------------------------- */

static void
sa_family_to_asciiz_name(mmux_asciizcp_t * name_p, mmux_libc_network_address_family_t sa_family)
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
socket_communication_style_to_asciiz_name(mmux_asciizcp_t* name_p, mmux_libc_socket_communication_style_t style)
{
  switch (style.value) {
#if (defined MMUX_HAVE_LIBC_SOCK_STREAM)
  case MMUX_LIBC_VALUEOF_SOCK_STREAM:
    *name_p = "SOCK_STREAM";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_DGRAM)
  case MMUX_LIBC_VALUEOF_SOCK_DGRAM:
    *name_p = "SOCK_DGRAM";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_DCCP)
  case MMUX_LIBC_VALUEOF_SOCK_DCCP:
    *name_p = "SOCK_DCCP";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_PACKET)
  case MMUX_LIBC_VALUEOF_SOCK_PACKET:
    *name_p = "SOCK_PACKET";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_RAW)
  case MMUX_LIBC_VALUEOF_SOCK_RAW:
    *name_p = "SOCK_RAW";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_RDM)
  case MMUX_LIBC_VALUEOF_SOCK_RDM:
    *name_p = "SOCK_RDM";
    break;
#endif

#if (defined MMUX_HAVE_LIBC_SOCK_SEQPACKET)
  case MMUX_LIBC_VALUEOF_SOCK_SEQPACKET:
    *name_p = "SOCK_SEQPACKET";
    break;
#endif

  default:
    break;
  }
}

/* ------------------------------------------------------------------ */

static void
socket_internet_protocol_to_asciiz_name(mmux_asciizcp_t* name_p, mmux_libc_network_internet_protocol_t protocol)
{
  switch (protocol.value) {
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
 ** Types handling.
 ** ----------------------------------------------------------------- */

mmux_libc_network_port_number_t
mmux_libc_network_port_number_from_host_byteorder_value (mmux_libc_host_byteorder_uint16_t host_byteorder_value)
{
  mmux_libc_network_byteorder_uint16_t	network_byteorder_value;

  mmux_libc_htons(&network_byteorder_value, host_byteorder_value);
  return (mmux_libc_network_port_number_t) { .value = network_byteorder_value.value };
}


/** --------------------------------------------------------------------
 ** Interface naming.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_if_index_set (mmux_libc_if_nameindex_t struct_p, mmux_libc_network_interface_index_t new_field_value)
{
  struct_p->if_index = new_field_value.value;
  return false;
}
bool
mmux_libc_if_index_ref (mmux_libc_network_interface_index_t * field_value_result_p, mmux_libc_if_nameindex_arg_t struct_p)
{
  *field_value_result_p = mmux_libc_network_interface_index(struct_p->if_index);
  return false;
}

bool
mmux_libc_if_name_set (mmux_libc_if_nameindex_t struct_p, mmux_asciizcp_t new_field_value)
{
  struct_p->if_name = (mmux_asciizp_t)new_field_value;
  return false;
}
bool
mmux_libc_if_name_ref (mmux_asciizcpp_t field_value_result_p, mmux_libc_if_nameindex_arg_t struct_p)
{
  *field_value_result_p = mmux_asciizp(struct_p->if_name);
  return false;
}

bool
mmux_libc_if_nameindex_dump (mmux_libc_fd_arg_t fd, mmux_libc_if_nameindex_arg_t nameindex_p, mmux_asciizcp_t struct_name)
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
mmux_libc_if_nametoindex (mmux_libc_network_interface_index_t * index_result_p, mmux_asciizcp_t network_interface_name)
{
  mmux_standard_uint_t	rv = if_nametoindex(network_interface_name);

  if (0 < rv) {
    *index_result_p = mmux_libc_network_interface_index(rv);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_if_indextoname (mmux_asciizp_t buffer, mmux_libc_network_interface_index_t index)
{
  char *	rv = if_indextoname(index.value, buffer);

  return ((NULL != rv)? false : true);
}
bool
mmux_libc_if_nameindex (mmux_libc_network_interface_name_index_t const * * result_nameindex_p)
{
  auto	nameindex_p = (mmux_libc_network_interface_name_index_t const *) if_nameindex();

  if (NULL != nameindex_p) {
    *result_nameindex_p = nameindex_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_if_freenameindex (mmux_libc_network_interface_name_index_t const * nameindex_array)
{
  if_freenameindex(nameindex_array);
  return false;
}


/** --------------------------------------------------------------------
 ** Byte order.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_htons (mmux_libc_network_byteorder_uint16_t * result_p, mmux_libc_host_byteorder_uint16_t value)
{
  *result_p = mmux_libc_network_byteorder_uint16(htons(value.value));
  return false;
}
bool
mmux_libc_ntohs (mmux_libc_host_byteorder_uint16_t * result_p, mmux_libc_network_byteorder_uint16_t value)
{
  *result_p = mmux_libc_host_byteorder_uint16(ntohs(value.value));
  return false;
}
bool
mmux_libc_htonl (mmux_libc_network_byteorder_uint32_t * result_p, mmux_libc_host_byteorder_uint32_t value)
{
  *result_p = mmux_libc_network_byteorder_uint32(htonl(value.value));
  return false;
}
bool
mmux_libc_ntohl (mmux_libc_host_byteorder_uint32_t * result_p, mmux_libc_network_byteorder_uint32_t value)
{
  *result_p = mmux_libc_host_byteorder_uint32(ntohl(value.value));
  return false;
}


/** --------------------------------------------------------------------
 ** Struct ipfour_addr.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_s_addr_set (mmux_libc_ipfour_addr_t ipfour_addr, mmux_libc_network_byteorder_uint32_t value)
{
  /* The field  "s_addr" of "struct  in_addr" is  a "uint32_t" in  network byteorder,
     which is big-endian.  When in doubt about it: read the manual page ip(7). */
  ipfour_addr->value->s_addr = value.value;
  return false;
}
bool
mmux_libc_s_addr_ref (mmux_libc_network_byteorder_uint32_t * result_p, mmux_libc_ipfour_addr_arg_t ipfour_addr)
{
  *result_p = mmux_libc_network_byteorder_uint32(ipfour_addr->value->s_addr);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_make_ipfour_addr (mmux_libc_ipfour_addr_t address_result,
			    mmux_libc_network_byteorder_uint32_t raw_address)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  /* Stored in network byte order. */
  address_result->value->s_addr = raw_address.value;
  return false;
}
static bool
mmux_libc_make_ipfour_addr_from_struct_in_addr (mmux_libc_ipfour_addr_t address_result, struct in_addr input_address)
/* This is reserved for internal use only. */
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  address_result->value[0] = input_address;
  return false;
}
bool
mmux_libc_make_ipfour_addr_none (mmux_libc_ipfour_addr_t address_result)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  {
    mmux_libc_network_byteorder_uint32_t	raw_address;

    mmux_libc_htonl(&raw_address, MMUX_LIBC_INADDR_NONE);
    return mmux_libc_make_ipfour_addr(address_result, raw_address);
  }
}
bool
mmux_libc_make_ipfour_addr_any (mmux_libc_ipfour_addr_t address_result)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  {
    mmux_libc_network_byteorder_uint32_t	raw_address;

    mmux_libc_htonl(&raw_address, MMUX_LIBC_INADDR_ANY);
    return mmux_libc_make_ipfour_addr(address_result, raw_address);
  }
}
bool
mmux_libc_make_ipfour_addr_broadcast (mmux_libc_ipfour_addr_t address_result)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  {
    mmux_libc_network_byteorder_uint32_t	raw_address;

    mmux_libc_htonl(&raw_address, MMUX_LIBC_INADDR_BROADCAST);
    return mmux_libc_make_ipfour_addr(address_result, raw_address);
  }
}
bool
mmux_libc_make_ipfour_addr_loopback (mmux_libc_ipfour_addr_t address_result)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  {
    mmux_libc_network_byteorder_uint32_t	raw_address;

    mmux_libc_htonl(&raw_address, MMUX_LIBC_INADDR_LOOPBACK);
    return mmux_libc_make_ipfour_addr(address_result, raw_address);
  }
}
bool
mmux_libc_make_ipfour_addr_from_asciiz (mmux_libc_ipfour_addr_t address_result, mmux_asciizcp_t dotted_quad)
{
  return mmux_libc_inet_pton(address_result, MMUX_LIBC_AF_INET, dotted_quad);
}
bool
mmux_libc_ipfour_addr_reset (mmux_libc_ipfour_addr_t address)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_ipfour_addr_dump (mmux_libc_fd_arg_t fd, mmux_libc_ipfour_addr_arg_t ipfour_addr, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct in_addr";
  }

  DPRINTF(fd, "%s * = %p\n", struct_name, (mmux_pointerc_t)ipfour_addr);

  {
    mmux_libc_network_byteorder_uint32_t	raw_address_number;

    mmux_libc_s_addr_ref(&raw_address_number, ipfour_addr);

    DPRINTF(fd, "%s.s_addr = 0x%08x", struct_name, raw_address_number.value);
    {
      auto const	provided_nchars = mmux_usize_literal(512);
      char		str[provided_nchars.value];

      if (mmux_libc_inet_ntop(str, provided_nchars, MMUX_LIBC_AF_INET, ipfour_addr)) {
	return true;
      }
      DPRINTF(fd, " (%s) [network byteorder]\n", str);
    }
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_ipfour_addr_equal (bool * result_p,
			     mmux_libc_ipfour_addr_arg_t ipfour_addr_1,
			     mmux_libc_ipfour_addr_arg_t ipfour_addr_2)
{
  mmux_libc_network_byteorder_uint32_t	raw_address_1, raw_address_2;

  mmux_libc_s_addr_ref(&raw_address_1, ipfour_addr_1);
  mmux_libc_s_addr_ref(&raw_address_2, ipfour_addr_2);

  *result_p = (ipfour_addr_1->value->s_addr == ipfour_addr_2->value->s_addr)? true : false;
  return false;
}


/** --------------------------------------------------------------------
 ** Struct ipsix_addr.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_ipsix_addr_loopback (mmux_libc_ipsix_addr_t address_result)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  address_result->value[0] = in6addr_loopback;
  return false;
}
bool
mmux_libc_make_ipsix_addr_any (mmux_libc_ipsix_addr_t address_result)
{
  MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
  address_result->value[0] = in6addr_any;
  return false;
}
bool
mmux_libc_make_ipsix_addr_from_asciiz (mmux_libc_ipsix_addr_t address_result, mmux_asciizcp_t dotted_quad)
{
  return mmux_libc_inet_pton(address_result, MMUX_LIBC_AF_INET6, dotted_quad);
}
bool
mmux_libc_ipsix_addr_reset (mmux_libc_ipsix_addr_t address)
{
  MMUX_LIBC_IPSIX_ADDR_RESET(address);
  return false;
}

bool
mmux_libc_ipsix_addr_dump (mmux_libc_fd_arg_t fd, mmux_libc_ipsix_addr_arg_t ipsix_addr, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct in6_addr";
  }

  DPRINTF(fd, "%s * = %p\n", struct_name, (mmux_pointerc_t)ipsix_addr);

  {
    auto const	provided_nchars = mmux_usize_literal(512);
    char	str[provided_nchars.value];

    if (mmux_libc_inet_ntop(str, provided_nchars, MMUX_LIBC_AF_INET6, (mmux_pointer_t)ipsix_addr)) {
      return true;
    }
    DPRINTF(fd, "%s = (%s)\n", struct_name, str);
  }

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_ipsix_addr_equal (bool * result_p,
			    mmux_libc_ipsix_addr_arg_t ipsix_addr_1,
			    mmux_libc_ipsix_addr_arg_t ipsix_addr_2)
{
  mmux_ternary_comparison_result_t	cmpnum;

  mmux_libc_memcmp(&cmpnum, ipsix_addr_1, ipsix_addr_2, mmux_usize(sizeof(mmux_libc_internet_protocol_address_six_t)));
  *result_p = mmux_ternary_comparison_result_is_equal(cmpnum);
  return false;
}


/** --------------------------------------------------------------------
 ** Struct hostent.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_h_name_set (mmux_libc_hostent_t P, mmux_asciizp_t value)
{
  P->h_name = value;
  return false;
}
bool
mmux_libc_h_name_ref (mmux_asciizpp_t result_p, mmux_libc_hostent_arg_t P)
{
  *result_p = mmux_asciizp(P->h_name);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_h_aliases_set (mmux_libc_hostent_t P, mmux_asciizpp_t value)
{
  P->h_aliases = value;
  return false;
}
bool
mmux_libc_h_aliases_ref (mmux_asciizpp_t result_p, mmux_libc_hostent_arg_t P)
{
  *result_p = mmux_asciizp(P->h_aliases);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_h_addrtype_set (mmux_libc_hostent_t P, mmux_libc_network_address_family_t value)
{
  P->h_addrtype = value.value;
  return false;
}
bool
mmux_libc_h_addrtype_ref (mmux_libc_network_address_family_t * result_p, mmux_libc_hostent_arg_t P)
{
  *result_p = mmux_libc_network_address_family(P->h_addrtype);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_h_length_set (mmux_libc_hostent_t P, mmux_usize_t value)
{
  P->h_length = (int) value.value;
  return false;
}
bool
mmux_libc_h_length_ref (mmux_usize_t * result_p, mmux_libc_hostent_arg_t P)
{
  *result_p = mmux_usize(P->h_length);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_h_addr_list_set (mmux_libc_hostent_t P, mmux_asciizpp_t value)
{
  P->h_addr_list = value;
  return false;
}
bool
mmux_libc_h_addr_list_ref (mmux_asciizpp_t * result_p, mmux_libc_hostent_arg_t P)
{
  *result_p = P->h_addr_list;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_h_addr_set (mmux_libc_hostent_t P, mmux_asciizp_t value)
{
  P->h_addr = value;
  return false;
}
bool
mmux_libc_h_addr_ref (mmux_asciizp_t * result_p, mmux_libc_hostent_arg_t P)
{
  *result_p = P->h_addr;
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_hostent_dump (mmux_libc_fd_arg_t fd, mmux_libc_hostent_arg_t hostent_p, mmux_asciizcp_t struct_name)
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
  case MMUX_LIBC_VALUEOF_AF_INET:
    DPRINTF(fd, " (AF_INET)\n");
    break;
  case MMUX_LIBC_VALUEOF_AF_INET6:
    DPRINTF(fd, " (AF_INET6)\n");
    break;
  default:
    DPRINTF(fd, "\n");
    break;
  }

  /* Dump the field "h_length". */
  {
    if (sizeof(struct in_addr) == hostent_p->h_length) {
      DPRINTF(fd, "%s.h_length = \"%d\" (sizeof(struct in_addr))\n", struct_name, hostent_p->h_length);
    } else if (sizeof(struct in6_addr) == hostent_p->h_length) {
      DPRINTF(fd, "%s.h_length = \"%d\" (sizeof(struct in6_addr))\n", struct_name, hostent_p->h_length);
    } else {
      DPRINTF(fd, "%s.h_length = \"%d\"\n", struct_name, hostent_p->h_length);
    }
  }


  if (NULL != hostent_p->h_addr_list) {
    auto const	provided_nchars = mmux_usize_literal(512);

    for (; hostent_p->h_addr_list[addr_list_idx]; ++addr_list_idx) {
      char	presentation_buf[provided_nchars.value];

      inet_ntop(hostent_p->h_addrtype, hostent_p->h_addr_list[addr_list_idx], presentation_buf, provided_nchars.value);
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

/* ------------------------------------------------------------------ */

bool
mmux_libc_sethostent (bool stayopen)
{
  sethostent((mmux_standard_sint_t)stayopen);
  return false;
}
bool
mmux_libc_endhostent (void)
{
  endhostent();
  return false;
}
bool
mmux_libc_gethostent (bool * there_is_one_more_p, mmux_libc_hostent_t hostent_result)
{
  struct hostent *	rv = gethostent();

  /* Yes, we  are copying  the whole  data structure: it  is just  a small  number of
     machine words, and  doing it makes the "/etc/hosts" database  access API uniform
     with the way other APIs are implemented. */
  if (rv) {
    *hostent_result = *((mmux_libc_network_database_host_t *) rv);
    *there_is_one_more_p = true;
  } else {
    *there_is_one_more_p = false;
  }
  return false;
}


/** --------------------------------------------------------------------
 ** Struct servent.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_s_name_set (mmux_libc_servent_t P, mmux_asciizp_t value)
{
  P->s_name = value;
  return false;
}
bool
mmux_libc_s_name_ref (mmux_asciizpp_t result_p, mmux_libc_servent_arg_t P)
{
  *result_p = mmux_asciizp(P->s_name);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_s_aliases_set (mmux_libc_servent_t P, mmux_asciizpp_t value)
{
  P->s_aliases = value;
  return false;
}
bool
mmux_libc_s_aliases_ref (mmux_asciizpp_t result_p, mmux_libc_servent_arg_t P)
{
  *result_p = mmux_asciizp(P->s_aliases);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_s_port_set (mmux_libc_servent_t P, mmux_libc_network_port_number_t value)
{
  P->s_port = (int)value.value;
  return false;
}
bool
mmux_libc_s_port_ref (mmux_libc_network_port_number_t * result_p, mmux_libc_servent_arg_t P)
{
  *result_p = mmux_libc_network_port_number(mmux_libc_network_byteorder_uint16(P->s_port));
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_s_proto_set (mmux_libc_servent_t P, mmux_asciizp_t value)
{
  P->s_proto = value;
  return false;
}
bool
mmux_libc_s_proto_ref (mmux_asciizpp_t result_p, mmux_libc_servent_arg_t P)
{
  *result_p = mmux_asciizp(P->s_proto);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_servent_dump (mmux_libc_fd_arg_t fd, mmux_libc_servent_arg_t servent_p, mmux_asciizcp_t struct_name)
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

  DPRINTF(fd, "%s.s_port = 0x%X [network byteorder] (host byteorder: %u)\n",
	  struct_name, servent_p->s_port, ntohs(servent_p->s_port));
  DPRINTF(fd, "%s.s_proto = \"%s\"\n", struct_name, servent_p->s_proto);

  return false;
}

bool
mmux_libc_setservent (bool stayopen)
{
  setservent((mmux_standard_sint_t)stayopen);
  return false;
}
bool
mmux_libc_endservent (void)
{
  endservent();
  return false;
}
bool
mmux_libc_getservent (bool * there_is_one_more_p, mmux_libc_servent_t servent_result)
{
  struct servent *	rv = getservent();

  /* Yes, we  are copying  the whole  data structure: it  is just  a small  number of
     machine  words, and  doing  it  makes the  "/etc/services"  database access  API
     uniform with the way other APIs are implemented. */
  if (rv) {
    *servent_result = *((mmux_libc_network_database_service_t *) rv);
    *there_is_one_more_p = true;
  } else {
    *there_is_one_more_p = false;
  }
  return false;
}
bool
mmux_libc_getservbyname (bool * there_is_one_p, mmux_libc_servent_t servent_result,
			 mmux_asciizcp_t service_name_p, mmux_asciizcp_t protocol_name_p)
{
  struct servent *	rv = getservbyname(service_name_p, protocol_name_p);

  /* Yes, we  are copying  the whole  data structure: it  is just  a small  number of
     machine  words, and  doing  it  makes the  "/etc/services"  database access  API
     uniform with the way other APIs are implemented. */
  if (rv) {
    *servent_result = *((mmux_libc_network_database_service_t *) rv);
    *there_is_one_p = true;
  } else {
    *there_is_one_p = false;
  }
  return false;
}
bool
mmux_libc_getservbyport (bool * there_is_one_p, mmux_libc_servent_t servent_result,
			 mmux_libc_network_port_number_t port, mmux_asciizcp_t protocol_name_p)
{
  struct servent *	rv = getservbyport(port.value, protocol_name_p);

  /* Yes, we  are copying  the whole  data structure: it  is just  a small  number of
     machine  words, and  doing  it  makes the  "/etc/services"  database access  API
     uniform with the way other APIs are implemented. */
  if (rv) {
    *servent_result = *((mmux_libc_network_database_service_t *) rv);
    *there_is_one_p = true;
  } else {
    *there_is_one_p = false;
  }
  return false;
}


/** --------------------------------------------------------------------
 ** Internet Protocols database.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_p_name_set (mmux_libc_protoent_t P, mmux_asciizp_t value)
{
  P->p_name = value;
  return false;
}
bool
mmux_libc_p_name_ref (mmux_asciizpp_t result_p, mmux_libc_protoent_arg_t P)
{
  *result_p = mmux_asciizp(P->p_name);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_p_aliases_set (mmux_libc_protoent_t P, mmux_asciizpp_t value)
{
  P->p_aliases = value;
  return false;
}
bool
mmux_libc_p_aliases_ref (mmux_asciizpp_t result_p, mmux_libc_protoent_arg_t P)
{
  *result_p = mmux_asciizp(P->p_aliases);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_p_proto_set (mmux_libc_protoent_t P, mmux_libc_network_internet_protocol_t value)
{
  P->p_proto = value.value;
  return false;
}
bool
mmux_libc_p_proto_ref (mmux_libc_network_internet_protocol_t * result_p, mmux_libc_protoent_arg_t P)
{
  *result_p = mmux_libc_network_internet_protocol(P->p_proto);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_protoent_dump (mmux_libc_fd_arg_t fd, mmux_libc_protoent_arg_t protoent_p, mmux_asciizcp_t struct_name)
{
  int	aliases_idx = 0;

  if (NULL == struct_name) {
    struct_name = "struct protoent";
  }

  DPRINTF(fd, "%s.p_name = \"%s\"\n", struct_name, protoent_p->p_name);

  if (NULL != protoent_p->p_aliases) {
    for (; protoent_p->p_aliases[aliases_idx]; ++aliases_idx) {
      DPRINTF(fd, "%s.p_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, protoent_p->p_aliases[aliases_idx]);
    }
  }
  if (0 == aliases_idx) {
    DPRINTF(fd, "%s.p_aliases = \"0x0\"\n", struct_name);
  }

  DPRINTF(fd, "%s.s_proto = \"%d\"\n", struct_name, protoent_p->p_proto);

  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_setprotoent (bool stayopen)
{
  setprotoent((mmux_standard_sint_t)stayopen);
  return false;
}
bool
mmux_libc_endprotoent (void)
{
  endprotoent();
  return false;
}
bool
mmux_libc_getprotoent (bool * there_is_one_more_p, mmux_libc_protoent_t protoent_result)
{
  struct protoent *	rv = getprotoent();

  /* Yes, we  are copying  the whole  data structure: it  is just  a small  number of
     machine  words, and  doing it  makes  the "/etc/protocols"  database access  API
     uniform with the way other APIs are implemented. */
  if (rv) {
    *protoent_result = *((mmux_libc_network_database_protocol_t *) rv);
    *there_is_one_more_p = true;
  } else {
    *there_is_one_more_p = false;
  }
  return false;
}
bool
mmux_libc_getprotobyname (bool * there_is_one_p,
			  mmux_libc_protoent_t protoent_result, mmux_asciizcp_t protocol_name_p)
{
  struct protoent *	rv = getprotobyname(protocol_name_p);

  if (rv) {
    *protoent_result = *((mmux_libc_network_database_protocol_t *) rv);
    *there_is_one_p  = true;
  } else {
    *there_is_one_p  = false;
  }
  return false;
}
bool
mmux_libc_getprotobynumber (bool * there_is_one_p,
			    mmux_libc_protoent_t protoent_result,
			    mmux_libc_network_internet_protocol_t protocol)
{
  struct protoent *	rv = getprotobynumber(protocol.value);

  if (rv) {
    *protoent_result = *((mmux_libc_network_database_protocol_t *) rv);
    *there_is_one_p  = true;
  } else {
    *there_is_one_p  = false;
  }
  return false;
}

#if 0


/** --------------------------------------------------------------------
 ** Networks database.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_setnetent (bool stayopen)
{
  setnetent((mmux_standard_sint_t)stayopen);
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
mmux_libc_getnetbyaddr (mmux_libc_netent_t const * * result_netent_pp,
			mmux_libc_host_byteorder_uint32_t network_number,
			mmux_libc_network_address_family_t family)
{
  mmux_libc_netent_t const *	netent_p = getnetbyaddr(network_number.value, family.value);

  if (netent_p) {
    *result_netent_pp = netent_p;
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Struct netent.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_ASCIIZP_SETTER_GETTER(netent,	n_name)
DEFINE_STRUCT_ASCIIZPP_SETTER_GETTER(netent,	n_aliases)
DEFINE_STRUCT_SETTER_GETTER(netent,		n_addrtype,	sint)
DEFINE_STRUCT_SETTER_GETTER(netent,		n_net,		ulong)

bool
mmux_libc_netent_dump (mmux_libc_fd_arg_t fd, mmux_libc_netent_t const * netent_p, mmux_asciizcp_t struct_name)
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
    auto		field_value = mmux_libc_network_address_family(netent_p->n_addrtype);
    mmux_asciizcp_t	name;

    sa_family_to_asciiz_name(&name, field_value);
    DPRINTF(fd, "%s.n_addrtype = \"%d\" (%s)\n", struct_name, (int)field_value.value, name);
  }

  /* The value "netent_p->n_net" is in host byte order. */
  {
    auto const	buflen = mmux_libc_socklen_literal(512);
    char	net_str[buflen.value];
    auto	network_byteorder_net = mmux_uint32(htonl(netent_p->n_net));

    inet_ntop(netent_p->n_addrtype, &(network_byteorder_net.value), net_str, buflen.value);

    DPRINTF(fd, "%s.n_net = \"%lu\" (%s)\n", struct_name, (mmux_standard_ulong_t)(netent_p->n_net), net_str);
  }
  return false;
}


/** --------------------------------------------------------------------
 ** Struct sockaddr.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(sockaddr, sa_family,	libc_socket_address_family)

bool
mmux_libc_sockaddr_dump (mmux_libc_fd_arg_t fd,
			 mmux_libc_sockaddr_t const * sockaddr_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr";
  }

  {
    mmux_libc_network_address_family_t	sa_family;
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
mmux_libc_sun_path_set (mmux_libc_sockaddr_un_t * const P, mmux_libc_fs_ptn_arg_t fs_ptn)
{
  /* Check if the input pathname is too long  to fit in the data structure along with
     its terminating nul;  we do not want  to truncate it.  Notice  that the pathname
     stored in  the struct MUST be  terminated by a nul:  if it is not,  the standard
     functions will fail. */
  if ((sizeof(P->sun_path) - 1) < strlen(fs_ptn->value)) {
    return true;
  } else {
    /* This chunk comes from the documentation of GLIBC. */
    strncpy(P->sun_path, fs_ptn->value, sizeof(P->sun_path));
    P->sun_path[sizeof(P->sun_path) - 1] = '\0';
    return false;
  }
}
bool
mmux_libc_sun_path_ref (mmux_libc_fs_ptn_t fs_ptn_result, mmux_libc_sockaddr_un_t const * const P)
{
  /* FIXME  Add the  factory as  argument to  this function.   (Marco Maggi;  Oct 22,
     2025) */
  mmux_libc_fs_ptn_factory_copying_t	fs_ptn_factory;

  mmux_libc_file_system_pathname_factory_dynamic(fs_ptn_factory);
  return mmux_libc_make_file_system_pathname(fs_ptn_result, fs_ptn_factory, P->sun_path);
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
mmux_libc_sockaddr_un_dump (mmux_libc_fd_arg_t fd, mmux_libc_sockaddr_un_t const * sockaddr_un_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr_un";
  }

  {
    mmux_asciizcp_t			sun_name = "unknown";
    mmux_libc_network_address_family_t	family;

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

bool
mmux_libc_sin_family_set (mmux_libc_sockaddr_in_t * P, mmux_libc_network_address_family_t new_field_value)
{
  P->sin_family = new_field_value.value;
  return false;
}
bool
mmux_libc_sin_family_ref (mmux_libc_network_address_family_t * field_value_result_p, mmux_libc_sockaddr_in_t const * P)
{
  *field_value_result_p = mmux_libc_network_address_family(P->sin_family);
  return false;
}

bool
mmux_libc_sin_addr_set (mmux_libc_sockaddr_in_t * P, mmux_libc_ipfour_addr_arg_t new_field_value)
{
  P->sin_addr.s_addr = new_field_value->s_addr;
  return false;
}
bool
mmux_libc_sin_addr_ref (mmux_libc_ipfour_addr_t field_value_result, mmux_libc_sockaddr_in_t const * P)
{
  field_value_result->s_addr = P->sin_addr.s_addr;
  return false;
}
bool
mmux_libc_sin_port_set (mmux_libc_sockaddr_in_t * const P, mmux_libc_host_byteorder_uint16_t host_byteorder_value)
{
  mmux_libc_network_byteorder_uint16_t	network_byteorder_value;

  mmux_libc_htons(&network_byteorder_value, host_byteorder_value);
  P->sin_port = network_byteorder_value.value;
  return false;
}
bool
mmux_libc_sin_port_ref (mmux_libc_host_byteorder_uint16_t * result_host_byteorder_p, mmux_libc_sockaddr_in_t const * const P)
{
  auto					network_byteorder_value = mmux_libc_network_byteorder_uint16( P->sin_port );

  mmux_libc_ntohs(result_host_byteorder_p, network_byteorder_value);
  return false;
}

bool
mmux_libc_sin_addr_pp_ref (mmux_libc_ipfour_addr_t ** sin_addr_pp, mmux_libc_sockaddr_in_t * sockaddr_p)
{
  *sin_addr_pp = (mmux_libc_ipfour_addr_t *) &(sockaddr_p->sin_addr);
  return false;
}

bool
mmux_libc_sockaddr_in_dump (mmux_libc_fd_arg_t fd, mmux_libc_sockaddr_in_t const * sockaddr_in_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr_in";
  }

  /* Dump the field "sin_family". */
  {
    auto		field_value = mmux_libc_network_address_family(sockaddr_in_p->sin_family);
    mmux_asciizcp_t	sin_name = "unknown";

    sa_family_to_asciiz_name(&sin_name, field_value);
    DPRINTF(fd, "%s.sin_family = \"%d\" (%s)\n", struct_name, sockaddr_in_p->sin_family, sin_name);
  }

  /* Dump the field "sin_addr". */
  {
    mmux_libc_network_address_family_t	family;
    mmux_libc_ipfour_addr_t		addr;

    auto const	provided_nchars = mmux_usize_literal(512);
    char	presentation_buf[provided_nchars.value];

    mmux_libc_sin_family_ref (&family, sockaddr_in_p);
    mmux_libc_sin_addr_ref   (addr,    sockaddr_in_p);

    mmux_libc_inet_ntop(presentation_buf, provided_nchars, family, addr);
    presentation_buf[provided_nchars.value - 1] = '\0';
    DPRINTF(fd, "%s.sin_addr = \"%s\"\n", struct_name, presentation_buf);
  }

  /* Dump the field "sin_port". */
  {
    DPRINTF(fd, "%s.sin_port = \"%d\"\n", struct_name, (int)ntohs(sockaddr_in_p->sin_port));
  }
  return false;
}


/** --------------------------------------------------------------------
 ** Struct sockaddr_in6.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_sinsix_family_set (mmux_libc_sockaddr_in_t * P, mmux_libc_network_address_family_t new_field_value)
{
  P->sinsix_family = new_field_value.value;
  return false;
}
bool
mmux_libc_sinsix_family_ref (mmux_libc_network_address_family_t * field_value_result_p, mmux_libc_sockaddr_in_t const * P)
{
  *field_value_result_p = mmux_libc_network_address_family(P->sinsix_family);
  return false;
}


DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_family,   libc_socket_address_family,  sinsix_family)
DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_addr,     libc_ipsix_addr,	      sipsix_addr)
DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_flowinfo, uint32,		      sinsix_flowinfo)
DEFINE_STRUCT_SETTER_GETTER_SPLIT(sockaddr_insix, sin6_scope_id, uint32,		      sinsix_scope_id)

/* ------------------------------------------------------------------ */

bool
mmux_libc_sinsix_port_set (mmux_libc_sockaddr_insix_t * const P, mmux_libc_host_byteorder_uint16_t host_byteorder_value)
{
  mmux_libc_network_byteorder_uint16_t	network_byteorder_value;

  mmux_libc_htons(&network_byteorder_value, host_byteorder_value);
  P->sin6_port = network_byteorder_value.value;
  return false;
}
bool
mmux_libc_sinsix_port_ref (mmux_libc_host_byteorder_uint16_t * result_host_byteorder_p, mmux_libc_sockaddr_insix_t const * const P)
{
  auto	network_byteorder_value = mmux_libc_network_byteorder_uint16( P->sin6_port );

  mmux_libc_ntohs(result_host_byteorder_p, network_byteorder_value);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_sipsix_addr_p_ref (mmux_libc_ipsix_addr_t ** sipsix_addr_pp, mmux_libc_sockaddr_insix_t const * sockaddr_p)
{
  *sipsix_addr_pp = (mmux_libc_ipsix_addr_t *) &(sockaddr_p->sin6_addr);
  return false;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_sockaddr_insix_dump (mmux_libc_fd_arg_t fd, mmux_libc_sockaddr_insix_t const * sockaddr_insix_p,
			       mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct sockaddr_in6";
  }

  /* Dump the field "sin6_family". */
  {
    auto		field_value = mmux_libc_network_address_family(sockaddr_insix_p->sin6_family);
    mmux_asciizcp_t	sin6_name = "unknown";

    sa_family_to_asciiz_name(&sin6_name, field_value);
    DPRINTF(fd, "%s.sin6_family = \"", struct_name);
    MMUX_LIBC_CALL(mmux_sshort_dprintf_p(fd->value, &field_value));
    DPRINTF(fd, "\" (%s)\n", sin6_name);
  }

  /* Dump the field "sin6_addr". */
  {
    mmux_libc_network_address_family_t	family;
    mmux_libc_ipsix_addr_t *		addr_p;
    auto const				provided_nchars = mmux_usize_literal(512);
    char				bufptr[provided_nchars.value];

    MMUX_LIBC_CALL(mmux_libc_sinsix_family_ref(&family, sockaddr_insix_p));
    MMUX_LIBC_CALL(mmux_libc_sipsix_addr_p_ref(&addr_p, sockaddr_insix_p));
    MMUX_LIBC_CALL(mmux_libc_inet_ntop(bufptr, provided_nchars, family, addr_p));
    bufptr[provided_nchars.value - 1] = '\0';
    DPRINTF(fd, "%s.sin6_addr = \"%s\"\n", struct_name, bufptr);
  }

  DPRINTF(fd, "%s.sin6_flowinfo = \"%lu\"\n", struct_name, (mmux_standard_ulong_t)(sockaddr_insix_p->sin6_flowinfo));
  DPRINTF(fd, "%s.sin6_scope_id = \"%lu\"\n", struct_name, (mmux_standard_ulong_t)(sockaddr_insix_p->sin6_scope_id));
  DPRINTF(fd, "%s.sin6_port = \"%d\"\n",      struct_name, ntohs(sockaddr_insix_p->sin6_port));
  return false;
}


/** --------------------------------------------------------------------
 ** Struct addrinfo.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_flags,		sint)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_family,	sint)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_socktype,	sint)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_protocol,	sint)
DEFINE_STRUCT_SETTER_GETTER(addrinfo, ai_addrlen,	libc_socklen)

bool
mmux_libc_ai_addr_set (mmux_libc_addrinfo_ptr_t const P, mmux_libc_sockaddr_ptr_t value)
{
  P->ai_addr = value;
  return false;
}
bool
mmux_libc_ai_addr_ref (mmux_libc_sockaddr_ptr_t * result_p, mmux_libc_addrinfo_t const * const P)
{
  *result_p = (mmux_libc_sockaddr_ptr_t)(P->ai_addr);
  return false;
}

bool
mmux_libc_ai_next_set (mmux_libc_addrinfo_ptr_t const P, mmux_libc_addrinfo_ptr_t value)
{
  P->ai_next = value;
  return false;
}
bool
mmux_libc_ai_next_ref (mmux_libc_addrinfo_ptr_t * result_p, mmux_libc_addrinfo_t const * const P)
{
  *result_p = (mmux_libc_addrinfo_ptr_t)(P->ai_next);
  return false;
}

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
mmux_libc_addrinfo_dump (mmux_libc_fd_arg_t fd, mmux_libc_addrinfo_t const * addrinfo_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct addrinfo";
  }

  /* Inspect the field: ai_flags */
  {
    bool	not_first_flags = false;

    DPRINTF(fd, "%s.ai_flags = \"%d\"", struct_name, addrinfo_p->ai_flags);

    if (AI_ADDRCONFIG & addrinfo_p->ai_flags) {
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
    auto		field_value = mmux_libc_network_address_family(addrinfo_p->ai_family);
    mmux_asciizcp_t	ai_name = "unknown";

    sa_family_to_asciiz_name(&ai_name, field_value);
    DPRINTF(fd, "%s.ai_family = \"%d\" (%s)\n", struct_name, (int)field_value.value, ai_name);
  }

  /* Inspect the field: ai_socktype */
  {
    auto		style   = mmux_libc_socket_communication_style(addrinfo_p->ai_socktype);
    mmux_asciizcp_t	ai_name = "unknown";

    socket_communication_style_to_asciiz_name(&ai_name, style);
    DPRINTF(fd, "%s.ai_socktype = \"%d\" (%s)\n", struct_name, style.value, ai_name);
  }

  /* Inspect the field: ai_protocol */
  {
    auto		protocol = mmux_libc_network_internet_protocol(addrinfo_p->ai_protocol);
    mmux_asciizcp_t	ai_name  = "unknown";

    socket_internet_protocol_to_asciiz_name(&ai_name, protocol);
    DPRINTF(fd, "%s.ai_protocol = \"%d\" (%s)\n", struct_name, protocol.value, ai_name);
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
    char	bufstr[provided_nchars.value];

    mmux_libc_memzero(bufstr, provided_nchars);
    inet_ntop(addrinfo_p->ai_family, &(addrinfo_p->ai_addr), bufstr, provided_nchars.value);

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
 ** Address conversion to/from ASCII presentation.
 ** ----------------------------------------------------------------- */

#endif

bool
mmux_libc_inet_aton (mmux_libc_ipfour_addr_t address_result, mmux_asciizcp_t input_presentation_p)
{
  struct in_addr	ad;
  int			rv = inet_aton(input_presentation_p, &ad);

  if (0 != rv) {
    MMUX_LIBC_IPFOUR_ADDR_RESET(address_result);
    address_result->value[0] = ad;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_inet_ntoa (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
		     mmux_libc_ipfour_addr_arg_t input_addr_p)
{
  /* This is the dotted-quad string. */
  mmux_asciizcp_t	presentation_ptr = inet_ntoa(input_addr_p->value[0]);
  mmux_usize_t		presentation_len;

  mmux_libc_strlen(&presentation_len, presentation_ptr);

  /* The number of bytes "ouput_presentation_provided_nchars" is meant to include the
     trailing nul character.  The number of bytes "presentation_len" does not include
     the trailing nul character. */
  if (mmux_ctype_greater(ouput_presentation_provided_nchars, presentation_len)) {
    strncpy(ouput_presentation_p, presentation_ptr, ouput_presentation_provided_nchars.value);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_inet_pton (mmux_libc_ip_addr_t address_result,
		     mmux_libc_network_address_family_t family, mmux_asciizcp_t input_presentation_p)
{
  switch (family.value) {
  case AF_INET:
    {
      struct in_addr	ad;
      int		rv = inet_pton(family.value, input_presentation_p, &ad);

      if (0 != rv) {
	auto	the_address_result = (mmux_libc_internet_protocol_address_four_t *) address_result;

	MMUX_LIBC_IPFOUR_ADDR_RESET(the_address_result);
	the_address_result->value[0] = ad;
	return false;
      } else {
	return true;
      }
    }
  case AF_INET6:
    {
      struct in6_addr	ad;
      int		rv = inet_pton(family.value, input_presentation_p, &ad);

      if (0 != rv) {
	auto	the_address_result = (mmux_libc_internet_protocol_address_six_t *) address_result;

	MMUX_LIBC_IPSIX_ADDR_RESET(the_address_result);
	the_address_result->value[0] = ad;
	return false;
      } else {
	return true;
      }
    }
  default:
    return true;
  }
}
bool
mmux_libc_inet_ntop (mmux_asciizp_t ouput_presentation_p, mmux_usize_t ouput_presentation_provided_nchars,
		     mmux_libc_network_address_family_t family,
		     mmux_libc_ip_addr_arg_t input_addr)
{
  auto const		provided_nchars = mmux_usize_literal(512);
  char			presentation[provided_nchars.value];
  mmux_asciizcp_t	rv = inet_ntop(family.value, input_addr, presentation, provided_nchars.value);

  if (NULL != rv) {
    auto	presentation_generated_nchars = mmux_usize_strlen(presentation);

    if (mmux_ctype_greater(ouput_presentation_provided_nchars, presentation_generated_nchars)) {
      return mmux_libc_strncpy(ouput_presentation_p, presentation, ouput_presentation_provided_nchars);
    }
  }
  return true;
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_inet_addr (mmux_libc_ipfour_addr_t result_ip_addr_p, mmux_asciizcp_t presentation_ip_addr_p)
{
  /* The return value of "inet_addr()" is in network byteorder. */
  auto	raw_address = mmux_libc_network_byteorder_uint32(inet_addr(presentation_ip_addr_p));

  if (MMUX_LIBC_VALUEOF_INADDR_NONE != raw_address.value) {
    return mmux_libc_make_ipfour_addr(result_ip_addr_p, raw_address);
  } else {
    return true;
  }
}
bool
mmux_libc_inet_network (mmux_libc_ipfour_addr_t address_result, mmux_asciizcp_t presentation_ip_addr_p)
{
  /* The function "inet_network()" returns a value in host byteorder. */
  auto	rv = mmux_libc_host_byteorder_uint32(inet_network(presentation_ip_addr_p));

  if (MMUX_LIBC_VALUEOF_INADDR_NONE != rv.value) {
    mmux_libc_network_byteorder_uint32_t	raw_address;

    mmux_libc_htonl(&raw_address, rv);
    return mmux_libc_make_ipfour_addr(address_result, raw_address);
  } else {
    return true;
  }
}
bool
mmux_libc_inet_makeaddr (mmux_libc_ipfour_addr_t ipfour_addr_result,
			 mmux_libc_host_byteorder_uint32_t network_address_number,
			 mmux_libc_host_byteorder_uint32_t local_address_number)
{
  struct in_addr	addr = inet_makeaddr(network_address_number.value, local_address_number.value);
  auto			raw_address = mmux_libc_network_byteorder_uint32(addr.s_addr);

  return mmux_libc_make_ipfour_addr(ipfour_addr_result, raw_address);
}
bool
mmux_libc_inet_lnaof (mmux_libc_host_byteorder_uint32_t * local_address_number_result_p,
		      mmux_libc_ipfour_addr_arg_t ipfour_addr)
{
  *local_address_number_result_p = mmux_libc_host_byteorder_uint32(inet_lnaof(ipfour_addr->value[0]));
  return false;
}
bool
mmux_libc_inet_netof (mmux_libc_host_byteorder_uint32_t * network_address_number_result_p,
		      mmux_libc_ipfour_addr_arg_t ipfour_addr)
{
  *network_address_number_result_p = mmux_libc_host_byteorder_uint32(inet_netof(ipfour_addr->value[0]));
  return false;
}

bool
mmux_libc_inet_net_pton (mmux_libc_ip_addr_t address_result,
			 mmux_uint_t * number_of_bits_result,
			 mmux_libc_network_address_family_t family,
			 mmux_asciizcp_t presentation)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_INET_NET_PTON]]],[[[
  if (MMUX_LIBC_VALUEOF_AF_INET == family.value) {
    struct in_addr	result = { .s_addr = mmux_standard_uint32_constant_zero() };
    int			rv = inet_net_pton(family.value, presentation, &result, sizeof(result));

    if (-1 == rv) {
      return true;
    } else {
      auto	the_address_result = (mmux_libc_internet_protocol_address_four_t *) address_result;

      if (mmux_libc_make_ipfour_addr_from_struct_in_addr(the_address_result, result)) {
	return true;
      } else {
	*number_of_bits_result = mmux_uint(rv);
	return false;
      }
    }
  } else {
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  }
]]])
}
bool
mmux_libc_inet_net_ntop (mmux_asciizp_t presentation_result, mmux_usize_t presentation_provided_nbytes,
			 mmux_libc_network_address_family_t family,
			 mmux_libc_ip_addr_arg_t address,
			 mmux_uint_t number_of_bits)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_INET_NET_NTOP]]],[[[
  if (MMUX_LIBC_VALUEOF_AF_INET == family.value) {
    auto		the_address = (mmux_libc_internet_protocol_address_four_t *) address;
    mmux_asciizp_t	rv = inet_net_ntop(family.value, the_address->value, number_of_bits.value,
					   presentation_result, presentation_provided_nbytes.value);

    return (NULL == rv)? true : false;
  } else {
    mmux_libc_errno_set(MMUX_LIBC_EINVAL);
    return true;
  }
]]])
}


#if 0


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
    *result_error_code_p = mmux_sint(rv);
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
  *result_error_message_p = gai_strerror(errnum.value);
  return false;
}
bool
mmux_libc_getnameinfo (mmux_asciizcp_t result_hostname_p, mmux_libc_socklen_t provided_hostname_len,
		       mmux_asciizcp_t result_servname_p, mmux_libc_socklen_t provided_servname_len,
		       mmux_sint_t * result_error_code_p,
		       mmux_libc_sockaddr_ptr_t input_sockaddr_p, mmux_libc_socklen_t input_sockaddr_size,
		       mmux_sint_t flags)
{
  int	rv = getnameinfo(input_sockaddr_p, input_sockaddr_size.value,
			 (mmux_asciizp_t)result_hostname_p, provided_hostname_len.value,
			 (mmux_asciizp_t)result_servname_p, provided_servname_len.value,
			 flags.value);

  if (0 == rv) {
    return false;
  } else {
    *result_error_code_p = mmux_sint(rv);
    return true;
  }
}

bool
mmux_libc_sethostent (bool stayopen)
{
  sethostent((mmux_standard_sint_t)stayopen);
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
 ** Sockets: creation, pairs, shutdown.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_make_network_socket (mmux_libc_network_socket_t * result_p, mmux_standard_sint_t sock_num)
{
  result_p->value = sock_num;
  return false;
}
bool
mmux_libc_socket (mmux_libc_network_socket_t * result_sock_p,
		  mmux_libc_network_protocol_family_t namespace,
		  mmux_libc_socket_communication_style_t style,
		  mmux_libc_network_internet_protocol_t ipproto)
{
  int	sock_num = socket(namespace.value, style.value, ipproto.value);

  if (-1 != sock_num) {
    return mmux_libc_make_network_socket(result_sock_p, sock_num);
  } else {
    return true;
  }
}
bool
mmux_libc_shutdown (mmux_libc_network_socket_t * sockp, mmux_libc_socket_shutdown_mode_t how)
{
  int	rv = shutdown(sockp->value, how.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_socketpair (mmux_libc_network_socket_t * result_sock1_p,
		      mmux_libc_network_socket_t * result_sock2_p,
		      mmux_libc_network_protocol_family_t namespace,
		      mmux_libc_socket_communication_style_t style,
		      mmux_libc_network_internet_protocol_t ipproto)
{
  int	socks[2];
  int	rv = socketpair(namespace.value, style.value, ipproto.value, socks);

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
mmux_libc_connect (mmux_libc_network_socket_t * sockp,
		   mmux_libc_sockaddr_ptr_t sockaddr_pointer, mmux_libc_socklen_t sockaddr_size)
{
  int	rv = connect(sockp->value, sockaddr_pointer, sockaddr_size.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_bind (mmux_libc_network_socket_t * sockp,
		mmux_libc_sockaddr_ptr_t sockaddr_pointer, mmux_libc_socklen_t sockaddr_size)
{
  int	rv = bind(sockp->value, sockaddr_pointer, sockaddr_size.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_listen (mmux_libc_network_socket_t * sockp, mmux_uint_t pending_connections_queue_length)
{
  int	rv = listen(sockp->value, pending_connections_queue_length.value);

  return ((0 == rv)? false : true);
}
bool
mmux_libc_accept (mmux_libc_network_socket_t * result_connected_sock_p,
		  mmux_libc_sockaddr_ptr_t result_client_sockaddr_p,
		  mmux_libc_socklen_t * result_client_sockaddr_size_p,
		  mmux_libc_network_socket_t * server_sockp)
/* Upon calling:  the location referenced by  "result_client_sockaddr_size_p" must be
 * set  to   the  number   of  bytes   allocated  for   the  address   referenced  by
 * "result_client_sockaddr_p".
 *
 * Upon      successfully     returning:      the     location      referenced     by
 * "result_client_sockaddr_size_p" is reset to the actual size of the client address.
 */
{
  mmux_standard_libc_socklen_t	len;
  mmux_standard_sint_t		connected_sock = accept(server_sockp->value, result_client_sockaddr_p, &len);

  if (-1 != connected_sock) {
    if (mmux_libc_make_network_socket(result_connected_sock_p, connected_sock)) {
      return true;
    } else {
      *result_client_sockaddr_size_p = mmux_libc_socklen(len);
      return false;
    }
  } else {
    return true;
  }
}
bool
mmux_libc_accept4 (mmux_libc_network_socket_t * result_connected_sock_p,
		   mmux_libc_sockaddr_ptr_t result_client_sockaddr_p,
		   mmux_libc_socklen_t * result_client_sockaddr_size_p,
		   mmux_libc_network_socket_t * server_sockp,
		   mmux_sint_t flags)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_ACCEPT4]]],[[[
  mmux_standard_libc_socklen_t	len;
  mmux_standard_sint_t		connected_sock = accept4(server_sockp->value,
							 result_client_sockaddr_p,
							 &len,
							 flags.value);

  if (-1 != connected_sock) {
    if (mmux_libc_make_network_socket(result_connected_sock_p, connected_sock)) {
      return true;
    } else {
      *result_client_sockaddr_size_p = mmux_libc_socklen(len);
      return false;
    }
  } else {
    return true;
  }
]]])
}
bool
mmux_libc_getpeername (mmux_libc_network_socket_t * sockp,
		       mmux_libc_sockaddr_ptr_t sockaddr_any,
		       mmux_libc_socklen_t * sockaddr_any_size_p)
{
  mmux_standard_libc_socklen_t	len;
  int				rv = getpeername(sockp->value, sockaddr_any, &len);

  if (0 == rv) {
    *sockaddr_any_size_p = mmux_libc_socklen(len);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_getsockname (mmux_libc_network_socket_t * sockp,
		       mmux_libc_sockaddr_ptr_t sockaddr_any,
		       mmux_libc_socklen_t * sockaddr_any_size_p)
{
  mmux_standard_libc_socklen_t	len;
  int				rv = getsockname(sockp->value, sockaddr_any, &len);

  if (0 == rv) {
    *sockaddr_any_size_p = mmux_libc_socklen(len);
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Sending and receiving data.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_send (mmux_usize_t * result_number_of_bytes_sent_p,
		mmux_libc_network_socket_t * sockp,
		mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
{
  mmux_standard_ssize_t	number_of_bytes_sent = send(sockp->value, bufptr, buflen.value, flags.value);

  if (-1 < number_of_bytes_sent) {
    *result_number_of_bytes_sent_p = mmux_usize(number_of_bytes_sent);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_sendto (mmux_usize_t * result_number_of_bytes_sent_p,
		  mmux_libc_network_socket_t * sockp,
		  mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags,
		  mmux_libc_sockaddr_ptr_t destination_sockaddr_p, mmux_libc_socklen_t destination_sockaddr_size)
{
  mmux_standard_ssize_t	number_of_bytes_sent = sendto(sockp->value, bufptr, buflen.value, flags.value,
						      destination_sockaddr_p, destination_sockaddr_size.value);

  if (-1 < number_of_bytes_sent) {
    *result_number_of_bytes_sent_p = mmux_usize(number_of_bytes_sent);
    return false;
  } else {
    return true;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_libc_recv (mmux_usize_t * result_number_of_bytes_received_p,
		mmux_libc_network_socket_t * sockp,
		mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
{
  mmux_standard_ssize_t	number_of_bytes_received = recv(sockp->value, bufptr, buflen.value, flags.value);

  if (-1 < number_of_bytes_received) {
    *result_number_of_bytes_received_p = mmux_usize(number_of_bytes_received);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_recvfrom (mmux_usize_t * result_number_of_bytes_received_p,
		    mmux_libc_sockaddr_ptr_t result_sender_sockaddr_p,
		    mmux_libc_socklen_t * result_sender_sockaddr_size_p,
		    mmux_libc_network_socket_t * sockp,
		    mmux_pointer_t bufptr, mmux_usize_t buflen, mmux_sint_t flags)
{
  /* The arguments "result_sender_sockaddr_p" and "result_sender_sockaddr_size_p" can
     be NULL if we are not interested in retrieving the sender address. */
  mmux_standard_libc_socklen_t	len;
  mmux_standard_ssize_t		number_of_bytes_received  = recvfrom(sockp->value,
								     bufptr, buflen.value, flags.value,
								     result_sender_sockaddr_p,
								     &len);

  if (-1 < number_of_bytes_received) {
    *result_number_of_bytes_received_p = mmux_usize(number_of_bytes_received);
    *result_sender_sockaddr_size_p     = mmux_libc_socklen(len);
    return false;
  } else {
    return true;
  }
}


/** --------------------------------------------------------------------
 ** Options.
 ** ----------------------------------------------------------------- */

DEFINE_STRUCT_SETTER_GETTER(linger, l_onoff,		sint)
DEFINE_STRUCT_SETTER_GETTER(linger, l_linger,		sint)

bool
mmux_libc_linger_dump (mmux_libc_fd_arg_t fd, mmux_libc_linger_t const * linger_p, mmux_asciizcp_t struct_name)
{
  if (NULL == struct_name) {
    struct_name = "struct linger";
  }
  DPRINTF(fd, "%s.l_onoff  = \"%d\"\n", struct_name, linger_p->l_onoff);
  DPRINTF(fd, "%s.l_linger = \"%d\"\n", struct_name, linger_p->l_linger);
  return false;
}
bool
mmux_libc_getsockopt (mmux_pointer_t result_optval_p, mmux_libc_socklen_t * result_optlen_p,
		      mmux_libc_network_socket_t * sockp, mmux_sint_t level, mmux_sint_t optname)
{
  mmux_standard_libc_socklen_t	len;
  mmux_standard_sint_t		rv = getsockopt(sockp->value, level.value, optname.value,
						result_optval_p, &len);

  if (0 == rv) {
    *result_optlen_p = mmux_libc_socklen(len);
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_setsockopt (mmux_libc_network_socket_t * sockp, mmux_sint_t level, mmux_sint_t optname,
		      mmux_pointer_t optval_p, mmux_libc_socklen_t optlen)
{
  int	rv = setsockopt(sockp->value, level.value, optname.value, optval_p, optlen.value);

  return ((0 == rv)? false : true);
}

#endif

/* end of file */
