# ffmpeg-with-rtmp-for-android

CentOS 7 에서의 작동을 보증합니다.
이 안내는 [FFmpeg-Android](https://github.com/OnlyInAmerica/FFmpeg-Android)와 [guardianproject](https://github.com/guardianproject/openssl-android)하는 훌륭한 작업물을 기반으로 합니다.

## Summary
+ 1. Setting Environment
+ 2. Download NDK
+ 3. Clone FFmpeg-Android
+ 4. Clone openssl
+ 5. Download ffmpeg source

### 1. Setting Environment
#### 모든 소스 파일은 /usr/local/src 에 다운로드 받습니다.
#### 쉬운 구분을 위해 /usr/local/src/ffmpeg 디렉토리를 만들도록 합니다.
#### <pre><code>cd /usr/local/src
mkdir ffmpeg
cd /usr/local/src/ffmpeg
</code></pre>

### 2. Download NDK
NDK를 다운로드 받습니다. [Download NDK](https://developer.android.com/ndk/downloads/index.html)
후에 NDK의 쉬운 교체를 위해 link를 생성합니다.
<pre><code>wget https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip
unzip android-ndk-r12b-linux-x86_64.zip
mv android-ndk-r12b-linux-x86_64.zip /usr/local/ndk-r12b
ln –s /usr/local/ndk-r12b /usr/local/ndk 
</code></pre>

### 3. Clone FFmpeg-Android
[FFmpeg-Android](https://github.com/OnlyInAmerica/FFmpeg-Android)를 가져옵니다.
<pre><code>cd /usr/local/src/ffmpeg
git clone https://github.com/OnlyInAmerica/FFmpeg-Android
</code></pre>

### 4. Clone openssl
[guardianproject](https://github.com/guardianproject/openssl-android)를 가져옵니다.
<pre><code>cd /usr/local/src/ffmpeg
git clone https://github.com/guardianproject/openssl-android
</code></pre>

### 5. Download ffmpeg source

<pre><code></code></pre>
<pre><code></code></pre>
<pre><code></code></pre>
