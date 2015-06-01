#!/bin/bash

export USER=$(whoami)
export SGE_CONFIG_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export SGE_ROOT=/var/lib/gridengine
echo $SGE_CONFIG_DIR
sed -i -r "s/^(127.0.0.1\s)(localhost\.localdomain\slocalhost)/\1localhost localhost.localdomain ${HOSTNAME} /" /etc/hosts
cp /etc/resolv.conf /etc/resolv.conf.orig
echo "domain ${HOSTNAME}" >> /etc/resolv.conf
# Update everything.
apt-get -y update -qq
echo "gridengine-master shared/gridenginemaster string ${HOSTNAME}" | debconf-set-selections
echo "gridengine-master shared/gridenginecell string default" | debconf-set-selections
echo "gridengine-master shared/gridengineconfig boolean true" | debconf-set-selections
apt-get -y install gridengine-common gridengine-master
# Do this in a separate step to give master time to start
apt-get -y install libdrmaa1.0 gridengine-client gridengine-exec
cp ${SGE_ROOT}/default/common/act_qmaster ${SGE_ROOT}/default/common/act_qmaster.orig
echo \"${HOSTNAME}\" > ${SGE_ROOT}/default/common/act_qmaster
service gridengine-master restart
service gridengine-exec restart
export CORES=$(grep -c '^processor' /proc/cpuinfo)
cp $SGE_CONFIG_DIR/user.conf.tmpl $SGE_CONFIG_DIR/user.conf
sed -i -r "s/template/${USER}/" $SGE_CONFIG_DIR/user.conf
qconf -Auser $SGE_CONFIG_DIR/user.conf
qconf -au $USER arusers
qconf -as $HOSTNAME
cp $SGE_CONFIG_DIR/host.conf.tmpl $SGE_CONFIG_DIR/host.conf
sed -i -r "s/localhost/${HOSTNAME}/" $SGE_CONFIG_DIR/host.conf
export HOST_IN_SEL=$(qconf -sel | grep -c "${HOSTNAME}")
if [ $HOST_IN_SEL != "1" ]; then qconf -Ae $SGE_CONFIG_DIR/host.conf; else qconf -Me $SGE_CONFIG_DIR/host.conf; fi
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
# Add a job based test to make sure the system really works.
echo
echo "Submit a simple job to make sure the submission system really works."

mkdir /tmp/test_gridengine
pushd /tmp/test_gridengine
set -e

echo "-------------- test.sh --------------"
echo -e '#!/bin/sh\necho "stdout"\necho "stderr" 1>&2' | tee test.sh
echo "-------------------------------------"
echo
chmod +x test.sh

qsub -cwd -sync y test.sh
echo

echo "------------ test.sh.o1 -------------"
cat test.sh.o*
echo "-------------------------------------"
echo

echo "------------ test.sh.e1 -------------"
cat test.sh.e*
echo "-------------------------------------"
echo

grep stdout test.sh.o* &>/dev/null
grep stderr test.sh.e* &>/dev/null

rm test.sh*

set +e
popd
rm -rf /tmp/test_gridengine
# Put everything back the way it was.
cp /etc/resolv.conf.orig /etc/resolv.conf
cp ${SGE_ROOT}/default/common/act_qmaster.orig ${SGE_ROOT}/default/common/act_qmaster
# Clean apt-get so we don't have a bunch of junk left over from our build.
apt-get clean
