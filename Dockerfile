FROM ubuntu:12.04
MAINTAINER John Kirkham <jakirkham@gmail.com>

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh
