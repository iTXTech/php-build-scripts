## Script for building Windows PHP packages

The script need to be ran on Linux.
Dependencies: bsdtar, curl

## Script for building and installing PHP on Linux

Run this to build and install PHP configure to match your environment.
You need basic compiler package group, build dependencies and curl, sudo, tar.
* For Debian-based distros: `apt install libssl-dev autoconf pkg-config curl libedit-dev libsqlite3-dev libxml2-dev libcurl4-openssl-dev libyaml-dev`
* For RPM-based-distros: `yum install autoconf pkg-config curl libedit-devel libsqlite3-devel libxml2-devel libyaml-devel libcurl-devel`  
Note that you probably want dnf instead on Fedora.

Environment variable "$PREFIX" can be set to install to other locations.
