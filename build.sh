#!/usr/bin/env sh

# Based on code from https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh

OPENSSL_VERSION=1.1.0l
# OPENSSL_VERSION=1.1.1i
PREFIX=`pwd`

DIRECTORY="openssl-${OPENSSL_VERSION}"

if [ ! -d "$DIRECTORY" ]; then
  echo "Download source code"
  wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
  tar xf openssl-${OPENSSL_VERSION}.tar.gz
fi

cd openssl-${OPENSSL_VERSION}

echo "Configure"
make clean
wasiconfigure ./Configure linux-x32 -no-asm -no-threads -static -no-afalgeng -DOPENSSL_SYS_NETWARE -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_AFALGENG=1 -DOPENSSL_NO_SPEED=1 -DNO_SYSLOG || exit $?
# 1.1.1i
# wasiconfigure ./Configure linux-x32 -no-asm -no-dso -no-threads -no-ui-console -static -no-afalgeng -DOPENSSL_SYS_NETWARE -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_AFALGENG=1 -DOPENSSL_NO_SPEED=1 -DNO_SYSLOG || exit $?

cp ../progs.h apps/progs.h

sed -i 's|^CROSS_COMPILE.*$|CROSS_COMPILE=|g' Makefile

echo "Build"
wasimake make -j12 build_generated libssl.a libcrypto.a # apps/openssl

rm -rf ${PREFIX}/include
mkdir -p ${PREFIX}/include
cp -R include/openssl ${PREFIX}/include

cp libssl.a ${PREFIX}/lib
cp libcrypto.a ${PREFIX}/lib

# cp -R apps/openssl.wasm ../

# echo "Generate libraries .wasm files"
# wasicc libcrypto.a -o ${PREFIX}/libcrypto.wasm
# wasicc libssl.a -o ${PREFIX}/libssl.wasm

# echo "Link"
# wasicc apps/*.o libssl.a libcrypto.a \
#   -o ${PREFIX}/openssl.wasm

# chmod +x ${PREFIX}/openssl.wasm || exit $?

echo "Done"
