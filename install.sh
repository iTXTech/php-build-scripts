#!/bin/bash

# Requirements: curl, sudo, tar, building tools

PREFIX=/usr/local
SUDO=sudo
DL=wget
PROXYCHAINS=

PHP_VERSION=7.3.8
YAML_VERSION=2.0.4
SWOOLE_VERSION=4.4.4
ZIP_VERSION=1.15.4

set -e

mkdir -p temp
cd temp

$PROXYCHAINS $DL http://www.php.net/distributions/php-$PHP_VERSION.tar.xz
tar -xJf php-$PHP_VERSION.tar.xz
cd php-$PHP_VERSION

./configure \
    --disable-cgi \
    --enable-mbstring \
    --enable-bcmath \
    --enable-pdo \
    --with-mysql-pdo \
    --with-sodium \
    --enable-sockets \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-zlib \
    --with-gmp \
    --with-gd \
    --with-jpeg-dir \
    --with-webp-dir \
    --with-png-dir \
    --with-freetype-dir \
    --enable-pcntl \
    --enable-maintainer-zts \
    --prefix="$PREFIX"

make -j`nproc`
$SUDO make install
cd ..

$PROXYCHAINS git clone https://github.com/krakjoe/pthreads.git --depth=1
cd pthreads
phpize
./configure
make -j`nproc`
$SUDO make install
cd ..

$PROXYCHAINS $DL https://pecl.php.net/get/swoole-$SWOOLE_VERSION.tgz
tar -zxf swoole-$SWOOLE_VERSION.tgz
cd swoole-$SWOOLE_VERSION
phpize
./configure --enable-http2 --enable-sockets --enable-openssl
make -j`nproc`
$SUDO make install
cd ..

$PROXYCHAINS git clone https://github.com/swoole/ext-async.git --depth=1
cd ext-async
phpize
./configure
make -j`nproc`
$SUDO make install
cd ..

$PROXYCHAINS $DL https://pecl.php.net/get/yaml-$YAML_VERSION.tgz
tar -zxf yaml-$YAML_VERSION.tgz
cd yaml-$YAML_VERSION
phpize
./configure
make -j`nproc`
$SUDO make install
cd ..

$PROXYCHAINS $DL https://pecl.php.net/get/zip-$ZIP_VERSION.tgz
tar -zxf zip-$ZIP_VERSION.tgz
cd zip-$ZIP_VERSION
phpize
./configure
make -j`nproc`
$SUDO make install
cd ..

$PROXYCHAINS git clone https://github.com/runkit7/runkit7.git --depth=1
cd runkit7
phpize
./configure
make -j`nproc`
$SUDO make install
cd ..

echo "phar.readonly = off
extension = yaml.so
extension = pthreads.so
extension = swoole.so
extension = swoole_async.so
extension = runkit7.so
extension = zip.so
zend_extension = opcache.so
zend.assertions = -1
" | $SUDO tee "$PREFIX/lib/php.ini" > /dev/null

cd ..
rm -rf temp
