#!/bin/sh

# bastion.sh - Prepare an EC2 instance as a bastion host
#
# This script changes the default SSH port from 22 to 2804.

sed -i 's/^Port.*/Port 2804/g' /etc/ssh/sshd_config
service ssh restart
