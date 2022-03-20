FROM debian:bullseye

MAINTAINER Sagnik Sasmal, <sagnik@sagnik.me>

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Install OS deps
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get -y install dirmngr curl software-properties-common locales git cmake \
    && apt-get -y install autoconf automake g++ libtool \
    && apt-get -y install ffmpeg libmp3lame-dev x264 \
    && apt-get -y install sqlite3 libsqlite3-dev \
    && useradd -m -d /home/container container

# Ensure UTF-8
RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen
    
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN wget https://nodejs.org/dist/v16.13.2/node-v16.13.2-linux-x64.tar.gz -O /tmp && \
    tar -C /usr/local/ --strip-components 1 -xzf /tmp/node-v16.13.2-linux-x64.tar.gz && \
    rm -f /tmp/node-v16.13.2-linux-x64.tar.gz

USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

ENV YARN_CACHE_FOLDER "/home/container/node_package_cache/"
ENV NPM_CONFIG_CACHE "/home/container/node_package_cache/"

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
