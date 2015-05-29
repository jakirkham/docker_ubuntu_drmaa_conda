#!/bin/bash

# Download and configure conda.
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"
conda config --set always_yes yes
source activate root
# Install basic conda dependencies.
conda update conda
conda install conda-build
conda install binstar
