FROM linuxserver/baseimage
MAINTAINER Stian Larsen <lonixx@gmail.com>

RUN apt-get update && \
apt-get install -y wget python && \
curl -o /tmp/rar.tar.gz http://www.rarlab.com/rar/rarlinux-x64-5.3.b5.tar.gz && \
tar xvf /tmp/rar.tar.gz  -C /tmp && \
cp -v /tmp/rar/*rar /usr/bin/ && \
mkdir -p /app && chown abc:abc /app && \
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
