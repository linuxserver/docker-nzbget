#!/bin/bash

if [ -f /config/nzbget.conf ]; then
  exit 0
else
  cp /tmp/nzbget.conf /config/
  chown abc:abc /config/nzbget.conf
  mkdir -p /downloads/dst
  chown -R abc:abc /downloads
fi