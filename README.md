[![](https://badge.imagelayers.io/jakirkham/ubuntu_drmaa_conda:latest.svg)](https://imagelayers.io/?images=jakirkham/ubuntu_drmaa_conda:latest 'Get your own badge on imagelayers.io')

# Purpose

In order to provide a simple portable test environment for Grid Engine, this repo contains what is necessary to build a Ubuntu 12 based image using Docker. In addition, it provides a copy of [`binstar`]( http://binstar-client.readthedocs.org/en/latest/index.html ) and [`conda`]( http://conda.pydata.org/ ) with some extensions for building.

# Building

## Automatic

This repo is part of an automated build, which is hosted on Docker Hub ( <https://registry.hub.docker.com/u/jakirkham/ubuntu_drmaa_conda> ). Changes added to this trigger an automatic rebuild and deploy the resulting image to Docker Hub. To download an existing image, one simply needs to run `docker pull jakirkham/ubuntu_drmaa_conda`.

## Manual

If one wishes to develop this repo, building will need to be performed manually. This container can be built simply by `cd`ing into the repo and using `docker build -t <NAME> .` where `<NAME>` is the name tagged to the image built. More information about building can be found in Docker's documentation ( <https://docs.docker.com/reference/builder> ). Please consider opening a pull request for changes that you make.
