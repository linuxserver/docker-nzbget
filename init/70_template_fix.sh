#!/bin/bash

# Fix a potential lack of template config
if [[ -f /usr/share/nzbget/nzbget.conf ]]; then
cp /usr/share/nzbget/nzbget.conf /usr/share/nzbget/webui/
elif [[ -f /usr/share/nzbget/webui/nzbget.conf ]]; then
cp /usr/share/nzbget/webui/nzbget.conf /usr/share/nzbget/
fi
