#!/usr/bin/env sh

# Based on code from https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh

OPENSSL_VERSION=1.1.0h
PREFIX=`pwd`

wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

emconfigure ./Configure linux-generic64 --prefix=${PREFIX}

sed -i 's|^CROSS_COMPILE.*$|CROSS_COMPILE=|g' Makefile

emmake make -j 12 build_generated libssl.a libcrypto.a apps/openssl

rm -rf ${PREFIX}/include
mkdir -p ${PREFIX}/include
cp -R include/openssl ${PREFIX}/include

emcc libcrypto.a -o ${PREFIX}/libcrypto.wasm
emcc libssl.a -o ${PREFIX}/libssl.wasm
emcc apps/app_rand.o apps/apps.o apps/asn1pars.o apps/ca.o apps/ciphers.o \
  apps/cms.o apps/crl.o apps/crl2p7.o apps/dgst.o apps/dhparam.o apps/dsa.o \
  apps/dsaparam.o apps/ec.o apps/ecparam.o apps/enc.o apps/engine.o \
  apps/errstr.o apps/gendsa.o apps/genpkey.o apps/genrsa.o apps/nseq.o \
  apps/ocsp.o apps/openssl.o apps/opt.o apps/passwd.o apps/pkcs12.o \
  apps/pkcs7.o apps/pkcs8.o apps/pkey.o apps/pkeyparam.o apps/pkeyutl.o \
  apps/prime.o apps/rand.o apps/rehash.o apps/req.o apps/rsa.o apps/rsautl.o \
  apps/s_cb.o apps/s_client.o apps/s_server.o apps/s_socket.o apps/s_time.o \
  apps/sess_id.o apps/smime.o apps/speed.o apps/spkac.o apps/srp.o apps/ts.o \
  apps/verify.o apps/version.o apps/x509.o libssl.a libcrypto.a \
  -o ${PREFIX}/openssl.wasm \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s ERROR_ON_UNDEFINED_SYMBOLS=0

cd ..
rm -rf openssl-${OPENSSL_VERSION}*
