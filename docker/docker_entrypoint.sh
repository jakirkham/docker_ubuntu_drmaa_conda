#!/bin/bash


set -e

# Set the ulimits for this container. Must be run with the --privileged option
#ulimit -l unlimited
#ulimit -s unlimited

# Get system specs
export CORES=$(grep -c '^processor' /proc/cpuinfo)
export HOSTNAME=$(hostname)
export USER=$(whoami)

# Fix some basic system and Grid Engine files
sudo sh -c 'echo "domain ${HOSTNAME}" >> /etc/resolv.conf'
sudo sh -c "echo \"${HOSTNAME}\" > ${SGE_ROOT}/default/common/act_qmaster"

# Restart Grid Engine
sudo service gridengine-master restart
sudo service gridengine-exec restart

# Replace all of the config files with the template files
sudo cp $SGE_CONFIG_DIR/batch.conf.tmpl $SGE_CONFIG_DIR/batch.conf
sudo cp $SGE_CONFIG_DIR/host.conf.tmpl $SGE_CONFIG_DIR/host.conf
sudo cp $SGE_CONFIG_DIR/queue.conf.tmpl $SGE_CONFIG_DIR/queue.conf
sudo cp $SGE_CONFIG_DIR/user.conf.tmpl $SGE_CONFIG_DIR/user.conf

# Path the config files with system details as needed
sudo sed -i -r "s/localhost/${HOSTNAME}/" $SGE_CONFIG_DIR/host.conf
sudo sed -i -r "s/localhost/${HOSTNAME}/" $SGE_CONFIG_DIR/queue.conf
sudo sed -i -r "s/UNDEFINED/${CORES}/" $SGE_CONFIG_DIR/queue.conf
sudo sed -i -r "s/template/${USER}/" $SGE_CONFIG_DIR/user.conf

# Clean all existing settings.
sudo sh -c "export SGE_ROOT=${SGE_ROOT}; qconf -suserl | xargs -r -I {} qconf -du {} arusers"
sudo sh -c "export SGE_ROOT=${SGE_ROOT}; qconf -suserl | xargs -r qconf -duser"
sudo sh -c "export SGE_ROOT=${SGE_ROOT}; qconf -sql | xargs -r qconf -dq"
sudo sh -c "export SGE_ROOT=${SGE_ROOT}; qconf -spl | grep -v "make" | xargs -r qconf -dp"
sudo sh -c "export SGE_ROOT=${SGE_ROOT}; qconf -ss | xargs -r qconf -ds"
sudo sh -c "export SGE_ROOT=${SGE_ROOT}; qconf -sel | xargs -r qconf -de"

# Apply configuration files to the Grid Engine configuration
sudo qconf -Auser $SGE_CONFIG_DIR/user.conf
sudo qconf -au $USER arusers
sudo qconf -as $HOSTNAME

export HOST_IN_SEL=$(qconf -sel | grep -c "$HOSTNAME")
if [ $HOST_IN_SEL != "1" ]; then sudo qconf -Ae $SGE_CONFIG_DIR/host.conf; else sudo qconf -Me $SGE_CONFIG_DIR/host.conf; fi

sudo qconf -Ap $SGE_CONFIG_DIR/batch.conf
sudo qconf -Aq $SGE_CONFIG_DIR/queue.conf


# Run whatever the user wants to
exec "$@"
