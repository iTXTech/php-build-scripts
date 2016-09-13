## Script for building Windows PHP packages

The script need to be ran on Linux.
Dependencies: aria2, bsdtar

## Script for building and installing PHP on Linux

Run this to build and install PHP configure to match your environment.
You need basic compiler package group, build dependencies and curl, sudo, tar.

The following is just for reference:  
* For Debian-based distros: `libssl-dev autoconf pkg-config curl libedit-dev libsqlite3-dev libxml2-dev libcurl4-openssl-dev libyaml-dev`
* For RPM-based-distros: `autoconf pkg-config curl libedit-devel libsqlite3-devel libxml2-devel libyaml-devel libcurl-devel`

Environment variable "$PREFIX" can be set to install to other locations (must be absolute path). The default is /usr/local, which most time has the highest priority in the PATH.

## Home based install with phpbrew

After installing [phpbrew](https://github.com/phpbrew/phpbrew#install), you can build with the following flags:
```
phpbrew install -j$(nproc) latest +neutral-cgi+mbstring+bcmath+sockets+curl+editline+openssl+zlib+pcntl+zts
phpbrew ext install yaml latest
phpbrew ext install pthreads latest
phpbrew ext install weakref latest
```
