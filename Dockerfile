FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# package version
# (stable-download or testing-download)
ARG NZBGET_BRANCH="stable-download"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	p7zip \
	python2 \
	unrar \
	wget && \
 echo "**** install nzbget ****" && \
 mkdir -p \
	/app/nzbget && \
 curl -o \
 /tmp/json -L \
	http://nzbget.net/info/nzbget-version-linux.json && \
 NZBGET_VERSION=$(grep "${NZBGET_BRANCH}" /tmp/json  | cut -d '"' -f 4) && \
 curl -o \
 /tmp/nzbget.run -L \
	"${NZBGET_VERSION}" && \
 sh /tmp/nzbget.run --destdir /app/nzbget && \
 echo "**** configure nzbget ****" && \
 cp /app/nzbget/nzbget.conf /defaults/nzbget.conf && \
 sed -i \
	-e "s#\(MainDir=\).*#\1/downloads#g" \
	-e "s#\(ScriptDir=\).*#\1$\{MainDir\}/scripts#g" \
	-e "s#\(WebDir=\).*#\1$\{AppDir\}/webui#g" \
	-e "s#\(ConfigTemplate=\).*#\1$\{AppDir\}/webui/nzbget.conf.template#g" \
 /defaults/nzbget.conf && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /downloads
EXPOSE 6789
