#!/bin/bash

# Requirements: curl, bsdtar

set -e
shopt -s extglob

PHP_VERSION="7.0.9"
PHP_VERSION_BASE="${PHP_VERSION:0:3}"
EXTENSIONS="pthreads weakref yaml"
pthreads_VERSION="3.1.6"
weakref_VERSION="0.3.2"
yaml_VERSION="2.0.0RC8"
CYGWIN_PACKAGES="cygwin mintty"
cygwin_VERSION="2.5.2-1"
mintty_VERSION="2.4.2-0"

get () {
    echo "Downloading and extracting ${1}..."
    curl -fsSL "${1}" | bsdtar -xf - -C "work/${2}" "${@:3}"
    echo "${1} downloaded and extracted."
}

get_noextract () {
    echo "Downloading ${1}..."
    (cd work/${2} && curl -fsSLOJ "${1}")
    echo "${1} downloaded and saved."
}

get_cygwin () {
    get "${1}" "${2}" --strip-components 2 usr/bin
}

pack () {
    echo "Archiving files..."
    bsdtar -acf "${1}" -C work -s '/.//' .
    echo "Compressed archive can be found at ${1}."
}

for ARCH in x86 x64; do
    mkdir -p work
    mkdir -p work/bin/php/ext
    get "http://windows.php.net/downloads/releases/php-${PHP_VERSION}-Win32-VC14-${ARCH}.zip" bin/php &
    for EXT in $EXTENSIONS; do
        EXT_VER_TEMP="${EXT}_VERSION"
        EXT_VER="${!EXT_VER_TEMP}"
        get "http://windows.php.net/downloads/pecl/releases/${EXT}/${EXT_VER}/php_${EXT}-${EXT_VER}-${PHP_VERSION_BASE}-ts-vc14-${ARCH}.zip" bin/php/ext &
    done
    mkdir -p work/bin
    CYGWIN_ARCH=x86_`[ ARCH = "x64" ] && echo 64 || true`
    for PKG in $CYGWIN_PACKAGES; do
        PKG_VER_TEMP="${PKG}_VERSION"
        PKG_VER="${!PKG_VER_TEMP}"
        get_cygwin "https://mirrors.kernel.org/sourceware/cygwin/x86/release/${PKG}/${PKG}-${PKG_VER}.tar.xz" bin &
    done
    get_noextract "https://raw.githubusercontent.com/iTXTech/Genisys/master/start.cmd" &
    echo ";Custom Genisys php.ini file
zend.enable_gc = On
max_execution_time = 0
error_reporting = -1
display_errors = stderr
display_startup_errors = On
register_argc_argv = On
default_charset = \"UTF-8\"
include_path = \".;.\ext\"
extension_dir = \"./ext/\"
enable_dl = On
allow_url_fopen = On
extension=php_bz2.dll
extension=php_weakref.dll
extension=php_curl.dll
extension=php_mysqli.dll
extension=php_sqlite3.dll
extension=php_sockets.dll
extension=php_mbstring.dll
extension=php_yaml.dll
extension=php_pthreads.dll
extension=php_com_dotnet.dll
extension=php_openssl.dll
zend_extension=php_opcache.dll
;zend_extension=php_xdebug.dll
cli_server.color = On
phar.readonly = Off
phar.require_hash = On
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.save_comments=1
opcache.load_comments=1
opcache.fast_shutdown=0
opcache.optimization_level=0xffffffff
" > work/bin/php/php.ini
    wait
    # Assuming such libraries exist.
    mv work/bin/php/ext/!(php_*).dll work/bin/php/
    find work -type f -not -name "*.dll" -not -name "*.exe" -not -name "php.ini" -not -name "start.cmd" -print0 | xargs -0 rm -f
    pack "php_${PHP_VERSION}_${ARCH}.zip"
    rm -rf work
done
