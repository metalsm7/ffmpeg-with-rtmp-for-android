# ffmpeg-with-rtmp-for-android

- **CentOS 7 에서의 작동을 보증합니다.**
- **이 안내는 [FFmpeg-Android](https://github.com/OnlyInAmerica/FFmpeg-Android)와 [guardianproject](https://github.com/guardianproject/openssl-android)라는 훌륭한 작업물을 기반으로 합니다.**

## Summary
+ 1. Setting Environment
+ 2. Download NDK
+ 3. Clone FFmpeg-Android
+ 4. Clone openssl
+ 5. Clone librtmp
+ 6. Download ffmpeg source

### 1. Setting Environment
모든 소스 파일은 /usr/local/src 에 다운로드 받습니다.
쉬운 구분을 위해 /usr/local/src/ffmpeg 디렉토리를 만들도록 합니다.
<pre><code>$ cd /usr/local/src
$ mkdir ffmpeg
$ cd /usr/local/src/ffmpeg
</code></pre>

### 2. Download NDK
NDK를 다운로드 받습니다. [Download NDK](https://developer.android.com/ndk/downloads/index.html)
후에 NDK의 쉬운 교체를 위해 link를 생성합니다.
<pre><code>$ wget https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip
$ unzip android-ndk-r12b-linux-x86_64.zip
$ mv android-ndk-r12b-linux-x86_64.zip /usr/local/ndk-r12b
$ ln –s /usr/local/ndk-r12b /usr/local/ndk 
</code></pre>

### 3. Clone FFmpeg-Android
[FFmpeg-Android](https://github.com/OnlyInAmerica/FFmpeg-Android)를 가져옵니다.
<pre><code>$ cd /usr/local/src/ffmpeg
$ git clone https://github.com/OnlyInAmerica/FFmpeg-Android
</code></pre>

### 4. Clone openssl
[guardianproject](https://github.com/guardianproject/openssl-android)를 가져옵니다.
<pre><code>$ cd /usr/local/src/ffmpeg
$ git clone https://github.com/guardianproject/openssl-android
</code></pre>
이제 현재 시스템에 맞게 파일 수정을 합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/openssl-android
$ vi jni/Application.mk
</code></pre>
ORIGINAL | MODIFY
------------ | -------------
<b>NDK_TOOLCHAIN_VERSION=4.4.3</b> <br />APP_PROJECT_PATH := $(shell pwd) <br />APP_BUILD_SCRIPT := $(APP_PROJECT_PATH)/Android.mk | <b>NDK_TOOLCHAIN_VERSION=4.9</b> <br /><b>APP_ABI := all32</b><br />APP_PROJECT_PATH := $(shell pwd) <br />APP_BUILD_SCRIPT := $(APP_PROJECT_PATH)/Android.mk
NDK빌드 합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/openssl-android
$ /usr/local/ndk/bdk-build
</code></pre>

### 5. Clone librtmp
[rtmpdump](git://git.ffmpeg.org/rtmpdump)를 가져옵니다.
<pre><code>$ cd /usr/local/src/ffmpeg
$ git clone git://git.ffmpeg.org/rtmpdump
</code></pre>
[FFmpeg-Android]의 build_librtmp_for_android.sh 파일을 복사한 후 실행 권한을 줍니다.
<pre><code>$ cd /usr/local/src/ffmpeg/rtmpdump/librtmp
$ cp /usr/local/src/ffmpeg/FFmpeg-Android/build_librtmp_for_android.sh ./
$ chmod +x build_librtmp_for_android.sh
</code></pre>
build_librtmp_for_android.sh 파일의 일부를 현재 시스템 설정에 맞춰 변경해줍니다.
<pre><code>$ vi build_librtmp_for_android.sh
</code></pre>
ORIGINAL | MODIFY
------------ | -------------
NDK=/Applications/android-ndk-r9c <br />SYSROOT=$NDK/platforms/android-19/arch-arm/ <br />TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64 <br />OPENSSL_DIR=/Users/davidbrodsky/Code/android/openssl-android/ | NDK=/usr/local/ndk <br />SYSROOT=$NDK/platforms/android-19/arch-arm/ <br />TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64 <br />OPENSSL_DIR=/usr/local/src/ffmpeg/openssl-android/
Makefile 의 일부를 수정합니다.
+ 이는 linux 시스템에서 빌드 시 librtmp.so.1 가 아닌 librtmp-1.so 파일로 만들기 위함입니다.

<pre><code>$ vi Makefile
</code></pre>

ORIGINAL | MODIFY
------------ | -------------
SO_posix=.$(SOX).$(SO_VERSION) | SO_posix=-$(SO_VERSION).$(SOX)

이제 librtmp를 빌드하고 결과를 확인합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/rtmpdump/librtmp
$ ./build_librtmp_for_android.sh
</code></pre>

/usr/local/src/ffmpeg/rtmpdump/librtmp/android/arm/lib 디렉토리에 "librtmp-1.so", "librtmp.so" 파일이 있으면 성공입니다.

### 6. Download ffmpeg source
[ffmpeg](http://www.ffmpeg.org/download.html) 소스를 다운로드 합니다.
<pre><code>$ cd /usr/local/src
$ wget http://ffmpeg.org/releases/ffmpeg-3.1.2.tar.bz2
$ tar xvf ffmpeg-3.1.2.tar.bz2
$ mv /usr/local/src/ffmpeg-3.1.2 /usr/local/src/ffmpeg/
</code></pre>
ffmpeg의 configure 파일 일부를 수정합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/ffmpeg-3.1.2
$ vi configure
</code></pre>
ORIGINAL | MODIFY
------------ | -------------
SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)' <br />LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"' <br />SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)' <br />SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)' | SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)' <br />LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"' <br />SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)' <br />SLIB_INSTALL_LINKS='$(SLIBNAME)'

ORIGINAL | MODIFY
------------ | -------------
enabled librtmp    && require_pkg_config librtmp librtmp/rtmp.h RTMP_Socket | enabled librtmp    && require librtmp librtmp/rtmp.h RTMP_Socket -L/usr/local/src/ffmpeg/rtmpdump/librtmp/android/arm/lib -lrtmp

[FFmpeg-Android]의 build_ffmpeg_with_librtmp_for_android.sh  파일을 복사한 후 실행 권한을 줍니다.
<pre><code>$ cd /usr/local/src/ffmpeg/ffmpeg-3.1.2
$ cp /usr/local/src/ffmpeg/FFmpeg-Android/build_ffmpeg_with_librtmp_for_android.sh ./
$ chmod +x build_ffmpeg_with_librtmp_for_android.sh
</code></pre>
build_ffmpeg_with_librtmp_for_android.sh 파일 일부를 현재 시스템에 맞게 수정합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/ffmpeg-3.1.2
$ vi build_ffmpeg_with_librtmp_for_android.sh</code></pre>

ORIGINAL | MODIFY
------------ | -------------
NDK=/Applications/android-ndk-r9c <br />SYSROOT=$NDK/platforms/android-19/arch-arm/ <br />TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64 <br /><br />OPENSSL_DIR=/Users/davidbrodsky/Code/android/openssl-android/ <br />LIBRTMP_DIR=/Users/davidbrodsky/Code/c/rtmpdump/librtmp/ | NDK=/usr/local/ndk <br />SYSROOT=$NDK/platforms/android-19/arch-arm/ <br />TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64 <br /><br />OPENSSL_DIR=/usr/local/src/ffmpeg/openssl-android/ <br />LIBRTMP_DIR=/usr/local/src/ffmpeg/rtmpdump/librtmp/

마지막으로 ffmpeg를 빌드합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/ffmpeg-3.1.2
$ ./build_ffmpeg_with_librtmp_for_android.sh
</code></pre>

/usr/local/src/ffmpeg/ffmpeg-3.1.2/android/arm/lib 디렉토리에 so 파일들이 만들어져 있으면 성공입니다.

이제 이 파일들을 복사해서 android에서 사용해 봅시다!
