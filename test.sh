#!/usr/bin/env sh

../wasmer/target/release/wasmer run -- \
  openssl.wasm genrsa -des3 -out priv.key 2048 || exit $?
