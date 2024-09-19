#!/bin/bash

# ABI=${1:-arm64-v8a}
# NDK=${2:-/home/martin/Android/Sdk/ndk/25.1.8937393}
echo "Using ABI: ${ABI}"
echo "Using NDK location: ${NDK}"
echo "Using architecture: ${ARCH} (compiler prefix: ${COMPILER_PREFIX})"

# Define NDK path and toolchain
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
export TARGET=$COMPILER_PREFIX
API=21
ARCH1=${ARCH}
ABIDEF="android"
case $ARCH in
    "armv7a")
        API=17
	ARCH1="arm"
	ABIDEF="androideabi";;
    "i686")
        API=17;;
    *) ;;
esac

export PATH="$TOOLCHAIN/bin:${PATH}"

# Setup Compiler Variables
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export NM=$TOOLCHAIN/bin/llvm-nm
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

# Setup Additional Flags
export SYSROOT="$TOOLCHAIN/sysroot"
export CFLAGS="-I$SYSROOT/usr/include --sysroot $SYSROOT"
export CXXFLAGS="-I$SYSROOT/usr/include --sysroot $SYSROOT -fPIC"
export CPPFLAGS=${CXXFLAGS}
export ARFLAGS="cr"
export LDFLAGS="--sysroot $SYSROOT -L${SYSROOT}/usr/lib/${ARCH_SYSROOT}/$API -fPIC"


cd ../hdf5/source
./configure --host=$TARGET --prefix="$SYSROOT/usr" --with-sysroot="$SYSROOT" --with-zlib="${SYSROOT}/usr/lib/${ARCH_SYSROOT}/$API" --enable-shared --disable-static --enable-cxx --enable-java --with-pic --enable-build-mode=production --enable-optimization=high #  --enable-hl
make && make install 
make clean
export PATH=${ORGPATH}
cd ../../build_scripts
