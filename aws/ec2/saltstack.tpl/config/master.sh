#!/bin/sh

cd /root
curl -L -o bootstrap_salt.sh https://bootstrap.saltstack.com/

# "-M" installs salt-master in addition to salt-minion
sh bootstrap_salt.sh -M stable
