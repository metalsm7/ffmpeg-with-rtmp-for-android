# ffmpeg-with-rtmp-for-android

- **CentOS 7 에서의 작동을 보증합니다.(다른 OS에서는 추가적으로 수정이 필요한 부분이 있을 수 있습니다)**
- **이 안내는 librtmp 빌드를 위해 [guardianproject](https://github.com/guardianproject/openssl-android)라는 훌륭한 작업물을 기반으로 합니다.**

## Summary
+ 1. Setting Environment
+ 2. Download NDK
+ 3. Get openssl & Build
+ 4. Get librtmp & Build
+ 5. Get ffmpeg
+ 6. Build ffmpeg

### 1. Setting Environment
모든 소스 파일은 /usr/local/src 에 다운로드 받습니다.
쉬운 구분을 위해 /usr/local/src/ffmpeg 디렉토리를 만들도록 합니다.
<pre><code>$ cd /usr/local/src
$ mkdir ffmpeg
$ cd /usr/local/src/ffmpeg
</code></pre>

### 2. Download NDK
NDK를 다운로드 받습니다. [Download NDK](https://developer.android.com/ndk/downloads/index.html)<br />
후에 NDK의 쉬운 교체를 위해 link를 생성합니다.
<pre><code>$ wget https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip
$ unzip android-ndk-r12b-linux-x86_64.zip
$ mv android-ndk-r12b-linux-x86_64.zip /usr/local/ndk-r12b
$ ln –s /usr/local/ndk-r12b /usr/local/ndk 
</code></pre>

### 3. Get openssl & Build
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
$ /usr/local/ndk/ndk-build
</code></pre>

### 4. Get librtmp & Build
[rtmpdump](git://git.ffmpeg.org/rtmpdump)를 가져옵니다.
<pre><code>$ cd /usr/local/src/ffmpeg
$ git clone git://git.ffmpeg.org/rtmpdump
</code></pre>
make_librtmp.sh 파일을 가져온 후 실행 권한을 줍니다.
<pre><code>$ cd /usr/local/src/ffmpeg/rtmpdump/librtmp
$ wget https://raw.githubusercontent.com/metalsm7/ffmpeg-with-rtmp-for-android/master/make_librtmp.sh make_librtmp.sh
$ chmod +x make_librtmp.sh
</code></pre>
만약 사용자 환경에 맞춰 수정이 필요한 경우 make_librtmp.sh 파일의 일부를 현재 시스템 설정에 맞춰 변경해줍니다.
<pre><code>$ vi make_librtmp.sh
</code></pre>
! | Modify make_librtmp.sh
------------ | -------------
Check Point | NDK=<b>/usr/local/ndk</b> <br />SYSROOT=$NDK<b>/platforms/android-19/arch-arm/</b> <br />TOOLCHAIN=$NDK<b>/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64</b> <br />OPENSSL_DIR=<b>/usr/local/src/ffmpeg/openssl-android/</b>
Makefile 의 일부를 수정합니다.
+ 이는 linux 시스템에서 빌드 시 librtmp.so.1 가 아닌 librtmp-1.so 파일로 만들기 위함입니다.

<pre><code>$ vi Makefile
</code></pre>

ORIGINAL | MODIFY
------------ | -------------
SO_posix=.$(SOX).$(SO_VERSION) | SO_posix=-$(SO_VERSION).$(SOX)

이제 librtmp를 빌드하고 결과를 확인합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/rtmpdump/librtmp
$ ./make_librtmp.sh
</code></pre>

/usr/local/src/ffmpeg/rtmpdump/librtmp/android/arm/lib 디렉토리에 "librtmp-1.so", "librtmp.so" 파일이 있으면 성공입니다.

### 5. Get ffmpeg
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

make_ffmpeg.sh 파일을 가져온 후 실행 권한을 줍니다.
<pre><code>$ cd /usr/local/src/ffmpeg/ffmpeg-3.1.2
$ wget https://raw.githubusercontent.com/metalsm7/ffmpeg-with-rtmp-for-android/master/make_ffmpeg.sh make_ffmpeg.sh
$ chmod +x make_ffmpeg.sh
</code></pre>
만약 사용자 환경에 맞춰 수정이 필요한 경우 make_ffmpeg.sh 파일 일부를 현재 시스템에 맞게 수정합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/ffmpeg-3.1.2
$ vi make_ffmpeg.sh</code></pre>

! | Modify make_ffmpeg.sh
------------ | -------------
Check Point | NDK=<b>/usr/local/ndk</b> <br />SYSROOT=$NDK<b>/platforms/android-19/arch-arm/</b> <br />TOOLCHAIN=$NDK<b>/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64</b> <br /><br />OPENSSL_DIR=<b>/usr/local/src/ffmpeg/openssl-android/</b> <br />LIBRTMP_DIR=<b>/usr/local/src/ffmpeg/rtmpdump/librtmp/</b>

### 6.Build ffmpeg
마지막으로 ffmpeg를 빌드합니다.
<pre><code>$ cd /usr/local/src/ffmpeg/ffmpeg-3.1.2
$ ./make_ffmpeg.sh
</code></pre>

/usr/local/src/ffmpeg/ffmpeg-3.1.2/android/arm/lib 디렉토리에 so 파일들이 만들어져 있으면 성공입니다.

이제 이 파일들을 복사해서 android에서 사용해 봅시다!
