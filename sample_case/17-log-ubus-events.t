# Purpose: Verify log and ubus events presence following config changes.
# Prerequisites:
#  - logread and ubus available on DUT.
# Notes:
#  - Normalizes timestamps.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Trigger a wireless reload and check for log entries:
  $ R "wifi reload >/dev/null 2>&1 || true; sleep 2; logread | grep -Ei 'wireless|hostapd|netifd' | tail -n 5 | sed -E 's/[A-Z][a-z]{2} [ 0-9]{1,2} [0-9]{2}:[0-9]{2}:[0-9]{2}/Mon DD HH:MM:SS/g' | sed -E 's/(wlan[0-9a-z]+|phy[0-9]+|radio[0-9]+)/IFACE/g' | sort | uniq"
  * (glob)

Check ubus wireless status again to confirm presence:
  $ R "ubus call network.wireless status 2>/dev/null | tr -d ' ' | tr -d '\"' | grep -E 'up:true|up:false' | head -n 1 || echo missing"
  * (glob)
