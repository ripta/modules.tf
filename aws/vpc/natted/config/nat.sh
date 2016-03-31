#!/bin/sh

DEBIAN_FRONTEND=noninteractive apt-get update

sed -i 's/^#net.ipv4.ip_forward.*/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
sed -i 's/^#net.ipv6.conf.all.forwarding.*/net.ipv6.conf.all.forwarding = 1/g' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

iptables -t nat -A POSTROUTING -o eth0 -s ${vpc_cidr} -j MASQUERADE
