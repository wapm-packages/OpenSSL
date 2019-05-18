#!/usr/bin/env sh

# Based on code from https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh

OPENSSL_VERSION=1.1.0h
PREFIX=`pwd`

wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

emconfigure ./Configure linux-generic64 --prefix=${PREFIX}

sed -i 's|^CROSS_COMPILE.*$|CROSS_COMPILE=|g' Makefile

emmake make -j 12 build_generated libssl.a libcrypto.a

rm -rf ${PREFIX}/include
mkdir -p ${PREFIX}/include
cp -R include/openssl ${PREFIX}/include

emcc libcrypto.a -o ${PREFIX}/libcrypto.wasm
emcc libssl.a -o ${PREFIX}/libssl.wasm

cd ..
rm -rf openssl-${OPENSSL_VERSION}*
