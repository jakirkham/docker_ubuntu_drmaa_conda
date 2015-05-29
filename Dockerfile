FROM ubuntu:12.04
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN useradd -m -s /bin/bash -g sudo user
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

USER user
WORKDIR /home/user
