#***************************************************************************
#
# Filename:         Dockerfile
# Classification:   UNCLASSIFIED
# Description:      Docker file for Shim
#
# Copyright (C) 2021-2025 Viasat UK
#
# All rights reserved.
# The information in this software is subject to change without notice and
# should not be construed as a commitment by Viasat UK.
#
# Viasat Proprietary
# The Proprietary Information provided herein is proprietary to Viasat and
# must be protected from further distribution and use. Disclosure to others,
# use or copying without express written authorization of Viasat, is strictly
# prohibited.
#
#***************************************************************************
FROM ubuntu:noble-20250529

RUN sed -i 's/^Types: deb/& deb-src/' /etc/apt/sources.list.d/ubuntu.sources && \
    apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    devscripts=2.23.7 \
    git-buildpackage=0.9.33 \
    software-properties-common=0.99.49.2 \
    cmake=3.28.3-1build7 && \
    apt build-dep -y shim

WORKDIR /shim

COPY CMakeLists.txt data/viasatuk.der data/sbat.viasat.csv shimx64.efi check_nx_bit.sh ./

RUN cmake -B _redhat -D BUILD_VIASAT=OFF && \
    cmake --build _redhat

RUN cmake -B _viasat -D BUILD_VIASAT=ON && \
    cmake --build _viasat

RUN hexdump -Cv _redhat/INSTALL/shimx64.efi > redhat_shim.hex && \
    hexdump -Cv _viasat/INSTALL/shimx64.efi > viasat_shim.hex && \
    diff -u redhat_shim.hex viasat_shim.hex > diff_shim.hex | true

RUN sha256sum _viasat/INSTALL/shimx64.efi shimx64.efi

RUN chmod +x check_nx_bit.sh && ./check_nx_bit.sh shimx64.efi

RUN objcopy --only-section .sbat -O binary shimx64.efi /dev/stdout
