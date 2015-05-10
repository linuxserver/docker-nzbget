FROM phusion/baseimage:0.9.16
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV TERM screen
MAINTAINER Stian Larsen <lonixx@gmail.com>

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

ADD https://github.com/gfjardim/nzbget-updates/raw/master/libpar2-1_0.4-3patched_amd64.deb /src/libpar2.deb
ADD https://github.com/gfjardim/nzbget-updates/raw/master/nzbget-STABLE-amd64.deb /src/nzbget.deb
ADD nzbget.conf /tmp/nzbget.conf

RUN add-apt-repository ppa:jon-severinsson/ffmpeg && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
apt-get update -q && \
apt-get install -qy libxml2 sgml-base libsigc++-2.0-0c2a python2.7-minimal xml-core javascript-common libjs-jquery libjs-jquery-metadata libjs-jquery-tablesorter libjs-twitter-bootstrap libpython-stdlib python2.7 python-minimal python ffmpeg wget unrar unzip p7zip nzbget && \
curl -o /tmp/rar.tar.gz http://rarlabs.com/rar/rarlinux-x64-5.2.b4.tar.gz && \
tar xvf /tmp/rar.tar.gz  -C /tmp && \
cp -v /tmp/rar/*rar /usr/bin/ && \
dpkg -P nzbget && \
dpkg -P libpar2-1 && \
dpkg -i /src/libpar2.deb && \
dpkg -i /src/nzbget.deb && \
apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*

#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh
 
#Adduser
RUN useradd -u 911 -U -s /bin/false abc
RUN usermod -G users abc


#Mappings
VOLUME /config
VOLUME /downloads

EXPOSE 6789