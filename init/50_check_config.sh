#!/bin/bash

if [ ! -f /config/nzbget.conf ]; then
  echo "No config found, copys default now"
  cp -v /app/nzbget.conf /config/nzbget.conf
else
  cp /tmp/nzbget.conf /config/
  chown abc:abc /config/nzbget.conf
  mkdir -p /downloads/dst
  chown -R abc:abc /downloads
fi