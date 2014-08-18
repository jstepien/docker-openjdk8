FROM dockerfile/java
MAINTAINER Jan Stępień
RUN \
  apt-get update && \
  apt-get install -y \
    mercurial zip pkg-config ca-certificates-java libX11-dev libxext-dev \
    libxrender-dev libxtst-dev  libasound2-dev libcups2-dev libfreetype6-dev \
    libxt-dev
RUN \
  cd /tmp && \
  hg clone http://hg.openjdk.java.net/jdk8/jdk8 openjdk8 && \
  cd openjdk8 && \
  sh ./get_source.sh && \
  bash ./configure --with-cacerts-file=/etc/ssl/certs/java/cacerts && \
  make all && \
  cp -a build/linux-x86_64-normal-server-release/images/j2sdk-image \
    /opt/openjdk8 && \
  cd /tmp && \
  rm -rf openjdk8
