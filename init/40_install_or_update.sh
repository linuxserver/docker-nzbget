#!/bin/bash


#Checks if nzbget is installed, and grabs the current version if it is.
LOCAL_VERSION=0
if [ -x /app/nzbget ];  then
	LOCAL_VERSION=$(/app/nzbget -v | cut -d " " -f 3)
fi

#downloads the version json and stores the data temporary

curl -o /tmp/json http://nzbget.net/info/nzbget-version-linux.json


#Grabbing relevant data out of json
TESTING_VERSION=$()
if [ $TESTING ]; then
	echo "Useing TESTING branch:"
	REMOTE_VERSION=$(cat /tmp/json | grep testing-version | cut -d '"' -f 4)
	DOWNLOAD=$(cat /tmp/json | grep testing-download | cut -d '"' -f 4)
else
	echo "Useing STABLE Branch:"
	REMOTE_VERSION=$(cat /tmp/json | grep stable-version | cut -d '"' -f 4)
	DOWNLOAD=$(cat /tmp/json | grep stable-download | cut -d '"' -f 4)
fi

if [ $LOCAL_VERSION != $REMOTE_VERSION ]; then
		echo "Not up-to-date\Installed"
		wget -O /tmp/nzbget.run $DOWNLOAD
		/sbin/setuser abc sh /tmp/nzbget.run --destdir /app
		if [ -x /app/nzbget ]; then echo "Install successfull"; fi
fi