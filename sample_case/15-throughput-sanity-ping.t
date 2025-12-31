# Purpose: Sanity-check network responsiveness using ping RTT and packet loss thresholds.
# Prerequisites:
#  - WAN connectivity to 1.1.1.1 or similar endpoint.
# Notes:
#  - Parses summary line for packet loss; RTTs normalized.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Run ping and check packet loss summary:
  $ R "ping -c 5 -w 7 1.1.1.1 | sed -E 's/([0-9]+)% packet loss/PL=\\1%/g;s/avg\\/.*\\/[0-9\\.]+/avg\\/X.Y/g' | grep -E 'PL=|rtt min|round-trip' | head -n 2 | sort"
  PL=* (glob)
  * (glob)
