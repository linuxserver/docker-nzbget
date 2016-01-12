#!/bin/bash
chown -R abc:abc /app

if [ ! -f /config/nzbget.conf ]; then
  echo "No config found, copys default now"
  cp -v /app/nzbget.conf /config/nzbget.conf
  echo "Changeing some defaults to match our container"
  sed -i -e "s#\(MainDir=\).*#\1/downloads#g" /config/nzbget.conf
  sed -i -e "s#\(UMask=\).*#\1000#g" /config/nzbget.conf
  sed -i -e "s#\(ScriptDir=\).*#\1$\{MainDir\}/scripts#g" /config/nzbget.conf
  sed -i -e "s#\(ControlIP=\).*#\10.0.0.0#g" /config/nzbget.conf
  chown abc:abc /config/nzbget.conf
  chmod u+rw /config/nzbget.conf
  mkdir -p /downloads/dst
  chown -R abc:abc /downloads
fi


echo "Checking som config options"
sed -i -e "s#\(WebDir=\).*#\1$\{AppDir\}/webui#g" /config/nzbget.conf
sed -i -e "s#\(ConfigTemplate=\).*#\1$\{AppDir\}/webui/nzbget.conf.template#g" /config/nzbget.conf
sed -i -e "s#\(LogFile=\).*#\1$\{MainDir\}/nzbget.log#g" /config/nzbget.conf
