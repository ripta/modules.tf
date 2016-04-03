#!/bin/sh

cd /root
curl -L -o bootstrap_salt.sh https://bootstrap.saltstack.com/

SALT_OPTS="stable"

# The master address may be omitted, which falls back to salt's default: `salt`
[ -n "${master_address}" ] && SALT_OPTS="-A ${master_address} $SALT_OPTS"

# The minion ID may also be omitted, which falls back to the hostname
[ -n "${minion_id}" ] && SALT_OPTS="-i ${minion_id} $SALT_OPTS"

sh bootstrap_salt.sh $SALT_OPTS
