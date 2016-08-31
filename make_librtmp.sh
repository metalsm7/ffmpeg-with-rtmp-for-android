#!/bin/bash
NDK=/usr/local/ndk 
SYSROOT=$NDK/platforms/android-19/arch-arm/ 
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64 
OPENSSL_DIR=/usr/local/src/ffmpeg/openssl-android/
# Note: Change the above variables for your system.
function build_one
{
	set -e
    make clean
    ln -s ${SYSROOT}usr/lib/crtbegin_so.o
    ln -s ${SYSROOT}usr/lib/crtend_so.o
    export XLDFLAGS="$ADDI_LDFLAGS -L${OPENSSL_DIR}libs/armeabi -L${SYSROOT}usr/lib "
    export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-androideabi-
    export XCFLAGS="${ADDI_CFLAGS} -I${OPENSSL_DIR}include -isysroot ${SYSROOT}"
    export INC="-I${SYSROOT}"
    make prefix=\"${PREFIX}\" OPT= install
}
CPU=arm
PREFIX=$(pwd)/android/$CPU 
ADDI_CFLAGS="-marm"
build_one
