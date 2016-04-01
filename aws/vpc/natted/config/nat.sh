#!/bin/sh

# nat.sh - Prepare an EC2 instance as a NAT
#
# This script enables kernel IP forwarding for both IPv4 and IPv6. When combined
# with an instance that has its `source_dest_check` set to `false`, any incoming
# packet from ${vpc_cidr} will be forwarded to `eth0`.

sed -i 's/^#net.ipv4.ip_forward.*/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf
sed -i 's/^#net.ipv6.conf.all.forwarding.*/net.ipv6.conf.all.forwarding = 1/g' /etc/sysctl.conf
sysctl -p /etc/sysctl.conf

iptables -t nat -A POSTROUTING -o eth0 -s ${vpc_cidr} -j MASQUERADE
