#!/usr/bin/env sh

# Based on code from https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh

OPENSSL_VERSION=1.1.0l
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
wasiconfigure ./Configure linux-x32 -no-asm -static -no-sock -no-afalgeng -DOPENSSL_SYS_NETWARE -DSIG_DFL=0 -DSIG_IGN=0 -DHAVE_FORK=0 -DOPENSSL_NO_AFALGENG=1 -DOPENSSL_NO_SPEED=1 || exit $?

cp ../progs.h apps/progs.h

sed -i 's|^CROSS_COMPILE.*$|CROSS_COMPILE=|g' Makefile

echo "Build"
wasimake make -j12 build_generated libssl.a libcrypto.a apps/openssl

rm -rf ${PREFIX}/include
mkdir -p ${PREFIX}/include
cp -R include/openssl ${PREFIX}/include

cp -R apps/openssl.wasm ../

# echo "Generate libraries .wasm files"
# wasicc libcrypto.a -o ${PREFIX}/libcrypto.wasm
# wasicc libssl.a -o ${PREFIX}/libssl.wasm

# echo "Link"
# wasicc apps/*.o libssl.a libcrypto.a \
#   -o ${PREFIX}/openssl.wasm

# chmod +x ${PREFIX}/openssl.wasm || exit $?

echo "Done"
