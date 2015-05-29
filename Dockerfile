FROM ubuntu:12.04
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN useradd -m -s /bin/bash -g sudo user
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 6444
ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

ADD install_miniconda.sh /usr/share/install_miniconda.sh
RUN /usr/share/install_miniconda.sh

USER user
WORKDIR /home/user
