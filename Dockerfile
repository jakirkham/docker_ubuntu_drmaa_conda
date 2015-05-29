FROM ubuntu:12.04
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN useradd -m -s /bin/bash -g sudo user
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

ADD install_miniconda.sh /usr/share/install_miniconda.sh
RUN /usr/share/install_miniconda.sh

ADD supervisord.conf /etc/supervisord.conf
RUN mkdir /usr/share/supervisor
ADD install_supervisor.sh /usr/share/supervisor/install_supervisor.sh
RUN /usr/share/supervisor/install_supervisor.sh

USER user
WORKDIR /home/user

EXPOSE 6444 10389 22
CMD ["/usr/bin/supervisord"]
