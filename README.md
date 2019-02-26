[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# [linuxserver/nzbget](https://github.com/linuxserver/docker-nzbget)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/nzbget.svg)](https://microbadger.com/images/linuxserver/nzbget "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/nzbget.svg)](https://microbadger.com/images/linuxserver/nzbget "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/nzbget.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/nzbget.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-nzbget/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-nzbget/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/nzbget/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/nzbget/latest/index.html)

[Nzbget](http://nzbget.net/) is a usenet downloader, written in C++ and designed with performance in mind to achieve maximum download speed by using very little system resources.

[![nzbget](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/nzbget-banner.png)](http://nzbget.net/)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/). 

Simply pulling `linuxserver/nzbget` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |

## Version Tags

This image provides various versions that are available via tags. `latest` tag usually provides the latest stable version. Others are considered under development and caution must be exercised when using them.

| Tag | Description |
| :----: | --- |
| latest | Stable nzbget releases |
| testing | nzbget pre-releases |

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=nzbget \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Europe/London \
  -p 6789:6789 \
  -v <path to data>:/config \
  -v <path/to/downloads>:/downloads \
  --restart unless-stopped \
  linuxserver/nzbget
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  nzbget:
    image: linuxserver/nzbget
    container_name: nzbget
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/London
    volumes:
      - <path to data>:/config
      - <path/to/downloads>:/downloads
    ports:
      - 6789:6789
    mem_limit: 4096m
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 6789` | WebUI |
| `-e PUID=1001` | for UserID - see below for explanation |
| `-e PGID=1001` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /config` | NZBGet App data. |
| `-v /downloads` | Location of downloads on disk. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```


&nbsp;
## Application Setup

Webui can be found at  `<your-ip>:6789` and the default login details (change ASAP) are

`login:nzbget, password:tegbzn6789`

To allow scheduling, from the webui set the time correction value in settings/logging.

To change umask settings.

![](http://i.imgur.com/A4VMbwE.png)

scroll to bottom, set umask like this (example shown for unraid)

![](http://i.imgur.com/mIqDEJJ.png)

You can add an additional mount point for intermediate unpacking folder with:-

`-v </path/to/intermedia_unpacking_folder>:/intermediate`

for example, and changing the setting for InterDir in the PATHS tab of settings to `/intermediate`



## Support Info

* Shell access whilst the container is running: `docker exec -it nzbget /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f nzbget`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' nzbget`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/nzbget`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/nzbget`
* Stop the running container: `docker stop nzbget`
* Delete the container: `docker rm nzbget`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start nzbget`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update the image: `docker-compose pull linuxserver/nzbget`
* Let compose update containers as necessary: `docker-compose up -d`
* You can also remove the old dangling images: `docker image prune`

## Versions

* **22.02.19:** - Rebasing to alpine 3.9.
* **20.01.19:** - Add pipeline logic and multi arch, build from source.
* **21.08.18:** - Rebase to alpine 3.8.
* **20.02.18:** - Add note about supplemental mount point for intermediate unpacking.
* **13.12.17:** - Rebase to alpine 3.7.
* **02.09.17:** - Place app in subfolder rather than /app.
* **12.07.17:** - Add inspect commands to README, move to jenkins build and push.
* **28.05.17:** - Rebase to alpine 3.6.
* **20.04.17:** - Add testing branch.
* **06.02.17:** - Rebase to alpine 3.5.
* **30.09.16:** - Fix umask.
* **09.09.16:** - Add layer badges to README.
* **27.08.16:** - Add badges to README, perms fix on /app to allow updates.
* **19.08.16:** - Rebase to alpine linux.
* **18.08.15:** - Now useing latest version of unrar beta and implements the universal installer method.
