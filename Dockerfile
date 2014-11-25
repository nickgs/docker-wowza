FROM ubuntu:latest
MAINTAINER Manfred Touron m@42.am

ENV DEBIAN_FRONTEND noninteractive

# SYSTEM
RUN locale-gen en_US en_US.UTF-8
RUN apt-get update -y
RUN apt-get install -qq curl wget \
    python-software-properties wget \
    software-properties-common && \
    apt-get clean

# JAVA
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -qq oracle-java7-installer && \
    apt-get clean

# DOCKER ENTRIES
EXPOSE 8083 8086 1935
ENTRYPOINT ["/start"]

# WOWZA
RUN cd /tmp && \
    wget -q http://www.wowza.com/downloads/WowzaStreamingEngine-4-1-0/WowzaStreamingEngine-4.1.0.deb.bin && \
    chmod +x /tmp/WowzaStreamingEngine*.bin && \
    echo "yes" | /tmp/WowzaStreamingEngine*.bin && \
    rm -f /tmp/WowzaStreamingEngine*.bin && \
    touch /usr/local/WowzaMediaServer/conf/Server.license && \
    chmod 777 /usr/local/WowzaMediaServer/conf/Server.license
# cd /usr/local/WowzaMediaServer/bin
# ./startup.sh

ADD ./start /