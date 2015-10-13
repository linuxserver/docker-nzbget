#!/bin/bash


#Checks if nzbget is installed, and grabs the current version if it is.
LOCAL_VERSION=0
if [ -x /app/nzbget ];  then
	LOCAL_VERSION=$(/app/nzbget -v | cut -d " " -f 3)
fi

#downloads the version json and stores the data temporary

curl -o /tmp/json http://nzbget.net/info/nzbget-version-linux.json


#Grabbing relevant data out of json
if [ "$TESTING" ]; then
	echo "Useing TESTING branch:"
	REMOTE_VERSION=$(grep testing-version /tmp/json | cut -d '"' -f 4)
	DOWNLOAD=$(grep testing-download /tmp/json | cut -d '"' -f 4)
else
	echo "Useing STABLE Branch:"
	REMOTE_VERSION=$(grep stable-version /tmp/json | cut -d '"' -f 4)
	DOWNLOAD=$(grep stable-download /tmp/json  | cut -d '"' -f 4)
fi

if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
		echo "Not up-to-date\Installed"
		wget -O /tmp/nzbget.run "$DOWNLOAD"
		/sbin/setuser abc sh /tmp/nzbget.run --destdir /app
		if [ -x /app/nzbget ]; then echo "Install successfull"; fi
fi
