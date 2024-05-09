# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/unrar:latest as unrar

FROM ghcr.io/linuxserver/baseimage-alpine:3.19 as buildstage

# set NZBGET version
ARG NZBGET_RELEASE

RUN \
  echo "**** install build packages ****" && \
  apk add \
    boost-dev \
    build-base \
    cmake \
    git \
    libxml2-dev \
    libxslt-dev \
    ncurses-dev \
    openssl-dev && \
  echo "**** build nzbget ****" && \
  if [ -z ${NZBGET_RELEASE+x} ]; then \
    NZBGET_RELEASE=$(curl -sX GET "https://api.github.com/repos/nzbgetcom/nzbget/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p /nzbget && \
  git clone https://github.com/nzbgetcom/nzbget.git nzbget && \
  cd nzbget/ && \
  git checkout ${NZBGET_RELEASE} && \
  mkdir -p build && \
  cd build && \
  cmake .. -DCMAKE_INSTALL_PREFIX=/app/nzbget && \
  cmake --build . -j 2 && \
  cmake --install . && \
  mv /app/nzbget/bin/nzbget /app/nzbget/ && \
  rm -rf /app/nzbget/bin/ && \
  rm -rf /app/nzbget/etc/ && \
  sed -i \
    -e "s|^MainDir=.*|MainDir=/downloads|g" \
    -e "s|^ScriptDir=.*|ScriptDir=$\{MainDir\}/scripts|g" \
    -e "s|^WebDir=.*|WebDir=$\{AppDir\}/webui|g" \
    -e "s|^ConfigTemplate=.*|ConfigTemplate=$\{AppDir\}/webui/nzbget.conf.template|g" \
    -e "s|^UnrarCmd=.*|UnrarCmd=unrar|g" \
    -e "s|^SevenZipCmd=.*|SevenZipCmd=7z|g" \
    -e "s|^CertStore=.*|CertStore=$\{AppDir\}/cacert.pem|g" \
    -e "s|^CertCheck=.*|CertCheck=yes|g" \
    -e "s|^DestDir=.*|DestDir=$\{MainDir\}/completed|g" \
    -e "s|^InterDir=.*|InterDir=$\{MainDir\}/intermediate|g" \
    -e "s|^LogFile=.*|LogFile=$\{MainDir\}/nzbget.log|g" \
    -e "s|^AuthorizedIP=.*|AuthorizedIP=127.0.0.1|g" \
  /app/nzbget/share/nzbget/nzbget.conf && \
  mv /app/nzbget/share/nzbget/webui /app/nzbget/ && \
  cp /app/nzbget/share/nzbget/nzbget.conf /app/nzbget/webui/nzbget.conf.template && \
  ln -s /usr/bin/7z /app/nzbget/7za && \
  ln -s /usr/bin/unrar /app/nzbget/unrar && \
  cp /nzbget/pubkey.pem /app/nzbget/pubkey.pem && \
  curl -o /app/nzbget/cacert.pem -L "https://curl.se/ca/cacert.pem"

# Runtime Stage
FROM ghcr.io/linuxserver/baseimage-alpine:3.19

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --upgrade --virtual=build-dependencies \
    build-base && \
  echo "**** install packages ****" && \
  apk add --no-cache \
    7zip \
    boost1.82-json \
    libxml2 \
    libxslt \
    openssl \
    python3 && \
  echo "**** install python packages ****" && \
  python3 -m venv /lsiopy && \
  pip install -U --no-cache-dir \
    pip \
    wheel && \
  pip install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.19/ \
    apprise \
    pynzb \
    requests && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root/.cache \
    /root/.cargo \
    /tmp/*

# add local files and files from buildstage
COPY --from=buildstage /app/nzbget /app/nzbget
COPY root/ /

# add unrar
COPY --from=unrar /usr/bin/unrar-alpine /usr/bin/unrar

# ports and volumes
VOLUME /config
EXPOSE 6789
