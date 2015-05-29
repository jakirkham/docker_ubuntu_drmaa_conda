#!/bin/bash

# Install bzip2.
apt-get install -y bzip2

# Download and configure conda.
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /opt/conda
/opt/conda/bin/conda config --set always_yes yes
source /opt/conda/bin/activate root

# Install basic conda dependencies.
/opt/conda/bin/conda update conda
/opt/conda/bin/conda install conda-build
/opt/conda/bin/conda install binstar
