[![](https://badge.imagelayers.io/jakirkham/ubuntu_drmaa_conda:latest.svg)](https://imagelayers.io/?images=jakirkham/ubuntu_drmaa_conda:latest 'Get your own badge on imagelayers.io')
[![](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0.txt 'Apache License Version 2.0')

# Purpose

In order to provide a simple portable test environment for Grid Engine, this repo contains what is necessary to build a Ubuntu 12 based image using Docker. In addition, it provides a copy of [`anaconda-client`]( http://docs.anaconda.org/ ) and [`conda`]( http://conda.pydata.org/ ) with some extensions for building.

# Building

## Automatic

This repo is part of an automated build, which is hosted on Docker Hub ( <https://hub.docker.com/r/jakirkham/ubuntu_drmaa_conda> ). Changes added to this trigger an automatic rebuild and deploy the resulting image to Docker Hub. To download an existing image, one simply needs to run `docker pull jakirkham/ubuntu_drmaa_conda`.

## Manual

If one wishes to develop this repo, building will need to be performed manually. This container can be built simply by `cd`ing into the repo and using `docker build --rm -t <NAME> .` where `<NAME>` is the name tagged to the image built. More information about building can be found in Docker's documentation ( <https://docs.docker.com/reference/builder> ). Please consider opening a pull request for changes that you make.

# Testing

A simple test has been added during the installation of Grid Engine as this is the trickiest step and the one most likely to go wrong. The test submits a simple job and verifies that it runs successfully. As this occurs during the build process, failure of this test will terminate the build. Currently, Docker Hub does not provide a way to test the entrypoint to make sure it behaves properly. Ideally commonalities between the entrypoint and Grid Engine installation can be found and refactored out into a common script that both can use allowing it to be better tested. No direct testing of `conda` is performed. However, some basic installation and upgrading occurs, which should hopefully verify that it is working. Also, as this is pretty well tested by the team at Continuum, it is believed not to be at as serious of a risk.

# Usage

Once an image is acquired either from one of the provided builds or manually, the image is designed to provide a preconfigured shell environment. Simply run `docker run --rm -it <NAME>`. This will configure Grid Engine and a number of environment variables useful for maintaining it and starts up `bash`. In the case of an automated build, `<NAME>` is `jakirkham/ubuntu_drmaa_conda`.
