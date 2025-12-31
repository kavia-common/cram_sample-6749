# Purpose: Verify basic firewall ruleset presence using nft/iptables markers for accept/drop chains.
# Prerequisites:
#  - OpenWrt firewall (fw4 or legacy fw3) active.
# Notes:
#  - Only checks for existence of expected chains or rules markers; no disruptive actions.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Check fw4 nftables chains (preferred):
  $ R "nft list ruleset 2>/dev/null | grep -E 'chain input|chain forward|chain output' | sed 's/[[:space:]]\\+/ /g' | sort | uniq || true"
  *chain input* (glob)
  *chain forward* (glob)
  *chain output* (glob)

Fallback legacy iptables presence (if nft not available):
  $ R "iptables -L 2>/dev/null | head -n 3 | sed 's/[[:space:]]\\+/ /g' || echo iptables-missing"
  * (glob)
