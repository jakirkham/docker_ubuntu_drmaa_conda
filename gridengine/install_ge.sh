#!/bin/bash

export SGE_CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $SGE_CONFIG_DIR
sed -i -r "s/^(127.0.0.1\s)(localhost\.localdomain\slocalhost)/\1localhost localhost.localdomain ${HOSTNAME} /" /etc/hosts
apt-get -y update -qq
echo "gridengine-master shared/gridenginemaster string ${HOSTNAME}" | debconf-set-selections
echo "gridengine-master shared/gridenginecell string default" | debconf-set-selections
echo "gridengine-master shared/gridengineconfig boolean true" | debconf-set-selections
apt-get -y install gridengine-common gridengine-master
# Do this in a separate step to give master time to start
apt-get -y install libdrmaa1.0 gridengine-client gridengine-exec
export CORES=$(grep -c '^processor' /proc/cpuinfo)
cp $SGE_CONFIG_DIR/user.conf.tmpl $SGE_CONFIG_DIR/user.conf
sed -i -r "s/template/user/" $SGE_CONFIG_DIR/user.conf
qconf -Auser $SGE_CONFIG_DIR/user.conf
qconf -au user arusers
qconf -as $HOSTNAME
cp $SGE_CONFIG_DIR/host.conf.tmpl $SGE_CONFIG_DIR/host.conf
sed -i -r "s/localhost/${HOSTNAME}/" $SGE_CONFIG_DIR/host.conf
export LOCALHOST_IN_SEL=$(qconf -sel | grep -c "${HOSTNAME}")
if [ $LOCALHOST_IN_SEL != "1" ]; then qconf -Ae $SGE_CONFIG_DIR/host.conf; else qconf -Me $SGE_CONFIG_DIR/host.conf; fi
cp $SGE_CONFIG_DIR/queue.conf.tmpl $SGE_CONFIG_DIR/queue.conf
sed -i -r "s/localhost/${HOSTNAME}/" $SGE_CONFIG_DIR/queue.conf
sed -i -r "s/UNDEFINED/${CORES}/" $SGE_CONFIG_DIR/queue.conf
cp $SGE_CONFIG_DIR/batch.conf.tmpl $SGE_CONFIG_DIR/batch.conf
qconf -Ap $SGE_CONFIG_DIR/batch.conf
qconf -Aq $SGE_CONFIG_DIR/queue.conf
service gridengine-master restart
service gridengine-exec restart
echo "Printing queue info to verify that things are working correctly."
qstat -f -q all.q -explain a
echo "You should see sge_execd and sge_qmaster running below:"
ps aux | grep "sge"
# Clean apt-get so we don't have a bunch of junk left over from our build.
apt-get clean
