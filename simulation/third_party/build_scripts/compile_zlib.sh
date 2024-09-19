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

ORGPATH=$PATH
export PATH="$TOOLCHAIN/bin:${PATH}"
# Setup Compiler Variables
export CHOST=${ARCH_SYSROOT}$
export CHOST2=${COMPILER_PREFIX}$API
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
echo "CC used: $CC"
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
echo "CXX used: $CXX"
export LD=$TOOLCHAIN/bin/ld
export LLD=$TOOLCHAIN/bin/lld
export NM=$TOOLCHAIN/bin/llvm-nm
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

# Setup Additional Flags
export SYSROOT="$TOOLCHAIN/sysroot"
# export CFLAGS=""
export CFLAGS="-I${SYSROOT}/usr/include --sysroot $SYSROOT -fPIC"
export CXXFLAGS="-I$SYSROOT/usr/include --sysroot $SYSROOT -fPIC"
export CPPFLAGS=${CXXFLAGS}
export ARFLAGS="cr"
export LDFLAGS="--sysroot $SYSROOT -L$SYSROOT/usr/lib"

PARAMS="--shared "
#case $ARCH in
#    "aarch64"|"x86_64")
#	PARAMS="${PARAMS} --64";;
#    *) ;;
#esac

cd ../zlib/source
./configure --prefix="$SYSROOT/usr" ${PARAMS}
make && make install
make clean
export PATH=${ORGPATH}
cd ../../build_scripts
