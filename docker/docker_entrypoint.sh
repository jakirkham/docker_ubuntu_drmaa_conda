#!/bin/bash


set -e

source /usr/share/gridengine/default/common/settings.sh

# Set the ulimits for this container. Must be run with the --privileged option
#ulimit -l unlimited
#ulimit -s unlimited

echo "$HOSTNAME" >  /usr/share/gridengine/default/common/act_qmaster
echo "domain $HOSTNAME" >> /etc/resolv.conf
/etc/init.d/sgemaster start
qconf -mattr "queue" "hostlist" "$HOSTNAME" "debug"
qconf -as $HOSTNAME


# Run whatever the user wants to
exec "$@"
