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

You will need [Wasienv](https://github.com/wasienv/wasienv) to build the `openssl.wasm` file.

Steps:

1. Setup wasienv, see
   [Installation Instructions](https://github.com/wasienv/wasienv)
2. Run `./build.sh`

Build script inspired by
[TrueBitFoundation](https://github.com/TrueBitFoundation/wasm-ports/blob/master/openssl.sh)
