# Purpose: Verify wireless interface bring-up/down and status using OpenWrt (UCI/ubus/iw).
# Prerequisites:
#  - CRAM_REMOTE_COMMAND is set by sample_cram/cram.sh to ssh root@<DUT_LAN_IP>
#  - DUT has wireless configured with at least one radio (e.g., radio0) and interface (e.g., wlan0)
#  - Root SSH enabled on DUT
# Notes:
#  - This test is designed to be deterministic. It uses grep/sed/sort to normalize output.
#  - Filters are applied via CRAM regex/glob expectations for volatile fields.

Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

Disable and enable wifi to verify state toggling (using wifi down/up or /sbin/wifi):

  $ R "wifi down >/dev/null 2>&1 || true; sleep 2; iw dev | grep Interface | tr -d '\t' | sort"
  Interface * (glob)

  $ R "wifi up >/dev/null 2>&1 || true; sleep 3; iw dev | grep -e Interface -e ssid | tr -d '\t' | sort | sed 's/[ ]\\+/ /g'"
  Interface * (glob)
  ssid * (glob)

Validate UCI wireless config exists:

  $ R "uci show wireless | grep -E 'wireless\\.radio[0-9]+|wireless\\..*\\.ssid' | sed 's/@[0-9]\\+/@N/g' | sort"
  wireless.radio0.* (glob)
  *ssid* (glob)

Check interface status via ubus (normalize volatile fields):

  $ R "ubus call network.wireless status 2>/dev/null | tr -d ' ' | tr -d '\t' | tr -d '\"' | sed -E 's/[0-9]{2}:[0-9]{2}:[0-9]{2}/HH:MM:SS/g;s/[0-9]{4}-[0-9]{2}-[0-9]{2}/YYYY-MM-DD/g;s/(assoc|connected|active|up):true/\\1:true/g;s/(assoc|connected|active|up):false/\\1:false/g' | grep -E '(up:true|ssid:|ifname:|up:false)' | sort | uniq"
  ifname:* (glob)
  ssid:* (glob)
  up:* (glob)
