#!/bin/sh
# Copyright 2016 The Rust Project Developers. See the COPYRIGHT
# file at the top-level directory of this distribution and at
# http://rust-lang.org/COPYRIGHT.
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
# <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
# option. This file may not be copied, modified, or distributed
# except according to those terms.


set -ex

export CFLAGS="-fPIC"
MUSL=musl-1.1.14
curl http://www.musl-libc.org/releases/$MUSL.tar.gz | tar xzf -
cd $MUSL
./configure --prefix=/musl-x86_64 --disable-shared
make -j10
make install
make clean
cd ..

# To build MUSL we're going to need a libunwind lying around, so acquire that
# here and build it.
curl http://llvm.org/releases/3.7.0/llvm-3.7.0.src.tar.xz | tar xJf -
curl http://llvm.org/releases/3.7.0/libunwind-3.7.0.src.tar.xz | tar xJf -
mkdir libunwind-build
cd libunwind-build
cmake ../libunwind-3.7.0.src -DLLVM_PATH=/build/llvm-3.7.0.src \
          -DLIBUNWIND_ENABLE_SHARED=0
make -j10
cp lib/libunwind.a /musl-x86_64/lib
