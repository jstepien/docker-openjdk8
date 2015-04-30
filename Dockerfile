FROM dockerfile/ubuntu
MAINTAINER Jan Stępień
RUN \
  apt-get update && \
  apt-get install -y \
    libxt-dev zip pkg-config libX11-dev libxext-dev \
    libxrender-dev libxtst-dev libasound2-dev libcups2-dev libfreetype6-dev && \
  rm -rf /var/lib/apt/lists/*
RUN \
  apt-get update && \
  apt-get install -y mercurial ca-certificates-java openjdk-7-jdk && \
  cd /tmp && \
  hg clone http://hg.openjdk.java.net/jdk8u/jdk8u openjdk8 && \
  cd openjdk8 && \
  hg checkout jdk8u45-b14 && \
  sh ./get_source.sh && \
  bash ./configure --with-cacerts-file=/etc/ssl/certs/java/cacerts && \
  make all && \
  cp -a build/linux-x86_64-normal-server-release/images/j2sdk-image \
    /opt/openjdk8 && \
  cd /tmp && \
  rm -rf openjdk8 && \
  apt-get purge -y --auto-remove mercurial ca-certificates-java openjdk-7-jdk default-jre && \
  rm -rf /var/lib/apt/lists/* && \
  find /opt/openjdk8 -type f -exec chmod a+r {} + && \
  find /opt/openjdk8 -type d -exec chmod a+rx {} +
ENV PATH /opt/openjdk8/bin:$PATH
ENV JAVA_HOME /opt/openjdk8
