Create R alias:

  $ alias R="${CRAM_REMOTE_COMMAND:-}"

network lan ipaddr get :
  $ R "uci get network.lan.ipaddr"
  192.168.1.1

network lan ipaddr set :
  $ R "uci set network.lan.ipaddr='192.168.2.1'"
  $ R "uci commit network.lan.ipaddr"
  $ R "uci get network.lan.ipaddr"
  192.168.2.1

Restore network lan ip addr set
  $ R "uci set network.lan.ipaddr='192.168.1.1'"
  $ R "uci commit network.lan.ipaddr"
  $ R "uci get network.lan.ipaddr"
  192.168.1.1

network lan ip apply
  $ R "uci set network.lan.ipaddr='192.168.2.1'"
  $ R "uci commit network.lan.ipaddr"
  $ R "/etc/init.d/network restart > /dev/null 2>&1 &"
  $ sleep 60
  $ sudo ip addr add 192.168.2.50/24 dev ${INTERFACE}
  $ ssh -o StrictHostKeychecking=no root@192.168.2.1 ls > /dev/null 2>&1
  $ CRAM_REMOTE_COMMAND2="ssh root@192.168.2.1"
  $ alias R="${CRAM_REMOTE_COMMAND2:-}"
  $ R 'ifconfig br-lan | grep "inet addr" | awk -F: "{print \$2}" | awk "{print \$1}"'
  192.168.2.1
