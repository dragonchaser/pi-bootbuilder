FROM ubuntu:latest
ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y full-upgrade \
    && apt-get -y install \
    tzdata \
    libssl-dev \ 
    build-essential \
    flex bison \
    git \
    wget \
    unzip \
    gcc-aarch64-linux-gnu

RUN mkdir -p /data/output
WORKDIR /data
RUN wget --quiet https://github.com/u-boot/u-boot/archive/refs/heads/master.zip
RUN unzip -q master.zip
RUN rm master.zip
RUN mv u-boot-master u-boot
RUN wget --quiet https://github.com/raspberrypi/firmware/archive/refs/heads/master.zip
RUN unzip -q master.zip
RUN mv firmware-master firmware
COPY entrypoint.sh /data/entrypoint.sh
RUN apt-get -y install \
    autopoint \
    python
ENTRYPOINT /data/entrypoint.sh
