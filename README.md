![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](http://linuxserver.io) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](http://forum.linuxserver.io) or for real-time support our [IRC](http://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/NZBGet

[NZBGet](http://nzbget.net/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.

## Usage

```
docker create \
	--name nzbget \
	-p 6789:6789 \
	-e PUID=<UID> -e PGID=<GID> \
	-v </path/to/appdata>:/config \
	-v <path/to/downloads>:/downloads \
	linuxserver/nzbget
```

This container is based on phusion-baseimage with ssh removed. For shell access whilst the container is running do `docker exec -it nzbget /bin/bash`.

**Parameters**

* `-p 6789` - NZBGet WebUI Port
* `-v /config` - NZBGet App data
* `-v /downloads` - location of downloads on disk
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.  

## Updates / Monitoring

* Upgrade to the latest version of NZBGet simply `docker restart nzbget`.
* Monitor the logs of the container in realtime `docker logs -f nzbget`.
* If you wish to use unstable testing branch of nzbget, add -e TESTING=1 to your run command or template settings.
* REMEMBER it is called unstable for a reason.
* To allow scheduling, withing settings/logging set the time correction value

#### Changelog
+ **18.08.2015:** Now useing latest version of unrar beta and implements the universal installer method. 
