# Buildstage
FROM lsiobase/alpine:arm64v8-3.9 as buildstage

# set NZBGET version
ARG NZBGET_RELEASE

RUN \
 echo "**** install build packages ****" && \
 apk add \
	curl \
	g++ \
	gcc \
	git \
	libxml2-dev \
	libxslt-dev \
	make \
	ncurses-dev \
	openssl-dev && \
 echo "**** build nzbget ****" && \
 if [ -z ${NZBGET_RELEASE+x} ]; then \
	NZBGET_RELEASE=$(curl -sX GET "https://api.github.com/repos/nzbget/nzbget/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p /app/nzbget && \
 git clone https://github.com/nzbget/nzbget.git nzbget && \
 cd nzbget/ && \
 git checkout ${NZBGET_RELEASE} && \
 git cherry-pick -n fa57474d && \
 ./configure \
	bindir='${exec_prefix}' && \
 make && \
 make prefix=/app/nzbget install && \
 sed -i \
	-e "s#^MainDir=.*#MainDir=/downloads#g" \
	-e "s#^ScriptDir=.*#ScriptDir=$\{MainDir\}/scripts#g" \
	-e "s#^WebDir=.*#WebDir=$\{AppDir\}/webui#g" \
	-e "s#^ConfigTemplate=.*#ConfigTemplate=$\{AppDir\}/webui/nzbget.conf.template#g" \
	-e "s#^UnrarCmd=.*#UnrarCmd=$\{AppDir\}/unrar#g" \
	-e "s#^SevenZipCmd=.*#SevenZipCmd=$\{AppDir\}/7za#g" \
	-e "s#^CertStore=.*#CertStore=$\{AppDir\}/cacert.pem#g" \
	-e "s#^CertCheck=.*#CertCheck=yes#g" \
	-e "s#^DestDir=.*#DestDir=$\{MainDir\}/completed#g" \
	-e "s#^InterDir=.*#InterDir=$\{MainDir\}/intermediate#g" \
	-e "s#^LogFile=.*#LogFile=$\{MainDir\}/nzbget.log#g" \
	-e "s#^AuthorizedIP=.*#AuthorizedIP=127.0.0.1#g" \
 /app/nzbget/share/nzbget/nzbget.conf && \
 mv /app/nzbget/share/nzbget/webui /app/nzbget/ && \
 cp /app/nzbget/share/nzbget/nzbget.conf /app/nzbget/webui/nzbget.conf.template && \
 ln -s /usr/bin/7za /app/nzbget/7za && \
 ln -s /usr/bin/unrar /app/nzbget/unrar && \
 cp /nzbget/pubkey.pem /app/nzbget/pubkey.pem && \
 curl -o \
	/app/nzbget/cacert.pem -L \
	"https://curl.haxx.se/ca/cacert.pem"

# Runtime Stage
FROM lsiobase/alpine:arm64v8-3.9

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs,thelamer"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --upgrade --virtual=build-dependencies \
	gcc \
	libc-dev \
	libxml2-dev \
	libxslt-dev \
	make \
	py2-pip \
	python-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	libxml2 \
	libxslt \
	openssl \
	p7zip \
	python2 \
	unrar \
	wget && \
 echo "**** install python packages ****" && \
 pip install --no-cache-dir \
	apprise \
	chardet \
	pynzbget &&\
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files and files from buildstage
COPY --from=buildstage /app/nzbget /app/nzbget
COPY root/ /

# ports and volumes
VOLUME /config /downloads
EXPOSE 6789
