FROM dockerfile/java:openjdk-7-jdk
MAINTAINER Jan Stępień
RUN \
  apt-get update && \
  apt-get install -y \
    libxt-dev zip pkg-config ca-certificates-java libX11-dev libxext-dev \
    libxrender-dev libxtst-dev libasound2-dev libcups2-dev libfreetype6-dev && \
  rm -rf /var/lib/apt/lists/*
RUN \
  apt-get update && \
  apt-get install -y mercurial && \
  cd /tmp && \
  hg clone http://hg.openjdk.java.net/jdk8u/jdk8u20 openjdk8 && \
  cd openjdk8 && \
  sh ./get_source.sh && \
  apt-get purge -y --auto-remove mercurial && \
  rm -rf /var/lib/apt/lists/* && \
  bash ./configure --with-cacerts-file=/etc/ssl/certs/java/cacerts && \
  make all && \
  cp -a build/linux-x86_64-normal-server-release/images/j2sdk-image \
    /opt/openjdk8 && \
  cd /tmp && \
  rm -rf openjdk8
ENV PATH /opt/openjdk8/bin:$PATH
