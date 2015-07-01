![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](http://linuxserver.io) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](http://forum.linuxserver.io) or for real-time support our [IRC](http://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/NZBGet

![] ()

[NZBGet](http://nzbget.net/) NZBGet is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources. It supports all platforms including Windows, Mac, Linux and works on all devices including PC, NAS, WLAN routers and media players.

## Usage

```
docker create \
	--name <containter-name> \
	-p <port>:<port> \
	-e PUID=<UID> -e PGID=<GID> \
	-v </path/to/appdata>:/config \
	-v <path/to/tvseries>:/tv \
	linuxserver/name
```

**Parameters**

* `-p <port>` - the port X webinterface
* `-v /config` - x App data
* `-v /x` - location of x on disk
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.  

## Updates / Monitoring

* Upgrade to the latest version of x simply `docker restart <container-name>`.
* Monitor the logs of the container in realtime `docker logs -f <container-name>`.

**Credits**

* lonix <lonixx@gmail.com>
* IronicBadger <ironicbadger@linuxserver.io>