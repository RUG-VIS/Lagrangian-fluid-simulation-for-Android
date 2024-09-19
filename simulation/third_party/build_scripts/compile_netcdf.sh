#!/bin/bash

# ABI=${1:-arm64-v8a}
# NDK=${2:-/home/martin/Android/Sdk/ndk/25.1.8937393}
echo "Using ABI: ${ABI}"
echo "Using NDK location: ${NDK}"
echo "Using architecture: ${ARCH} (compiler prefix: ${COMPILER_PREFIX})"

# Define NDK path and toolchain
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
export TARGET=$COMPILER_PREFIX
export API=29

# Setup Compiler Variables
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export AS=$CC
export NM=$TOOLCHAIN/bin/llvm-nm
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

# Setup Additional Flags
export SYSROOT="${TOOLCHAIN}/sysroot"
export PATH="${TOOLCHAIN}/bin:${SYSROOT}/usr/bin:${PATH}"
export C_INCLUDE_PATH="${SYSROOT}/usr/include:${C_INCLUDE_PATH}"
export LD_LIBRARY_PATH="${TOOLCHAIN}/lib:${SYSROOT}/usr/lib/${ARCH_SYSROOT}/$API:${SYSROOT}/usr/lib:${LD_LIBRARY_PATH}"
export CFLAGS="-I${SYSROOT}/usr/include --sysroot ${SYSROOT} -std=C99"
export CXXFLAGS="-I${SYSROOT}/usr/include --sysroot ${SYSROOT} -std=C99"
export CPPFLAGS=${CXXFLAGS}
export LDFLAGS="-L${SYSROOT}/usr/lib/${ARCH_SYSROOT}/$API -L${SYSROOT}/usr/lib --sysroot ${SYSROOT} -fPIC"

# /home/christian/Android/Sdk/ndk/27.0.12077973/toolchains/llvm/prebuilt/linux-x86_64/sysroot
cd ../netcdf-c/source
# echo "Using configure-command:"
# echo ""
# ./configure --host=x86_64-linux --build=${COMPILER_PREFIX} --prefix="${SYSROOT}/usr" --disable-dap --enable-netcdf-4 --with-sysroot="${SYSROOT}" --disable-byterange --enable-shared --disable-static --disable-logging --enable-dynamic-loading -with-pic
./configure --host=${TARGET} --prefix="${SYSROOT}/usr" --disable-dap --enable-netcdf-4 --with-sysroot="${SYSROOT}" --disable-byterange --enable-shared --disable-static --disable-logging --enable-dynamic-loading -with-pic
make && make install
make clean
cd ../../build_scripts
