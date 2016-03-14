FROM ubuntu:14.04
MAINTAINER Jan Stępień
RUN \
  apt-get update && \
  apt-get install -y \
    libxt6 libX11-6 libxext6 \
    libxrender1 libxtst6 libasound2 libcups2 libfreetype6 && \
  rm -rf /var/lib/apt/lists/*
RUN \
  apt-get update && \
  apt-get install -y \
    mercurial ca-certificates-java openjdk-7-jdk build-essential \
    libxt-dev pkg-config zip pkg-config libX11-dev libxext-dev \
    libxrender-dev libxtst-dev libasound2-dev libcups2-dev libfreetype6-dev && \
  cd /tmp && \
  hg clone http://hg.openjdk.java.net/jdk8u/jdk8u openjdk8 && \
  cd openjdk8 && \
  tag=jdk8u72-b15 && \
  hg checkout $tag && \
  sh ./get_source.sh && \
  for dir in ./*; do test -d $dir && (cd $dir && hg checkout $tag); done && \
  bash ./configure --with-cacerts-file=/etc/ssl/certs/java/cacerts \
                   --with-jobs=$(grep -c ^processor /proc/cpuinfo) && \
  make all && \
  mv build/linux-x86_64-normal-server-release/images/j2sdk-image \
    /opt/openjdk8 && \
  cd /tmp && \
  rm -rf openjdk8 && \
  apt-get purge -y --auto-remove \
    mercurial ca-certificates-java build-essential openjdk-7-jdk default-jre \
    libxt-dev pkg-config zip pkg-config libX11-dev libxext-dev gcc-4.8 gcc \
    libxrender-dev libxtst-dev libasound2-dev libcups2-dev libfreetype6-dev && \
  rm -rf /var/lib/apt/lists/* && \
  find /opt/openjdk8 -iname '*.diz' -exec rm {} + && \
  find /opt/openjdk8 -type f -exec chmod a+r {} + && \
  find /opt/openjdk8 -type d -exec chmod a+rx {} +
ENV PATH /opt/openjdk8/bin:$PATH
ENV JAVA_HOME /opt/openjdk8
RUN \
  cd /tmp && \
  echo > t.java '\
    public class t {\
      public static void main(String[] args) {\
        System.out.println(System.getProperty("java.vm.version"));\
      }\
    }' && \
  javac t.java && \
  java -Xmx5m t | grep -q ^25.71-b[0-9]*$ && \
  rm -f t.java t.class
