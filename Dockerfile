FROM ubuntu:12.04
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN useradd -m -s /bin/bash -g sudo user
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 6444
ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

USER user
WORKDIR /home/user

ADD install_miniconda.sh /home/user/install_miniconda.sh
RUN /home/user/install_miniconda.sh
