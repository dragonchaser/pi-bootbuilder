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
    gcc-aarch64-linux-gnu

RUN mkdir -p /data/output
WORKDIR /data
RUN git clone https://github.com/u-boot/u-boot
RUN git clone https://github.com/raspberrypi/firmware
COPY entrypoint.sh /data/entrypoint.sh
RUN apt-get -y install \
    autopoint \
    python
ENTRYPOINT /data/entrypoint.sh
