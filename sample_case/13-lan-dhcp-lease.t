# Purpose: Verify DHCP server is active on LAN and that a lease can be observed via system data.
# Prerequisites:
#  - dnsmasq or odhcpd serving LAN; ubus/dhcp available.
# Notes:
#  - Does not force renew from LAN host; checks lease table presence deterministically.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check dnsmasq is running:
  $ R "pgrep -x dnsmasq >/dev/null 2>&1 && echo running || echo not-running"
  * (glob)

Check for at least one DHCP lease entry:
  $ R "test -f /tmp/dhcp.leases && awk '{print $2,$3,$4}' /tmp/dhcp.leases | sed -E 's/([0-9a-f]{2}:){5}[0-9a-f]{2}/MAC:MAC:MAC:MAC:MAC:MAC/g;s/[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+/IP.IP.IP.IP/g' | head -n 1 || echo none"
  * (glob)
