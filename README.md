# OpenSSL

You can install OpenSSL with:

```shell
wapm install openssl
```

## Running

You can run OpenSSL cli

```shell
$ wapm run openssl
OpenSSL>
```

## Building from Source

You will need Emscripten SDK (emsdk) to build the `openssl.wasm` file.

Steps:

1. Setup emsdk (>= 1.38.11), see
   [Installation Instructions](https://github.com/juj/emsdk#installation-instructions)
2. Run `./build.sh`

Build script inspired by
[TrueBitFoundation](https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh)
