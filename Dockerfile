FROM linuxserver/baseimage
MAINTAINER Stian Larsen <lonixx@gmail.com>

ENV APTLIST="python"

RUN apt-get update && \
apt-get install $APTLIST -qy && \
ln -fs /app/unrar /usr/bin/unrar && \
apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/*

#Adding Custom files
ADD init/ /etc/my_init.d/
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh
 
#Mappings
VOLUME /config /downloads
EXPOSE 6789
