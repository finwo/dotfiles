#!/usr/bin/env bash

_term() {
	echo "Caught SIGTERM"
	kill -TERM "$child" 2>/dev/null
}

DEV=/dev/ttyS2
SPD=1500000
MOD=client

while [ "$#" -gt 0 ]; do
  case "$1" in
    -s|--speed)
      shift
      SPD=$1
      ;;
    -d|--dev|--tty)
      shift
      DEV=$1
      ;;
    -m|--mode)
      shift
      MOD=$1
      ;;
  esac
  shift
done

trap _term SIGTERM
sudo stty -F $DEV $SPD
sudo slattach -L -s $SPD -p cslip $DEV &
child=$!

echo "nameserver 127.0.0.1" | sudo tee -a /etc/resolv.conf
echo "nameserver 1.1.1.1"   | sudo tee -a /etc/resolv.conf
echo "nameserver 1.0.0.1"   | sudo tee -a /etc/resolv.conf
echo "nameserver 8.8.8.8"   | sudo tee -a /etc/resolv.conf
echo "nameserver 8.8.4.4"   | sudo tee -a /etc/resolv.conf

case "$MOD" in
  client)
    sudo ifconfig sl0 192.168.16.2 pointtopoint 192.168.16.1 up
    sudo route add default dev sl0
    ;;
  host)
    PHY=$(route -n | grep UG | tr ' ' '\n' | tail -1)
    sudo iptables -t nat -A POSTROUTING -o $PHY -j MASQUERADE
    sudo iptables -A FORWARD -i sl0 -o $PHY -j ACCEPT
    sudo iptables -A FORWARD -i $PHY -o sl0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -j DROP
    sudo ifconfig sl0 192.168.16.1 pointopoint 192.168.16.2 up
    ;;
esac

wait "$child"
