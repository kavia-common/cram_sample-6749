# Purpose: Validate VLAN configuration on LAN ports using UCI and that it is applied.
# Prerequisites:
#  - Device uses DSA or swconfig-compatible config via UCI (network.@device/network.@switch)* depending on platform
#  - This test uses no reboot; it writes config then reloads network.
# Notes:
#  - Uses sed/grep/sort to stabilize output.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Create/ensure a VLAN named vlan10 and assign LAN interface to it (id 10):
  $ R "uci -q set network.vlan10='device'; uci set network.vlan10.name='br-lan.10' || true; uci set network.vlan10.type='8021q' || true; uci set network.vlan10.ifname='br-lan' || true; uci set network.vlan10.vid='10' || true; uci -q commit network; /etc/init.d/network reload >/dev/null 2>&1 || true; echo OK"
  OK

Confirm UCI has vlan10 with vid 10:
  $ R \"uci show network | grep -E 'network.vlan10' | sed 's/@[0-9]\\+/@N/g' | sort\"
  network.vlan10.* (glob)
  *vid='10'* (glob)

Validate the sub-interface appears:
  $ R "ip -o link show | grep -E 'br-lan\\.10' | sed -E 's/@.*>/:>/g;s/link\\/ether [0-9a-f:]+/link\\/ether XX:XX:XX:XX:XX:XX/g' | cut -d' ' -f2- | sort"
  br-lan.10:> * (glob)
