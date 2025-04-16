#***************************************************************************
#
# Filename: Dockerfile
# Classification: UNCLASSIFIED
# Description: Docker file for Shim
#
# Copyright (C) 2021-2025 Viasat, UK Limited.
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
FROM debian:stable-20250407-slim
ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt update -y \
    && \
    apt install -y \
    bsdmainutils=12.1.8 \
    cmake=3.25.1-1 \
    dos2unix=7.4.3-1 \
    gcc=4:12.2.0-3 \
    g++=4:12.2.0-3 \
    git=1:2.39.5-0+deb12u2 \
    make=4.3-4.1 \
    pesign=0.112-6 \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/shim
COPY CMakeLists.txt data/viasatuk.der data/sbat.viasat.csv data/shimx64.efi ./

RUN cmake -B _redhat -D BUILD_VIASAT=OFF && \
    cmake --build _redhat

RUN cmake -B _viasat -D BUILD_VIASAT=ON && \
    cmake --build _viasat

RUN hexdump -Cv _redhat/INSTALL/shimx64.efi > redhat_shim.hex && \
    hexdump -Cv _viasat/INSTALL/shimx64.efi > viasat_shim.hex && \
    diff -u redhat_shim.hex viasat_shim.hex > diff_shim.hex | true

RUN sha256sum _viasat/INSTALL/shimx64.efi shimx64.efi

COPY check_nx_bit.sh ./
RUN ./check_nx_bit.sh _viasat/INSTALL/shimx64.efi