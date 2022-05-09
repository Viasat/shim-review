#***************************************************************************
#
# Filename: Dockerfile
# Classification: UNCLASSIFIED
# Description: Docker file for Shim
#
# Copyright (C) 2021 Viasat, UK Limited.
# All rights reserved.
# The information in this software is subject to change without notice and
# should not be construed as a commitment by Viasat, UK Limited.
#
# Viasat Proprietary
# The Proprietary Information provided herein is proprietary to Viasat and
# must be protected from further distribution and use. Disclosure to others,
# use or copying without express written authorization of Viasat, is strictly
# prohibited.
#
#***************************************************************************
FROM debian:stable-slim
ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt update -y \
    && \
    apt install -y \
    bsdmainutils \
    dos2unix \
    gcc \
    g++ \
    git \
    make \
    pesign \
    wget \
    && \
    rm -rf /var/lib/apt/lists/*

# cmake >= 3.14
ENV CMAKE_VERSION 3.20
ENV CMAKE_BUILD 5
ENV CMAKE_SCRIPT cmake-$CMAKE_VERSION.$CMAKE_BUILD-linux-x86_64.sh

WORKDIR /root/cmake
RUN wget -q https://cmake.org/files/v$CMAKE_VERSION/$CMAKE_SCRIPT \
    && \
    mkdir /opt/cmake \
    && \
    sh $CMAKE_SCRIPT --prefix=/opt/cmake --skip-license \
    && \
    ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
    && \
    cmake --version

WORKDIR /root/shim
COPY CMakeLists.txt data/viasatuk.der data/sbat.viasat.csv data/BOOTX64.EFI ./

RUN cmake -B _redhat -D BUILD_VIASAT=OFF && \
    cmake --build _redhat

RUN cmake -B _viasat -D BUILD_VIASAT=ON && \
    cmake --build _viasat

RUN hexdump -Cv _redhat/INSTALL/shimx64.efi > redhat_shim.hex && \
    hexdump -Cv _viasat/INSTALL/shimx64.efi > viasat_shim.hex && \
    diff -u redhat_shim.hex viasat_shim.hex > diff_shim.hex | true

RUN sha256sum _viasat/INSTALL/shimx64.efi BOOTX64.EFI