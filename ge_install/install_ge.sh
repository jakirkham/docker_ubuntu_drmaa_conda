#!/bin/bash
# This script installs and configures a Sun Grid Engine installation for use
# on a Travis instance.
#
# Written by Dan Blanchard (dblanchard@ets.org), September 2013

export SGE_CONFIG_DIR=ge_install
echo $SGE_CONFIG_DIR
sed -i -r "s/^(127.0.0.1\s)(localhost\.localdomain\slocalhost)/\1localhost localhost.localdomain $(hostname) /" /etc/hosts
apt-get -y update -qq
echo "gridengine-master shared/gridenginemaster string localhost" | debconf-set-selections
echo "gridengine-master shared/gridenginecell string default" | debconf-set-selections
echo "gridengine-master shared/gridengineconfig boolean true" | debconf-set-selections
apt-get -y install gridengine-common gridengine-master
# Do this in a separate step to give master time to start
apt-get -y install libdrmaa1.0 gridengine-client gridengine-exec
export CORES=$(grep -c '^processor' /proc/cpuinfo)
sed -i -r "s/template/$USER/" $SGE_CONFIG_DIR/user_template
qconf -Auser $SGE_CONFIG_DIR/user_template
qconf -au $USER arusers
qconf -as localhost
export LOCALHOST_IN_SEL=$(qconf -sel | grep -c 'localhost')
if [ $LOCALHOST_IN_SEL != "1" ]; then qconf -Ae $SGE_CONFIG_DIR/host_template; else qconf -Me $SGE_CONFIG_DIR/host_template; fi
sed -i -r "s/UNDEFINED/$CORES/" $SGE_CONFIG_DIR/queue_template
qconf -Ap $SGE_CONFIG_DIR/batch_template
qconf -Aq $SGE_CONFIG_DIR/queue_template
echo "Printing queue info to verify that things are working correctly."
qstat -f -q all.q -explain a
echo "You should see sge_execd and sge_qmaster running below:"
ps aux | grep "sge"
