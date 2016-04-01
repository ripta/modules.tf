#!/bin/sh

DEBIAN_FRONTEND=noninteractive apt-get update

sed -i 's/^Port.*/Port 2804/g' /etc/ssh/sshd_config
service ssh restart
