FROM linuxserver/baseimage
MAINTAINER Stian Larsen <lonixx@gmail.com>

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]


ADD nzbget.conf /tmp/nzbget.conf

RUN add-apt-repository ppa:mc3man/trusty-media && \
apt-add-repository ppa:modriscoll/nzbget && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" && \
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" && \
apt-get update -q && \
apt-get install -qy libxml2 sgml-base libsigc++-2.0-0c2a python2.7-minimal xml-core javascript-common libjs-jquery libjs-jquery-metadata libjs-jquery-tablesorter libjs-twitter-bootstrap libpython-stdlib python2.7 python-minimal python ffmpeg wget unrar unzip p7zip && \
apt-get install nzbget -y --force-yes && \
curl -o /tmp/rar.tar.gz http://www.rarlab.com/rar/rarlinux-x64-5.2.1b2.tar.gz&& \
tar xvf /tmp/rar.tar.gz  -C /tmp && \
cp -v /tmp/rar/*rar /usr/bin/ && \
apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*

#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run
RUN chmod -v +x /etc/my_init.d/*.sh
 
#Mappings
VOLUME /config
VOLUME /downloads

EXPOSE 6789
