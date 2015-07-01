# lonix/nzbget


**sample create command:**

```
docker create --name=<name> -v /etc/localtime:/etc/localtime:ro -v <path to data>:/config -v <path to downloads>:/downloads -e PGID=<gid> -e PUID=<uid>  -p 6789:6789 lonix/nzbget:2.0.1
```

**You need to map**

* PORT: 67889 for Web
* MOUNT: /downloads for download location
* MOUNT: /etc/localhost for timesync (Not required)
* MOUNT: /config for Configuration storage
* VARIABLE: PGID for for GroupID
* VARIABLE: PUID for for UserID

It is based on phusion-baseimage with ssh removed. (use docker exec).


**Credits**

lonix <lonixx@gmail.com>
gfjardim <gfjardim@gmail.com> 


**Versions**

2.2: Changeing release scheme, dropping alot of autobuilds. This one will log if new version is avalible
2.1: Updated to nzbget14, and changed to unrar-shareware
2.0.1: Added a lost Configfile.
2.0: Lots of updates, selctable uid/gid.
1.0: Inital release

