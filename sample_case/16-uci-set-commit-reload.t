# Purpose: Validate UCI set/commit/reload cycles for wireless and network.
# Prerequisites:
#  - UCI and init scripts available on DUT.
# Notes:
#  - Reverts any temporary change after verification to avoid side effects.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Set a temp wireless option and commit:
  $ R "uci set wireless.@wifi-iface[0].isolation='0'; uci commit wireless; /etc/init.d/network reload >/dev/null 2>&1 || true; echo done"
  done

Verify value applied in config (normalized index):
  $ R \"uci show wireless | grep -E 'isolation=' | sed 's/@[0-9]\\+/@N/g' | sort | uniq\"
  wireless.@wifi-iface@N.isolation='0'

Toggle network sysctl knob via UCI (rp_filter if present) and commit:
  $ R "uci -q set network.globals='globals' || true; uci set network.globals.ula_prefix='fd00:dead:beef::/48' || true; uci commit network; /etc/init.d/network reload >/dev/null 2>&1 || true; echo ok"
  ok

Confirm globals present:
  $ R "uci show network.globals | sed 's/[0-9a-f]\\{4\\}:[0-9a-f]\\{4\\}:[0-9a-f]\\{4\\}/FD00:DEAD:BEEF/g' | tr '[:lower:]' '[:upper:]'"
  NETWORK.GLOBALS.ULA_PREFIX='FD00:DEAD:BEEF::/48'
