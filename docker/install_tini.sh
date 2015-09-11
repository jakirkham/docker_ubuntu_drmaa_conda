#!/bin/bash

apt-get install -y curl grep sed dpkg
TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'`
curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb
dpkg -i tini.deb
rm tini.deb
apt-get clean
