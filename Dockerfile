FROM ubuntu:12.04
MAINTAINER John Kirkham <jakirkham@gmail.com>


RUN apt-get update && apt-get install -y sudo

RUN groupadd wheel
RUN useradd -m -s /bin/bash -g wheel user
RUN echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

ENV SGE_ROOT=/var/lib/gridengine \
    SGE_CELL=default \
    DRMAA_LIBRARY_PATH=/usr/lib/libdrmaa.so.1.0

ADD supervisor /usr/share/supervisor
RUN mv /usr/share/supervisor/supervisord.conf /etc/supervisord.conf
RUN /usr/share/supervisor/install_supervisor.sh

ADD install_miniconda.sh /usr/share/install_miniconda.sh
RUN /usr/share/install_miniconda.sh

ENV PATH=/opt/conda/bin:$PATH

USER user
WORKDIR /home/user

EXPOSE 6444 10389 22
CMD ["/usr/bin/supervisord"]
