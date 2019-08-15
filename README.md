# Build [PHP](https://secure.php.net) for [SimpleFramework](https://github.com/iTXTech/SimpleFramework)

The recommended [PHP](https://secure.php.net) environment for running [SimpleFramework](https://github.com/iTXTech/SimpleFramework).

Features:

1. Thread Safe
1. Integrated extensions: `sodium`, `gd` and more
1. Extended extensions: `swoole`, `yaml`, `pthreads`, `runkit7` and `zip`

## Build on Linux

### Dependencies

* For Debian-based distros: `libssl-dev autoconf pkg-config curl libedit-dev libsqlite3-dev libxml2-dev libcurl4-openssl-dev libyaml-dev libzip-dev libgmp-dev libsodium-dev libjpeg-dev libpng-dev libwebp-dev libfreetype6-dev`
* For RPM-based-distros: `autoconf pkg-config curl libedit-devel libsqlite3-devel libxml2-devel libyaml-devel libcurl-devel libzip-last-devel gmp-devel` and more

* If you are using Ubuntu 17.04, configure can not locate the libcurl, so you need to `sudo ln -s /usr/include/x86_64-linux-gnu/curl /usr/include`

### Install system wide

`$ curl -fsSL https://raw.githubusercontent.com/iTXTech/php-build-scripts/master/install.sh | bash`

### Customize your install script

```bash
$ wget https://raw.githubusercontent.com/iTXTech/php-build-scripts/master/install.sh
$ nano install.sh #modify something, like changing DL to aria2c -s16 -x16
$ bash install.sh
```

## Build on macOS

1. Install dependencies using [homebrew](https://brew.sh/)
1. You will have to specify the location of libraries in `install.sh`

## Windows Binary

See [releases](https://github.com/iTXTech/php-build-scripts/releases)

Include `pthreads` and `yaml`.

`runkit7` will be available shortly.
