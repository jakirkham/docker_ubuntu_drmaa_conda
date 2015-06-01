#!/bin/bash

# Install bzip2.
apt-get install -y bzip2 tar

# Install dependencies of conda's Qt4.
apt-get install -y libSM6 libXrender1

# Clean out apt-get.
apt-get clean

# Download and configure conda.
cd /usr/share/miniconda
wget http://repo.continuum.io/miniconda/Miniconda-3.9.1-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /opt/conda
export PATH="/opt/conda/bin:${PATH}"
conda config --set always_yes yes
source activate root

# Install basic conda dependencies.
conda update conda
conda install conda-build
conda install binstar
