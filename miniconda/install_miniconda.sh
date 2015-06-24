#!/bin/bash

# Install wget to download the miniconda setup script.
apt-get install -y wget

# Install VCS.
apt-get install -y git mercurial subversion

# Install bzip2.
apt-get install -y bzip2 tar

# Install dependencies of conda's Qt4.
apt-get install -y libSM6 libXext6 libXrender1

# Clean out apt-get.
apt-get clean

# Download and configure conda.
cd /usr/share/miniconda
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /opt/conda
export PATH="/opt/conda/bin:${PATH}"
source activate root

# Install basic conda dependencies.
conda update -y --all
conda install -y conda-build
conda install -y binstar
conda install -y jinja2

# Clean out all unneeded intermediates.
conda clean -yitps
