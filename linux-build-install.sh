#!/bin/bash

# Requirements: curl, sudo, tar, building tools

[ -z "${PREFIX}" ] && PREFIX=/usr/local
[ -w "${PREFIX}" ] || SUDO=sudo

set -e

mkdir -p work
cd work

curl -fsSL http://www.php.net/distributions/php-7.0.23.tar.xz | tar -xJf - --strip-components=1

./configure \
    --disable-cgi \
    --enable-mbstring \
    --enable-bcmath \
    --enable-pdo \
    --enable-sockets \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-zlib \
	--with-gmp \
    --enable-pcntl \
    --enable-maintainer-zts \
    --prefix="${PREFIX}"

make -j`nproc`
$SUDO make install

$SUDO "${PREFIX}/bin/pecl" install channel://pecl.php.net/pthreads-3.1.6 channel://pecl.php.net/weakref-0.3.3 channel://pecl.php.net/yaml-2.0.2 channel://pecl.php.net/zip-1.15.1
echo "phar.readonly = off
extension = yaml.so
extension = pthreads.so
extension = weakref.so
extension = zip.so
zend_extension = opcache.so
zend.assertions = -1
" | $SUDO tee "${PREFIX}/lib/php.ini" > /dev/null

cd ..
rm -rf work
