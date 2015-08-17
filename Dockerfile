FROM linuxserver/baseimage
MAINTAINER Stian Larsen <lonixx@gmail.com>


ADD nzbget.conf /tmp/nzbget.conf

RUN apt-get update && \
apt-get install -y wget && \
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
