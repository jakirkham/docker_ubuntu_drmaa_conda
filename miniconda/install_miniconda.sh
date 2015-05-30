#!/bin/bash

# Install bzip2.
apt-get install -y bzip2

# Install dependencies of conda's Qt4.
apt-get install -y libsm6 libXrender1

# Clean out apt-get.
apt-get clean

# Download and configure conda.
cd /usr/share/miniconda
wget http://repo.continuum.io/miniconda/Miniconda-3.9.1-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /opt/conda
/opt/conda/bin/conda config --set always_yes yes
source /opt/conda/bin/activate root

# Install basic conda dependencies.
/opt/conda/bin/conda update conda
/opt/conda/bin/conda install conda-build
/opt/conda/bin/conda install binstar
