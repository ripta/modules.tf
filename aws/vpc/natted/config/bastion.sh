#!/bin/sh

# bastion.sh - Prepare an EC2 instance as a bastion host
#
# This script changes the default SSH port from 22 to 2804.

if [ -n "$(command -v yum)" ]
then
  yum update -y
elif [ -n "$(command -v apt-get)" ]
then
  DEBIAN_FRONTEND=noninteractive apt-get update
elif [ -n "$(command -v apk)" ]
then
  apk update
else
  echo "Warning: could not find a supported package manager" >&2
fi

sed -i 's/^#\?Port.*/Port 2804/g' /etc/ssh/sshd_config
service sshd restart
