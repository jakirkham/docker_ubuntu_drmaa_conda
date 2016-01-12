#!/bin/bash


set -e

# Set the ulimits for this container. Must be run with the --privileged option
#ulimit -l unlimited
#ulimit -s unlimited

# Get system specs
export CORES=$([[ -z "${CORES+x}" ]] && echo $(grep -c '^processor' /proc/cpuinfo) || echo "${CORES}")
export HOSTNAME=$(hostname)
export USER=$(whoami)

# Fix some basic system and Grid Engine files
echo "domain ${HOSTNAME}" >> /etc/resolv.conf
echo "${HOSTNAME}" > ${SGE_ROOT}/default/common/act_qmaster

# Restart Grid Engine
service gridengine-master restart
service gridengine-exec restart

# Replace all of the config files with the template files
cp $SGE_CONFIG_DIR/batch.conf.tmpl $SGE_CONFIG_DIR/batch.conf
cp $SGE_CONFIG_DIR/host.conf.tmpl $SGE_CONFIG_DIR/host.conf
cp $SGE_CONFIG_DIR/queue.conf.tmpl $SGE_CONFIG_DIR/queue.conf
cp $SGE_CONFIG_DIR/user.conf.tmpl $SGE_CONFIG_DIR/user.conf

# Path the config files with system details as needed
sed -i -r "s/localhost/${HOSTNAME}/" $SGE_CONFIG_DIR/host.conf
sed -i -r "s/localhost/${HOSTNAME}/" $SGE_CONFIG_DIR/queue.conf
sed -i -r "s/UNDEFINED/${CORES}/" $SGE_CONFIG_DIR/queue.conf
sed -i -r "s/template/${USER}/" $SGE_CONFIG_DIR/user.conf

# Clean all existing settings.
qconf -suserl | xargs -r -I {} qconf -du {} arusers
qconf -suserl | xargs -r qconf -duser
qconf -sql | xargs -r qconf -dq
qconf -spl | grep -v "make" | xargs -r qconf -dp
qconf -ss | xargs -r qconf -ds
qconf -sel | xargs -r qconf -de

# Apply configuration files to the Grid Engine configuration and wait briefly to ensure the submission host has been properly added
qconf -Auser ${SGE_CONFIG_DIR}/user.conf
qconf -au ${USER} arusers
qconf -as ${HOSTNAME}
sleep 1

export HOST_IN_SEL=$(qconf -sel | grep -c "$HOSTNAME")
if [ $HOST_IN_SEL != "1" ]; then qconf -Ae ${SGE_CONFIG_DIR}/host.conf; else qconf -Me ${SGE_CONFIG_DIR}/host.conf; fi

qconf -Ap ${SGE_CONFIG_DIR}/batch.conf
qconf -Aq ${SGE_CONFIG_DIR}/queue.conf

# Run whatever the user wants to
exec "$@"
