#!/bin/bash

# Update apt-get.
apt-get update -y -q

# Install curl to download the miniconda setup script.
apt-get install -y curl

# Install VCS.
apt-get install -y git mercurial subversion

# Install bzip2 and tar. Needed for decompressing packages.
apt-get install -y bzip2 tar

# Install dependencies of conda's Qt4.
apt-get install -y libSM6 libXext6 libXrender1

# Clean out apt-get.
apt-get clean

# Download and configure conda.
cd /usr/share/miniconda
curl http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh > miniconda2.sh
bash miniconda2.sh -b -p /opt/conda2
rm miniconda2.sh
export PATH="/opt/conda/bin:${PATH}"
source activate root
conda config --set show_channel_urls True

# Install basic conda dependencies.
conda update -y --all
conda install -y pycrypto
conda install -y conda-build
conda install -y anaconda-client
conda install -y jinja2

# Install python bindings to DRMAA.
conda install -y drmaa

# Clean out all unneeded intermediates.
conda clean -yitps
