#!/usr/bin/env sh

# Based on code from https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh

OPENSSL_VERSION=1.1.0h
PREFIX=`pwd`

echo "Download source code"
rm -rf openssl-${OPENSSL_VERSION}*
wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

echo "Configure"
make clean
emconfigure ./Configure linux-x32 -no-asm -no-threads --prefix=${PREFIX} || exit $?

sed -i 's|^CROSS_COMPILE.*$|CROSS_COMPILE=|g' Makefile

echo "Build"
emmake make -j 12 build_generated libssl.a libcrypto.a apps/openssl

rm -rf ${PREFIX}/include
mkdir -p ${PREFIX}/include
cp -R include/openssl ${PREFIX}/include

echo "Generate libraries .wasm files"
emcc libcrypto.a -o ${PREFIX}/libcrypto.wasm
emcc libssl.a -o ${PREFIX}/libssl.wasm

echo "Link"
emcc apps/*.o libssl.a libcrypto.a \
  -o ${PREFIX}/openssl.wasm \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s ERROR_ON_UNDEFINED_SYMBOLS=0
chmod +x ${PREFIX}/openssl.wasm || exit $?

echo "Clean"
cd ..
rm -rf openssl-${OPENSSL_VERSION}*

echo "Done"
