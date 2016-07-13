FROM lsiobase/alpine
MAINTAINER sparklyballs

# package version (stable-download or testing-download)
ARG NZBGET_BRANCH="testing-download"

# environment
ARG NZBG_ROOT="/tmp"
ARG NZBG_WWW="http://nzbget.net/info/nzbget-version-linux.json"

# install packages
RUN \
 apk add --no-cache \
	curl \
	p7zip \
	python \
	unrar \
	wget

# install nzbget
RUN \
 curl -o \
 "${NZBG_ROOT}/json" -L \
	"${NZBG_WWW}" && \
 NZBGET_VERSION=$(grep "${NZBGET_BRANCH}" "${NZBG_ROOT}/json"  | cut -d '"' -f 4) && \
 curl -o \
 "${NZBG_ROOT}/nzbget.run" -L \
	"${NZBGET_VERSION}" && \
 sh "${NZBG_ROOT}/nzbget.run" --destdir /app && \

# cleanup
 rm -rfv \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /downloads
EXPOSE 6789
