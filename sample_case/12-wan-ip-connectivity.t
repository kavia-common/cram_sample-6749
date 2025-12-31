# Purpose: Validate WAN IPv4/IPv6 connectivity using ping with basic latency/packet loss sanity.
# Prerequisites:
#  - WAN uplink is active and policy routing allows outbound ICMP.
#  - ping and ping6 (or ping -6) available on DUT.
# Notes:
#  - Output normalized to avoid timestamp/variable latencies. We only check packet loss and success markers.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

IPv4 ping public DNS (expect success):
  $ R "ping -c 2 -w 4 1.1.1.1 | sed -E 's/time=[0-9\\.]+/time=X.Y/g;s/([0-9]+)% packet loss/PL=\\1%/g' | grep -E 'icmp_seq=|PL=' | sort | uniq"
  PL=* (glob)
  icmp_seq=* (glob)

IPv6 ping public DNS (skip-safe if no v6; still deterministic):
  $ R "ping -6 -c 2 -w 6 2606:4700:4700::1111 2>&1 | sed -E 's/time=[0-9\\.]+/time=X.Y/g;s/([0-9]+)% packet loss/PL=\\1%/g' | grep -E 'icmp_seq=|PL=|Name or service not known|No route to host|Network is unreachable' | sort | uniq"
  * (glob)
