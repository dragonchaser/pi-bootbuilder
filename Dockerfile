FROM ubuntu:latest
RUN apt-get update \
    && apt-get -y full-upgrade \
    && apt-get -y install \
    libssl-dev \ 
    build-essential \
    flex bison \
    git \
    gcc-aarch64-linux-gnu

RUN mkdir -p /data/output
WORKDIR /data
RUN git clone https://github.com/u-boot/u-boot
RUN git clone https://github.com/raspberrypi/firmware
COPY entrypoint.sh /data/entrypoint.sh
ENTRYPOINT /data/entrypoint.sh
