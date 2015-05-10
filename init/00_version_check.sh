#!/bin/bash
UVER=$(curl -s https://bitbucket.org/lonix/$CNAME/raw/master/VERSION)
clear

if [ "$UVER" != "$CVER" ]; then
echo "
----------------------------------
Docker version
-----------------------------------
You are not running the latest version of this docker container, 
Newest: $UVER
Current: $CVER
Changelog, can be found in README.md on bitbucket
to upgrade simply use: 
docker pull lonix/$CNAME
and recreate your docker
-----------------------------------
"
fi