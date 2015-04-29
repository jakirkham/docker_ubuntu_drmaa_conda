FROM ubuntu:12.04
MAINTAINER John Kirkham <jakirkham@gmail.com>

ADD ge_install ge_install
RUN ge_install/install_ge.sh
